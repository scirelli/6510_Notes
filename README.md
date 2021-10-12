# 6502/6510 Notes

## Registers
###### ADDR/PC - Program counter. Tells the 6510 where to get the next instruction from.  
###### AR, XR, YR - Contents of the three registers.  
###### SP - Stack pointer. More on this later.  

### Status Register
```
Bits:    7 6 5 4 3 2 1 0  
         | | | | | | | |  
Flag:    N V - B D I Z C  
```
##### NV-BDIZC - Status register in binary.
###### N - Negative flag
The negative flag is set/clear depending on what the MSB was after an operation. So if the MSB was 1, the flag would be set. So LDA #$A0 would set the N flag, because $A0 has the MSB as 1.

###### V - Overflow flag
The overflow flag is usable pretty much only for signed numbers. It is set if the result changed the sign from negative to positive, or positive to negative in the wrong way. It only applies to math, not incrementing or decrementing. So for example, if $7F had $1 added, it would have a result of $80: which is 127 to -128, so that's overflow and would set the overflow flag.

###### - - Unused bit
###### B - Reached current position from a break
###### D - Decimal mode
###### I - Interrupt disable flag
###### Z - Zero flag 
This flag is set (1) if the result of a compare instruction was equal or the result of a previous instruction was zero, else it's clear (0). So if we did this:  
```
LDX #$01
DEX
```
then DEX would make X zero, setting the zero flag. It will also be set if a load or store instruction resulted in 0.  

###### C - Carry flag.
The carry flag is set if the result of a compare instruction was greater than or equal to, else it's clear. It also acts as a carry and borrow in addition and subtraction, and is important in multiplication and division.

## Instructions
6510 has three registers that can all hold 8 bits of data: A, X, and Y  

###### LDA ADDR - load into A  
###### LDX ADDR - load into X  
###### LDY ADDR - load into Y  

###### STA ADDR - store A into  
###### STX ADDR - store X into  
###### STY ADDR - store Y into  

###### TAX - transfer A to X  
###### TAY - transfer A to Y  
###### TXA - transfer X to A  
###### TYA - transfer Y to A  

###### INC ADDR - increment memory  
###### INX - increment X  
###### INY - increment Y  
###### DEC ADDR - decrement memory  
###### DEX - decrement X  
###### DEY - decrement Y  

###### BRK - Break. This breaks the program and jumps to the address at $0316.  
Note: Using BRK to end a program is generally a bad idea for actual programs. We're only using it in this example.  

###### CLC - clears carry
###### SEC sets carry.

###### CLV clears overflow.

###### JMP ADDR - Unconditional jump  
###### JSR ADDR -  Jump subroutine  
###### RTS - Return subroutine  
Note: If an RTS is encountered without being in any of your own subroutines, the computer will go back to BASIC (will crash if you got the ROMs off). There are several Kernal routines, but these are not suitable for demos- only use them for tools and things that don't need to be fast.  

###### BNE - Branch if not equal  
The BNE instruction branches if the zero flag is clear, and BEQ branches if set. So we could do a simple loop with X like this:  
```
A 1000 LDX #$08
* your code *
DEX <- this is $1002 in this case
BNE $1002
```
So this doesn't do much, it just loops DEX 8 times.  

###### BEQ - Branch if equal  
Note: One odd thing about branches is that *they are made of only two bytes*. This is because the second byte is a signed number that tells the computer how far to branch: so therefore you can only branch back 128 bytes and forward 127. This is called relative addressing.  
So instead of doing this:  
```
A 1000 CPX #$50
BNE $2000
TXA
* more than 127 bytes of code *
A 2000 TYA
```
You'll need to get around this with an unconditional jump, like so:
```
A 1000 CPX #$50
BEQ $1007
JMP $2000
TXA <- this is $1007
* more than 127 bytes of code *
A 2000 TYA
```
###### BCC - branch if carry clear
###### BCS - branches if set
###### BPL - branch if plus
Branches if N is clear.
###### BMI - branch if minus
Branches if N is set. 
###### BVC branches if V is clear
###### BVS branches if V is set


###### CMP ADDR - Compare A with  
###### CPX ADDR - Compare X with  
###### CPY ADDR - Compare Y with  

