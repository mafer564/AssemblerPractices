
;INSTITUTO POLITECNICO NACIONAL
;CECYT9 JUAN DE DIOS BATIZ
;
;PRACTICA 1:"Interrupciones empleando el timer 0" 
;
;GRUPO: 6IM2.   EQUIPO 
;
;INTEGRANTES:
;
;DESCRIPCION DE LA PRACTICA: Inicilizar una lcd y mostrar un mensaje.
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 list p=16f877A;
; BITS DE CONFIGURACION
 ;#include "C:\Archivos de programa (x86)\Microchip\MPASM Suite\P16F877A.INC"
 #include "C:\Program Files (x86)\Microchip\MPASM Suite\P16F877A.inc";
; BITS DE CONFIGURACION
	__config _XT_OSC & _WDT_OFF & _PWRTE_ON & _BODEN_OFF & _LVP_OFF & _CP_OFF;
;---------------------------------------------------------------------------------------------------------------------------------------------------
;
;frecuencia de oscilación (fosc) =4MHz
;Ciclo de trabajo del PIC = (1/fosc)*4 = 1us
;
;VARIABLES

Contador1   equ   0x20;
Contador2   equ   0x21;

; LAS VARIABLES DE USUARIO COMIENZAN DESDE LA DIRECCION 20
;---------------------------------------------------------------------------------------------------------------------------------------------------
;
;CONSTANTES
M    equ    .64;
N    equ    .64;
L    equ    .128;
;---------------------------------------------------------------------------------------------------------------------------------------------------

;ASIGNACION DE LOS BITS DE LOS PUERTOS DE I/O
; PUERTO A
Sin_UsoRA0    equ    .0; //Sin uso RA0
Sin_UsoRA1    equ    .1; //Sin uso RA1
Sin_UsoRA2    equ    .2; //Sin uso RA2
Sin_UsoRA3    equ    .3; //Sin uso RA3
Sin_UsoRA4    equ    .4; //Sin uso RA4 
Sin_UsoRA5    equ    .5; //Sin uso RA5

proga         equ    b'111111';Programación inicial del puerto A
;Si al bit de RA0 se le pone como 1, se considera como entrada, y si tiene 0 es salida
;
; PUERTO B
; Nos sirve para poder mandar el codigo de los caracteres a los displays
LCD_D0            equ    .0; //Bit 0 de la lcd
LCD_D1            equ    .1; //Bit 1 de la lcd
LCD_D2            equ    .2; //Bit 2 de la lcd
LCD_D3            equ    .3; //Bit 3 de la lcd
LCD_D4            equ    .4; //Bit 4 de la lcd
LCD_D5            equ    .5; //Bit 5 de la lcd
LCD_D6            equ    .6; //Bit 6 de la lcd
LCD_D7            equ    .7; //Bit 7 de la lcd

progb         equ    b'00000000';Programación inicial del puerto B
;
; PUERTO C
; Sirve para mandar los pulsos de reloj a los registros
RS_LCD        equ    .0; //Bit que controla el común del display 0
Enable_LCD    equ    .1; //Bit que controla el común del display 1
Luz_LCD       equ    .2; //Bit que controla el común del display 2
clk_pto3      equ    .3; //Bit que controla el común del display 3
clk_pto4      equ    .4; //Bit que controla el común del display 4
clk_pto5      equ    .5; //Bit que controla el común del display 5
clk_pto6      equ    .6; //Bit que controla el común del display 6
clk_pto7      equ    .7; //Bit que controla el común del display 7

progc         equ    b'11111111';Programación inicial del puerto C
;
; PUERTO D
Sin_UsoRD0     equ    .0; //Sin uso RD0
Sin_UsoRD1     equ    .1; //Sin uso RD1
Sin_UsoRD2     equ    .2; //Sin uso RD2
Sin_UsoRD3     equ    .3; //Sin uso RD3
Sin_UsoRD4     equ    .4; //Sin uso RD4
Sin_UsoRD5     equ    .5; //Sin uso RD5
Sin_UsoRD6     equ    .6; //Sin uso RD6
Sin_UsoRD7     equ    .7; //Sin uso RD7


progd         equ    b'11111111';Programación inicial del puerto D como entradas
;
; PUERTO E
Sin_UsoRE0    equ    .0;
Sin_UsoRE1    equ    .1;
Sin_UsoRE2    equ    .2;

