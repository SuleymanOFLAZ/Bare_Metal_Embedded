/*
 * main.h
 *
 *  Created on: 25 Mar 2021
 *      Author: suleyman
 */

#ifndef MAIN_H_
#define MAIN_H_

/* Stack Memory Address Calculation */
#define SIZE_TASK_STACK  		1024U
#define SIZE_SCHED_STACK 		1024U

#define SRAM_START				0X20000000U
#define SRAM_SIZE				((128) * (1024))
#define SRAM_END				((SRAM_START) + (SRAM_SIZE))

#define T1_STACK_START			SRAM_END
#define T2_STACK_START			((SRAM_END) - (1 * SIZE_TASK_STACK))
#define T3_STACK_START			((SRAM_END) - (2 * SIZE_TASK_STACK))
#define T4_STACK_START			((SRAM_END) - (3 * SIZE_TASK_STACK))
#define IDLE_STACK_START			((SRAM_END) - (4 * SIZE_TASK_STACK))
#define SCHED_STACK_START		((SRAM_END) - (5 * SIZE_TASK_STACK))
/* --- */

/* SysTick timer macros */
#define TICK_HZ 1000U
#define PROCESSOR_CLOCK_SPEED 16000000U
#define SYSTICK_TIMER_CLOCK_SPEED PROCESSOR_CLOCK_SPEED
/* --- */

#define MAX_USER_TASKS 	   5
#define TASK_READY_STATE   0x00U
#define TASK_BLOCKED_STATE 0xFFU

#define INTERRUPT_DISABLE() __asm volatile("MOV R0, #0x1"); \
		__asm("MSR PRIMASK, R0")
#define INTERRUPT_ENABLE() __asm volatile("MOV R0, #0x0"); \
		__asm("MSR PRIMASK, R0")

typedef struct
{
	uint32_t psp_value;
	uint32_t block_count;
	uint8_t  current_state;
	void (*task_handler)(void);
}TCB_t;


void idle_handler(void);  // IDLE
void task1_handler(void); // This is Task1
void task2_handler(void); // This is Task2
void task3_handler(void); // This is Task3
void task4_handler(void); // This is Task4 of the application

void unblock_user_tasks(void);
void update_global_tick_count(void);
void schedule(void);
void task_delay(uint32_t tick_count);

__attribute__((naked)) void init_scheduler_task_stack(uint32_t sched_task_stack_start);
void init_user_tasks_stack(void);
void enable_processor_faults(void);
__attribute__((naked))  void switch_sp_to_psp(void);
uint32_t get_psp_value(void);
void decide_next_task(void);
void save_psp_value(uint32_t current_psp_value);


#endif /* MAIN_H_ */
