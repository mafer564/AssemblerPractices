;INSTITUTO POLITECNICO NACIONAL
;CECYT 9 "JUAN DE DIOS BATIZ"
;PRACTICA 4
;Teoria de operacion del Display Matricial. 
;GRUPO: 6IM2  EQUIPO:1
;INTEGRANTES:
;Vargas Espino Carlos Hassan
;Perez Jimenez Madelin Fernanda
;COMENTARIO DE LO QUE EL PROGRAMA EJECUTARA:Este programa realizara un desplegado de imagenes en el
;display maricial de 7x5.
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

M		EQU 0X20;
N		EQU 0X21;
L		EQU 0X22;
presc_1	        EQU 0x23; //
presc_2		EQU 0x24; //
cont_milis	EQU 0x25; /
	
act_col1         EQU 0X01;
act_col2         EQU 0X02;
act_col3         EQU 0X04;
act_col4         EQU 0X08;
act_col5         EQU 0X10;
des_columnas	 EQU 0X00;

;CONSTANTES	   
CarA_col1	EQU 0X03;
CarA_col2	EQU 0X6d;
CarA_col3	EQU 0X6e;
CarA_col4	EQU 0X6d;
CarA_col5	EQU 0X03;

;corregir direcciones	   
CarB_col1	EQU 0X03;
CarB_col2	EQU 0X6d;
CarB_col3	EQU 0X6e;
CarB_col4	EQU 0X6d;
CarB_col5	EQU 0X03;
	
	   
CarC_col1	EQU 0X03;
CarC_col2	EQU 0X6d;
CarC_col3	EQU 0X6e;
CarC_col4	EQU 0X6d;
CarC_col5	EQU 0X03;
	
	   
CarD_col1	EQU 0X03;
CarD_col2	EQU 0X6d;
CarD_col3	EQU 0X6e;
CarD_col4	EQU 0X6d;
CarD_col5	EQU 0X03;

	   
CarE_col1	EQU 0X03;
CarE_col2	EQU 0X6d;
CarE_col3	EQU 0X6e;
CarE_col4	EQU 0X6d;
CarE_col5	EQU 0X03;
	
	
Imagen1_col1	EQU 
Imagen1_col2	EQU
Imagen1_col3	EQU
Imagen1_col4	EQU
Imagen1_col5	EQU

Imagen2_col1	EQU
Imagen2_col2	EQU
Imagen2_col3	EQU
Imagen2_col4	EQU
Imagen2_col5	EQU
	
Imagen3_col1	EQU
Imagen3_col2	EQU
Imagen3_col3	EQU
Imagen3_col4	EQU
Imagen3_col5	EQU
	



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
Act_col1          EQU           .0;//Activacion de columna 1.
Act_col2          EQU           .1;//Activacion de columna 2.
Act_col3          EQU           .2;//Activacion de columna 3.
Act_col4          EQU           .3;//Activacion de columna 4.
Act_col4          EQU           .4;//Activacion de columna 5.

PROGB            EQU   B'11111000'; //PROGRAMACIÓN INICIAL DEL PUERTO B.

;PUERTO C.
Act_Ren1        EQU          .0; ; //CaracterA col1.
Act_Ren2	EQU          .1;  // CaracterA col2
Act_Ren3        EQU          .2; //  CaracterA col3.
Act_Ren4        EQU          .3; //  CaracterA col4.
Act_Ren5        EQU          .4; // SIN USORC4.
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

SAL_INT				MOVLW .131; 
					MOVWF TMR0;
					
					MOVF FSR_TEMP,W;
					MOVWF FSR;
					
					MOVF PCLATH_TEMP,W;
					MOVWF PCLATH;

					MOVF STATUS_TEMP,W;
					MOVWF STATUS;

					RETFIE;

;== INTERRUPCION ==

RUTINA_INT			INCF CONT_MILIS,F;
				INCF PRESC_1,F;
		
					MOVLW .100; 
					XORWF PRESC_1,W; 
					BTFSC STATUS,Z; 
					GOTO SIG_INT; 
					GOTO SAL_RUTINT; 
					
