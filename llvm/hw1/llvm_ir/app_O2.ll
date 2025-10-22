; ModuleID = 'src/app.c'
source_filename = "src/app.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nounwind uwtable
define dso_local void @init(ptr nocapture noundef writeonly %0) local_unnamed_addr #0 {
  br label %2

2:                                                ; preds = %1, %5
  %3 = phi i64 [ 0, %1 ], [ %6, %5 ]
  br label %8

4:                                                ; preds = %5
  ret void

5:                                                ; preds = %8
  %6 = add nuw nsw i64 %3, 1
  %7 = icmp eq i64 %6, 51
  br i1 %7, label %4, label %2, !llvm.loop !5

8:                                                ; preds = %2, %8
  %9 = phi i64 [ 0, %2 ], [ %15, %8 ]
  %10 = tail call i32 @simRand() #4
  %11 = srem i32 %10, 100
  %12 = icmp slt i32 %11, 15
  %13 = zext i1 %12 to i32
  %14 = getelementptr inbounds [102 x i32], ptr %0, i64 %3, i64 %9
  store i32 %13, ptr %14, align 4, !tbaa !7
  %15 = add nuw nsw i64 %9, 1
  %16 = icmp eq i64 %15, 102
  br i1 %16, label %5, label %8, !llvm.loop !11
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

declare i32 @simRand() local_unnamed_addr #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @countNeighbors(i32 noundef %0, i32 noundef %1, ptr nocapture noundef readnone %2) local_unnamed_addr #0 {
  %4 = tail call i32 @simRand() #4
  %5 = srem i32 %4, 4
  ret i32 %5
}

; Function Attrs: nounwind uwtable
define dso_local void @drawCell(i32 noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = mul nsw i32 %0, 5
  %5 = mul nsw i32 %1, 5
  tail call void @simPutPixel(i32 noundef %4, i32 noundef %5, i32 noundef %2) #4
  %6 = add nsw i32 %5, 1
  tail call void @simPutPixel(i32 noundef %4, i32 noundef %6, i32 noundef %2) #4
  %7 = add nsw i32 %5, 2
  tail call void @simPutPixel(i32 noundef %4, i32 noundef %7, i32 noundef %2) #4
  %8 = add nsw i32 %5, 3
  tail call void @simPutPixel(i32 noundef %4, i32 noundef %8, i32 noundef %2) #4
  %9 = add nsw i32 %5, 4
  tail call void @simPutPixel(i32 noundef %4, i32 noundef %9, i32 noundef %2) #4
  %10 = add nsw i32 %4, 1
  tail call void @simPutPixel(i32 noundef %10, i32 noundef %5, i32 noundef %2) #4
  tail call void @simPutPixel(i32 noundef %10, i32 noundef %6, i32 noundef %2) #4
  tail call void @simPutPixel(i32 noundef %10, i32 noundef %7, i32 noundef %2) #4
  tail call void @simPutPixel(i32 noundef %10, i32 noundef %8, i32 noundef %2) #4
  tail call void @simPutPixel(i32 noundef %10, i32 noundef %9, i32 noundef %2) #4
  %11 = add nsw i32 %4, 2
  tail call void @simPutPixel(i32 noundef %11, i32 noundef %5, i32 noundef %2) #4
  tail call void @simPutPixel(i32 noundef %11, i32 noundef %6, i32 noundef %2) #4
  tail call void @simPutPixel(i32 noundef %11, i32 noundef %7, i32 noundef %2) #4
  tail call void @simPutPixel(i32 noundef %11, i32 noundef %8, i32 noundef %2) #4
  tail call void @simPutPixel(i32 noundef %11, i32 noundef %9, i32 noundef %2) #4
  %12 = add nsw i32 %4, 3
  tail call void @simPutPixel(i32 noundef %12, i32 noundef %5, i32 noundef %2) #4
  tail call void @simPutPixel(i32 noundef %12, i32 noundef %6, i32 noundef %2) #4
  tail call void @simPutPixel(i32 noundef %12, i32 noundef %7, i32 noundef %2) #4
  tail call void @simPutPixel(i32 noundef %12, i32 noundef %8, i32 noundef %2) #4
  tail call void @simPutPixel(i32 noundef %12, i32 noundef %9, i32 noundef %2) #4
  %13 = add nsw i32 %4, 4
  tail call void @simPutPixel(i32 noundef %13, i32 noundef %5, i32 noundef %2) #4
  tail call void @simPutPixel(i32 noundef %13, i32 noundef %6, i32 noundef %2) #4
  tail call void @simPutPixel(i32 noundef %13, i32 noundef %7, i32 noundef %2) #4
  tail call void @simPutPixel(i32 noundef %13, i32 noundef %8, i32 noundef %2) #4
  tail call void @simPutPixel(i32 noundef %13, i32 noundef %9, i32 noundef %2) #4
  ret void
}

