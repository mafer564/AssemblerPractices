;INSTITUTO POLITECNICO NACIONAL
;CECYT 9 "JUAN DE DIOS BATIZ"
;PRACTICA 2
;INGRESO DE DATOS AL SISTEMA CON TECLADO MATRICIAL 4X4. 
;GRUPO:   EQUIPO:
;INTEGRANTES:
;COMENTARIO DE LO QUE EL PROGRAMA EJECUTARA: 
list p=16f877A;
#include "C:\Program Files (x86)\Microchip\MPASM Suite\p16f877a.inc";
;Bits de configuración.
 __config _XT_OSC & _WDT_OFF & _PWRTE_ON & _BODEN_OFF & _LVP_OFF & _CP_OFF; 
;_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _INDF
; Registros de proposito general banco 0 de memoria RAM.
; Registros propios de estructura del programa
; Variables 0
res_w				equ		0x20; //
res_status 			equ		0x21; //
res_pclath 			equ		0x22; //
res_fsr		                 equ		0x23; //
presc_1	                        equ		0x24; //
presc_2		                equ		0x25; //
cont_milis	                equ	         0x26; //
banderas		        equ		0x27; //
us			        equ		0x28; //
ds				equ	         0x29; //
um				equ		0x2a; //
dm				equ		 0x2b; //
uh				equ		0x2c; //
dh				equ		0x2d; //
var_teclado			equ		0x2e; //
var_tecopri			equ		0x2f; //
var_tecla			equ		0x30; //
;-----------------------------------------------------------------------
;Constantes 
No_hay_tecla				equ		0xF0;
Tec_1						equ		0xE0
Tec_2						equ		0xD0
Tec_3						equ		0xB0
Tec_A						equ		0x70
Tec_4						equ		0xE0
Tec_5						equ		0xD0
Tec_6						equ		0xB0
Tec_B						equ		0x70
Tec_7						equ		0xE0
Tec_8						equ		0xD0
Tec_9						equ		0xB0
Tec_C						equ		0x70
Tec_E						equ		0xE0
Tec_0						equ		0xD0
Tec_F						equ		0xB0
Tec_D						equ		0x70
;------------------------------------------------------------------------
; banderas del registro;
ban_int                     equ     .0;
sin_ubd1                    equ     .1;
sin_ubd2                    equ     .2;
sin_ubd3                    equ     .3;
sin_ubd4                    equ     .4;
sin_ubd5                    equ     .5;
sin_ubd6                    equ     .6;
sin_ubd7                    equ     .7;
;_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
;Asignacion de los bits de los puertos entradas/salidas :3 ?.
  ;PUERTO A.	
ENABLE_LCD					equ			.0;//activa el modo de sincronizacion de tiempo se activa en modo bajo (0)
RS_LCD   					equ			.1;//selecciona el digito buscado
sin_usoRA2					equ			.2;//se utiliza para aumentar el digito requerido 
Sin_usoRA3					equ			.3;//se utiliza como bit de regresion en el demultiplexeo del 74139
Sin_UsoRA4					equ			.4;//se utiliza para elegir entre utilizar 8 o 4 matrices (si 0=4matrices o 1=8matrices) 
Sin_UsoRA5					equ			.5;//Sin Uso RA5
	
proga						equ b'000000'; Programación inicial del puerto A. Siendo habilitadas como entradas.

;PUERTOB.
Act_ren1					equ		.0; //Pin de salida para acivar el renglon 1 del teclado.
Act_ren2					equ		.1; //Pin de salida para acivar el renglon 1 del teclado.
Act_ren3					equ		.2; //Pin de salida para acivar el renglon 1 del teclado.
Act_ren4					equ		.3; //Pin de salida para acivar el renglon 1 del teclado.
Col_1						equ		.4; //Pin de entrada para leer el codigo de la tecla oprimida.
Col_2						equ		.5; //Pin de entrada para leer el codigo de la tecla oprimida.
Col_3						equ		.6; //Pin de entrada para leer el codigo de la tecla oprimida.
Col_4						equ		.7; //Pin de entrada para leer el codigo de la tecla oprimida.

