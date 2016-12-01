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
Contador1	equ			0x20; 
Contador2	equ			0x21; 
Contador3	equ			0x22; 
Contador4	equ			0x23; 
Contador5	equ			0x24; 
Contador6	equ			0x25; 
Contador7	equ			0x26; 
Contador8	equ			0x27; 
Contador9	equ			0x28; 
Fact_1  	equ			0x29; 
Fact_2  	equ			0x2A; 
Contadorx  	equ			0x2B; 
Contador_bajo   equ                     0x2C;
Contador_alto   equ                     0x2D;
cont_bajo       equ                     0x2E;
cont_alto       equ                     0x2F;
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;Constantes.
M			equ		  .1; 
N			equ		  .150;
L			equ		  .9;

;Constantes de ccaracteres en siete segmentos.

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
Sin_UsoRC3	equ			.3; //Sin uso RC3.
Sin_UsoRC4      equ                     .4; //Sin uso RC4.
Sin_UsoRC5      equ                     .6; //Sin uso RC5.
Sin_UsoRC6	equ			.5; //Sin uso RC6.
Sin_UsoRC7	equ			.7; //Sin uso RC7.

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
				;==   Programa principal       ==
				;================================
prog_prin		call prog_ini;

ini                     movlw Car_0;              0
                        movwf PORTB;
                        bcf PORTC, Com_Disp2;
                        call retardo;
                        bsf PORTC, Com_Disp2;
                        call retardo;

                        movlw Car_0;              0
                        movwf PORTB;
                        bcf PORTC, Com_Disp1;
                        call retardo;
                        bsf PORTC, Com_Disp1;
                        call retardo;

                        movlw Car_0;              0
                        movwf PORTB;
                        bcf PORTC, Com_Disp0;
                        call retardo;
                        bsf PORTC, Com_Disp0;
                        call retardo;
                        decfsz Contador1,f;
                        goto ini;
                 
                        goto  loop_prin;



loop_prin	                movlw sensor_bajo; Carga el dato del sensor de abajo a w.					movwf Contador1; Envía el dato al contador 1.
                                btfsc f, w;
                                goto loop_prin;
                                btfss f, w;
                                goto loop_2;

lopp_2                          movlw sensor_alto; Carga el dato del sensor de arriba a w.	                                movwf Contador2; Envía el dato al contador 1.
                                btfsc f, w;
                                goto contador_bajo;
                                btfss f, w
                                goto contador_alto;

contador_alto		        movlw sensor_alto; Carga el dato al registro w.              
                                movwf cont_alto; Envía el dato al contador.                    
				bcf PORTC, Com_Disp2;
                                call retardo;
                                bsf PORTC, Com_Disp2;
                                call retardo;

contador_bajo                   movlw sensor_bajo; 
                                movwf cont_bajo;
                                bcf PORTC, Com_Disp2;
                                call retardo;
                                bsf PORTC, Com_Disp2;
                                call retardo;

loop_max                        movlw .34; Carga el numeroal registro w.		
				movwf Contadorx; Envía el numero al contador .



loop_max1       movlw .0; Carga el numero al registro w.		
		movwf Contador4; Envía el numero al contador.
		incfsz Contador5,f;
                movlw .6;
                subwf Contador2,w;
                btfsc status,z;
                goto loop_max2;
                goto loop_max      

loop_max2       movlw .0; 		
		movwf Contador4; 
                movlw .0; 		
		movwf Contador5; 
		incfsz Contador6,f;
                movlw .10;
                subwf Contador3,w;
                btfsc status,z;
                goto loop_max3;
                goto loop_max  

loop_max3       movlw .0; 	
		movwf Contador4; 
                movlw .0; 		
		movwf Contador5; 
                movlw .0; 		
		movwf Contador6; 
		incfsz Contador7,f;
                movlw .6;
                subwf Contador4,w;
                btfsc status,z;
                goto loop_max4;
                goto loop_max 

loop_max4       movlw .0; 		
		movwf Contador4; 
                movlw .0; 		
		movwf Contador5; 
                movlw .0; 		
		movwf Contador6; 
                movlw .0; C		
		movwf Contador7; 
		incfsz Contador8,f;
                movlw .10;
                subwf Contador5,w;
                btfsc status,z;
                goto loop_max5;
                goto loop_max       

