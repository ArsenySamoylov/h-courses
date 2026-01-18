## ANTLR-4
In ubuntu apt files (at least on my machine) there are conflicting versions for antlr generator and dev library. This proved to be a major pain in the ass.
To address this problem I had to manually install correct dev library version from Debian packages website.

Here is what worked for me:

First install dependency for dev library: https://packages.debian.org/trixie/libantlr4-runtime4.9 

Then dev library: https://packages.debian.org/trixie/libantlr4-runtime-dev

Generator version (from apt): ANTLR Parser Generator  Version 4.9.2

Big thanks to [@Vladislave0-0](https://github.com/Vladislave0-0) and [@aleksplast](https://github.com/aleksplast) for pointing out for the problem.  

## Language
This language is inspired by Golang and is intended to be a small, minimal subset of it. The goal is not full Go compatibility, but rather a clean and simple language suitable for experimenting with parsing, semantic analysis, and LLVM-based code generation. It supports basic control flow, expressions, variables, functions, and primitive types, while intentionally omitting more complex Go features. The language is designed to be easy to extend as new features are added over time.

## Examples

You can find more examples in the `examples/` directory.
Below are some minimal programs demonstrating supported language features.

---

### 1. Hello-world–style minimal program

```go
func main() {
}
```

---

### 2. Global constant

```go
const answer = 42

func main() {
}
```

---

### 3. Variable declaration and assignment

```go
func main() {
    var x int = 10
    x = x + 5
}
```

---

### 4. Integer arithmetic

```go
func main() {
    var a int = 10
    var b int = 3

    var c int
    c = a + b
    c = a - b
    c = a * b
    c = a / b
    c = a % b
}
```

---

### 5. Hexadecimal literals

```go
func main() {
    var color int = 0xFF0000FF
}
```

---

### 6. Boolean values and comparisons

```go
func main() {
    var x int = 10
    var y int = 20

    var b bool
    b = x < y
    b = x > y
    b = x == y
}
```

---

### 7. If / else

```go
func main() {
    var x int = 10

    if x > 5 {
        x = x + 1
    } else {
        x = x - 1
    }
}
```

---

### 8. For loop

```go
func main() {
    var x int = 0

    for x < 10 {
        x = x + 1
    }
}
```

---

### 9. Function calls

```go
func foo() {
}

func main() {
    foo()
}
```

### 10. Expression statements

```go
func main() {
    1 + 2 * 3
    (4 + 5) * 6
}
```

---

## Notes & Limitations

* Unary expressions (e.g. `-x`) are **planned** but not fully supported yet
* Constants are currently **global only**
* No user-defined types
* No arrays or structs

