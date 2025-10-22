#include "llvm/ExecutionEngine/ExecutionEngine.h"
#include "llvm/ExecutionEngine/GenericValue.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Support/raw_ostream.h"
using namespace llvm;

#include "../../hw1/src/sim.h"

Function* emitIR(Module *module, LLVMContext &context) {
    IRBuilder<> builder(context);

    // Types
    Type *voidType  = Type::getVoidTy(context);
    Type *int32Type = Type::getInt32Ty(context);
    Type *int64Type = Type::getInt64Ty(context);
    Type *boolType  = Type::getInt1Ty(context);

    ArrayType *innerArrayType = ArrayType::get(int32Type, FIELD_WIDTH);
    ArrayType *outerArrayType = ArrayType::get(innerArrayType, FIELD_HEIGHT);
    PointerType *outerArrayPtrType = outerArrayType->getPointerTo();

    // External function declarations
    ArrayRef<Type *> simPutPixelParamTypes = {int32Type, int32Type, int32Type};
    FunctionType *simPutPixelType = FunctionType::get(voidType, simPutPixelParamTypes, false);
    FunctionCallee simPutPixelFunc = module->getOrInsertFunction("simPutPixel", simPutPixelType);

    FunctionType *simFlushType = FunctionType::get(int32Type, false);
    FunctionCallee simFlushFunc = module->getOrInsertFunction("simFlush", simFlushType);

    FunctionType *simRandType = FunctionType::get(int32Type, false);
    FunctionCallee simRandFunc = module->getOrInsertFunction("simRand", simRandType);

    // Function: init
    FunctionType *initType = FunctionType::get(voidType, {outerArrayPtrType}, false);
    Function *initFunc = Function::Create(initType, Function::ExternalLinkage, "init", module);
    initFunc->addParamAttr(0, Attribute::NoCapture);

    BasicBlock *initBB0 = BasicBlock::Create(context, "", initFunc);
    BasicBlock *initBB2 = BasicBlock::Create(context, "", initFunc);
    BasicBlock *initBB4 = BasicBlock::Create(context, "", initFunc);
    BasicBlock *initBB5 = BasicBlock::Create(context, "", initFunc);
    BasicBlock *initBB8 = BasicBlock::Create(context, "", initFunc);

    builder.SetInsertPoint(initBB0);
    builder.CreateBr(initBB2);

    builder.SetInsertPoint(initBB2);
    PHINode *initPhi3 = builder.CreatePHI(int64Type, 2);
    builder.CreateBr(initBB8);

    builder.SetInsertPoint(initBB8);
    PHINode *initPhi9 = builder.CreatePHI(int64Type, 2);
    Value *randCall = builder.CreateCall(simRandFunc);
    Value *mod100 = builder.CreateSRem(randCall, builder.getInt32(100));
    Value *cmp12 = builder.CreateICmpSLT(mod100, builder.getInt32(ALIVE_PROB));
    Value *ext13 = builder.CreateZExt(cmp12, int32Type);

    Value *gep = builder.CreateInBoundsGEP(outerArrayType, initFunc->getArg(0), 
                                        {builder.getInt64(0), initPhi3, initPhi9});
    builder.CreateStore(ext13, gep);

    Value *next15 = builder.CreateAdd(initPhi9, builder.getInt64(1));
    Value *cmp16 = builder.CreateICmpEQ(next15, builder.getInt64(FIELD_HEIGHT));
    builder.CreateCondBr(cmp16, initBB5, initBB8);

    builder.SetInsertPoint(initBB5);
    Value *next6 = builder.CreateAdd(initPhi3, builder.getInt64(1));
    Value *cmp7 = builder.CreateICmpEQ(next6, builder.getInt64(FIELD_WIDTH));
    builder.CreateCondBr(cmp7, initBB4, initBB2);

    builder.SetInsertPoint(initBB4);
    builder.CreateRetVoid();

    // Link PHI nodes
    initPhi3->addIncoming(builder.getInt64(0), initBB0);
    initPhi3->addIncoming(next6, initBB5);
    initPhi9->addIncoming(builder.getInt64(0), initBB2);
    initPhi9->addIncoming(next15, initBB8);

    // Function: drawCell
    FunctionType *drawCellType = FunctionType::get(voidType, {int32Type, int32Type, int32Type}, false);
    Function *drawCellFunc = Function::Create(drawCellType, Function::ExternalLinkage, "drawCell", module);

    BasicBlock *drawCellBB = BasicBlock::Create(context, "", drawCellFunc);
    builder.SetInsertPoint(drawCellBB);

    Value *x = drawCellFunc->getArg(0);
    Value *y = drawCellFunc->getArg(1);
    Value *color = drawCellFunc->getArg(2);

    Value *x5 = builder.CreateMul(x, builder.getInt32(5));
    Value *y5 = builder.CreateMul(y, builder.getInt32(5));

    // Simulate loop unrolling
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
            Value *px = builder.CreateAdd(x5, builder.getInt32(i));
            Value *py = builder.CreateAdd(y5, builder.getInt32(j));
            builder.CreateCall(simPutPixelFunc, {px, py, color});
        }
    }

    builder.CreateRetVoid();

    // Function: countNeighbors (TODO: sorry it's to large for me... For now just simRandFunc)
    FunctionType *countNeighborsType = FunctionType::get(int32Type, {int32Type, int32Type, outerArrayPtrType}, false);
    Function *countNeighborsFunc = Function::Create(countNeighborsType, Function::ExternalLinkage, "countNeighbors", module);
    countNeighborsFunc->addParamAttr(2, Attribute::NoCapture);

    BasicBlock *countBB = BasicBlock::Create(context, "", countNeighborsFunc);
    builder.SetInsertPoint(countBB);
    Value *rand = builder.CreateCall(simRandFunc);
    Value *ret = builder.CreateSRem(rand, builder.getInt32(4));
    builder.CreateRet(ret);

   // Function: app
    FunctionType *appType = FunctionType::get(voidType, false);
    Function *appFunc = Function::Create(appType, Function::ExternalLinkage, "app", module);

    BasicBlock *appBB0 = BasicBlock::Create(context, "", appFunc);
    BasicBlock *appBB3 = BasicBlock::Create(context, "", appFunc);
    BasicBlock *appBB5 = BasicBlock::Create(context, "", appFunc);
    BasicBlock *appBB8 = BasicBlock::Create(context, "", appFunc);
    BasicBlock *appBB17 = BasicBlock::Create(context, "", appFunc);
    BasicBlock *appBB20 = BasicBlock::Create(context, "", appFunc);
    BasicBlock *appBB23 = BasicBlock::Create(context, "", appFunc);
    BasicBlock *appBB26 = BasicBlock::Create(context, "", appFunc);
    BasicBlock *appBB40 = BasicBlock::Create(context, "", appFunc);
    BasicBlock *appBB45 = BasicBlock::Create(context, "", appFunc);
    BasicBlock *appBB48 = BasicBlock::Create(context, "", appFunc);
    BasicBlock *appBB51 = BasicBlock::Create(context, "", appFunc);
    BasicBlock *appBB60 = BasicBlock::Create(context, "", appFunc);
    BasicBlock *appBB63 = BasicBlock::Create(context, "", appFunc);


    builder.SetInsertPoint(appBB0);
    AllocaInst *array1 = builder.CreateAlloca(outerArrayType);
    array1->setAlignment(Align(16));
    AllocaInst *array2 = builder.CreateAlloca(outerArrayType);
    array2->setAlignment(Align(16));

    builder.CreateBr(appBB3);

    builder.SetInsertPoint(appBB3);
    PHINode *phi4 = builder.CreatePHI(int64Type, 2);
    builder.CreateBr(appBB8);

    builder.SetInsertPoint(appBB8);
    PHINode *phi9 = builder.CreatePHI(int64Type, 2);

    Value *randCall2 = builder.CreateCall(simRandFunc);
    Value *mod100_2 = builder.CreateSRem(randCall2, builder.getInt32(100));
    Value *cmp12_2 = builder.CreateICmpSLT(mod100_2, builder.getInt32(ALIVE_PROB));
    Value *ext13_2 = builder.CreateZExt(cmp12_2, int32Type);

    Value *gep2 = builder.CreateInBoundsGEP(outerArrayType, array1, 
    {builder.getInt64(0), phi4, phi9});
    builder.CreateStore(ext13_2, gep2);

    Value *next15_2 = builder.CreateAdd(phi9, builder.getInt64(1), "", true, true);
    Value *cmp16_2 = builder.CreateICmpEQ(next15_2, builder.getInt64(FIELD_WIDTH));
    builder.CreateCondBr(cmp16_2, appBB5, appBB8);

    builder.SetInsertPoint(appBB5);
    Value *next6_2 = builder.CreateAdd(phi4, builder.getInt64(1), "", true, true);
    Value *cmp7_2 = builder.CreateICmpEQ(next6_2, builder.getInt64(FIELD_HEIGHT));
    builder.CreateCondBr(cmp7_2, appBB17, appBB3);

    phi4->addIncoming(builder.getInt64(0), appBB0);
    phi4->addIncoming(next6_2, appBB5);
    phi9->addIncoming(builder.getInt64(0), appBB3);
    phi9->addIncoming(next15_2, appBB8);

    builder.SetInsertPoint(appBB17);
    PHINode *currentBuffer = builder.CreatePHI(outerArrayPtrType, 2);
    PHINode *nextBuffer = builder.CreatePHI(outerArrayPtrType, 2);

    currentBuffer->addIncoming(array1, appBB5);
    nextBuffer->addIncoming(array2, appBB5);

    builder.CreateBr(appBB20);

    builder.SetInsertPoint(appBB20);
    PHINode *updateRowPhi = builder.CreatePHI(int64Type, 2);
    builder.CreateBr(appBB26);

    builder.SetInsertPoint(appBB26);
    PHINode *updateColPhi = builder.CreatePHI(int64Type, 2);

    Value *row_i32 = builder.CreateTrunc(updateRowPhi, int32Type);
    Value *col_i32 = builder.CreateTrunc(updateColPhi, int32Type);

    Value *neighborCount = builder.CreateCall(countNeighborsFunc, {col_i32, row_i32, currentBuffer});

    Value *currentCellGEP = builder.CreateInBoundsGEP(outerArrayType, currentBuffer, 
                                                    {builder.getInt64(0), updateRowPhi, updateColPhi});
    Value *currentCell = builder.CreateLoad(int32Type, currentCellGEP);

    Value *isDead = builder.CreateICmpEQ(currentCell, builder.getInt32(0));
    Value *isAlive = builder.CreateICmpNE(currentCell, builder.getInt32(0));

    Value *deadBecomesAlive = builder.CreateAnd(isDead, builder.CreateICmpEQ(neighborCount, builder.getInt32(3)));
    Value *newCellDeadCase = builder.CreateSelect(deadBecomesAlive, builder.getInt32(1), builder.getInt32(0));

    Value *aliveStaysAlive = builder.CreateAnd(isAlive, 
                                            builder.CreateOr(builder.CreateICmpEQ(neighborCount, builder.getInt32(2)),
                                                            builder.CreateICmpEQ(neighborCount, builder.getInt32(3))));
    Value *newCellAliveCase = builder.CreateSelect(aliveStaysAlive, currentCell, builder.getInt32(0));

    Value *newCell = builder.CreateSelect(isDead, newCellDeadCase, newCellAliveCase);

    Value *nextCellGEP = builder.CreateInBoundsGEP(outerArrayType, nextBuffer, 
                                                {builder.getInt64(0), updateRowPhi, updateColPhi});
    builder.CreateStore(newCell, nextCellGEP);

    Value *nextCol = builder.CreateAdd(updateColPhi, builder.getInt64(1), "", true, true);
    Value *colDone = builder.CreateICmpEQ(nextCol, builder.getInt64(FIELD_WIDTH));
    builder.CreateCondBr(colDone, appBB23, appBB26);

    builder.SetInsertPoint(appBB23);
    Value *nextRow = builder.CreateAdd(updateRowPhi, builder.getInt64(1), "", true, true);
    Value *rowDone = builder.CreateICmpEQ(nextRow, builder.getInt64(FIELD_HEIGHT));
    builder.CreateCondBr(rowDone, appBB45, appBB20);

    updateRowPhi->addIncoming(builder.getInt64(0), appBB17);
    updateRowPhi->addIncoming(nextRow, appBB23);
    updateColPhi->addIncoming(builder.getInt64(0), appBB20);
    updateColPhi->addIncoming(nextCol, appBB26);

    builder.SetInsertPoint(appBB45);
    builder.CreateBr(appBB48);

    builder.SetInsertPoint(appBB48);
    PHINode *renderRowPhi = builder.CreatePHI(int64Type, 2);
    builder.CreateBr(appBB51);

    builder.SetInsertPoint(appBB51);
    PHINode *renderColPhi = builder.CreatePHI(int64Type, 2);

    Value *renderCellGEP = builder.CreateInBoundsGEP(outerArrayType, nextBuffer, 
                                                {builder.getInt64(0), renderRowPhi, renderColPhi});
    Value *renderCell = builder.CreateLoad(int32Type, renderCellGEP);

    Value *isCellAlive = builder.CreateICmpNE(renderCell, builder.getInt32(0));
    Value *color1 = builder.CreateSelect(isCellAlive, builder.getInt32(BLUE), builder.getInt32(WHITE));

    Value *renderRow_i32 = builder.CreateTrunc(renderRowPhi, int32Type);
    Value *renderCol_i32 = builder.CreateTrunc(renderColPhi, int32Type);

    builder.CreateCall(drawCellFunc, {renderCol_i32, renderRow_i32, color1});

    Value *nextRenderCol = builder.CreateAdd(renderColPhi, builder.getInt64(1), "", true, true);
    Value *renderColDone = builder.CreateICmpEQ(nextRenderCol, builder.getInt64(FIELD_WIDTH));
    builder.CreateCondBr(renderColDone, appBB60, appBB51);

    builder.SetInsertPoint(appBB60);
    Value *nextRenderRow = builder.CreateAdd(renderRowPhi, builder.getInt64(1), "", true, true);
    Value *renderRowDone = builder.CreateICmpEQ(nextRenderRow, builder.getInt64(FIELD_HEIGHT));
    builder.CreateCondBr(renderRowDone, appBB40, appBB48);

    renderRowPhi->addIncoming(builder.getInt64(0), appBB45);
    renderRowPhi->addIncoming(nextRenderRow, appBB60);
    renderColPhi->addIncoming(builder.getInt64(0), appBB48);
    renderColPhi->addIncoming(nextRenderCol, appBB51);

    builder.SetInsertPoint(appBB40);
    Value *flushResult = builder.CreateCall(simFlushFunc);
    Value *shouldExit = builder.CreateICmpNE(flushResult, builder.getInt32(0));

    Value *tempBuffer = currentBuffer;
    currentBuffer->addIncoming(nextBuffer, appBB40);
    nextBuffer->addIncoming(tempBuffer, appBB40);

    builder.CreateCondBr(shouldExit, appBB63, appBB17);

    builder.SetInsertPoint(appBB63);
    builder.CreateRetVoid();

    return appFunc;
}

