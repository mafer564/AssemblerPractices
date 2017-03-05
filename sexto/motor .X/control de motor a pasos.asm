LIST P=16f877A
#include "C:\Program Files (x86)\Microchip\MPASM Suite\P16F877A.inc";
; BITS DE CONFIGURACION
	__config _XT_OSC & _WDT_OFF & _PWRTE_ON & _BODEN_OFF & _LVP_OFF & _CP_OFF;
;DECLARACION REGISTROS A USAR

status equ 0x03 
 portb equ 0x06 
 trisb equ 0x86 
 reg1 equ 0x0c ;registro usado para el retardo 
 reg2 equ 0x0d ;registro usado para el retardo
;CONFIGURACION PUERTO B COMO SALIDA
org 0x00 ;origen del programa 
bsf status,5 ;vamos al banco1 de la memoria RAM 
clrf trisb ;puerto queda configurado como salida 
bcf status,5 ;regresamos al banco0 de la memoria RAM
;PROGRAMA PRINCIPAL 
 inicio	     movlw b'00001000' ;cargamos W con b'00001000' 
	     movwf portb ;mandamos lo que hay en W al puerto B 
	     call retardo ;hacemos una pausa movlw b'00000100' 
	     movwf portb
	     call retardo 
	     movlw b'00000001' 
	     movwf portb 
	     call retardo 
	     goto inicio
	     
retardo	    MOVLW 0x90 ;cargamos (w) con el hexadecimal 90 
	     MOVWF reg1 ;mover lo que hay en W al registro1 
	     MOVLW 0x90 ;cargamos (w) con hexadecimal 90 
	     MOVWF reg2 ;mover que hay en W al registro2 

uno	    DECFSZ reg1,1 ;Decrementa registro1 y el resultado guardalo en el mismo 
	     GOTO uno

dos	    DECFSZ reg2,1 ;decrementa registro2 y el resultado guardalo en el mismo 
	     GOTO dos 
	     RETURN ;retorna de donde lo llamaron 

	     end ;Fin del programita



