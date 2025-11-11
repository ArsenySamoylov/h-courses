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

//    XOR x1 x1 x1
//    MUL x3 x2 imm
//    B label
//    CMP x6 x6 imm
//    ADD x4 x5 512
//    BR_COND x4 label_13
//    FLUSH
//    EXIT

#define BLUE 0xFF0000FF
#define WHITE 0xFFFFFFFF

const int REG_FILE_SIZE = 8;
uint32_t REG_FILE[REG_FILE_SIZE];

void do_XOR(int arg1, int arg2, int arg3) {
  REG_FILE[arg1] = REG_FILE[arg2] ^ REG_FILE[arg3];
}

void do_MUL(int arg1, int arg2, int arg3) {
  REG_FILE[arg1] = REG_FILE[arg2] * arg3;
}

void do_CMP(int arg1, int arg2, int arg3) {
  REG_FILE[arg1] = REG_FILE[arg2] == arg3;
}

void do_ADD(int arg1, int arg2, int arg3) {
  REG_FILE[arg1] = REG_FILE[arg2] + arg3;
}

void do_PUT_CELL(int arg1, int arg2, int arg3) {
  simPutPixel(REG_FILE[arg1], REG_FILE[arg2],   REG_FILE[arg3]);
  simPutPixel(REG_FILE[arg1], REG_FILE[arg2]+1, REG_FILE[arg3]);
  simPutPixel(REG_FILE[arg1], REG_FILE[arg2]+2, REG_FILE[arg3]);
  simPutPixel(REG_FILE[arg1], REG_FILE[arg2]+3, REG_FILE[arg3]);
}

void do_RAND_COLOR(int arg1) {
  REG_FILE[arg1] = simRand() % 2 ? WHITE : BLUE;
}

