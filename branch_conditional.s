		INCLUDE stm32l1xx_constants.s       ; Load Constant Definitions
		INCLUDE stm32l1xx_tim_constants.s   ; TIM Constants
		AREA myData, DATA, READWRITE
		AREA myCode, CODE, READONLY
		EXPORT __main						; __main and not _main as defined 
		ALIGN								; startup_stm32l1xx_md.s. lines 192,
		ENTRY								; 217, and 36
__main	PROC
		; Branch instructions are used to alter the direction of program
		; execution from the normal flow of control. These branch deviations
		; can either be: unconditional or conditional. Unconditionals jump
		; whereas conditionals test for conditions before branching out.
		CMP r1, #0			; equivalent to SUBS r0, r1 or subtract r1 from r0
							; CMP updates N, Z, C, and V flags
		RSBLT r1, r1, #0	; branch to r1 = 0 - r1 if r1 < 0. LT = signed LT
		; compare two unsigned numbers
		MOV r4, #0x00000001	; x
		MOV r5, #0xFFFFFFFF	; y
		CMP r4, r5
		BLS else			; branch if <=
then	MOV r6, #1			; z = 1
		B endif				; skip next instruction
else	MOV r6, #0			; z = 0
endif
		; compare two signed numbers
		MOVS r4, #0x00000001	; x
		MOVS r5, #0xFFFFFFFF	; y
		CMP r4, r5
		BLE then1			; branch if signed <=
		MOVS r6, #1			; z = 1
		B endif1				; skip next instruction
then1	MOVS r6, #0			; z = 0
endif1
		; implement an if-then statement, e.g., if(a<0){...} then ...
		; r1 = a, r2 = x
		CMP r1, #0			; compare a with 0
		BGE endif2			; go to endif if a >= 0
then2 	RSB r1, r1, #0		; a = 0 - a
endif2	ADD r2, r2, #1		; x = x + 1
		; or another version
		CMP r1, #0			; compare a with 0
		RSBLT r1, r1, #0	; a = 0 - a
		ADD r2, r2, #1		; x = x + 1
stop 	b stop
		ENDP
		END
