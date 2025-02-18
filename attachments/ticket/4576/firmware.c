#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>

#include "events.h"

//#include "sched.h"
#include "uart.h"
#include "base.h"

static struct {
    struct uart_request req;
    const __flash char *str;
} ctx;

static void uart_puts(const __flash char *str)
{
    ctx.str = str;

        char c = *(ctx.str++);

        ctx.req.c = c;
        uart_tx(&ctx.req);
}

int main(void)
{
    led_init();
    led_on();

    uart_init(baud2ubrr(115200));

//    uart_puts(F("Hello World!\n"));

    set_sleep_mode(SLEEP_MODE_IDLE);
    sleep_enable();

    static void (* const __flash workers[EV_COUNT])(void) = {
        [ EV_UART_UDRE ] = uart_udre
    };

    for (;;) {
        uint8_t events = EVENTS_REG;
        if (events == 0) {
            led_off();
            sei();
            sleep_cpu();
            led_on();
            cli();
            continue;
        }
        EVENTS_REG = 0;
        sei();
        uint8_t idx = 0;
        for (;;) {
            if (events & 1) {
                workers[idx]();
            }
            if ((events >>= 1) == 0) {
                break;
            }
            ++idx;
        };
        cli();
    }
}
