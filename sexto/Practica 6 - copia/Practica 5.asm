;_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
 list p=16f877A;

 #include <P16F877A.INC>;
 #include <Ini_pic.INC>
 #include <Var_y_const.INC>
 #include <LCD.INC>
 #include <Tabla.inc>
;Bits de configuración.

 __config _XT_OSC & _WDT_OFF & _PWRTE_ON & _BODEN_OFF & _LVP_OFF & _CP_OFF; All
 
;_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
;
;fosc = 4.00 Mhz.
;Ciclo de trabajo del pic = (1/fosc)*4= 1 us. 

;t int=(256-R)*P*((1/4000000)*4)=1 ms; //Tiempo de interrupción.

;R=131, P=8.
;P=preescaler		R=variable

;PWM Period = (POSTCALER DEL TMR2)[(PR2) + 1] •(TMR2 Prescale Value)/ 1000000
;PWM period = (16)* [64+1] (16) /1000000
;PMW=16.66666 ms

;PWM Duty Cycle =(CCPR1L:CCP1CON<5:4>) •TOSC • (TMR2 Prescale Value)
;Aumenta y disminuye :v
;--------------------------------------------------------------------------------------------------------------------------------------------------------
;Para poder manejar esta practica es necesario 
;1.- Para modificar los mensajes se necesita escribir el mensaje en la tabla (como en el ejemplo) 
;	   y cargar var_tabla con la posicion en que se encuentra la primera letra del mensaje de la tabla
;2.- Llamar para escribir  en la LCD Mensaje superior y Mensaje inferior
;3.- Hacer uso del banco de memoria 1 para modificar trisb para entrada y salida de datos
;4.- No agregar instrucciones que no sean en esta pagina :V (Practica 5.asm) o en "Tabla.inc" a menos de que se modifique
;	   la organizacion del programa (Ini_pic.INC & LCD.INC) 
;5.- Si se pueden agregar mas variables, constantes, modificacion en los puertos y todas esas mamadas de "var y const.inc":V
;6.- Saber como se usan las memorias RAM 6116 (logica negativa)
;7.- Ser chingon :3
;--------------------------------------------------------------------------------------------------------------------------------------------------------
						    ;============================
							;===  Programa Principal  ===
							;============================
							ORG 0x011A

prog_prin				   call 	prog_ini; 				Inicializa el pic
						   call 	ini_LCD; 				Inicializa la LCD
							
loop_prin				   call 	Mensaje_inicial;		Llama a la subrutina que pone los mensajes iniciales en la LCD
						   call		Graba_datos_RAM;		Llama a la subrutina que graba los datos en la memoria RAM
						   call		Mensaje_de_muestreo;	Llama a la subrutina que pone la direccion y dato de la memoria RAM
Inicia_de_nuevo			   clrf		portc;					Limpia el puerto C para comenzar a capturar los datos de la RAM
Loop_de_captura			   call		Captura_numeros;		Llama a la subrutina que captura los datos y los respalda :v
						   call		Convierte_datos;		Llama a la subrutina que convierte el dato a hexadecimal y caracter :3
						   call		Manda_a_LCD;			Llama a la subrutina que manda los datos a la LCD
						   call		Checa_la_direccion;		Llama a la subrutina que va a checar en que direccion de ram se encuentra
						   movwf	Tempo1;					Guarda el dato de direccion
						   movwf	Tempo2;					Guarda el dato de direccion
						   call		Convierte_datos;		Llama a la subrutina que convierte el dato a hexadecimal y caracter :3
						   call		Manda_direccion;		Llama a la subrutina que manda la direccion a la LCD
						   call		retardo_3seg;			Llam a un retardo de 1 segundo para visualizar los datos :3
						   incf		Portc,f;				Incrementa el puerto C en 1 para cambiar de direccion :v
						   movlw	.18;					
						   xorwf	portc,w;				Compara lo que hay en el puerto C (direccion de la RAM) con 18
						   btfss	status,z;				Son iguales?
						   goto 	Loop_de_captura;		No, sigue leyendo las siguientes localidades de RAM
						   goto		Inicia_de_nuevo;		Si, vuelve a leer desde el inicio :3

;--------------------------------------------------------------------------------------------------------------------------------------------------------
						    ;===========================================
							;=== Subrutina que graba la memoria RAM  ===
							;===========================================
Graba_datos_RAM			   movlw	.64 ; 					Mueve 64 a var_tabla para mostrar el mensaje correspondiente
						   movwf 	var_tabla;
						   clrf		N_veces;				Limpia el registro N_veces para hacer la cuenta de veces que llama la tabla
						   clrf		portc;					Limpia el puerto C para seleccionar la direccion 0 de RAM

