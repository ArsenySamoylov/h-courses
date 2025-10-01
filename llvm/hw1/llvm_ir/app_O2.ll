; ModuleID = 'src/app.c'
source_filename = "src/app.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@current = internal unnamed_addr global ptr @buff1, align 8
@next = internal unnamed_addr global ptr @buff2, align 8
@app.isInitted = internal unnamed_addr global i1 false, align 1
@buff1 = internal global [51 x [102 x i32]] zeroinitializer, align 16
@buff2 = internal global [51 x [102 x i32]] zeroinitializer, align 16

; Function Attrs: nounwind uwtable
define dso_local void @init() local_unnamed_addr #0 {
  br label %1

1:                                                ; preds = %0, %4
  %2 = phi i64 [ 0, %0 ], [ %5, %4 ]
  br label %7

3:                                                ; preds = %4
  ret void

4:                                                ; preds = %7
  %5 = add nuw nsw i64 %2, 1
  %6 = icmp eq i64 %5, 51
  br i1 %6, label %3, label %1, !llvm.loop !5

7:                                                ; preds = %1, %7
  %8 = phi i64 [ 0, %1 ], [ %15, %7 ]
  %9 = tail call i32 @simRand() #4
  %10 = srem i32 %9, 100
  %11 = icmp slt i32 %10, 15
  %12 = zext i1 %11 to i32
  %13 = load ptr, ptr @current, align 8, !tbaa !7
  %14 = getelementptr inbounds [51 x [102 x i32]], ptr %13, i64 0, i64 %2, i64 %8
  store i32 %12, ptr %14, align 4, !tbaa !11
  %15 = add nuw nsw i64 %8, 1
  %16 = icmp eq i64 %15, 102
  br i1 %16, label %4, label %7, !llvm.loop !13
}

declare i32 @simRand() local_unnamed_addr #1

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(read, inaccessiblemem: none) uwtable
define dso_local i32 @countNeighbors(i32 noundef %0, i32 noundef %1) local_unnamed_addr #2 {
  %3 = load ptr, ptr @current, align 8
  %4 = add nsw i32 %1, -1
  %5 = zext nneg i32 %4 to i64
  %6 = add nsw i32 %0, -1
  %7 = icmp ult i32 %6, 102
  %8 = add i32 %1, -1
  %9 = icmp ult i32 %8, 51
  %10 = and i1 %7, %9
  br i1 %10, label %11, label %17

11:                                               ; preds = %2
  %12 = zext nneg i32 %6 to i64
  %13 = getelementptr inbounds [51 x [102 x i32]], ptr %3, i64 0, i64 %5, i64 %12
  %14 = load i32, ptr %13, align 4, !tbaa !11
  %15 = icmp ne i32 %14, 0
  %16 = zext i1 %15 to i32
  br label %17

17:                                               ; preds = %2, %11
  %18 = phi i32 [ 0, %2 ], [ %16, %11 ]
  %19 = icmp ult i32 %0, 102
  %20 = add i32 %1, -1
  %21 = icmp ult i32 %20, 51
  %22 = and i1 %19, %21
  br i1 %22, label %23, label %30

23:                                               ; preds = %17
  %24 = zext nneg i32 %0 to i64
  %25 = getelementptr inbounds [51 x [102 x i32]], ptr %3, i64 0, i64 %5, i64 %24
  %26 = load i32, ptr %25, align 4, !tbaa !11
  %27 = icmp ne i32 %26, 0
  %28 = zext i1 %27 to i32
  %29 = add nuw nsw i32 %18, %28
  br label %30

30:                                               ; preds = %17, %23
  %31 = phi i32 [ %18, %17 ], [ %29, %23 ]
  %32 = add nsw i32 %0, 1
  %33 = icmp ult i32 %32, 102
  %34 = add i32 %1, -1
  %35 = icmp ult i32 %34, 51
  %36 = and i1 %33, %35
  br i1 %36, label %37, label %44

37:                                               ; preds = %30
  %38 = zext nneg i32 %32 to i64
  %39 = getelementptr inbounds [51 x [102 x i32]], ptr %3, i64 0, i64 %5, i64 %38
  %40 = load i32, ptr %39, align 4, !tbaa !11
  %41 = icmp ne i32 %40, 0
  %42 = zext i1 %41 to i32
  %43 = add nuw nsw i32 %31, %42
  br label %44

