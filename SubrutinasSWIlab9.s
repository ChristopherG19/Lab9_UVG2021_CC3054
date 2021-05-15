/*
 * Universidad de Valle de Guatemala
 * Organizacion de Computadoras y Assembler - Seccion 10
 * Christopher Garcia - 20541
 * Laboratorio#9
*/
.text
.align 2

/*----------------Inicio de subrutinas---------------*/

//Subrutina encargada de imprimir el menú
//Esta subrutina llamaba a la subrutina _print provista por el catedrático
//Y se imprimía el valor deseado que en este caso fueron las opciones del menú
.global printMenu
printMenu:
    PUSH {LR}

    //Mensaje inicial (Título)
    ldr r0,=Salto
    bl puts
    ldr r1,=Titulo1
    bl _print
    ldr r0,=Salto
    bl puts

    //Mensaje
    ldr r1,=Seleccion
    bl _print
    //Mensaje Suma
    ldr r1,=SSuma
    bl _print
    //Mensaje Multiplicación
    ldr r1,=SMul
    bl _print
    //Mensaje Módulo
    ldr r1,=SMod
    bl _print
    //Mensaje Valor almacenado
    ldr r1,=SEqu
    bl _print
    //Mensaje Potencia
    ldr r1,=SPot
    bl _print
    //Mensaje Cadena 1
    ldr r1,=SCad1
    bl _print
    //Mensaje Cadena 2
    ldr r1,=SCad2
    bl _print
    //Mensaje Concatenar cadenas
    ldr r1,=SCon
    bl _print
    //Mensaje Salida instruccion
    ldr r1,=SSal
    bl _print

    //Salto de linea para mejorar la estética
    ldr r0,=Salto
    bl puts
    
    //Salida de la subrutina con SWI
    SWI 0
    POP {LR}
    BX LR 

//Subrutina _print obtenida de canvas, su función es imprimir un valor a pantalla con SWI
.global _print
_print:
  PUSH {LR}     @ copy of LR because I will call _strlen here
  LDR R8,=strLen4print
  BL _strlen
  LDR R2,[R8]
  MOV R7, #4		@4=llamado a "write" swi
  MOV R0, #1		@1=stdout (monitor)
  SWI 0
  POP {LR}
  BX LR /*-- _print --*/

//Subrutina _strlen obtenida de canvas, utilizada para poder conocer el largo de una cadena
.global _strlen
_strlen:
  MOV R0,R1
  length .req R5
  MOV length,#0
countchars:
  LDRB R4,[R0],#1
  CMP R4,#'\n'      @CR to check end of line
  BEQ endOfLine
  ADD length,#1
  B countchars
endOfLine:
  ADD length,#1
  STR length,[R8]
  .unreq length
  SWI 0
  BX LR /*-- _strlen --*/

//Subrutina _keybread obtenida de canvas, encargada de leer entrada de teclado con SWI
.global _keybread
_keybread:
@ Lee el caracter
  MOV R1,R0     @copia el parametro del puntero a la cadena
  MOV R7, #3		@3=llamado a "read" swi
  MOV R0, #0		@0=stdin (teclado)
  MOV R2, #20		@longitud de la cadena: 20 caracteres + enter
  SWI 0
  BX LR

//Subrutina _char2Num obtenida de canvas, encargada de convertir .asciz a .word
.global _char2Num
_char2Num:
  charPointer .req R0
  valPointer .req R1
  LDRB R0,[charPointer]
  CMP R0,#0x30      @ Is the hex ascii value between 0
  CMPGE R0,#0x39    @ or 9
  SUBLE R0,#0x30    @ subtract 0x30 only if it's a digit
  STRLE R0,[valPointer] @ store value only if it's a digit
  MOVLE R11,#1 //Registro sin utilizar que se modifica para comprobar que el 
              //dato ingresado es un dígito, esto como parte de la programación defensiva 
              //(Modificación hecha a diferencia de la original)
  .unreq charPointer
  .unreq valPointer
  SWI 0
  BX LR
  
/*---------------OPERACIONES-------------------*/

//SUMA
.global Sumatoria
Sumatoria:
  PUSH {LR}
  /*Se lee el dato ingresado por el usuario, este es verificado como parte de la programación defensiva*/
  Verificacion:
    mov r11,#0
    ldr r0,=Ingreso
    bl _keybread

    /*Con ayuda de la subrutina provista en Canvas se convierte de .asciz a .word*/
    ldr r0,=Ingreso
    ldr r1,=Resultado
    bl _char2Num
    cmp r11,#0
    ldreq r0,=ErrorDato
    bleq puts
    beq Verificacion
  
  /*Se realiza la suma y se almacena el valor*/
  ldr r0,=Ingreso
  ldr r1,=Resultado
  ldr r0,[r1]
  add r0,r9
  mov r9,r0 
  str r0,[r1]

  /*Se imprime el resultado con un formato especifico */
  ldr r2,=Resultado
  mov r2,r1
  ldr r1,[r1]
  ldr r0,=Impresion
  bl printf

  //Salida de la subrutina con SWI
  SWI 0
  POP {LR}
  BX LR

