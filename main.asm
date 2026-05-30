;====================================================================
; Program Name: Employee Salary Management System (ESMS)
; Program Description: A console-based Employee Salary Management System
;              that stores up to 50 employee records, validates
;              all inputs, calculates net salaries, displays pay
;              slips, department statistics, and salary histogram.
;Authors: Mohammad Shaqboua ,
;         Mohammad Dawas ,  
;         Husam Ziadeh
;====================================================================

INCLUDE Irvine32.inc
.data

; ============ Final Values ============
MAX_EMPLOYEES = 50
RECORD_SIZE   = 44

; ============ Arrays ============
empArray        BYTE MAX_EMPLOYEES * RECORD_SIZE DUP(0)
empCount        DWORD 0

; ============ Departmental Statistics ============
deptCount       DWORD 5 DUP(0)    
deptTotal       DWORD 5 DUP(0)    
deptMin         DWORD 5 DUP(0)    
deptMax         DWORD 5 DUP(0)    

; ============ Payroll ============
bracketCount    DWORD 5 DUP(0)    

; ============ Temporary variables ============
tempID          DWORD 0
tempDept        DWORD 0
tempSalary      DWORD 0
tempAllow       DWORD 0
tempDeduct      DWORD 0
tempNet         DWORD 0
tempName        BYTE 21 DUP(0)

; ============ Prompts ============
menuTitle       BYTE "================================================",0
menuHeader      BYTE " EMPLOYEE SALARY MANAGEMENT SYSTEM",0
menu1           BYTE "1. Add New Employee",0
menu2           BYTE "2. Display Pay Slip",0
menu3           BYTE "3. Department Statistics",0
menu4           BYTE "4. Exit Program",0
menuPrompt      BYTE "Enter your choice (1-4): ",0

; ============ Input messages ============
promptName      BYTE "Enter employee name: ",0
promptID        BYTE "Enter employee ID (6 digits): ",0
promptDept      BYTE "Enter department code (1-5): ",0
promptSalary    BYTE "Enter basic salary (500-20000 JOD): ",0
promptAllow     BYTE "Enter allowances (0-5000 JOD): ",0
promptDeduct    BYTE "Enter deductions (0-3000 JOD): ",0

; ============ Error messages ============
errID           BYTE "ERROR: ID must be 6 digits (100000-999999)!",0
errDept         BYTE "ERROR: Department must be between 1 and 5!",0
errSalary       BYTE "ERROR: Salary must be between 500 and 20000!",0
errFull         BYTE "ERROR: Maximum employees reached!",0
successAdd      BYTE "Employee added successfully!",0
pressKey        BYTE "Press any key to continue...",0

.code

;====================================================================
; Initialize: Clear all arrays and counters
;====================================================================
Initialize PROC
                            mov     empCount, 0
                            mov     esi, 0

    InitLoop:
                            mov     deptCount[esi*4], 0
                            mov     deptTotal[esi*4], 0
                            mov     deptMin[esi*4],   99999
                            mov     deptMax[esi*4],   0
                            mov     bracketCount[esi*4], 0
                            inc     esi
                            cmp     esi, 5
                            jl      InitLoop
                            ret
Initialize ENDP

;====================================================================
; ValidateID: Check if ID is between 100000 and 999999
; Input:  EAX = entered ID
; Output: EAX = 1 (valid) or 0 (invalid)
;====================================================================
ValidateID PROC
                            cmp     eax, 100000                                        ;check if ID is less than 100000
                            jl      IDInvalid
                            cmp     eax, 999999                                        ;check if ID is greater than 999999
                            jg      IDInvalid
                            mov     eax, 1                                             ;valid
                            ret

    IDInvalid:
                            mov     edx, offset errID                                  ;display error message
                            call    WriteString
                            call    Crlf
                            mov     eax, 0                                             ;invalid
                            ret
ValidateID ENDP

;====================================================================
; ValidateDepartment: Check if department code is between 1 and 5
; Input:  EAX = entered department code
; Output: EAX = 1 (valid) or 0 (invalid)
;====================================================================
ValidateDepartment PROC
                            cmp     eax, 1                                             ;check if department is less than 1
                            jl      DeptInvalid
                            cmp     eax, 5                                             ;check if department is greater than 5
                            jg      DeptInvalid
                            mov     eax, 1                                             ;valid
                            ret

    DeptInvalid:
                            mov     edx, offset errDept                                ;display error message
                            call    WriteString
                            call    Crlf
                            mov     eax, 0                                             ;invalid
                            ret
