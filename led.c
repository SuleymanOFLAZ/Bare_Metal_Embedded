/*
 * led.c
 *
 *  Created on: 28 Mar 2021
 *      Author: suleymanoflaz
 */

#include <stdint.h>
#include <stdio.h>
#include "main.h"
#include "led.h"

uint32_t volatile *GPIOD_ODR=(uint32_t *)0x40020C14;

void delay(uint32_t loop_value)
{
	for(int i=0; i<loop_value; i++);
}

void init_user_leds(void)
{
	// Enable The GPIOD clock
	uint32_t volatile *RCC_AHB1ENR = (uint32_t *)0x40023830;
	*RCC_AHB1ENR |= (1 << 3);


	// Configure the GPIO
	uint32_t volatile *GPIOD = (uint32_t *)0x40020C00;
	// Make the PD12-PD15 ports output
	*GPIOD |= (2 << 29);
	*GPIOD |= (2 << 27);
	*GPIOD |= (2 << 25);
	*GPIOD |= (2 << 23);

}

void led_on(uint8_t led)
{
	switch(led)
	{
		case 12:
			*GPIOD_ODR |= (1 << 12);
			break;
		case 13:
			*GPIOD_ODR |= (1 << 13);
			break;
		case 14:
			*GPIOD_ODR |= (1 << 14);
			break;
		case 15:
			*GPIOD_ODR |= (1 << 15);
			break;
		default:
			break;
	}
}

void led_off(uint8_t led)
{
	switch(led)
	{
		case 12:
			*GPIOD_ODR &= ~(1 << 12);
			break;
		case 13:
			*GPIOD_ODR &= ~(1 << 13);
			break;
		case 14:
			*GPIOD_ODR &= ~(1 << 14);
			break;
		case 15:
			*GPIOD_ODR &= ~(1 << 15);
			break;
		default:
			break;
	}
}
