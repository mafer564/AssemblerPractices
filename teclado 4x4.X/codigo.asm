;INSTITUTO POLITECNICO NACIONAL
;CECYT 9 "JUAN DE DIOS BATIZ"
;
;PRACTICA 2
;INGRESO DE DATOS AL SISTEMA CON TECLADO MATRICIAL 4X4. 
;
;GRUPO: 6IM2  EQUIPO:
;
;INTEGRANTES:
;VARGAS ESPINO CARLOS HASSAN
;PEREZ JIMENEZ MADELIN FERNANDA    
;COMENTARIO DE LO QUE EL PROGRAMA EJECUTARA: 
;El programa inicializara un reloj tipo militar de 24 hrs.
;
; Usa cristal de 4 MHz


LIST P=16F877A;
#INCLUDE "C:\PROGRAM FILES (X86)\MICROCHIP\MPASM SUITE\P16F877A.INC";
;include <P16F873A.INC>
; Oscilador XT, Watchdog Timer OFF, Power-up Timer ON, Brown-out Reset OFF, 
; Low-Voltage OFF, Protection Data EEPROM OFF, Write protection OFF,
; Code Protection OFF
 __config _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _WRT_OFF & _CP_OFF
	


; Declaracion de direcciones, variables, constantes y etiquetas a utilizar

; Constantes para 5ms
i5ms	    EQU	    d'34'
j5ms	    EQU	    d'49'

; Constantes para antirebote
i_anti	    EQU	    d'33'
j_anti	    EQU	    d'97'
k_anti	    EQU	    d'30'
	    
; Constantes para 1seg
; Se pueden cambiar para aumentar velocidad del reloj y checar los cambios
i_1seg	    EQU	    d'33'	    ;original d'33'
j_1seg	    EQU	    d'97'	    ;original d'97'
k_1seg	    EQU	    d'98'	    ;original d'98'

; Direcciones que se usan como variables para bucles
Contador1	    EQU	    h'20'
Contador2	    EQU	    h'21'
Contador3	    EQU	    h'22'

; Direcciones que se usan como variables para conteo del reloj    
uni_Seg	    EQU	    h'23'	    ; Unidades de segundo
de_Seg	    EQU	    h'24'	    ; Decenas de segundo
uni_Min	    EQU	    h'25'	    ; Unidades de minuto
de_Min	    EQU	    h'26'	    ; Decenas de minuto
uni_Hrs	    EQU	    h'27'	    ; Unidades de hora
de_Hrs	    EQU	    h'28'	    ; Decenas de hora

; Direccion que se usa como variable para saber posicion y valor a cambiar
posicion    EQU	    h'29'
valor	    EQU	    h'2A'

; Bytes de posicion del LCD
PosUni_Seg   EQU	    b'10001011'	    ; Posicion h'0B' en el LCD
PosDec_Seg EQU	    b'10001010'	    ; Posicion h'0A' en el LCD
PosUni_Min   EQU	    b'10001000'	    ; Posicion h'08' en el LCD
PosDec_Min   EQU	    b'10000111'	    ; Posicion h'07' en el LCD
PosUni_Hrs   EQU	    b'10000101'	    ; Posicion h'05' en el LCD
PosDec_Hrs   EQU	    b'10000100'	    ; Posicion h'04' en el LCD
Pos2_ptos1   EQU	    b'10000110'	    ; Posicion h'06' en el LCD
Pos2_ptos2   EQU	    b'10001001'	    ; Posicion h'09' en el LCD
Pos_Lim_Dere EQU	    b'10001100'	    ; Posicion extrema derecha h'0C'
Pos_Lim_Izq  EQU	    b'10000011'	    ; Posicion extrema izquierda h'03'

; Valor usado para restablecer un contador a 0
cero	    EQU	    h'30'	; Valor ASCII para 0
uno	    EQU	    h'31'	; Valor ASCII para 1
dos	    EQU	    h'32'	; Valor ASCII para 2
tres	    EQU	    h'33'	; Valor ASCII para 3
cuatro	    EQU	    h'34'	; Valor ASCII para 4
cinco	    EQU	    h'35'	; Valor ASCII para 5
seis	    EQU	    h'36'	; Valor ASCII para 6
siete	    EQU	    h'37'	; Valor ASCII para 7
ocho	    EQU	    h'38'	; Valor ASCII para 8
nueve	    EQU	    h'39'	; Valor ASCII para 9
	    
; Valores limites que se usan para comparar contra el conteo del reloj	    
limite_Uni   EQU	    h'3A'	; Valor ASCII ';' 1 despues del '9' (unidades)
limite_Dec   EQU	    h'36'	; Valor ASCII '6' (decenas)
limiteUni_Hrs  EQU	    h'34'	; Valor ASCII '4' (unidades de hora)
limiteDec_Hrs  EQU	    h'33'	; Valor ASCII '3' (decenas de hora)

  ;PUERTO A: control de la lcd
; Establecer bits de configuracion de cada puerto	    
en_ON	    EQU	    b'000001'	    ; Pin A0
en_OFF	    EQU	    b'000000'
rs_ON	    EQU	    b'000010'	    ; Pin A1
rs_OFF	    EQU	    b'000000'	    	    	    

    ;PUERTO B  : conrol del teclado
; Bytes de posicion del Teclado
fila1	    EQU	    b'00001110'	    
fila2	    EQU	    b'00001101'
fila3	    EQU	    b'00001011'	    
fila4	    EQU	    b'00000111'
columna1    EQU	    d'4'
columna2    EQU	    d'5'
columna3    EQU	    d'6'    
columna4    EQU	    d'7'

  ;PUERTO C: control de los bits de la lcd	    
; Bytes de configuracion del LCD
LCDfunction EQU	    b'00111000'	    ; 8 bits, 2 lineas, Matriz 5x8 puntos
dispCTRL1   EQU	    b'00001100'	    ; Display ON, Cursor OFF, Parpadeo OFF
dispCTRL2   EQU	    b'00001101'	    ; Display ON, Cursor OFF, Parpadeo ON
clearLCD    EQU	    b'00000001'	    ; Limpia el LCD
dispMODE    EQU	    b'00000110'	    ; Cursor a la derecha, Corrimiento OFF

