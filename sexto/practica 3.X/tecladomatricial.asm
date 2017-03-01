;INSTITUTO POLITECNICO NACIONAL
;CECYT 9 "JUAN DE DIOS BATIZ"
;
;PRACTICA 2
;INGRESO DE DATOS AL SISTEMA CON TECLADO MATRICIAL 4X4. 
;
;GRUPO: 6IM2  EQUIPO:
;
;INTEGRANTES:
;
;COMENTARIO DE LO QUE EL PROGRAMA EJECUTARA: 
;El programa inicializara un reloj tipo militar de 24 hrs.
;
 LIST P=16F877A;

;#INCLUDE "C:\ARCHIVOS DE PROGRAMA\MICROCHIP\MPASM SUITE\P16F877A.INC";
#INCLUDE "C:\PROGRAM FILES (X86)\MICROCHIP\MPASM SUITE\P16F877A.INC";

;BITS DE CPONFIGURACIÓN

  __CONFIG _XT_OSC & _WDT_OFF & _PWRTE_ON & _BODEN_OFF & _LVP_OFF & _CP_OFF;


;REGISTROS DE PROPOSITO GENERAL BANCO  0 DE MEMORIA RAM.

Var_teclado	EQU 0x20;
Var_tecopri	EQU 0x21;
Contador1	EQU 0x22;
Contador2	EQU 0x23;
Contador3	EQU 0x24;

;CONSTANTES
M	EQU .3;
N	EQU .255;
L	EQU  .255;
No_haytecla	EQU 0xF0;
Tec_0	EQU 0xE0;
Tec_1	EQU 0xD0;
Tec_2	EQU 0xB0;
Tec_3	EQU 0x70;
Tec_4	EQU 0xE0;
Tec_5	EQU 0xD0;
Tec_6	EQU 0xB0;
Tec_7	EQU 0x70;
Tec_8	EQU 0xE0;
Tec_9	EQU 0xD0;
Tec_A	EQU 0xB0;
Tec_B	EQU 0x70;
Tec_C	EQU 0xE0;
Tec_D	EQU 0xD0;
Tec_E	EQU 0xB0;
Tec_F	EQU 0x70;

;ASIGNACIÓIN DE LOS BITS DE LOS PUERTOS DE I/O.
;PUERTO A.
SIN_USORA0       EQU          .0; // SIN USORA0.
SIN_USORA1       EQU          .1; // SIN USORA1.
SIN_USORA2       EQU          .2; // SIN USORA2.
SIN_USORA3       EQU          .3; // SIN USORA3.
SIN_USORA4       EQU          .4; // SIN USORA4.
SIN_USORA5       EQU          .5; // SIN USORA5.

PROGA            EQU    B'00000000'; //PROGRAMACIÓN INICIAL DEL PUERTO A.

;PUERTO B.
Act_Ren1          EQU           .0;//SALIDA PARA ACTIVAR EL RENGLON1.
Act_Ren2          EQU           .1;//SALIDA PARA ACTIVAR EL RENGLON 2.
Act_Ren3          EQU           .2;//SALIDA PARA ACTIVAR EL RENGLON 3.
Act_Ren4          EQU           .3;//SALIDA PARA ACTIVAR EL RENGLON 4.
Col_1             EQU           .4;//ENTRADA PARA LEER LA COLUMNA 1 .
Col_2             EQU           .5;//ENTRADA PARA LEER LA COLUMNA 2.
Col_3             EQU           .6;//ENTRADA PARA LEER LA COLUMNA 3.
Col_4             EQU           .7;//ENTRADA PARA LEER LA COLUMNA 4.


PROGB            EQU   B'11110000'; //PROGRAMACIÓN INICIAL DEL PUERTO B.

;PUERTO C.
Bit_D0LCD           EQU          .0; // BIT 0 DE DATOS O COMANDOS PARA LA LCD.
Bit_D1LCD           EQU          .1; // BIT 1 DE DATOS O COMANDOS PARA LA LCD.
Bit_D2LCD           EQU          .2; // BIT 2 DE DATOS O COMANDOS PARA LA LCD.
Bit_D3LCD           EQU          .3; // BIT 3 DE DATOS O COMANDOS PARA LA LCD.
Bit_D4LCD           EQU          .4; // BIT 4 DE DATOS O COMANDOS PARA LA LCD.
Bit_D5LCD           EQU          .5; // BIT 5 DE DATOS O COMANDOS PARA LA LCD.
Bit_D6LCD           EQU          .6; // BIT 6 DE DATOS O COMANDOS PARA LA LCD.
Bit_D7LCD           EQU          .7; // BIT 7 DE DATOS O COMANDOS PARA LA LCD.


