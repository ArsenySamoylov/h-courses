; ModuleID = 'app/app.c'
source_filename = "app/app.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noreturn nounwind uwtable
define dso_local void @app() local_unnamed_addr #0 {
  br label %1

1:                                                ; preds = %13, %0
  %2 = phi i32 [ 0, %0 ], [ %14, %13 ]
  %3 = mul nuw nsw i32 %2, 5
  %4 = add nuw nsw i32 %3, 1
  %5 = add nuw nsw i32 %3, 2
  %6 = add nuw nsw i32 %3, 3
  %7 = add nuw nsw i32 %3, 4
  br label %15

8:                                                ; preds = %10
  %9 = tail call i32 @simFlush() #2
  br label %13

10:                                               ; preds = %15
  %11(x2) = add nuw nsw i32 %2, 1
  %12 = icmp eq i32 %11, 51
  br i1 %12, label %8, label %13

13:                                               ; preds = %10, %8
  %14(x2) = phi i32 [ %11, %10 ], [ 0, %8 ]
  br label %1, !llvm.loop !5

15:                                               ; preds = %1, %15
  %16(x8) = phi i32 [ 0, %1 ], [ %26, %15 ]

  %17(x9) = tail call i32 @simRand() #2
  %18 = and i32 %17, 1
  %19 = icmp eq i32 %18, 0
  %20 = select i1 %19, i32 -1, i32 -16776961
  ^ Get random color in x9


  %21(x10) = mul nuw nsw i32 %16, 5
  tail call void @simPutPixel(i32 noundef %21, i32 noundef %3, i32 noundef %20) #2
  tail call void @simPutPixel(i32 noundef %21, i32 noundef %4, i32 noundef %20) #2
  tail call void @simPutPixel(i32 noundef %21, i32 noundef %5, i32 noundef %20) #2
  tail call void @simPutPixel(i32 noundef %21, i32 noundef %6, i32 noundef %20) #2
  tail call void @simPutPixel(i32 noundef %21, i32 noundef %7, i32 noundef %20) #2
  ^- multi call

  %22 = add nuw nsw i32 %21, 1
  tail call void @simPutPixel(i32 noundef %22, i32 noundef %3, i32 noundef %20) #2
  tail call void @simPutPixel(i32 noundef %22, i32 noundef %4, i32 noundef %20) #2
  tail call void @simPutPixel(i32 noundef %22, i32 noundef %5, i32 noundef %20) #2
  tail call void @simPutPixel(i32 noundef %22, i32 noundef %6, i32 noundef %20) #2
  tail call void @simPutPixel(i32 noundef %22, i32 noundef %7, i32 noundef %20) #2

  %23 = add nuw nsw i32 %21, 2
  tail call void @simPutPixel(i32 noundef %23, i32 noundef %3, i32 noundef %20) #2
  tail call void @simPutPixel(i32 noundef %23, i32 noundef %4, i32 noundef %20) #2
  tail call void @simPutPixel(i32 noundef %23, i32 noundef %5, i32 noundef %20) #2
  tail call void @simPutPixel(i32 noundef %23, i32 noundef %6, i32 noundef %20) #2
  tail call void @simPutPixel(i32 noundef %23, i32 noundef %7, i32 noundef %20) #2

  %24 = add nuw nsw i32 %21, 3
  tail call void @simPutPixel(i32 noundef %24, i32 noundef %3, i32 noundef %20) #2
  tail call void @simPutPixel(i32 noundef %24, i32 noundef %4, i32 noundef %20) #2
  tail call void @simPutPixel(i32 noundef %24, i32 noundef %5, i32 noundef %20) #2
  tail call void @simPutPixel(i32 noundef %24, i32 noundef %6, i32 noundef %20) #2
  tail call void @simPutPixel(i32 noundef %24, i32 noundef %7, i32 noundef %20) #2

  %25 = add nuw nsw i32 %21, 4
  tail call void @simPutPixel(i32 noundef %25, i32 noundef %3, i32 noundef %20) #2
  tail call void @simPutPixel(i32 noundef %25, i32 noundef %4, i32 noundef %20) #2
  tail call void @simPutPixel(i32 noundef %25, i32 noundef %5, i32 noundef %20) #2
  tail call void @simPutPixel(i32 noundef %25, i32 noundef %6, i32 noundef %20) #2
  tail call void @simPutPixel(i32 noundef %25, i32 noundef %7, i32 noundef %20) #2
  %26(x8) = add nuw nsw i32 %16, 1
  %27 = icmp eq i32 %26, 102
  br i1 %27, label %10, label %15, !llvm.loop !7
}

declare i32 @simRand() local_unnamed_addr #1

declare void @simPutPixel(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

declare i32 @simFlush() local_unnamed_addr #1

attributes #0 = { noreturn nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!5 = distinct !{!5, !6}
!6 = !{!"llvm.loop.mustprogress"}
!7 = distinct !{!7, !6}
