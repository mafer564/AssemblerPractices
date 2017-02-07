;INSTITUTO POLITECNICO NACIONAL
;CECYT9 JUAN DE DIOS BATIZ
;
;PRACTICA 5:"Entrada de Datos al Sistema (I.Operaciones Aritmeticas)" 
;
;GRUPO: 5IM2.   EQUIPO 09
;
;GARCIA RODRIGUEZ LUIS DANIEL
;
;ESTE PROGRAMA REALIZA SUMAS Y RESTAS BINARIAS Y LAS PRESENTA EN UN DYSPLAY DE 7
;SEGMENTOS DE FORMA HEXADECIMAL
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
x0 			equ   0x20
x1			equ   0x21
x2			equ   0x22
x3	        equ   0x20
y0 			equ   0x23
y1 			equ   0x24
y2 			equ	  0x25
y3          equ   0x26
r0	        equ	  0x27
r1 			equ   0x28
r2 			equ   0x29
r3          equ   0x30
r4   		equ   0x31
r5	        equ	  0x32
respaldo    equ   0x33
Contador1   equ   0x34
Contador2   equ   0x35
Contador3   equ   0x36
resultado   equ   0x37
subst       equ   0x38
resp_num    equ   0x39
resp_num1   equ   0x40
resp_num2   equ   0x41


; LAS VARIABLES DE USUARIO COMIENZAN DESDE LA DIRECCION 20
;---------------------------------------------------------------------------------------------------------------------------------------------------
;
;CONSTANTES
M    equ    .64;
N    equ    .64;
L    equ    .128;
;---------------------------------------------------------------------------------------------------------------------------------------------------
; CONSTANTES DE CARACTERES EN SIETE SEGMENTOS
Car_A       equ   b'01110111'; Caracter A en siete segmentos
Car_b       equ   b'01111100'; Caracter b en siete segmentos
Car_C       equ   b'00111001'; Caracter C en siete segmentos
Car_cc      equ   b'01011000'; Caracter c en siete segmentos
Car_d       equ   b'01011110'; Caracter d en siete segmentos
Car_E       equ   b'01111001'; Caracter E en siete segmentos
Car_F       equ   b'01110001'; Caracter F en siete segmentos
Car_G       equ   b'01111101'; Caracter G en siete segmentos
Car_gg      equ   b'01101111'; Caracter g en siete segmentos
Car_H       equ   b'01110110'; Caracter H en siete segmentos
Car_hh      equ   b'01110100'; Caracter h en siete segmentos
Car_i       equ   b'00010000'; Caracter i en siete segmentos
Car_J       equ   b'00011110'; Caracter J en siete segmentos
Car_L       equ   b'00111000'; Caracter L en siete segmentos
Car_n       equ   b'01010100'; Caracter n en siete segmentos
Car_o       equ   b'01011100'; Caracter o en siete segmentos
Car_P       equ   b'01110011'; Caracter P en siete segmentos
Car_q       equ   b'01100111'; Caracter q en siete segmentos
Car_r       equ   b'01010000'; Caracter r en siete segmentos
Car_S       equ   b'01101101'; Caracter S en siete segmentos
Car_t       equ   b'01111000'; Caracter t en siete segmentos
Car_U       equ   b'00111110'; Caracter U en siete segmentos
Car_uu      equ   b'00011100'; Caracter u en siete segmentos
Car_y       equ   b'01101110'; Caracter y en siete segemntos
Car_0       equ   b'00111111'; Caracter 0 en siete segmentos
Car_1       equ   b'00000110'; Caracter 1 en siete segmentos
Car_2       equ   b'01011011'; Caracter 2 en siete segmentos
Car_3       equ   b'01001111'; Caracter 3 en siete segmentos
Car_4       equ   b'01100110'; Caracter 4 en siete segmentos
Car_5       equ   b'01101101'; Caracter 5 en siete segmentos
Car_6       equ   b'01111101'; Caracter 6 en siete segmentos
Car_7       equ   b'00000111'; Caracter 7 en siete segmentos
Car_8       equ   b'01111111'; Caracter 8 en siete segmentos
Car_9       equ   b'01101111'; Caracter 9 en siete segmentos
Car_null    equ   b'00000000'; Caracter nulo (espacios)
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
Seg_a             equ    .0; //Segmento a del bus de segmentos
Seg_b             equ    .1; //Segmento b del bus de segmentos
Seg_c             equ    .2; //Segmento c del bus de segmentos
Seg_d             equ    .3; //Segmento d del bus de segmentos
Seg_e             equ    .4; //Segmento e del bus de segmentos
Seg_f             equ    .5; //Segmento f del bus de segmentos
Seg_g             equ    .6; //Segmento g del bus de segmentos
Seg_dp            equ    .7; //Segmento dp del bus de segmentos