###### ORA - Logical OR to A
###### AND - Logical AND to A
###### EOR - Exclusive OR to A

###### ADC - Add with carry
Make sure to CLC (clear carry) before any new addition. The carry bit is used to link different ADCs together for multi-byte addition


###### SBC - Subtract with carry
The carry bit is used as a borrow for multi-byte subtraction. Need to set the carry (SEC) to prevent anything extra from being subtracted. 

###### ASL - Arithmetic shift left
It shifts bit 7 into carry, all other bits left, and 0 goes in bit 0. 
```
     +-+-+-+-+-+-+-+-+
C <- |7|6|5|4|3|2|1|0| <- 0
     +-+-+-+-+-+-+-+-+
```

###### ROL - Rotate left
It shifts carry into zero, all other bits left, and bit 7 goes into the new carry. 
```
+------------------------------+
|                              |
|   +-+-+-+-+-+-+-+-+    +-+   |
+-< |7|6|5|4|3|2|1|0| <- |C| <-+
    +-+-+-+-+-+-+-+-+    +-+
```

To multiply by non-powers of two, we must use other ways to get there. So to multiply by 6:
```
LDA #$01
ASL A <- multiply by 2
STA $xxxx <- store A*2 into some location
ASL A <- now we have A*4
CLC
ADC $xxxx <- and add A*2 to get A*6
```

To multiply a two-byte value we need to use ASL and ROL in sequence.
```
ASL $2000 <- x*2
ROL $2001
ASL $2000 <- x*4
ROL $2001
```
Rotate the carry into the high byte ...and so on.

###### LSR Logical shift right
```
     +-+-+-+-+-+-+-+-+
0 -> |7|6|5|4|3|2|1|0| -> C
     +-+-+-+-+-+-+-+-+
 ```
###### ROR Rotate right
```
+------------------------------+
|                              |
|   +-+    +-+-+-+-+-+-+-+-+   |
+-> |C| -> |7|6|5|4|3|2|1|0| >-+
    +-+    +-+-+-+-+-+-+-+-+
```
 Note that the ASL/LSR/ROL/ROR can be used for more than just addition, since they work with the bits of a memory address/accumulator. 

###### NOP - No op


## Monitor Commands
A ADDR OPC OPER  
Assembly mode: Where ADDR is where you assemble to, then opcode, then operand if one. After you enter in the command, the monitor will have the next assembly line ready for you. All you have to type now is the opcode and operand.  
Exit this mode by just pressing return with nothing else in the line.  

X  
Exit monitor mode  

M ADD1 <ADD2>  
List memory. Where ADD1 is the address you'd like to list from, and ADD2 (optional) is the address where listing ends. Typing just M will continuously list from where you left off.  

G ADDR  
Goto ADDR. Set the program couter to ADDR  

R  
View the registers.  


**VICE Monitor located at $E5CD**  

## Tips

### Usable Memory

```
┏━━━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━━━━┯━━┯━━━━━━━━━━━━━┯━━━━━━━━━━━━━━━┯━━━━━━━━━━━━━━━━┯━━━━━━━━━━━┯━━━━━━━━━━━━━━┓
┃ Zero Page │         │Cassette    │  │ Basic RAM   │               │ Empty RAM      │I/O        │              ┃
┃           │         │Buffer      │  │             │               │                │           │              ┃
┃ 255 bytes │         │191bytes    │  │             │               │                │           │              ┃
┗━━━━━━━━━━━┷━━━━━━━━━┷━━━━━━━━━━━━┷━━┷━━━━━━━━━━━━━┷━━━━━━━━━━━━━━━┷━━━━━━━━━━━━━━━━┷━━━━━━━━━━━┷━━━━━━━━━━━━━━┛
$0000  $00FF|$0100    |$033C  $03FB|  |$0800   $9FFF|$A000     $BFFF|$C000      $CFFF|$D000 $DFFF|$E000     $FFFF
```
$033C-$03FB
: The cassette buffer, $033C-$03FB ($BF = 192 bytes) is a good spot to put short example programs.  
$C000-$CFFF
: There's a completely free block of RAM in $C000-$CFFF (4095 bytes, 4k).  
$0800-$9FFF
: (38911 bytes 38.91kb) is the normal spot if you're not using BASIC at all, If a SYS-line is needed start at $080D.  
$A000-$BFFF and $E000-$FFFF
: If BASIC and Kernal-ROMs are turned off entirely, there is almost all of $A000-$BFFF and $E000-$FFFF. Don't use $D000-$DFFF, that's where the I/O (SID, VIC, CIA) lies.  

