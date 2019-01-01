#include <avr/io.h>

    .section .bss

ch: .space 1, 0
nc: .space 1, 0

    .section .text

    .global doit
doit:
    sts   ch, r1
    sts   nc, r1
    sei
forever:
    lds    r17, nc
    lds    r16, ch
    cpse   r16, r17
    rjmp   sendIt
    rjmp   forever   
sendIt: 
    rcall  toHex
    rcall  sendHex
    lds    r16, ch
    sts    nc, r16
    rjmp   forever

sendHex:
    rcall  USART_send
    mov    r16, r17
    rcall  USART_send
    ldi    r16, '\n'
    rcall  USART_send
    ret

    .global USART_RX_vect
USART_RX_vect:
    in     r2, _SFR_IO_ADDR(SREG)
    push   r2
    lds    r2, UDR0
    sts    ch, r2
    sts    nc, r1
    pop    r2
    out    _SFR_IO_ADDR(SREG), r2
    reti

    .end