progb         equ    b'00000000';Programación inicial del puerto B
;
; PUERTO C
; Sirve para mandar los pulsos de reloj a los registros
Com_Disp0     equ    .0; //Bit que controla el común del display 0
Com_Disp1     equ    .1; //Bit que controla el común del display 1
Com_Disp2     equ    .2; //Bit que controla el común del display 2
Com_Disp3     equ    .3; //Bit que controla el común del display 3
Com_Disp4     equ    .4; //Bit que controla el común del display 4
Com_Disp5     equ    .5; //Bit que controla el común del display 5
Com_Disp6     equ    .6; //Bit que controla el común del display 6
Com_Disp7     equ    .7; //Bit que controla el común del display 7

progc         equ    b'00000000';Programación inicial del puerto C como salidas
;
; PUERTO D
bit0    		equ    .0; //Sin uso RD0
bit1    		equ    .1; //Sin uso RD1
bit2    		equ    .2; //Sin uso RD2
bit3    		equ    .3; //Sin uso RD3
Ingreso_dat     equ    .4; //Sin uso RD4
Ope0    		equ    .5; //Sin uso RD5
Ope1    		equ    .6; //Sin uso RD6
Sin_UsoRD7    	equ    .7; //Sin uso RD7


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
prog_prin        call  	prog_ini; Llamamos a la etiqueta prog_ini
ini   	         bcf   	STATUS,RP0;
		 		bcf   	STATUS,RP1;
		 		movlw     0x00;
	 	 		movwf     r0;
		 		movwf     r1;
loop1  	        call 	lee_num
				btfsc 	PORTD,4;
		 		goto  	loop1;
		 		movf  	PORTD,W;
                andlw  0x0F;
		 		movwf 	x0;
                movwf  respaldo;
                call   prob_x0;
mostrar_x0      movf   r0,w;
		 		movwf  PORTB;
		 		bcf    PORTC,Com_Disp0;		         
                call   retardo;
		 		bsf    PORTC,Com_Disp0;
                movlw  0x00;
                movwf  respaldo;                 
loop2  	        call   lee_num2
				btfsc 	PORTD,4;
		 		goto  	loop2;
		 		movf  	PORTD,W;
                andlw  0x0F;
		 		movwf 	y0;
		 		movwf  respaldo;
                call   prob_y0;
mostrar_y0      movf   r0,w;
				movwf  PORTB;
		 		bcf    PORTC,Com_Disp0;		         
                call   retardo;
		 		bsf    PORTC,Com_Disp0;
                movlw  0x00;
                movwf  respaldo;
loop3  	        btfsc 	PORTD,4;
		 		goto  	loop3;
                btfsc  PORTD,6;
                goto   resta;
                clrw
		 		addwf  x0,W;
		 		addwf  y0,W;
		 		movwf  resultado;
                movwf  respaldo;
                call   enc_num;
retr            call   retardo3;
mostrar	         movf   r0,w;
				 movwf  PORTB;
		 		 bcf    PORTC,Com_Disp0;
		 		call   retardo2;
		 		bsf    PORTC,Com_Disp0;
				movf   r1,w;
	        	movwf  PORTB;
		 		bcf    PORTC,Com_Disp1;
		 		call   retardo2;
		 		bsf    PORTC,Com_Disp1;
		 		btfsc  PORTD,4;
		 		goto   mostrar;
                call   retardo;
		 		goto   loop1; 
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

               ;=========================
               ;= Subrutina para restar =
      	       ;=========================

resta            movf   y0,w;
                 subwf  x0,w;
                 btfss  STATUS,C;
                 goto   err2;
                 movwf  resultado;
                 movwf  respaldo;
                 call   enc_num;
                 goto   retr;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

               ;======================================
	       ;= Subrutina de retardo de 2 segundos =
	       ;======================================

retardo         movlw L
                movwf Contador1;
