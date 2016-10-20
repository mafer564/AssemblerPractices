;INSTITUTO POLITECNICO NACIONAL
;CECYT 9 "JUAN DE DIOS BATIZ"
;
;Holi, este es el programiuxi 
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
#include "c:\opt\microchip\mplabcomm\v3.20.01\lib\p16f877a.inc";
 ;#include "C:\Program Files (x86)\Microchip\MPASM Suite\P16F877A.inc";
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
Car_d		equ b'10100001'; Caracter d en siete segmentos que enciende con 0 y se apaga con 1 por que #anodocomun.
Car_E		equ b'10000110'; Caracter E en siete segmentos que enciende con 0 y se apaga con 1 por que #anodocomun.
Car_J		equ b'11100001'; Caracter J en siete segmentos.
Car_o		equ b'10100011'; Caracter o en siete segmentos que enciende con 0 y se apaga con 1 por que #anodocomun.
Car_S		equ b'10010010'; Caracter S en siete segmentos que enciende con 0 y se apaga con 1 por que #anodocomun.
Car_uu		equ b'11100011'; Caracter u en siete segmentos que enciende con 0 y se apaga con 1 por que #anodocomun.
Car_null	equ b'11111111'; Caracter nulo en siete segmentos que enciende con 0 y se apaga con 1 por que #anodocomun.

;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;Asignacion de los bits de los puertos de I/O.
;Puerto A.
Sin_UsoRA0		equ	.0; // Sin uso RA0.
Sin_UsoRA1		equ	.1; // Sin uso RA1.
Sin_UsoRA2		equ	.2; // Sin uso RA2.
Sin_UsoRA3		equ	.3; // Sin uso RA3.
Sin_UsoRA4		equ	.4; // Sin uso RA4.
Sin_UsoRA5		equ	.5; // Sin uso RA5.

proga			equ	b'111111'; //Programacion inicial del puerto A.
;Puerto B.
seg_a			equ	.0; // Salida para controlar el segmento a.
seg_b			equ	.1; // Salida para controlar el segmento b.
seg_c			equ	.2; // Salida para controlar el segmento c.						
seg_d			equ	.3; // Salida para controlar el segmento d.	
seg_e			equ	.4; // Salida para controlar el segmento e.
seg_f			equ	.5; // Salida para controlar el segmento f.
seg_g			equ	.6; // Salida para controlar el segmento g.
seg_dp			equ	.7; // Segmento dep del bus de segmentos.

progb			equ	b'00000000'; //Programacion inicial del puerto B.
;Puerto C.
Com_Disp0			equ	.0; // Bit que controla el display 0.
Com_Disp1			equ	.1; // Bit que controla el display 1.
Com_Disp2			equ	.2; // Bit que controla el display 2.						
Com_Disp3			equ	.3; // Bit que controla el display 3.	
Sin_UsoRC4			equ	.4; // Sin uso RC4.
Sin_UsoRC5			equ	.5; // Sin uso RC5.
Sin_UsoRC6			equ	.6; // Sin uso RC6.
Sin_UsoRC7			equ	.7; // Sin uso RC7.

progc			equ	b'00000000'; //Programacion inicial del puerto C.
;Puerto D.
Sin_UsoRD0		equ	.0; // Sin uso RD0.
Sin_UsoRD1		equ	.1; // Sin uso RD1.
Sin_UsoRD2		equ	.2; // Sin uso RD2.
Sin_UsoRD3		equ	.3; // Sin uso RD3.	
Sin_UsoRD4		equ	.4; // Sin uso RD4.
Sin_UsoRD5		equ	.5; // Sin uso RD5.
Sin_UsoRD6		equ	.6; // Sin uso RD6.
Sin_UsoRD7		equ	.7; // Sin uso RD7.

progd			equ	b'11111111'; //Programacion inicial del puerto D.

;Puerto E.
Sin_UsoRE0		equ			.0; // Sin Uso RE0.
Sin_UsoRE1		equ			.1; // Sin Uso RE1.
Sin_UsoRE2		equ			.2; // Sin Uso RE2.

proge 			equ	b'111';// Programacion inicial del puerto E.

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


					;=====================
					;=== Vector reset ====
					;=====================
					org 0x0000;
vec_reset				clrf pclath; Asegura la pagina cero de la mem. de prog.
					goto prog_prin;
;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


					;==============================
					;=== Vector de interrupcion====
					;==============================
					org 0x0004;
vec_int					nop;


					retfie;
;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

					;==============================
					;=== Subrutina de inicio   ====
					;==============================
prog_ini				bsf status, rp0; selec. el bco. 1 de ram.
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
					movlw b'11111111';
					movwf portc;

					return;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

					;==============================
					;=== Programa Principal    ====
					;==============================
prog_prin				call prog_ini;
					
loop_prin				movlw .6;
					movwf Contador1;
					