ValidateDepartment ENDP

;====================================================================
; MainMenu: Display main menu and read user choice
; Output: EAX = user choice (1-4)
;====================================================================
MainMenu PROC
    MenuLoop:
                            call    Clrscr

                            mov     edx, offset menuTitle                              ;print top border
                            call    WriteString
                            call    Crlf
                            mov     edx, offset menuHeader                             ;print title
                            call    WriteString
                            call    Crlf
                            mov     edx, offset menuTitle                              ;print bottom border
                            call    WriteString
                            call    Crlf

                            mov     edx, offset menu1                                  ;print option 1
                            call    WriteString
                            call    Crlf
                            mov     edx, offset menu2                                  ;print option 2
                            call    WriteString
                            call    Crlf
                            mov     edx, offset menu3                                  ;print option 3
                            call    WriteString
                            call    Crlf
                            mov     edx, offset menu4                                  ;print option 4
                            call    WriteString
                            call    Crlf

                            mov     edx, offset menuPrompt                             ;prompt user for choice
                            call    WriteString
                            call    ReadInt                                            ;read choice

                            cmp     eax, 1                                             ;check if less than 1
                            jl      MenuLoop
                            cmp     eax, 4                                             ;check if greater than 4
                            jg      MenuLoop
                            ret
MainMenu ENDP

;====================================================================
; AddEmployee: Get and validate employee data then store in array
;====================================================================
AddEmployee PROC
                            mov     eax, empCount                                      ;check if array is full
                            cmp     eax, MAX_EMPLOYEES
                            jl      CanAdd
                            mov     edx, offset errFull                                ;display max capacity error
                            call    WriteString
                            call    Crlf
                            ret

    CanAdd:
                            mov     edx, offset promptName                             ;prompt for employee name
                            call    WriteString
                            mov     edx, offset tempName
                            mov     ecx, 20                                            ;max 20 characters
                            call    ReadString

    GetID:
                            mov     edx, offset promptID                               ;prompt for employee ID
                            call    WriteString
                            call    ReadInt
                            mov     tempID, eax                                        ;save entered ID
                            call    ValidateID                                         ;validate the ID
                            cmp     eax, 0
                            je      GetID                                              ;if invalid re-prompt

    GetDept:
                            mov     edx, offset promptDept                             ;prompt for department code
                            call    WriteString
                            call    ReadInt
                            mov     tempDept, eax                                      ;save entered department
                            call    ValidateDepartment                                 ;validate department
                            cmp     eax, 0
                            je      GetDept                                            ;if invalid re-prompt

                            mov     edx, offset promptSalary                           ;prompt for basic salary
                            call    WriteString
                            call    ReadInt
                            mov     tempSalary, eax                                    ;save basic salary

                            mov     edx, offset promptAllow                            ;prompt for allowances
                            call    WriteString
                            call    ReadInt
                            mov     tempAllow, eax                                     ;save allowances

                            mov     edx, offset promptDeduct                           ;prompt for deductions
                            call    WriteString
                            call    ReadInt
                            mov     tempDeduct, eax                                    ;save deductions

                            mov     edx, offset successAdd                             ;display success message
                            call    WriteString
                            call    Crlf
                            ret
AddEmployee ENDP

;====================================================================
; main: Program entry point
;====================================================================
main PROC
                            call    Initialize                                         ;initialize all arrays

    MainLoop:
                            call    MainMenu                                           ;display menu and get choice

                            cmp     eax, 1                                             ;check for option 1
                            je      DoAdd
                            cmp     eax, 2                                             ;check for option 2
                            je      DoSlip
                            cmp     eax, 3                                             ;check for option 3
                            je      DoStats
                            cmp     eax, 4                                             ;check for option 4
                            je      DoExit

    DoAdd:
                            call    AddEmployee                                        ;add new employee
                            mov     edx, offset pressKey
                            call    WriteString
                            call    ReadChar
                            jmp     MainLoop

    DoSlip:
                            ; call DisplayPaySlip <- Dawas Worked
                            jmp     MainLoop

    DoStats:
                            ; call DisplayDepartmentStats <- Husam Worked
                            jmp     MainLoop

    DoExit:
                            exit

main ENDP
END main

End main