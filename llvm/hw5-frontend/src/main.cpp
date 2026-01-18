#include "../sim.h"

#include "gen/MiniGoLexer.h"
#include "gen/MiniGoParser.h"
#include "gen/MiniGoVisitor.h"

#include "antlr4-runtime.h"

#include "llvm/ExecutionEngine/ExecutionEngine.h"
#include "llvm/ExecutionEngine/GenericValue.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Support/raw_ostream.h"

#include <cstddef>
#include <fstream>
#include <map>
#include <memory>
#include <stdexcept>
#include <string>
#include <strstream>
#include <vector>

using namespace llvm;

struct TreeLLVMWalker : public MiniGoVisitor {
  enum class Scope {
    Local,
    Global,
    All,
  };

  std::map<std::string, Value*> local_vars;
  std::map<std::string, Value*> global_vars;
  std::map<std::string, Function*> functions;


  Function *currFunc;
  LLVMContext *ctxLLVM;
  Module *module;
  IRBuilder<> *builder;
  
  bool interpretMode;
  
  Type *int32Type;
  Type *voidType;

  TreeLLVMWalker(LLVMContext *ctxLLVM, IRBuilder<> *builder, Module *module,
                 bool interpretMode)
      : ctxLLVM(ctxLLVM), builder(builder), module(module),
        interpretMode(interpretMode) {
    int32Type = Type::getInt32Ty(*ctxLLVM);
    voidType = Type::getVoidTy(*ctxLLVM);
  }

  void regGraphicFuncs() {
    // declare i32 @PUT_PIXEL(i32, i32, i32)
    ArrayRef<Type *> simPutPixelParamTypes = {int32Type, int32Type, int32Type};
    FunctionType *simPutPixelType =
        FunctionType::get(int32Type, simPutPixelParamTypes, false);
    module->getOrInsertFunction("PUT_PIXEL", simPutPixelType);

    // declare i32 @FLUSH()
    FunctionType *simFlushType = FunctionType::get(int32Type, false);
    module->getOrInsertFunction("FLUSH", simFlushType);
  }

  void regGraphicFuncsIntr() {
    // declare void @llvm.sim.putpixel(i32 noundef, i32 noundef, i32 noundef)
    ArrayRef<Type *> simPutPixelParamTypes = {int32Type, int32Type, int32Type};
    FunctionType *simPutPixelIntrType =
        FunctionType::get(voidType, simPutPixelParamTypes, false);
    FunctionCallee simPutPixelIntr =
        module->getOrInsertFunction("llvm.sim.putpixel", simPutPixelIntrType);

    // define i32 @PUT_PIXEL(i32 %0, i32 %1, i32 %2) {
    FunctionType *simPutPixelType =
        FunctionType::get(int32Type, simPutPixelParamTypes, false);
    Function *simPutPixelFunc = Function::Create(
        simPutPixelType, Function::ExternalLinkage, "PUT_PIXEL", module);
    // entry:
    builder->SetInsertPoint(
        BasicBlock::Create(*ctxLLVM, "entry", simPutPixelFunc));
    // call void @llvm.sim.putpixel(i32 %0, i32 %1, i32 %2)
    builder->CreateCall(simPutPixelIntr,
                        {simPutPixelFunc->getArg(0), simPutPixelFunc->getArg(1),
                         simPutPixelFunc->getArg(2)});
    // ret i32 0
    builder->CreateRet(builder->getInt32(0));

    // declare void @llvm.sim.flush()
    FunctionType *simFlushIntrType = FunctionType::get(voidType, false);
    FunctionCallee simFlushIntr =
        module->getOrInsertFunction("llvm.sim.flush", simFlushIntrType);

    // define i32 @FLUSH() {
    FunctionType *simFlushType = FunctionType::get(int32Type, false);
    Function *simFlushFunc = Function::Create(
        simFlushType, Function::ExternalLinkage, "FLUSH", module);
    // entry:
    builder->SetInsertPoint(
        BasicBlock::Create(*ctxLLVM, "entry", simFlushFunc));
    // call void @llvm.sim.flush()
    builder->CreateCall(simFlushIntr);
    // ret i32 0
    builder->CreateRet(builder->getInt32(0));
  }

  antlrcpp::Any visitProgram(MiniGoParser::ProgramContext *ctx) override {
    outs() << "visitProgram\n";
    if (interpretMode) {
      regGraphicFuncs();
    } else {
      regGraphicFuncsIntr();
    }

    for (auto it : ctx->topLevelDecl()) {
      visitTopLevelDecl(it);
    }
    return nullptr;
  }

