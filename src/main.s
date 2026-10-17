.global _start

.data
prompt:     .asciz "minishell> "
prompt_len = . - prompt

help_msg:   .asciz "Comandos disponibles: exit, help, clear\n"
help_len = . - help_msg

clear_screen: .asciz "\033[H\033[J"
clear_len = . - clear_screen

.bss
.lcomm input_buffer, 256

.text
_start:
main_loop:
    // 1. Imprimir el prompt
    mov x0, #1
    ldr x1, =prompt
    mov x2, prompt_len
    mov x8, #64
    svc #0

    // 2. Leer la entrada del usuario
    mov x0, #0
    ldr x1, =input_buffer
    mov x2, #256
    mov x8, #63
    svc #0

    cmp x0, #0
    b.le exit_shell

    // Si el usuario solo presionó Enter, repetir prompt
    ldr x1, =input_buffer
    ldrb w2, [x1, #0]
    mov w3, #10
    cmp w2, w3
    b.eq main_loop

    // 3. Validar comando "exit"
    ldr x1, =input_buffer
    ldrb w2, [x1, #0]
    mov w3, #'e'
    cmp w2, w3
    b.ne check_help

    ldrb w2, [x1, #1]
    mov w3, #'x'
    cmp w2, w3
    b.ne check_help

    ldrb w2, [x1, #2]
    mov w3, #'i'
    cmp w2, w3
    b.ne check_help

    ldrb w2, [x1, #3]
    mov w3, #'t'
    cmp w2, w3
    b.ne check_help

    ldrb w2, [x1, #4]
    mov w3, #10
    cmp w2, w3
    b.ne check_help

    b exit_shell

check_help:
    // 4. Validar comando "help"
    ldr x1, =input_buffer
    ldrb w2, [x1, #0]
    mov w3, #'h'
    cmp w2, w3
    b.ne check_clear

    ldrb w2, [x1, #1]
    mov w3, #'e'
    cmp w2, w3
    b.ne check_clear

    ldrb w2, [x1, #2]
    mov w3, #'l'
    cmp w2, w3
    b.ne check_clear

    ldrb w2, [x1, #3]
    mov w3, #'p'
    cmp w2, w3
    b.ne check_clear

    ldrb w2, [x1, #4]
    mov w3, #10
    cmp w2, w3
    b.ne check_clear

    // Imprimir mensaje de ayuda
    mov x0, #1
    ldr x1, =help_msg
    mov x2, help_len
    mov x8, #64
    svc #0
    b main_loop

check_clear:
    // 5. Validar comando "clear"

    ldr x1, =input_buffer
    ldrb w2, [x1, #0]
    mov w3, #'c'
    cmp w2, w3
    b.ne unknown_cmd

    ldrb w2, [x1, #1]
    mov w3, #'l'
    cmp w2, w3
    b.ne unknown_cmd

    ldrb w2, [x1, #2]
    mov w3, #'e'
    cmp w2, w3
    b.ne unknown_cmd

    ldrb w2, [x1, #3]
    mov w3, #'a'
    cmp w2, w3
    b.ne unknown_cmd

    ldrb w2, [x1, #4]
    mov w3, #'r'
    cmp w2, w3
    b.ne unknown_cmd

    ldrb w2, [x1, #5]
    mov w3, #10
    cmp w2, w3
    b.ne unknown_cmd

    // Limpiar pantalla con ANSI y redibujar prompt
    mov x0, #1
    ldr x1, =clear_screen
    mov x2, clear_len
    mov x8, #64
    svc #0
    b main_loop

unknown_cmd:
    // Si no coincide con ninguno, vuelve a pedir el prompt
    b main_loop

exit_shell:
    mov x0, #0
    mov x8, #93
    svc #0
