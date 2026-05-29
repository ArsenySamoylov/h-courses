define i32 @smin(ptr %arr, i32 %size) {
entry:
  %empty = icmp eq i32 %size, 0
  br i1 %empty, label %ret0, label %loop.header

ret0:
  ret i32 0

loop.header:
  %min0ptr = getelementptr i32, ptr %arr, i32 0
  %min0 = load i32, ptr %min0ptr
  br label %loop

loop:
  %i = phi i32 [0, %loop.header],
                 [%nexti, %merge]

  %min = phi i32 [%min0, %loop.header],
                   [%newmin, %merge]

  %cond = icmp i32 %i, %size
  br i1 %cond, label %body, label %exit

body:
  %elemPtr = getelementptr i32, ptr %arr, i32 %i
  %elem = load i32, ptr %elemPtr

  %less = icmp i32 %elem, %min
  br i1 %less, label %take, label %skip

take:
  br label %merge

skip:
  br label %merge

merge:
  %newmin = phi i32 [%elem, %take],
                     [%min, %skip]

  %nexti = add i32 %i, 1
  br label %loop

exit:
  ret i32 %min
}