  antlrcpp::Any visitTopLevelDecl(MiniGoParser::TopLevelDeclContext *ctx) override {
    outs() << "visitTopLevelDecl\n";
    if (ctx->constDecl())
      return visitConstDecl(ctx->constDecl());
    return nullptr;
  }

  antlrcpp::Any visitConstDecl(MiniGoParser::ConstDeclContext *ctx) override {
    std::string name = ctx->ID()->getText();
    outs() << "visitConstDecl: "<< name << "\n";
    return registerVar(name, visitExpr(ctx->expr()).as<Value*>(), Scope::Global);
  }

  antlrcpp::Any visitFuncDecl(MiniGoParser::FuncDeclContext *ctx) override {
    if (currFunc != nullptr) {
      throw std::runtime_error("Function declaration inside function is not supported");
    }
    std::string name = ctx->ID()->getText();
    if (functions.count(name)) {
      throw std::runtime_error("Function redeclaration");
    }

    std::vector<Type *> funcParamTypes(1, voidType);

    FunctionType *funcType = FunctionType::get(voidType, funcParamTypes, false);
    Function *func = Function::Create(funcType, Function::ExternalLinkage, name, module);

    // Register function
    functions[name] = func;

    // entry:
    BasicBlock *entryBB = BasicBlock::Create(*ctxLLVM, "entry", func);
    builder->SetInsertPoint(entryBB);
    currFunc = func;

    // Main body
    local_vars.clear();
    visitBlock(ctx->block());

    if (!builder->GetInsertBlock()->getTerminator()){
      builder->CreateRetVoid();
    }
    
    local_vars.clear();
    currFunc = nullptr;
    return nullptr;
  }

  antlrcpp::Any visitBlock(MiniGoParser::BlockContext *ctx) override {
    if (ctx->statement().size() != 0) {
      for (auto it: ctx->statement())
        visitStatement(it);
    }
    return nullptr;
  }

  antlrcpp::Any visitStatement(MiniGoParser::StatementContext *ctx) override {
    return visit(ctx->children[0]);
  }

  antlrcpp::Any visitIfStmt(MiniGoParser::IfStmtContext *ctx) override {
    auto *thenBB  = BasicBlock::Create(*ctxLLVM, "then", currFunc);
    auto *elseBB  = BasicBlock::Create(*ctxLLVM, "else", currFunc);
    auto *mergeBB = BasicBlock::Create(*ctxLLVM, "merge", currFunc);

    auto *condition = visitExpr(ctx->expr()).as<Value*>();
    builder->CreateCondBr(condition, thenBB, elseBB);
    
    // ThenBB
    builder->SetInsertPoint(thenBB);
    visitBlock(ctx->block(0));

    if(!builder->GetInsertBlock()->getTerminator()) {
      builder->CreateBr(mergeBB);
    }

    // ElseBB
    builder->SetInsertPoint(elseBB);

    if (ctx->block().size() > 1) {
      visitBlock(ctx->block(1));
    }

    if(!builder->GetInsertBlock()->getTerminator()) {
      builder->CreateBr(mergeBB);
    }

    // MergeBB
    builder->SetInsertPoint(mergeBB);
    return nullptr;
  }

  antlrcpp::Any visitForStmt(MiniGoParser::ForStmtContext *ctx) override {
    auto *conditionBB = BasicBlock::Create(*ctxLLVM, "condition", currFunc);
    auto *loopBB  = BasicBlock::Create(*ctxLLVM, "loop", currFunc);
    auto *mergeBB = BasicBlock::Create(*ctxLLVM, "merge", currFunc);

    builder->SetInsertPoint(conditionBB);
    auto *condition = visitExpr(ctx->expr()).as<Value*>();
    builder->CreateCondBr(condition, loopBB, mergeBB);

    builder->SetInsertPoint(loopBB);
    visitBlock(ctx->block());
    
    if(!builder->GetInsertBlock()->getTerminator()) {
      builder->CreateBr(mergeBB);
    }

    builder->SetInsertPoint(mergeBB);
    return nullptr;
  }

  antlrcpp::Any visitVarDecl(MiniGoParser::VarDeclContext *ctx) override {
    std::string name = ctx->ID()->getText();
    return registerVar(name, visitExpr(ctx->expr()).as<Value*>(), Scope::Local);
  }

  antlrcpp::Any visitAssignStmt(MiniGoParser::AssignStmtContext *ctx) override {
    std::string name = ctx->ID()->getText();
    return setVar(name, visitExpr(ctx->expr()).as<Value*>());
  }

