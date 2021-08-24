; Program5.asm
; Name(s): Roshan Rajan,Ayodele Kuye
; UTEid(s): rkr649, apk669
; Continuously reads from x3600 making sure its not reading duplicate
; symbols. Processes the symbol based on the program description
; of mRNA processing.
    .ORIG x3000
; set up the keyboard interrupt vector table entry
;M[x0180] <- x2600
    LD R0, KBISR
    STI R0, KBINTVec
;Initialize global to be 0
    ;M[x3600] <- 0
    
    LD R0, KBINTEN
    STI R0, KBSR
    
    AND R0, R0, #0
    STI R0, GLOB
; enable keyboard interrupts
; KBSR[14] <- 1 ==== M[xFE00] = x4000
; This loop is the proper way to read an input
    ; Here means x3600 has a valid input
    ; Process it in keeping with FSM
    GetA
    AND R0, R0, #0
    STI R0, GLOB
    HERE
    LDI R0, GLOB
    BRz HERE
    TRAP x21
    LD R1, CheckA
    ADD R1, R0, R1
    BRz Reset1
    BR GetA
    
    Reset1
    AND R0, R0, #0
    STI R0, GLOB
    GetU
    LDI R0, GLOB
    BRz GetU
    TRAP x21
    LD R1, CheckU
    ADD R1, R0, R1
    BRz Reset2
    BR Reset1
    
    Reset2
    AND R0, R0, #0
    STI R0, GLOB
    GetG
    LDI R0, GLOB
    BRz GetG
    TRAP x21
    LD R1, CheckG
    ADD R1, R0, R1
    BRz Next
    BR GetA
    
    Next
    LD R0, Pipe
    TRAP x21
    
    
    GetU2
    AND R0, R0, #0
    STI R0, GLOB
    Here6
    LDI R0, GLOB
    BRz Here6
    TRAP x21
    LD R1, CheckU
    ADD R1, R0, R1
    BRz Reset3
    BR GetU2
    
    Reset3
    AND R0, R0, #0
    STI R0, GLOB
    Here3
    LDI R0, GLOB
    BRz Here3
    TRAP x21
    LD R1, CheckU
    ADD R1, R0, R1
    BRz Reset3
    LD R1, CheckC
    ADD R1, R0, R1
    BRz GetU2
    LD R1, CheckG
    ADD R1, R0, R1
    BRz AfterUG
    LD R1, CheckA
    ADD R1, R0, R1, 
    BRz AfterUA
    
    AfterUG
    AND R0, R0, #0
    STI R0, GLOB
    Here4
    LDI R0, GLOB 
    BRz Here4
    TRAP x21
    LD R1, CheckA
    ADD R1, R0, R1
    BRz Stop
    LD R1, CheckG
    ADD R1, R0, R1
    BRz GetU2
    LD R1, CheckC
    ADD R1, R0, R1
    BRz GetU2
    LD R1, CheckU
    ADD R1, R0, R1
    BRz Reset3
    
    AfterUA
    AND R0, R0, #0
    STI R0, GLOB
    Here5
    LDI R0, GLOB
    BRz Here5
    TRAP x21
    LD R1, CheckA
    ADD R1, R0, R1
    BRz Stop
    LD R1, CheckG
    ADD R1, R0, R1
    BRz Stop
    LD R1, CheckC
    ADD R1, R0, R1
    BRz GetU2
    LD R1, CheckU
    ADD R1, R0, R1
    BRz GetU2
    ;check if user prints UAA UAG UGA
    ; Reset GLOB to 0
    
; Repeat unil Stop Codon detected
Stop
    HALT
    
    
KBINTVec    .FILL x0180
KBSR        .FILL xFE00
KBISR       .FILL x2600
KBINTEN     .FILL x4000
GLOB        .FILL x3600
CheckA      .FILL #-65
CheckC      .FILL #-67
CheckG      .FILL #-71
CheckU      .FILL #-85
Pipe        .FILL x007C
	.END

; Interrupt Service Routine
; Keyboard ISR runs when a key is struck
; Checks for a valid RNA symbol and places it at x3600
    .ORIG x2600
    ; Save R0 and R1
    ST R0, SaveR0
    ST R1, SaveR1
    LDI R0, KBDR        ;Get keystroke
    ; Check if R0 has A, C, G, or U
    LD R1, NegA
    ADD R1, R0, R1
    BRz Valid
    LD R1, NegC
    ADD R1, R0, R1
    BRz Valid
    LD R1, NegG
    ADD R1, R0, R1
    BRz Valid
    LD R1, NegU
    ADD R1, R0, R1
    BRz Valid
    BR Done
Valid
    ; Write R0 to Global
    STI R0, IGLOB
Done
LD R0, SaveR0
LD R1, SaveR1
    RTI
        
KBDR    .FILL xFE02
IGLOB   .FILL x3600
NegA  .FILL #-65
NegC  .FILL #-67
NegG  .FILL #-71
NegU  .FILL #-85
SaveR0  .BLKW #1
SaveR1  .BLKW #1
		.END
