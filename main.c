#include <stdint.h>
#include <stdio.h>
#include "main.h"
#include "led.h"

uint8_t volatile current_task = 1; // task1 is running
uint32_t volatile global_tick_count = 0;
TCB_t volatile user_tasks[MAX_USER_TASKS];

// This function initializes semi hosting future
extern void initialise_monitor_handles(void);

void init_systick_timer(uint32_t tick_hz)
{
	// Calculating RELOAD Value
	uint32_t reload = ((uint32_t)SYSTICK_TIMER_CLOCK_SPEED / tick_hz) - 1;

	// Loading the RELOAD value to the RELOAD region (27-0 bits) of SYST_RVR register
	uint32_t *pSYST_RVR = (uint32_t *)0xE000E014;
	*pSYST_RVR  &= ~(0x00FFFFFF); // CLearing the RELOAD
	*pSYST_RVR |= reload; // Loading reload

	// Settings for SysTick Timer
	uint32_t *pSYST_CSR = (uint32_t *)0xE000E010;
	*pSYST_CSR |= (1 << 2); // Enabling SysTick exception request
	*pSYST_CSR |= (1 << 1); // Indicating the clock source to 16MHz High Speed Internal Processor Clock

	// Enabling the SysTick Timer
	*pSYST_CSR |= (1 << 0);
}

int main(void)
{
	enable_processor_faults();
	printf("Processor faults enabled\n");
	
	initialise_monitor_handles();

	init_user_leds();

	init_scheduler_task_stack(SCHED_STACK_START);

	init_user_tasks_stack();
	printf("Tasks stacks iniialized.\n");

	init_systick_timer(TICK_HZ);

	switch_sp_to_psp();

	task1_handler();
    /* Loop forever */
	for(;;);
}

void enable_processor_faults(void)
{
	uint32_t volatile *pSHCSR = (uint32_t *)0xE000ED24;
	*pSHCSR = (1 << 18); // Enabling the Usage Fault
	*pSHCSR = (1 << 17); // Enabling the Bus Fault
	*pSHCSR = (1 << 16); // Enabling the MemManage Fault
}

void idle_handler(void)
{
	while(1);
}

void task1_handler(void)
{
	while(1){
		printf("Tasks1_handler running.\n");
		led_on(LED_GREEN);
		task_delay(1000);
		led_off(LED_GREEN);
		task_delay(1000);
	}
}
void task2_handler(void)
{
	while(1){
		printf("Tasks2_handler running.\n");
		led_on(LED_ORANGE);
		task_delay(500);
		led_off(LED_ORANGE);
		task_delay(500);
	}
}
void task3_handler(void)
{
	while(1){
		printf("Tasks3_handler running.\n");
		led_on(LED_RED);
		task_delay(250);
		led_off(LED_RED);
		task_delay(250);
	}
}
void task4_handler(void)
{

	while(1){
		printf("Tasks_handler running.\n");
		led_on(LED_BLUE);
		task_delay(125);
		led_off(LED_BLUE);
		task_delay(125);
	}
}

__attribute__((naked)) void init_scheduler_task_stack(uint32_t sched_task_stack_start)
{
	__asm volatile("MSR MSP,%0" : : "r"(sched_task_stack_start) : );
	__asm volatile("BX LR");
}

void init_user_tasks_stack(void)
{
	uint32_t *pPSP;

	user_tasks[0].current_state = TASK_READY_STATE;
	user_tasks[1].current_state = TASK_READY_STATE;
	user_tasks[2].current_state = TASK_READY_STATE;
	user_tasks[3].current_state = TASK_READY_STATE;
	user_tasks[4].current_state = TASK_READY_STATE;

	user_tasks[0].task_handler = idle_handler;
	user_tasks[1].task_handler = task1_handler;
	user_tasks[2].task_handler = task2_handler;
	user_tasks[3].task_handler = task3_handler;
	user_tasks[4].task_handler = task4_handler;

	user_tasks[0].psp_value = IDLE_STACK_START;
	user_tasks[1].psp_value = T1_STACK_START;
	user_tasks[2].psp_value = T2_STACK_START;
	user_tasks[3].psp_value = T3_STACK_START;
	user_tasks[4].psp_value = T4_STACK_START;

	for(int i=0; i<MAX_USER_TASKS ; i++)
	{
		pPSP = (uint32_t *)user_tasks[i].psp_value;

		pPSP--; // xPSR
		*pPSP = (uint32_t)0x01000000; // DUMMY xPSR Should be 0x01000000 because of the T bit

		pPSP--; // PC
		*pPSP = (uint32_t)user_tasks[i].task_handler;

		pPSP--; // LR
		*pPSP = (uint32_t)0xFFFFFFFD; // Special Return Value

		for(int j=0; j<13; j++)
		{
			pPSP--; // General Purpuse Registers R12-R0
			*pPSP = (uint32_t)0x00;
		}

		user_tasks[i].psp_value = (uint32_t)pPSP; // Saving the final value of the PSP

	}
}

