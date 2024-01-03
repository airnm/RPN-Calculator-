.text
        .global _start
_start:
        SUB R4, SP, #8
        // output prompt
user_input: LDR     R0, =prompt
        BL      printf
        
        // wait for input
input: LDR     R0, =my_str
        LDR     R1, =my_str_sz
        LDR     R2, =stdin
        LDR     R2, [R2]
        BL      fgets

        // read number from string
string: LDR     R0, =my_str
        LDR     R1, =format_in
        LDR     R2, =my_x
        BL      sscanf

        // test for successful scan
        CMP     R0, #1
        BEQ     stack
        LDR     R1, =my_str
        LDRB    R1, [R1]
        CMP     R1, #'q
        BEQ     quit
        CMP     SP, R4
        BGT     error
        CMP     R1, #'+
        BEQ     plus
        CMP     R1, #'-
        BEQ     subtract
        CMP     R1, #'*
        BEQ     multiplication
        
        // get pointer to input string
        LDR     R1, =my_str

        // replace LF with NULL
        MOV     R2, #0
loop:   LDRB    R3, [R1, R2]
        CMP     R3, #10
        ADDNE   R2, R2, #1
        BNE     loop
        MOV     R3, #0
        STRB    R3, [R1, R2]
        
        // print error message
        LDR     R0, =error_out
        LDR     r1, =my_str
        LDRB    r1, [r1]
        CMP     r2, #'+
        beq     plus
        BL      printf

        // error exit
        MOV     R0, #1
        B      user_input

        // print number and sum
stack:
        LDR     R1, =my_x
        LDR     R1, [R1]
        STMFD   SP!, {R1}
        B       user_input

plus: 
        LDR     R0, =format_add_out
        LDMFD   SP!, {R2}
        LDMFD   SP!, {R1}
        ADD     R3, R1, R2
        STMFD   SP!, {R3}
        BL      printf
        B       user_input

subtract:  
        LDR     R0, =format_subtract_out
        LDMFD   SP!, {R2}
        LDMFD   SP!, {R1}
        SUB     R3, R1, R2
        STMFD   SP!, {R3}
        BL      printf
        B       user_input

multiplication:  
        LDR     R0, =format_multiplication_out
        LDMFD   SP!, {R2}
        LDMFD   SP!, {R1}
        MUL     R3, R1, R2
        STMFD   SP!, {R3}
        BL      printf
        B       user_input

error:
        LDR R0, =error1
        BL      printf
        B       user_input



quit: 
        MOV      R0, #0
        BL      exit

        .data
prompt: .asciz  "> "

error1:
        .asciz "Error! No numbers on stack!\n"

error_out:
        .asciz  "\"%c\" is not an integer!\n"

format_in:
        .asciz  "%d"

format_add_out:
        .asciz  "%d + %d = %d\n"

format_subtract_out:
        .asciz  "%d - %d = %d\n"

format_multiplication_out:
        .asciz  "%d * %d = %d\n"

my_str: .space  80
        .equ    my_str_sz, (.-my_str)
my_x:   .word   0