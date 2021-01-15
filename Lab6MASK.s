			GLOBAL Reset_Handler         ;Labeling instructions.
			AREA mycode,CODE,READONLY  ;Making my code into code and written to read only memory
PINSEL0 	EQU 0xE002C000 ;Pin function selection for port 0 (#0=GPIO)
IO0BASE 	EQU 0xE0028000 ;Base address for indexed addressing. Same as IO0PIN
IO0PIN 		EQU 0x0 ;GPIO Port pin to designate value for port 0 (0=0, 1=1)
IO0DIR   	EQU 0x8 ;Sets directions for port 0 (0=input, 1=output)
IO0SET 		EQU 0x4 ;Sets pins to "1", and zeros have no effect
IO0CLR 		EQU 0xC ;Clears pins set to "1" and zeros have no effect


Reset_Handler

			LDR 	r2,=PINSEL0 		;Making reference register to store later
			LDR 	r0,[r2] 			;Reading from PINSEL0
			LDR 	r1,=0x0000FFFF  	;Creating mask to only effect LED pins
			AND		r0,r1,r0 			;Setting the LED pins to function as GPIO
			STR 	r0,[r2]    			;Writing it in Pin Select Port 0's address

			LDR 	r4,=IO0BASE     	;Setting base address

			;TASK 1: Initially Turn 4 LEDs off, after button pressed they turn on
			;INITIALLY TURN 4 LEDS OFF P0.8-P0.11
			LDR 	r8,[r4,#IO0DIR] 	;Reading from Direction Register
			LDR 	r3,=0xF00       	;Creating mask to only make P0.8-P0.11 as an output
			ORR 	r8,r3,r8 			;Using mask
			STR	 	r8,[r4,#IO0DIR] 	;Writing to direction register using offset
			LDR 	r6,=0xF00   		 ;Turning desired LEDs off
			STR 	r6,[r4,#IO0SET]

			;Reading state of P0.14 and testing if it is set to 1 (button pushed)
			LDR 	r8,[r4,#IO0DIR] 	;Reading from Direction Register
			LDR 	r3,=0xFFFFBFFF  	;Creating mask to only make P0.14 an input (0)
			AND 	r8,r3,r8 			;Using mask
			STR 	r8,[r4,#IO0DIR] 	;Writing to direction register using offset

PinRead1 	LDR 	r7,=IO0BASE 		;Base is IO0PIN
			LDR		r9,[r7]
			TST 	r9,#0x4000 			;Test to see if button is pressed
			BNE 	PinRead1 			;If not pressed, keep checking

			;Once button is pushed, turn desired LEDs on
			LDR 	r8,[r4,#IO0DIR] 	;Reading from Direction Register
			LDR 	r3,=0xF00       	;Creating mask to only make P0.8-P0.11 as an output
			ORR 	r8,r3,r8 			;Using mask
			STR		r8,[r4,#IO0DIR] 	;Writing to direction register using offset
			LDR	 	r6,=0x000000F00 	;Turning desired LEDs on
			STR 	r6,[r4,#IO0CLR]

			;TASK 2: Initially set 8 LEDs off. Then after button it turns them on.

			LDR 	r10,=860000 		;2 Second delay between tasks
delay		SUBS 	r10, r10, #1
			BNE delay

			;INITIALLY TURN 8 LEDS OFF P0.8-P0.15
			LDR		r8,[r4,#IO0DIR] 	;Reading from Direction Register
			LDR 	r3,=0xFF00      	;Creating mask to only P0.8-P0.15 an output (1)
			ORR 	r8,r3,r8 			;Using mask
			STR 	r8,[r4,#IO0DIR] 	;Writing to direction register using offset
			LDR 	r6,=0xFF00    		;Turning desired LEDs on
			STR 	r6,[r4,#IO0CLR]

			;Reading state of P0.14 and testing if it is set to 1 (button pushed)
PinRead2 	LDR 	r8,[r4,#IO0DIR] 	;Reading from Direction Register
			LDR 	r3,=0xFFFFBFFF  	;Creating mask to only make P0.14 an input (0)
			AND		r8,r3,r8 			;Using mask
			STR 	r8,[r4,#IO0DIR] 	;Writing to direction register using offset

			LDR 	r7,=IO0BASE 		;Base is IO0PIN
			LDR 	r9,[r7]

			;Making LEDs look as if they are remaining on
			LDR 	r8,[r4,#IO0DIR] 	;Reading from Direction Register
			LDR 	r3,=0xFF00      	;Creating mask to only P0.8-P0.15 an output (1)
			ORR 	r8,r3,r8 			;Using mask
			STR 	r8,[r4,#IO0DIR] 	;Writing to direction register using offset
			LDR 	r6,=0xFF00   		;Turning desired LEDs on
			STR 	r6,[r4,#IO0CLR]

			TST 	r9,#0x4000 			;Test to see if button is pressed
			BNE 	PinRead2 			;If not pressed, keep checking

			;Once button is pushed, turn desired LEDs on
			LDR 	r8,[r4,#IO0DIR] 	;Reading from Direction Register
			LDR 	r3,=0xFF00       	;Creating mask to only make P0.8-P0.11 as an output
			ORR 	r8,r3,r8 			;Using mask
			STR 	r8,[r4,#IO0DIR] 	;Writing to direction register using offset
			LDR 	r6,=0xFF00 			;Turning desired LEDs off
			STR 	r6,[r4,#IO0SET]

stop 		B 		stop 				;Label this loop stop so it branches back to itself to hold
			END 