progb						equ b'11110000'; // Programación inicial del puerto B.

;PUERTO C.
d0_lcd						equ		.0; // Segmento 1 del bus de caracteres.
d1_lcd						equ		.1; // Segmento 2 del bus de caracteres.
d2_lcd						equ		.2; // Segmento 3 del bus de caracteres.
d3_lcd						equ		.3; // Segmento 4 del bus de caracteres.
d4_lcd						equ		.4; // Segmento 5 del bus de caracteres.
d5_lcd						equ		.5; // Segmento 6 del bus de caracteres.
d6_lcd						equ		.6; // Segmento 7 del bus de caracteres.
d7_lcd						equ		.7; // Segmento 8 del bus de caracteres.

progc						equ b'00000000'; // Programación Inicial del puerto C. Habilitadas como salidas.

;Puerto D.
Sin_usoRD0					equ		.0; // Sin uso RD0.
Sin_UsoRD1					equ		.1; // Sin uso RD1.
Sin_UsoRD2					equ		.2; // Sin uso RD2.
Sin_UsoRD3					equ		.3; // Sin uso RD3.
Sin_UsoRD4					equ		.4; // Sin uso RD4.
Sin_UsoRD5					equ		.5; // Sin uso RD5.
Sin_UsoRD6					equ		.6; // Sin uso RD6.
Sin_UsoRD7					equ		.7; // Sin uso RD7.

progd						equ b'11111111'; // Programacion Inicial Puerto D. Siendo habilitadas como entradas.

;Puerto E.	
Sin_UsoRe0					equ		.0; // Sin uso Re0.
Sin_UsoRe1					equ		.1; // Sin uso Re1.
Sin_UsoRe2					equ		.2; // Sin uso Re2.

proge						equ b'011'; // Programcion inicial puerto E. Siendo habilitadas como entradas.

;_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
							;=====================================
							;==========   Vector Reset   =========
							;=====================================
							org 0x0000;
vec_reset					clrf PCLATH; Asegura la pagina cero de la memoria de prog.
							goto prog_prin;
;_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
							;=====================================
							;===== Vector de interrupcion   ======
							;=====================================
							org 0x0004;
vec_int						movwf res_w;
							movf status,w;
							movwf res_status;
						    clrf status;
						    movf pclath,w;
						    movwf res_pclath;
						    clrf pclath;
						    movf fsr,w;
						    movwf res_fsr;
						    
						    btfsc intcon, t0if;
						    call rutina_int;
						    
sal_int                     movlw .131;
						    movwf tmr0;
						    
						    movf res_fsr,w;
						    movwf fsr;
						    movf res_pclath,w;
						    movwf pclath;
						    movf res_status,w;
						    movwf status;
						    movf res_w,w;						    
						    
							retfie;
;-------------------------------------------------------------------------------------
						;=================================
      					;=== Subrutina de interrupcion ===
						;=================================
rutina_int                 incf cont_milis,f;
						   incf presc_1,f;
						   movlw .23;
						   xorwf presc_1,w;
						   btfsc status,z;
						   goto sig_int;
						   goto sal_rutint;
						   
sig_int                    clrf presc_1;
						   incf presc_2,f;
						   movlw .42;
						   xorwf presc_2,w;
						   btfss status,z;
						   goto sal_rutint;
						   clrf presc_1;
						   clrf presc_2;
						   
sal_rutext                 bsf banderas, ban_int;

sal_rutint                 bcf intcon,t0if;
						   return;
;_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
							;=====================================
							;===  Subrutina de Inicio      =======
							;=====================================

