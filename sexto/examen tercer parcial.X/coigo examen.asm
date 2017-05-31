;INSTITUTO POLITECNICO NACIONAL
;CECYT 9 "JUAN DE DIOS BATIZ"
;PRACTICA 1
;RELOJ DE TIEMPO REAL CON INTERRUPCIONES. 
;GRUPO: 6IM2  EQUIPO:
;INTEGRANTES:
;COMENTARIO DE LO QUE EL PROGRAMA EJECUTARA: 
 LIST P=16F877A;

;#INCLUDE "C:\ARCHIVOS DE PROGRAMA\MICROCHIP\MPASM SUITE\P16F877A.INC";
#INCLUDE "C:\PROGRAM FILES (X86)\MICROCHIP\MPASM SUITE\P16F877A.INC";

;BITS DE CPONFIGURACIÓN
  __CONFIG _XT_OSC & _WDT_OFF & _PWRTE_ON & _BODEN_OFF & _LVP_OFF & _CP_OFF;

;FOSC=4MHZ
;CICLO DE TRABAJO DEL PIC=(1/FOSC)*4=1US.
;T INT= (256-R)*(P)*(1/4000000)*4)= 1MS ;//TIEMPO DE INTERRUPCION.
;R=131    P=8.
;FREC INT = 1/T INT= 1 KHZ.

;REGISTROS DE PROPOSITO GENERAL BANCO  0 DE MEMORIA RAM.
;VARIABLES.

W_TEMP		EQU 0X20;
STATUS_TEMP	EQU 0X21;
PCLATH_TEMP	EQU 0X22;
FSR_TEMP	EQU 0X23;

PRESC_1		EQU 0X24;
PRESC_2		EQU 0X25;



U_SEGUNDOS	EQU 0X32;
CONT_MILIS	EQU 0X33;

;CONSTANTES
Car_A       equ   b'01110111'; Caracter A en siete segmentos
Car_b       equ   b'01111100'; Caracter b en siete segmentos
Car_C       equ   b'00111001'; Caracter C en siete segmentos
Car_D       equ   b'01011110'; Caracter d en siete segmentos
Car_E       equ   b'01111001'; Caracter E en siete segmentos
Car_F       equ   b'01110001'; Caracter F en siete segmentos
Car_G       equ   b'01111101'; Caracter G en siete segmentos
Car_H       equ   b'01110110'; Caracter H en siete segmentos
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
Car_Y       equ   b'01101110'; Caracter y en siete segemntos
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
;ASIGNACIÓIN DE LOS BITS DE LOS PUERTOS DE I/O.
;PUERTO A.
SIN_USORA0       EQU          .0; // SIN USORA0.
SIN_USORA1       EQU          .1; // SIN USORA1.
SIN_USORA2       EQU          .2; // SIN USORA2.
SIN_USORA3       EQU          .3; // SIN USORA3.
SIN_USORA4       EQU          .4; // SIN USORA4.
SIN_USORA5       EQU          .5; // SIN USORA5.

PROGA            EQU    B'11111111'; //PROGRAMACIÓN INICIAL DEL PUERTO A.

;PUERTO B.
DATA_SER	 EQU          .0; // SIN USORA0.
CLK_SER		   EQU          .1; // SIN USORA1.
CLK_PAR	          EQU          .2; // SIN USORA2.
SIN_USORB3       EQU          .3; // SIN USORA3.
SIN_USORB4       EQU          .4; // SIN USORA4.
SIN_USORB5       EQU          .5; // SIN USORA5.
SIN_USORB6       EQU          .4; // SIN USORA4.
SIN_USORB7       EQU          .5; // SIN USORA5.

PROGB            EQU   B'11111000'; //PROGRAMACIÓN INICIAL DEL PUERTO B.

;PUERTO C.
SIN_USORC0	 EQU          .0; // SEÑAL DE CONTROL (COMANDO/DATOS).
SIN_USORC1       EQU          .1; // SEÑAL DE INGRESO DE INFORMACION.
SIN_USORC2       EQU          .2; // SIN USORC2.
SIN_USORC3       EQU          .3; // SIN USORC3.
SIN_USORC4       EQU          .4; // SIN USORC4.
SIN_USORC5       EQU          .5; // SIN USORC5.
SIN_USORC6       EQU          .6; // SIN USORC6.
SIN_USORC7       EQU          .7; // SIN USORC7.

PROGC            EQU    B'11111000'; //PROGRAMACIÓN INICIAL DEL PUERTO C.

;PUERTO D.
SIN_USORD0		 EQU		  .0; // SIN USORD0.
SIN_USORD1		 EQU		  .1; // SIN USORD1.
SIN_USORD2       EQU          .2; // SIN USORD2.
SIN_USORD3       EQU          .3; // SIN USORD3.
SIN_USORD4       EQU          .4; // SIN USORD4.
SIN_USORD5       EQU          .5; // SIN USORD5.
SIN_USORD6       EQU          .6; // SIN USORD6.
SIN_USORD7       EQU          .7; // SIN USORD7.  

PROGD            EQU    B'00000000'; //PROGRAMACIÓN INICIAL DEL PUERTO D.

;PUERTO E.