Vuelve_a_grabar			   movf		var_tabla,w;			Mueve el valor que se tomara de la tabla
						   call		Tabla;					Llama la tabla y regresa con el valor que se quiere grabar :V
						   movwf 	portb;					Moverla al puerto B para que este a la salida de la memoria
						   bcf		Porta,CE_RAM;			Activa la memoria RAM para empezar a trabajar con ella
						   call		Retardo_1ms;			Tiempo necesario para que la RAM trabaje bien :V
						   bcf		Porta,WE_RAM;			Activa la escritura de la Memoria RAM
						   call		Retardo_1ms;			Tiempo necesario para que la RAM trabaje bien :V
						   bsf		porta,WE_RAM;			Desactiva la escritura
						   call		Retardo_1ms;			Tiempo necesario para que la RAM trabaje bien :V
						   bsf		porta,CE_RAM;			Desactiva la memoria :V
						   call		retardo_1ms;			Tiempo necesario para que la RAM trabaje bien :V
						   Incf		Portc,f;				Incrementa la direccion de la RAM para que grabe en otro lugar :3
						   Incf		Var_tabla,f;			Incrementa para tomar el siguiente dato de la tabla :3
						   movlw	.16;					Es el numero de veces que tiene que ir a la tabla :v
						   xorwf	portc,w
						   btfss	status,z;				Son iguales?
						   goto		Vuelve_a_grabar;		No, Repite hasta que sean iguales
						   Return;							Si, regresa de donde fue llamada :3

;--------------------------------------------------------------------------------------------------------------------------------------------------------
						    ;=================================================
							;=== Subrutina que cambia el dato y direccion  ===
							;=================================================

Captura_numeros			   bsf 		STATUS,RP0;				selecciona el banco 1 de ram.
						   movlw 	progb_in; 				Programacion como entradas alv, se define en variables y constantes
						   movwf 	TRISB ^0x80; 	
						   bcf 		STATUS,RP0;				Regresa al banco 0 de memoria RAM para seguir trabajando

						   bcf 		porta,CE_RAM;			Activa la memoria ram
						   call		retardo_1ms;			Espera 1ms que necesita la RAM para trabajar chido :v
						   bcf		porta,OE_RAM;			Deja que la RAM muestre los datos de la localidad seleccionada
						   call		retardo_1ms;			Espera 1ms que necesita la RAM para trabajar chido :v
						   movf		Portb,w;				Lectura de RAM a travez del puerto B
						   movwf	Tempo1;					Respalda el dato correspondiente a la lectura de RAM
						   movwf	Tempo2;					Respalda el dato correspondiente a la lectura de RAM
						   movwf	Dato_directo;			Respalda el dato correspondiente a la lectura de RAM
						   bsf		porta,OE_RAM;			La RAM dejará de mostrar el dato correspondiente
						   call		retardo_1ms;			Espera 1ms que necesita la RAM para trabajar chido :v
						   bsf		porta,CE_RAM;			La RAM se desactiva para evitar cortos :3
						   call		retardo_1ms;			Espera 1ms que necesita la RAM para trabajar chido :v

						   return;							Regresa de donde fue llamado :3
;--------------------------------------------------------------------------------------------------------------------------------------------------------
						    ;====================================================
							;=== Subrutina que convierte los datos a mostrar  ===
							;====================================================

Convierte_datos			   movlw 	0x0F;					
						   andwf 	Tempo1,f;				Enmascara el dato para solo usar el nibble bajo :v
						   call		comprueba_Dato;			Llama a la subrutina para saber si tomarlo como numero o letra :v
						   movlw	0x37;
						   addwf	Tempo1,f;				Le suma 37h para convertir una letra a Hex :3

Nibble_Alto				   movlw 	0xF0;					
						   andwf 	Tempo2,f;				Enmascara el dato para solo usar el nibble alto :v
						   swapf	Tempo2,f;				Cambio de nibbles para trabajar con el alto como bajo
						   movlw	0x30;					
						   addwf	Tempo2,f;				Le suma 30h para convertirlo a numero hex

						   return;							Regresa :3
;--------------------------------------------------------------------------------------------------------------------------------------------------------
						    ;=============================================================
							;=== Subrutina que comprueba el dato antes de convertirlo  ===
							;=============================================================

