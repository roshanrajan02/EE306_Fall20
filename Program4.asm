;***********************************************************
; Programming Assignment 4
; Student Name: Roshan Rajan
; UT Eid: rkr649
; -------------------Save Simba (Part II)---------------------
; This is the starter code. You are given the main program
; and some declarations. The subroutines you are responsible for
; are given as empty stubs at the bottom. Follow the contract. 
; You are free to rearrange your subroutines if the need were to 
; arise.

;***********************************************************

.ORIG x4000

;***********************************************************
; Main Program
;***********************************************************
        
        JSR   DISPLAY_JUNGLE
        LEA   R0, JUNGLE_INITIAL
        TRAP  x22 
        LDI   R0,BLOCKS
        JSR   LOAD_JUNGLE
        JSR   DISPLAY_JUNGLE
        LEA   R0, JUNGLE_LOADED
        TRAP  x22                        ; output end message
HOMEBOUND
        LEA   R0,PROMPT
        TRAP  x22
        TRAP  x20                        ; get a character from keyboard into R0
        TRAP  x21                        ; echo character entered
        LD    R3, ASCII_Q_COMPLEMENT     ; load the 2's complement of ASCII 'Q'
        ADD   R3, R0, R3                 ; compare the first character with 'Q'
        BRz   EXIT                       ; if input was 'Q', exit
;; call a converter to convert i,j,k,l to up(0) left(1),down(2),right(3) respectively
        JSR   IS_INPUT_VALID      
        ADD   R2, R2, #0                 ; R2 will be zero if the move was valid
        BRz   VALID_INPUT
        LEA   R0, INVALID_MOVE_STRING    ; if the input was invalid, output corresponding
        TRAP  x22                        ; message and go back to prompt
        BR    HOMEBOUND
VALID_INPUT                 
        JSR   APPLY_MOVE                 ; apply the move (Input in R0)
        JSR   DISPLAY_JUNGLE
        JSR   IS_SIMBA_HOME      
        ADD   R2, R2, #0                 ; R2 will be zero if Simba reached Home
        BRnp  HOMEBOUND                     ; otherwise, loop back
EXIT   
        LEA   R0, GOODBYE_STRING
        TRAP  x22                        ; output a goodbye message
        TRAP  x25                        ; halt
JUNGLE_LOADED       .STRINGZ "\nJungle Loaded\n"
JUNGLE_INITIAL      .STRINGZ "\nJungle Initial\n"
ASCII_Q_COMPLEMENT  .FILL    x-71    ; two's complement of ASCII code for 'q'
PROMPT .STRINGZ "\nEnter Move \n\t(up(i) left(j),down(k),right(l)): "
INVALID_MOVE_STRING .STRINGZ "\nInvalid Input (ijkl)\n"
GOODBYE_STRING      .STRINGZ "\nYou Saved Simba !Goodbye!\n"
BLOCKS               .FILL x5000

;***********************************************************
; Global constants used in program
;***********************************************************
;***********************************************************
; This is the data structure for the Jungle grid
;***********************************************************
GRID .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
  
;***********************************************************
; this data stores the state of current position of Simba and his Home
;***********************************************************
CURRENT_ROW        .BLKW   #1       ; row position of Simba
CURRENT_COL        .BLKW   #1       ; col position of Simba 
HOME_ROW           .BLKW   #1       ; Home coordinates (row and col)
HOME_COL           .BLKW   #1

;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
; The code above is provided for you. 
; DO NOT MODIFY THE CODE ABOVE THIS LINE.
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************