loop_max5       movlw .0; 		
		movwf Contador4; 
                movlw .0; 		
		movwf Contador5; 
                movlw .0; 		
		movwf Contador6; 
                movlw .0; 		
		movwf Contador7; 
                movlw .0; 		
		movwf Contador8; 
                movlw .1;
                subwf Contador6,w;
                btfsc status,z;
                goto loop_max6;
                goto loop_max 

loop_max6       movlw .0;               
                movwf Contador4; 
                movlw .0;             
                movwf Contador5; 
                movlw .0;              
                movwf Contador6; 
                movlw .0;              
                movwf Contador7; 
                incfsz Contador8,f;
                movlw .10;
                subwf Contador7,w;
                btfsc status,z;
                goto loop_max7;
                goto loop_max   

loop_max7       movlw .0;               
                movwf Contador4; 
                movlw .0;             
                movwf Contador5; 
                movlw .0;            
                movwf Contador6; 
                movlw .0;              
                movwf Contador7;
                incfsz Contador8,f;
                movlw .10;
                subwf Contador8,w;
                btfsc status,z;
                goto loop_max8;
                goto loop_max   

loop_max8       movlw .0;               
                movwf Contador4; 
                movlw .0;               
                movwf Contador5; 
                movlw .0;               
                movwf Contador6; 
                movlw .0;               
                movwf Contador7; 
                incfsz Contador8,f;
                movlw .10;
                subwf Fact_1,w;
                btfsc status,z;
                goto sigue;
                goto no_sigue;   

sigue   	incfsz Contador9,f;

no_sigue        movlw .2;
                subwf Contador9,w;
                btfsc status,z;
                goto loop_max9;
                goto loop_max

loop_max9       movlw .0;                
                movwf Contador2; 
                movlw .0;                
                movwf Contador3;
                movlw .0;               
                movwf Contador4; 
                movlw .0;               
                movwf Contador5; 
                movlw .0;               
                movwf Contador6; 
                movlw .0;               
                movwf Contador7; 
                movlw .2;               
                movwf Contador8; 
                movlw .1;               
                movwf Fact_1; 
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

Pon_0           movlw Car_0; 
                movwf portb; 
		bcf portc,Com_Disp0;
		call retardo;
		bsf portc,Com_Disp0;
		call retardo;
                return;

Pon_1           movlw Car_1; 
                movwf portb; 
		bcf portc,Com_Disp0;
		call retardo;
		bsf portc,Com_Disp0;
		call retardo;
                return;

Pon_2           movlw Car_2; 
                movwf portb; 
		bcf portc,Com_Disp0;
		call retardo;
		bsf portc,Com_Disp0;
		call retardo;
                return;

Pon_3           movlw Car_3; 
                movwf portb; 
		bcf portc,Com_Disp0;
		call retardo;
		bsf portc,Com_Disp0;
		call retardo;
                return;

Pon_4           movlw Car_4; 
                movwf portb; 
		bcf portc,Com_Disp0;
		call retardo;
		bsf portc,Com_Disp0;
		call retardo;
                return;

Pon_5           movlw Car_5; 
                movwf portb; 
		bcf portc,Com_Disp0;
		call retardo;
		bsf portc,Com_Disp0;
		call retardo;
                return;

Pon_6           movlw Car_6; 
                movwf portb; 
		bcf portc,Com_Disp0;
		call retardo;
		bsf portc,Com_Disp0;
		call retardo;
                return;

Pon_7           movlw Car_7; 
                movwf portb; 
		bcf portc,Com_Disp0;
		call retardo;
		bsf portc,Com_Disp0;
		call retardo;
                return;

Pon_8           movlw Car_8; 
                movwf portb; 
		bcf portc,Com_Disp0;
		call retardo;
		bsf portc,Com_Disp0;
		call retardo;
                return;

Pon_9           movlw Car_9; 
                movwf portb; 
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

                movlw .7;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_7x;

                movlw .8;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_8x;

                movlw .9;
                subwf Fact_2,w;
                btfsc status,z;
                goto Pon_9x;