prog_ini			   	   bsf STATUS,RP0; selec.elbca. 1 de ram.
						   movlw 0x02;e
						   movwf OPTION_REG ^0x80;
						   movlw proga;
						   movwf TRISA ^0x80;
						   movlw progb;
						   movwf TRISB ^0x80;
						   movlw progc;
						   movwf TRISC ^0x80;
						   movlw progd;
						   movwf TRISD ^0x80;
						   movlw PROGE;
						   movwf TRISE ^0x80;
						   movlw 0x06;
						   movwf adcon1 ^0x80; conf. el pto. a como salidas i/0.
						   bcf status,rp0;
						   movlw .131;
						   movwf tmr0;
						   movlw 0xa0;
						   movwf intcon;
						   clrf portc;
						   movlw 0xff;
						   movwf porta;
						   movlw 0x30;
						   movwf us;
						   movwf ds;
						   movwf um;
						   movwf dm;
						   movwf uh;
						   movwf dh;
						   movwf var_teclado
						   movwf var_tecopri
						   movwf var_tecla
						   movlw 0x00;
						   movwf presc_1;
						   movwf presc_2;
						  
						  movwf 0x0F;
						  movwf portb;
						   return;
;_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
						    ;=====================================
							;===  Programa Principal  ============
							;=====================================
prog_prin				   call prog_ini;
						   call ini_lcd;
						   
						   bcf porta, RS_LCD;
						   movlw 0x86;
						   movwf portc;
						   call pulso_enable;
						   bsf porta, RS_LCD;
						   movlw 0x3a;
						   movwf portc;
						   call pulso_enable;
						   
						   bcf porta, RS_LCD;
						   movlw 0x89;
						   movwf portc;
						   call pulso_enable;
						   bsf porta, RS_LCD;
						   movlw 0x3a;
						   movwf portc;
						   call pulso_enable;
						   						   
seacabocuenta              clrf var_tecopri
						   movlw 0x30;
						   movwf us;
						   movwf ds;
						   movwf um;
						   movwf dm;
						   movwf uh;
						   movwf dh;
						   call show_it;
						   
contarxd				   incf us,f;
						   call chequeous;
						   call chequeods;
						   call chequeoum;
						   call chequeodm;
						   call chequeouh;
						   call chequeodh;
						   call show_it;
						   call barre_teclado
						   goto selecciona_accion
continua				   clrf var_tecopri
						   call esp_int
						   goto contarxd;		   
						   
chequeous                  movf us,w;
						   xorlw 0x3a;
						   btfss status,z;
						   return;
						   movlw 0x30;
                           movwf us;
                           incf ds,f;
                           return;
chequeods                  movf ds,w;
						   xorlw 0x36;
						   btfss status,z;
						   return;
						   movlw 0x30;
                           movwf ds;
                           incf um,f;
                           return;
chequeoum				   movf um,w;
						   xorlw 0x3a;
						   btfss status,z;	
                           return;
                           movlw 0x30;
                           movwf um;
                           incf dm,f;
                           return;
chequeodm				   movf dm,w;
						   xorlw 0x36;
						   btfss status,z;
                           return;
                           movlw 0x30;
                           movwf dm;
                           incf uh,f;
                           return;
chequeouh                  movf uh,w;
						   xorlw 0x3a;
						   btfss status,z;
                           return;
                           movlw 0x30;
                           movwf uh;
                           incf dh,f;
                           return;
chequeodh				   movf dh,w;
						   xorlw 0x32;
						   btfss status,z;	   
                           return;
                           movf uh,w;
						   xorlw 0x34;
						   btfsc status,z;
						   goto seacabocuenta;	
                           return;
                           
