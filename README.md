# Synchronous FIFO in Verilog

## Overview
This project implements an 8-depth, 8-bit Synchronous FIFO (First In First Out) memory in Verilog along with a comprehensive testbench.

The FIFO uses:
- Single clock for both read and write operations
- Circular buffer architecture
- Separate read and write pointers
- Full and Empty detection logic

---

# FIFO Architecture

The FIFO consists of:
- Memory Array
- Write Pointer (`wptr`)
- Read Pointer (`rptr`)
- Full and Empty Detection Logic

---

# FIFO Parameters

| Parameter | Value |
|---|---|
| Data Width | 8 bits |
| FIFO Depth | 8 locations |
| Pointer Width | 4 bits |
| Clock Type | Synchronous |

---

# Working Principle

## Write Operation
When:
- `write_en = 1`
- FIFO is not full

Data is written into:
```verilog
r[wptr[2:0]]
```

After writing:
```verilog
wptr <= wptr + 1;
```

---

## Read Operation
When:
- `read_en = 1`
- FIFO is not empty

Data is read from:
```verilog
r[rptr[2:0]]
```

After reading:
```verilog
rptr <= rptr + 1;
```

---

# Full and Empty Detection

## FIFO Empty Condition
```verilog
wptr == rptr
```

## FIFO Full Condition
```verilog
wptr[2:0] == rptr[2:0] &&
wptr[3] != rptr[3]
```

---

# Features

- Synchronous FIFO Design
- Circular Buffer Implementation
- Full and Empty Status Flags
- Overflow Protection
- Underflow Protection
- Simultaneous Read/Write Support
- Reset Initialization
- Verification using Testbench

---

# Testbench Description

The testbench verifies all major FIFO operations.

## Test Cases Covered

### 1. Reset Test
- Verifies FIFO becomes empty after reset

### 2. Write Until Full
- Writes data continuously until FIFO becomes full

### 3. Overflow Test
- Attempts write operation after FIFO is full

### 4. Read Until Empty
- Reads all stored data and verifies FIFO order

### 5. Underflow Test
- Attempts read operation when FIFO is empty

### 6. Simultaneous Read and Write
- Tests concurrent read/write operation in same clock cycle

---

# Simulation Output Example

```text
T=50 | WE=1 RE=0 | DIN=15 | DOUT=0 | FULL=0 EMPTY=0
```

---

# Files Included

| File | Description |
|---|---|
| `fifo.v` | Synchronous FIFO design |
| `fifo_tb.v` | FIFO verification testbench |
| `fifo_all_cases.vcd` | Waveform dump file |

---

# Applications

- Data Buffering
- UART Communication
- Processor Pipelines
- ADC/DAC Interfaces
- FPGA and ASIC Designs

---

# Conclusion

This project demonstrates the design and verification of a synchronous FIFO using Verilog. The FIFO successfully supports read/write operations, overflow and underflow protection, and simultaneous read/write functionality using pointer-based control logic.