SIN_USORE0       EQU          .0; // SIN USORE0.
SIN_USORE1       EQU          .1; // SIN USORE1.
SIN_USORE2       EQU          .2; // SIN USORE2.

PROGE            EQU     B'111';  //PROGRMACIÓN INICIAL DEL PUERTO E.

;BANDERAS

BAN_INT			 EQU		  .0;
SIN_USOB1		 EQU		  .1;
SIN_USOB2		 EQU		  .2;
SIN_USOB3		 EQU		  .3;
SIN_USOB4		 EQU		  .4;
SIN_USOB5		 EQU		  .5;
SIN_USOB6		 EQU		  .6;
SIN_USOB7		 EQU		  .7;

;== VECTOR RESET ==

		            ORG 0X0000;
VEC_RESET           CLRF PCLATH;
                    GOTO PROG_PRIN;
;== VECTOR INTERRUPCION ==
                    ORG 0X0004;
VEC_INT             MOVWF W_TEMP;	

		    MOVF STATUS,W;
		    MOVWF STATUS_TEMP;	
		    CLRF STATUS;

		    MOVF PCLATH,W;
		    MOVWF PCLATH_TEMP;	
		    CLRF PCLATH;
		
		    MOVF FSR,W;
		    MOVWF FSR_TEMP;

		    BTFSC INTCON,T0IF;
		    CALL RUTINA_INT; 

SAL_INT		    MOVLW .131; 
		    MOVWF TMR0;
					
		    MOVF FSR_TEMP,W;
		    MOVWF FSR;
				
		    MOVF PCLATH_TEMP,W;
		    MOVWF PCLATH;

		    MOVF STATUS_TEMP,W;
		    MOVWF STATUS;

		    RETFIE;

;== INTERRUPCION ==

RUTINA_INT	    INCF CONT_MILIS,F;
		    INCF PRESC_1,F;
		
		    MOVLW .100; 
		    XORWF PRESC_1,W; 
		    BTFSC STATUS,Z; 
		    GOTO SIG_INT; 
		    GOTO SAL_RUTINT; 
					
SIG_INT		    CLRF PRESC_1;
		    INCF PRESC_2,F;
		    MOVLW .10;
		    XORWF PRESC_2,W;
		    BTFSS STATUS,Z;
		    GOTO SAL_RUTINT;
		    CLRF PRESC_1;
		    CLRF PRESC_2;
		
SAL_RUTEXT	    BSF BANDERAS,BAN_INT;

SAL_RUTINT	    BCF INTCON,T0IF; 
					
		    RETURN;
					
;== INICIO ==      

PROG_INI	BSF STATUS,RP0; 
				
		MOVLW 0X82; 
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
		MOVWF ADCON1 ^0X80;

		BCF STATUS,RP0; 
	
		MOVLW .131; 
		MOVWF TMR0 ^0X00;

		MOVLW 0XA0;
		MOVWF INTCON ^0X00; 
				
		CLRF PORTB ^0X00;

		MOVLW 0Xff;
		MOVWF PORTC ^0X00;

											
		RETURN;

;== PROGRAMA PRINCIPAL ==

PROG_PRIN           CALL PROG_INI;
	            
		    NOP;
		    MOVLW CAR_A;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_B;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;

		   MOVLW CAR_C;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_D;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_E;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_F;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_G;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_H;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_i;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_J;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_L;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_N;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_O;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_P;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_Q;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_R;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_S;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_T;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_U;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_V;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
				
		    MOVLW CAR_Y;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_0;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_1;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_2;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_3;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_4;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_5;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_6;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_7;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_8;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    MOVLW CAR_9;
		    MOVWF TX_DATA;
		    CALL TRANSMITE;
		    CALL RETARDO_SEG;
		    
		    goto prog_prin;
		    return;
		 ;=============================================
                 ;== Subrutina Transmite==
                 ;=============================================
TRANSMITE	MOVLW .8;
		 MOVWF CONTADOR;
		 BCF STATUS,C;
		 
		 
sig_endata	RLF TX_DATA,F;
		 BTFSS STATUS,C;
		 GOTO CERO;
		 BSF PORTB, DATA_SER;
		 GOTO GEN_PULSO;
	
CERO		BSF PORTB, DATA_SER;

GEN_PULSO	NOP;
		bsf portb,clk_ser;
		call retardo;
		bcf portb,clk_ser;

		decfsz contador,f ;
		goto sig_endta;

		bsf portb,clk_para;
		call retardo;
		bcf portb,clk_para;
              
                return;
		 ;=============================================
                 ;== Subrutina de retardo de medio segundo ==
                 ;=============================================
retardo	       CLRF CONT_MILIS;
esp_time	MOVLW .1;
                XORWF CONT_MILIS,W;
		 BTFSS STATUS,Z;
		GOTO ESP_TIME;
              
                return;
		;=============================================
                 ;== Subrutina de retardo de medio segundo ==
                 ;=============================================
retardo_SEG     CLRF CONT_SEG;
ESP_TIMESEG	MOVLW .1;
               XORWF  CONT_SEG,W;
		BTFSS STATUS,Z;
               GOTO  ESP_TIMESEG;
		              
                return;
					END;



