;INSTITUTO POLITECNICO NACIONAL.
;CECYT 9 JUAN DE DIOS BATIZ.
;
;PRACTICA 07
;MANIPULACIÓN DE SUBRUTINAS DE TIEMPO "RELOJ DE TIEMPO REAL"
;
;GRUPO: 5IM2. 
;EQUIPO: 
;INTEGRANTES:
;
;
;COMENTARIO DE LO QUE EL PROGRAMA EJECUTARA: EL PROGRAMA REPRESENTARÁ LA FUNCION DE UN RELOJ,MIDE EL TIEMPO (24 HORAS) Y CUANDO SE CUMPLE ESTE LAPSO DE TIEMPO EL CUENTA SE REINICIA.
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


list p=16f877A
 include <p16f877a.inc>
;#include "c:\Archivos del Programa\microchip\mpasm suite\p16f877a.inc";
;#include "c:\Archivos del Programa(x86)\microchip\mpasm suite\p16f877a.inc";
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;fosc = 4Mhz.
;Ciclo de trabajo del PIC = (1/fosc)*4 = 1 us.
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;Registros de proposito general Banco 0 de memoria RAM.
;
;Registros propios de estructura del programa.
;Variables.
Contador1	equ			0x20; //
Contador2	equ			0x21; //
Contador3	equ			0x22; //
Contador4	equ			0x23; //
Contador5	equ			0x24; //
Contador6	equ			0x25; //
Contador7	equ			0x26; //
Contador8	equ			0x27; //
Contador9	equ			0x28; //
Fact_1  	equ			0x29; //
Fact_2  	equ			0x2A; //
Contadorx  	equ			0x2B; //
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;Constantes.
M			equ		  .1; EL ULTIMO QUE SE RESTA
N			equ		  .150;
L			equ		  .9;

;Constantes de ccaracteres en siete segmentos.
Car_A		equ	b'01110111'; CaracteSeg_NumA en siete segmentos.
Car_b		equ b'01111100'; CaracteSeg_Numb en siete segmentos.
Car_C		equ b'00111001'; CaracteSeg_NumC en siete segmentos.
Car_cc		equ b'01011000'; CaracteSeg_Numc en siete segmentos.
Car_d		equ b'01011110'; CaracteSeg_Numd en siete segmentos.
Car_E		equ b'01111001'; CaracteSeg_NumE en siete segmentos.
Car_F		equ b'01110001'; CaracteSeg_NumF en siete segmentos.
Car_G		equ b'01111101'; CaracteSeg_NumG en siete segmentos.
Car_gg		equ b'01101111'; CaracteSeg_Numg en siete segmentos.
Car_H		equ b'01110110'; CaracteSeg_NumH en siete segmentos.
Car_hh		equ b'01110100'; CaracteSeg_Numh en siete segmentos.
Car_i		equ b'00000100'; CaracteSeg_Numi en siete segmentos.
Car_J		equ b'00011110'; CaracteSeg_NumJ en siete segmentos.
Car_L		equ b'00111000'; CaracteSeg_NumL en siete segmentos.
Car_n		equ b'01010100'; CaracteSeg_Numn en siete segmentos.
Car_nn      equ b'01010101'; CaracteSeg_Numnn en siete segmentos.
Car_o		equ b'01011100'; CaracteSeg_Numo en siete segmentos.
Car_p		equ b'01110011'; CaracteSeg_Nump en siete segmentos.
Car_q		equ b'01100111'; CaracteSeg_Numq en siete segmentos.
Car_r		equ b'01010000'; CaracteSeg_Numr en siete segmentos.
Car_s		equ b'01101101'; CaracteSeg_Nums en siete segmentos.
Car_t		equ b'01111000'; CaracteSeg_Numt en siete segmentos.
Car_U		equ b'00111110'; CaracteSeg_NumU en siete segmentos.
Car_uu		equ b'00011100'; CaracteSeg_Numu en siete segmentos.
Car_V		equ b'10111110'; CaracteSeg_NumV en siete segmentos.
Car_vv		equ b'10011100'; CaracteSeg_Numv en siete segmentos.
Car_y		equ b'01101110'; CaracteSeg_Numy en siete segmentos.
Car_z		equ b'11011011'; CaracteSeg_Numz en siete segmentos.
Car_0		equ b'00111111'; Numero 0 en siete segmentos.
Car_1		equ b'00000110'; Numero 1 en siete segmentos.
Car_2		equ b'01011011'; Numero 2 en siete segmentos.
Car_3		equ b'01001111'; Numero 3 en siete segmentos.
Car_4		equ b'01100110'; Numero 4 en siete segmentos.
Car_5		equ b'01101101'; Numero 5 en siete segmentos.
Car_6		equ b'01111101'; Numero 6 en siete segmentos.
Car_7		equ b'00000111'; Numero 7 en siete segmentos.
Car_8		equ b'01111111'; Numero 8 en siete segmentos.
Car_9		equ b'01100111'; Numero 9 en siete segmentos.
Car_null	equ b'00000000'; Caracter nulo en siete segmentos.
Car_igual	equ b'01000000'; Numero 9 en siete segmentos.

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;Asignación de los bits de los puertos de I/O.
;Puerto A.
Sin_UsoRA0	equ			.0; //Sin Uso RA0.
Sin_UsoRA1	equ			.1; //Sin Uso RA1.
Sin_UsoRA2	equ			.2; //Sin Uso RA2.
Sin_UsoRA3	equ			.3; //Sin Uso RA3.
Sin_UsoRA4	equ			.4; //Sin Uso RA4.
Sin_UsoRA5	equ			.5; //Sin Uso RA5.

