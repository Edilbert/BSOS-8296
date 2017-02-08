BSOS
====

Enhanced operating system for the Commodore 8296(D) DIN version

Change your keyboard to the pictured layout for compatibility
with the new operating system BSOS. Just switch the keycaps
using a screwdriver.

![Keyboard](https://github.com/Edilbert/BSOS/blob/master/keyboard.jpg)

BSOS (Bit Shift Operating System) is an enhanced version of the
Commodore BASIC 4.0 operating system for CBM/PET 8296 computer
with the DIN keyboard.

You may try it with the emulator software VICE before changing your
real hardware.

The hardware change includes the replacement
of the ROM's/EPROM's for the basic/kernal, editor and character generator.
You'd need two 2532 EPROM's and one 27128 EPROM and an EPROM programmer.

The keyboard layout is changed too for the more convenient position
of the cursor keys in the lower right corner, as seen on the C64.

PATCHES APPLIED
===============

DOS parameter parser accepts 0-9 for drive value (original 0-1)
This allows BASIC4 to work with all 10 possible drives of petSD

DELETED FEATURES
================

All tape related code is removed in order to make room for improvements
The entry of diacritic characters is removed (accented letters etc.)

NEW MACHINE LANGUAGE MONITOR
============================

The machine language monitor TIM is replaced by BSM, the
Bit Shift Monitor. BSM has much more features, like assembler,
disassembler, access to other RAM banks, disk wedge and more.
The repository file "monitor.txt" contains the full documentation of BSM.

EDITING
=======

The ASCII characters {|}~ are added to the character set

```
CONTROL 7/      |
CONTROL 8(      {
CONTROL 9)      }
CONTROL .Pi     ~ 

CONTROL Y       scroll window up   (continuos BASIC listing)
CONTROL A       scroll window down (continuos BASIC listing)
CONTROL D       set screen to 25 rows (default)
CONTROL-SHIFT D set screen to 26 rows
```
The compatibility PET character set selected by SHIFT-CTRL-B remains
unchanged.


LOAD, SAVE, MERGE and VERIFY use unit 8 as default device

LOAD "filename",8,0  discards the load address and loads the file to $0401.
This enables the loading of C64 and other BASIC programs, which use different
start addresses for BASIC programs.

MERGE "filename",8,0  discards the load address and loads the file at
the end of the program in memory merging its contents. The merged
program must have all linenumbers greater than those of the program
in memory!

DLOAD, LOAD, MERGE and VERIFY display the start address of the program after the
word LOADING or VERIFYING, the progress during the LOAD and the end address+1
after finishing. This is especially useful for VERIFY, because the last
address displayed is exactly the position where the verifying fails, if it
is not successful. Also it always good to know, which memory is occupied by
the loaded program, especially if it is a machine language program being
loaded into high memory. Examples:

```
DLOAD "DC8050"
LOADING 0401-0BC9

MERGE "LIB"
LOADING 0BC7-1278

LOAD "POWER"
LOADING 9000-A000

VERIFY "BSOS BOOT"
VERIFYING 0401-041D
```

The Commodore Disk-Wedge is integrated, loosely based on Nils Eilers' code.

```
@                          read drive status
@command                   send dos command
@$                         directory
$                          directory
$0                         directory of drive 0
$0:pat*                    directory of files starting with "pat"
/prog                      load program prog
^prog                      load and run program prog
#9                         switch to unit 9
#                          display current unit
```

All wedge commands except '/' and '^' may also be used in TIM.

New BASIC commands
==================

```
DELETE from-to         ; Deletes a line range
FIND /text/            ; Lists all BASIC Lines containing 'text" token mode
FIND "text"            ; Lists all BASIC lines containing 'text' text mode
REPLACE !find!replace! ; Do a search & replace in token mode (any delimiter)
REPLACE "find"replace" ; Do a search & replace in text mode (" delimiter)
MONITOR                ; Calls TIM instead of breaking to it with SYS 1024
MERGE "filename",unit  ; Loads a program and merges it to an existing
RENUMBER new,inc,old   ; Renumbers a BASIC program
   The default values for new,inc,old are: 10,10,first line
   RENUMBER 1000,10  renumbers the whole program to linenumbers
      1000,1010,1020 etc.
```

Enhanced BASIC commands
=======================

```
COPY U8 TO U9          ; copies all files from D0,U8 to D0,U9
COPY "*",D1,U9 TO U8   ; copies all files from D1,U9 to D0,U8
COPY "R*",U10 TO U11   ; copies all files starting with 'R'
```

New Boot / Reset features
=========================

BSOS performs an undestructive RAM test after power up or reset.
This enables RAM inspection after a reset due to hangups.

Option ROM activation
=====================

BSOS checks the option ROM addresses $9000 and $A000 for the
identification string "BSOS". If present a JSR $9004 or
$A004 is executed. The option ROM routine may either return
with a RTS after doing its initializations or jump directly
to the BASIC_Ready address or stay inside the option ROM program.

Execute program from disk at boot or reset
==========================================

BSOS looks for a file "BSOS BOOT" at unit 8 during startup.
If present, it is loaded and run after system initialization.