## Commodore 64 standard KERNAL functions

|Address|Function|
|:------|:-------|
|$FF81	| SCINIT. Initialize VIC; restore default input/output to keyboard/screen;<br>clear screen;<br>set PAL/NTSC switch and interrupt timer.<br><br>Input: –<br>Output: –<br>Used registers: A, X, Y.<br>Real address: $FF5B.|
|$FF84	| IOINIT. Initialize CIA's, SID volume; setup memory configuration; set and start interrupt timer.<br><br>Input: –<br>Output: –<br>Used registers: A, X.<br>Real address: $FDA3.|
|$FF87	| RAMTAS. Clear memory addresses $0002-$0101 and $0200-$03FF; run memory test and set start and end address of BASIC work area accordingly; set screen memory to $0400 and datasette buffer to $033C.<br><br>Input: –<br>Output: –<br>Used registers: A, X, Y.<br>Real address: $FD50.|
|$FF8A	| RESTOR. Fill vector table at memory addresses $0314-$0333 with default values.<br><br>Input: –<br>Output: –<br>Used registers: –<br>Real address: $FD15.|
|$FF8D	| VECTOR. Copy vector table at memory addresses $0314-$0333 from or into user table.<br><br>Input: Carry: 0 = Copy user table into vector table, 1 = Copy vector table into user table; X/Y = Pointer to user table.<br>Output: –<br>Used registers: A, Y.<br>Real address: $FD1A.|
|$FF90	| SETMSG. Set system error display switch at memory address $009D.<br><br>Input: A = Switch value.<br>Output: –<br>Used registers: –<br>Real address: $FE18.|
|$FF93	| LSTNSA. Send LISTEN secondary address to serial bus. (Must call LISTEN beforehands.)<br><br>Input: A = Secondary address.<br>Output: –<br>Used registers: A.<br>Real address: $EDB9.|
|$FF96	| TALKSA. Send TALK secondary address to serial bus. (Must call TALK beforehands.)<br><br>Input: A = Secondary address.<br>Output: –<br>Used registers: A.<br>Real address: $EDC7.|
|$FF99	| MEMBOT. Save or restore start address of BASIC work area.<br><br>Input: Carry: 0 = Restore from input, 1 = Save to output; X/Y = Address (if Carry = 0).<br>Output: X/Y = Address (if Carry = 1).<br>Used registers: X, Y.<br>Real address: $FE25.|
|$FF9C	| MEMTOP. Save or restore end address of BASIC work area.<br><br>Input: Carry: 0 = Restore from input, 1 = Save to output; X/Y = Address (if Carry = 0).<br>Output: X/Y = Address (if Carry = 1).<br>Used registers: X, Y.<br>Real address: $FE34.|
|$FF9F	| SCNKEY. Query keyboard; put current matrix code into memory address $00CB, current status of shift keys into memory address $028D and PETSCII code into keyboard buffer.<br><br>Input: –<br>Output: –<br>Used registers: A, X, Y.<br>Real address: $EA87.|
|$FFA2	| SETTMO. Unknown. (Set serial bus timeout.)<br><br>Input: A = Timeout value.<br>Output: –<br>Used registers: –<br>Real address: $FE21.|
|$FFA5	| IECIN. Read byte from serial bus. (Must call TALK and TALKSA beforehands.)<br><br>Input: –<br>Output: A = Byte read.<br>Used registers: A.<br>Real address: $EE13.|
|$FFA8	| IECOUT. Write byte to serial bus. (Must call LISTEN and LSTNSA beforehands.)<br><br>Input: A = Byte to write.<br>Output: –<br>Used registers: –<br>Real address: $EDDD.|
|$FFAB	| UNTALK. Send UNTALK command to serial bus.<br><br>Input: –<br>Output: –<br>Used registers: A.<br>Real address: $EDEF.|
|$FFAE	| UNLSTN. Send UNLISTEN command to serial bus.<br><br>Input: –<br>Output: –<br>Used registers: A.<br>Real address: $EDFE.|
|$FFB1	| LISTEN. Send LISTEN command to serial bus.<br><br>Input: A = Device number.<br>Output: –<br>Used registers: A.<br>Real address: $ED0C.|
|$FFB4	| TALK. Send TALK command to serial bus.<br><br>Input: A = Device number.<br>Output: –<br>Used registers: A.<br>Real address: $ED09.|
|$FFB7	| READST. Fetch status of current input/output device, value of ST variable. (For RS232, status is cleared.)<br><br>Input: –<br>Output: A = Device status.<br>Used registers: A.<br>Real address: $FE07.|
|$FFBA	| SETLFS. Set file parameters.<br><br>Input: A = Logical number; X = Device number; Y = Secondary address.<br>Output: –<br>Used registers: –<br>Real address: $FE00.|
|$FFBD	| SETNAM. Set file name parameters.<br><br>Input: A = File name length; X/Y = Pointer to file name.<br>Output: –<br>Used registers: –<br>Real address: $FDF9.|
|$FFC0	| OPEN. Open file. (Must call SETLFS and SETNAM beforehands.)<br><br>Input: –<br>Output: –<br>Used registers: A, X, Y.<br>Real address: ($031A), $F34A.|
|$FFC3	| CLOSE. Close file.<br><br>Input: A = Logical number.<br>Output: –<br>Used registers: A, X, Y.<br>Real address: ($031C), $F291.|
|$FFC6	| CHKIN. Define file as default input. (Must call OPEN beforehands.)<br><br>Input: X = Logical number.<br>Output: –<br>Used registers: A, X.<br>Real address: ($031E), $F20E.|
|$FFC9	| CHKOUT. Define file as default output. (Must call OPEN beforehands.)<br><br>Input: X = Logical number.<br>Output: –<br>Used registers: A, X.<br>Real address: ($0320), $F250.|
|$FFCC	| CLRCHN. Close default input/output files (for serial bus, send UNTALK and/or UNLISTEN); restore default input/output to keyboard/screen.<br><br>Input: –<br>Output: –<br>Used registers: A, X.<br>Real address: ($0322), $F333.|
|$FFCF	| CHRIN. Read byte from default input (for keyboard, read a line from the screen). (If not keyboard, must call OPEN and CHKIN beforehands.)<br><br>Input: –<br>Output: A = Byte read.<br>Used registers: A, Y.<br>Real address: ($0324), $F157.|
|$FFD2	| CHROUT. Write byte to default output. (If not screen, must call OPEN and CHKOUT beforehands.)<br><br>Input: A = Byte to write.<br>Output: –<br>Used registers: –<br>Real address: ($0326), $F1CA.|
|$FFD5	| LOAD. Load or verify file. (Must call SETLFS and SETNAM beforehands.)<br><br>Input: A: 0 = Load, 1-255 = Verify; X/Y = Load address (if secondary address = 0).<br>Output: Carry: 0 = No errors, 1 = Error; A = KERNAL error code (if Carry = 1); X/Y = Address of last byte loaded/verified (if Carry = 0).<br>Used registers: A, X, Y.<br>Real address: $F49E.|
|$FFD8	| SAVE. Save file. (Must call SETLFS and SETNAM beforehands.)<br><br>Input: A = Address of zero page register holding start address of memory area to save; X/Y = End address of memory area plus 1.<br>Output: Carry: 0 = No errors, 1 = Error; A = KERNAL error code (if Carry = 1).<br>Used registers: A, X, Y.<br>Real address: $F5DD.|
|$FFDB	| SETTIM. Set Time of Day, at memory address $00A0-$00A2.<br><br>Input: A/X/Y = New TOD value.<br>Output: –<br>Used registers: –<br>Real address: $F6E4.|
|$FFDE	| RDTIM. read Time of Day, at memory address $00A0-$00A2.<br><br>Input: –<br>Output: A/X/Y = Current TOD value.<br>Used registers: A, X, Y.<br>Real address: $F6DD.|
|$FFE1	| STOP. Query Stop key indicator, at memory address $0091; if pressed, call CLRCHN and clear keyboard buffer.<br><br>Input: –<br>Output: Zero: 0 = Not pressed, 1 = Pressed; Carry: 1 = Pressed.<br>Used registers: A, X.<br>Real address: ($0328), $F6ED.|
|$FFE4	| GETIN. Read byte from default input. (If not keyboard, must call OPEN and CHKIN beforehands.)<br><br>Input: –<br>Output: A = Byte read.<br>Used registers: A, X, Y.<br>Real address: ($032A), $F13E.|
|$FFE7	| CLALL. Clear file table; call CLRCHN.<br><br>Input: –<br>Output: –<br>Used registers: A, X.<br>Real address: ($032C), $F32F.|
|$FFEA	| UDTIM. Update Time of Day, at memory address $00A0-$00A2, and Stop key indicator, at memory address $0091.<br><br>Input: –<br>Output: –<br>Used registers: A, X.<br>Real address: $F69B.|
|$FFED	| SCREEN. Fetch number of screen rows and columns.<br><br>Input: –<br>Output: X = Number of columns (40); Y = Number of rows (25).<br>Used registers: X, Y.<br>Real address: $E505.|
|$FFF0	| PLOT. Save or restore cursor position.<br><br>Input: Carry: 0 = Restore from input, 1 = Save to output; X = Cursor column (if Carry = 0); Y = Cursor row (if Carry = 0).<br>Output: X = Cursor column (if Carry = 1); Y = Cursor row (if Carry = 1).<br>Used registers: X, Y.<br>Real address: $E50A.|
|$FFF3	| IOBASE. Fetch CIA #1 base address.<br><br>Input: –<br>Output: X/Y = CIA #1 base address ($DC00).<br>Used registers: X, Y.<br>Real address: $E500.|