show_it                    bcf porta, RS_LCD;
						   movlw 0x8a;
						   movwf portc;
						   call pulso_enable;
						   bsf porta, RS_LCD;
						   movf ds,w;
						   movwf portc;
						   call pulso_enable;
						   
						   bsf porta, RS_LCD;
						   movf us,w;
						   movwf portc;
						   call pulso_enable;
						   
						   bcf porta, RS_LCD;
						   movlw 0x87;
						   movwf portc;
						   call pulso_enable;
						   bsf porta, RS_LCD;
						   movf dm,w;
						   movwf portc;
						   call pulso_enable;
						   
						   bsf porta, RS_LCD;
						   movf um,w;
						   movwf portc;
						   call pulso_enable;
						   
						   bcf porta, RS_LCD;
						   movlw 0x84;
						   movwf portc;
						   call pulso_enable;
						   bsf porta, RS_LCD;
						   movf dh,w;
						   movwf portc;
						   call pulso_enable;
						   
						   bsf porta, RS_LCD;
						   movf uh,w;
						   movwf portc;
						   call pulso_enable;
						   return;					   

barre_teclado			   	bsf portb, Act_ren4;
							nop;
							bcf portb, Act_ren1;
							movf portb,w;
							movwf Var_teclado;
							movlw 0xF0
							andwf Var_teclado,f
							
							movlw No_hay_tecla;
							xorwf Var_teclado,w;
							Btfsc status,z;
							goto sig_ran2
							
							movlw Tec_1;
							xorwf Var_teclado,w;
							btfsc status,z;
							goto tec1;
							
							movlw Tec_2;
							xorwf Var_teclado,w;
							btfsc status,z;
							goto tec2;
							
							movlw Tec_3;
							xorwf Var_teclado,w;
							btfsc status,z;
							goto tec3;
							
							movlw Tec_A;
							xorwf Var_teclado,w;
							btfsc status,z;
							goto Fue_tecA;
							
							nop
							
Sig_ran2					bsf portb, Act_ren1;
							nop;
							bcf portb, Act_ren2;
							movf portb,w;
							movwf Var_teclado;
							movlw 0xF0
							andwf Var_teclado,f
							
							movlw No_hay_tecla;
							xorwf Var_teclado,w;
							Btfsc status,z;
							goto sig_ran3
							
							movlw Tec_4;
							xorwf Var_teclado,w;
							btfsc status,z;
							goto tec4;
							
							movlw Tec_5;
							xorwf Var_teclado,w;
							btfsc status,z;
							goto tec5;
							
							movlw Tec_6;
							xorwf Var_teclado,w;
							btfsc status,z;
							goto tec6;
							
							movlw Tec_B;
							xorwf Var_teclado,w;
							btfsc status,z;
							goto Fue_tecB;
							
							nop
							
Sig_ran3					bsf portb, Act_ren2;
							nop;
							bcf portb, Act_ren3;
							movf portb,w;
							movwf Var_teclado;
							movlw 0xF0
							andwf Var_teclado,f
							
							movlw No_hay_tecla;
							xorwf Var_teclado,w;
							Btfsc status,z;
							goto sig_ran4
							
							movlw Tec_7;
							xorwf Var_teclado,w;
							btfsc status,z;
							goto tec7;
							
							movlw Tec_8;
							xorwf Var_teclado,w;
							btfsc status,z;
							goto tec8;
							
							movlw Tec_9;
							xorwf Var_teclado,w;
							btfsc status,z;
							goto tec9;
							
							movlw Tec_C;
							xorwf Var_teclado,w;
							btfsc status,z;
							goto Fue_tecC;
							
							nop
							
Sig_ran4					bsf portb, Act_ren3;
							nop;
							bcf portb, Act_ren4;
							movf portb,w;
							movwf Var_teclado;
							movlw 0xF0
							andwf Var_teclado,f
							
							movlw No_hay_tecla;
							xorwf Var_teclado,w;
							Btfsc status,z;
							goto Sal_barreteo
							
							movlw Tec_E;
							xorwf Var_teclado,w;
							btfsc status,z;
							goto Fue_tecE;
							
							movlw Tec_0;
							xorwf Var_teclado,w;
							btfsc status,z;
							goto tec0;
							
							movlw Tec_F;
							xorwf Var_teclado,w;
							btfsc status,z;
							goto Fue_tecF;
							
							movlw Tec_D;
							xorwf Var_teclado,w;
							btfsc status,z;
							goto Fue_tecD;
							
							nop
							
