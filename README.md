# Bare_Metal_Embedded

In this project:
I wrote a startup file for STM32F407VGT6 Microcontroller. I use 'C' to wrote this file and I use some GCC attributes.
startup file includes vector table, reset handler and a default handler for other exceptions with weak and alias attributes.
I wrote a Linler Script file.
I wrote a make file for compilation, cleaning, linking and downloading the project.
And we use the semi hosting feature also.

The project compiled with ARM GCC Toolchain and downloaded to target with using OpenOCD and GDB Client. Also Telnet Client was used too.
Stanadrt 'C' library added to the project.(libc_nano)
And rdimon library used when using semihosting feature.
