# 💼 Employee Salary Management System (ESMS)

> A console-based payroll management application written in **x86 MASM Assembly** using the Irvine32 library.

---

## 👥 Authors

| Name |
|------|
| [Mohammad Shaqboua](https://github.com/Mohammadshaqboua) |
| [Mohammad Dawas](https://github.com/DAWAS00) |
| [Husam Ziadeh](https://github.com/husamziadeh2005) |

---

## 📋 Overview

ESMS is a fully functional employee payroll system built in low-level x86 Assembly. It supports storing up to **50 employee records**, performs full input validation, calculates net salaries, and generates detailed pay slips and department statistics — all through a clean console menu.

---

## ✨ Features

- **Add Employees** — Capture name, ID, department, salary, allowances, and deductions with full validation
- **Pay Slip Display** — Formatted pay slip with tax bracket classification per employee
- **Department Statistics** — Per-department count, total payroll, min/max salary
- **Salary Histogram** — Visual star-based distribution across 5 salary brackets
- **Input Validation** — All fields are range-checked with error messages on bad input

---

## 🖥️ Main Menu

When you run the program, you'll see the following console menu:

```
============================================
   Employee Salary Management System
============================================
 [1] Add Employee
 [2] Display Pay Slip
 [3] Department Statistics
 [4] Salary Histogram
 [5] Exit
============================================
Enter your choice:
```

Navigate by typing the option number and pressing **Enter**.

---

## 🗂️ Record Structure

Each employee record is **44 bytes**, stored in a flat array:

| Offset | Size | Field |
|--------|------|-------|
| 0 | 20 bytes | Name (string) |
| 20 | 4 bytes | Employee ID (DWORD) |
| 24 | 1 byte | Department Code (BYTE) |
| 28 | 4 bytes | Basic Salary (DWORD) |
| 32 | 4 bytes | Allowances (DWORD) |
| 36 | 4 bytes | Deductions (DWORD) |
| 40 | 4 bytes | Net Salary (DWORD) |

> **Memory layout:** Records are stored contiguously in a static array (`employees` buffer). The index into a record is calculated as `index × 44`.

---

## ✅ Validation Rules

| Field | Valid Range | Error Behavior |
|-------|-------------|----------------|
| Employee ID | 100000 – 999999 (6 digits) | Re-prompts with error message |
| Department | 1 – 5 | Re-prompts with error message |
| Basic Salary | 500 – 20,000 JOD | Re-prompts with error message |
| Allowances | 0 – 5,000 JOD | Re-prompts with error message |
| Deductions | 0 – 3,000 JOD | Re-prompts with error message |

---

## 💰 Salary Formula

```
Net Salary = Basic Salary + Allowances - Deductions
```

Net salary is computed at the time of adding the employee and stored directly in the record.

---

## 📊 Tax Brackets

| Bracket | Net Salary Range | Description |
|---------|-----------------|-------------|
| 1 | < 500 JOD | Below minimum wage threshold |
| 2 | 500 – 999 JOD | Entry level |
| 3 | 1,000 – 1,499 JOD | Mid range |
| 4 | 1,500 – 1,999 JOD | Senior range |
| 5 | ≥ 2,000 JOD | Top bracket |

Brackets are displayed on each employee's pay slip for payroll classification purposes.

---

## 🏢 Department Codes

| Code | Department |
|------|------------|
| 1 | HR |
| 2 | Engineering |
| 3 | Finance |
| 4 | Marketing |
| 5 | Operations |

---

## 📄 Sample Pay Slip Output

```
============================================
              EMPLOYEE PAY SLIP
============================================
Name          : Ahmad Al-Khalidi
Employee ID   : 204512
Department    : Engineering
--------------------------------------------
Basic Salary  :   1500 JOD
Allowances    :    300 JOD
Deductions    :    100 JOD
--------------------------------------------
NET SALARY    :   1700 JOD
Tax Bracket   : 4
============================================
```

---

## 📈 Sample Histogram Output

```
Salary Distribution
===================
< 500       : **
500-999     : ****
1000-1499   : *******
1500-1999   : ***
>= 2000     : *
```

Each `*` represents one employee in that salary bracket.

---

## 🛠️ Requirements

| Requirement | Details |
|-------------|---------|
| Assembler | MASM (Microsoft Macro Assembler) |
| Library | [Irvine32](http://asmirvine.com/) — must be installed and linked |
| OS | Windows (32-bit or 32-bit compatible mode) |
| IDE | Visual Studio 2019+ or any MASM-compatible build environment |

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/your-username/esms-assembly.git
cd esms-assembly
```

### 2. Set up Irvine32

Download and install the [Irvine32 library](http://asmirvine.com/gettingStartedVS2019/index.htm), then configure your include/lib paths in Visual Studio:

- **Include path:** `C:\Irvine\`
- **Library path:** `C:\Irvine\`
- **Additional dependencies:** `Irvine32.lib`, `kernel32.lib`, `user32.lib`

### 3. Configure the project

In Visual Studio, go to **Project → Properties** and set:

- Platform: `x86`
- Configuration type: `Application (.exe)`
- Under **Microsoft Macro Assembler → General**, set Include Paths to your Irvine32 directory

### 4. Build and run

Set the build target to **x86 Release** and press **Run** (`Ctrl+F5`).

---

## 📁 Project Structure

```
esms-assembly/
├── ESMS.asm        # Main source file (all logic)
└── README.md
```

---

## ⚙️ How It Works — Architecture Notes

The program is structured around a single `.asm` file with the following logical sections:

| Section | Purpose |
|---------|---------|
| `.data` | Static storage — employee array (50 × 44 bytes), string constants, counter variable |
| `.code` | All procedures: `main`, `AddEmployee`, `DisplayPaySlip`, `DeptStats`, `Histogram`, `ValidateInput` |
| `main` | Entry point — displays menu, dispatches based on user choice using a `cmp`/`jmp` chain |

**Key registers used:**

- `ESI` — base pointer into the employee array
- `ECX` — loop counter
- `EAX/EBX` — arithmetic (salary calculation, comparisons)
- `EDX` — used with `WriteString` / `WriteDec` from Irvine32

---

## 📌 Known Limitations

- Data is **not persisted** between runs (no file I/O)
- Maximum capacity is **50 employees** per session
- Names are capped at **19 characters** (null-terminated in a 20-byte buffer)
- No duplicate ID detection — entering the same ID twice creates two separate records
- Department statistics initialize with `deptMin = 99999` and update as records are added

---

## 🔮 Possible Future Improvements

- [ ] File I/O to save/load employee records between sessions
- [ ] Search employee by ID or name
- [ ] Sort employees by salary or department
- [ ] Delete or update an existing employee record
- [ ] Export pay slips to a `.txt` file

---

## 📜 License

This project was developed as an academic assignment. Feel free to use it for educational purposes.