SIG_INT				CLRF PRESC_1;
					INCF PRESC_2,F;
					MOVLW .10;
					XORWF PRESC_2,W;
					BTFSS STATUS,Z;
					GOTO SAL_RUTINT;
					CLRF PRESC_1;
					CLRF PRESC_2;
		
SAL_RUTEXT			BSF BANDERAS,BAN_INT;

SAL_RUTINT			BCF INTCON,T0IF; 
					
					RETURN;
					
;== INICIO ==      

PROG_INI			BSF STATUS,RP0; 
				
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

					CLRF BANDERAS;

					MOVLW 0XFF; '0' IMPORTANTE
					MOVWF U_SEGUNDOS;
					MOVWF D_SEGUNDOS;
					MOVWF U_MINUTOS;
					MOVWF D_MINUTOS;
					MOVWF U_HORAS;
					MOVWF D_HORAS;
											
					RETURN;

;== PROGRAMA PRINCIPAL ==

loopP	    nop;
	    clrf cont_seg;
	    clrf apuntador;
	    
	   movf apuntador;
	   movwf portc;
	   movlw Act_col1;
	   movwf portb;
	   call retardo;
	   movwf des_columnas 
	   movwf portb;
	   call retardo;
	   
	   movlw CarA_col2;
	   movwf portc;
	   movlw Act_col2;
	   movwf portb;
	   call retardo;
	   movlw des_columnas
	   
	   movlw CarA_col3;
	   movwf portc;
	   movlw Act_col3;
	   movwf portb;
	   call retardo;
	   
	   movlw CarA_col4;
	   movwf portc;
	   movlw Act_col4;
	   movwf portb;
	   call retardo;
	   
	   movlw CarA_col5;
	   movwf portc;
	   movlw Act_col5;
	   movwf portb;
	   call retardo;
	   movlw des_columnas;
	   
	   ;CARACTER B
	   clrf cont_seg;
	    clrf apuntador;
	    
	   movf apuntador;
	   movwf portc;
	   movlw Act_col1;
	   movwf portb;
	   call retardo;
	   movwf des_columnas 
	   movwf portb;
	   call retardo;
	   
	   movlw CarB_col2;
	   movwf portc;
	   movlw Act_col2;
	   movwf portb;
	   call retardo;
	   movlw des_columnas
	   
	   movlw CarB_col3;
	   movwf portc;
	   movlw Act_col3;
	   movwf portb;
	   call retardo;
	   
	   movlw CarB_col4;
	   movwf portc;
	   movlw Act_col4;
	   movwf portb;
	   call retardo;
	   
	   movlw CarB_col5;
	   movwf portc;
	   movlw Act_col5;
	   movwf portb;
	   call retardo;
	   movlw des_columnas;

	;CARACTER C 
	    clrf cont_seg;
	    clrf apuntador;
	    
	   movf apuntador;
	   movwf portc;
	   movlw Act_col1;
	   movwf portb;
	   call retardo;
	   movwf des_columnas 
	   movwf portb;
	   call retardo;
	   
	   movlw CarC_col2;
	   movwf portc;
	   movlw Act_col2;
	   movwf portb;
	   call retardo;
	   movlw des_columnas
	   
	   movlw CarC_col3;
	   movwf portc;
	   movlw Act_col3;
	   movwf portb;
	   call retardo;
	   
	   movlw CarC_col4;
	   movwf portc;
	   movlw Act_col4;
	   movwf portb;
	   call retardo;
	   
	   movlw CarC_col5;
	   movwf portc;
	   movlw Act_col5;
	   movwf portb;
	   call retardo;
	   movlw des_columnas;

	   ;CARACTER D
	   clrf cont_seg;
	    clrf apuntador;
	    
	   movf apuntador;
	   movwf portc;
	   movlw Act_col1;
	   movwf portb;
	   call retardo;
	   movwf des_columnas 
	   movwf portb;
	   call retardo;
	   
	   movlw CarD_col2;
	   movwf portc;
	   movlw Act_col2;
	   movwf portb;
	   call retardo;
	   movlw des_columnas
	   
	   movlw CarD_col3;
	   movwf portc;
	   movlw Act_col3;
	   movwf portb;
	   call retardo;
	   
	   movlw CarD_col4;
	   movwf portc;
	   movlw Act_col4;
	   movwf portb;
	   call retardo;
	   
	   movlw CarD_col5;
	   movwf portc;
	   movlw Act_col5;
	   movwf portb;
	   call retardo;
	   movlw des_columnas;
	   
	   ;CARACTER E
	   
	  clrf cont_seg;
	  clrf apuntador;
	    
	   movf apuntador;
	   movwf portc;
	   movlw Act_col1;
	   movwf portb;
	   call retardo;
	   movwf des_columnas 
	   movwf portb;
	   call retardo;
	   
	   movlw CarE_col2;
	   movwf portc;
	   movlw Act_col2;
	   movwf portb;
	   call retardo;
	   movlw des_columnas
	   
	   movlw CarE_col3;
	   movwf portc;
	   movlw Act_col3;
	   movwf portb;
	   call retardo;
	   
	   movlw CarE_col4;
	   movwf portc;
	   movlw Act_col4;
	   movwf portb;
	   call retardo;
	   
	   movlw CarE_col5;
	   movwf portc;
	   movlw Act_col5;
	   movwf portb;
	   call retardo;
	   movlw des_columnas;
	   
	   ;Definir ciclos en las imagenes
	   ;IMAGEN 1
