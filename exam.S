  #include <avr/io.h>

    .section .data

table:

    .word 0x1322
    .word 0x1112
    .word 0x2333
    //.word 0x1234
    //.word 0x3322
tableEnd:

#define TABLE_COUNT (tableEnd - table) / 2

    .section .bss
minimum: .space 2, 0
maximum: .space 2, 0

    .section .text

    .global doit
doit:
    
    ldi   r24, 1
    ldi   r25, TABLE_COUNT    
    
    rcall displayNewLine
    ldi   r16, TABLE_COUNT    
    rcall displayHex2ASCII
    
    rcall displayNewLine
    lds   r16, table
    rcall displayHex2ASCII
    rcall displayNewLine

    rcall findTableMinAndMax

    rcall displayMinAndMax
    
forever:
    
    rjmp  forever

findTableMinAndMax:
    
    ldi   xl, lo8(table)
    ldi   xh, hi8(table)
    
    ldi   yl, lo8(minimum)
    ldi   yh, hi8(minimum)    
    
    ldi   zl, lo8(maximum)
    ldi   zh, hi8(maximum)    
    
    inc   r25
Loop:
    
    ld   r18, x+//low
    ld   r19, x+//high
    cpi   r24, 1 //Increment should be one for first loop
    breq  First
    //rcall jump    


MinmOthers:    
    
    cp   r20, r18
    cpc  r21, r19
    
    brlo minm
    
    std   y+1, r19//high
    std   y+, r18//low
    mov  r20, r18
    mov  r21, r19
   
    rjmp  MaxmOthers
   
minm:
    
    std   y+1, r21//high
    std   y+, r20//low
    //rjmp  Loop
    //ret
            
MaxmOthers:    
    dec   r25
    
    //rcall displayNewLine
    //mov   r16, r25       
    //rcall displayHex2ASCII
    
    //rcall displayNewLine
    //mov   r16, r22       
    //rcall displayHex2ASCII
    
    //rcall displayNewLine
    //mov   r16, r23    
    //rcall displayHex2ASCII
    
    cp   r22, r18/////
    cpc  r23, r19
    brlo maxm
    //ret
    std   z+1, r23//high
    std   z+, r22//low
    
    //rjmp  Loop
    cpi   r25, 1
    breq  DoLoop
    
    rjmp  Loop
    //ret

maxm:

    std   z+1, r19//high
    std   z+, r18//low
    
    mov  r22, r18
    mov  r23, r19

    cpi   r25, 1
    breq  DoLoop
    
    rjmp Loop


DoLoop:
    

    ret
         
First:
      
    dec  r24

    mov  r20, r18 //Low for min
    mov  r21, r19 //High for min
    
    mov  r22, r18// Low for max
    mov  r23, r19//High for max
    
    
    std   y+1, r19//high
    std   y+, r18//low
    
    std   z+1, r19//high
    std   z+, r18//low
    
    rjmp  Loop
    





    
displayMinAndMax:
    rcall displayNewLine
    ldi   zl, lo8(minimum)
    ldi   zh, hi8(minimum)
    ldd   r16, z + 1
    rcall displayHex2ASCII
    ld    r16, z
    rcall displayHex2ASCII
    rcall displaySpace
    ldi   zl, lo8(maximum)
    ldi   zh, hi8(maximum)
    ldd   r16, z + 1
    rcall displayHex2ASCII
    ld    r16, z
    rcall displayHex2ASCII
    rcall displayNewLine
    ret

displayHex2ASCII:
    rcall hexByteToTwoAscii
    rcall sendAsciiPair
    ret

displayNewLine:
    push  r16
    ldi   r16, '\n'
    rcall USART_send
    pop   r16
    ret

displaySpace:
    push  r16
    ldi   r16, ' '
    rcall USART_send
    pop   r16
    ret

sendAsciiPair:
    push  r16
    push  r17
    rcall USART_send
    mov   r16, r17
    rcall USART_send
    pop   r17
    pop   r16
    ret
    

hexByteToTwoAscii:
    push   r16
lowbyte:
    andi   r16, 0x0f
    cpi    r16, 0x0a
    brge   letter1
number1:
    ori    r16, 0x30
    mov    r17, r16
    rjmp   highbyte
letter1:
    subi   r16, 0x09
    ori    r16, 0x40
    mov    r17, r16
highbyte:
    pop    r16
    lsr    r16
    lsr    r16
    lsr    r16
    lsr    r16
    andi   r16, 0x0f
    cpi    r16, 0x0a
    brge   letter2
number2:
    ori    r16, 0x30
    rjmp   done
letter2:
    subi   r16, 0x09
    ori    r16, 0x40
done:
    ret

    

    .global __do_clear_bss     
    .global __do_copy_data

    .end