;***********************************************************
; DISPLAY_JUNGLE
;   Displays the current state of the Jungle Grid 
;   This can be called initially to display the un-populated jungle
;   OR after populating it, to indicate where Simba is (*), any 
;   Hyena's(#) are, and Simba's Home (H).
; Input: None
; Output: None
; Notes: The displayed grid must have the row and column numbers
;***********************************************************
DISPLAY_JUNGLE      
; Your Program 3 code goes here
    ST R0, DJSaveR0
    ST R1, DJSaveR1
    ST R2, DJSaveR2
    ST R3, DJSaveR3
    ST R4, DJSaveR4
    ST R5, DJSaveR5
    ST R6, DJSaveR6
    AND R0, R0, #0
    AND R1, R1, #0
    AND R2, R2, #0
    AND R3, R3, #0
    AND R4, R4, #0
    AND R5, R5, #0
    AND R6, R6, #0
    
    AND R3, R3, #0
    LD R1, Space
    AND R0, R0, #0
    ADD R0, R1, R0
    TRAP x21
    TRAP x21
    TRAP x21
    
    Redo
    AND R0, R0, #0
    LD R1, Convert
    ADD R0, R3, R1
    TRAP x21
    LD R1, Space
    AND R0, R0, #0
    ADD R0, R0, R1
    TRAP x21
    LD R2, ColChecker
    ADD R2, R3, R2
    BRz Next
    ADD R3, R3, #1
    BR Redo
    
    Next
    LEA R0, Enter
    TRAP x22
    LEA R0, EvenSpacing
    TRAP x22
    LD R0, BEGIN
    TRAP x22
    LD R5, IncrementString
    LEA R0, Enter
    TRAP x22
    AND R3, R3, #0
    LD R0, BEGIN
    ST R0, NextString
    
    Repeat
    LD R6, Convert
    ADD R0, R3, R6
    TRAP x21
    LD R0, Space
    TRAP x21
    LD R0, NextString
    ADD R0, R0, R5
    TRAP x22
    ST R0, NextString
    LEA R0, Enter
    TRAP x22
    LEA R0, EvenSpacing
    TRAP x22
    LD R0, NextString
    ADD R0, R0, R5
    TRAP x22
    LD R4, ColChecker
    ADD R4, R4, R3
    BRz Conclude
    ADD R3, R3, #1
    ST R0, NextString
    LEA R0, Enter
    TRAP x22
    BR Repeat
    
    Conclude
    LD R0, DJSaveR0
    LD R1, DJSaveR1
    LD R2, DJSaveR2
    LD R3, DJSaveR3
    LD R4, DJSaveR4
    LD R5, DJSaveR5
    LD R6, DJSaveR6
    JMP R7
    
    Convert         .FILL #48
    Space           .FILL x0020
    EvenSpacing     .STRINGZ "  "
	ColChecker      .FILL #-7
	Enter           .STRINGZ "\n"
    IncrementString .FILL #18
    NextString      .BLKW #1
    RowNum          .BLKW #1
    BEGIN           .FILL x40A4
    DJSaveR0        .BLKW #1
    DJSaveR1        .BLKW #1
    DJSaveR2        .BLKW #1
    DJSaveR3        .BLKW #1
    DJSaveR4        .BLKW #1
    DJSaveR5        .BLKW #1
    DJSaveR6        .BLKW #1

