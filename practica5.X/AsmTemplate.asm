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
;Suma de numeros binarios de uno o mas digitos.
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
suma equ 0x20; //
num1 equ 0x21; //
num2 equ 0x22; //
;------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;Constantes.
M			equ			  .8;
N			equ			.255;
L			equ			.255

;Constantes de caracteres en siete segmentos.
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
seg_b			equ	.1; // Salida para controlar el segmento b.
seg_c			equ	.2; // Salida para controlar el segmento c.						
seg_d			equ	.3; // Salida para controlar el segmento d.	
seg_e			equ	.4; // Salida para controlar el segmento e.
seg_f			equ .5; // Salida para controlar el segmento f.
seg_g			equ .6; // Salida para controlar el segmento g.
seg_dp			equ .7; // Salida para controlar el segmento del punto decimal.

progb			equ	b'00000000'; //Programacion inicial del puerto B.
;Puerto C.
num_1				equ	.0; // Salida para controlar el numero 1.
num_2				equ	.1; // Salida para controlar el numero 2.
Suma				equ	.2; // Suma.						
Sin_UsoRC3			equ	.3; // Sin uso RC3.	
Sin_UsoRC4			equ	.4; // Sin uso RC4.
Sin_UsoRC5			equ .5; // Sin uso RC5.
Sin_UsoRC6			equ .6; // Sin uso RC6.
Sin_UsoRC7			equ .7; // Sin uso RC7.

progc			equ	b'11111111'; //Programacion inicial del puerto C.
;Puerto D.
Disp_1				equ	.0; // Salida para controlar el display 1.
Disp_2				equ	.1; // Salida para controlar el display 2.
Sin_UsoRD2			equ	.2; // Sin uso R2.						
Sin_UsoRD3			equ	.3; // Sin uso RD3.	
Sin_UsoRD4			equ	.4; // Sin uso RD4.
Sin_UsoRD5			equ .5; // Sin uso RD5.
Sin_UsoRD6			equ .6; // Sin uso RD6.
Sin_UsoRD7			equ .7; // Sin uso RD7.

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
;prog_ini			bsf status, rp0; selec. el bco. 1 de ram.
					;movlw 0x81;
					;movwf option_reg ^0x80
					;movlw proga;
					;movwf trisa ^0x80
					;movlw progb;
					;movwf trisb ^0x80
					;movlw progc;
					;movwf trisc ^0x80
					;movlw progd;
					;movwf trisd ^0x80
					;movlw proge;
					;movwf trise ^0x80
					;movlw 0x06;
					;movwf adcon1 ^0x80; conf. el pto. a como salidas i/o.
					;bcf status, rp0;

					;clrf portb;
					;movlw 0xff;
					;movwf portc;

					;return;

prog_ini                  bsf STATUS,RP0; selec. el bco. 1 de ram.
                          movlw 0x81;
                          movwf OPTION_REG ^0x80;
                          movlw proga;
                          movwf TRISA ^0x80;
                          movlw progb;
                          movwf TRISB ^0x80;
                          movlw progc;
                          movwf TRISC ^0x80;
                          movlw progd;
                          movwf TRISD ^0x80;
                          movlw proge;
                          movwf TRISE ^0x80;
                          movwf 0x06;
                          movwf ADCON1 ^0x80; conf. el pto. a como salida i/o.
                          bcf STATUS,RP0;

                          clrf PORTB;
                          movlw b'11111111';
                          movwf PORTC; 


                          return;

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					;=============================
					;=== Programa principal   ====
					;=============================
prog_prin                 call prog_ini;

loop_prin                 call lee_num;
                          call convbin_a_7seghex;
                          call muestra_datos;
          
                          goto loop_prin;


;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					;===========================================
					;=== Subrutina que lee el num. en bin   ====
					;===========================================

lee_num                   movf PORTD,w;
                          movwf suma;
                          movlw 0x0f;
                          andwf suma,f;

esp_tec                   btfsc PORTD,PB_tecnum;
                          goto esp_tec;

                          return;

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					;===================================================
					;=== Subrutina que convierte el num bin a hex   ====
					;===================================================
convbin_a_7seghex         movlw .0;
                          subwf suma,w;
                          btfsc STATUS,Z;
                          goto fue_0;
                          movlw .1;
                          subwf suma,w;
                          btfsc STATUS,Z;
                          goto fue_1;
                          movlw .2;
                          subwf suma,w;
                          btfsc STATUS,Z;
                          goto fue_2;
                          movlw .3;
                          subwf suma,w;
                          btfsc STATUS,Z;
                          goto fue_3;
                          movlw .4;
                          subwf suma,w;
                          btfsc STATUS,Z;
                          goto fue_4;
                          movlw .5;
                          subwf suma,w;
                          btfsc STATUS,Z;
                          goto fue_5;
                          movlw .6;
                          subwf suma,w;
                          btfsc STATUS,Z;
                          goto fue_6;
                          movlw .7;
                          subwf suma,w;
                          btfsc STATUS,Z;
                          goto fue_7;
                          movlw .8;
                          subwf suma,w;
                          btfsc STATUS,Z;
                          goto fue_8;
                          movlw .9;
                          subwf suma,w;
                          btfsc STATUS,Z;
                          goto fue_9;
                          movlw .10;
                          subwf suma,w;
                          btfsc STATUS,Z;
                          goto fue_10;
                          movlw .11;
                          subwf suma,w;
                          btfsc STATUS,Z;
                          goto fue_11;
                          movlw .12;
                          subwf suma,w;
                          btfsc STATUS,Z;
                          goto fue_12;
                          movlw .13;
                          subwf suma,w;
                          btfsc STATUS,Z;
                          goto fue_13;
                          movlw .14;
                          subwf suma,w;
                          btfsc STATUS,Z;
                          goto fue_14;
                          movlw .15;
                          subwf suma,w;
                          btfsc STATUS,Z;
                          goto fue_15;
                         
fue_0                     movlw Car_0;
                          movwf suma;
                          goto salte_conv;
fue_1                     movlw Car_1;
                          movwf suma;
                          goto salte_conv;
fue_2                     movlw Car_2;
                          movwf suma;
                          goto salte_conv;
fue_3                     movlw Car_3;
                          movwf suma;
                          goto salte_conv;
fue_4                     movlw Car_4;
                          movwf suma;
                          goto salte_conv;
fue_5                     movlw Car_5;
                          movwf suma;
                          goto salte_conv;
fue_6                     movlw Car_6;
                          movwf suma;
                          goto salte_conv;
fue_7                     movlw Car_7;
                          movwf suma;
                          goto salte_conv;
fue_8                     movlw Car_8;
                          movwf suma;
                          goto salte_conv;
fue_9                     movlw Car_9;
                          movwf suma;
                          goto salte_conv;
fue_10                     movlw Car_A;
                          movwf suma;
                          goto salte_conv;
fue_11                     movlw Car_b;
                          movwf suma;
                          goto salte_conv;
fue_12                     movlw Car_C;
                          movwf suma;
                          goto salte_conv;
fue_13                     movlw Car_d;
                          movwf suma;
                          goto salte_conv;
fue_14                     movlw Car_E;
                          movwf suma;
                          goto salte_conv;
fue_15                     movlw Car_F;
                          movwf suma;
                          goto salte_conv;

                          movlw Car_null;
                          movwf suma;
                          goto salte_conv;

salte_conv                return;

					
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					;===========================================
					;=== Subrutina que muestra el n\FAmero   ====
					;===========================================
muestra_datos             movf suma;
                          movwf PORTB;
                          bcf PORTC, Com_Disp0;

                          return;