uint32_t get_psp_value(void)
{
	return user_tasks[current_task].psp_value;
}

void save_psp_value(uint32_t current_psp_value)
{
	user_tasks[current_task].psp_value = current_psp_value;
}

void decide_next_task(void)
{
	int state = TASK_BLOCKED_STATE;

	for(int i=0 ; i<MAX_USER_TASKS; i++)
	{
		current_task++;
		current_task %= MAX_USER_TASKS;
		state = user_tasks[current_task].current_state;
		if( (state == TASK_READY_STATE) && (current_task != 0))
			break;
	}

	if(state != TASK_READY_STATE)
		current_task = 0;
}

__attribute__((naked)) void switch_sp_to_psp(void)
{
	// Initialize the PSP with TASK1 starting value
	__asm volatile("PUSH {LR}"); // preserve LR which connects back to main
	__asm volatile("BL get_psp_value");
	__asm volatile("MSR PSP, R0"); // initialize PSP
	__asm volatile("POP {LR}"); // bring LR back

	// Change the MSP to PSP
	__asm volatile("MRS R0, CONTROL"); // Saving CONTROL Register to R0
	__asm volatile("ORR R0, R0, #0x02"); // Setting the 1st bit
	__asm volatile("MSR CONTROL, R0"); // Load back to CONTROL Register
	__asm volatile("BX LR");
}

void MemManage_Handler(void)
{
	printf("Exception: MemManage Fault\n");
	while(1);
}

void BusFault_Handler(void)
{
	printf("Exception: BusFault\n");
	while(1);
}

void UsageFault_Handler(void)
{
	printf("Exception: Usage Fault\n");
	while(1);
}

void HardFault_Handler(void)
{
	printf("Exception: HardFault\n");
	while(1);
}


void task_delay(uint32_t tick_count)
{
	// Disable Interrups --> For shared global variable protection
	INTERRUPT_DISABLE();

	if(current_task) // if the current task isn't the idle task
	{
		user_tasks[current_task].block_count = global_tick_count + tick_count;
		user_tasks[current_task].current_state = TASK_BLOCKED_STATE;
		schedule();
	}

	// Enable Interrups
	INTERRUPT_ENABLE();
}

void schedule(void)
{
	//Pend the PendSV Exception
	uint32_t volatile *pICSR = (uint32_t *)0xE000ED04;
	*pICSR |= (1 << 28);
}

void update_global_tick_count(void)
{
	global_tick_count++;
}

void unblock_user_tasks(void)
{
	for(int i=1; i<MAX_USER_TASKS; i++)
	{
		if(user_tasks[i].current_state != TASK_READY_STATE)
		{
			if(user_tasks[i].block_count == global_tick_count)
			{
				user_tasks[i].current_state = TASK_READY_STATE;
			}
		}
	}
}

void SysTick_Handler(void)
{
	uint32_t volatile *pICSR = (uint32_t *)0xE000ED04;

	update_global_tick_count();
	unblock_user_tasks();

	// Pend the PendSV Exception
	*pICSR |= (1 << 28);
}

__attribute__((naked)) void PendSV_Handler(void)
{
	/* First push the LR, Because we will use BL instruction */
	__asm volatile("PUSH {LR}");

	/* Save  the context of current tasks */
	//1. Get current running task's PSP value
	__asm volatile("MRS R0, PSP");
	//2. Using that PSP value store SF2(R4 to R11)
	__asm volatile("STMDB R0!, {R4-R11}");
	//3. Save the current value of PSP
	__asm volatile("BL save_psp_value");

	/* Retrieve the context of next task */
	//1. Decide next task to run
	__asm volatile("BL decide_next_task");
	//2. Get its past PSP value
	__asm volatile("BL get_psp_value");
	//3. Using that PSP value retrieve SF2(R4 to R11)
	__asm volatile("LDMIA R0!, {R4-R11}");
	//4. Update PSP
	__asm volatile("MSR PSP, R0");

	/* POP the LR and go back */
	__asm volatile("POP {LR}");
	__asm volatile("BX LR");
}