LOOPI1     clrf cont_seg;
	   clrf apuntador;
	    
	   movf apuntador;
	   movwf portc;
	   movlw Act_col1;
	   movwf portb;
	   call retardo;
	   movwf des_columnas 
	   movwf portb;
	   call retardo;
	   
	   movlw Imagen1_col2;
	   movwf portc;
	   movlw Act_col2;
	   movwf portb;
	   call retardo;
	   movlw des_columnas
	   
	   movlw Imagen1_col3;
	   movwf portc;
	   movlw Act_col3;
	   movwf portb;
	   call retardo;
	   
	   movlw Imagen1_col4;
	   movwf portc;
	   movlw Act_col4;
	   movwf portb;
	   call retardo;
	   
	   movlw Imagen1_col5;
	   movwf portc;
	   movlw Act_col5;
	   movwf portb;
	   call retardo;
	   movlw des_columnas;
	   
	   ;IMAGEN2
LOOPI2	    clrf cont_seg;
	    clrf apuntador;
	    
	   movf apuntador;
	   movwf portc;
	   movlw Act_col1;
	   movwf portb;
	   call retardo;
	   movwf des_columnas 
	   movwf portb;
	   call retardo;
	   
	   movlw Imagen2_col2;
	   movwf portc;
	   movlw Act_col2;
	   movwf portb;
	   call retardo;
	   movlw des_columnas
	   
	   movlw Imagen2_col3;
	   movwf portc;
	   movlw Act_col3;
	   movwf portb;
	   call retardo;
	   
	   movlw Imagen2_col4;
	   movwf portc;
	   movlw Act_col4;
	   movwf portb;
	   call retardo;
	   
	   movlw Imagen2_col5;
	   movwf portc;
	   movlw Act_col5;
	   movwf portb;
	   call retardo;
	   movlw des_columnas;

	   ;IMAGEN 3
LOOPI3	clrf cont_seg;
	    clrf apuntador;
	    
	   movf apuntador;
	   movwf portc;
	   movlw Act_col1;
	   movwf portb;
	   call retardo;
	   movwf des_columnas 
	   movwf portb;
	   call retardo;
	   
	   movlw Imagen3_col2;
	   movwf portc;
	   movlw Act_col2;
	   movwf portb;
	   call retardo;
	   movlw des_columnas
	   
	   movlw Imagen3_col3;
	   movwf portc;
	   movlw Act_col3;
	   movwf portb;
	   call retardo;
	   
	   movlw Imagen3_col4;
	   movwf portc;
	   movlw Act_col4;
	   movwf portb;
	   call retardo;
	   
	   movlw Imagen3_col5;
	   movwf portc;
	   movlw Act_col5;
	   movwf portb;
	   call retardo;
	   movlw des_columnas;

	   return;

;==  SUBRUTINA DE RETARDO  ==
retardo		    clrf cont_milis;
esp_time	    movlw .3;
		    xorwf cont_milis,w;
		    btfss status,z;
		    goto esp_time
	    
		 return;
					
					END;



