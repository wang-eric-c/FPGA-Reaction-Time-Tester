# FPGA-Reaction-Time-Tester

A reaction-time game in SystemVerilog. After the user starts a round, the FPGA waits a randomized interval, lights an LED, and measures how long the user takes to press the button in response. The elapsed time is shown on a 4-digit seven-segment display.

## How it plays

The top-level module runs a four-state FSM:

| State    | Behavior                                                                 | Exits on               |
|----------|--------------------------------------------------------------------------|------------------------|
| `RESET`  | Idle. LED off, display cleared.                                          | Button press → `SET`   |
| `SET`    | Counts up to a randomized value from the RNG (the "wait" period).        | Counter hits target → `GO` |
| `GO`     | LED on, stopwatch running.                                               | Button press → `SCORE` |
| `SCORE`  | Stopwatch frozen. Elapsed time stays on the display.                     | Reset                  |

`rst` returns the FSM to `RESET` at any time.

## Top-level interface

```
lab_2_top(
    input  logic       clk,
    input  logic       rst,
    input  logic       button,
    output logic       led,
    output logic [6:0] digit,   // 7-segment cathodes
    output logic [3:0] an       // 4-digit anode select
);
```

## Module hierarchy

```
lab_2_top
├── stopwatch                  // counts elapsed time while start_watch is high
├── random_number_generator    // LFSR-based 8-bit RNG
├── binary_to_ssd              // elapsed_time -> 4 nibbles for the digits
├── ssd_display                // time-multiplexes the 4 digits
│   └── seven_segment_digit    // 4-bit BCD -> 7-segment cathode pattern
└── clock_divider              // slow clock for stopwatch / display multiplex
```

## Files

| File                          | Description                                             |
|-------------------------------|---------------------------------------------------------|
| `lab_2_top.sv`                | Top-level FSM and wiring                                |
| `stopwatch.sv`                | Elapsed-time counter, gated by `start_watch`            |
| `random_number_generator.sv`  | LFSR-based RNG that latches a new number on button press |
| `clock_divider.sv`            | Divides the system clock for slower internal events     |
| `binary_to_ssd.sv`            | Binary elapsed-time → per-digit display values          |
| `ssd_display.sv`              | Multiplexes the 4 digits onto the shared segment bus    |
| `seven_segment_digit.sv`      | Single-digit BCD-to-7-segment decoder                   |

## Build (Vivado)

1. Create a new RTL project targeting your board's part (e.g. `xc7z010clg400-1` for ZYBO Z7-10, or the appropriate part for a Basys 3).
2. Add all `.sv` files as design sources.
3. Add a constraints file mapping:
   - `clk` to the onboard clock
   - `rst` and `button` to two pushbuttons
   - `led` to an onboard LED
   - `digit[6:0]` and `an[3:0]` to the seven-segment display pins
4. Generate bitstream and program the board.

## Playing

1. Hold `rst` briefly to return to the idle state.
2. Press `button` to start a round.
3. Wait for the LED to turn on (the wait time is randomized).
4. Press `button` as quickly as you can — your reaction time is held on the display.

Pressing `button` *before* the LED lights up will not register as a valid response under the current FSM (the press will be ignored until the `GO` state is entered).
