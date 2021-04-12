	.cpu cortex-m4
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"main.c"
	.text
	.global	current_task
	.data
	.type	current_task, %object
	.size	current_task, 1
current_task:
	.byte	1
	.global	global_tick_count
	.bss
	.align	2
	.type	global_tick_count, %object
	.size	global_tick_count, 4
global_tick_count:
	.space	4
	.global	user_tasks
	.align	2
	.type	user_tasks, %object
	.size	user_tasks, 80
user_tasks:
	.space	80
	.text
	.align	1
	.global	init_systick_timer
	.arch armv7e-m
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	init_systick_timer, %function
init_systick_timer:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #28
	add	r7, sp, #0
	str	r0, [r7, #4]
	ldr	r2, .L2
	ldr	r3, [r7, #4]
	udiv	r3, r2, r3
	subs	r3, r3, #1
	str	r3, [r7, #20]
	ldr	r3, .L2+4
	str	r3, [r7, #16]
	ldr	r3, [r7, #16]
	ldr	r3, [r3]
	and	r2, r3, #-16777216
	ldr	r3, [r7, #16]
	str	r2, [r3]
	ldr	r3, [r7, #16]
	ldr	r2, [r3]
	ldr	r3, [r7, #20]
	orrs	r2, r2, r3
	ldr	r3, [r7, #16]
	str	r2, [r3]
	ldr	r3, .L2+8
	str	r3, [r7, #12]
	ldr	r3, [r7, #12]
	ldr	r3, [r3]
	orr	r2, r3, #4
	ldr	r3, [r7, #12]
	str	r2, [r3]
	ldr	r3, [r7, #12]
	ldr	r3, [r3]
	orr	r2, r3, #2
	ldr	r3, [r7, #12]
	str	r2, [r3]
	ldr	r3, [r7, #12]
	ldr	r3, [r3]
	orr	r2, r3, #1
	ldr	r3, [r7, #12]
	str	r2, [r3]
	nop
	adds	r7, r7, #28
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L3:
	.align	2
.L2:
	.word	16000000
	.word	-536813548
	.word	-536813552
	.size	init_systick_timer, .-init_systick_timer
	.align	1
	.global	main
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
	bl	enable_processor_faults
	bl	init_user_leds
	ldr	r0, .L6
	bl	init_scheduler_task_stack
	bl	init_user_tasks_stack
	mov	r0, #1000
	bl	init_systick_timer
	bl	switch_sp_to_psp
	bl	task1_handler
.L5:
	b	.L5
.L7:
	.align	2
.L6:
	.word	536996864
	.size	main, .-main
	.align	1
	.global	enable_processor_faults
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	enable_processor_faults, %function
enable_processor_faults:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #12
	add	r7, sp, #0
	ldr	r3, .L9
	str	r3, [r7, #4]
	ldr	r3, [r7, #4]
	mov	r2, #262144
	str	r2, [r3]
	ldr	r3, [r7, #4]
	mov	r2, #131072
	str	r2, [r3]
	ldr	r3, [r7, #4]
	mov	r2, #65536
	str	r2, [r3]
	nop
	adds	r7, r7, #12
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L10:
	.align	2
.L9:
	.word	-536810204
	.size	enable_processor_faults, .-enable_processor_faults
	.align	1
	.global	idle_handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	idle_handler, %function
idle_handler:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	add	r7, sp, #0
.L12:
	b	.L12
	.size	idle_handler, .-idle_handler
	.align	1
	.global	task1_handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	task1_handler, %function
task1_handler:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
.L14:
	movs	r0, #12
	bl	led_on
	mov	r0, #1000
	bl	task_delay
	movs	r0, #12
	bl	led_off
	mov	r0, #1000
	bl	task_delay
	b	.L14
	.size	task1_handler, .-task1_handler
	.align	1
	.global	task2_handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	task2_handler, %function
task2_handler:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
.L16:
	movs	r0, #13
	bl	led_on
	mov	r0, #500
	bl	task_delay
	movs	r0, #13
	bl	led_off
	mov	r0, #500
	bl	task_delay
	b	.L16
	.size	task2_handler, .-task2_handler
	.align	1
	.global	task3_handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	task3_handler, %function
task3_handler:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
.L18:
	movs	r0, #14
	bl	led_on
	movs	r0, #250
	bl	task_delay
	movs	r0, #14
	bl	led_off
	movs	r0, #250
	bl	task_delay
	b	.L18
	.size	task3_handler, .-task3_handler
	.align	1
	.global	task4_handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	task4_handler, %function
task4_handler:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
.L20:
	movs	r0, #15
	bl	led_on
	movs	r0, #125
	bl	task_delay
	movs	r0, #15
	bl	led_off
	movs	r0, #125
	bl	task_delay
	b	.L20
	.size	task4_handler, .-task4_handler
	.align	1
	.global	init_scheduler_task_stack
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	init_scheduler_task_stack, %function
init_scheduler_task_stack:
	@ Naked Function: prologue and epilogue provided by programmer.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	mov	r3, r0
	.syntax unified
@ 101 "main.c" 1
	MSR MSP,r3
@ 0 "" 2
@ 102 "main.c" 1
	BX LR
@ 0 "" 2
	.thumb
	.syntax unified
	nop
	.size	init_scheduler_task_stack, .-init_scheduler_task_stack
	.align	1
	.global	init_user_tasks_stack
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	init_user_tasks_stack, %function
init_user_tasks_stack:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #20
	add	r7, sp, #0
	ldr	r3, .L27
	movs	r2, #0
	strb	r2, [r3, #8]
	ldr	r3, .L27
	movs	r2, #0
	strb	r2, [r3, #24]
	ldr	r3, .L27
	movs	r2, #0
	strb	r2, [r3, #40]
	ldr	r3, .L27
	movs	r2, #0
	strb	r2, [r3, #56]
	ldr	r3, .L27
	movs	r2, #0
	strb	r2, [r3, #72]
	ldr	r3, .L27
	ldr	r2, .L27+4
	str	r2, [r3, #12]
	ldr	r3, .L27
	ldr	r2, .L27+8
	str	r2, [r3, #28]
	ldr	r3, .L27
	ldr	r2, .L27+12
	str	r2, [r3, #44]
	ldr	r3, .L27
	ldr	r2, .L27+16
	str	r2, [r3, #60]
	ldr	r3, .L27
	ldr	r2, .L27+20
	str	r2, [r3, #76]
	ldr	r3, .L27
	ldr	r2, .L27+24
	str	r2, [r3]
	ldr	r3, .L27
	ldr	r2, .L27+28
	str	r2, [r3, #16]
	ldr	r3, .L27
	ldr	r2, .L27+32
	str	r2, [r3, #32]
	ldr	r3, .L27
	ldr	r2, .L27+36
	str	r2, [r3, #48]
	ldr	r3, .L27
	ldr	r2, .L27+40
	str	r2, [r3, #64]
	movs	r3, #0
	str	r3, [r7, #8]
	b	.L23
.L26:
	ldr	r2, .L27
	ldr	r3, [r7, #8]
	lsls	r3, r3, #4
	add	r3, r3, r2
	ldr	r3, [r3]
	str	r3, [r7, #12]
	ldr	r3, [r7, #12]
	subs	r3, r3, #4
	str	r3, [r7, #12]
	ldr	r3, [r7, #12]
	mov	r2, #16777216
	str	r2, [r3]
	ldr	r3, [r7, #12]
	subs	r3, r3, #4
	str	r3, [r7, #12]
	ldr	r2, .L27
	ldr	r3, [r7, #8]
	lsls	r3, r3, #4
	add	r3, r3, r2
	adds	r3, r3, #12
	ldr	r3, [r3]
	mov	r2, r3
	ldr	r3, [r7, #12]
	str	r2, [r3]
	ldr	r3, [r7, #12]
	subs	r3, r3, #4
	str	r3, [r7, #12]
	ldr	r3, [r7, #12]
	mvn	r2, #2
	str	r2, [r3]
	movs	r3, #0
	str	r3, [r7, #4]
	b	.L24
.L25:
	ldr	r3, [r7, #12]
	subs	r3, r3, #4
	str	r3, [r7, #12]
	ldr	r3, [r7, #12]
	movs	r2, #0
	str	r2, [r3]
	ldr	r3, [r7, #4]
	adds	r3, r3, #1
	str	r3, [r7, #4]
.L24:
	ldr	r3, [r7, #4]
	cmp	r3, #12
	ble	.L25
	ldr	r2, [r7, #12]
	ldr	r1, .L27
	ldr	r3, [r7, #8]
	lsls	r3, r3, #4
	add	r3, r3, r1
	str	r2, [r3]
	ldr	r3, [r7, #8]
	adds	r3, r3, #1
	str	r3, [r7, #8]
.L23:
	ldr	r3, [r7, #8]
	cmp	r3, #4
	ble	.L26
	nop
	nop
	adds	r7, r7, #20
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L28:
	.align	2
.L27:
	.word	user_tasks
	.word	idle_handler
	.word	task1_handler
	.word	task2_handler
	.word	task3_handler
	.word	task4_handler
	.word	536997888
	.word	537001984
	.word	537000960
	.word	536999936
	.word	536998912
	.size	init_user_tasks_stack, .-init_user_tasks_stack
	.align	1
	.global	get_psp_value
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	get_psp_value, %function
get_psp_value:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	add	r7, sp, #0
	ldr	r3, .L31
	ldrb	r3, [r3]
	uxtb	r3, r3
	ldr	r2, .L31+4
	lsls	r3, r3, #4
	add	r3, r3, r2
	ldr	r3, [r3]
	mov	r0, r3
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L32:
	.align	2
.L31:
	.word	current_task
	.word	user_tasks
	.size	get_psp_value, .-get_psp_value
	.align	1
	.global	save_psp_value
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	save_psp_value, %function
save_psp_value:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #12
	add	r7, sp, #0
	str	r0, [r7, #4]
	ldr	r3, .L34
	ldrb	r3, [r3]
	uxtb	r3, r3
	ldr	r2, .L34+4
	lsls	r3, r3, #4
	add	r3, r3, r2
	ldr	r2, [r7, #4]
	str	r2, [r3]
	nop
	adds	r7, r7, #12
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L35:
	.align	2
.L34:
	.word	current_task
	.word	user_tasks
	.size	save_psp_value, .-save_psp_value
	.align	1
	.global	decide_next_task
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	decide_next_task, %function
decide_next_task:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #12
	add	r7, sp, #0
	movs	r3, #255
	str	r3, [r7, #4]
	movs	r3, #0
	str	r3, [r7]
	b	.L37
.L40:
	ldr	r3, .L44
	ldrb	r3, [r3]
	uxtb	r3, r3
	adds	r3, r3, #1
	uxtb	r2, r3
	ldr	r3, .L44
	strb	r2, [r3]
	ldr	r3, .L44
	ldrb	r3, [r3]
	uxtb	r2, r3
	ldr	r3, .L44+4
	umull	r1, r3, r3, r2
	lsrs	r1, r3, #2
	mov	r3, r1
	lsls	r3, r3, #2
	add	r3, r3, r1
	subs	r3, r2, r3
	uxtb	r2, r3
	ldr	r3, .L44
	strb	r2, [r3]
	ldr	r3, .L44
	ldrb	r3, [r3]
	uxtb	r3, r3
	ldr	r2, .L44+8
	lsls	r3, r3, #4
	add	r3, r3, r2
	adds	r3, r3, #8
	ldrb	r3, [r3]
	uxtb	r3, r3
	str	r3, [r7, #4]
	ldr	r3, [r7, #4]
	cmp	r3, #0
	bne	.L38
	ldr	r3, .L44
	ldrb	r3, [r3]
	uxtb	r3, r3
	cmp	r3, #0
	bne	.L42
.L38:
	ldr	r3, [r7]
	adds	r3, r3, #1
	str	r3, [r7]
.L37:
	ldr	r3, [r7]
	cmp	r3, #4
	ble	.L40
	b	.L39
.L42:
	nop
.L39:
	ldr	r3, [r7, #4]
	cmp	r3, #0
	beq	.L43
	ldr	r3, .L44
	movs	r2, #0
	strb	r2, [r3]
.L43:
	nop
	adds	r7, r7, #12
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L45:
	.align	2
.L44:
	.word	current_task
	.word	-858993459
	.word	user_tasks
	.size	decide_next_task, .-decide_next_task
	.align	1
	.global	switch_sp_to_psp
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	switch_sp_to_psp, %function
switch_sp_to_psp:
	@ Naked Function: prologue and epilogue provided by programmer.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	.syntax unified
@ 181 "main.c" 1
	PUSH {LR}
@ 0 "" 2
@ 182 "main.c" 1
	BL get_psp_value
@ 0 "" 2
@ 183 "main.c" 1
	MSR PSP, R0
@ 0 "" 2
@ 184 "main.c" 1
	POP {LR}
@ 0 "" 2
@ 187 "main.c" 1
	MRS R0, CONTROL
@ 0 "" 2
@ 188 "main.c" 1
	ORR R0, R0, #0x02
@ 0 "" 2
@ 189 "main.c" 1
	MSR CONTROL, R0
@ 0 "" 2
@ 190 "main.c" 1
	BX LR
@ 0 "" 2
	.thumb
	.syntax unified
	nop
	.size	switch_sp_to_psp, .-switch_sp_to_psp
	.section	.rodata
	.align	2
.LC0:
	.ascii	"Exception: MemManage Fault\000"
	.text
	.align	1
	.global	MemManage_Handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	MemManage_Handler, %function
MemManage_Handler:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
	ldr	r0, .L49
	bl	puts
.L48:
	b	.L48
.L50:
	.align	2
.L49:
	.word	.LC0
	.size	MemManage_Handler, .-MemManage_Handler
	.section	.rodata
	.align	2
.LC1:
	.ascii	"Exception: BusFault\000"
	.text
	.align	1
	.global	BusFault_Handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	BusFault_Handler, %function
BusFault_Handler:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
	ldr	r0, .L53
	bl	puts
.L52:
	b	.L52
.L54:
	.align	2
.L53:
	.word	.LC1
	.size	BusFault_Handler, .-BusFault_Handler
	.section	.rodata
	.align	2
.LC2:
	.ascii	"Exception: Usage Fault\000"
	.text
	.align	1
	.global	UsageFault_Handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	UsageFault_Handler, %function
UsageFault_Handler:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
	ldr	r0, .L57
	bl	puts
.L56:
	b	.L56
.L58:
	.align	2
.L57:
	.word	.LC2
	.size	UsageFault_Handler, .-UsageFault_Handler
	.section	.rodata
	.align	2
.LC3:
	.ascii	"Exception: HardFault\000"
	.text
	.align	1
	.global	HardFault_Handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	HardFault_Handler, %function
HardFault_Handler:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
	ldr	r0, .L61
	bl	puts
.L60:
	b	.L60
.L62:
	.align	2
.L61:
	.word	.LC3
	.size	HardFault_Handler, .-HardFault_Handler
	.align	1
	.global	task_delay
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	task_delay, %function
task_delay:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #8
	add	r7, sp, #0
	str	r0, [r7, #4]
	.syntax unified
@ 221 "main.c" 1
	MOV R0, #0x1
@ 0 "" 2
@ 221 "main.c" 1
	MSR PRIMASK, R0
@ 0 "" 2
	.thumb
	.syntax unified
	ldr	r3, .L65
	ldrb	r3, [r3]
	uxtb	r3, r3
	cmp	r3, #0
	beq	.L64
	ldr	r3, .L65+4
	ldr	r2, [r3]
	ldr	r3, .L65
	ldrb	r3, [r3]
	uxtb	r3, r3
	mov	r0, r3
	ldr	r3, [r7, #4]
	add	r2, r2, r3
	ldr	r1, .L65+8
	lsls	r3, r0, #4
	add	r3, r3, r1
	adds	r3, r3, #4
	str	r2, [r3]
	ldr	r3, .L65
	ldrb	r3, [r3]
	uxtb	r3, r3
	ldr	r2, .L65+8
	lsls	r3, r3, #4
	add	r3, r3, r2
	adds	r3, r3, #8
	movs	r2, #255
	strb	r2, [r3]
	bl	schedule
.L64:
	.syntax unified
@ 231 "main.c" 1
	MOV R0, #0x0
@ 0 "" 2
@ 231 "main.c" 1
	MSR PRIMASK, R0
@ 0 "" 2
	.thumb
	.syntax unified
	nop
	adds	r7, r7, #8
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
.L66:
	.align	2
.L65:
	.word	current_task
	.word	global_tick_count
	.word	user_tasks
	.size	task_delay, .-task_delay
	.align	1
	.global	schedule
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	schedule, %function
schedule:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #12
	add	r7, sp, #0
	ldr	r3, .L68
	str	r3, [r7, #4]
	ldr	r3, [r7, #4]
	ldr	r3, [r3]
	orr	r2, r3, #268435456
	ldr	r3, [r7, #4]
	str	r2, [r3]
	nop
	adds	r7, r7, #12
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L69:
	.align	2
.L68:
	.word	-536810236
	.size	schedule, .-schedule
	.align	1
	.global	update_global_tick_count
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	update_global_tick_count, %function
update_global_tick_count:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	add	r7, sp, #0
	ldr	r3, .L71
	ldr	r3, [r3]
	adds	r3, r3, #1
	ldr	r2, .L71
	str	r3, [r2]
	nop
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L72:
	.align	2
.L71:
	.word	global_tick_count
	.size	update_global_tick_count, .-update_global_tick_count
	.align	1
	.global	unblock_user_tasks
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	unblock_user_tasks, %function
unblock_user_tasks:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #12
	add	r7, sp, #0
	movs	r3, #1
	str	r3, [r7, #4]
	b	.L74
.L76:
	ldr	r2, .L77
	ldr	r3, [r7, #4]
	lsls	r3, r3, #4
	add	r3, r3, r2
	adds	r3, r3, #8
	ldrb	r3, [r3]
	uxtb	r3, r3
	cmp	r3, #0
	beq	.L75
	ldr	r2, .L77
	ldr	r3, [r7, #4]
	lsls	r3, r3, #4
	add	r3, r3, r2
	adds	r3, r3, #4
	ldr	r2, [r3]
	ldr	r3, .L77+4
	ldr	r3, [r3]
	cmp	r2, r3
	bne	.L75
	ldr	r2, .L77
	ldr	r3, [r7, #4]
	lsls	r3, r3, #4
	add	r3, r3, r2
	adds	r3, r3, #8
	movs	r2, #0
	strb	r2, [r3]
.L75:
	ldr	r3, [r7, #4]
	adds	r3, r3, #1
	str	r3, [r7, #4]
.L74:
	ldr	r3, [r7, #4]
	cmp	r3, #4
	ble	.L76
	nop
	nop
	adds	r7, r7, #12
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L78:
	.align	2
.L77:
	.word	user_tasks
	.word	global_tick_count
	.size	unblock_user_tasks, .-unblock_user_tasks
	.align	1
	.global	SysTick_Handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	SysTick_Handler, %function
SysTick_Handler:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #8
	add	r7, sp, #0
	ldr	r3, .L80
	str	r3, [r7, #4]
	bl	update_global_tick_count
	bl	unblock_user_tasks
	ldr	r3, [r7, #4]
	ldr	r3, [r3]
	orr	r2, r3, #268435456
	ldr	r3, [r7, #4]
	str	r2, [r3]
	nop
	adds	r7, r7, #8
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
.L81:
	.align	2
.L80:
	.word	-536810236
	.size	SysTick_Handler, .-SysTick_Handler
	.align	1
	.global	PendSV_Handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	PendSV_Handler, %function
PendSV_Handler:
	@ Naked Function: prologue and epilogue provided by programmer.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	.syntax unified
@ 274 "main.c" 1
	PUSH {LR}
@ 0 "" 2
@ 278 "main.c" 1
	MRS R0, PSP
@ 0 "" 2
@ 280 "main.c" 1
	STMDB R0!, {R4-R11}
@ 0 "" 2
@ 282 "main.c" 1
	BL save_psp_value
@ 0 "" 2
@ 286 "main.c" 1
	BL decide_next_task
@ 0 "" 2
@ 288 "main.c" 1
	BL get_psp_value
@ 0 "" 2
@ 290 "main.c" 1
	LDMIA R0!, {R4-R11}
@ 0 "" 2
@ 292 "main.c" 1
	MSR PSP, R0
@ 0 "" 2
@ 295 "main.c" 1
	POP {LR}
@ 0 "" 2
@ 296 "main.c" 1
	BX LR
@ 0 "" 2
	.thumb
	.syntax unified
	nop
	.size	PendSV_Handler, .-PendSV_Handler
	.ident	"GCC: (GNU Arm Embedded Toolchain 10-2020-q4-major) 10.2.1 20201103 (release)"