Comprueba_dato			   bcf		status,c;				Limpia el bit de acarreo de status
						   movlw	.246;					Carga 246 a w
						   addwf	Tempo1,w;				Checa si es una letra(codigo ascci) por complemento
						   btfsc	status,c;				Es letra?
						   return;							Si, regresa

						   movlw	0x07;					No, haz lo siguiente....
						   subwf	Tempo1,f;				Le resta 07h para que regrese, se le sumen 37h y se convierta a hex
						   return;							Regresa de donde fue llamado

;--------------------------------------------------------------------------------------------------------------------------------------------------------
						    ;=============================================================
							;===  Subrutina que checa en que direccion de RAM esta :3  ===
							;=============================================================

Checa_la_direccion		   movlw	.64;					Carga W con 64
						   movwf	var_tabla;				Carga var_tabla con 64 para tomar el valor correspondiente
						   clrf		N_veces;				Limpia N_veces (con esta se tomara el valor de localidad de RAM)

Loop_direccion			   movf		var_tabla,w;			mueve el valor de var_tabla a w
						   call		tabla;					Llama a la tabla y toma el valor cargado en var_tabla :3
						   xorwf	dato_directo,w;			Lo compara con dato_directo, que es el valor que tiene en esa localidad
						   btfsc	status,z;				Son iguales?
						   goto		Este_es_el_dato;		Si, Ve y toma el dato cargado en N_veces para mostrar la direccion :3
						   incf		var_tabla,f;			No, Incrementa var_tabla para compararlo con el siguiente valor de la tabla
						   incf		N_Veces,f;				Incrementa N_veces (valor con el que se tomara la direccion :3)
						   goto		Loop_direccion;			Repite el ciclo amor :3
						   
;--------------------------------------------------------------------------------------------------------------------------------------------------------
						    ;==================================================
							;=== Subrutina que muestra los datos en la LCD  ===
							;==================================================

Manda_a_LCD				   bsf 		STATUS,RP0;				selecciona el banco 1 de ram.
						   movlw 	progb_out; 				Programacion como salidas alv, se define en variables y constantes
						   movwf 	TRISB ^0x80; 	
						   bcf 		STATUS,RP0;				Regresa al banco 0 de memoria RAM para seguir trabajando 

						   bcf 		porta, RS_LCD;			Poner LCD en modo comandos
						   movlw 	0xC7;					Poner en la direccion 6 del segundo renglon :3
						   movwf 	portb;					moverlo al puerto b (Donde esta conectada la LCD)
						   call 	pulso_enable;			Ejecuta la instruccion :3
						   bsf 		porta, RS_LCD;			Poner LCD en modo datos

						   movf 	Tempo2,w;				mueve lo que hay en la variable Tempo2
						   movwf	Portb;					Muevelo a la LCD
						   call		pulso_enable;			Ejecuta la instruccion :3

						   movf 	Tempo1,w;				mueve lo que hay en la variable Tempo1
						   movwf	Portb;					Muevelo a la LCD--> siguiente espacio :3
						   call		pulso_enable;			Ejecuta la instruccion :3

						   bcf 		porta, RS_LCD;			Poner LCD en modo comandos
						   movlw 	0xCF;					Poner en la direccion 15 del segundo renglon :3
						   movwf 	portb;					moverlo al puerto b (Donde esta conectada la LCD)
						   call 	pulso_enable;			Ejecuta la instruccion :3
						   bsf 		porta, RS_LCD;			Poner LCD en modo datos

						   movf 	dato_directo,w;			mueve lo que hay en la variable Dato_directo
						   movwf	Portb;					Muevelo a la LCD
						   call		pulso_enable;			Ejecuta la instruccion :3

						   return;							Regresa de donde fue llamado :V
;--------------------------------------------------------------------------------------------------------------------------------

Manda_direccion			   bsf 		STATUS,RP0;				selecciona el banco 1 de ram.
						   movlw 	progb_out; 				Programacion como entradas alv, se define en variables y constantes
						   movwf 	TRISB ^0x80; 	
						   bcf 		STATUS,RP0;				Regresa al banco 0 de memoria RAM para seguir trabajando

						   bcf 		porta, RS_LCD;			Poner LCD en modo comandos
						   movlw 	0x8D;					Poner en la direccion 14 del primer renglon :3
						   movwf 	portb;					moverlo al puerto b (Donde esta conectada la LCD)
						   call 	pulso_enable;			Ejecuta la instruccion :3
						   bsf 		porta, RS_LCD;			Poner LCD en modo datos 
						
						   movf 	Tempo2,w;				mueve lo que hay en la variable Tempo2
						   movwf	Portb;					Muevelo a la LCD
						   call		pulso_enable;			Ejecuta la instruccion :3

						   movf 	Tempo1,w;				mueve lo que hay en la variable Tempo1
						   movwf	Portb;					Muevelo a la LCD--> siguiente espacio :3
						   call		pulso_enable;			Ejecuta la instruccion :3
							
						   Return;							Regresa de donde fue llamado :v
				
