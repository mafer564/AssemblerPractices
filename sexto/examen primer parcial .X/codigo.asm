
;INSTITUTO POLITECNICO NACIONAL
;CECYT9 JUAN DE DIOS BATIZ
;
;Ejemplo de ejercicio de examen.
;
;GRUPO: 6IM2.   EQUIPO 
;
;INTEGRANTES:
;
;DESCRIPCION DE LA PRACTICA: Contar de 0 al 98, de 2 en 2, con un tiempo de interrupcion de 4 segundos.
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
Sin_usoRC2    equ    .2; //Sin uso
Sin_usoRC2    equ    .3; //Sin uso
Sin_usoRC2    equ    .4; //Sin uso
Sin_usoRC2    equ    .5; //Sin uso 
Sin_usoRC2    equ    .6; //Sin uso
Sin_usoRC2    equ    .7; //Sin uso 


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
;Antes de cualquier subrutina, y despues de la que inicializa el PIC,
;			debe estar la que inicializa la lcd.

muestra_cta			BCF PORTC,RS_LCD; Pone en 0 RS_LCD del puerto C
				
				MOVLW 0X87;Direccion del pin de la LCD donde se mostrara. 
				MOVWF PORTB;Manda a w al puerto B.
				CALL PULSO_ENABLE;llama a la subrutina
				bsf portc, RS_LCD;Pone en 1 RS_LCD.
				
				movf cta_decenas,w;Carga cta_decenas a w.
				movwf portb; Manda w al puerto B.
				call pulso_enable; Llama subrutina.
				
				movf cta_unidades,w;Carga cta_unidades a w.
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
		 org 0x0004;LA SUBRUTINA DE INTERRUPCION DEL PIC ESTA EN LA DIRECCION 4.
vec_int		movwf resp_w;Respalda w. (La carga a resp_w)
		movf status,w;Carga el registro status a w.
		movwf resp_status;Respalda w.
		clrf status;Limpia el registro status.
		movf pclath,w;Carga a w los bits del pclath.(los 3 que llena del program counter cuando hay un call o goto)
		movwf res_pclath;respalda.
		clrf pclath;limpia pclath.
		movf fsr,w;Mueve el apuntador de reg. a w. (rfs utiliza el contenido del registro anterior para redireccionarlo a otro.)
		movwf res_fsr;Respalda w.
		
		btfsc intcon,t0if;Salta si el timer 0 del reg. intcon es 0.
		call rutina_int;llama a la subrutina.
		
sal_int		movlw .131;Direccion del t0.
		movwf tmr0;Carga el t0 a w.
		
		movf res_fsr,w;mueve res_fsr a w.
		movwf fsr;respalda el contenido fsr.
		movf res_pclath,w;Carga a w el respaldo de pclath.
		movwf pclath;respalda.
		movf resp_status,w;mueve a w el respaldo de status.
		movwf status;respalda.
		movf resp_w,w;mueve a w el respaldo de w.
		
		retfie;	Retorna la interrupcion.
;-----------------------------------------------------------------------------------------------------------------------------------------
                 ;================================
                 ;== Subrutina de interrupciones==
                 ;================================
rutina_int       incf   presc_1,f;  Incrementa en 1 presc_1.
                 
		 movlw .100; Direccion requerida
                 xorwf presc_1,w;or excl. entre w y el presc_1, el resultado se guarda en w.
		 btfsc status,z;Salta si el bit z del registro status es 0.
		 goto sig_int;va a la direccion sig_int.
		 goto sal_rutint;va a la direccion sal_rutint.
		 ;Si presc_1 es 0 brincara a la rutina del presc_2, si es 1 saldra de la rutina.
		 
sig_int		clrf presc_1;limpia el presc_1.
		incf presc_2,f;Incrementa en 1 el presc_2.
		movlw .5;Direccion.
		xorwf presc_2,f;Or exc. entre w y presc_2.
		btfss status,z;Salta si el bit z del registro status es 1.
		goto sal_rutint;Va a la rutina sal_rutint.
		clrf presc_1;limpia el presc_1
		clrf presc_2;Limpia el presc_2
		
sal_rutint	btfss porte, Led_Rojo;Salta si el bit Led_Rojo del Puerto E esta en 1.
		goto sec_led;Va a la rutina sec_led.
		bcf porte,Led_Rojo;Pone en 0 Led_Rojo. Prende el led.
		
		
sec_led		bsf porte, Led_Rojo;Pone en 1 Led_Rojo Apaga el led.

sig_intcta	incf cta_unidades,f;Incrementa en 1 cta_unidades.
		incf cta_unidades,f;Incrementa en 1 cta_unidades.
		 movlw 0x3a;Direccion requerida a w.Compara su valor con 0.
		 xorwf cta_unidades,f;Or exc. entre w y cta_unidades.
		 btfss status,z;Salta su el bit z del reg status es 1.
		 goto sal_rutint;Va a la rutina sal_rutint.
		 movlw '0';Muestra 0
		 movwf cta_unidades;Carga a w cta_unidades.
		 incf cta_decenas,f;Incrementa en 1 cta_decenas.
		 movlw 0x3a;Compara su valor con 0.
		 xorwf cta_decenas,w;or exc. entre w y cta_decenas. 
		 btfss status,z;Salta si el bit z del reg. status es 1. 
		 goto sal_rutint;Va a la rutina sal_rutina.
		 movlw '0';Muestra 0.
		 ;FALTAN CINSTRUCCIONES!
		 
               
		 movwf adcon1 ^0x80;
		 bcf status,RP0; ponte en el banco 0 del reg. status. 
		 
		 movlw 0xa0;Compara su valor con el de la direccion 0xa0.
		 movwf intcon;
		 movlw .131;
		 movwf tmr0;
		 
		 movlw '0'; Compara el valor con 0.
		 movwf cuenta_unidades;Carga a w cta_unidades.
		 movwf cuenta_decenas;Cara a w cta_decenas.
		 
		 clrf portb;Limpia el puerto B.
		 movlw 0x03;Compara su valor con el de la direccion 0x03.
		 movwf portc;Carga el puerto C a w.
		 
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








