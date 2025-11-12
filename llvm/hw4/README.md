# **ISA Description**

## **Instruction Set**

### **Arithmetic Instructions**
| Instruction | Format | Description |
|------------|--------|----------|
| `XOR` | `XOR rd rs1 rs2` | Bitwise EXCLUSIVE OR |
| `MUL` | `MUL rd rs1 imm` | Multiplication (immediate only) |
| `ADD` | `ADD rd rs1 imm` | Addition (immediate only) |

### **Comparison Operations**
| Instruction | Format | Description |
|------------|--------|----------|
| `CMP` | `CMP rd rs1 imm` | Equality comparison |

### **Graphics Instructions**
| Instruction | Format | Description |
|------------|--------|----------|
| `PUT_CELL` | `PUT_CELL rx ry color` | Draw 4x1 pixel cell |
| `RAND_COLOR` | `RAND_COLOR rd` | Random color generation |
| `FLUSH` | `FLUSH` | Display refresh |

### **Flow Control Instructions**
| Instruction | Format | Description |
|------------|--------|----------|
| `B` | `B label` | Unconditional branch |
| `BR_COND` | `BR_COND rcond label_true label_false` | Conditional branch |

### **Special Instructions**
| Instruction | Format | Description |
|------------|--------|----------|
| `EXIT` | `EXIT` | Program termination |