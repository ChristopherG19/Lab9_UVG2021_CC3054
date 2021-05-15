/*
 * Universidad de Valle de Guatemala
 * Organizacion de Computadoras y Assembler - Seccion 10
 * Christopher Garcia - 20541
 *
 * Laboratorio#9
*/

/*Apartado de data donde se define todo lo que se utilizara*/
.data
.align 2

Titulo1: .asciz "----Bienvenido(a) a esta calculadora----\n"
Cte1: .asciz "Ingrese una opcion:\n"
ErrorIngreso: .asciz "Lo sentimos, error de comando ingresado\n"
Info: .asciz "\nSuma de: Dato ingresado + dato almacenado"
Info2: .asciz "\nMultiplicacion de: Dato ingresado * dato almacenado"
Info3: .asciz "\nModulo (Residuo de una division)"
Info4: .asciz "\nPotencia de: Dato ingresado_1 (Base) y Dato ingresado_2 (Potencia)"
Info5: .asciz "\nValor de resultado almacenado"
Fin: .asciz "Gracias por utilizar esta calculadora, saliendo del programa...3...2...1...\n"
Salto: .asciz "\n"
Ingreso: .asciz "           "

/*Inicio del main*/
.text
.global main
.func main

main:
    stmfd sp!,{lr} /* SP = R13 link register */

    /*Se imprime el menu con una subrutina*/
    bl printMenu

    /*Loop que repite la presentación de la solicitud de información*/
    LoopCalcu:
        /*Se imprime el mensaje donde se solicita información*/
        ldr r1,=Cte1
        bl _print

        /*Se lee la entrada de teclado con ayuda de la subrutina provista en Canvas*/
        ldr r0,=Ingreso
        bl _keybread

        /*Se lee el primer byte y se almacena*/
        ldr r3,=Ingreso
        ldrb r3,[r3]

        /*Inicio de comparaciones con el byte almacenado*/
        cmp r3,#'+'
        beq Suma
        cmp r3,#'*'
        beq Mult
        cmp r3,#'M'
        beq Mod
        cmp r3,#'P'
        beq Pot
        cmp r3, #'='
        beq Resultante
        cmp r3,#'1'
        beq PriCar
        cmp r3,#'2'
        beq SegCar
        cmp r3,#'C'
        beq Conca
        cmp r3, #'q'
        beq SalidaF

        /*Se utiliza como programacion defensiva ante errores de ingreso*/
        cmpeq r3,#0
        beq ErrorComandos

    /*Si en dado caso se ingresa un dato erroneo se muestra un mensaje de error*/
    ErrorComandos:
        ldr r1,=ErrorIngreso
        bl _print
        b LoopCalcu

    /*Proceso de suma si el usuario la solicita*/
    Suma:
        /*Mensaje informativo */
        ldr r0,=Info
        bl puts
        
        /*Se llama a la subrutina que realiza la suma*/
        bl Sumatoria

        /*Salto de linea para mejorar la estética*/
        ldr r0,=Salto
        bl puts

        /*Se llama al loop del inicio para continuar utilizando la calculadora*/
        b LoopCalcu

    /*Proceso de multiplicación si el usuario la solicita*/
    Mult:
        /*Mensaje informativo */
        ldr r0,=Info2
        bl puts

        /*Se llama a la subrutina que realiza la Multiplicación*/
        bl MultiplicacionOpe

        /*Salto de linea para mejorar la estética*/
        ldr r0,=Salto
        bl puts

        /*Se llama al loop del inicio para continuar utilizando la calculadora*/
        b LoopCalcu

    /*Proceso de módulo si el usuario la solicita*/
    Mod:
        /*Mensaje informativo */
        ldr r0,=Info3
        bl puts

        /*Se llama a la subrutina que realiza Modulo*/
        bl ModuloOpe

        /*Salto de linea para mejorar la estética*/
        ldr r0,=Salto
        bl puts

        /*Se llama al loop del inicio para continuar utilizando la calculadora*/
        b LoopCalcu

    /*Proceso de Potencia si el usuario la solicita*/
    Pot:
        /*Mensaje informativo */
        ldr r0,=Info4
        bl puts

        /*Se llama a la subrutina que realiza la Potencia de dos numeros (Base y potencia)*/
        bl pote

        /*Salto de linea para mejorar la estética*/
        ldr r0,=Salto
        bl puts

        /*Se llama al loop del inicio para continuar utilizando la calculadora*/
        b LoopCalcu

    /*Proceso de Resultante si el usuario la solicita*/
    Resultante:
        /*Mensaje informativo */
        ldr r0,=Info5
        bl puts

        /*Se llama a la subrutina que realiza la presentacion del resultado almacenado*/
        bl Igual

        /*Salto de linea para mejorar la estética*/
        ldr r0,=Salto
        bl puts

        /*Se llama al loop del inicio para continuar utilizando la calculadora*/
        b LoopCalcu

    PriCar:
        /*Se llama a la subrutina que realiza la lectura de la primera cadena*/
        bl Lectura        

        /*Salto de linea para mejorar la estética*/
        ldr r0,=Salto
        bl puts

        /*Se llama al loop del inicio para continuar utilizando la calculadora*/
        b LoopCalcu

    SegCar:
        /*Se llama a la subrutina que realiza la lectura de la segunda cadena*/
        bl Lectura2
    
        /*Salto de linea para mejorar la estética*/
        ldr r0,=Salto
        bl puts

        /*Se llama al loop del inicio para continuar utilizando la calculadora*/
        b LoopCalcu

    Conca:
        /*Se llama a la subrutina que realiza la concatenación de ambas cadenas*/
        //bl Veri

        /*Salto de linea para mejorar la estética*/
        ldr r0,=Salto
        bl puts

        /*Se llama al loop del inicio para continuar utilizando la calculadora*/
        b LoopCalcu

    SalidaF:

        /*Impresión de mensaje de despedida*/
        ldr r0,=Fin
        bl puts

        /*Finalizamos el programa con SWI */
        mov r7,#1
        swi 0

    /*Salida correcta del programa con SWI, finalización completa del programa*/
	mov r7,#1
    swi 0
