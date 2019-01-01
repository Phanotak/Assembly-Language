#include <avr/io.h>

    .section .data

table:
    .byte  'A'
    .byte  'B'
    .byte  'C'
    .byte  23
    .byte  0x9c
    .byte  0b01011010
    .byte  0

    .section .text

    .global doit
doit:
    ldi    r31, hi8(table)
    ldi    r30, lo8(table)
loop:
    ld     r16, Z+
    cpi    r16, 0
    breq   forever
    rcall  toHex
    rcall  sendHex
    rjmp   loop
forever:
    rjmp   forever

sendHex:
    rcall  USART_send
    mov    r16, r17
    rcall  USART_send
    ldi    r16, '\n'
    rcall  USART_send
    ret

    .global __do_copy_data

    .end