proga		equ   b'111111'; //Programación inicial del puerto A.

;Puerto B.
Seg_a		equ			.0; // Bit 0 del bus de segmentos.
Seg_b		equ			.1; // Bit 1 del bus de segmentos.
Seg_c		equ			.2; // Bit 2 del bus de segmentos.
Seg_d		equ			.3; // Bit 3 del bus de segmentos.
Seg_e		equ			.4; // Bit 4 del bus de segmentos.
Seg_f		equ			.5; // Bit 5 del bus de segmentos.
Seg_g		equ			.6; // Bit 6 del bus de segmentos.
Seg_dp		equ			.7; // Bit 7 del bus de segmentos.

progb		equ   b'00000000'; //Programación inicial del puerto B.

;Puerto C.
Com_Disp0	equ			.0; //Bit que controla el comun del display 0.
Com_Disp1	equ			.1; //Bit que controla el comun del display 1.
Com_Disp2	equ			.2; //Bit que controla el comun del display 2.
Com_Disp3	equ			.3; //Bit que controla el comun del display 3.
Com_Disp4	equ			.4; //Bit que controla el comun del display 4.
Com_Disp5	equ			.5; //Bit que controla el comun del display 5.
Com_Disp6	equ			.6; //Bit que controla el comun del display 6.
Com_Disp7	equ			.7; //Bit que controla el comun del display 7.

progc		equ   b'00000000'; //Programación inicial del puerto C.

;Puerto D.
Sin_UsoRD0	equ			.0; //Sin Uso RD0.
Sin_UsoRD1	equ			.1; //Sin Uso RD1.
Sin_UsoRD2	equ			.2; //Sin Uso RD2.
Sin_UsoRD3	equ			.3; //Sin Uso RD3.
Sin_UsoRD4	equ			.4; //Sin Uso RD4.
Sin_UsoRD5	equ			.5; //Sin Uso RD5.
Sin_UsoRD6	equ			.6; //Sin Uso RD6.
Sin_UsoRD7	equ			.7; //Sin Uso RD7.

progd		equ   b'11111111'; //Programación inicial del puerto D.

;Puerto E.
Sin_UsoRE0	equ			.0; //Sin Uso RE0.
Sin_UsoRE1	equ			.1; //Sin Uso RE1.
Led_Op		equ			.2; //Led Op.

proge		equ   b'011'; //Programación inicial del puerto E.
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


				;=========================
				;==		Vector reset	==
				;=========================
				org 0x0000;
vec_reset		clrf pclath; Asegura la paagina cero de la memoria: de prog.
				goto prog_prin;
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


				;=====================================
				;==		Vector de interrupción		==
				;=====================================
				org 0x0004;
