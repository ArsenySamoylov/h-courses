; ModuleID = 'smin.c'
source_filename = "smin.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read) uwtable
define dso_local i32 @smin(ptr nocapture noundef readonly %0, i32 noundef %1) local_unnamed_addr #0 {
  %3 = icmp eq i32 %1, 0
  br i1 %3, label %39, label %4

4:                                                ; preds = %2
  %5 = load i32, ptr %0, align 4, !tbaa !5
  %6 = zext i32 %1 to i64
  %7 = icmp ult i32 %1, 8
  br i1 %7, label %28, label %8

8:                                                ; preds = %4
  %9 = and i64 %6, 4294967288
  %10 = insertelement <4 x i32> poison, i32 %5, i64 0
  %11 = shufflevector <4 x i32> %10, <4 x i32> poison, <4 x i32> zeroinitializer
  br label %12

12:                                               ; preds = %12, %8
  %13 = phi i64 [ 0, %8 ], [ %22, %12 ]
  %14 = phi <4 x i32> [ %11, %8 ], [ %20, %12 ]
  %15 = phi <4 x i32> [ %11, %8 ], [ %21, %12 ]
  %16 = getelementptr inbounds i32, ptr %0, i64 %13
  %17 = getelementptr inbounds i32, ptr %16, i64 4
  %18 = load <4 x i32>, ptr %16, align 4, !tbaa !5
  %19 = load <4 x i32>, ptr %17, align 4, !tbaa !5
  %20 = tail call <4 x i32> @llvm.smin.v4i32(<4 x i32> %18, <4 x i32> %14)
  %21 = tail call <4 x i32> @llvm.smin.v4i32(<4 x i32> %19, <4 x i32> %15)
  %22 = add nuw i64 %13, 8
  %23 = icmp eq i64 %22, %9
  br i1 %23, label %24, label %12, !llvm.loop !9

24:                                               ; preds = %12
  %25 = tail call <4 x i32> @llvm.smin.v4i32(<4 x i32> %20, <4 x i32> %21)
  %26 = tail call i32 @llvm.vector.reduce.smin.v4i32(<4 x i32> %25)
  %27 = icmp eq i64 %9, %6
  br i1 %27, label %39, label %28

28:                                               ; preds = %4, %24
  %29 = phi i64 [ 0, %4 ], [ %9, %24 ]
  %30 = phi i32 [ %5, %4 ], [ %26, %24 ]
  br label %31

31:                                               ; preds = %28, %31
  %32 = phi i64 [ %37, %31 ], [ %29, %28 ]
  %33 = phi i32 [ %36, %31 ], [ %30, %28 ]
  %34 = getelementptr inbounds i32, ptr %0, i64 %32
  %35 = load i32, ptr %34, align 4, !tbaa !5
  %36 = tail call i32 @llvm.smin.i32(i32 %35, i32 %33)
  %37 = add nuw nsw i64 %32, 1
  %38 = icmp eq i64 %37, %6
  br i1 %38, label %39, label %31, !llvm.loop !13

39:                                               ; preds = %31, %24, %2
  %40 = phi i32 [ 0, %2 ], [ %26, %24 ], [ %36, %31 ]
  ret i32 %40
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare <4 x i32> @llvm.smin.v4i32(<4 x i32>, <4 x i32>) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.vector.reduce.smin.v4i32(<4 x i32>) #1

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: read) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!5 = !{!6, !6, i64 0}
!6 = !{!"int", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = distinct !{!9, !10, !11, !12}
!10 = !{!"llvm.loop.mustprogress"}
!11 = !{!"llvm.loop.isvectorized", i32 1}
!12 = !{!"llvm.loop.unroll.runtime.disable"}
!13 = distinct !{!13, !10, !12, !11}