declare void @simPutPixel(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: nounwind uwtable
define dso_local void @render(ptr nocapture noundef readonly %0) local_unnamed_addr #0 {
  br label %2

2:                                                ; preds = %1, %6
  %3 = phi i64 [ 0, %1 ], [ %7, %6 ]
  %4 = trunc i64 %3 to i32
  br label %9

5:                                                ; preds = %6
  ret void

6:                                                ; preds = %9
  %7 = add nuw nsw i64 %3, 1
  %8 = icmp eq i64 %7, 51
  br i1 %8, label %5, label %2, !llvm.loop !12

9:                                                ; preds = %2, %9
  %10 = phi i64 [ 0, %2 ], [ %16, %9 ]
  %11 = getelementptr inbounds [102 x i32], ptr %0, i64 %3, i64 %10
  %12 = load i32, ptr %11, align 4, !tbaa !7
  %13 = icmp eq i32 %12, 0
  %14 = select i1 %13, i32 -1, i32 -16776961
  %15 = trunc i64 %10 to i32
  tail call void @drawCell(i32 noundef %15, i32 noundef %4, i32 noundef %14)
  %16 = add nuw nsw i64 %10, 1
  %17 = icmp eq i64 %16, 102
  br i1 %17, label %6, label %9, !llvm.loop !13
}

; Function Attrs: nounwind uwtable
define dso_local void @update(ptr nocapture noundef readonly %0, ptr nocapture noundef writeonly %1) local_unnamed_addr #0 {
  br label %3

3:                                                ; preds = %2, %6
  %4 = phi i64 [ 0, %2 ], [ %7, %6 ]
  br label %9

5:                                                ; preds = %6
  ret void

6:                                                ; preds = %9
  %7 = add nuw nsw i64 %4, 1
  %8 = icmp eq i64 %7, 51
  br i1 %8, label %5, label %3, !llvm.loop !14

9:                                                ; preds = %3, %9
  %10 = phi i64 [ 0, %3 ], [ %22, %9 ]
  %11 = tail call i32 @simRand() #4
  %12 = srem i32 %11, 4
  %13 = getelementptr inbounds [102 x i32], ptr %0, i64 %4, i64 %10
  %14 = load i32, ptr %13, align 4, !tbaa !7
  %15 = icmp eq i32 %14, 0
  %16 = icmp eq i32 %12, 3
  %17 = zext i1 %16 to i32
  %18 = icmp slt i32 %12, 2
  %19 = select i1 %18, i32 0, i32 %14
  %20 = select i1 %15, i32 %17, i32 %19
  %21 = getelementptr inbounds [102 x i32], ptr %1, i64 %4, i64 %10
  store i32 %20, ptr %21, align 4
  %22 = add nuw nsw i64 %10, 1
  %23 = icmp eq i64 %22, 102
  br i1 %23, label %6, label %9, !llvm.loop !15
}

; Function Attrs: nounwind uwtable
define dso_local void @app() local_unnamed_addr #0 {
  %1 = alloca [51 x [102 x i32]], align 16
  %2 = alloca [51 x [102 x i32]], align 16
  call void @llvm.lifetime.start.p0(i64 20808, ptr nonnull %1) #4
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(20808) %1, i8 0, i64 20808, i1 false)
  call void @llvm.lifetime.start.p0(i64 20808, ptr nonnull %2) #4
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(20808) %2, i8 0, i64 20808, i1 false)
  br label %3

3:                                                ; preds = %5, %0
  %4 = phi i64 [ 0, %0 ], [ %6, %5 ]
  br label %8

5:                                                ; preds = %8
  %6 = add nuw nsw i64 %4, 1
  %7 = icmp eq i64 %6, 51
  br i1 %7, label %17, label %3, !llvm.loop !5