vec_int			nop;


				retfie;
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


				;=================================
				;==		Subrutina de inicio		==
				;=================================
prog_ini		bsf status,rp0; seleccionar el banco 1 de ram.
				movlw 0x81;
				movwf option_reg ^0x80;
				movlw proga;
				movwf trisa ^0x80;
				movlw progb;
				movwf trisb ^0x80;
				movlw progc;
				movwf trisc ^0x80;
				movlw progd;
				movwf trisd ^0x80;
				movlw proge;
				movwf trise ^0x80;
				movlw 0x06;
				movwf adcon1 ^0x80; configura el pto. a como salidas I/O.
				bcf status,rp0;
				
				clrf portb;
				movlw 0xff;
				movwf portc;

				return;
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


				;================================
				;==		Programa principal	   ==
				;================================
prog_prin		call prog_ini;

loop_prin	    movlw .0; Carga el numero 6 al registro w.		
				movwf Contador4; Envía el numero 6 al contador 1.
                movlw .0; Carga el numero 6 al registro w.		
				movwf Contador5; Envía el numero 6 al contador 1.
                movlw .0; Carga el numero 6 al registro w.		
				movwf Contador6; Envía el numero 6 al contador 1.
                movlw .0; Carga el numero 6 al registro w.		
				movwf Contador7; Envía el numero 6 al contador 1.
                movlw .0; Carga el numero 6 al registro w.		
				movwf Contador8; Envía el numero 6 al contador 1.
                movlw .0; Carga el numero 6 al registro w.		
				movwf Contador9; Envía el numero 6 al contador 1.
                movlw .0; Carga el numero 6 al registro w.		
				movwf Fact_1; Envía el numero 6 al contador 1.

loop_max        movlw .34; Carga el numero 6 al registro w.		
				movwf Contadorx; Envía el numero 6 al contador 1.
loop_ja         movf Contador4,w;
				movwf Fact_2;
                call comparar
                movf Contador5,w;
				movwf Fact_2;
                call comparar1
                movlw Car_igual; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp2;
				call retardo;
				bsf portc,Com_Disp2;
				call retardo;
                movf Contador6,w;
				movwf Fact_2;
                call comparar2
                movf Contador7,w;
				movwf Fact_2;
                call comparar3
                movlw Car_igual; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp5;
				call retardo;
				bsf portc,Com_Disp5;
				call retardo;
                movf Contador8,w;
				movwf Fact_2;
                call comparar4
                movf Contador9,w;
				movwf Fact_2;
                call comparar5
                call retardo1
                decfsz Contadorx,f;
                goto loop_ja
                nop;
				incfsz Contador4,f;
                movlw .10;
                subwf Contador4,w;
                btfsc status,z;
                goto loop_max1;
                goto loop_max

loop_max1       movlw .0; Carga el numero 6 al registro w.		
				movwf Contador4; Envía el numero 6 al contador 1.
				incfsz Contador5,f;
                movlw .6;
                subwf Contador5,w;
                btfsc status,z;
                goto loop_max2;
                goto loop_max      

loop_max2       movlw .0; Carga el numero 6 al registro w.		
				movwf Contador4; Envía el numero 6 al contador 1.
                movlw .0; Carga el numero 6 al registro w.		
				movwf Contador5; Envía el numero 6 al contador 1.
				incfsz Contador6,f;
                movlw .10;
                subwf Contador6,w;
                btfsc status,z;
                goto loop_max3;
                goto loop_max  

loop_max3       movlw .0; Carga el numero 6 al registro w.		
				movwf Contador4; Envía el numero 6 al contador 1.
                movlw .0; Carga el numero 6 al registro w.		
				movwf Contador5; Envía el numero 6 al contador 1.
                movlw .0; Carga el numero 6 al registro w.		
				movwf Contador6; Envía el numero 6 al contador 1.
				incfsz Contador7,f;
                movlw .6;
                subwf Contador7,w;
                btfsc status,z;
                goto loop_max4;
                goto loop_max 