//MULTIPLICACIÓN
.global MultiplicacionOpe
MultiplicacionOpe:
  PUSH {LR}
  /*Se lee el dato ingresado por el usuario, este es verificado como parte de la programación defensiva*/
  Verificacion2:
    mov r11,#0
    /*Se lee el dato ingresado por el usuario*/
    ldr r0,=Ingreso2
    bl _keybread

    /*Con ayuda de la subrutina provista en Canvas se convierte de .asciz a .word*/
    ldr r0,=Ingreso
    ldr r1,=Resultado
    bl _char2Num
    cmp r11,#0
    ldreq r0,=ErrorDato
    bleq puts
    beq Verificacion2

  ldr r1,=Resultado
  ldr r0,[r1]
  mul r0,r9,r0
  mov r9,r0
  str r0,[r1]

  ldr r1,=Resultado
  ldr r1,[r1]
  ldr r0,=Impresion
  bl printf
  
  //Salida de la subrutina con SWI
  SWI 0
  POP {LR}
  BX LR

//MODULO
.global ModuloOpe
ModuloOpe:
  PUSH {LR}
  /*Se lee el dato ingresado por el usuario, este es verificado como parte de la programación defensiva*/
  Verificacion3:
    mov r11,#0
    /*Se lee el dato ingresado por el usuario*/
    ldr r0, =IngresoMod
    bl _keybread 

    /*Con ayuda de la subrutina provista en Canvas se convierte de .asciz a .word*/
    ldr r0, =IngresoMod
    ldr r1,=Resultado
    bl _char2Num
    cmp r11,#0
    ldreq r0,=ErrorDato
    bleq puts
    beq Verificacion3

  /*Se obtiene y guarda el valor del .word*/
  ldr r1,=Resultado
  ldr r0,[r1]

  //Contador para saber cuando detener el loop posterior
  mov r6,#0

  loopRestaDiv: //Loop obtenido de ejemplo sobre divisiones provisto para un laboratorio/ejercicio anterior
    subs r9,r0
    add r6,#1
    cmp r9,r0
    bge loopRestaDiv
    
  /*Se obtiene y guarda el valor del resultado*/
  str r9,[r1]
    
  //Impresión del resultado
  ldr r1,=Resultado
  ldr r1,[r1]
  ldr r0,=Impresion
  bl printf

  //Salida de la subrutina con SWI
  SWI 0
  POP {LR}
  BX LR

//POTENCIAS
.global pote
pote:
  PUSH {LR}
  /*Se lee el dato ingresado por el usuario, este es verificado como parte de la programación defensiva*/
  Verificacion4:
    mov r11,#0
    ldr r0,=Tit1
    bl puts

    ldr r0,=Ingreso3
    bl _keybread

    /*Con ayuda de la subrutina provista en Canvas se convierte de .asciz a .word*/
    ldr r0,=Ingreso3
    ldr r1,=Num1
    bl _char2Num
    cmp r11,#0
    ldreq r0,=ErrorDato
    bleq puts
    beq Verificacion4

  //Impresión de título informativo
  ldr r0,=Tit2
  bl puts
  /*Se lee el dato ingresado por el usuario, este es verificado como parte de la programación defensiva*/
  Verificacion5:
    mov r11,#0 
    ldr r0,=Ingreso4
    bl _keybread

    /*Con ayuda de la subrutina provista en Canvas se convierte de .asciz a .word*/
    ldr r0,=Ingreso4
    ldr r1,=Num2
    bl _char2Num
    cmp r11,#0
    ldreq r0,=ErrorDato
    bleq puts
    beq Verificacion5
  
  /*Se obtienen ambos valores*/
  ldr r0,=Num1 //Base
  ldr r1,[r0]
  ldr r0,=Num2 //Potencia
  ldr r2,[r0]
  ldr r3,=ResultadoP //Almacen del resultado
  
  //Se realiza un loop para multiplicar la base por sí misma las veces necesarias
  mov r9,r1
  mov r1,#1
  mov r10,#1

  loopPo:
    cmp r10,r2
    addle r10,#1
    mulle r1,r9,r1
    ble loopPo

  //Se obtiene y almacena el resultado
  str r1,[r3]

  //Se imprime el resultado
	ldr r0,=Impresion
	bl printf

  //Salida de la subrutina con SWI
  SWI 0
  POP {LR}
  BX LR

//MUESTRA EL RESULTADO ALMACENADO
.global Igual
Igual:
  PUSH {LR}
  ldr r1,=Resultado
  ldr r1,[r1]
  ldr r0,=Impresion
  bl printf
  
  //Salida de la subrutina con SWI
  SWI 0
  POP {LR}
  BX LR

//LECTURAS PARA CONCATENACION

//Subrutina Lectura (Modificación de archivo en canvas), lee la primer cadena del usuario
.global Lectura
Lectura:
  PUSH {LR}
  ldr r0,=Inform1
  bl puts