## Commodore 64 Screen functions
|Address|Function|
|:------|:-------|
|$E4DA	| Put current color, at memory address $0286, into color RAM, pointed at by memory addresses $00F3-$00F4.<br><br>Input: Y = Column number.<br>Output: –<br>Used registers: A.|
|$E505	| Fetch number of screen rows and columns.<br><br>Input: –<br>Output: X = Number of columns (40); Y = Number of rows (25).<br>Used registers: X, Y.|
|$E50A	| Save or restore cursor position.<br><br>Input: Carry: 0 = Restore from input, 1 = Save to output; X = Cursor row (if Carry = 0); Y = Cursor column (if Carry = 0).<br>Output: X = Cursor row (if Carry = 1); Y = Cursor column (if Carry = 1).<br>Used registers: X, Y.|
|$E518	| Initialize VIC; restore default input/output to keyboard/screen; clear screen.<br><br>Input: –<br>Output: –<br>Used registers: A, X, Y.|
|$E544	| Clear screen.<br><br>Input: –<br>Output: –<br>Used registers: A, X, Y.|
|$E566	| Move cursor home, to upper left corner of screen.<br><br>Input: –<br>Output: –<br>Used registers: A, X, Y.|
|$E56C	| Set pointer at memory addresses $00D1-$00D2 to current line in screen memory and pointer at memory addresses $00F3-$00F4 to current line in Color RAM, according to current cursor row, at memory address $00D6, and column, at memory address $00D3.<br><br>Input: –<br>Output: –<br>Used registers: A, X, Y.|
|$E59A	| Initialize VIC; restore default input/output to keyboard/screen; move cursor home.<br><br>Input: –<br>Output: –<br>Used registers: A, X, Y.|
|$E5A0	| Initialize VIC; restore default input/output to keyboard/screen.<br><br>Input: –<br>Output: –<br>Used registers: A, X.|
|$E5A8	| Initialize VIC.<br><br>Input: –<br>Output: –<br>Used registers: A, X.|
|$E632	| Read byte from screen; if input line is empty, the cursor appears and a line of data is input.<br><br>Input: –<br>Output: A = Byte read.<br>Used registers: A.|
|$E684	| Check PETSCII code; if $22, quotation mark, then toggle quotation mode switch, at memory address $00D4.<br><br>Input: –<br>Output: –<br>Used registers: –|
|$E6B6	| Recompute the high bytes of pointers to lines in screen memory, at memory addresses $00D9-$00F1.<br><br>Input: –<br>Output: –<br>Used registers: A, X, Y.|
|$E716	| Write byte to screen.<br><br>Input: A = Byte to write.<br>Output: –<br>Used registers: –|
|$E8CB	| Check PETSCII code; if belongs to a color, set current color, at memory address $0286.<br><br>Input: –<br>Output: –<br>Used registers: A, X.|
|$E8EA	| Scroll complete screen upwards.<br><br>Input: –<br>Output: –<br>Used registers: A, X, Y.|
|$E965	| Insert line before current line and scroll lower part of screen downwards.<br><br>Input: –<br>Output: –<br>Used registers: A, X, Y.|
|$E9F0	| Set pointer at memory addresses $00D1-$00D2 to current line in screen memory, fetching high byte from table at memory addresses $00D9-$00F1.<br><br>Input: X = Row number.<br>Output: –<br>Used registers: A.|
|$E9FF	| Clear screen line.<br><br>Input: X = Row number.<br>Output: –<br>Used registers: A, Y.|
|$EA13	| Write character and color onto screen; set cursor phase delay to 2.<br><br>Input: A = Character to write; X = Color to write.<br>Output: –<br>Used registers: A, Y.|
|$EA24	| Set pointer at memory addresses $00F3-$00F4 to current line in Color RAM, according to pointer at memory addresses $00D1-$00D2 to current line in screen memory.<br><br>Input: –<br>Output: –<br>Used registers: –|