;------------------------------------------------------------------------------------------------------------------------------
                   		;====================
      					;===   Mensajes   ===
						;====================

Mensaje_inicial		  	   clrf		var_tabla; 				mueve 0 a var tabla para mostrar el mensaje correspondiente
						   call		Mensaje_superior; 		Pon los datos de la tabla en la parte superior de la LCD
						   movlw	.16 ; 					Mueve 16 a var_tabla para mostrar el mensaje correspondiente
						   movwf 	var_tabla;
						   call		Mensaje_inferior; 		Pon los datos de la tabla en la parte superior de la LCD
						   call 	retardo_5seg; 			Llama un retardo de 5 seg por requerimientos de la practica
						   return				   

Mensaje_de_muestreo		   movlw	.32 ; 					Mueve 32 a var_tabla para mostrar el mensaje correspondiente
						   movwf 	var_tabla;
						   call		Mensaje_superior; 		Pon los datos de la tabla en la parte superior de la LCD
						   movlw	.48 ; 					Mueve 48 a var_tabla para mostrar el mensaje correspondiente
						   movwf 	var_tabla;
						   call		Mensaje_inferior; 		Pon los datos de la tabla en la parte superior de la LCD
						   Return

;------------------------------------------------------------------------------------------------------------------------------
                   		;====================
      					;=== Retardos xD  ===
						;====================

Retardo_1ms				   clrf 	cont_milis; 			Limpia la variable que cuenta milisegundos para iniciar el conteo

Espera_1ms				   movlw 	.1; 					Cont milis incrementa cada que va a la interrupcion
						   xorwf 	cont_milis,w;	 		Compara lo que hay en cont_milis con 250
						   btfss 	status,z; 				Son iguales? 
						   goto 	Espera_1ms; 			No, regresa a comparar hasta que sean iguales :V
						   return;							Si, regresar de donde fue llamada
;-----------------------------------------------------------------------------------------------------------------------------------------------

Retardo_3seg			   clrf 	cont_milis; 			Limpia la variable que cuenta milisegundos para iniciar el conteo
						   clrf		cont_cuarto_de_seg; 	Limpia la variable que cuenta 1/4 de segundo

Espera_3s				   movlw 	.250; 					Cont milis incrementa cada que va a la interrupcion
						   xorwf 	cont_milis,w;	 		Compara lo que hay en cont_milis con 250
						   btfss 	status,z; 				Son iguales? 
						   goto 	Espera_3s;	 			No, regresa a comparar hasta que sean iguales :V
						   clrf		cont_milis; 			Si, limpia cont_milis para volver a hacerlo
						   incf		cont_cuarto_de_seg,f; 	Incrementa cuartos_de_seg una vez cada que incrementa 250 milis
						   movlw	.10; 
						   xorwf	cont_cuarto_de_seg,w; 	Compara lo que hay en cont_cuarto_de_seg con 12 para 3 seg
						   btfss	status,z; 				Son iguales? 
						   goto		Espera_3s;				No, regresa al inicio hasta que sean iguales
						   return; 							Si, regresa de donde fue llamada :V

;-----------------------------------------------------------------------------------------------------------------------------

Retardo_5seg			   clrf 	cont_milis; 			Limpia la variable que cuenta milisegundos para iniciar el conteo
						   clrf		cont_cuarto_de_seg; 	Limpia la variable que cuenta 1/4 de segundo

Espera_5seg				   movlw 	.250; 					Cont milis incrementa cada que va a la interrupcion
						   xorwf 	cont_milis,w;	 		Compara lo que hay en cont_milis con 250
						   btfss 	status,z; 				Son iguales? 
						   goto 	Espera_5seg; 			No, regresa a comparar hasta que sean iguales :V
						   clrf		cont_milis; 			Si, limpia cont_milis para volver a hacerlo
						   incf		cont_cuarto_de_seg,f; 	Incrementa cuartos_de_seg una vez cada que incrementa 250 milis
						   movlw	.20; 
						   xorwf	cont_cuarto_de_seg,w; 	Compara lo que hay en cont_cuarto_de_seg con 20 para 5 seg
						   btfss	status,z; 				Son iguales? 
						   goto		Espera_5seg;			No, regresa al inicio hasta que sean iguales
						   return; 							Si, regresa de donde fue llamada :V

						   End;								Final del programa :3