men1					movlw Car_null;
					movwf portb;
					bcf portc,Com_Disp3;  
					call retardo; 
					bsf portc,Com_Disp3;
					call retardo;
					
					movlw Car_null;
					movwf portb;
					bcf portc,Com_Disp2;  
					call retardo; 
					bsf portc,Com_Disp2;
					call retardo;
					
					movlw Car_null;
					movwf portb;
					bcf portc,Com_Disp1; 
					call retardo; 
					bsf portc,Com_Disp1;
					call retardo;
					
					movlw Car_J;
					movwf portb;
					bcf portc,Com_Disp0;  J
					call retardo; 
					bsf portc,Com_Disp0;
					call retardo; 
					decfsz Contador,f;
					goto men1;  
					
					movlw .6;
					movwf Contador1;		
men2					movlw Car_null;
					movwf portb;
					bcf portc,Com_Disp3;  
					call retardo;;
					bsf portc,Com_Disp3;
					call retardo;
					
					movlw Car_null;
					movwf portb;
					bcf portc,Com_Disp2; 
					call retardo;
					bsf portc,Com_Disp2;
					call retardo;
					
					movlw Car_J;
					movwf portb;
					bcf portc,Com_Disp1;  J
					call retardo;
					bsf portc,Com_Disp1;
					call retardo;
					
					movlw Car_o;
					movwf portb;
					bcf portc,Com_Disp0;  o
					call retardo;
					bsf portc,Com_Disp0;
					call retardo;
					decfsz Contador,f;
					goto men2;  
					
					movlw .6;
					movwf Contador1;		
men3					movlw Car_null;
					movwf portb;
					bcf portc,Com_Disp3;  
					call retardo;
					bsf portc,Com_Disp3;
					call retardo;
					
					movlw Car_J;
					movwf portb;
					bcf portc,Com_Disp2;  J
					call retardo;
					bsf portc,Com_Disp2;
					call retardo;
					
					movlw Car_o;
					movwf portb;
					bcf portc,Com_Disp1;  o
					call retardo;
					bsf portc,Com_Disp1;
					call retardo;
					
					movlw Car_S;
					movwf portb;
					bcf portc,Com_Disp0;  s
					call retardo;
					bsf portc,Com_Disp0;
					call retardo;
					decfsz Contador,f;
					goto men3
					
					movlw .6;
					movwf Contador1;
men4					movlw Car_J;
					movwf portb;
					bcf portc,Com_Disp3;  J
					call retardo;
					bsf portc,Com_Disp3;
					call retardo;
				
					movlw Car_o;
					movwf portb;
					bcf portc,Com_Disp2;  o
					call retardo;
					bsf portc,Com_Disp2;
					call retardo;
					
					movlw Car_S;
					movwf portb;
					bcf portc,Com_Disp1;  S
					call retardo;
					bsf portc,Com_Disp1;
					call retardo;
					
					movlw Car_E;
					movwf portb;
					bcf portc,Com_Disp0;  e
					call retardo;
					bsf portc,Com_Disp0;
					call retardo;
					decfsz Contador,f;
					goto men4
					
					movlw .6;
					movwf Contador1;
men5					movlw Car_o;
					movwf portb;
					bcf portc,Com_Disp3;  o
					call retardo;
					bsf portc,Com_Disp3;
					call retardo;
					
					movlw Car_S;
					movwf portb;
					bcf portc,Com_Disp2;  s
					call retardo;
					bsf portc,Com_Disp2;
					call retardo;
					
					movlw Car_E;
					movwf portb;
					bcf portc,Com_Disp1;  e
					call retardo;
					bsf portc,Com_Disp1;
					call retardo;
					
					movlw Car_null;
					movwf portb;
					bcf portc,Com_Disp0;  
					call retardo;
					bsf portc,Com_Disp0;
					call retardo;
					decfsz Contador,f;
					goto men5
	
					movlw .6;
					movwf Contador1;
men6					movlw Car_S;
					movwf portb;
					bcf portc,Com_Disp3;  s
					call retardo;
					bsf portc,Com_Disp3;
					call retardo;
					
					movlw Car_E;
					movwf portb;
					bcf portc,Com_Disp2;  e
					call retardo;
					bsf portc,Com_Disp2;
					call retardo;
					
					movlw Car_null;
					movwf portb;
					bcf portc,Com_Disp1;  
					call retardo;
					bsf portc,Com_Disp1;
					call retardo;
					
					movlw Car_d;
					movwf portb;
					bcf portc,Com_Disp0;  d
					call retardo;
					bsf portc,Com_Disp0;
					call retardo;
					decfsz Contador,f;
					goto men6;
					
					movlw .6;
					movwf Contador1;
men7					movlw Car_E;
					movwf portb;
					bcf portc,Com_Disp3;  e
					call retardo;
					bsf portc,Com_Disp3;
					call retardo;
					
					movlw Car_null;
					movwf portb;
					bcf portc,Com_Disp2;  
					call retardo;
					bsf portc,Com_Disp2;
					call retardo;
					
					movlw Car_d;
					movwf portb;
					bcf portc,Com_Disp1;  d
					call retardo;
					bsf portc,Com_Disp1;
					call retardo;
					
					movlw Car_E;
					movwf portb;
					bcf portc,Com_Disp0;  e
					call retardo;
					bsf portc,Com_Disp0;
					call retardo;
					decfsz Contador1,f;
					goto men7;
					
					movlw .6;
					movwf Contador1;
