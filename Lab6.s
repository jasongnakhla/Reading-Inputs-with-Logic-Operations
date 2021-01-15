				GLOBAL	Reset_Handler			;Labeling instruction
				AREA	mycode, CODE, Readonly	;Making the code a code and read only memory
Reset_Handler	
IO0_Base		EQU		0xE0028000
PINSEL0			EQU		0xE002C000				;PINSEL0 is a control register and is 32-bit long. pin function selection for port 0 (#0=GPIO)
IO0DIR			EQU		0x8				;Sets directions for port 0 (0=input, 1=output)
IO0PIN			EQU		0				;GPIO Port pin to designate value for port (0=0, 1=1)
IO0SET			EQU		0X4
IO0CLR			EQU		0XC
BUTTONMASK		EQU		0X00004000
				
				LDR		R2,=IO0_Base

				LDR		R0,=0x0000FFFF;0XCFFFFFFF			;Making a mask for PINSEL0. This is based on the manual of what values indicate for P0.0-P0.15
				LDR		R1,=PINSEL0				;Load PINSEL0 address into R1
				LDR		R5,[R1]					;Load pointer to point to address in R5
				AND		R5,R5,R0				;And R5 with the mask to set the Ports we want to use to 0
				STR		R5,[R0]					;This is active low so 0 means on and 1 means off
							
				
				LDR 	R0,=0x00000F00
				STR		R0,[R2,#IO0DIR]					;Storing it at Pin Select Port 0's address
				
				LDR		R0,=0x00000F00					;Press control with a character it will write but not be visible. Will not run.
				; I met my brother at the train. Action sentence
				; Different styles
				STR		R0,[R2,#IO0SET]
				;LDR		R2,=IO0PIN
				;LDR		R0,=0XFFFFBFFF			;Setting P0.8-p0.15 to be the output pins from the microcontroller
				;STR		R0,[R2]					;Storing it in IO Direction's address

output			LDR		R3,[R2]
				TST		R3,#0x00004000
				BNE		output
				
				LDR		R0,=0x00000F00
				STR		R0,[R2,#IO0CLR]

				;LDR		R0,=0XFFFFF0FF
				;STR		R0,[R2]					;Want to turn on the LEDS. Store the value of R0 into the address of IO0_Base offsetted by
	
stop			B 		stop
				END