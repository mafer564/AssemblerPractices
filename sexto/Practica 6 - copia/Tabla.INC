;_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 

						    ;==================================
							;===  Tabla de las imagenes xD  ===
							;==================================	
;La instruccion RETLW sirve como return pero esta regresa de donde fue llamada con un valor establecido en W :3					
							org 0x001A; Organiza en 0x001A para que la tabla ocupe el mayor numero de instrucciones posibles :v
							
tabla						addwf pcl,f; PCL es el contador de programa, entonces si le sumas lo de w va a saltar w instrucciones :3

							Retlw 'M'
							Retlw 'a'
							Retlw 'n'
							Retlw 'e'
							Retlw 'j'
							Retlw 'o'
							Retlw ' '
							Retlw 'd'
							Retlw 'e'
							Retlw ' '
							Retlw 'M'
							Retlw '.'
							Retlw ' '
							Retlw 'R'
							Retlw 'A'
							Retlw 'M'

							Retlw '2'
							Retlw 'I'
							Retlw 'M'
							Retlw '2'
							Retlw ' '
							Retlw 'E'
							Retlw 'Q'
							Retlw 'U'
							Retlw 'I'
							Retlw 'P'
							Retlw 'O'
							Retlw ' '
							Retlw '1'
							Retlw ' '
							Retlw ' '
							Retlw ' '

							Retlw 'D'
							Retlw 'i'
							Retlw 'r'
							Retlw 'e'
							Retlw 'c'
							Retlw 'c'
							Retlw 'i'
							Retlw 'o'
							Retlw 'n'
							Retlw ':'
							Retlw ' '
							Retlw '0'
							Retlw '0'
							Retlw ' '
							Retlw ' '
							Retlw ' '

							Retlw 'D'
							Retlw 'a'
							Retlw 't'
							Retlw 'o'
							Retlw ':'
							Retlw '0'
							Retlw 'x'
							Retlw ' '
							Retlw ' '
							Retlw ' '
							Retlw 'C'
							Retlw 'a'
							Retlw 'r'
							Retlw '.'
							Retlw ' '
							Retlw ' '

							Retlw '0'
							Retlw '1'
							Retlw '2'
							Retlw '3'
							Retlw '4'
							Retlw '5'
							Retlw '6'
							Retlw '7'
							Retlw '8'
							Retlw '9'
							Retlw 'A'
							Retlw 'B'
							Retlw 'C'
							Retlw 'D'
							Retlw 'E'
							Retlw 'F'

							Retlw 'g'
							Retlw 'h'
;------------------------------------------------------------------------------------------------------------------------------------
;Esta tablita sirve para tomar la localidad de memoria en la que se encuentra el valor correspondiente al caracter en pantalla

Este_es_el_dato			   movf		N_veces,w;	N_Veces aumenta cada que la variable anterior no es, aumenta para comparar con el dato :3
						   addwf	pcl,f;		Suma N_Veces con PCL para saltar W instrucciones :3
							
						   Retlw	0x00
						   Retlw	0x01	
						   Retlw	0x02
						   Retlw	0x03	
						   Retlw	0x04
						   Retlw	0x05	
						   Retlw	0x06
						   Retlw	0x07	
						   Retlw	0x08
						   Retlw	0x09	
						   Retlw	0x0A
						   Retlw	0x0B	
						   Retlw	0x0C
						   Retlw	0x0D	
						   Retlw	0x0E
						   Retlw	0x0F
						   Retlw	0x10
						   Retlw	0x11	

