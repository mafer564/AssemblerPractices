;_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
							;=====================================
							;==========   Vector Reset   =========
							;=====================================
							org 0x0000; 		Organiza el programa desde el inicio de todo
vec_reset					clrf PCLATH; 		Asegura la pagina cero de la memoria de prog.
							goto prog_prin; 	Dirige al programa principal
;_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
							;=====================================
							;===== Vector de interrupcion   ======
							;=====================================
;Cuando se usan las interrupciones el programa incrementa el tmr0 en 1 cada P(valor del preescalador) instrucciones y cuando 
;el tmr0 se desborda se activa la bandera T0if la cual directamente manda el programa a 0x0004 donde se encuentra el vector de interrupcion xD
;las instrucciones que saltan de un lado a otro en la memoria de programa[como retlw,retfie,return,goto,call,btfss y btfsc(solo cuando saltan), 
;decfsc(solo cuando salta)] toman 2 ciclos de maquina, las demas toman 1 ciclo de maquina

							org 0x0004; 		Organiza el programa en la direccion 0x04 que es donde se llega cada que se interrumpe el codigo :3
vec_int						movwf res_w; 		Respalda W para la interrupcion
							movf status,w; 
							movwf res_status; 	Respalda status para la interrupcion
						    clrf status; 		Limpia status para la interrupcion (la interrupcion esta en la pagina 1 de memoria)
						    movf pclath,w; 
						    movwf res_pclath; 	Respalda pclath para la interrupcion
						    clrf pclath; 		Limpia pclath para la interrupcion
						    movf fsr,w;
						    movwf res_fsr; 		Respalda FSR para la interrupcion
						    
						    btfsc intcon, t0if; Prueba si la bandera t0if se desborda(solo se desborda cuando tmr0 sobre pasa .255)
						    incf cont_milis,f; 	Incrementa el registro cont_milis que sirve para contar el tiempo que estara en el loop del retardo 
							bcf intcon,t0if; 	Limpia la bandera t0if para volver a hacer interrupcion :V
						    
sal_int                     movlw .131; 		Inicializa tmr0 con .131 para que la interrupcion se tarde lo estimado
						    movwf tmr0;
						    
						    movf res_fsr,w;
						    movwf fsr; 			Regresa FSR a su estado antes de la interrupcion
						    movf res_pclath,w;
						    movwf pclath; 		Regresa pclath a su estado para volver a la pagina de memoria en que estaba
						    movf res_status,w;
						    movwf status; 		Regresa status a su estado para volver al programa :V
						    movf res_w,w; 		Regresa w a su lugar :V

							retfie; Retorno de una interrupcion de donde se detuvo el programa :v

;_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
							;=====================================
							;===  Subrutina de Inicio      =======
							;=====================================
							ORG 0X0100

prog_ini				   movlw 0xff; 			Pon el puerto A todo en 1 en este caso para evitar	
						   movwf PORTA; 		la memoria ram de datos que no queremos :v

						   bsf STATUS,RP0;		selecciona el banco 1 de ram.
						   movlw 0x82; 			Esta configuracion apaga RPU y define el preescalador a 8 para el Tmr0 :'v
						   movwf OPTION_REG ^0x80; Registro que se usa para definir los preescaladores y las RPU en puerto B como entrada
						   movlw proga; 		Mueve lo que hay en proga hacia Trisa para definirlo como entradas o salidas :v
						   movwf TRISA ^0x80; 	(Los gorritos son para indicarle al programa a partir de que registro buscar el Tris)
						   movlw progb_out; 	Programacion como salidas alv, se define en variables y constantes
						   movwf TRISB ^0x80; 
						   movlw progc; 		Lo de escribir con prog solo es por mera comodidad xD
						   movwf TRISC ^0x80;
						   movlw progd; 		Para definirlos junto con los puertos
						   movwf TRISD ^0x80;
						   movlw PROGE; 		y luego solo moverlos a los tris por medio de esta subrutina
						   movwf TRISE ^0x80;
						   movlw 0x06; 			Esta configuracion define todas las entradas como digitales :3
						   movwf adcon1 ^0x80; 	Registro para control del conversor analogico/digital
						   bcf status,rp0; 		Regresa al banco 0 de Ram (donde se definen las variables que usamos siempre :3)

						   movlw .131; 			valor calculado con la formula de interrupciones xD
						   movwf tmr0; 			se carga al tmr0
						   movlw 0xa0; 			Esta configuracion habilita las interrupciones globales y por tmr0
						   movwf intcon; 		Registro para control de interrupciones :v

						   clrf portb; Limpia el puerto B 
						   clrf portc; Limpia el puerto C
						   clrf portd; Limpia el puerto D

						   return;