## Glossary
MSB
: most significant bit
Addressing Modes
: 
* Implied - No address.
  - Instructions like ASL, INX, or DEY do not affect any address in memory. No operand is required.
    ```
    ASL
    INX
    DEY
    ```
* Immediate - No address, but a value.
  - The operand of an immediate instruction is only one byte, and denotes a constant value.
    ```
    LDA #$06
    ORA #$9A
    AND #$7F
    ```
* Absolute - An address denoting a two-byte memory location.
  - The operand of an absolute instruction is two bytes, and denotes an address in memory.
    ```
    LDA $1234
    STA $4321
    JMP $C000
    ```
* Zeropage - An address denoting a one-byte memory location. ($00xx)
  - The operand of a zeropage instruction is one byte, and denotes an address in the zero page ($00xx).
    ```
    LDA $FB
    STA $FE
    CMP $FD
    ```
* Indexed - Denoting a range of 256 locations.
  - If an operand is indexed, then whatever index is specified is added to the address to get the real address.
    ```
    LDA $1234,X <- load A from $1234+the value in X
    STA $4321,Y <- store A to $4321+the value in Y
    LDA $FB,X <- load A from $00FB+the value in X
    ```
  There is a bug regarding indexing from zeropage- say our X value is 4. We try LDA $FE,X. Instead of loading from $0102, the counter will roll over and load from $0002 instead.