loopc1		    movlw M
                movwf Contador2;
loopc2	    	movlw N
                movwf Contador3;
loopc3	    	decfsz Contador3,f;
		        goto loopc3
                decfsz Contador2,f;
				goto loopc2
	        	decfsz Contador1,f;
				goto loopc1
				return;

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                 ;=============================================
                 ;== Subrutina de retardo de 2 mili segundos ==
                 ;=============================================
                 ; PAGINA CERO
 
retardo2         movlw .2;
                 movwf Contador3;
Loop0a           movlw .255;
                 movwf Contador2;
Loop0b           decfsz Contador2,f;
                 goto Loop0b;
                 decfsz Contador3,f;
                 goto Loop0a;
              
                 return;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

               ;========================
  	       ;= Subrutina de retardo =
	       ;========================

retardo3        movlw .5
                movwf Contador1;
loopu1		movlw .100
                movwf Contador2;
loopu2	    	movlw .255
                movwf Contador3;
loopu3	    	decfsz Contador3,f;
	        goto loopu3
                decfsz Contador2,f;
		goto loopu2
	        decfsz Contador1,f;
		goto loopu1;
		return;

;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

               ;===================================
               ;= Subrutina para encontrar número =
               ;===================================
		
enc_num         movlw .10;
		subwf resultado,w;
		btfsc STATUS,C;
		call  dos_digitos;
                goto  find_num;
prob_x0         movlw .10;
		subwf x0,w;
		btfsc STATUS,C;
		call  err1;
                goto  find_num;
prob_y0         movlw .10;
		subwf y0,w;
		btfsc STATUS,C;
		call  err1;
                goto  find_num;
find_num        movlw .0;
			subwf respaldo,w;
			btfsc STATUS,Z;
			goto fue_cero;
	        movlw .1;
			subwf respaldo,w;
			btfsc STATUS,Z;
			goto fue_uno;
			movlw .2;
			subwf respaldo,w;
			btfsc STATUS,Z;
			goto fue_dos;
	        movlw .3;
			subwf respaldo,w;
			btfsc STATUS,Z;
			goto fue_tres;
	        movlw .4;
			subwf respaldo,w;
			btfsc STATUS,Z;
			goto fue_cuatro;
	        movlw .5;
	        subwf respaldo,w;
			btfsc STATUS,Z;
			goto fue_cinco;
	        movlw .6;
			subwf respaldo,w;
	        btfsc STATUS,Z;
	        goto fue_seis;
	        movlw .7;
	        subwf respaldo,w;
	        btfsc STATUS,Z;
	        goto fue_siete;
	        movlw .8;
	        subwf respaldo,w;
	        btfsc STATUS,Z;
	        goto fue_ocho;
	        movlw .9;
		subwf respaldo,w;
	        btfsc STATUS,Z;
		goto fue_nueve;
	        movlw .10;
	        subwf respaldo,w;
	        btfsc STATUS,Z;
	        goto fue_cero;
	        movlw .11;
	        subwf respaldo,w;
			btfsc STATUS,Z;
	        goto fue_uno;
	        movlw .12;
	        subwf respaldo,w;
	        btfsc STATUS,Z;
			goto fue_dos;
	        movlw .13;
	        subwf respaldo,w;
	        btfsc STATUS,Z;
	        goto fue_tres;
	        movlw .14;
	        subwf respaldo,w;
	        btfsc STATUS,Z;
	        goto fue_cuatro;
	        movlw .15;
	        subwf respaldo,w;
	        btfsc STATUS,Z;
	        goto fue_cinco;
                movlw .16;
	        subwf respaldo,w;
	        btfsc STATUS,Z;
	        goto fue_seis;
	        movlw .17;
	        subwf respaldo,w;
	        btfsc STATUS,Z;
	        goto fue_siete;
                movlw .18;
	        subwf respaldo,w;
	        btfsc STATUS,Z;
	        goto fue_ocho;
	        
	        return;
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		;======================================
                ;= Subrutina para números mayores a 9 =
                ;======================================
		
dos_digitos     movlw Car_1;
	    	 	movwf r1;
				return;
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                ;=============================
                ;= Error de más de un dígito =
                ;=============================

err1             movlw .60;
                 movwf Contador1;
