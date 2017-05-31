;_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _INDF
;
; Registros de proposito general banco 0 de memoria RAM.
;
; Registros propios de estructura del programa
; Variables 0
res_w    					equ		0x20; // Variable para respaldar w
res_status   				equ		0x21; // Variable para respaldar status
res_pclath 					equ		0x22; // Variable para respaldar pclath
res_fsr                     equ		0x23; // Variable para respaldar fsr
cont_milis                  equ     0x24; // Variable para contar los milisegundos de la interrupcion
cont_cuarto_de_seg			equ		0x25
tempo1						equ		0x26; // Variable para buscar el dato de la ram
tempo2						equ		0x27; // Variable para buscar el dato de la ram
var_tabla					equ		0x28; // Se usa para entrar a la tabla
N_veces						equ		0x29; // Se usa para contar a 16 en la tabla xD
Dato_directo				equ		0x2A; // Usado para guardar el caracter que se grabo en RAM
;_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
;Asignacion de los bits de los puertos entradas/salidas :3 ?.

  ;PUERTO A.	
ENABLE_LCD					equ		.0; // activa el modo de sincronizacion de tiempo se activa en modo bajo (0)
RS_LCD						equ		.1; // Rs de la pantalla LCD
OE_RAM						equ		.2; // Con este en 0 la memoria RAM muestra el dato que tenga en la direccion seleccionada.
WE_RAM						equ		.3; // Con este se escribe en la memoria RAM.
Sin_usoRA4					equ		.4; // Sin uso RA4.
CE_RAM						equ		.5; // Activa o desactiva la memoria alv.
	
proga						equ b'010000';  // Programación inicial del puerto A.

;PUERTOB.
Data_bus_D0					equ		.0; // Es el bit 0 del bus de datos entre memoria pic y lcd.
Data_bus_D1					equ		.1; // Es el bit 1 del bus de datos entre memoria pic y lcd.
Data_bus_D2					equ		.2; // Es el bit 2 del bus de datos entre memoria pic y lcd.
Data_bus_D3					equ		.3; // Es el bit 3 del bus de datos entre memoria pic y lcd.
Data_bus_D4					equ		.4; // Es el bit 4 del bus de datos entre memoria pic y lcd.
Data_bus_D5					equ		.5; // Es el bit 5 del bus de datos entre memoria pic y lcd.
Data_bus_D6					equ		.6; // Es el bit 6 del bus de datos entre memoria pic y lcd.
Data_bus_D7					equ		.7; // Es el bit 7 del bus de datos entre memoria pic y lcd.

progb_in					equ b'11111111'; // Programación para recibir datos de la memoria ram.
progb_out					equ b'00000000'; // Programacion para mandar datos a la lcd.

;PUERTO C.
Bus_dir_A0					equ		.0; // Bit 0 del bus de direcciones :v
Bus_dir_A1					equ		.1; // Bit 1 del bus de direcciones :v
Bus_dir_A2					equ		.2; // Bit 2 del bus de direcciones :v
Bus_dir_A3					equ		.3; // Bit 3 del bus de direcciones :v
Bus_dir_A4					equ		.4; // Bit 4 del bus de direcciones :v
Bus_dir_A5					equ		.5; // Bit 5 del bus de direcciones :v
Bus_dir_A6					equ		.6; // Bit 6 del bus de direcciones :v
Bus_dir_A7					equ		.7; // Bit 7 del bus de direcciones :v

progc						equ b'00000000'; // Programación Inicial del puerto C. 

;Puerto D.
Bus_dir_A8					equ		.0; // Bit 8 del bus de direcciones :v
Bus_dir_A9					equ		.1; // Bit 9 del bus de direcciones :v
Bus_dir_A10					equ		.2; // Bit 10 del bus de direcciones :v
Sin_UsoRD3					equ		.3; // Sin uso RD3.
Sin_UsoRD4					equ		.4; // Sin uso RD4.
Sin_UsoRD5					equ		.5; // Sin uso RD5.
Sin_UsoRD6					equ		.6; // Sin uso RD6.
Sin_UsoRD7					equ		.7; // Sin uso RD7.

progd						equ b'11111000'; // Programacion Inicial Puerto D. 

;Puerto E.	
Sin_UsoRe0					equ		.0; // Sin uso Re0.
Sin_UsoRe1					equ		.1; // Sin uso Re1.
Sin_UsoRe2					equ		.2; // Sin uso Re2.

proge						equ b'011';     // Programcion inicial puerto E. 

;Los prog son por mera estetica :3