loop_max4       movlw .0; Carga el numero 6 al registro w.		
				movwf Contador4; Envía el numero 6 al contador 1.
                movlw .0; Carga el numero 6 al registro w.		
				movwf Contador5; Envía el numero 6 al contador 1.
                movlw .0; Carga el numero 6 al registro w.		
				movwf Contador6; Envía el numero 6 al contador 1.
                movlw .0; Carga el numero 6 al registro w.		
				movwf Contador7; Envía el numero 6 al contador 1.
				incfsz Contador8,f;
                movlw .10;
                subwf Contador8,w;
                btfsc status,z;
                goto loop_max5;
                goto loop_max       

loop_max5       movlw .0; Carga el numero 6 al registro w.		
				movwf Contador4; Envía el numero 6 al contador 1.
                movlw .0; Carga el numero 6 al registro w.		
				movwf Contador5; Envía el numero 6 al contador 1.
                movlw .0; Carga el numero 6 al registro w.		
				movwf Contador6; Envía el numero 6 al contador 1.
                movlw .0; Carga el numero 6 al registro w.		
				movwf Contador7; Envía el numero 6 al contador 1.
                movlw .0; Carga el numero 6 al registro w.		
				movwf Contador8; Envía el numero 6 al contador 1.
                movlw .1;
                subwf Fact_1,w;
                btfsc status,z;
                goto no_sigue;
                goto sigue
sigue		    incfsz Contador9,f;
no_sigue        movlw .2;
                subwf Contador9,w;
                btfsc status,z;
                goto loop_max6;
                goto loop_max

loop_max6       movlw .0; Carga el numero 6 al registro w.		
				movwf Contador4; Envía el numero 6 al contador 1.
                movlw .0; Carga el numero 6 al registro w.		
				movwf Contador5; Envía el numero 6 al contador 1.
                movlw .0; Carga el numero 6 al registro w.		
				movwf Contador6; Envía el numero 6 al contador 1.
                movlw .0; Carga el numero 6 al registro w.		
				movwf Contador7; Envía el numero 6 al contador 1.
                movlw .0; Carga el numero 6 al registro w.		
				movwf Contador8; Envía el numero 6 al contador 1.
                movlw .2; Carga el numero 6 al registro w.		
				movwf Contador9; Envía el numero 6 al contador 1.
                movlw .1; Carga el numero 6 al registro w.		
				movwf Fact_1; Envía el numero 6 al contador 1.
                movlw .4;
                subwf Contador8,w;
                btfsc status,z;
                goto prog_prin;
                goto loop_max

comparar        movlw .0;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_0;

                movlw .1;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_1;

                movlw .2;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_2;

                movlw .3;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_3;

                movlw .4;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_4;

                movlw .5;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_5;

                movlw .6;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_6;

                movlw .7;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_7;

                movlw .8;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_8;

                movlw .9;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_9;

Pon_0           movlw Car_0; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp0;
				call retardo;
				bsf portc,Com_Disp0;
				call retardo;
                return;

Pon_1           movlw Car_1; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp0;
				call retardo;
				bsf portc,Com_Disp0;
				call retardo;
                return;

Pon_2           movlw Car_2; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp0;
				call retardo;
				bsf portc,Com_Disp0;
				call retardo;
                return;

Pon_3           movlw Car_3; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp0;
				call retardo;
				bsf portc,Com_Disp0;
				call retardo;
                return;

Pon_4           movlw Car_4; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp0;
				call retardo;
				bsf portc,Com_Disp0;
				call retardo;
                return;

Pon_5           movlw Car_5; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp0;
				call retardo;
				bsf portc,Com_Disp0;
				call retardo;
                return;

Pon_6           movlw Car_6; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp0;
				call retardo;
				bsf portc,Com_Disp0;
				call retardo;
                return;

Pon_7           movlw Car_7; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp0;
				call retardo;
				bsf portc,Com_Disp0;
				call retardo;
                return;

Pon_8           movlw Car_8; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp0;
				call retardo;
				bsf portc,Com_Disp0;
				call retardo;
                return;

Pon_9           movlw Car_9; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp0;
				call retardo;
				bsf portc,Com_Disp0;
				call retardo;
                return;