* Indirect - Denoting a location where the real two-byte address can be found.
  - The operand of an indirect address points to an address where the actual two-byte address is held. If we had the value $C000 in $1234, ($1234) would load the two-byte value from $1234 ($C000) as the real operand.
    ```
    JMP ($1234)
    ```
* Indexed Indirect
  - This mode points to an address in zeropage. Let's go through what it does-
    Say that at $FB, we have the value $2000 and we try:
    ```
    LDA ($FB),Y
    ```
    So, the CPU reads what address is at $FB- in our case, $2000. Then it adds the index to that value to get the real operand.
* Indirect Indexed
  - This mode again points to an address in zeropage.
    Say that at $F0, we had $2000, $3000, then $4000 and we try:
    ```
    LDA ($F0,X)
    ```
    The CPU reads what address is at $F0+whatever is in X. If X was 0, it'd get $2000. If 2, it'd get $3000. If 4, it'd get $4000.
* Relative - An offset locating an address, used in branches (see part 3).





## References
- (http://6502.org/source/)
- (https://codebase64.org/)  
- (https://www.c64-wiki.com/wiki/Memory_Map)
  - https://www.c64-wiki.com/wiki/Indirect-indexed_addressing
- [Vice Manual](https://vice-emu.sourceforge.io/vice_12.html)
[Commodore 64 standard KERNAL Functions](https://sta.c64.org/cbm64krnfunc.html)
[Screen Functions](https://sta.c64.org/cbm64scrfunc.html)