44:                                               ; preds = %30, %37
  %45 = phi i32 [ %31, %30 ], [ %43, %37 ]
  %46 = zext nneg i32 %1 to i64
  %47 = add nsw i32 %0, -1
  %48 = icmp ult i32 %47, 102
  %49 = icmp ult i32 %1, 51
  %50 = and i1 %48, %49
  br i1 %50, label %51, label %58

51:                                               ; preds = %44
  %52 = zext nneg i32 %47 to i64
  %53 = getelementptr inbounds [51 x [102 x i32]], ptr %3, i64 0, i64 %46, i64 %52
  %54 = load i32, ptr %53, align 4, !tbaa !11
  %55 = icmp ne i32 %54, 0
  %56 = zext i1 %55 to i32
  %57 = add nuw nsw i32 %45, %56
  br label %58

58:                                               ; preds = %51, %44
  %59 = phi i32 [ %45, %44 ], [ %57, %51 ]
  %60 = add nsw i32 %0, 1
  %61 = icmp ult i32 %60, 102
  %62 = icmp ult i32 %1, 51
  %63 = and i1 %61, %62
  br i1 %63, label %64, label %71

64:                                               ; preds = %58
  %65 = zext nneg i32 %60 to i64
  %66 = getelementptr inbounds [51 x [102 x i32]], ptr %3, i64 0, i64 %46, i64 %65
  %67 = load i32, ptr %66, align 4, !tbaa !11
  %68 = icmp ne i32 %67, 0
  %69 = zext i1 %68 to i32
  %70 = add nuw nsw i32 %59, %69
  br label %71

71:                                               ; preds = %58, %64
  %72 = phi i32 [ %59, %58 ], [ %70, %64 ]
  %73 = add nsw i32 %1, 1
  %74 = zext nneg i32 %73 to i64
  %75 = add nsw i32 %0, -1
  %76 = icmp ult i32 %75, 102
  %77 = add i32 %1, 1
  %78 = icmp ult i32 %77, 51
  %79 = and i1 %76, %78
  br i1 %79, label %80, label %87

80:                                               ; preds = %71
  %81 = zext nneg i32 %75 to i64
  %82 = getelementptr inbounds [51 x [102 x i32]], ptr %3, i64 0, i64 %74, i64 %81
  %83 = load i32, ptr %82, align 4, !tbaa !11
  %84 = icmp ne i32 %83, 0
  %85 = zext i1 %84 to i32
  %86 = add nuw nsw i32 %72, %85
  br label %87

87:                                               ; preds = %71, %80
  %88 = phi i32 [ %72, %71 ], [ %86, %80 ]
  %89 = icmp ult i32 %0, 102
  %90 = add i32 %1, 1
  %91 = icmp ult i32 %90, 51
  %92 = and i1 %89, %91
  br i1 %92, label %93, label %100

93:                                               ; preds = %87
  %94 = zext nneg i32 %0 to i64
  %95 = getelementptr inbounds [51 x [102 x i32]], ptr %3, i64 0, i64 %74, i64 %94
  %96 = load i32, ptr %95, align 4, !tbaa !11
  %97 = icmp ne i32 %96, 0
  %98 = zext i1 %97 to i32
  %99 = add nuw nsw i32 %88, %98
  br label %100

100:                                              ; preds = %87, %93
  %101 = phi i32 [ %88, %87 ], [ %99, %93 ]
  %102 = add nsw i32 %0, 1
  %103 = icmp ult i32 %102, 102
  %104 = add i32 %1, 1
  %105 = icmp ult i32 %104, 51
  %106 = and i1 %103, %105
  br i1 %106, label %107, label %114

107:                                              ; preds = %100
  %108 = zext nneg i32 %102 to i64
  %109 = getelementptr inbounds [51 x [102 x i32]], ptr %3, i64 0, i64 %74, i64 %108
  %110 = load i32, ptr %109, align 4, !tbaa !11
  %111 = icmp ne i32 %110, 0
  %112 = zext i1 %111 to i32
  %113 = add nuw nsw i32 %101, %112
  br label %114

114:                                              ; preds = %107, %100
  %115 = phi i32 [ %101, %100 ], [ %113, %107 ]
  ret i32 %115
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