comparar1       movlw .0;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_0x;

                movlw .1;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_1x;

                movlw .2;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_2x;

                movlw .3;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_3x;

                movlw .4;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_4x;

                movlw .5;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_5x;

                movlw .6;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_6x;


Pon_0x          movlw Car_0; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp1;
				call retardo;
				bsf portc,Com_Disp1;
				call retardo;
                return;

Pon_1x          movlw Car_1; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp1;
				call retardo;
				bsf portc,Com_Disp1;
				call retardo;
                return;

Pon_2x          movlw Car_2; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp1;
				call retardo;
				bsf portc,Com_Disp1;
				call retardo;
                return;

Pon_3x          movlw Car_3; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp1;
				call retardo;
				bsf portc,Com_Disp1;
				call retardo;
                return;

Pon_4x          movlw Car_4; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp1;
				call retardo;
				bsf portc,Com_Disp1;
				call retardo;
                return;

Pon_5x          movlw Car_5; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp1;
				call retardo;
				bsf portc,Com_Disp1;
				call retardo;
                return;

Pon_6x          movlw Car_6; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp1;
				call retardo;
				bsf portc,Com_Disp1;
				call retardo;
                return;

comparar2       movlw .0;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_0xx;

                movlw .1;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_1xx;

                movlw .2;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_2xx;

                movlw .3;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_3xx;

                movlw .4;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_4xx;

                movlw .5;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_5xx;

                movlw .6;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_6xx;

                movlw .7;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_7xx;

                movlw .8;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_8xx;

                movlw .9;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_9xx;

Pon_0xx         movlw Car_0; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp3;
				call retardo;
				bsf portc,Com_Disp3;
				call retardo;
                return;

Pon_1xx         movlw Car_1; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp3;
				call retardo;
				bsf portc,Com_Disp3;
				call retardo;
                return;

Pon_2xx         movlw Car_2; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp3;
				call retardo;
				bsf portc,Com_Disp3;
				call retardo;
                return;

Pon_3xx         movlw Car_3; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp3;
				call retardo;
				bsf portc,Com_Disp3;
				call retardo;
                return;

Pon_4xx         movlw Car_4; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp3;
				call retardo;
				bsf portc,Com_Disp3;
				call retardo;
                return;

Pon_5xx         movlw Car_5; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp3;
				call retardo;
				bsf portc,Com_Disp3;
				call retardo;
                return;

Pon_6xx         movlw Car_6; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp3;
				call retardo;
				bsf portc,Com_Disp3;
				call retardo;
                return;

Pon_7xx         movlw Car_7; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp3;
				call retardo;
				bsf portc,Com_Disp3;
				call retardo;
                return;

Pon_8xx         movlw Car_8; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp3;
				call retardo;
				bsf portc,Com_Disp3;
				call retardo;
                return;

Pon_9xx         movlw Car_9; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp3;
				call retardo;
				bsf portc,Com_Disp3;
				call retardo;
                return;

comparar3       movlw .0;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_0xxx;

                movlw .1;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_1xxx;

                movlw .2;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_2xxx;

                movlw .3;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_3xxx;

                movlw .4;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_4xxx;

                movlw .5;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_5xxx;

                movlw .6;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_6xxx;


Pon_0xxx        movlw Car_0; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp4;
				call retardo;
				bsf portc,Com_Disp4;
				call retardo;
                return;

Pon_1xxx        movlw Car_1; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp4;
				call retardo;
				bsf portc,Com_Disp4;
				call retardo;
                return;

Pon_2xxx        movlw Car_2; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp4;
				call retardo;
				bsf portc,Com_Disp4;
				call retardo;
                return;

Pon_3xxx        movlw Car_3; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp4;
				call retardo;
				bsf portc,Com_Disp4;
				call retardo;
                return;

Pon_4xxx        movlw Car_4; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp4;
				call retardo;
				bsf portc,Com_Disp4;
				call retardo;
                return;

Pon_5xxx        movlw Car_5; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp4;
				call retardo;
				bsf portc,Com_Disp4;
				call retardo;
                return;