men_err          movlw Car_E;              E
                 movwf PORTB;
                 bcf PORTC, Com_Disp4;
                 call retardo2;
                 bsf PORTC, Com_Disp4;
                 call retardo2;
                 
                 movlw Car_r;              R
                 movwf PORTB;
                 bcf PORTC, Com_Disp3;
                 call retardo2;
                 bsf PORTC, Com_Disp3;
                 call retardo2;

                 movlw Car_r;              R
                 movwf PORTB;
                 bcf PORTC, Com_Disp2;
                 call retardo2;
                 bsf PORTC, Com_Disp2;
                 call retardo2;

                 movlw Car_o;              O
                 movwf PORTB;
                 bcf PORTC, Com_Disp1;
                 call retardo2;
                 bsf PORTC, Com_Disp1;
                 call retardo2;

                 movlw Car_r;              R
                 movwf PORTB;
                 bcf PORTC, Com_Disp0;
                 call retardo2;
                 bsf PORTC, Com_Disp0;
                 call retardo2;

                 decfsz Contador1,f;
                 goto men_err;
                 
                 goto  ini;

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                ;============================
                ;= Error de número negativo =
                ;============================

err2             movlw .60;
                 movwf Contador1;
men_err2         movlw Car_E;              E
                 movwf PORTB;
                 bcf PORTC, Com_Disp4;
                 call retardo2;
                 bsf PORTC, Com_Disp4;
                 call retardo2;

                 movlw Car_r;              R
                 movwf PORTB;
                 bcf PORTC, Com_Disp3;
                 call retardo2;
                 bsf PORTC, Com_Disp3;
                 call retardo2;

                 movlw Car_r;              R
                 movwf PORTB;
                 bcf PORTC, Com_Disp2;
                 call retardo2;
                 bsf PORTC, Com_Disp2;
                 call retardo2;

                 movlw Car_o;              O
                 movwf PORTB;
                 bcf PORTC, Com_Disp1;
                 call retardo2;
                 bsf PORTC, Com_Disp1;
                 call retardo2;

                 movlw Car_r;              R
                 movwf PORTB;
                 bcf PORTC, Com_Disp0;
                 call retardo2;
                 bsf PORTC, Com_Disp0;
                 call retardo2;

                 decfsz Contador1,f;
                 goto men_err2;
                 
                 goto  ini;

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                
                ;====================================
                ;= Subrutina de carga de caracteres =
                ;====================================
		
fue_cero        movlw Car_0;
		        movwf r0;
		        goto salte_conv;
fue_uno         movlw Car_1;
		        movwf r0;
		        goto salte_conv;
fue_dos         movlw Car_2;
		        movwf r0;
		        goto salte_conv;
fue_tres        movlw Car_3;
		        movwf r0;
		        goto salte_conv;
fue_cuatro      movlw Car_4;
		        movwf r0;
		        goto salte_conv;
fue_cinco       movlw Car_5;
		        movwf r0;
		        goto salte_conv;
fue_seis        movlw Car_6;
		        movwf r0;
		        goto salte_conv;
fue_siete       movlw Car_7;
	 	        movwf r0;
		        goto salte_conv;
fue_ocho        movlw Car_8;
		        movwf r0;
		        goto salte_conv;
fue_nueve       movlw Car_9;
		        movwf r0;
	        	goto salte_conv;
		
salte_conv      return;
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



					;=================================================
					;=== SUB RUTINA  LEE NUM EN BINARIO           ====
					;=================================================
lee_num				movf PORTD,w;
					movwf Ingreso_dat;
					movlw 0x0f;
					andwf Ingreso_dat,f;

esp_tec				btfsc PORTD,Ingreso_dat;
					goto esp_tec;
					return;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



					;=================================================
					;=== SUB RUTINA  LEE NUM EN BINARIO    2      ====
					;=================================================
lee_num1			movf PORTD,w;
					movwf Ingreso_dat;
					movlw 0x0f;
					andwf Ingreso_dat,f;

esp_tec1			btfsc PORTD,Ingreso_dat;
					goto esp_tec1;
					return;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



					;=================================================
					;=== SUB RUTINA regresar           ====
					;=================================================
lee_num2			movf PORTD,w;
					movwf Ingreso_dat;
					movlw 0x0f;
					andwf Ingreso_dat,f;

esp_tec2			btfsc PORTD,Ingreso_dat;
					goto esp_tec2;
					return;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
                end;


