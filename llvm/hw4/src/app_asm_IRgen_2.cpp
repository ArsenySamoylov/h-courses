#include "../app/sim.h"

#include "llvm/ExecutionEngine/ExecutionEngine.h"
#include "llvm/ExecutionEngine/GenericValue.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Support/raw_ostream.h"
#include <fstream>
#include <iostream>
#include <unordered_map>
using namespace llvm;

#define BLUE 0xFF0000FF
#define WHITE 0xFFFFFFFF

const int REG_FILE_SIZE = 8;

int main(int argc, char *argv[]) {
  if (argc != 2) {
    outs() << "[ERROR] Need 1 argument: file with assembler code\n";
    return 1;
  }
  std::ifstream input;
  input.open(argv[1]);
  if (!input.is_open()) {
    outs() << "[ERROR] Can't open " << argv[1] << '\n';
    return 1;
  }

  LLVMContext context;
  Module *module = new Module("top", context);
  IRBuilder<> builder(context);
  Type *voidType = Type::getVoidTy(context);
  Type *int32Type = Type::getInt32Ty(context);

  // [8 x i32] regFile = {0, 0, 0, 0, 0, 0, 0, 0}
  ArrayType *regFileType = ArrayType::get(int32Type, REG_FILE_SIZE);
  GlobalVariable *regFile = new GlobalVariable(
      *module, regFileType, false, GlobalValue::PrivateLinkage, 0, "regFile");
  regFile->setInitializer(ConstantAggregateZero::get(regFileType));

  // declare void @main()
  FunctionType *funcType = FunctionType::get(voidType, false);
  Function *mainFunc =
      Function::Create(funcType, Function::ExternalLinkage, "main", module);

  std::string name;
  std::string arg;
  std::unordered_map<std::string, BasicBlock *> BBMap;

  outs() << "\n#[FILE]:\nBBs:";

  while (input >> name) {
    if (!name.compare("XOR") || !name.compare("MUL") || !name.compare("ADD") ||
        !name.compare("PUT_CELL") || !name.compare("CMP")) {
      input >> arg >> arg >> arg;
      continue;
    }
    if (!name.compare("BR_COND")) {
      input >> arg >> arg >> arg;
      continue;
    }
    if (!name.compare("RAND_COLOR") || !name.compare("B")) {
      input >> arg;
      continue;
    }
    if (!name.compare("FLUSH")) {
      continue;
    }

    outs() << " " << name;
    BBMap[name] = BasicBlock::Create(context, name, mainFunc);
  }
  outs() << '\n';
  input.close();
  input.open(argv[1]);

  // Declare external simulation functions
  ArrayRef<Type *> simPutPixelParamTypes = {int32Type, int32Type, int32Type};
  FunctionType *simPutPixelType =
      FunctionType::get(voidType, simPutPixelParamTypes, false);
  FunctionCallee simPutPixelFunc =
      module->getOrInsertFunction("simPutPixel", simPutPixelType);

  FunctionType *simFlushType = FunctionType::get(voidType, false);
  FunctionCallee simFlushFunc =
      module->getOrInsertFunction("simFlush", simFlushType);

  FunctionType *simRandType = FunctionType::get(int32Type, false);
  FunctionCallee simRandFunc =
      module->getOrInsertFunction("simRand", simRandType);

  BasicBlock *entryBB = BasicBlock::Create(context, "entry", mainFunc);
  builder.SetInsertPoint(entryBB);
  
  std::string firstBB;
  input >> firstBB;
  input.close();
  input.open(argv[1]);
  
  while (input >> name) {
    if (name.compare("XOR") && name.compare("MUL") && name.compare("ADD") && 
        name.compare("PUT_CELL") && name.compare("CMP") && 
        name.compare("BR_COND") && name.compare("RAND_COLOR") && 
        name.compare("B") && name.compare("FLUSH") && name.compare("EXIT")) {
      firstBB = name;
      break;
    }
  }
  input.close();
  input.open(argv[1]);
  
  builder.CreateBr(BBMap[firstBB]);
  outs() << "BB entry\n";

  while (input >> name) {
    if (!name.compare("EXIT")) {
      outs() << "\tEXIT\n";
      builder.CreateRetVoid();
      if (input >> name) {
        outs() << "BB " << name << '\n';
        builder.SetInsertPoint(BBMap[name]);
      }
      continue;
    }
    
    if (!name.compare("PUT_CELL")) {
      input >> arg;
      outs() << "\tPUT_CELL " << arg;
      Value *x_ptr = builder.CreateConstGEP2_32(regFileType, regFile, 0, std::stoi(arg.substr(1)));
      Value *x_val = builder.CreateLoad(int32Type, x_ptr);
      
      input >> arg;
      outs() << " " << arg;
      Value *y_ptr = builder.CreateConstGEP2_32(regFileType, regFile, 0, std::stoi(arg.substr(1)));
      Value *y_val = builder.CreateLoad(int32Type, y_ptr);
      
      input >> arg;
      outs() << " " << arg << '\n';
      Value *color_ptr = builder.CreateConstGEP2_32(regFileType, regFile, 0, std::stoi(arg.substr(1)));
      Value *color_val = builder.CreateLoad(int32Type, color_ptr);
      
      // Generate 4 simPutPixel calls
      Value *args[] = {x_val, y_val, color_val};
      builder.CreateCall(simPutPixelFunc, args);
      
      Value *y_plus1 = builder.CreateAdd(y_val, builder.getInt32(1));
      Value *args1[] = {x_val, y_plus1, color_val};
      builder.CreateCall(simPutPixelFunc, args1);
      
      Value *y_plus2 = builder.CreateAdd(y_val, builder.getInt32(2));
      Value *args2[] = {x_val, y_plus2, color_val};
      builder.CreateCall(simPutPixelFunc, args2);
      
      Value *y_plus3 = builder.CreateAdd(y_val, builder.getInt32(3));
      Value *args3[] = {x_val, y_plus3, color_val};
      builder.CreateCall(simPutPixelFunc, args3);
      
      continue;
    }
    
    if (!name.compare("FLUSH")) {
      outs() << "\tFLUSH\n";
      builder.CreateCall(simFlushFunc);
      continue;
    }
    
    if (!name.compare("XOR")) {
      input >> arg;
      outs() << "\t" << arg;
      Value *res_ptr = builder.CreateConstGEP2_32(regFileType, regFile, 0, std::stoi(arg.substr(1)));
      
      input >> arg;
      outs() << " = " << arg;
      Value *arg1_ptr = builder.CreateConstGEP2_32(regFileType, regFile, 0, std::stoi(arg.substr(1)));
      Value *arg1_val = builder.CreateLoad(int32Type, arg1_ptr);
      
      input >> arg;
      outs() << " ^ " << arg << '\n';
      Value *arg2_ptr = builder.CreateConstGEP2_32(regFileType, regFile, 0, std::stoi(arg.substr(1)));
      Value *arg2_val = builder.CreateLoad(int32Type, arg2_ptr);
      
      Value *xor_result = builder.CreateXor(arg1_val, arg2_val);
      builder.CreateStore(xor_result, res_ptr);
      continue;
    }
    
    if (!name.compare("MUL")) {
      input >> arg;
      outs() << "\t" << arg;
      Value *res_ptr = builder.CreateConstGEP2_32(regFileType, regFile, 0, std::stoi(arg.substr(1)));
      
      input >> arg;
      outs() << " = " << arg;
      Value *arg1_ptr = builder.CreateConstGEP2_32(regFileType, regFile, 0, std::stoi(arg.substr(1)));
      Value *arg1_val = builder.CreateLoad(int32Type, arg1_ptr);
      
      input >> arg;
      outs() << " * " << arg << '\n';
      Value *arg2_val = builder.getInt32(std::stoi(arg));
      
      Value *mul_result = builder.CreateMul(arg1_val, arg2_val);
      builder.CreateStore(mul_result, res_ptr);
      continue;
    }
    
    if (!name.compare("CMP")) {
      input >> arg;
      outs() << "\t" << arg;
      Value *res_ptr = builder.CreateConstGEP2_32(regFileType, regFile, 0, std::stoi(arg.substr(1)));
      
      input >> arg;
      outs() << " = " << arg;
      Value *arg1_ptr = builder.CreateConstGEP2_32(regFileType, regFile, 0, std::stoi(arg.substr(1)));
      Value *arg1_val = builder.CreateLoad(int32Type, arg1_ptr);
      
      input >> arg;
      outs() << " == " << arg << '\n';
      Value *arg2_val = builder.getInt32(std::stoi(arg));
      
      Value *cmp_result = builder.CreateICmpEQ(arg1_val, arg2_val);
      Value *cmp_result_i32 = builder.CreateZExt(cmp_result, int32Type);
      builder.CreateStore(cmp_result_i32, res_ptr);
      continue;
    }
    
    if (!name.compare("ADD")) {
      input >> arg;
      outs() << "\t" << arg;
      Value *res_ptr = builder.CreateConstGEP2_32(regFileType, regFile, 0, std::stoi(arg.substr(1)));
      
      input >> arg;
      outs() << " = " << arg << " + ";
      Value *arg1_ptr = builder.CreateConstGEP2_32(regFileType, regFile, 0, std::stoi(arg.substr(1)));
      Value *arg1_val = builder.CreateLoad(int32Type, arg1_ptr);
      
      input >> arg;
      outs() << arg << '\n';
      Value *arg2_val = builder.getInt32(std::stoi(arg));
      
      Value *add_result = builder.CreateAdd(arg1_val, arg2_val);
      builder.CreateStore(add_result, res_ptr);
      continue;
    }
    
    if (!name.compare("BR_COND")) {
      input >> arg;
      outs() << "\tif (" << arg;
      Value *cond_ptr = builder.CreateConstGEP2_32(regFileType, regFile, 0, std::stoi(arg.substr(1)));
      Value *cond_val = builder.CreateLoad(int32Type, cond_ptr);
      Value *cond_bool = builder.CreateTrunc(cond_val, builder.getInt1Ty());
      
      input >> arg;
      outs() << ") then BB:" << arg;
      input >> name;
      outs() << " else BB:" << name << '\n';
      
      builder.CreateCondBr(cond_bool, BBMap[arg], BBMap[name]);
      builder.SetInsertPoint(BBMap[name]);
      outs() << "BB " << name << '\n';
      continue;
    }
    
    if (!name.compare("B")) {
      input >> name;
      outs() << "\tgo to " << name << "\n";
      builder.CreateBr(BBMap[name]);
      continue;
    }
    
    if (!name.compare("RAND_COLOR")) {
      input >> arg;
      outs() << "\t" << arg << " = rand_color()\n";
      Value *res_ptr = builder.CreateConstGEP2_32(regFileType, regFile, 0, std::stoi(arg.substr(1)));
      
      Value *rand_val = builder.CreateCall(simRandFunc);
      Value *mod_result = builder.CreateURem(rand_val, builder.getInt32(2));
      Value *is_nonzero = builder.CreateICmpNE(mod_result, builder.getInt32(0));
      Value *color_val = builder.CreateSelect(is_nonzero, 
                                            builder.getInt32(WHITE), 
                                            builder.getInt32(BLUE));
      builder.CreateStore(color_val, res_ptr);
      continue;
    }

    if (builder.GetInsertBlock() && builder.GetInsertBlock()->getTerminator() == nullptr) {
      builder.CreateBr(BBMap[name]);
      outs() << "\tbranch to " << name << '\n';
    }
    outs() << "BB " << name << '\n';
    builder.SetInsertPoint(BBMap[name]);
  }

  outs() << "\n#[LLVM IR]:\n";
  module->print(outs(), nullptr);
  outs() << '\n';
  bool verif = verifyFunction(*mainFunc, &outs());
  outs() << "[VERIFICATION] " << (verif ? "FAIL\n\n" : "OK\n\n");

  outs() << "\n#[Running code]\n";
  InitializeNativeTarget();
  InitializeNativeTargetAsmPrinter();

  ExecutionEngine *ee = EngineBuilder(std::unique_ptr<Module>(module)).create();
  ee->InstallLazyFunctionCreator([](const std::string &fnName) -> void * {
    if (fnName == "simFlush") {
      return reinterpret_cast<void *>(simFlush);
    }
    if (fnName == "simPutPixel") {
      return reinterpret_cast<void *>(simPutPixel);
    }
    if (fnName == "simRand") {
      return reinterpret_cast<void *>(simRand);
    }
    return nullptr;
  });

  ee->finalizeObject();

  simInit();

  ArrayRef<GenericValue> noargs;
  ee->runFunction(mainFunc, noargs);
  outs() << "#[Code was run]\n";

  simExit();
  return EXIT_SUCCESS;
}