8:                                                ; preds = %8, %3
  %9 = phi i64 [ 0, %3 ], [ %15, %8 ]
  %10 = tail call i32 @simRand() #4
  %11 = srem i32 %10, 100
  %12 = icmp slt i32 %11, 15
  %13 = zext i1 %12 to i32
  %14 = getelementptr inbounds [102 x i32], ptr %1, i64 %4, i64 %9
  store i32 %13, ptr %14, align 4, !tbaa !7
  %15 = add nuw nsw i64 %9, 1
  %16 = icmp eq i64 %15, 102
  br i1 %16, label %5, label %8, !llvm.loop !11

17:                                               ; preds = %5, %55
  %18 = phi ptr [ %19, %55 ], [ %2, %5 ]
  %19 = phi ptr [ %18, %55 ], [ %1, %5 ]
  br label %20

20:                                               ; preds = %22, %17
  %21 = phi i64 [ 0, %17 ], [ %23, %22 ]
  br label %25

22:                                               ; preds = %25
  %23 = add nuw nsw i64 %21, 1
  %24 = icmp eq i64 %23, 51
  br i1 %24, label %40, label %20, !llvm.loop !14

25:                                               ; preds = %25, %20
  %26 = phi i64 [ 0, %20 ], [ %38, %25 ]
  %27 = tail call i32 @simRand() #4
  %28 = srem i32 %27, 4
  %29 = getelementptr inbounds [102 x i32], ptr %19, i64 %21, i64 %26
  %30 = load i32, ptr %29, align 4, !tbaa !7
  %31 = icmp eq i32 %30, 0
  %32 = icmp eq i32 %28, 3
  %33 = zext i1 %32 to i32
  %34 = icmp slt i32 %28, 2
  %35 = select i1 %34, i32 0, i32 %30
  %36 = select i1 %31, i32 %33, i32 %35
  %37 = getelementptr inbounds [102 x i32], ptr %18, i64 %21, i64 %26
  store i32 %36, ptr %37, align 4
  %38 = add nuw nsw i64 %26, 1
  %39 = icmp eq i64 %38, 102
  br i1 %39, label %22, label %25, !llvm.loop !15

40:                                               ; preds = %22, %43
  %41 = phi i64 [ %44, %43 ], [ 0, %22 ]
  %42 = trunc i64 %41 to i32
  br label %46

43:                                               ; preds = %46
  %44 = add nuw nsw i64 %41, 1
  %45 = icmp eq i64 %44, 51
  br i1 %45, label %55, label %40, !llvm.loop !12

46:                                               ; preds = %46, %40
  %47 = phi i64 [ 0, %40 ], [ %53, %46 ]
  %48 = getelementptr inbounds [102 x i32], ptr %18, i64 %41, i64 %47
  %49 = load i32, ptr %48, align 4, !tbaa !7
  %50 = icmp eq i32 %49, 0
  %51 = select i1 %50, i32 -1, i32 -16776961
  %52 = trunc i64 %47 to i32
  tail call void @drawCell(i32 noundef %52, i32 noundef %42, i32 noundef %51)
  %53 = add nuw nsw i64 %47, 1
  %54 = icmp eq i64 %53, 102
  br i1 %54, label %43, label %46, !llvm.loop !13

55:                                               ; preds = %43
  %56 = tail call i32 @simFlush() #4
  %57 = icmp eq i32 %56, 0
  br i1 %57, label %17, label %58, !llvm.loop !16

58:                                               ; preds = %55
  call void @llvm.lifetime.end.p0(i64 20808, ptr nonnull %2) #4
  call void @llvm.lifetime.end.p0(i64 20808, ptr nonnull %1) #4
  ret void
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #3

declare i32 @simFlush() local_unnamed_addr #2

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!5 = distinct !{!5, !6}
!6 = !{!"llvm.loop.mustprogress"}
!7 = !{!8, !8, i64 0}
!8 = !{!"int", !9, i64 0}
!9 = !{!"omnipotent char", !10, i64 0}
!10 = !{!"Simple C/C++ TBAA"}
!11 = distinct !{!11, !6}
!12 = distinct !{!12, !6}
!13 = distinct !{!13, !6}
!14 = distinct !{!14, !6}
!15 = distinct !{!15, !6}
!16 = distinct !{!16, !6}