tec0					movlw '0'
							movwf var_tecla
							goto Sal_barreteo;
							
tec1					movlw '1';
							movwf var_tecla
							goto Sal_barreteo;
							
tec2					movlw '2';
							movwf var_tecla
							goto Sal_barreteo;
							
tec3					movlw '3';
							movwf var_tecla
							goto Sal_barreteo;
							
tec4					movlw '4';
							movwf var_tecla
							goto Sal_barreteo;
							
tec5					movlw '5';
							movwf var_tecla
							goto Sal_barreteo;
							
tec6					movlw '6';
							movwf var_tecla
							goto Sal_barreteo;
							
tec7					movlw '7';
							movwf var_tecla
							goto Sal_barreteo;
							
tec8					movlw '8';
							movwf var_tecla
							goto Sal_barreteo;
							
tec9					movlw '9';
							movwf var_tecla
							goto Sal_barreteo;
							
Fue_tecA					movlw 'A';
							movwf var_tecopri
							movwf var_tecla
							goto Sal_barreteo;
							
Fue_tecB					movlw 'B';
							movwf var_tecopri
							movwf var_tecla
							goto Sal_barreteo;
							
Fue_tecC					movlw 'C';
							movwf var_tecopri
							movwf var_tecla
							goto Sal_barreteo;
							
Fue_tecD					movlw 'D';
							movwf var_tecopri
							movwf var_tecla
							goto Sal_barreteo;
							
Fue_tecE					movlw 'E';
							movwf var_tecopri
							movwf var_tecla
							goto Sal_barreteo;
							
Fue_tecF					movlw 'F';
							movwf var_tecopri
							movwf var_tecla
							goto Sal_barreteo;

Sal_barreteo				return;


selecciona_accion			movlw 'C';
							xorwf Var_tecopri,w;
							btfss status,z;
							goto pruebaconb;
							goto seacabocuenta;
							
							
pruebaconb					movlw 'B';
							xorwf Var_tecopri,w;
							btfsc status,z;
							call deten_el_relojdh;	
							goto continua
							
							
deten_el_relojdh			movlw 0x2D
							movwf Uh
							movwf Dm 
							movwf Um
							movwf Ds
							movwf Us
							movlw ' '
							movwf Dh
							call show_it
							clrf var_teclado
							call barre_teclado;
							movlw 0xF0
							xorwf var_teclado,w
							btfss status,z
							goto modifica_decenas_hora
							goto deten_el_relojdh	
modifica_decenas_hora		call checaantesdeponerdh
							btfsc status,c
							goto deten_el_relojdh
							movf var_tecla,w
							movwf dh
							call show_it							
deten_el_relojuh			clrf var_teclado
							call barre_teclado;
							movlw 0xF0
							xorwf var_teclado,w
							btfss status,z
							goto modifica_unidades_hora
							goto deten_el_relojuh							
modifica_unidades_hora		call checaantesdeponeruh
							btfsc status,c
							goto deten_el_relojuh
							movf var_tecla,w
							movwf uh
							call show_it
deten_el_relojdm			clrf var_teclado
							call barre_teclado;
							movlw 0xF0
							xorwf var_teclado,w
							btfss status,z
							goto modifica_decenas_minuto
							goto deten_el_relojdm					
modifica_decenas_minuto		call checaantesdeponerdm
							btfsc status,c
							goto deten_el_relojdm
							movf var_tecla,w
							movwf dm
							call show_it						
deten_el_relojum			clrf var_teclado
							call barre_teclado;
							movlw 0xF0
							xorwf var_teclado,w
							btfss status,z
							goto modifica_unidades_minuto
							goto deten_el_relojum							
modifica_unidades_minuto	call checaantesdeponerum
							btfsc status,c
							goto deten_el_relojum
							movf var_tecla,w
							movwf um
							call show_it							