Pon_6xxx        movlw Car_6; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp4;
				call retardo;
				bsf portc,Com_Disp4;
				call retardo;
                return;

comparar4       movlw .0;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_0xxxx;

                movlw .1;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_1xxxx;

                movlw .2;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_2xxxx;

                movlw .3;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_3xxxx;

                movlw .4;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_4xxxx;

                movlw .5;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_5xxxx;

                movlw .6;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_6xxxx;

                movlw .7;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_7xxxx;

                movlw .8;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_8xxxx;

                movlw .9;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_9xxxx;

Pon_0xxxx       movlw Car_0; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp6;
				call retardo;
				bsf portc,Com_Disp6;
				call retardo;
                return;

Pon_1xxxx       movlw Car_1; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp6;
				call retardo;
				bsf portc,Com_Disp6;
				call retardo;
                return;

Pon_2xxxx       movlw Car_2; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp6;
				call retardo;
				bsf portc,Com_Disp6;
				call retardo;
                return;

Pon_3xxxx       movlw Car_3; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp6;
				call retardo;
				bsf portc,Com_Disp6;
				call retardo;
                return;

Pon_4xxxx       movlw Car_4; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp6;
				call retardo;
				bsf portc,Com_Disp6;
				call retardo;
                return;

Pon_5xxxx       movlw Car_5; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp6;
				call retardo;
				bsf portc,Com_Disp6;
				call retardo;
                return;

Pon_6xxxx       movlw Car_6; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp6;
				call retardo;
				bsf portc,Com_Disp6;
				call retardo;
                return;

Pon_7xxxx       movlw Car_7; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp6;
				call retardo;
				bsf portc,Com_Disp6;
				call retardo;
                return;

Pon_8xxxx         movlw Car_8; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp6;
				call retardo;
				bsf portc,Com_Disp6;
				call retardo;
                return;

Pon_9xxxx       movlw Car_9; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp6;
				call retardo;
				bsf portc,Com_Disp6;
				call retardo;
                return;

comparar5       movlw .0;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_0xxxxx;

                movlw .1;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_1xxxxx;

                movlw .2;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_2xxxxx;

                movlw .3;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_3xxxxx;

                movlw .4;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_4xxxxx;

                movlw .5;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_5xxxxx;

                movlw .6;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_6xxxxx;


Pon_0xxxxx      movlw Car_0; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp7;
				call retardo;
				bsf portc,Com_Disp7;
				call retardo;
                return;

Pon_1xxxxx      movlw Car_1; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp7;
				call retardo;
				bsf portc,Com_Disp7;
				call retardo;
                return;

Pon_2xxxxx        movlw Car_2; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp7;
				call retardo;
				bsf portc,Com_Disp7;
				call retardo;
                return;

Pon_3xxxxx      movlw Car_3; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp7;
				call retardo;
				bsf portc,Com_Disp7;
				call retardo;
                return;

Pon_4xxxxx      movlw Car_4; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp7;
				call retardo;
				bsf portc,Com_Disp7;
				call retardo;
                return;

Pon_5xxxxx      movlw Car_5; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp7;
				call retardo;
				bsf portc,Com_Disp7;
				call retardo;
                return;

Pon_6xxxxx      movlw Car_6; Carga el caracter A al registro w.
                movwf portb; Envía el caracter vacio al puerto b.
				bcf portc,Com_Disp7;
				call retardo;
				bsf portc,Com_Disp7;
				call retardo;
                return;

                ;==================================================
				;==		Subrutina de retardo de medio segundo 	 ==
				;==================================================
retardo1        movlw M;
				movwf Contador3;
Loop11			movlw N;
				movwf Contador2;
Loop10			movlw L;
				movwf Contador1;
Loop9			decfsz Contador1,f;
				goto Loop9;
				decfsz Contador2,f;
				goto Loop10;
				decfsz Contador3,f;
				goto Loop11; 
	            return;     

retardo 		movlw .2;
				movwf Contador3;
Loop66			movlw .255;
				movwf Contador2;
Loop55		    decfsz Contador2,f;
				goto Loop55;
				decfsz Contador3,f;
				goto Loop66;
                return;




				end