declare void @simPutPixel(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: nounwind uwtable
define dso_local void @render() local_unnamed_addr #0 {
  br label %1

1:                                                ; preds = %0, %5
  %2 = phi i64 [ 0, %0 ], [ %6, %5 ]
  %3 = trunc i64 %2 to i32
  br label %8

4:                                                ; preds = %5
  ret void

5:                                                ; preds = %8
  %6 = add nuw nsw i64 %2, 1
  %7 = icmp eq i64 %6, 51
  br i1 %7, label %4, label %1, !llvm.loop !14

8:                                                ; preds = %1, %8
  %9 = phi i64 [ 0, %1 ], [ %16, %8 ]
  %10 = load ptr, ptr @current, align 8, !tbaa !7
  %11 = getelementptr inbounds [51 x [102 x i32]], ptr %10, i64 0, i64 %2, i64 %9
  %12 = load i32, ptr %11, align 4, !tbaa !11
  %13 = icmp eq i32 %12, 0
  %14 = select i1 %13, i32 -1, i32 -16776961
  %15 = trunc i64 %9 to i32
  tail call void @drawCell(i32 noundef %15, i32 noundef %3, i32 noundef %14)
  %16 = add nuw nsw i64 %9, 1
  %17 = icmp eq i64 %16, 102
  br i1 %17, label %5, label %8, !llvm.loop !15
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: none) uwtable
define dso_local void @update() local_unnamed_addr #3 {
  %1 = load ptr, ptr @current, align 8, !tbaa !7
  %2 = load ptr, ptr @next, align 8
  br label %3

3:                                                ; preds = %0, %7
  %4 = phi i64 [ 0, %0 ], [ %8, %7 ]
  %5 = trunc i64 %4 to i32
  br label %10

6:                                                ; preds = %7
  store ptr %2, ptr @current, align 8, !tbaa !7
  store ptr %1, ptr @next, align 8, !tbaa !7
  ret void

7:                                                ; preds = %24
  %8 = add nuw nsw i64 %4, 1
  %9 = icmp eq i64 %8, 51
  br i1 %9, label %6, label %3, !llvm.loop !16

10:                                               ; preds = %3, %24
  %11 = phi i64 [ 0, %3 ], [ %27, %24 ]
  %12 = trunc i64 %11 to i32
  %13 = tail call i32 @countNeighbors(i32 noundef %12, i32 noundef %5)
  %14 = getelementptr inbounds [51 x [102 x i32]], ptr %1, i64 0, i64 %4, i64 %11
  %15 = load i32, ptr %14, align 4, !tbaa !11
  %16 = icmp eq i32 %15, 0
  br i1 %16, label %17, label %20

17:                                               ; preds = %10
  %18 = icmp eq i32 %13, 3
  %19 = zext i1 %18 to i32
  br label %24

20:                                               ; preds = %10
  %21 = add i32 %13, -4
  %22 = icmp ult i32 %21, -2
  %23 = select i1 %22, i32 0, i32 %15
  br label %24

24:                                               ; preds = %20, %17
  %25 = phi i32 [ %19, %17 ], [ %23, %20 ]
  %26 = getelementptr inbounds [51 x [102 x i32]], ptr %2, i64 0, i64 %4, i64 %11
  store i32 %25, ptr %26, align 4
  %27 = add nuw nsw i64 %11, 1
  %28 = icmp eq i64 %27, 102
  br i1 %28, label %7, label %10, !llvm.loop !17
}

; Function Attrs: nounwind uwtable
define dso_local void @app() local_unnamed_addr #0 {
  %1 = load i1, ptr @app.isInitted, align 1
  br i1 %1, label %2, label %4

2:                                                ; preds = %0
  %3 = load ptr, ptr @current, align 8, !tbaa !7
  br label %20

4:                                                ; preds = %0, %6
  %5 = phi i64 [ %7, %6 ], [ 0, %0 ]
  br label %9

6:                                                ; preds = %9
  %7 = add nuw nsw i64 %5, 1
  %8 = icmp eq i64 %7, 51
  br i1 %8, label %19, label %4, !llvm.loop !5

9:                                                ; preds = %9, %4
  %10 = phi i64 [ 0, %4 ], [ %17, %9 ]
  %11 = tail call i32 @simRand() #4
  %12 = srem i32 %11, 100
  %13 = icmp slt i32 %12, 15
  %14 = zext i1 %13 to i32
  %15 = load ptr, ptr @current, align 8, !tbaa !7
  %16 = getelementptr inbounds [51 x [102 x i32]], ptr %15, i64 0, i64 %5, i64 %10
  store i32 %14, ptr %16, align 4, !tbaa !11
  %17 = add nuw nsw i64 %10, 1
  %18 = icmp eq i64 %17, 102
  br i1 %18, label %6, label %9, !llvm.loop !13

