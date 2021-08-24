; Programming Project 1 starter file
; Student Name  :  Roshan Rajan
; UTEid: rkr649
; Modify this code to satisfy the requirements of Project 1
; left-rotate a 16-bit number N by B bit positions. 
; N is at x30FF; B is is x3100; put result at x3101
; Read the complete Project Description on Canvas
; RO is the loop counter
; R1 stores the value of N at beginning of each shift 
; R2 stores final value of N at the end of each shift
; R3 stores number of bits (B) to test if it is greater than 0 
	.ORIG	x3000
;---- Your Solution goes here	
    AND R0, R0, #0
    LD R0, xFE ; stores the number of bits in R0
    LD R1, xFC ; stores the memory location in R1
    ADD R3, R0, #0 ; sets nzp bit for bit value
    BRnz #9
    ADD R2, R1, R1 ; stores left shifted value of R1 into R2
    ADD R1, R1, #0 ; sets nzp bit
    BRn #1 ; decides whether or not 1 should be added based on if R1 is negative
    ADD R2, R2, #-1 ; if positive, the ADD #-1 will cancel out the ADD #1 
    ADD R2, R2, #1 ; if negative the ADD #1 will move MSB to LSB's place
    AND R1, R1, #0 ; resets R1 to 0
    ADD R1, R2, #0  ; sets R1 to the new value after one shift
    ADD R0, R0, #-1 ; decrements the loop counter
    BRp #-9 ; if the loop counter is positive iterates code starting from x3003
    ADD R4, R1, #0 ; stores the final result in Register 4
    ST R4, xF1 ; stores the Register 4 into x3101
    
;---- Done
	TRAP	x25
;---- You may declare addresses and such here
    
	.END
	
	
	.ORIG x30FF
    .FILL x9D20; N
    .FILL #1 ; B 
    .END
    
    
    