Pon_0x          movlw Car_0; 
                movwf portb; 
		bcf portc,Com_Disp1;
		call retardo;
		bsf portc,Com_Disp1;
		call retardo;
                return;

Pon_1x          movlw Car_1; 
                movwf portb; 
		bcf portc,Com_Disp1;
		call retardo;
		bsf portc,Com_Disp1;
		call retardo;
                return;

Pon_2x          movlw Car_2; 
                movwf portb; 
		bcf portc,Com_Disp1;
		call retardo;
		bsf portc,Com_Disp1;
		call retardo;
                return;

Pon_3x          movlw Car_3; 
                movwf portb; 
		bcf portc,Com_Disp1;
		call retardo;
		bsf portc,Com_Disp1;
		call retardo;
                return;

Pon_4x          movlw Car_4; 
                movwf portb;
		bcf portc,Com_Disp1;
		call retardo;
		bsf portc,Com_Disp1;
		call retardo;
                return;

Pon_5x          movlw Car_5; 
                movwf portb; 
        	bcf portc,Com_Disp1;
		call retardo;
		bsf portc,Com_Disp1;
		call retardo;
                return;

Pon_6x          movlw Car_6; 
                movwf portb; 
                bcf portc,Com_Disp1;
                call retardo;
                bsf portc,Com_Disp1;
                call retardo;
                return;                

Pon_7x          movlw Car_7; 
                movwf portb; 
                bcf portc,Com_Disp1;
                call retardo;
                bsf portc,Com_Disp1;
                call retardo;
                return;

Pon_8x          movlw Car_8; 
                movwf portb; 
                bcf portc,Com_Disp1;
                call retardo;
                bsf portc,Com_Disp1;
                call retardo;
                return;

Pon_9x          movlw Car_9; 
                movwf portb; 
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

Pon_0xx         movlw Car_0;
                movwf portb;
		bcf portc,Com_Disp3;
		call retardo;
		bsf portc,Com_Disp3;
		call retardo;
                return;

Pon_1xx         movlw Car_1;
                movwf portb;
		bcf portc,Com_Disp3;
		call retardo;
		bsf portc,Com_Disp3;
		call retardo;
                return;

Pon_2xx         movlw Car_2;
                movwf portb;
		bcf portc,Com_Disp3;
		call retardo;
		bsf portc,Com_Disp3;
		call retardo;
                return;

Pon_3xx         movlw Car_3;
                movwf portb;
		bcf portc,Com_Disp3;
		call retardo;
		bsf portc,Com_Disp3;
		call retardo;
                return;

Pon_4xx         movlw Car_4;
                movwf portb;
		bcf portc,Com_Disp3;
		call retardo;
		bsf portc,Com_Disp3;
		call retardo;
                return;

Pon_5xx         movlw Car_5;
                movwf portb;
		bcf portc,Com_Disp3;
		call retardo;
		bsf portc,Com_Disp3;
		call retardo;
                return;

Pon_6xx         movlw Car_6; 
                movwf portb; 
		bcf portc,Com_Disp3;
		call retardo;
		bsf portc,Com_Disp3;
		call retardo;
                return;

Pon_7xx         movlw Car_7; 
                movwf portb; 
		bcf portc,Com_Disp3;
		call retardo;
		bsf portc,Com_Disp3;
		call retardo;
                return;

Pon_8xx         movlw Car_8; 
                movwf portb; 
		bcf portc,Com_Disp3;
		call retardo;
		bsf portc,Com_Disp3;
		call retardo;
                return;

Pon_9xx         movlw Car_9; 
                movwf portb; 
		bcf portc,Com_Disp3;
		call retardo;
		bsf portc,Com_Disp3;
		call retardo;
                return;


                return;

                ;==================================================
		;==		Subrutina de retardo de segundos ==
		;==================================================
retardo1        movlw M;
		movwf Contador3;
Loop11		movlw N;
		movwf Contador2;
Loop10		movlw L;
		movwf Contador1;
Loop9		decfsz Contador1,f;
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
Loop55		        decfsz Contador2,f;
			goto Loop55;
			decfsz Contador3,f;
                        goto Loop66;
                        return;




				end