int main() {
    LLVMContext context;
    Module *module = new Module("src/app.c", context);

    auto appFunc = emitIR(module, context);

    module->print(outs(), nullptr);
    outs() << '\n';

    bool verif = verifyModule(*module, &outs());
    outs() << "[VERIFICATION] " << (verif ? "FAIL\n\n" : "OK\n\n");

    if (verif) {
        outs() << "Module verification failed. Cannot execute.\n";
        return 1;
    }

    outs() << "[EE] Run\n";
    InitializeNativeTarget();
    InitializeNativeTargetAsmPrinter();
    InitializeNativeTargetAsmParser();

    std::string error;
    ExecutionEngine *ee = EngineBuilder(std::unique_ptr<Module>(module))
                            .setErrorStr(&error)
                            .setEngineKind(EngineKind::JIT)
                            .create();

    if (!ee) {
        outs() << "Failed to create ExecutionEngine: " << error << "\n";
        return 1;
    }

    ee->InstallLazyFunctionCreator([](const std::string &fnName) -> void * {
        if (fnName == "simPutPixel") return reinterpret_cast<void *>(simPutPixel);
        if (fnName == "simFlush") return reinterpret_cast<void *>(simFlush);
        if (fnName == "simRand") return reinterpret_cast<void *>(simRand);
            return nullptr;
    });
    ee->finalizeObject();
    
    simInit();
    ArrayRef<GenericValue> noargs;
    ee->runFunction(appFunc, noargs);
    simExit();
    outs() << "[EE] Execution completed\n";
    return 0;
    }