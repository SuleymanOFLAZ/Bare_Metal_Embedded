/*
 * led.h
 *
 *  Created on: 28 Mar 2021
 *      Author: suleyman
 */

#ifndef LED_H_
#define LED_H_

#define DELAY_1S (PROCESSOR_CLOCK_SPEED / 48)
#define DELAY_500MS (DELAY_1S/2)
#define DELAY_250MS (DELAY_1S/4)
#define DELAY_125MS (DELAY_1S/8)

#define LED_GREEN 	12
#define LED_ORANGE 	13
#define LED_RED 	14
#define LED_BLUE 	15

void delay(uint32_t loop_value);
void init_user_leds(void);
void led_on(uint8_t led);
void led_off(uint8_t led);

#endif /* LED_H_ */
