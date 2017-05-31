;------------------------------------------------------------------------------------------------------------------------------
; 						==============================================
;						===== Libreria principal para uso de LCD =====
;						==============================================
						   ORG 0x07C0; 			Organiza el programa en 0x07C0 que son las ultimas direcciones del banco 1
		                                                                                       				
ini_lcd					   bcf porta, RS_LCD; 	Pone la LCD en modo comandos xD
						   movlw 0x38; 			Selecciona una interfaz de 8 bits, modo de dos lineas y formato 5x7
						   movwf portb; 		comandos hacia la LCD
						   call pulso_enable;
						   movlw 0x0c; 			Selecciona el display encendido y formato de cursores xD
						   movwf portb; 		Coamndos a LCD
						   call pulso_enable;
						   movlw 0x01; 			Limpia el display
						   movwf portb; 		Comandos a LCD
						   call pulso_enable;
						   movlw 0x06; 			Selecciona el modo de entrada de caracteres
						   movwf portb; 		Comandos a LCD
						   call pulso_enable;
						   movlw 0x80; 			Selecciona escritura en primer renglon :3
						   movwf portb; 		Comando a LCD
						   call pulso_enable; 	Porque no se pinches pueden agregar imagenes aqui? :'v
						   bsf porta, ENABLE_LCD; Para mas informacion revisar imagen en carpeta "Micros"

						   return; Regresa
;------------------------------------------------------------------------------------------------------------------------------
                        ;====================
      					;=== pulso enable ===
						;====================
;Son simples retardos para esperar el tiempo de eneable establecido por la LCD
;Checar el apartado de retardos en "Practica 5.asm"--> Retardo_5seg

pulso_enable               bcf porta, ENABLE_LCD; 

						   clrf cont_milis;
esp_time                   movlw .1;
						   xorwf cont_milis,w;
						   btfss status,z;
						   goto esp_time;
						   bsf porta, ENABLE_LCD;

						   clrf cont_milis;
esp_time2				   movlw .20;
						   xorwf cont_milis,w;
						   btfss status,z;
						   goto esp_time2;		   
						   return;

;----------------------------------------------------------------------------------------------------------------------------------------------------------
						    ;===========================
							;===  Mensajes de la LCD  ==
							;===========================
;Esa es una forma chingona de escribir en la LCD por medio de tablas :3 


Mensaje_superior		   bcf porta, RS_LCD;
						   movlw 0x80;
						   movwf portb;
						   call pulso_enable;
						   bsf porta, RS_LCD;

						   clrf N_veces

Loop_LCD_sup			   movf var_tabla,w
						   call tabla
						   movwf portb;
						   call pulso_enable;
						   incf var_tabla,f
						   incf N_veces,f
						   movlw .16
						   xorwf N_veces,w
						   btfss status,z
						   goto LOOP_LCD_sup
						   
						   return	

Mensaje_inferior		   bcf porta, RS_LCD;
						   movlw 0xc0;
						   movwf portb;
						   call pulso_enable;
						   bsf porta, RS_LCD;

						   clrf N_veces

Loop_LCD_inf			   movf var_tabla,w
						   call tabla
						   movwf portb;
						   call pulso_enable;
						   incf var_tabla,f
						   incf N_veces,f
						   movlw .16
						   xorwf N_veces,w
						   btfss status,z
						   goto LOOP_LCD_inf
						   
						   return	