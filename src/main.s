.global _start

.text
_start:
    mov x0, #0          // Código de salida 0 (éxito)
    mov x8, #93         // Número de syscall para exit en ARM64
    svc #0              // Llamada al sistema operativo

