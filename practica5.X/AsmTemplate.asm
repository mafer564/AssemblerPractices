;INSTITUTO POLITECNICO NACIONAL
;CECYT 9 "JUAN DE DIOS BATIZ"
;
;PRACTICA 5
;
;GRUPO: 5IM2. EQUIPO 9;
;INTEGRANTES:
;1.-ARRIAGA VALONA ADOLFO ALEJANDRO 
;2.-PEREZ JIMENEZ MADELIN FERNANDA
;3.- RANGEL MORALES OSCAR MAURICIO
;4.- SERVIN PEREZ NAHOMI THAIS
;
;COMENTARIO DE LO QUE EL PROGRAMA EJECUTA : 
;
;---------------------------------------------------------------------------------------------------------------------------------------------------

 list P=16F877A;
;#include "c:\archivos de programa\microchip\mpasm suite\p16f877a.inc";
#include "C:\Program Files (x86)\Microchip\MPASM Suite\P16F877A.inc";
;bits de configuracion.
 __config _XT_OSC & _WDT_OFF & _PWRT_ON & _BODEN_OFF &_ LVP_OFF & _CP_OFF;
;-------------------------------------------------------------------------------------------------------------------------------------------------------
;
;fosc = 4 Mhz
;ciclo de trabajo del PIC = (1/fosc)*4 = 1us.
;t int =(256-R)*(P)*((1/3579545)*4) = 1.0012 ms ; //tiempo de interrupcion.
;R= 249, p= 874Hz.
;------------------------------------------------------------------------------------------------------------------------------------------------------------
;
; REGISTROS DE PROPOCITO GENERAL BANCO 0 DE MEMORIA RAM.
;	
;Registros propios de estructura del programa
;variables.
Contador1 equ 0x20; //
Contador2 equ 0x21; //
Contador3 equ 0x22; //
;------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;Constantes.
M			equ			  .8;
N			equ			.255;
L			equ			.255

;Constantes de caracteres en siete segmentos.
Car_A		equ b'01110111'; Caracter A en siete segmentos.
Car_b		equ b'01111100'; Caracter b en siete segmentos.
Car_C		equ b'00111001'; Caracter C en siete segmentos.
Car_d		equ b'01011110'; Caracter d en siete segmentos.
Car_E		equ b'01111001'; Caracter E en siete segmentos.
Car_F		equ b'01110001'; Caracter F en siete segmentos.
Car_G		equ b'01111101'; Caracter G en siete segmentos.
Car_gg		equ b'01110111'; Caracter A en siete segmentos.
Car_H		equ b'01110100'; Caracter H en siete segmentos.
Car_hh		equ b'00000100'; Caracter A en siete segmentos.
Car_i		equ b'00000100'; Caracter i en siete segmentos.
Car_J		equ b'00011110'; Caracter J en siete segmentos.
Car_L		equ b'00111000'; Caracter L en siete segmentos.
Car_n		equ b'01010100'; Caracter n en siete segmentos.
Car_o		equ b'01011100'; Caracter o en siete segmentos.
Car_P		equ b'01110011'; Caracter P en siete segmentos.
Car_q		equ b'01100111'; Caracter q en siete segmentos.
Car_r		equ b'01010000'; Caracter r en siete segmentos. 
Car_S		equ b'01101101'; Caracter S en siete segmentos.
Car_t		equ b'01111000'; Caracter t en siete segmentos.
Car_U		equ b'01110111'; Caracter A en siete segmentos.
Car_uu		equ b'00011100'; Caracter u en siete segmentos.
Car_Y		equ b'01110111'; Caracter A en siete segmentos.
Car_yy		equ b'01101110'; Caracter Y en siete segmentos.
Car_Z		equ b'01011011'; Caracter Z en siete segmentos.
Car_zz		equ b'01110111'; Caracter A en siete segmentos.
Car_0		equ b'00111111';Caracter 0 en siete segmentos.
Car_1		equ b'00000110';Caracter 0 en siete segmentos.
Car_2		equ b'01011011';Caracter 0 en siete segmentos.
Car_3		equ b'01001111';Caracter 0 en siete segmentos.
Car_4		equ b'01100110';Caracter 0 en siete segmentos.
Car_5		equ b'01101101';Caracter 0 en siete segmentos.
Car_6		equ b'01111101';Caracter 0 en siete segmentos.
Car_7		equ b'00000111';Caracter 0 en siete segmentos.
Car_8		equ b'01111111';Caracter 0 en siete segmentos.
Car_9		equ b'01100111';Caracter 0 en siete segmentos.
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;Asignacion de los bits de los puertos de I/O.
;Puerto A.
Sin_UsoRA0		equ	.0; // Sin uso RA0.
Sin_UsoRA1		equ	.1; // Sin uso RA1.
Sin_UsoRA2		equ	.2; // Sin uso RA2.
Sin_UsoRA3		equ	.3; // Sin uso RA3.
Sin_UsoRA4		equ	.4; // Sin uso RA4.
Sin_UsoRA5		equ .5; // Sin uso RA5.