PROGC            EQU    B'00000000'; //PROGRAMACIÓN INICIAL DEL PUERTO C.

;PUERTO D.
RS_LCD		 EQU	      .0; // PIN DE SALIDA MODO COMANDOS.
ENABLE_LCD	 EQU	      .1; // PIN DE SALIDA ENABLE LCD.
SIN_USORD2       EQU          .2; // SIN USORD2.
SIN_USORD3       EQU          .3; // SIN USORD3.
SIN_USORD4       EQU          .4; // SIN USORD4.
SIN_USORD5       EQU          .5; // SIN USORD5.
SIN_USORD6       EQU          .6; // SIN USORD6.
SIN_USORD7       EQU          .7; // SIN USORD7.  

PROGD            EQU    B'11111100'; //PROGRAMACIÓN INICIAL DEL PUERTO D.

;PUERTO E.

SIN_USORE0       EQU          .0; // SIN USORE0.
SIN_USORE1       EQU          .1; // SIN USORE1.
SIN_USORE2       EQU          .2; // SIN USORE2.

PROGE            EQU     B'111';  //PROGRMACIÓN INICIAL DEL PUERTO E.
	    
;== INICIALIZACION LCD ==

INI_LCD				BCF PORTC,RS_LCD; 
				
				MOVLW 0X38;
				MOVWF PORTB;
				CALL PULSO_ENABLE;

				MOVLW 0X0C;
				MOVWF PORTB;
				CALL PULSO_ENABLE;

				MOVLW 0X01;
				MOVWF PORTB;
				CALL PULSO_ENABLE;

				MOVLW 0X06;
				MOVWF PORTB;
				CALL PULSO_ENABLE;
					
				MOVLW 0X80;
				MOVWF PORTB;
				CALL PULSO_ENABLE;

				BSF PORTC,RS_LCD; 
					
				RETURN;
;== PULSO ENABLE ==

PULSO_ENABLE		BCF PORTC,ENABLE_LCD; PONE EN BAJO ENABLE

					CLRF CONT_MILIS;
ESP_TIEMPO			MOVLW .1;
					XORWF CONT_MILIS,W;
					BTFSS STATUS,Z;
					GOTO ESP_TIEMPO;

					BSF PORTC,ENABLE_LCD; PONE EN ALTO ENABLE 
					
					CLRF CONT_MILIS;
ESP_TIEMPO1			MOVLW .40;
					XORWF CONT_MILIS,W;
					BTFSS STATUS,Z;
					GOTO ESP_TIEMPO1;

					RETURN;

;======================================
;=========== VECTOR RESET =============
;======================================

		            ORG 0X0000;
VEC_RESET           CLRF PCLATH;
                    GOTO PROG_PRIN;
;======================================
;======= VECTOR INTERRUPCION ==========
;======================================		    

                    ORG 0X0004;
VEC_INT            NOP;
		   RETFIE;
;======================================
;======================================		   
;=======SUBRUTINA DE INICIO ===========      
;======================================
;======================================
PROG_INI			BSF STATUS,RP0; 
				
					MOVLW 0X02; 
					MOVWF OPTION_REG ^0X80; 

                    MOVLW PROGA;
					MOVWF TRISA ^0X80;

                    MOVLW PROGB;
					MOVWF TRISB ^0X80;

                    MOVLW PROGC;
					MOVWF TRISC ^0X80;

                    MOVLW PROGD;
					MOVWF TRISD ^0X80;

                    MOVLW PROGE;
					MOVWF TRISE ^0X80;

                    MOVLW 0X06;
		;HASTA AQUI ESTA BIEN!			
	;	    MOVWF ADCON1 ^0X80;

	;	    BCF STATUS,RP0; 
	
;	    		MOVLW .131; 
	; 		MOVWF TMR0 ^0X00;
;			MOVLW 0XA0;
	;		MOVWF INTCON ^0X00; 
				
					CLRF PORTC;

					MOVLW 0X03;
					MOVWF PORTD ;

					;CLRF BANDERAS;

					MOVLW 0X0F;
					MOVWF PORTB;
											
					RETURN;