deten_el_relojds			call barre_teclado;
							movlw 0xF0
							xorwf var_teclado,w
							btfss status,z
							goto modifica_decenas_segundo
							goto deten_el_relojds			
modifica_decenas_segundo	call checaantesdeponerds
							btfsc status,c
							goto deten_el_relojds
							movf var_tecla,w
							movwf ds
							call show_it
deten_el_relojus			call barre_teclado;
							movlw 0xF0
							xorwf var_teclado,w
							btfss status,z
							goto modifica_unidades_segundo
							goto deten_el_relojus
														
modifica_unidades_segundo	call checaantesdeponerus
							btfsc status,c
							goto deten_el_relojus
							movf var_tecla,w
							movwf us
							call show_it 
							call bug
							return
							
bug							call barre_teclado
							movlw 'B';
							xorwf Var_tecopri,w;
							btfss status,z;
							goto bug;	
							return				
							   		
checaantesdeponerdh			bcf status,c
							movf var_tecla,w
							addlw .205
							btfss status,c
							return
							call tecla_incorrecta
							return
checaantesdeponeruh			movf Dh,w
							xorlw 0x32
							btfsc status,z
							goto cuentahasta4
							goto cuentahasta9						
cuentahasta4				bcf status,c
							movf var_tecla,w
							addlw .204
							btfss status,c
							return
							call tecla_incorrecta
							return				
cuentahasta9				bcf status,c
							movf var_tecla,w
							addlw .198
							btfss status,c
							return
							call tecla_incorrecta
							return							
checaantesdeponerdm			bcf status,c
							movf var_tecla,w
							addlw .202
							btfss status,c
							return
							call tecla_incorrecta
							return
checaantesdeponerum			bcf status,c
							movf var_tecla,w
							addlw .198
							btfss status,c
							return
							call tecla_incorrecta
							return
checaantesdeponerds			bcf status,c
							movf var_tecla,w
							addlw .202
							btfss status,c
							return
							call tecla_incorrecta
							return
checaantesdeponerus			bcf status,c
							movf var_tecla,w
							addlw .198
							btfss status,c
							return
							call tecla_incorrecta
							return
														
tecla_incorrecta			bcf porta, RS_LCD;
						   movlw 0xc0;
						   movwf portc;
						   call pulso_enable;
						   bsf porta, RS_LCD;
						   movlw ' ';
						   movwf portc;
						   call pulso_enable;
						   call pulso_enable;
						   call pulso_enable;
						   call pulso_enable;
						   call pulso_enable;
						   call pulso_enable;
						   call pulso_enable;
						   call pulso_enable;
						   call pulso_enable;
						   call pulso_enable;
						   call pulso_enable;
						   call pulso_enable;
						   call pulso_enable;
						   call pulso_enable;
						   call pulso_enable;
						   call pulso_enable;
						  return	  
						  
						                                                                                       				
ini_lcd					   bcf porta, RS_LCD;
						   movlw 0x38;
						   movwf portc;
						   call pulso_enable;
						   movlw 0x0c;
						   movwf portc;
						   call pulso_enable;
						   movlw 0x01;
						   movwf portc;
						   call pulso_enable;
						   movlw 0x06;
						   movwf portc;
						   call pulso_enable;
						   movlw 0x80;
						   movwf portc;
						   call pulso_enable;
						   bsf porta, ENABLE_LCD;
						   return;
						   
						   
esp_int                    bcf banderas, ban_int;
jimmy   			       btfss banderas, ban_int;
						   goto jimmy;
						   bcf banderas, ban_int;
						   return;
pulso_enable               bcf porta, ENABLE_LCD;
						   clrf cont_milis;
esp_time                   movlw .1;
						   xorwf cont_milis,w;
						   btfss status,z;
						   goto esp_time;
						   bsf porta, ENABLE_LCD;
						   clrf cont_milis;
esp_time2				   movlw .40;
						   xorwf cont_milis,w;
						   btfss status,z;
						   goto esp_time2;		   
						   return;
;---------------------------------------------------------
						   end;