proga			equ	b'111111'; //Programacion inicial del puerto A.
;Puerto B.
seg_a			equ	.0; // Salida para controlar el segmento a.
seg_b			equ	.1; // Sin uso RB1.
seg_c			equ	.2; // Sin uso RB2.						
seg_d			equ	.3; // Sin uso RB3.	
seg_e			equ	.4; // Sin uso RB4.
seg_f			equ .5; // Sin uso RB5.
seg_g			equ .6; // Sin uso RB6.
seg_dp			equ .7; // Sin uso RB7

progb			equ	b'00000000'; //Programacion inicial del puerto B.
;Puerto C.
Bit0_numbin			equ	.0; // Sin uso RC0.
Bit1_numbin			equ	.1; // Sin uso RC1.
Bit2_numbin			equ	.2; // Sin uso RC2.						
Bit3_numbin			equ	.3; // Sin uso RC3.	
Sin_UsoRC4			equ	.4; // Sin uso RC4.
Sin_UsoRC5			equ .5; // Sin uso RC5.
Sin_UsoRC6			equ .6; // Sin uso RC6.
PB_tecnum			equ .7; // Sin uso RC7.

progc			equ	b'11111111'; //Programacion inicial del puerto C.
;Puerto D.
Disp_1			equ	.0; // Salida para controlar el display 1.
Disp_2			equ	.1; // Salida para controlar el display 2.
Disp_3			equ	.2; // Salida para controlar el display 3.						
Disp_4			equ	.3; // Salida para controlar el display 4.	
Disp_5			equ	.4; // Salida para controlar el display 5.
Disp_6			equ .5; // Salida para controlar el display 6.
Disp_7			equ .6; // Salida para controlar el display 7.
Disp_8			equ .7; // Salida para controlar el display 8.

progd			equ	b'00000000'; //Programacion inicial del puerto D.

;Puerto E.
Sin_UsoRE0		equ			.0; // Sin Uso RE0
Sin_UsoRE1		equ			.1; // Sin Uso RE1
Sin_UsoRE2		equ			.2; // Sin Uso RE2

proge 			equ		b'111';// Programacion inicial del puerto E.

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


					;=====================
					;=== Vector reset ====
					;=====================
					org 0x0000;
vec_reset			clrf pclath; Asegura la pagina cero de la mem. de prog.
					goto prog_prin;
;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


					;==============================
					;=== Vector de interrupcion====
					;==============================
					org 0x0004;
vec_int				nop;


					retfie;
;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

					;==============================
					;=== Subrutina de inicio   ====
					;==============================
prog_ini			bsf status, rp0; selec. el bco. 1 de ram.
					movlw 0x81;
					movwf option_reg ^0x80
					movlw proga;
					movwf trisa ^0x80
					movlw progb;
					movwf trisb ^0x80
					movlw progc;
					movwf trisc ^0x80
					movlw progd;
					movwf trisd ^0x80
					movlw proge;
					movwf trise ^0x80
					movlw 0x06;
					movwf adcon1 ^0x80; conf. el pto. a como salidas i/o.
					bcf status, rp0;

					clrf portb;
					movlw 0xff;
					movwf portc;

					return;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					;=============================
					;=== Programa principal   ====
					;=============================
prog_prin			call prog_ini;

loop_prin			call lee_num:
					call convbin_a_h7seg;
					call muestra_numhex;

					goto loop_prin;


;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					;===========================================
					;=== Subrutina que lee el num. en bin   ====
					;===========================================

lee_num				movf	portc,w;
					movwf	resp_num;
					movlw	0x0f;
					andwf	resp_num, f;
esp_tec				btfsc	portd,PB_tecnum;
					goto	esp_tec;

					return;

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					;===================================================
					;=== Subrutina que convierte el num bin a hex   ====
					;===================================================
convbin_a_h7seg		movlw .0;
					subwf resp_num,w;
					btfsc status, Z;
					goto fue_0;
					movlw .1;
					subwf resp_num,w;
					btfsc status,Z;
					goto fue_1;
					movlw .2;
					subwf resp_num,w;
					btfsc status,Z;
					goto fue_2;
					movlw .3;
					subwf resp_num,w;
					btfsc status,Z;
					goto fue_3;
					movlw .4;
					subwf resp_num,w;
					btfsc status,Z;
					goto fue_4;
					movlw .5;
					subwf resp_num,w;
					btfsc status,Z;
					goto fue_5;
					movlw .6;
					subwf resp_num,w;
					btfsc status,Z;
					goto fue_6;
					movlw .7;
					subwf resp_num,w;
					btfsc status,Z;
					goto fue_7;
					movlw .8;
					subwf resp_num,w;
					btfsc status,Z;
					goto fue_8;
					movlw .9;
					subwf resp_num,w;
					btfsc status,Z;
					goto fue_9;
					movlw .10;
					subwf resp_num,w;
					btfsc status,Z;
					goto fue_10;
					movlw .11;
					subwf resp_num,w;
					btfsc status,Z;
					goto fue_11;
					movlw .12;
					subwf resp_num,w;
					btfsc status,Z;
					goto fue_12;
					movlw .13;
					subwf resp_num,w;
					btfsc status,Z;
					goto fue_13;
					movlw .14;
					subwf resp_num,w;
					btfsc status,Z;
					goto fue_14;
					movlw .15;
					subwf resp_num,w;
					btfsc status,Z;
					goto fue_15;
					return;

					
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					;===========================================
					;=== Subrutina que muestra el n\FAmero   ====
					;===========================================
muestra_numhex		


