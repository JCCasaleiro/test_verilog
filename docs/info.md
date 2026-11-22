<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

Tiny 8 bits CPU. 

## How to test

The 8 input bits functions described in the following table:

| b7| b6| b5| b4| b3| b2| b1| b0| Description |
|---|---|---|---|---|---|---|---|-------------|
| 0| 0| ROM Memory Address | Use the LSbits as ROM Address and 8 Bidirectional IOs as Databus|
| 0| 1| RAM Memory Address | Use the LSbits as RAM Address and 8 Bidirectional IOs as Databus|
| 1| 0| 0| 0| 0| 0| 0| 0| Output Value of Register V |
| 1| 0| 0| 0| 0| 0| 0| 1| Output Value of Register A |
| 1| 0| 0| 0| 0| 0| 1| 0| Output Value of Register R |
| 1| 0| 0| 0| 0| 0| 1| 1| Output Value of Register V |

## External hardware

Requires 8 LEDs to check the CPU internal registers values. 