  antlrcpp::Any visitExprStmt(MiniGoParser::ExprStmtContext *ctx) override {
    return visitExpr(ctx->expr());
  }

  antlrcpp::Any visitType(MiniGoParser::TypeContext *ctx) override {
    // TODO - implement type system
    return nullptr;
  }

  antlrcpp::Any visitExpr(MiniGoParser::ExprContext *ctx) override {
    outs() << "visitExpr\n";
    return visitComparisonExpr(ctx->comparisonExpr());
  }

  antlrcpp::Any visitComparisonExpr(MiniGoParser::ComparisonExprContext *ctx) override {
    outs() << "visitComparisonExpr\n";

    Value *lhs = visit(ctx->additiveExpr(0)).as<Value*>();

    for (size_t i = 1; i < ctx->additiveExpr().size(); ++i) {
      Value *rhs = visit(ctx->additiveExpr(i)).as<Value*>();

      std::string op = ctx->children[2*i - 1]->getText();
      if (op == "<") {
        lhs = builder->CreateICmpSLT(lhs, rhs);
      }
      else if (op == ">") {
        lhs = builder->CreateICmpSGT(lhs, rhs);
      } else {
        throw std::runtime_error("Unknow comparison operator");
      }
    }

    return lhs;
  }

  antlrcpp::Any visitAdditiveExpr(MiniGoParser::AdditiveExprContext *ctx) override {
    outs() << "visitAdditiveExpr\n";
    Value *lhs = visit(ctx->multiplicativeExpr(0)).as<Value *>();

    for (size_t i = 1; i < ctx->multiplicativeExpr().size(); ++i) {
        Value *rhs =
            visit(ctx->multiplicativeExpr(i)).as<llvm::Value *>();

        std::string op = ctx->children[2 * i - 1]->getText();

        if (op == "+") {
            lhs = builder->CreateAdd(lhs, rhs);
        } else if (op == "-") {
            lhs = builder->CreateSub(lhs, rhs);
        } else {
            throw std::runtime_error("Unknow additive operator");
        }
    }

    return lhs;
  }

  antlrcpp::Any visitMultiplicativeExpr(MiniGoParser::MultiplicativeExprContext *ctx) override {
    outs() << "visitMultiplicativeExpr\n";
    Value *lhs = visit(ctx->primary(0)).as<llvm::Value *>();

    for (size_t i = 1; i < ctx->primary().size(); ++i) {
        Value *rhs = visit(ctx->primary(i)).as<llvm::Value *>();

        std::string op = ctx->children[2 * i - 1]->getText();

        if (op == "*") {
          lhs = builder->CreateMul(lhs, rhs);
        } else if (op == "/") {
          lhs = builder->CreateSDiv(lhs, rhs);
        } else if (op == "%") {
          lhs = builder->CreateSRem(lhs, rhs);
        } else {
            throw std::runtime_error("Unknow multiplicative operator:" + op);
        }
    }

    return lhs;
  }

  antlrcpp::Any visitPrimary(MiniGoParser::PrimaryContext *ctx) override  {
    outs  () << "visitPrimary\n";
    if (ctx->literal()){
      outs() << "visitPrimary:" << ctx->literal()->getText() << "\n";
      return visitLiteral(ctx->literal());
    }
    if (ctx->ID()) {
      auto name = ctx->ID()->getText();
      
      if (ctx->argList()) {
        // Function Call
        auto it = functions.find(name);
        if (it == functions.end()) {
          throw std::runtime_error("Unknown function call");
        }

        Function *callee = it->second;
        std::vector<Value*> args = visitArgList(ctx->argList()).as<std::vector<Value*>>();
        if (callee->arg_size() != args.size()) {
            throw std::runtime_error("Argument count mismatch in call to " + name);
        }
      
        return builder->CreateCall(callee, args);
      
      } else {
        // Variable
        outs() << "visitPrimary:" << name << "\n";
        return getVar(name);
      }
    }

    if (ctx->expr()) {
      return visitExpr(ctx->expr());
    }

    throw std::runtime_error("Empty primary expression");
  }

  antlrcpp::Any visitArgList(MiniGoParser::ArgListContext *ctx) override {
      std::vector<Value*> args;

      for (auto *exprCtx : ctx->expr()) {
        Value *arg = visitExpr(exprCtx).as<Value*>();
        args.push_back(arg);
      }

      return args; 
  }

