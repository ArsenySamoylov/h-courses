define i32 @smin(ptr %arr, i32 %size) {
entry:
  %min = alloca i32
  %i = alloca i32

  %empty = icmp eq i32 %size, 0
  br i1 %empty, label %ret0, label %init

ret0:
  ret i32 0

init:
  %firstptr = getelementptr i32, ptr %arr, i32 0
  %first = load i32, ptr %firstptr
  store i32 %first, ptr %min

  store i32 0, ptr %i
  br label %loop

loop:
  %iv = load i32, ptr %i
  %cond = icmp ult i32 %iv, %size
  br i1 %cond, label %body, label %exit

body:
  %elemPtr = getelementptr i32, ptr %arr, i32 %iv
  %elem = load i32, ptr %elemPtr

  %curMin = load i32, ptr %min
  %cmp = icmp i32 %elem, %curMin

  br i1 %cmp, label %update, label %next

update:
  store i32 %elem, ptr %min
  br label %next

next:
  %oldi = load i32, ptr %i
  %newi = add i32 %oldi, 1
  store i32 %newi, ptr %i
  br label %loop

exit:
  %ans = load i32, ptr %min
  ret i32 %ans
}

