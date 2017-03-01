
;INSTITUTO POLITECNICO NACIONAL
;CECYT9 JUAN DE DIOS BATIZ
;
;PRACTICA 2:"Prender led usando interrupciones" 
;
;GRUPO: 6IM2.   EQUIPO 
;
;INTEGRANTES:
;
;DESCRIPCION DE LA PRACTICA: Prender y apagar un led con una interrupcion de 1 segundo.
;
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
;t int= (256-R)*(P)*(1/4000000)= 1ms // Tiempo de interrupcion
;R=131, p=8
;frec int= 1/t int= 1KHz
;DEFINIR VARIABLES EN RAM

resp_w	      equ   0x20;
resp_status   equ   0x21;
resp_pclath   equ   0x22;
res_fsr       equ   0x23;
presc_1       equ   0x24;
presc_2	      equ   0x25;
cont_milis    equ   0x26;
cont_unidades equ   0x27;
cont_decenas  equ   0x28;
; LAS VARIABLES DE USUARIO COMIENZAN DESDE LA DIRECCION 20
;---------------------------------------------------------------------------------------------------------------------------------------------------
;
;DEFINIR CONSTANTES
; Codigo de caracteres alfanumericos en 7 segmentos. 
M	    equ    .2;
N	    equ    .2;
L	    equ    .2;
num_itera   equ    .10;
decenas	    equ    0x35;
;cod. de los caracteres en 7 segmentos.
Car_A	    equ   b'01110111';
Car_B	    equ	  0xc7;
Car_0	    equ   0x3f;
Car_1	    equ   0x06;
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
Led_Rojo      equ    .2;

proge         equ    b'011';Programación inicial del puerto E como entradas
;-----------------------------------------------------------------------------------------------------------------------------------------
;		    
;-----------------------------------------------------------------------------------------------------------------------------------------
;
                 ;==================
                 ;== VECTOR RESET ==
                 ;==================
                 org 0x0000; 
vec_reset        clrf PCLATH; Asegurará la pagina 0 de la memoria del programa
                 goto prog_prin; Indica que vaya a la etiqueta prog_prin
;-----------------------------------------------------------------------------------------------------------------------------------------
                 ;== INICIALIZACION LCD ==

muestra_cta			BCF PORTC,RS_LCD; 
				
				MOVLW 0X87;
				MOVWF PORTB;
				CALL PULSO_ENABLE;
				bsf portc, RS_LCD;
				
				movf cta_decenas,w;
				movwf portb;
				call pulso_enable;
				
				movf cta_unidades,w;
				movwf portb;
				call pulso_enable;
				
				return;
				    
				;,MOVLW 0X0C;
				;;MOVWF PORTB;
				;;CALL PULSO_ENABLE;

				;;MOVLW 0X01;
				;;MOVWF PORTB;
				;;CALL PULSO_ENABLE;

				;;MOVLW 0X06;
				;;MOVWF PORTB;
				;;CALL PULSO_ENABLE;
					
				;;MOVLW 0X80;
				;;MOVWF PORTB;
				;;CALL PULSO_ENABLE;

				;,BSF PORTC,RS_LCD; 
					
				;;RETURN;
;-----------------------------------------------------------------------------------------------------------------------------------------
		 ;=================================
		 ;== SUBRUTINA DE INTERRUPCIONES ==
		 ;=================================
		 org 0x0004;
vec_int		movwf resp_w;
		movf status,w;
		movwf resp_status;
		clrf status;
		movf pclath,w;
		movwf res_pclath;
		clrf pclath;
		movf fsr,w;
		movwf res_fsr;
		
		btfsc intcon,t0if;
		call rutina_int;
		
sal_int		movlw .131;
		movwf tmr0;
		
		movf res_fsr,w;
		movwf fsr;
		movf res_pclath,w;
		movwf pclath;
		movf resp_status,w;
		movwf status;
		movf resp_w,w;
		
		retfie;
;-----------------------------------------------------------------------------------------------------------------------------------------
                 ;================================
                 ;== Subrutina de interrupciones==
                 ;================================
rutina_int       incf   presc_1,f; 
                 
		 movlw .100; 
                 xorwf presc_1,w;
		 btfsc status,z;
		 goto sig_int;
		 goto sal_rutint;
		 
sig_int		clrf presc_1;
		incf presc_2,f;
		movlw .5;
		xorwf presc_2,f;
		btfss status,z;
		goto sal_rutint;
		clrf presc_1;
		clrf presc_2;
		
sal_rutext	btfss porte, Led_Rojo;
		goto sec_led;
		bcf porte,Led_Rojo; Prende el led.
		goto esp_int;
		
sec_led		bsf porte, Led_Rojo; Apaga el led.

sig_intcta	incf cta_unidades,f;
		incf cta_unidades,f;
		 movlw 0x3a;
		 xorwf cta_unidades,f;
		 btfss status,z;
		 goto sal_rutint;
		 movlw '0';
		 movwf cta_unidades;
		 incf cta_decenas,f;
		 movlw 0x3a;
		 xorwf cta_decenas,w;
		 btfss status,z;
		 goto sal_rutint;
		 movlw '0';
		 ;FALTAN CINSTRUCCIONES!
		 
               
		 movwf adcon1 ^0x80;
		 bcf status,RP0; ponte en el banco 0 de la 
		 
		 movlw 0xa0;
		 movwf intcon;
		 movlw .131;
		 movwf tmr0;
		 
		 movlw '0';
		 movwf cuenta_unidades;
		 movwf cuenta_decenas;
		 
		 clrf portb;
		 movlw 0x03;
		 movwf portc;
		 
		 return;
;----------------------------------------------------------------------------------------------------------------------------------------
                 ;=======================
                 ;== PROGRAMA PINCIPAL ==
                 ;=======================
		 
prog_prin        call prog_ini;
		 
		 call ini_lcd;
		 
loop_prin		nop;
		 call mustra_cta;
		 goto loop_prin;
		 
		;;btfss banderas, band_int;
		;;goto esp_int;
		;;bcf banderas,band_int;
		
		;;btfss porte, Led_Rojo;
		;;goto sec_led;
		;;bcf porte,Led_Rojo; Prende el led.
		;;goto esp_int;
		
;;sec_led	bsf porte, Led_Rojo; Apaga el led.
		;;goto esp_int;
		 
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		end;