; Renombrar Puertos
LCD	    EQU	    PORTC;
teclado	    EQU	    PORTB;
 
;=============================================
;=============================================
;======= Inicializacion del programa==========
;=============================================
	org	0		; Comenzar en direccion 0
	errorlevel	-302	; Ignorar error 302
;=============================================================
;=============================================================
;==Configuracion de los puertos del PIC	(Entradas o salidas)==
;=============================================================
	    bsf	    STATUS,RP0	; Cambio a banco 1
	    bcf	    OPTION_REG,7; Habilita resistencias Pull-Up
	    clrf    TRISA       ; Pines PORTA salidas (RS, E)
	    movlw   b'11110000'	; Nibble alto entradas, nibble bajo salidas
	    movwf   TRISB	; Pines PORTB salidas y entradas
	    clrf    TRISC	; Pines PORTC salidas (LCD)
	    bcf	    STATUS,RP0	; Cambio a banco 0
;==================================================================
;==================================================================	    
;============= Inicializa el display para poder usarse y===========
;=================escribe en la pantalla 00:00:00==================
;==================================================================
	    call    LCDini[;
;==================================================================
;==================================================================
;============= Pone a ceros los contadores del reloj===============
;==================================================================
	    call    ResetCont;
;==================================================================
;==================================================================
;===== Espera un par de segundos antes de iniciar el programa======
;==================================================================
	    call    pausa1seg;
	    call    pausa1seg;
;==============================================================
;==============================================================
;=======================Inicio del programa====================
;==============================================================
main	    call    pausa1seg;
	    movlw   fila4	    ; Se prepara para detectar '*'
	    movwf   teclado	    ; Activa la fila 4
	    
;==================================================================
;==================================================================
;==============INCREMENTO DE UNIDADES DE SEGUNDO===================
;==================================================================

uni_Segundos  incf    uni_Seg,1	    ; Incrementa las unidades de segundo
	    movf    uni_Seg,0	    ; Copia uni_Seg a W
	    sublw   limite_Uni	    ; Calcula (limite - W) = (h'3A' - W)
	    btfss   STATUS,Z	    ; Si Z=1 se alcanzo el limite y salta
	    goto    muestraUS	    ; Si Z no es 1 muestra el valor actual
	    
	    movlw   cero	    ; Copia el valor de '0' a W
	    movwf   uni_Seg	    ; Reset del contador unidades de segundo
	    movlw   PosUni_Seg	    ; Ubicacion donde escribir en el LCD (0x0B)
	    movwf   LCD
	    call    comando
    
	    movf    uni_Seg,0	    ; Muestra el cero en el LCD
	    movwf   LCD
	    call    dato
				    ; Como se llego a las 10 unidades
	    goto    de_Segundos	    ; cambiar las decenas de segundo 
	    
muestraUS  movlw   PosUni_Seg	    ; Ubicacion donde escribir en el LCD (0x0B)
	    movwf   LCD;
	    call    comando;
	    
	    movf    uni_Seg,0	    ; Muestra el valor unidades de segundo
	    movwf   LCD;
	    call    dato;
	    
	    call    pausa1seg;
	    goto    uni_Segundos	    ; Una vez hecho el cambio seguir con el
				    ; conteo de los segundos

;==================================================================
;==================================================================
;===========INCREMENTO DE DECENAS DE SEGUNDO=======================
;==================================================================

de_Segundos  incf    de_Seg,1	    ; Incrementa las decenas de segundo
	    movf    de_Seg,0	    ; Copia de_Seg a W
	    sublw   limiteDec	    ; Calcula (limite - W) = (h'36' - W)
	    btfss   STATUS,Z	    ; Si Z=1 se alcanzo el limite y salta
	    goto    muestraDS	    ; Si Z no es 1 muestra el valor actual
	    
	    movlw   cero	    ; Copia el valor de '0' a W
	    movwf   de_Seg	    ; Reset del contador decenas de segundo
	    movlw   PosDecSeg	    ; Ubicacion donde escribir en el LCD (0x0A)
	    movwf   LCD;
	    call    comando;
	    
	    movf    de_Seg,0	    ; Muestra el cero en el LCD
	    movwf   LCD;
	    call    dato;
				    ; Como se llego a las 6 unidades
	    goto    uni_Minutos	    ; cambiar las unidades de minuto

muestraDS  movlw   PosDecSeg	    ; Ubicacion donde escribir en el LCD (0x0A)
	    movwf   LCD;
	    call    comando;
	    
	    movf    de_Seg,0	    ; Muestra el valor decenas de segundo
	    movwf   LCD;
	    call    dato;
	    
	    call    pausa1seg;
	    
	    goto    uni_Segundos	    ; Una vez hecho el cambio seguir con el
				    ; conteo de los segundos

;==================================================================
;==================================================================
;================INCREMENTO DE UNIDADES DE MINUTOS=================
;==================================================================

uni_Minutos   incf    uni_Min,1	    ; Incrementa las unidades de minuto
	    movf    uni_Min,0	    ; Copia uni_Min a W
	    sublw   limite_Uni	    ; Calcula (limite - W) = (h'3A' - W)
	    btfss   STATUS,Z	    ; Si Z=1 se alcanzo el limite y salta
	    goto    muestraUM	    ; Si Z no es 1 muestra el valor actual
	    
	    movlw   cero	    ; Copia el valor de '0' a W
	    movwf   uni_Min	    ; Reset del contador unidades de minuto
	    movlw   PosUni_Min	    ; Ubicacion donde escribir en el LCD (0x08)
	    movwf   LCD;
	    call    comando;
	    
	    movf    uni_Min,0	    ; Muestra el cero en el LCD
	    movwf   LCD;
	    call    dato;
				    ; Como se llego a las 10 unidades
	    goto    de_Minutos	    ; cambiar las decenas de minuto 

muestraUM  movlw   PosUni_Min	    ; Ubicacion donde escribir en el LCD (0x08)
	    movwf   LCD;
	    call    comando;
	    
	    movf    uni_Min,0	    ; Muestra el valor unidades de minuto
	    movwf   LCD;
	    call    dato;
	    
	    call    pausa1seg;
	    
	    goto    uni_Segundos	    ; Una vez hecho el cambio seguir con el
				    ; conteo de los segundos	    

;==================================================================
;==================================================================
;==============INCREMENTO DE DECENAS DE MINUTOS====================
;==================================================================
de_Minutos   incf    de_Min,1	    ; Incrementa las decenas de minuto
	    movf    de_Min,0	    ; Copia de_Min a W
	    sublw   limiteDec	    ; Calcula (limite - W) = (h'36' - W)
	    btfss   STATUS,Z	    ; Si Z=1 se alcanzo el limite y salta
	    goto    muestraDM	    ; Si Z no es 1 muestra el valor actual
	    
	    movlw   cero	    ; Copia el valor de '0' a W
	    movwf   de_Min	    ; Reset del contador decenas de minuto
	    movlw   PosDec_Min	    ; Ubicacion donde escribir en el LCD (0x07)
	    movwf   LCD;
	    call    comando;
	    
	    movf    de_Min,0	    ; Muestra el cero en el LCD
	    movwf   LCD;
	    call    dato;
				    ; Como se llego a las 6 unidades
	    goto    uHoras	    ; cambiar las unidades de hora

muestraDM  movlw   PosDec_Min	    ; Ubicacion donde escribir en el LCD (0x08)
	    movwf   LCD;
	    call    comando;
	    
	    movf    de_Min,0	    ; Muestra el valor decenas de minuto
	    movwf   LCD;
	    call    dato;
	    
	    call    pausa1seg;
	    
	    goto    uni_Segundos	    ; Una vez hecho el cambio seguir con el
				    ; conteo de los segundos	    
	    
;==================================================================
;==================================================================
;================INCREMENTO DE UNIDADES DE HORA====================
;==================================================================

uHoras	    incf    uni_Hrs,1	    ; Incrementa las unidades de hora
	    movf    de_Hrs,0	    ; Copia del valor de de_Hrs a W 
	    sublw   limiteDec_Hrs-1    ; Calcula ((limite - 1) - W) = (h'32' - W)
	    btfss   STATUS,Z	    ; Si Z=1 -> de_Hrs='2' -> limite de uni_Hrs = '4'
	    goto    HrsLong	    ; Si Z no es 1 uni_Hrs debe contar hasta 10

	    movf    uni_Hrs,0	    ; Copia uni_Hrs a W 
	    sublw   limiteUni_Hrs	    ; Calcula (limite - W) = (h'34' - W)
	    btfss   STATUS,Z	    ; Si Z=1 se alcanzo el limite y salta
	    goto    muestraUH	    ; Si Z no es 1 muestra el valor actual
	    
	    movlw   cero	    ; Copia el valor de '0' a W
	    movwf   uni_Hrs	    ; Reset del contador unidades de hora
	    movlw   PosUni_Hrs	    ; Ubicacion donde escribir en el LCD (0x05)
	    movwf   LCD;
	    call    comando;
	    
	    movf    uni_Hrs,0	    ; Muestra el cero en el LCD
	    movwf   LCD;
	    call    dato;
				    ; Como se llego a las 4 unidades
	    goto    dHoras	    ; cambiar las decenas de hora
	    
HrsLong    movf    uni_Hrs,0	    ; Copia uni_Hrs a W 
	    sublw   limite_Uni	    ; Calcula (limite - W) = (h'3A' - W)
	    btfss   STATUS,Z	    ; Si Z=1 se alcanzo el limite y salta
	    goto    muestraUH	    ; Si Z no es 1 muestra el valor actual
	    
	    movlw   cero	    ; Copia el valor de '0' a W
	    movwf   uni_Hrs	    ; Reset del contador unidades de hora
	    movlw   PosUni_Hrs	    ; Ubicacion donde escribir en el LCD (0x05)
	    movwf   LCD;
	    call    comando;
	    
	    movf    uni_Hrs,0	    ; Muestra el cero en el LCD
	    movwf   LCD;
	    call    dato;
				    ; Como se llego a las 10 unidades
	    goto    dHoras	    ; cambiar las decenas de hora
   

muestraUH  movlw   PosUni_Hrs	    ; Ubicacion donde escribir en el LCD (0x05)
	    movwf   LCD;
	    call    comando;
	    
	    movf    uni_Hrs,0	    ; Muestra el valor unidades de hora	    
	    movwf   LCD;
	    call    dato;
	    
	    call    pausa1seg;
	    
	    goto    uni_Segundos	    ; Una vez hecho el cambio seguir con el
				    ; conteo de los segundos
	    
;==================================================================
;==================================================================
;=================INCREMENTO DE DECENAS DE HORA====================
;==================================================================

dHoras	    incf    de_Hrs,1	    ; Incrementa las decenas de hora
	    movf    de_Hrs,0	    ; Copia de_Hrs a W
	    sublw   limiteDec_Hrs	    ; Calcula (limite - W) = (h'33' - W)
	    btfss   STATUS,Z	    ; Si Z=1 se alcanzo el limite y salta
	    goto    muestraDH	    ; Si Z no es 1 muestra el valor actual
	    
	    movlw   cero	    ; Copia el valor de '0' a W
	    movwf   de_Hrs	    ; Reset del contador decenas de hora
	    movlw   PosDec_Hrs	    ; Ubicacion donde escribir en el LCD (0x04)
	    movwf   LCD;
	    call    comando;
	    
	    movf    de_Hrs,0	    ; Muestra el cero en el LCD
	    movwf   LCD;
	    call    dato;
				    ; Como llego a las 3 unidades
	    goto    main	    ; regresa al inicio del programa

muestraDH  movlw   PosDec_Hrs	    ; Ubicacion donde escribir en el LCD (0x04)
	    movwf   LCD;
	    call    comando;
	    
	    movf    de_Hrs,0	    ; Muestra el valor decenas de hora
	    movwf   LCD;
	    call    dato;
	    
	    call    pausa1seg;
	    
	    goto    uni_Segundos	    ; Una vez hecho el cambio seguir con el
				    ; conteo de los segundos	    


;=====================================
;=====================================
;============SUBRUTINAS===============
;=====================================				    

; Pone a '0' los valores de los contadores
ResetCont  movlw   cero;
	    movwf   uni_Seg;
	    movwf   de_Seg;
	    movwf   uni_Min;
	    movwf   de_Min;
	    movwf   uni_Hrs;
	    movwf   de_Hrs;

	    movlw   '0';
	    movwf   LCD;
	    call    dato;
	    call    dato;
	    
	    movlw   ':';
	    movwf   LCD;
	    call    dato;
	    
	    movlw   '0';
	    movwf   LCD;
	    call    dato;
	    call    dato;
	    
	    movlw   ':';
	    movwf   LCD;
	    call    dato;

	    movlw   '0';
	    movwf   LCD;
	    call    dato;
	    call    dato;

	    return;
;==================================================================
;==================================================================
;==============Manda la orden de comando al LCD==================== 
;=============con RS=0 mas un pulso de 5ms en E====================
;==================================================================
comando    movlw   en_ON;
	    iorlw   rs_OFF;
	    movwf   PORTA;
	    call    pausa5ms;
	    movlw   en_OFF;
	    iorlw   rs_OFF;
	    movwf   PORTA;
	    call    pausa5ms;
	    
	    return;
;==================================================================
;==================================================================
;========== Manda la orden de envio de datos a la LCD============== 
;=============con RS=1 mas un pulso de 5ms en E	===================
;==================================================================
dato	    movlw   en_ON;
	    iorlw   rs_ON;
	    movwf   PORTA;
	    call    pausa5ms;
	    movlw   en_OFF;
	    iorlw   rs_ON;
	    movwf   PORTA;
	    call    pausa5ms;
	    
	    return;
;=================================================
;=================================================
; ============Rutina de retardo de 5ms============
;=================================================
pausa5ms   movlw	j5ms		; Rutina de retraso de 5ms
	    movwf	Contador2;
loop2	    movlw	i5ms;
	    movwf	Contador1;
loop1	    decfsz	Contador1,1;
	    goto	loop1;
	    decfsz	Contador2,1;
	    goto	loop2;
	    
	    return;
;========================================================
;========================================================
;======Rutina de retardo antirebote de push button=======
;========================================================
antirebote  movlw	k_anti		; Rutina de retraso de 500 ms
	    movwf	Contador3;
loop5	    movlw	j_anti;
	    movwf	Contador2;
loop4	    movlw	i_anti;
	    movwf	Contador1;
loop3	    decfsz	Contador1,1;
	    goto	loop3;
	    decfsz	Contador2,1;
	    goto	loop4;
	    decfsz	Contador3,1;
	    goto	loop5;
	    
	    return;
;==========================================================
;==========================================================	    
;==== Rutina de retardo de 1seg + Deteccion de boton '*'===
;==========================================================
pausa1seg  movlw	k_1seg		; Rutina de retraso de 1 segundo
	    movwf	Contador3;
loop8	    movlw	j_1seg;
	    movwf	Contador2;
loop7	    movlw	i_1seg;
	    movwf	Contador1;
	    btfss	teclado,columna1	; Busca si '*' fue presionado
	    goto	TimeSet		; Si '*'=1 va a rutina de cambio de hora
loop6	    decfsz	Contador1,1;
	    goto	loop6;
	    decfsz	Contador2,1;
	    goto	loop7;
	    decfsz	Contador3,1;
	    goto	loop8;
	    
	    return;
;========================================================
;========================================================
;==============Inicializacion del LCD====================	    
;========================================================
LCDini	    call    pausa5ms;

	    movlw   LCDfunction;
	    movwf   LCD;
	    call    comando;
	    
	    movlw   dispCTRL1;
	    movwf   LCD;
	    call    comando;
	    
	    movlw   clearLCD;
	    movwf   LCD;
	    call    comando;
	    
	    movlw   dispMODE;
	    movwf   LCD;
	    call    comando;
	    
	    movlw   PosDec_Hrs;
	    movwf   LCD;
	    call    comando;

	    return;	    
;========================================================
;========================================================
;===Inicializacion de LCD en modo de edicion de hora=====
;========================================================
TimeSet    call    antirebote;
	    movlw   PosDec_Hrs;		
	    movwf   posicion		; Guarda posicion actual en la variable
	    movwf   LCD;
	    call    comando		; Se posiciona en decenas de hora

	    movlw   dispCTRL2;
	    movwf   LCD;
	    call    comando		; Cambia el modo del cursor a parpadeo
	    
	    goto    ScanKeys		; Escanea teclas
;========================================================
;========================================================
;=============Bucle de escaneo de teclas=================	    
;========================================================
ScanKeys   movlw   fila1;		
	    movwf   teclado		; Empieza buscando en la fila 1
	    
	    btfss   teclado,columna1	; Pregunta por tecla 1
	    goto    Tecla1;
	    
	    btfss   teclado,columna2	; Pregunta por tecla 2
	    goto    Tecla2;

	    btfss   teclado,columna3	; Pregunta por tecla 3
	    goto    Tecla3;
	    
	    movlw   fila2;		
	    movwf   teclado		; Buscando en la fila 2
	    
	    btfss   teclado,columna1	; Pregunta por tecla 4
	    goto    Tecla4;

	    btfss   teclado,columna2	; Pregunta por tecla 5
	    goto    Tecla5;

	    btfss   teclado,columna3	; Pregunta por tecla 6
	    goto    Tecla6;

	    movlw   fila3;		
	    movwf   teclado		; Buscando en la fila 3
	    
	    btfss   teclado,columna1	; Pregunta por tecla 7
	    goto    Tecla7;

	    btfss   teclado,columna2	; Pregunta por tecla 8
	    goto    Tecla8;

	    btfss   teclado,columna3	; Pregunta por tecla 9
	    goto    Tecla9;

	    btfss   teclado,columna4	; Pregunta por tecla C
	    goto    TeclaC;

	    movlw   fila4;		
	    movwf   teclado		; Buscando en la fila 4
	    
	    btfss   teclado,columna2	; Pregunta por tecla 0
	    goto    Tecla0;

	    btfss   teclado,columna3	; Pregunta por tecla #
	    goto    TeclaExit;

	    btfss   teclado,columna4	; Pregunta por tecla D
	    goto    TeclaD;
	    
	    goto    ScanKeys;
;=======================================	    
;=====Comportamiento de tecla 0=========
;=======================================
Tecla0	    call    antirebote;
	    movlw   cero		; Carga el valor de la tecla
	    movwf   valor		; y lo copia a la variable
	    
	    call    CambiaDato		; '0' no tiene restricciones entonces
					; se manda a escribir siempre
	    call    BuscaPtos1		; Busca los ':' para evitar esa posicion
	    
	    call    LimRight		; Busca cursor fuera de limite derecho
	    
	    goto    ScanKeys;

;=======================================	    
;======Comportamiento de tecla 1========    
;=======================================
Tecla1    call    antirebote;
	    movlw   uno			; Carga el valor de la tecla
	    movwf   valor		; y lo copia a la variable
	    
	    call    CambiaDato		; '1' no tiene restricciones entonces

	    call    LimRight		; Busca cursor fuera de limite derecho
	    
	    call    BuscaPtos1		; Busca los ':' para evitar esa posicion
					; se manda a escribir siempre
	    goto    ScanKeys;
;=======================================
;======Comportamiento de tecla 2========	    
;=======================================
Tecla2	    call    antirebote;
	    movlw   dos			; Carga el valor de la tecla
	    movwf   valor		; y lo copia a la variable
	    
	    call    CambiaDato		; '2' no tiene restricciones entonces

	    call    LimRight		; Busca cursor fuera de limite derecho
	    
	    call    BuscaPtos1		; Busca los ':' para evitar esa posicion
	    
	    goto    ScanKeys;
;=======================================
;==== Comportamiento de tecla 3 ========
;=======================================
Tecla3	    call    antirebote;
	    movlw   tres		; Carga el valor de la tecla
	    movwf   valor		; y lo copia a la variable
	    
	    call    Valido		; '3' esta prohibido para decenas de hrs
					; 
	    call    CambiaDato;		
	    
	    call    LimRight		; Busca cursor fuera de limite derecho
	    
	    call    BuscaPtos1		; Busca los ':' para evitar esa posicion
	    
	    goto    ScanKeys;
;=======================================
;===== Comportamiento de tecla 4 =======
;=======================================
Tecla4	    call    antirebote;
	    movlw   cuatro		; Carga el valor de la tecla
	    movwf   valor		; y lo copia a la variable
	    
	    call    Valido		; '4' prohibido para dec de hrs siempre
					; y para uni de hrs si dec de hrs es '2'
	    call    CambiaDato		
	    
	    call    LimRight		; Busca cursor fuera de limite derecho
	    
	    call    BuscaPtos1		; Busca los ':' para evitar esa posicion
	    
	    goto    ScanKeys;	    

;=======================================
;===== Comportamiento de tecla 5 =======
;=======================================
Tecla5     call    antirebote;
	    movlw   cinco		; Carga el valor de la tecla
	    movwf   valor		; y lo copia a la variable
	    
	    call    Valido		; '5' prohibido para dec de hrs siempre
					; y para uni de hrs si dec de hrs es '2'
	    call    CambiaDato;		
	    
	    call    LimRight		; Busca cursor fuera de limite derecho
	    
	    call    BuscaPtos1		; Busca los ':' para evitar esa posicion
	    
	    goto    ScanKeys;	    	    
;=======================================
;===== Comportamiento de tecla 6 =======
;=======================================
Tecla6	    call    antirebote;
	    movlw   seis		; Carga el valor de la tecla
	    movwf   valor		; y lo copia a la variable
	    
	    call    Valido		; '6' solo es valido para uni de seg, de
					; min y de hrs (si DecHrs es '1' o '0')
	    call    CambiaDato;		
	    
	    call    LimRight		; Busca cursor fuera de limite derecho
	    
	    call    BuscaPtos1		; Busca los ':' para evitar esa posicion
	    
	    goto    ScanKeys;	    
;=======================================
;====== Comportamiento de tecla 7 ======
;=======================================
Tecla7	    call    antirebote;
	    movlw   siete		; Carga el valor de la tecla
	    movwf   valor		; y lo copia a la variable
	    
	    call    Valido		; '7' solo es valido para uni de seg, de
					; min y de hrs (si DecHrs es '1' o '0')
	    call    CambiaDato;		
	    
	    call    LimRight		; Busca cursor fuera de limite derecho
	    
	    call    BuscaPtos1		; Busca los ':' para evitar esa posicion
	    
	    goto    ScanKeys;	    	    
;=======================================
;====== Comportamiento de tecla 8 ======
;=======================================
Tecla8	    call    antirebote;
	    movlw   ocho		; Carga el valor de la tecla
	    movwf   valor		; y lo copia a la variable
	    
	    call    Valido		; '8' solo es valido para uni de seg, de
					; min y de hrs (si DecHrs es '1' o '0')
	    call    CambiaDato;		
	    
	    call    LimRight		; Busca cursor fuera de limite derecho
	    
	    call    BuscaPtos1		; Busca los ':' para evitar esa posicion
	    
	    goto    ScanKeys;	    	    
;=======================================
;====== Comportamiento de tecla 9 ======
;=======================================
Tecla9	    call    antirebote;
	    movlw   nueve		; Carga el valor de la tecla
	    movwf   valor		; y lo copia a la variable
	    
	    call    Valido		; '9' solo es valido para uni de seg, de
					; min y de hrs (si DecHrs es '1' o '0')
	    call    CambiaDato;		
	    
	    call    LimRight		; Busca cursor fuera de limite derecho
	    
	    call    BuscaPtos1		; Busca los ':' para evitar esa posicion
	    
	    goto    ScanKeys;	    	    
;=======================================
;===== Comportamiento de tecla C =======
;=======================================	    
TeclaC	    call    antirebote;
	    decf    posicion,1		; Decrementa la posicion en 1
	    
	    call    LimLeft		; Busca si esta fuera de los limites

	    call    BuscaPtos2		; Busca los ':' para evitar esa posicion
	    
	    movf    posicion,0		; Si todo es correcto toma nueva 
	    movwf   LCD		; posicion
	    call    comando;
	    
	    goto    ScanKeys;
;=======================================	    
;===== Comportamiento de tecla D =======
;=======================================
TeclaD	    call    antirebote;
	    incf    posicion,1; Decrementa la posicion en 1
    
	    call    LimRight; Busca si esta fuera de los limites

	    call    BuscaPtos1; Busca los ':' para evitar esa posicion

	    movf    posicion,0; Si todo es correcto toma nueva 
	    movwf   LCD	; posicion
	    call    comando;
	    
	    goto    ScanKeys;
;=======================================
;===== Comportamiento de tecla # =======    
;=======================================
TeclaExit  call    antirebote;
	    movlw   dispCTRL1;
	    movwf   LCD;
	    call    comando; Cambia el modo el cursor a no parpadeo
	    goto    main;
;========================================================
;========================================================
;==== Cambia el valor en el LCD dependiendo del =========
;======	las variables VALOR y POSICION ==================
;========================================================
CambiaDato movf    posicion,0; Copia la variable a W
	    movwf   LCD;
	    call    comando; Nueva posicion
	    
	    movf    valor,0; Copia la variable a W
	    movwf   LCD;
	    call    dato; Nuevo dato
;========================================================
;========================================================
;======= Dentro de la rutina actualiza la variable ======
;========= que usa el contador del reloj ================	    
;========================================================
CompUniSeg movf    posicion,0;		
	    sublw   PosUni_Seg		; Calcula (PosUni_Seg - W) = (h'0B' - W)
	    BTFSS  STATUS,Z		; Si Z=1 actualiza la variable del reloj
	    goto    CompDecSeg		; Si Z=0 compara siguiente posicion
	    movf    valor,0;
	    movwf   uni_Seg;
	    goto    FinCambia;

CompDecSeg movf    posicion,0;		
	    sublw   PosDecSeg		; Calcula (PosDecSeg - W) = (h'0A' - W)
	    BTFSS   STATUS,Z		; Si Z=1 actualiza la variable del reloj
	    goto    CompUniMin		; Si Z=0 compara siguiente posicion
	    movf    valor,0;
	    movwf   de_Seg;
	    goto    FinCambia	   ;
	    
CompUniMin movf    posicion,0	;	
	    sublw   PosUni_Min		; Calcula (PosUni_Min - W) = (h'08' - W)
	    btfss   STATUS,Z		; Si Z=1 actualiza la variable del reloj
	    goto    CompDecMin		; Si Z=0 compara siguiente posicion
	    movf    valor,0;
	    movwf   uni_Min;
	    goto    FinCambia	   ;

CompDecMin movf    posicion,0;		
	    sublw   PosDec_Min		; Calcula (PosDec_Min - W) = (h'07' - W)
	    btfss   STATUS,Z		; Si Z=1 actualiza la variable del reloj
	    goto    CompUniHrs		; Si Z=0 compara siguiente posicion
	    movf    valor,0;
	    movwf   de_Min;
	    goto    FinCambia	   ;

CompUniHrs movf    posicion,0	;	
	    sublw   PosUni_Hrs		; Calcula (PosUni_Hrs - W) = (h'05' - W)
	    btfss   STATUS,Z		; Si Z=1 actualiza la variable del reloj
	    goto    CompDecHrs		; Si Z=0 compara siguiente posicion
	    movf    valor,0;
	    movwf   uni_Hrs;
	    goto    FinCambia	   ;

CompDecHrs movf    posicion,0;
	    sublw   PosDec_Hrs;
	    btfss   STATUS,Z		; Si Z=1 actualiza la variable del reloj
	    goto    FinCambia;
	    
	    movf    valor,0		; Si no es ninguna lo guarda en la
	    movwf   de_Hrs		; variable de las decenas de hrs
	    sublw   dos			; Compara si el valor escrito es '2'
	    btfss   STATUS,Z;		
	    goto    FinCambia		; Si Z=0 finaliza CambiaDato
	    
	    incf    posicion,0;
	    movwf   LCD;
	    call    comando;
	    
	    movlw   cero		; Si Z=1 pone a '0' unidades de hora
	    movwf   uni_Hrs;
	    movwf   LCD;
	    call    dato;

	    incf    posicion,0;
	    movwf   LCD;
	    call    comando;
	    

FinCambia  incf    posicion,1;
	    return;
;========================================================
;======= Revisa si el proximo valor que se manda ========
;======== se traslapa con alguna posicion de ':' ========
;========================================================
BuscaPtos1 movf    posicion,0		; Copia la variable de posicion a W
					; para saber si saltar o no los ':'
	    sublw   Pos2_ptos1		; Calcula (PosPuntos1 - W) = (h'06' - W)
	    btfss   STATUS,Z		; Si Z=1 saltar una posicion mas
	    goto    OtrosPtos1		; Si Z=0 comprueba segundos puntos
	    incf    posicion,1		; Incremento extra de posicion
	    movf    posicion,0;
	    movwf   LCD;
	    call    comando;
	    return	;		
	    
OtrosPtos1 movf    posicion,0;
	    sublw   Pos2_ptos2		; Calcula (PosPuntos2 - W) = (h'09' - W)
	    btfss   STATUS,Z		; Si Z=1 saltar una posicion mas
	    return;
	    incf    posicion,1		; Incremento extra de posicion
	    movf    posicion,0;
	    movwf   LCD;
	    call    comando;
	    return;
;========================================================
;======= Revisa si el proximo valor que se manda ========
;======== se traslapa con alguna posicion de ':' ========
;========================================================
BuscaPtos2 movf    posicion,0		; Copia la variable de posicion a W
					; para saber si saltar o no los ':'
	    sublw   Pos2_ptos1		; Calcula (PosPuntos1 - W) = (h'06' - W)
	    btfss   STATUS,Z		; Si Z=1 saltar una posicion mas
	    goto    OtrosPtos2		; Si Z=0 comprueba segundos puntos
	    decf    posicion,1		; Decremento extra de posicion
	    movf    posicion,0;
	    movwf   LCD;
	    call    comando;
	    return	;		
	    
OtrosPtos2 movf    posicion,0;
	    sublw   Pos2_ptos2		; Calcula (PosPuntos2 - W) = (h'09' - W)
	    btfss   STATUS,Z		; Si Z=1 saltar una posicion mas
	    return;
	    decf    posicion,1		; Decremento extra de posicion
	    movf    posicion,0;
	    movwf   LCD;
	    call    comando;
	    return;
;========================================================	    
;===== Si la nueva posicion esta fuera del limite =======
;============ derecho lo manda a PosDec_Hrs ==============
;========================================================
LimRight  movf    posicion,0		; Copia la variable de posicion a W
	    sublw   Pos_Lim_Dere		; Calcula (LimDer - W) = (h'0C' - W)
	    btfss   STATUS,Z		; Si Z=1 mandar a PosDec_Hrs
	    return;
	    movlw   PosDec_Hrs;
	    movwf   posicion;
	    movwf   LCD;
	    call    comando;
	    goto    ScanKeys;
;========================================================	    
;======= Si la nueva posicion esta fuera del limite =====
;============= izquiero lo manda a PosUni_Seg ============	    
LimLeft    movf    posicion,0		; Copia la variable de posicion a W
	    sublw   Pos_Lim_Izq		; Calcula (LimIzq - W) = (h'03' - W)
	    btfss   STATUS,Z		; Si Z=1 mandar a PosUni_Seg
	    return;
	    movlw   PosUni_Seg;
	    movwf   posicion		; Guarda la nueva posicion
	    movwf   LCD;
	    call    comando;
	    goto    ScanKeys;	    
;========================================================
;========================================================
;======== Revisa si el dato a escribir es valido ========
;============== con respecto a su posicion ==============
;========================================================
Valido	    movf    valor,0		; Copia la variable de valor a W
	    sublw   tres		; Calcula ('3' - W) = (h'33' - W)
	    btfss   STATUS,Z		; Si Z=1 revisa restricciones de '3'
	    goto    CompTecl4		; Si Z=0 pregunta si es un '4'

CompTecl3  movf    posicion,0		; Copia la variable de posicion a W
	    sublw   PosDec_Hrs		; Calcula (PosDec_Hrs - W) = (h'04' - W)
	    btfss   STATUS,Z;		
	    return			; Si Z=0 es valido
	    goto    ScanKeys		; Si Z=1 ignora la tecla

CompTecl4  movf    valor,0		; Copia la variable de valor a W
	    sublw   cuatro		; Calcula ('4' - W) = (h'34' - W)
	    btfss   STATUS,Z		; Si Z=1 revisa restricciones de '4'
	    goto    CompTecl5		; Si Z=0 pregunta si es un '5'
	    
	    movf    posicion,0		; Copia la variable de posicion a W
	    sublw   PosDec_Hrs		; Calcula (PosDec_Hrs - W) = (h'04' - W)
	    btfsc   STATUS,Z;		
	    goto    ScanKeys		; Si Z=1 ignora la tecla
					; Si Z=0 pregunta por PosUni_Hrs
	    movf    posicion,0;		
	    sublw   PosUni_Hrs		; Calcula (PosUni_Hrs - W) = (h'05' - W)
	    btfss   STATUS,Z	;	
	    return		;	; Si Z=0 es valido
					; Si Z=1 pregunta por valor de de_Hrs
	    movf    de_Hrs,0		; Carga el valor de de_Hrs
	    sublw   dos			; Revisa si es '2'
	    btfss   STATUS,Z	;	
	    return			; Si Z=0 es valido
	    goto    ScanKeys		; Si Z=1 ignora tecla
	    
CompTecl5  movf    valor,0		; Copia la variable de valor a W
	    sublw   cinco		; Calcula ('5' - W) = (h'35' - W)
	    btfss   STATUS,Z		; Si Z=1 revisa restricciones de '5'
	    goto    CompTecl6		; Si Z=0 pregunta si es un '6'
	    
	    movf    posicion,0		; Copia la variable de posicion a W
	    sublw   PosDec_Hrs		; Calcula (PosDec_Hrs - W) = (h'04' - W)
	    btfsc   STATUS,Z		
	    goto    ScanKeys		; Si Z=1 ignora la tecla
	    
	    movf    posicion,0		; Copia la variable de de_Hrs a W
	    sublw   PosUni_Hrs		; Calcula (PosUni_Hrs - W) = (h'05' - W)
	    btfss   STATUS,Z	;	
	    return			; Si Z=0 es valido

	    movf    de_Hrs,0		; Carga el valor de de_Hrs
	    sublw   dos			; Revisa si es '2'
	    btfss   STATUS,Z	;	
	    return			; Si Z=0 es valido
	    goto    ScanKeys		; Si Z=1 ignora tecla
	    
CompTecl6  movf    valor,0		; Copia la variable de valor a W
	    sublw   seis		; Calcula ('6' - W) = (h'36' - W)
	    btfss   STATUS,Z		; Si Z=1 revisa restricciones de '6'
	    goto    CompTecl7		; Si Z=0 pregunta si es un '7'
	    
	    movf    posicion,0		; Copia la variable de posicion a W
	    sublw   PosDec_Hrs		; Calcula (PosDec_Hrs - W) = (h'04' - W)
	    btfsc   STATUS,Z	;	
	    goto    ScanKeys		; Si Z=1 ignora la tecla
					; Si Z=0 pregunta por PosUni_Hrs
	    movf    posicion,0	;	
	    sublw   PosUni_Hrs		; Calcula (PosUni_Hrs - W) = (h'05' - W)
	    btfss   STATUS,Z	;	
	    goto    NextComp1;
	    
	    movf    de_Hrs,0		; Carga el valor de de_Hrs
	    sublw   dos			; Revisa si es '2'
	    btfss   STATUS,Z;		
	    return			; Si Z=0 es valido
	    goto    ScanKeys		; Si Z=1 ignora tecla
	    
NextComp1  movf    posicion,0		; Copia la variable de de_Hrs a W
	    sublw   PosDec_Min		; Calcula (PosDec_Min - W) = (h'07' - W)
	    btfsc   STATUS,Z;
	    goto    ScanKeys;
	    
	    movf    posicion,0		; Copia la variable de de_Hrs a W
	    sublw   PosDecSeg		; Calcula (PosDecSeg - W) = (h'0A' - W)
	    btfss   STATUS,Z;
	    return			; Si Z=0 es valido
	    goto    ScanKeys		; Si Z=1 ignora tecla
	    
CompTecl7  movf    valor,0		; Copia la variable de valor a W
	    sublw   siete		; Calcula ('7' - W) = (h'37' - W)
	    btfss   STATUS,Z		; Si Z=1 revisa restricciones de '7'
	    goto    CompTecl8		; Si Z=0 pregunta si es un '8'
	    
	    movf    posicion,0		; Copia la variable de posicion a W
	    sublw   PosDec_Hrs		; Calcula (PosDec_Hrs - W) = (h'04' - W)
	    btfsc   STATUS,Z;		
	    goto    ScanKeys		; Si Z=1 ignora la tecla
					; Si Z=0 pregunta por PosUni_Hrs
	    movf    posicion,0		;
	    sublw   PosUni_Hrs		; Calcula (PosUni_Hrs - W) = (h'05' - W)
	    btfss   STATUS,Z		;
	    goto    NextComp2;
	    
	    movf    de_Hrs,0		; Carga el valor de de_Hrs
	    sublw   dos			; Revisa si es '2'
	    btfss   STATUS,Z;		
	    return			; Si Z=0 es valido
	    goto    ScanKeys		; Si Z=1 ignora tecla
	    
NextComp2  movf    posicion,0		; Copia la variable de de_Hrs a W
	    sublw   PosDec_Min		; Calcula (PosDec_Min - W) = (h'07' - W)
	    btfsc   STATUS,Z;
	    goto    ScanKeys;
	    
	    movf    posicion,0		; Copia la variable de de_Hrs a W
	    sublw   PosDecSeg		; Calcula (PosDec_Min - W) = (h'07' - W)
	    btfss   STATUS,Z;
	    return			; Si Z=0 es valido
	    goto    ScanKeys		; Si Z=1 ignora tecla	    
	    
CompTecl8  movf    valor,0		; Copia la variable de valor a W
	    sublw   ocho		; Calcula ('8' - W) = (h'38' - W)
	    btfss   STATUS,Z		; Si Z=1 revisa restricciones de '8'
	    goto    CompTecl9		; Si Z=0 pregunta si es un '9'
	    
	    movf    posicion,0		; Copia la variable de posicion a W
	    sublw   PosDec_Hrs		; Calcula (PosDec_Hrs - W) = (h'04' - W)
	    btfsc   STATUS,Z;		
	    goto    ScanKeys		; Si Z=1 ignora la tecla
					; Si Z=0 pregunta por PosUni_Hrs
	    movf    posicion,0	;	
	    sublw   PosUni_Hrs		; Calcula (PosUni_Hrs - W) = (h'05' - W)
	    btfss   STATUS,Z	;	
	    goto    NextComp3;
	    
	    movf    de_Hrs,0		; Carga el valor de de_Hrs
	    sublw   dos			; Revisa si es '2'
	    btfss   STATUS,Z;		
	    return			; Si Z=0 es valido
	    goto    ScanKeys		; Si Z=1 ignora tecla
	    
NextComp3  movf    posicion,0		; Copia la variable de de_Hrs a W
	    sublw   PosDec_Min		; Calcula (PosDec_Min - W) = (h'07' - W)
	    btfsc   STATUS,Z;
	    goto    ScanKeys;
	    
	    movf    posicion,0		; Copia la variable de de_Hrs a W
	    sublw   PosDecSeg		; Calcula (PosDec_Min - W) = (h'07' - W)
	    btfss   STATUS,Z;
	    return		;	; Si Z=0 es valido
	    goto    ScanKeys		; Si Z=1 ignora tecla	    

CompTecl9  movf    valor,0		; Copia la variable de valor a W
	    sublw   nueve		; Calcula ('9' - W) = (h'39' - W)
	    btfss   STATUS,Z		; Si Z=1 revisa restricciones de '9'
	    goto    ScanKeys		; Si Z=0 sigue escaneando
	    
	    movf    posicion,0		; Copia la variable de posicion a W
	    sublw   PosDec_Hrs		; Calcula (PosDec_Hrs - W) = (h'04' - W)
	    btfsc   STATUS,Z	;	
	    goto    ScanKeys		; Si Z=1 ignora la tecla
					; Si Z=0 pregunta por PosUni_Hrs
	    movf    posicion,0	;	
	    sublw   PosUni_Hrs		; Calcula (PosUni_Hrs - W) = (h'05' - W)
	    btfss   STATUS,Z	;	
	    goto    NextComp4;
	    
	    movf    de_Hrs,0		; Carga el valor de de_Hrs
	    sublw   dos			; Revisa si es '2'
	    btfss   STATUS,Z;		
	    return			; Si Z=0 es valido
	    goto    ScanKeys		; Si Z=1 ignora tecla
	    
NextComp4  movf    posicion,0		; Copia la variable de de_Hrs a W
	    sublw   PosDec_Min		; Calcula (PosDec_Min - W) = (h'07' - W)
	    btfsc   STATUS,Z;
	    goto    ScanKeys;
	    
	    movf    posicion,0		; Copia la variable de de_Hrs a W
	    sublw   PosDecSeg		; Calcula (PosDec_Min - W) = (h'07' - W)
	    btfss   STATUS,Z;
	    return			; Si Z=0 es valido
	    goto    ScanKeys		; Si Z=1 ignora tecla	    

	    return;
	    
    END