@ Lee el caracter
  MOV R7, #3		@3=llamado a "read" swi
  MOV R0, #0		@0=stdin (teclado)
  MOV R2, #50		@longitud de la cadena: 10 caracteres + enter
  LDR R1, =string	@apunta a la variable donde se guarda
  SWI 0

@ Muestra la cadena leida
  MOV R7, #4		@4=llamado a "write" swi
  MOV R0, #1		@1=stdout (monitor)
  MOV R2, #50 	@longitud de la cadena: 10 caracteres + enter
  LDR R1, =string	@apunta a la cadena
  SWI 0

  SWI 0
  POP {LR}
  BX LR

//Subrutina Lectura (Modificación de archivo en canvas), lee la primer cadena del usuario
.global Lectura2
Lectura2:
  PUSH {LR}
  ldr r0,=Inform2
  bl puts

@ Lee el caracter
  MOV R7, #3		@3=llamado a "read" swi
  MOV R0, #0		@0=stdin (teclado)
  MOV R2, #50		@longitud de la cadena: 10 caracteres + enter
  LDR R1, =string2	@apunta a la variable donde se guarda
  SWI 0

@ Muestra la cadena leida
  MOV R7, #4		@4=llamado a "write" swi
  MOV R0, #1		@1=stdout (monitor)
  MOV R2, #50 	@longitud de la cadena: 10 caracteres + enter
  LDR R1, =string2	@apunta a la cadena
  SWI 0

  SWI 0
  POP {LR}
  BX LR

//Se concatenan ambas cadenas
.global Concate     //Se realiza una modificación a la subrutina _strlen para poder lograr esto
Concate:
  PUSH {LR}
  ldr r0,=string
  length .req R5
  MOV length,#0
  countchars2:
    LDRB R4,[R0],#1
    CMP R4,#'\n'      @CR to check end of line
    BEQ endOfLine
    ADD length,#1
    B countchars
  endOfLine2:
    ADD length,#1
    STR length,[R6]
  .unreq length

  //Se cargan las cadenas y un lugar donde guardar la concatenación
  ldr r6,[r6]
  sub r6,#1
  ldr r7,=string
  ldr r8,=string2
  ldr r9,=string3

  //Se verifica el largo de la cadena
  loopVerilength:
    ldrb r3, [r7], #1
    strb r3, [r9], #1
    subs r12,#1
    bne loopVerilength

  //Se utiliza para comprobar que las cadenas se han podido concatenar
  loopVeriEspacios:
    ldrb r3, [r8], #1
    strb r3, [r9], #1
    cmp r3,#0
    bne loopVeriEspacios
  
  //Se imprime el resultado
  ldr r1,=string3
  bl _print

  /*Salto de linea para mejorar la estética*/
  ldr r0,=Salto
  bl puts

  //Salida de la subrutina con SWI
  SWI 0
  POP {LR}
  BX LR

/*--------------------------------DATOS UTILIZADOS--------------------------------*/
.data
.align 2
Impresion: .asciz ">> %d"
Titulo1: .asciz "|----Bienvenido(a) a esta calculadora----|\n"
Seleccion: .asciz "Seleccione opcion a realizar:\n"
SSuma: .asciz "(+)-----> Suma\n"
SMul: .asciz "(*)-----> Multiplicacion\n"
SMod: .asciz "(M)-----> Modulo\n"
SPot: .asciz "(P)-----> Potencia de un numero\n"
SEqu: .asciz "(=)-----> Muestra el resultado almacenado\n"
SCad1: .asciz "(1)-----> Ingresar primera cadena de caracteres\n"
SCad2: .asciz "(2)-----> Ingresar segunda cadena de caracteres\n"
SCon: .asciz "(C)-----> Concatenar cadenas de caracteres 1 y 2\n"
SSal: .asciz "(q)-----> Mostrar mensaje de despedida y salir al sistema operativo\n"
Inform1: .asciz "Ingresa tu primer cadena"
Inform2: .asciz "Ingresa tu segunda cadena"
Tit1: .asciz "Ingresa la base"
Tit2: .asciz "Ingresa la potencia"
ErrorDato: .asciz "Error, el dato ingresado no es un numero"
Error1In: .asciz "Error, falta la primera cadena\n"
Error2In: .asciz "Error, falta la segunda cadena\n"
Error3In: .asciz "Error, faltan una de las cadenas\n"
ContiMSJ: .asciz "Todo correcto, continuaremos"
Salto: .asciz "\n"
enter: 	.asciz "\n"
Resultado: .word 0
ResultadoP: .word 0
Num1: .word 0
Num2: .word 0
Num3: .word 0
Cont1: .word 2
strLen4print: .word 0
string: .asciz "                   "
string2: .asciz "                   "
string3: .asciz "                   "
Ingreso: .asciz "           "
Ingreso2: .asciz "           "
Ingreso3: .asciz "           "
Ingreso4: .asciz "           "
IngresoMod: .asciz "           "