19:                                               ; preds = %6
  store i1 true, ptr @app.isInitted, align 1
  br label %20

20:                                               ; preds = %2, %19
  %21 = phi ptr [ %3, %2 ], [ %15, %19 ]
  %22 = load ptr, ptr @next, align 8
  br label %23

23:                                               ; preds = %26, %20
  %24 = phi i64 [ 0, %20 ], [ %27, %26 ]
  %25 = trunc i64 %24 to i32
  br label %29

26:                                               ; preds = %43
  %27 = add nuw nsw i64 %24, 1
  %28 = icmp eq i64 %27, 51
  br i1 %28, label %48, label %23, !llvm.loop !16

29:                                               ; preds = %43, %23
  %30 = phi i64 [ 0, %23 ], [ %46, %43 ]
  %31 = trunc i64 %30 to i32
  %32 = tail call i32 @countNeighbors(i32 noundef %31, i32 noundef %25)
  %33 = getelementptr inbounds [51 x [102 x i32]], ptr %21, i64 0, i64 %24, i64 %30
  %34 = load i32, ptr %33, align 4, !tbaa !11
  %35 = icmp eq i32 %34, 0
  br i1 %35, label %36, label %39

36:                                               ; preds = %29
  %37 = icmp eq i32 %32, 3
  %38 = zext i1 %37 to i32
  br label %43

39:                                               ; preds = %29
  %40 = add i32 %32, -4
  %41 = icmp ult i32 %40, -2
  %42 = select i1 %41, i32 0, i32 %34
  br label %43

43:                                               ; preds = %39, %36
  %44 = phi i32 [ %38, %36 ], [ %42, %39 ]
  %45 = getelementptr inbounds [51 x [102 x i32]], ptr %22, i64 0, i64 %24, i64 %30
  store i32 %44, ptr %45, align 4
  %46 = add nuw nsw i64 %30, 1
  %47 = icmp eq i64 %46, 102
  br i1 %47, label %26, label %29, !llvm.loop !17

48:                                               ; preds = %26
  store ptr %22, ptr @current, align 8, !tbaa !7
  store ptr %21, ptr @next, align 8, !tbaa !7
  br label %49

49:                                               ; preds = %52, %48
  %50 = phi i64 [ 0, %48 ], [ %53, %52 ]
  %51 = trunc i64 %50 to i32
  br label %55

52:                                               ; preds = %55
  %53 = add nuw nsw i64 %50, 1
  %54 = icmp eq i64 %53, 51
  br i1 %54, label %65, label %49, !llvm.loop !14

55:                                               ; preds = %55, %49
  %56 = phi i64 [ 0, %49 ], [ %63, %55 ]
  %57 = load ptr, ptr @current, align 8, !tbaa !7
  %58 = getelementptr inbounds [51 x [102 x i32]], ptr %57, i64 0, i64 %50, i64 %56
  %59 = load i32, ptr %58, align 4, !tbaa !11
  %60 = icmp eq i32 %59, 0
  %61 = select i1 %60, i32 -1, i32 -16776961
  %62 = trunc i64 %56 to i32
  tail call void @drawCell(i32 noundef %62, i32 noundef %51, i32 noundef %61)
  %63 = add nuw nsw i64 %56, 1
  %64 = icmp eq i64 %63, 102
  br i1 %64, label %52, label %55, !llvm.loop !15

65:                                               ; preds = %52
  ret void
}

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { mustprogress nofree norecurse nosync nounwind willreturn memory(read, inaccessiblemem: none) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: none) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
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
!8 = !{!"any pointer", !9, i64 0}
!9 = !{!"omnipotent char", !10, i64 0}
!10 = !{!"Simple C/C++ TBAA"}
!11 = !{!12, !12, i64 0}
!12 = !{!"int", !9, i64 0}
!13 = distinct !{!13, !6}
!14 = distinct !{!14, !6}
!15 = distinct !{!15, !6}
!16 = distinct !{!16, !6}
!17 = distinct !{!17, !6}