;======================================
;======================================
;======= PROGRAMA PRINCIPAL ===========
;======================================
;======================================
PROG_PRIN           CALL PROG_INI;
		    CALL INI_LCD;
		   
LOOP_PRIN	    CALL BARRE_TECLADO;
		    CALL MUESTRA_TECLA;
		    
		    GOTO LOOP_PRIN;
;===============================================		  
;===============================================
;==== SUBRUTINA DE RETARDO DE MEDIO SEGUNDO=====
;===============================================
;===============================================
BARRE_TECLADO	BSF PORTB,Act_Ren4;
		NOP;
		BCF PORTB,Act_Ren1;
		MOVF PORTB,W;
		MOVWF Var_teclado;
		MOVLW 0XF0;
		ANDWF Var_teclado,f;
		
		MOVLW No_haytecla;
		XORWF Var_teclado,w;
		BTFSC STATUS,Z;
		GOTO sig_Ran2;
		MOVLW Tec_0;
		XORWF Var_teclado,w;
		BTFSC STATUS,Z;
		GOTO Fue_Tec0;
		MOVLW Tec_1;
		XORWF Var_teclado,w;
		BTFSC STATUS,Z;
		GOTO Fue_Tec1;
	
		MOVLW Tec_2
		XORWF Var_teclado,w;
		BTFSC STATUS,Z;
		GOTO Fue_Tec2;
		
		MOVLW Tec_3
		XORWF Var_teclado,w;
		BTFSC STATUS,Z;
		GOTO Fue_Tec3;
;NO SE SI LOS SIG_RAN ESTAN BIEN 
sig_Ran2	BSF PORTB,Act_Ren1;
		NOP;
		
sig_Ran3

		
sig_Ran4
		
Fue_Tec0    MOVLW '0';
	    MOVWF Var_tecopri;
	    GOTO SAL_BARRETEC;

Fue_Tec1    MOVLW '1';
	    MOVWF Var_tecopri;
	    GOTO SAL_BARRETEC;

Fue_Tec2    MOVLW '2';
	    MOVWF Var_tecopri;
	    GOTO SAL_BARRETEC;

Fue_Tec3    MOVLW '3';
	    MOVWF Var_tecopri;
	    GOTO SAL_BARRETEC;

Fue_Tec4    MOVLW '4';
	    MOVWF Var_tecopri;
	    GOTO SAL_BARRETEC;

Fue_Tec5    MOVLW '5';
	    MOVWF Var_tecopri;
	    GOTO SAL_BARRETEC;

Fue_Tec6    MOVLW '6';
	    MOVWF Var_tecopri;
	    GOTO SAL_BARRETEC;

Fue_Tec7    MOVLW '7';
	    MOVWF Var_tecopri;
	    GOTO SAL_BARRETEC;

Fue_Tec8    MOVLW '8';
	    MOVWF Var_tecopri;
	    GOTO SAL_BARRETEC;

Fue_Tec9    MOVLW '9';
	    MOVWF Var_tecopri;
	    GOTO SAL_BARRETEC;

Fue_TecA    MOVLW 'A';
	    MOVWF Var_tecopri;
	    GOTO SAL_BARRETEC;

Fue_TecB    MOVLW 'B';
	    MOVWF Var_tecopri;
	    GOTO SAL_BARRETEC;

Fue_TecC    MOVLW 'C';
	    MOVWF Var_tecopri;
	    GOTO SAL_BARRETEC;

Fue_TecD    MOVLW 'D';
	    MOVWF Var_tecopri;
	    GOTO SAL_BARRETEC;

Fue_TecE    MOVLW 'E';
	    MOVWF Var_tecopri;
	    GOTO SAL_BARRETEC;

Fue_TecF    MOVLW 'F';
	    MOVWF Var_tecopri;
	    GOTO SAL_BARRETEC;
;======================================		
;======================================		
;======SUBRUTINA DE MEDIO SEGUNDO======
;======================================
;======================================
Muestra_tecla	MOVLW 'C';
		XORWF Var_tecopri,w;
		BTFSS STATUS,Z;
		GOTO MUES_TEC;
		BCF PORTD,RS_LCD;
		MOVLW sal_muestec;
		
MUES_TEC	MOVF Var_tecopri;
		MOVWF PORTC;
		CALL pulso_Enable;
sal_muestec	RETURN;
	    
	    
	    
	    
	    
	    END;
		




