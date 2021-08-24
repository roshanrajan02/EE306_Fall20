; Programming Assignment 2
; Student Name: Roshan Rajan    
; UT Eid: rkr649
; Linked List creation from array. Insertion into the list
; You are given an array of student records starting at location x3500.
; The array is terminated by a sentinel. Each student record in the array
; has two fields:
;      Score -  A value between 0 and 100
;      Address of Name  -  A value which is the address of a location in memory where
;                          this student's name is stored.
; The end of the array is indicated by the sentinel record whose Score is -1
; The array itself is unordered meaning that the student records dont follow
; any ordering by score or name.
; You are to perform two tasks:
; Task 1: Sort the array in decreasing order of Score. Highest score first.
; Task 2: You are given a name (string) at location x6000, You have to lookup this student 
;         in the linked list (post Task1) and put the student's score at x5FFF (i.e., in front of the name)
;         If the student is not in the list then a score of -1 must be written to x5FFF
; Notes:
;       * If two students have the same score then keep their relative order as
;         in the original array.
;       * Names are case-sensitive.
; Task 1
    .ORIG x3000
    LD R0, Reference1       ;loads x3500 into R0
    Beginning
    ADD R2, R0, #2          ;loads the memory location of the next grade into R2
    ADD R4, R0, #0          ;loads the memory location of current max into R4
    LDR R1, R0, #0          ;loads the grade at the current element into R1
    BRn Task2              ;if the grade is negative, meaning the sentinel has been reached, task 1 ends (checks for empty arrays)
    IfBigger
    LDR R3, R2, #0          ;loads the grade being compared into R3
    ADD R6, R3, #0          ;stores the grade being compared into R6, so R3 can be modified
    NOT R3, R3              ;converts the grade being compared into negative, flips all bits
    ADD R3, R3, #1          ;completes negation process by adding 1 to the R3
    ADD R5, R3, R1          ;stores the sum of the current max and the grade being compared 
    BRzp Next               ;if the sum is negative
    ADD R4, R2, #0          ;sets the value of new max's memory location to the location of the grade that was being compared
    ADD R1, R6, #0          ;sets the current max equal to the grade that was just compared
    Next
    ADD R2, R2, #2          ;increments the element in the array, so the next grade can be compared
    LDR R3, R2, #0          ;loads the next grade into R3
    BRp IfBigger            ;checks if the sentinel has been reached yet
    LDR R6,R0,#1            ;loads the current element's name into R6
    LDR R7,R4,#1            ;loads the max element's name into R4
    STR R6,R4,#1            ;stores the current element's name into max element's name slot
    STR R7,R0,#1            ;stores the max element's name into the current element's name slot
	LDR R6,R0,#0            ;loads the current element's grade into R6
    LDR R7,R4,#0            ;loads the max element's grade into R4
    STR R6,R4,#0            ;stores the current element's grade into max element's grade slot
    STR R7,R0,#0            ;stores the max element's grade into the current element's grade slot
    Increment
    ADD R0, R0, #2          ;increments the value of the memory location of the current element
    LDR R1, R0, #0          ;loads the value of the current element's grade into R1
    BRzp Beginning          ;if the current element is -1 the program, task 1 is complete

; Task 2
; R0 holds the memory of the current element being compared in the array
; R1 holds the memory location of the lookup name
; R2 holds the memory location of the name of the current name being compared to the lookup name
; R3 holds the ascii value of the character currently being compared from the lookup name
; R4 holds the ascii value of the character being compared from the name at the current element in the array
; R5 holds the current grade (set to -1 unless a match for the lookup is found)
; R6 holds the memory location at which we want to store the final grade to (x5FFF)
    Task2
    AND R0, R0, #0      ;sets the value of R0-R7 to 0
    AND R1, R1, #0
    AND R2, R2, #0
    AND R3, R3, #0
    AND R4, R4, #0
    AND R5, R5, #0
    AND R6, R6, #0
    AND R7, R7, #0
    ADD R5, R5, #-1     ;R5 holds -1, which is the default grade unless a match for the lookup name is found
    LD R6, Reference3   ;R6 loads the memory location (x5FFF) to which the grade should be stored
    STR R5, R6, #0      ;stores R5 into x5FFF, defaulting the grade returned to -1
    LD R0, Reference1   ;loads x3500 into R0
    LD R1, Reference2   ;loads x6000 into R1
    LDR R3, R1, #0      ;loads the ascii value of the first character of the lookup name into R3
    Brz Finish          ;if the string is empty, the program is terminated and the grade is -1
    Start
    LD R1, Reference2   ;loads x6000 into R1
    LDR R2, R0, #0      ;if the array is empty, the program is terminated and the grade is -1
    BRn Finish          
    LDR R2, R0, #1      ;loads the memory location of the name into R2 
    LDR R3, R1, #0      ;loads the ascii value of the first character into R3
    LDR R4, R2, #0      ;loads the ascii value of the first character of the name in the array that is currently being compared
    Compare
    NOT R4, R4          ;flips all bits in R4, first part of making it negative
    ADD R4, R4, #1      ;adds 1 to R4, completing the negation process
    ADD R6, R4, R3      ;stores the sum of the ascii values of the names being compared into R6
    BRz NextCheck       ;if the characters are equal, R6 = 0, and the program checks if the next character in the names is the sentinel
    ADD R0, R0, #2      ;the element being compared to in the array is incremented
    BR Start
    NextCheck
    ADD R1, R1, #1      ;adds 1 to R1
    LDR R3, R1, #0      ;loads the ascii value of the next character of the lookup name into R3
    ADD R2, R2, #1      ;adds 1 to R2
    LDR R4, R2, #0      ;loads the ascii value of the next character of the name being compared in the array into R4
    ADD R7, R4, R3      ;stores the sum of the ascii values being compared into R7
    BRnp Compare        ;if the sum is 0, the sentinel has been reached and the names are identical, so the grade is changed
    LD R6, Reference3   ;loads x5FFF into R6 
    LDR R5, R0, #0      ;loads the grade for the current element into R5
    STR R5, R6, #0      ;stores the grade in R5 into x5FFF
; Your code goes here
    Finish
	TRAP	x25
; Your .FILLs go here
Reference1    .FILL x3500
Reference2    .FILL x6000
Reference3    .FILL x5FFF
	.END
    
    

; Student records are at x3500
    .ORIG	x3500
    .FILL   #55     ; student 0' score
    .FILL   x4700   ; student 0's nameAdd
    .FILL	#75     ; student 1' score
    .FILL   x4100   ; student 1's nameAdd
    .FILL   #65     ; student 2' score
    .FILL   x4200   ; student 2's nameAdd
	.FILL   #-1
    .END
    
; Joe
	.ORIG	x4700
	.STRINGZ "Joe"
	.END
; Wow
	.ORIG	x4200
	.STRINGZ "Wonder Woman"
	.END
	
; Bat
	.ORIG	x4100
	.STRINGZ "Bat Man"
	.END
	
; Person to Lookup	
	.ORIG   x6000
;       The following lookup should give score of 
	.STRINGZ  "Joe"
;       The following lookup should give score of
;	.STRINGZ  "Bat Man"
;       The following lookup should give score of -1 because Bat man is 
;           spelled with lowercase m; There is no student with that name 
;	.STRINGZ  "Bat man"
	.END
	