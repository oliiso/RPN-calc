// worked with Sophia Kist and Sam Hoffman

.text
        .global _start
_start:
        SUB     R5, SP, #4  // stack counter
        LDR     R0, =welcome
    
loop:
        BL      printf

        LDR     R0, =my_str
        LDR     R1, =my_str_sz
        LDR     R2, =stdin
        LDR     R2, [R2]
        BL      fgets

        // searching for number
        LDR     R0, =my_str
        LDR     R1, =format_in
        LDR     R2, =my_x
        BL      sscanf

        CMP     R0, #1
        BNE     NotNumber // branches to check for characters

        LDR     R1, =my_x
        LDR     R1, [R1]
        STMFD   SP!, {R1}
        LDR     R0, =prompt
        B       loop

NotNumber:
        LDR     R3, =my_str // loop checks for specific characters
        LDRB    R3, [R3]
        CMP     R3, #'q
        MOVEQ   R0, #0
        BLEQ    exit

        CMP     R5, SP
        BLE     ER

        LDMFD   SP!, {R2}
        LDMFD   SP!, {R1}

        CMP     R3, #'+
        BEQ     ADDITION
        CMP     R3, #'-
        BEQ     SUBTRACT
        CMP     R3, #'*
        BEQ     MULTIPLY 

        // print error message if not correct characters
        LDR     R0, =error_out
        BL      printf
        B       loop

ADDITION:
        ADD     R3, R1, R2
        STMFD   SP!, {R3}
        LDR     R0, =format_out_add
        B       loop

SUBTRACT: 
        SUB     R3, R1, R2
        STMFD   SP!, {R3}
        LDR     R0, =format_out_subtract
        B       loop

MULTIPLY:
        MUL     R3, R1, R2
        STMFD   SP!, {R3}
        LDR     R0, =format_out_multiply
        B       loop

ER:     LDR     R0, =stack_error
        B       loop

        .data

welcome: .asciz "Welcome to the RPN calculator! :)\n\nTo multiply: '*', to add: '+', to subtract: '-'\nInput 'q' to quit.\n\n> "
prompt: .asciz "> "
error_out:
        .asciz  "\"%c\" is not a valid input!\n"
format_in:
        .asciz  "%d"
format_out_add:
        .asciz  "%d + %d = %d\n> "
format_out_subtract:
        .asciz  "%d - %d = %d\n> "
format_out_multiply:
        .asciz  "%d * %d = %d\n> "
my_str: .space  80
        .equ    my_str_sz, (.-my_str)
my_x:   .word   0
stack_error:
        .asciz "no more values to compute\n> "
