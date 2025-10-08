#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
using namespace llvm;

struct MyModPass : public PassInfoMixin<MyModPass> {

  PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM) {
    if(!M.getName().contains("app.c"))
      return PreservedAnalyses::all();;

    outs() << "[Module] " << M.getName() << '\n';

    // Prepare builder for IR modification
    LLVMContext &Ctx = M.getContext();
    IRBuilder<> builder(Ctx);

    // Prepare Logger
    auto voidType  = Type::getVoidTy(Ctx);
    auto int8PtrTy = Type::getInt8Ty(Ctx)->getPointerTo();

    ArrayRef<Type*> loggerParams = {int8PtrTy, int8PtrTy};
    auto callLogFuncType = FunctionType::get(voidType, loggerParams, false);
    auto callLogFunc = M.getOrInsertFunction("callLogger", callLogFuncType);

    for (auto &F : M) {
        outs() << "[Function] " << F.getName() << " (arg_size: " << F.arg_size()
              << ")\n";
        for(auto &B : F) {
          for(auto &I : B) {
            if(dyn_cast<PHINode>(&I))
              continue;
            
            for(auto &O : I.operands()) {
              if(auto inst = dyn_cast<Instruction>(O)) {
                if(!dyn_cast<PHINode>(O))
                  continue;

                builder.SetInsertPoint(&I);
                auto *user_inst_name = builder.CreateGlobalStringPtr(    I.getOpcodeName());
                auto *used_inst_name = builder.CreateGlobalStringPtr(inst->getOpcodeName());

                builder.CreateCall(callLogFunc, {user_inst_name, used_inst_name});
              }
            }
          }
        }
    }

    outs() << '\n';
    return PreservedAnalyses::none();
  };
};

PassPluginLibraryInfo getPassPluginInfo() {
  const auto callback = [](PassBuilder &PB) {
    // PB.registerOptimizerLastEPCallback([](ModulePassManager &MPM, auto) {
    PB.registerOptimizerLastEPCallback([](ModulePassManager &MPM, auto) {
      MPM.addPass(MyModPass{});
      return true;
    });
  };

  return {LLVM_PLUGIN_API_VERSION, "MyPlugin", "0.0.1", callback};
};

/* When a plugin is loaded by the driver, it will call this entry point to
obtain information about this plugin and about how to register its passes.
*/
extern "C" LLVM_ATTRIBUTE_WEAK PassPluginLibraryInfo llvmGetPassPluginInfo() {
  return getPassPluginInfo();
}