;***********************************************************
; LOAD_JUNGLE
; Input:  R0  has the address of the head of a linked list of
;         gridblock records. Each record has four fields:
;       0. Address of the next gridblock in the list
;       1. row # (0-7)
;       2. col # (0-7)
;       3. Symbol (can be I->Initial,H->Home or #->Hyena)
;    The list is guaranteed to: 
;               * have only one Inital and one Home gridblock
;               * have zero or more gridboxes with Hyenas
;               * be terminated by a gridblock whose next address 
;                 field is a zero
; Output: None
;   This function loads the JUNGLE from a linked list by inserting 
;   the appropriate characters in boxes (I(*),#,H)
;   You must also change the contents of these
;   locations: 
;        1.  (CURRENT_ROW, CURRENT_COL) to hold the (row, col) 
;            numbers of Simba's Initial gridblock
;        2.  (HOME_ROW, HOME_COL) to hold the (row, col) 
;            numbers of the Home gridblock
;       
;***********************************************************
LOAD_JUNGLE 
; Your Program 3 code goes here
    ST R0, LJSaveR0
    ST R1, LJSaveR1
    ST R2, LJSaveR2
    ST R3, LJSaveR3
    ST R4, LJSaveR4
    ST R5, LJSaveR5
    ST R6, LJSaveR6
    ADD R4, R0, #0
    BR Change
    Iteration
    LDR R4, R0, #0 ;R4 holds the memory contents of the next address
Change
    BRz Finish
    ST R0, Location
    LDR R1, R4, #1
    LDR R2, R4, #2
    ST R7, LJSaveR7
    JSR GRID_ADDRESS
    ST R0, GridAddy
    LD R7, LJSaveR7
    LD R0, Location
    LDR R5, R4, #3
    LD R6, InitalCheck
    ADD R6, R6, R5
    BRz SetInitial
    LD R6, HomeCheck
    ADD R6, R6, R5
    BRz SetHome
    Continue
    LD R0, GridAddy
    STR R5, R0, #0
    ADD R0, R4, #0
    BR Iteration
    SetInitial
    LDR R3, R4, #1
    ST R3, CURRENT_ROW
    LDR R3, R4, #2
    ST R3, CURRENT_COL
    LD R5, Asterisk
    BR Continue
    SetHome
    LDR R0, R4, #1
    ST R0, HOME_ROW
    LDR R1, R4, #2
    ST R1, HOME_COL
    BR Continue
    Finish
    LD R0, LJSaveR0
    LD R1, LJSaveR1
    LD R2, LJSaveR2
    LD R3, LJSaveR3
    LD R4, LJSaveR4
    LD R5, LJSaveR5
    LD R6, LJSaveR6
    JMP R7
    
StartingPosition   .FILL x5000
LJSaveR0    .BLKW #1
LJSaveR1    .BLKW #1
LJSaveR2    .BLKW #1
LJSaveR3    .BLKW #1
LJSaveR4    .BLKW #1
LJSaveR5    .BLKW #1
LJSaveR6    .BLKW #1
LJSaveR7    .BLKW #1
Asterisk    .FILL x002A
InitalCheck .FILL #-73
HomeCheck   .FILL #-72
Location    .BLKW #1    
GridAddy    .BLKW #1

;***********************************************************
; GRID_ADDRESS
; Input:  R1 has the row number (0-7)
;         R2 has the column number (0-7)
; Output: R0 has the corresponding address of the space in the GRID
; Notes: This is a key routine.  It translates the (row, col) logical 
;        GRID coordinates of a gridblock to the physical address in 
;        the GRID memory.
;***********************************************************
GRID_ADDRESS     
; Your Program 3 code goes here
    ST R1, SaveR1
    ST R2, SaveR2
    ST R3, SaveR3
    ST R4, SaveR4
    ST R5, SaveR5
    AND R3, R3, #0
    AND R4, R4, #0
    AND R5, R5, #0
    LD R0, Start
    LD R5, Length
    AND R3, R3, #0
    ADD R4, R1, #0
    Back1
    ADD R4, R4, #0
    BRz Columns
    ADD R4, R4, #-1
    ADD R3, R3, R5
    BR Back1
    Columns
    ST R3, RowST 
    AND R3, R3, #0
    AND R4, R4, #0
    ADD R4, R2, #0
    Back2
    ADD R4, R4, #0
    BRz Calculate
    ADD R4, R4, #-1
    ADD R3, R3, #2
    BR Back2
    Calculate
    ADD R0, R3, R0
    LD R3, RowST
    ADD R0, R3, R0
    LD R1, SaveR1
    LD R2, SaveR2
    LD R3, SaveR3
    LD R4, SaveR4
    LD R5, SaveR5
    JMP R7

Length  .FILL #36
Start   .FILL x40B7
RowST   .BLKW #1
ColST   .BLKW #1
SaveR1  .BLKW #1
SaveR2  .BLKW #1
SaveR3  .BLKW #1
SaveR4  .BLKW #1
SaveR5  .BLKW #1

;***********************************************************
; IS_INPUT_VALID
; Input: R0 has the move (character i,j,k,l)
; Output:  R2  zero if valid; -1 if invalid
; Notes: Validates move to make sure it is one of i,j,k,l
;        Only checks if a valid character is entered
;***********************************************************

IS_INPUT_VALID
; Your New (Program4) code goes here
    ST R0, IVSaveR0
    ST R1, IVSaveR1
    LD R1, ASCII_I
    ADD R2, R1, R0
    BRz IsValid
    LD R1, ASCII_J
    ADD R2, R1, R0
    BRz IsValid
    LD R1, ASCII_K
    ADD R2, R1, R0
    BRz IsValid
    LD R1, ASCII_L
    ADD R2, R1, R0
    BRz IsValid
    AND R2, R2, #0
    ADD R2, R2, #-1
    BR Restore
    IsValid
    AND R2, R2, #0
    Restore
    LD R1, IVSaveR1
    LD R0, IVSaveR0
    JMP R7
    
    
ASCII_I .FILL #-105
ASCII_J .FILL #-106
ASCII_K .FILL #-107
ASCII_L .FILL #-108
IVSaveR1 .BLKW #1
IVSaveR0 .BLKW #1

;***********************************************************
; SAFE_MOVE
; Input: R0 has 'i','j','k','l'
; Output: R1, R2 have the new row and col if the move is safe
;         If the move is unsafe, that is, the move would 
;         take Simba to a Hyena or outside the Grid then 
;         return R1=-1 
; Notes: Translates user entered move to actual row and column
;        Also checks the contents of the intended space to
;        move to in determining if the move is safe
;        Calls GRID_ADDRESS
;        This subroutine does not check if the input (R0) is 
;        valid. This functionality is implemented elsewhere.
;***********************************************************

SAFE_MOVE      
; Your New (Program4) code goes here
    ST R0, SMSaveR0
    ST R1, SMSaveR1
    ST R2, SMSaveR2
    ST R3, SMSaveR3
    ST R4, SMSaveR4
    ST R5, SMSaveR5
    ST R6, SMSaveR6
    LD R5, Currents
    LDR R1, R5, #0
    LDR R2, R5, #1
    LD R4, ASCII_I
    ADD R3, R4, R0
    BRz IStep
    LD R4, ASCII_J
    ADD R3, R4, R0
    BRz JStep
    LD R4, ASCII_K
    ADD R3, R4, R0
    BRz KStep
    LD R4, ASCII_L
    ADD R3, R4, R0
    BRz LStep
    
    IStep
    ST R0, SaveChar
    ST R7, SMSaveR7
    JSR GRID_ADDRESS
    LD R7, SMSaveR7
    LD R3, ChangeI
    ADD R0, R0, R3
    ADD R1, R1, #-1
    BR SafeCheck
    
    JStep
    ST R0, SaveChar
    ST R7, SMSaveR7
    JSR GRID_ADDRESS
    LD R7, SMSaveR7
    LD R3, ChangeJ
    ADD R2, R2, #-1
    ADD R0, R0, R3
    BR SafeCheck
    
    KStep
    ST R0, SaveChar
    ST R7, SMSaveR7
    JSR GRID_ADDRESS
    LD R7, SMSaveR7
    LD R3, ChangeK
    ADD R1, R1, #1
    ADD R0, R0, R3
    BR SafeCheck
    
    LStep
    ST R0, SaveChar
    ST R7, SMSaveR7
    JSR GRID_ADDRESS
    LD R7, SMSaveR7
    LD R3, ChangeL
    ADD R2, R2, #1
    ADD R0, R0, R3
    BR SafeCheck
    
    SafeCheck
    ;Checks whether end of string has been reached
    LDR R3, R0, #0
    Brz Failure
    ;Checks if the current spot is less than the first spot
    LD R3, FirstAddr
    ADD R4, R3, R0
    BRn Failure
    ;Checks if the current spot is past the last spot
    LD R3, LastAddr
    ADD R4, R3, R0
    BRp Failure
    ;Checks if there is a hyena in the current spot
    LD R4, Hyena
    LDR R3, R0, #0
    ADD R5, R4, R3
    BRz Failure
    
Success
    LD R0, SMSaveR0
    LD R3, SMSaveR3
    LD R4, SMSaveR4
    LD R5, SMSaveR5
    LD R6, SMSaveR6
    BR Leave
    
Failure
    LD R0, SMSaveR0
    LD R2, SMSaveR2
    LD R3, SMSaveR3
    LD R4, SMSaveR4
    LD R5, SMSaveR5
    LD R6, SMSaveR6
    AND R1, R1, #0
    ADD R1, R1, #-1
Leave
    JMP R7
    
SaveChar .BLKW #1
SMSaveR0 .BLKW #1
SMSaveR1 .BLKW #1
SMSaveR2 .BLKW #1
SMSaveR3 .BLKW #1
SMSaveR4 .BLKW #1
SMSaveR5 .BLKW #1
SMSaveR6 .BLKW #1
SMSaveR7 .BLKW #1
Currents .FILL x41D6
ChangeI  .FILL #-36
ChangeJ  .FILL #-2
ChangeK  .FILL #36
ChangeL  .FILL #2
FirstAddr .FILL #-16566
LastAddr  .FILL #-16834
Hyena     .FILL #-35

;***********************************************************
; APPLY_MOVE
; This subroutine makes the move if it can be completed. 
; It checks to see if the movement is safe by calling 
; SAFE_MOVE which returns the coordinates of where the move 
; goes (or -1 if movement is unsafe as detailed below). 
; If the move is Safe then this routine moves the player 
; symbol to the new coordinates and clears any walls (|�s and -�s) 
; as necessary for the movement to take place. 
; If the movement is unsafe, output a console message of your 
; choice and return. 
; Input:  
;         R0 has move (i or j or k or l)
; Output: None; However must update the GRID and 
;               change CURRENT_ROW and CURRENT_COL 
;               if move can be successfully applied.
; Notes:  Calls SAFE_MOVE and GRID_ADDRESS
;***********************************************************

APPLY_MOVE   
; Your New (Program4) code goes here
    JMP R7

;***********************************************************
; IS_SIMBA_HOME
; Checks to see if the Simba has reached Home.
; Input:  None
; Output: R2 is zero if Simba is Home; -1 otherwise
; 
;***********************************************************

IS_SIMBA_HOME     
    ; Your code goes here

    JMP R7
    .END

; This section has the linked list for the
; Jungle's layout: #(0,1)->H(4,7)->I(2,1)->#(1,1)->#(6,3)->#(3,5)->#(4,4)->#(5,6)
	.ORIG	x5000
	.FILL	Head   ; Holds the address of the first record in the linked-list (Head)
blk2
	.FILL   blk4
	.FILL   #1
    .FILL   #1
	.FILL   x23

Head
	.FILL	blk1
    .FILL   #0
	.FILL   #1
	.FILL   x23

blk1
	.FILL   blk3
	.FILL   #4
	.FILL   #7
	.FILL   x48

blk3
	.FILL   blk2
	.FILL   #2
	.FILL   #1
	.FILL   x49

blk4
	.FILL   blk5
	.FILL   #6
	.FILL   #3
	.FILL   x23

blk7
	.FILL   #0
	.FILL   #5
	.FILL   #6
	.FILL   x23
blk6
	.FILL   blk7
	.FILL   #4
	.FILL   #4
	.FILL   x23
blk5
	.FILL   blk6
	.FILL   #3
	.FILL   #5
	.FILL   x23
	.END