void do_FLUSH() { simFlush(); }

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
  // ; ModuleID = 'top'
  // source_filename = "top"
  Module *module = new Module("top", context);
  IRBuilder<> builder(context);

  //[32 x i32] regFile = {0, 0, 0, 0}
  ArrayType *regFileType = ArrayType::get(builder.getInt32Ty(), REG_FILE_SIZE);
  module->getOrInsertGlobal("regFile", regFileType);
  GlobalVariable *regFile = module->getNamedGlobal("regFile");

  // declare void @main()
  FunctionType *funcType = FunctionType::get(builder.getVoidTy(), false);
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

  // Functions types
  Type *voidType = Type::getVoidTy(context);
  FunctionType *voidFuncType = FunctionType::get(voidType, false);
  FunctionType *int32FuncType = FunctionType::get(Type::getInt32Ty(context), false);

  ArrayRef<Type *> int32x3Types = {Type::getInt32Ty(context),
                                   Type::getInt32Ty(context),
                                   Type::getInt32Ty(context)};
  FunctionType *int32x3FuncType =
      FunctionType::get(voidType, int32x3Types, false);
  
  // Functions
  FunctionCallee do_XORFunc =
      module->getOrInsertFunction("do_XOR", int32x3FuncType);

  FunctionCallee do_MULFunc =
      module->getOrInsertFunction("do_MUL", int32x3FuncType);

  FunctionCallee do_CMPFunc =
      module->getOrInsertFunction("do_CMP", int32x3FuncType);

  FunctionCallee do_PUT_CELLFunc =
      module->getOrInsertFunction("do_PUT_CELL", int32x3FuncType);

  FunctionCallee do_ADDFunc =
      module->getOrInsertFunction("do_ADD", int32x3FuncType);

  FunctionCallee do_FLUSHFunc =
      module->getOrInsertFunction("do_FLUSH", voidFuncType);

  FunctionCallee do_RAND_COLORFunc =
      module->getOrInsertFunction("do_RAND_COLOR", int32FuncType);

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
      Value *arg1 = builder.getInt32(std::stoi(arg.substr(1)));
      input >> arg;
      outs() << " " << arg;
      Value *arg2 = builder.getInt32(std::stoi(arg.substr(1)));
      input >> arg;
      outs() << " " << arg << '\n';
      Value *arg3 = builder.getInt32(std::stoi(arg.substr(1)));
      Value *args[] = {arg1, arg2, arg3};
      builder.CreateCall(do_PUT_CELLFunc, args);
      continue;
    }
    if (!name.compare("FLUSH")) {
      outs() << "\tFLUSH\n";
      builder.CreateCall(do_FLUSHFunc);
      continue;
    }
    if (!name.compare("XOR")) {
      input >> arg;
      outs() << "\t" << arg;
      // res
      Value *arg1 = builder.getInt32(std::stoi(arg.substr(1)));
      input >> arg;
      outs() << " = " << arg;
      // arg1
      Value *arg2 = builder.getInt32(std::stoi(arg.substr(1)));
      input >> arg;
      outs() << " ^ " << arg << '\n';
      // arg2
      Value *arg3 = builder.getInt32(std::stoi(arg.substr(1)));
      Value *args[] = {arg1, arg2, arg3};
      builder.CreateCall(do_XORFunc, args);
      continue;
    }
    if (!name.compare("MUL")) {
      input >> arg;
      outs() << "\t" << arg;
      // res
      Value *arg1 = builder.getInt32(std::stoi(arg.substr(1)));
      input >> arg;
      outs() << " = " << arg;
      // arg1
      Value *arg2 = builder.getInt32(std::stoi(arg.substr(1)));
      input >> arg;
      outs() << " * " << arg << '\n';
      // arg2
      Value *arg3 = builder.getInt32(std::stoi(arg));
      Value *args[] = {arg1, arg2, arg3};
      builder.CreateCall(do_MULFunc, args);
      continue;
    }
    if (!name.compare("CMP")) {
      input >> arg;
      outs() << "\t" << arg;
      // res
      Value *arg1 = builder.getInt32(std::stoi(arg.substr(1)));
      input >> arg;
      outs() << " = " << arg;
      // arg1
      Value *arg2 = builder.getInt32(std::stoi(arg.substr(1)));
      input >> arg;
      outs() << " == " << arg << '\n';
      // arg2
      Value *arg3 = builder.getInt32(std::stoi(arg));
      Value *args[] = {arg1, arg2, arg3};
      builder.CreateCall(do_CMPFunc, args);
      continue;
    }

    if (!name.compare("ADD")) {
      input >> arg;
      outs() << "\t" << arg;
      // res
      Value *arg1 = builder.getInt32(std::stoi(arg.substr(1)));
      input >> arg;
      outs() << " = " << arg << " + ";
      // arg1
      Value *arg2 = builder.getInt32(std::stoi(arg.substr(1)));
      input >> arg;
      outs() << arg << '\n';
      // arg2
      Value *arg3 = builder.getInt32(std::stoi(arg));
      Value *args[] = {arg1, arg2, arg3};
      builder.CreateCall(do_ADDFunc, args);
      continue;
    }
    if (!name.compare("BR_COND")) {
      input >> arg;
      outs() << "\tif (" << arg;
      // reg1
      Value *reg_p = builder.CreateConstGEP2_32(regFileType, regFile, 0,
                                                std::stoi(arg.substr(1)));
      Value *reg_i1 = builder.CreateTrunc(
          builder.CreateLoad(builder.getInt32Ty(), reg_p), builder.getInt1Ty());
      input >> arg;
      outs() << ") then BB:" << arg;
      input >> name;
      outs() << " else BB:" << name << '\n';
      builder.CreateCondBr(reg_i1, BBMap[arg], BBMap[name]);
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
      Value *arg1 = builder.getInt32(std::stoi(arg.substr(1)));
      builder.CreateCall(do_RAND_COLORFunc, arg1);
      continue;
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
    if (fnName == "do_XOR") {
      return reinterpret_cast<void *>(do_XOR);
    }
    if (fnName == "do_MUL") {
      return reinterpret_cast<void *>(do_MUL);
    }
    if (fnName == "do_CMP") {
      return reinterpret_cast<void *>(do_CMP);
    }
    if (fnName == "do_PUT_CELL") {
      return reinterpret_cast<void *>(do_PUT_CELL);
    }
    if (fnName == "do_ADD") {
      return reinterpret_cast<void *>(do_ADD);
    }
    if (fnName == "do_RAND_COLOR") {
      return reinterpret_cast<void*>(do_RAND_COLOR);
    }
    if (fnName == "do_FLUSH") {
      return reinterpret_cast<void *>(do_FLUSH);
    }
    return nullptr;
  });

  ee->addGlobalMapping(regFile, (void *)REG_FILE);
  ee->finalizeObject();

  simInit();

  ArrayRef<GenericValue> noargs;
  ee->runFunction(mainFunc, noargs);
  outs() << "#[Code was run]\n";

  simExit();
  return EXIT_SUCCESS;
}