men8					movlw Car_null;
					movwf portb;
					bcf portc,Com_Disp3;  
					call retardo;
					bsf portc,Com_Disp3;
					call retardo;
					
					movlw Car_d;
					movwf portb;
					bcf portc,Com_Disp2;  d
					call retardo;
					bsf portc,Com_Disp2;
					call retardo;
				
					movlw Car_E;
					movwf portb;
					bcf portc,Com_Disp1;  e
					call retardo;
					bsf portc,Com_Disp1;
					call retardo;
					
					movlw Car_null;
					movwf portb;
					bcf portc,Com_Disp0;  
					call retardo;
					bsf portc,Com_Disp0;
					call retardo;
					decfsz Contador,f;
					goto men8;
					
					movlw .6;
					movwf Contador1; 
men9					movlw Car_d;
					movwf portb;
					bcf portc,Com_Disp3;  d
					call retardo;
					bsf portc,Com_Disp3;
					call retardo; 
					
					movlw Car_E;
					movwf portb;
					bcf portc,Com_Disp2;  e
					call retardo;
					bsf portc,Com_Disp2;
					call retardo;
					
					movlw Car_null;
					movwf portb;
					bcf portc,Com_Disp1;  
					call retardo;
					bsf portc,Com_Disp1;
					call retardo;
					
					movlw Car_J;
					movwf portb;
					bcf portc,Com_Disp0;  J
					call retardo;
					bsf portc,Com_Disp0;
					call retardo;
					decfsz Contador, f;
					goto men9;
					
					movlw .6;
					movwf Contador1;
men10					movlw Car_E ;
					movwf portb;
					bcf portc,Com_Disp3;  E
					call retardo;
					bsf portc,Com_Disp3;
					call retardo;
					
					movlw Car_null;
					movwf portb;
					bcf portc,Com_Disp2;  
					call retardo;
					bsf portc,Com_Disp2;
					call retardo;
					
					movlw Car_J;
					movwf portb;
					bcf portc,Com_Disp1;  J
					call retardo;
					bsf portc,Com_Disp1;
					call retardo;
					
					movlw Car_E;
					movwf portb;
					bcf portc,Com_Disp0;  e
					call retardo;
					bsf portc,Com_Disp0;
					call retardo;
					decfsz Contador1,f;
					goto men10;
					
					movlw .6;
					movwf Contador1;
men11					movlw Car_null;
					movwf portb;
					bcf portc,Com_Disp3;  
					call retardo;
					bsf portc,Com_Disp3;
					call retardo;
					
					movlw Car_J;
					movwf portb;
					bcf portc,Com_Disp2;  J
					call retardo;
					bsf portc,Com_Disp2;
					call retardo;
					
					movlw Car_E;
					movwf portb;
					bcf portc,Com_Disp1;  e
					call retardo;
					bsf portc,Com_Disp1;
					call retardo;
					
					movlw Car_S;
					movwf portb;
					bcf portc,Com_Disp0;  s
					call retardo;
					bsf portc,Com_Disp0;
					decfsz Contador,f ;
					goto men11;
					
					movlw .6;
					movwf Contador1;
men12					movlw Car_J;
					movwf portb;
					bcf portc,Com_Disp3;  J
					call retardo;
					bsf portc,Com_Disp3;
					call retardo;
					
					movlw Car_E;
					movwf portb;
					bcf portc,Com_Disp2;  e
					call retardo;
					bsf portc,Com_Disp2;
					call retardo;
					
					movlw Car_S;
					movwf portb;
					bcf portc,Com_Disp1;  s
					call retardo;
					bsf portc,Com_Disp1;
					call retardo;
					
					movlw Car_uu;
					movwf portb;
					bcf portc,Com_Disp0;  u
					call retardo;
					bsf portc,Com_Disp0;
					call retardo;
					decfsz Contador,f;
					goto men12;
					
					movlw .6;
					movwf Contador1;
men13					movlw Car_E;
					movwf portb;
					bcf portc,Com_Disp3;  e
					call retardo;
					bsf portc,Com_Disp3;
					call retardo;
					
					movlw Car_S;
					movwf portb;
	    				bcf portc,Com_Disp2;  s
					call retardo;
					bsf portc,Com_Disp2;
					call retardo;
					
					movlw Car_uu;
					movwf portb;
					bcf portc,Com_Disp1;  u
					call retardo;
					bsf portc,Com_Disp1;
					call retardo;
					
					movlw Car_S;
					movwf portb;
					bcf portc,Com_Disp3;  s
					call retardo;
					bsf portc,Com_Disp3;
					call retardo;
					decfsz Contador1,f;
					goto men13
					