  antlrcpp::Any visitLiteral(MiniGoParser::LiteralContext *ctx) override  {
    if (ctx->INT())
      return (Value*)builder->getInt32(std::stoi(ctx->INT()->getText()));
    if (ctx->BOOL()) {
      if(ctx->BOOL()->getText() == "true")
        return (Value*)builder->getInt1(builder->getTrue());
      else
        return (Value*)builder->getInt1(builder->getFalse());

    }
    if (ctx->HEX()) {
      abort();
    }
    throw std::runtime_error("Unknow Literal Type");
  }

  // Helper Functions
  Value *registerVar(const std::string &name, Value *val, Scope scp) {
    outs() << "registerVar: " << name << "\n";
    if (isVar(name, scp))
      throw std::runtime_error("Variable redeclaration");

    switch (scp) {
     case Scope::Local:
        local_vars[name] = val;
        break;
      case Scope::Global:
        global_vars[name] = val;
        break;
      default:
        throw std::runtime_error("Unknow scope type");
    }

    return val;
  }

  Value *setVar(const std::string &name, Value *val) {
    if (local_vars.count(name) != 0) {
        local_vars[name] = val;
        return val;
    }

    if (global_vars.count(name)) {
        global_vars[name] = val;
        return val;
    }

    throw std::runtime_error("Unknow variable name: '" + name + "'");
  }

  bool isVar(const std::string &name, Scope scp) {
    try {
      getVar(name, scp);
      return true;
    } catch (std::runtime_error& e) {
      return false;
    }
  }
  Value *getVar(const std::string &name, Scope scp = Scope::All) {
    outs() << "getVar: " << name << "\n";
    
    if (scp == Scope::Local || scp == Scope::All) {
      auto it = local_vars.find(name);
      if (it != local_vars.end())
        return it->second;
    }

    if (scp == Scope::Global || scp == Scope::All) {
      auto it = global_vars.find(name);
      if (it != global_vars.end())
        return it->second;
    }

    throw std::runtime_error("Unknow variable name: '" + name + "'");
  }
};


int main(int argc, const char *argv[]) {
  if (argc != 2 && argc != 3) {
    outs() << "[ERROR] Need arguments: file with MiniGo and optional output "
              "file for LLVM IR\n";
    return 1;
  }
  bool interpretMode = (argc == 2);
  // Open file
  std::ifstream stream;
  stream.open(argv[1]);

  // Provide the input text in a stream
  antlr4::ANTLRInputStream input(stream);

  // Create a lexer from the input
  MiniGoLexer lexer(&input);

  // Create a token stream from the lexer
  antlr4::CommonTokenStream tokens(&lexer);

  // Create a parser from the token stream
  MiniGoParser parser(&tokens);

  // Display the parse tree
  outs() << parser.program()->toStringTree() << '\n';

  LLVMContext context;
  Module *module = new Module("top", context);
  IRBuilder<> builder(context);

  TreeLLVMWalker walker(&context, &builder, module, interpretMode);
  walker.visitProgram(parser.program());

  outs() << "[LLVM IR]\n";
  module->print(outs(), nullptr);
  outs() << '\n';
  bool verif = verifyModule(*module, &outs());
  outs() << "[VERIFICATION] " << (verif ? "FAIL\n\n" : "OK\n\n");

  Function *appFunc = module->getFunction("app");
  if (appFunc == nullptr) {
    outs() << "Can't find app function\n";
    return -1;
  }

  if (interpretMode) {
    // LLVM IR Interpreter
    outs() << "[EE] Run\n";
    InitializeNativeTarget();
    InitializeNativeTargetAsmPrinter();

  ExecutionEngine *ee = EngineBuilder(std::unique_ptr<Module>(module)).create();
  ee->InstallLazyFunctionCreator([](const std::string &fnName) -> void * {
    if (fnName == "PUT_PIXEL") {
      return reinterpret_cast<void *>(simPutPixel);
      }
      if (fnName == "FLUSH") {
        return reinterpret_cast<void *>(simFlush);
      }
      outs() << "[ExecutionEngine] Can't find function " << fnName
            << ". Catch the Segmentation fault:)\n";
      return nullptr;
    });
    ee->finalizeObject();

    simInit();

    ArrayRef<GenericValue> noargs;
    GenericValue v = ee->runFunction(appFunc, noargs);
    outs() << "[EE] Result: " << v.IntVal << "\n";

    simExit();
  } else {
    // Dump LLVM IR with intrinsics
    outs() << "[OUTPUT] " << argv[2] << "\n";
    std::error_code EC;
    raw_fd_ostream OutputFile(argv[2], EC);
    if (!EC) {
      module->print(OutputFile, nullptr);
    }
  }

  return 0;
}