proge         equ    b'111';Programación inicial del puerto E como entradas
;-----------------------------------------------------------------------------------------------------------------------------------------
;
                 ;==================
                 ;== VECTOR RESET ==
                 ;==================
                 org 0x0000; 
vec_reset        clrf PCLATH; Asegurará la pagina 0 de la memoria del programa
                 goto prog_prin; Indica que vaya a la etiqueta prog_prin
;-----------------------------------------------------------------------------------------------------------------------------------------
                 ;============================
                 ;== VECTOR DE INTERRUPCION ==
                 ;============================
                 org  0x0004;
vec_int          nop;
                 retfie;
;-----------------------------------------------------------------------------------------------------------------------------------------
                 ;=========================
                 ;== SUBRUTINA DE INICIO ==
                 ;=========================
prog_ini         bsf   STATUS,RP0; 
                 movlw  0x81; 
                 movwf  OPTION_REG; 
                 movlw  proga; 
                 movwf  TRISA;
	         movlw  progb;
                 movwf  TRISB;
                 movlw  progc;
                 movwf  TRISC;
                 movlw  progd;
                 movwf  TRISD;
                 movlw  proge;
                 movwf  TRISE;
                 movlw  0x06;
                 movwf  ADCON1;
                 bcf    STATUS,RP0; 

                 clrf   PORTB;
                 movlw  b'11111111';
                 movwf  PORTC;

                 return;
;----------------------------------------------------------------------------------------------------------------------------------------
                 ;=======================
                 ;== PROGRAMA PINCIPAL ==
                 ;=======================
		 call ini_lcd;
prog_prin        movlw 'J';
		 movwf PORTB;
		 call pulso_enable;
		 
		 movlw 'U';
		 movwf PORTB;
		 call pulso_enable;

		 movlw 'A';
		 movwf PORTB;
		 call pulso_enable;		
		 		
		 movlw 'N';
		 movwf PORTB;
		 call pulso_enable;		
                
		movlw 'D';
		movwf PORTB;
		call pulso_enable; 		
                
                movlw 'E';
		movwf PORTB;
		call pulso_enable;

		movlw 'D';
		movwf PORTB;
		call pulso_enable; 	
                call   retardo;
		 		
		movlw 'I';
		movwf PORTB;
		call pulso_enable;
                
		movlw 'O';
		movwf PORTB;
		call pulso_enable;
			
		movlw 'S';
		movwf PORTB;
		call pulso_enable;
		
trabate		nop;
		goto   trabate; 
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

               ;========================================
               ;= Subrutina de inicializacion de la LCD=
      	       ;========================================
ini_lcd		bcf PORTC RS_LCD;
		
	       movlw 0x38;
               movwf PORTB;
	       call pulso_enable;
	       
	       movlw 0x0c;
	       movwf PORTB;
	       call pulso_enable;
	       
	       movlw 0x01;
	       movwf PORTB;
	       call pulso_enable;
	       
	       movlw 0x06;
	       movwf PORTB;
	       call pulso_enable;
	       
	        movlw 0x80;
	       movwf PORTB;
	       call pulso_enable;
	       
	       bsf PORTC,RS_LCD;
	       
	       return;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

               ;======================================
	       ;= Subrutina de retardo de medio segundo =
	       ;======================================

pulso_enable    bcf PORTC,Enable_LCD;
	       call retardo_1ms;
	       bsf PORTC,Enable_LCD;
	       
	       call ret_40ms;
	       
	       return;

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                 ;=============================================
                 ;== Subrutina de retardo de medio segundo ==
                 ;=============================================
retardo_1ms     movlw .10;
		movwf Contador2;
loop2           movlw .100;
		movwf Contador1;
loop1           decfsz Contador1,f;
		goto Loop1;
		decfsz Contador2,f;
		goto Loop2;
              
                return;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

               ;=========================================
  	       ;= Subrutina de retardo de medio segundo =
	       ;=========================================

ret_40ms	movlw .200;
	       movwf Contador2;
loop22		movlw .255;
	       movwf Contador1;
loop11		decfsz Contador1,f;
	       goto loop11;
	       decfsz Contador2,f;
	       goto loop22;
	       
		return;

;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

               
		
                end;



