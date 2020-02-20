; ****************************************************
; * Complete Commodore 8296 Operating System & BASIC *
; ****************************************************

; Use the Bit Shift Assembler "bsa" for assembly of this source

* = $b000   ; *** b000 ***  Commodore 8296

.STORE $B000, $1000, "b000.basic"
.STORE $C000, $1000, "c000.basic"
.STORE $D000, $1000, "d000.basic"
.STORE $E000, $1000, "e000.edit"
.STORE $F000, $1000, "f000.kernal"

BSOS_KBD = 1

; revision 1.12 10-Jan-2020
; -------------------------
; implement vector table for extension interception

; revision 1.11 08-Jan-2020
; -------------------------
; enhance DELETE commnd
; implement OLD command

; revision 1.10 09-Oct-2015
; -------------------------
; optimize garbage collection
; implement REPLACE command
; implement 26 rows mode

; revision 1.09 10-Sep-2015
; -------------------------
; optimize BASIC routines Scan_Linenumber and Basic_LIST
; in order to make parts of them callable subroutines
; These routines are used in the assembler and power scrolling

; revision 1.08 04-Aug-2015
; -------------------------
; Implement conditional code for original keyboard layout
; or BSOS keyboard layout (BSOS_KBD)

; revision 1.07 04-Aug-2015
; -------------------------
; Implement ML Disassembler

; revision 1.06 29-Jul-2015
; -------------------------
; Check disk error after trying to boot from disk

; revision 1.05 19-Jan-2015
; -------------------------
; Detect and activate option ROM's
; Detect and run "BSOS BOOT" during boot
; Non desctructive RAM test
; Optimization of BSM LOAD/SAVE

; revision 1.03 29-Dec-2014
; -------------------------
; Add unit to unit capability to the COPY command

; revision 1.02 23-Dec-2014
; -------------------------
; Fix bug in DSAVE/DOPEN (Save and Replace bug)
; Optimize DOS Parameter Parser

; revision 1.01 14-Dec-2014
; -------------------------
; Add support for Nils Eilers' SoftROM
; The LOAD and DLOAD routines may be used to load data files
; directly into the address range $9000 - $AFFF. This works well
; for RAM or SoftROM (which in fact is flashed) installed there.

; revision 1.00 30-Nov-2014
; -------------------------
; First public release

; The operating system and BASIC interpreter is stored on two chips:

; The editor is stored on a 2332 (4KB) ROM (or 2532 EPROM) for the
; address range $E000 - $EFFF. The range $E800 - $E8FF is reserved
; for I/O and is not accessible

; The remaining code is stored on a 23128 (16KB) ROM (or 27128 EPROM):
; The address ranges are: $C000 $D000 $B000 $F000

; So after assembling you can prepare the EPROM images by using
; 1) e000.edit for a 2532 EPROM
; 2) cat c000.basic d000.basic b000.basic f000.kernal >os8296.rom
;    and use os8296.rom then for a 27128 EPROM

; PATCHES APPLIED
; ===============

; DOS parameter parser accepts 0-9 for drive value (original 0-1)
; This allows BASIC4 to work with all 10 possible drives of petSD

; The BSM memory display and modifier uses 16 bytes per line

; DELETED FEATURES
; ================

; All tape related code is removed
; The entry of diacritic characters is removed (accented letters etc.)

; NEW FEATURES
; ============

; The COPY command accepts different units for source and target
; The full syntax is (s = source, t = target):
; COPY Ds,"filepattern",Us TO Dt,Ut
; The D(rive) parameter defaults to D0 if not specified
; The U(nit)  parameter defaults to U8 if not specified
; Examples:
;
; COPY U8 TO U9           copies all files from D0,U8 to D0,U9
; COPY D1,U8 TO D2,U10    copies all files from D1,U8 to D2,U10
; COPY "*" TO U11         copies all files from D0,U8 to D0,U11
; COPY D1,"A*" TO U10     copies all files beginning with A

; restrictions:
; Currently REL files are not supported.
; It is is not possible to give a different name for the target file,
; use the RENAME command if necessary

; The machine language monitor BSM can now display memory from other banks.
; The new command ".b" (set Bank) stores a byte for the bank register.
; This affects the memory display for the asddress range $8000 - $ffff.
; Common values for the bank register are:

; .b 00    : system bank (screen RAM, ROM, I/O)
; .b 80    ; RAM bank 0/2 in $8000 - $ffff
; .b 8c    ; RAM bank 1/3 in $8000 - $ffff

; BSM includes a disassembler:

; .d f5c2 f5ef     disassemble the given range
; .d f5c2          disassemble 10 statements starting with $f5c2
; .d               Disassemble next 10 statements

; EDITING
; =======

; The editor scrolls the BASIC listing upwards or downwards if the
; cursor is moved up on the top line or down on the bottom line
; The idea (not the code) is taken from Brad Templeton's POWER ROM
; The character set is expanded with the missing ASCII characters {|}~ 
; These can be used by pressing the CONTROL key together with:
; CONTROL 7/      |
; CONTROL 8(      {
; CONTROL 9)      }
; CONTROL .Pi     ~ 

; LOAD, SAVE and VERIFY use now unit 8 as default device

; LOAD "filename",8,0 forces the file to load to $0401
; this enables the loading of C64 and other BASIC programs, which use
; different start addresses for BASIC programs.

; The Disk-Wedge is integrated, loosely based on Nils Eilers' code.

; @                          read drive status
; @command                   send dos command
; @$                         directory
; $                          directory
; $0                         directory of drive 0
; $0:pat*                    directory of files starting with "pat"
; /prog                      load program prog
; ^prog                      load and run program prog
; #9                         switch to unit 9
; #                          display current unit

; New commands added:

; DELETE from-to       ; Deletes a line range
;   DELETE 500-700 deletes all lines in this range
; FIND "text"          ; lists all lines with strings containing <text>
; FIND /text/          ; lists all lines with BASIC   containing <text>
;                      ; any character may be used as delimiter
; MONITOR              ; Calls BSM
; RENUMBER new,inc,old ; Renumbers a BASIC program
;    The default values for new,inc,old are: 10,10,first line
;    RENUMBER 1000,10  renumbers the whole program to linenumbers
;       1000,1010,1020 etc.

; BSOS uses a vector table for important functions like C64, C128.
; This enables the interception for BASIC language extensions
; The names and addresses are the same as in the C128 BASIC.

  IERROR  = $0300     ; DEF_ERROR   BASIC error handler
  IMAIN   = $0302     ; DEF_MAIN    BASIC main loop
  ICRNCH  = $0304     ; DEF_CRUNCH  BASIC tokenizer
  IQPLOP  = $0306     ; DEF_QPLOP   BASIC statement lister
  IGONE   = $0308     ; DEF_GONE    BASIC interpret statement
  IEVAL   = $030a     ; DEF_EVAL    BASIC evaluate expression

; **********************
; BASIC scalar variables
; **********************

; ---------+-----+-----+-----+-----+-----+-----+-----+-----
; Type     | Exa.|  0  |  1  |  2  |  3  |  4  |  5  |  6
; ---------+-----+-----+-----+-----+-----+-----+-----+-----
; Float    | AB  |  A  |  B  | EXP | MSB | MAN | MAN | LSB
; ---------+-----+-----+-----+-----+-----+-----+-----+-----
; Integer  | AB% |  A^ |  B^ | MSB | LSB |  0  |  0  |  0
; ---------+-----+-----+-----+-----+-----+-----+-----+-----
; Function | AB( |  A^ |  B  | LFP | MFP | LBP | MBP | ARG
; ---------+-----+-----+-----+-----+-----+-----+-----+-----
; String   | AB$ |  A  |  B^ | LEN | LSP | MSP |  0  |  0
; ---------+-----+-----+-----+-----+-----+-----+-----+-----

; ************
; BASIC arrays
; ************

; ---------+-----+-----+-----+---------------+
; Type     | Exa.|  0  |  1  |  Element Size |
; ---------+-----+-----+-----+---------------+
; Float    | AB  |  A  |  B  |       5       |
; ---------+-----+-----+-----+---------------+
; Integer  | AB% |  A^ |  B^ |       2       |
; ---------+-----+-----+-----+---------------+
; String   | AB$ |  A  |  B^ |       3       |
; ---------+-----+-----+-----+---------------+

; The circumflex ^ indicates characters OR'ed with $80

; Array header:

; Byte  0   : 1st. character of name
; Byte  1   : 2nd, character of name
; Byte  2-3 : length of array including header in bytes
; Byte  4   : dimension count
; Byte  5-6 : Hi/Lo elements of 1st. dimension, (e.g. 11 for dim a(10)
; Byte  7-8 : Hi/Lo elements of 2nd. dimension if dimension count > 1
; Byte  x-x : Two bytes for each dimension

; *******
; Equates
; *******

CTRLA     = $01 ; scroll window down
CTRLB     = $02 ; switch character ROM
CTRLD     = $04 ; toggle display size between 25 or 26 rows
BELL      = $07 ; chime
TAB       = $09
CR        = $0d
CTRLN     = $0e ; switch to text mode
CTRLO     = $0f ; set top left window corner
DOWN      = $11
RVS       = $12
HOME      = $13
DEL       = $14
CTRLU     = $15
CTRLV     = $16
CTRLY     = $19
ESC       = $1b
RIGHT     = $1d
QUOTE     = $22

; These locations contain the JMP instruction and target address of the
; USR command. They are initialised so that if you try to execute a USR
; call without changing them you will receive an ILLEGAL QUANTITY error
; message.

Basic_USR = $00               ; initialized to $4c the code for JMP
USRVEC    = $01               ; initialized to $c373 (Illegal_Quantity)

CHARAC    = $03               ; search character
ENDCHR    = $04               ; scan quotes flag
COUNT     = $05               ; line crunch/array access/logic operators

; This is used as a flag by the routines that build an array or
; reference an existing array. It is used to determine whether a
; variable is in an array, whether the array has already been
; DIMensioned, and whether a new array should assume default size.

DIMFLG    = $06               ; DIM flag

; This flag is used to indicate whether data being operated upon is
; string or numeric. A value of $FF in this location indicates string
; data while a $00 indicates numeric data.

VALTYP    = $07               ; data type, $FF = string, $00 = numeric

; If the above flag indicates numeric then a $80 in this location
; identifies the number as an integer, and a $00 indicates a floating
; point number.

INTFLG    = $08     ; data type flag, $80 = integer, $00 = floating pt.

; The garbage collection routine uses this location as a flag to
; indicate that garbage collection has already been tried before adding
; a new string. If there is still not enough memory, an OUT OF MEMORY
; error message will result.

; LIST uses this byte as a flag to let it know when it has come to a
; character string in quotes. It will then print the string,rather than
; search it for BASIC keyword tokens.

; This location is also used during the process of converting a line of
; text in the BASIC input buffer into a linked program line of BASIC
; keyword tokens to flag a DATA line is being processed.

GARBFL    = $09     ; garbage collected/open quote/DATA flag

; This flag is set from the routines handling FOR, DEF and FN
; statements. Names for loop indices and function names must not be
; integer. Only identifiers of type real are allowed.

SUBFLG    = $0a     ; subscript/FNx flag

; input mode, $00 = INPUT, $40 = GET, $80 = READ

INPFLG    = $0b     ; input mode, $00 = INPUT, $40 = GET, $98 = READ

; This location is used to determine whether the sign of the value
; returned by the functions SIN, COS, ATN or TAN is positive or negative
; Also the comparison routines use this location to indicate the outcome
; of the compare. For A <=> B the value here will be $01 if A > B,
; $02 if A = B, and $04 if A < B. If more than one comparison operator
; was used to compare the two variables then the value here will be a
; combination of the above values.

TANSGN    = $0c     ; ATN sign/comparison evaluation flag

; Disk status or temporary string descriptor

DS_Len    = $0d     ; unused
DS_Ptr    = $0e     ; unused

; When the default input or output device is used the value here will
; be a zero, and the format of prompting and output will be the standard
; screen output format. The location $B8 is used to decide what device
; actually to put input from or output to.

IOPMPT    = $10     ; current I/O channel

; Used whenever a 16 bit integer is used e.g. the target line number for
; GOTO, LIST, ON, and GOSUB also the number of a BASIC line that is to
; be added or replaced. additionally PEEK, POKE, WAIT, and SYS use this
; location as a pointer to the address which is the subject of the
; command.

LINNUM = $11        ; line number

; This location points to the next available slot in the temporary
; string descriptor stack located at TEMPST ($16-$1e).

TEMPPT = $13        ; descriptor stack pointer, next free

; This contains information about temporary strings which have not yet
; been assigned to a string variable.

LASTPT = $14        ; current descriptor stack item pointer

; Stack for temporary string descriptors
; String 1: $16-$18
; String 2: $19-$1b
; String 3: $1c-$1e

TEMPST = $16        ; temporary descriptor stack

; miscellaneous pointer / word used in many BASIC routines

INDEXA = $1f        ; miscellaneous pointer

; miscellaneous pointer / word used in many BASIC routines

INDEXB = $21

; above address shared with RENUMBER as increment value

RENINC = $21        ; RENUMBER increment value

; Floating point accumulator #3 (mantissa only)

FAC3M1 = $23        ; mantissa byte 1 MSB
FAC3M2 = $24        ; mantissa byte 2
FAC3M3 = $25        ; mantissa byte 3
FAC3M4 = $26        ; mantissa byte 4 LSB

FAC3M5 = $27        ; unused

; FAC3 addresses shared with RENUMBER as start value for line numbers

RENNEW = $23        ; RENUMBER new line number start

; Start of BASIC program - initialized to $0401

TXTTAB = $28        ; Text Table

; Two byte pointer to the start of the BASIC variable storage area.

VARTAB = $2a        ; Variable table

; Two byte pointer to the start of the BASIC array storage area.

ARYTAB = $2c        ; Array table

; Two byte pointer to end of the start of free RAM.

STREND = $2e        ; String end

; Two byte pointer to the highest address used by BASIC +1.

FRETOP = $30        ; top of BASIC memory

; Two byte pointer to the bottom of the string text storage area.

FRESPC = $32        ; bottom of string space

; Two byte pointer to the highest RAM address

MEMSIZ = $34        ; top of RAM

; These locations contain the line number of the BASIC statement which
; is currently being executed. A value of $FF in location $3A means that
; BASIC is in immediate mode.

CURLIN = $36        ; current line number

; When program execution ends or stops the last line number executed is
; stored here.

OLDLIN = $38        ; break line number

; These locations contain the address of the start of the text of the
; BASIC statement that is being executed.  The value of the pointer to
; the address of the BASIC text character currently being scanned is
; stored here each time a new BASIC statement begins execution.

OLDTXT = $3a        ; continue pointer

; These locations hold the line number of the current DATA statement
; being READ. If an error concerning the DATA occurs this number will
; be moved to $39/$3A so that the error message will show the line that
; contains the DATA statement rather than in the line that contains the
; READ statement.

DATLIN = $3c        ; current DATA line number

; These locations point to the address where the next DATA will be READ
; from. RESTORE sets this pointer back to the address indicated by the
; start of BASIC pointer.

DATPTR = $3e        ; DATA pointer

; READ, INPUT and GET all use this as a pointer to the address of the
; source of incoming data, such as DATA statements, or the text input
; buffer.

INPPTR = $40        ; READ pointer

; Two bytes storing the name of a BASIC variable as ASCII values
; The combination of the two bits 7 determines the type
; ---------------------------------------------
; Real    : AB      = $41 $42 = 'A'     'B'
; Function: FNAB()  = $c1 $42 = 'A'+$80 'B'
; String  : AB$     = $41 $c2 = 'A'     'B'+$80
; Integer : AB%     = $c1 $c2 = 'A'+$80 'B'+$80

VARNAM = $42        ; current variable name

; These locations point to the value of the current BASIC variable.
; Specifically they point to the byte just after the two-character
; variable name.

VARPTR = $44        ; current variable address

; The address of the BASIC variable which is the subject of a FOR/NEXT
; loop is first stored here before being pushed onto the stack.

FORPNT = $46        ; FOR/NEXT variable pointer

; The expression evaluation routine creates this to let it know whether
; the current comparison operation is a < $01, = $02 or > $04 comparison
; or combination.

YSAVE  = $48        ; BASIC execute pointer temporary/precedence flag

; used to compare the variable type on both sides of an operator

ACCSYM = $4a        ; comparison evaluation flag

; These locations are used as a pointer to the function that is created
; during function definition. During function execution it points to
; where the evaluation results should be saved.

FUNCPT = $4b        ; FAC temp store/function/variable/garbage pointer

; Temporary Pointer to the current string descriptor.

DESCPT = $4d        ; FAC temp store/descriptor pointer

; Temporary pointer used in subroutines

INDEXC = $4f

; The first byte is the 6502 JMP instruction $4C, followed by the
; address of the required function taken from the table at $B000.

JUMPER = $51         ; JMP opcode for functions

; Used as jump address for previous opcode
; Several uses as temporary storage in BASIC routines

FUNJMP = $52         ; functions jump vector

; Temporary storage for floating point values (5 bytes)
; and temporary pointer (block pointer, array pointer)

FACTPA = $54         ; FAC temp store ($54 - $58)
TMPPTA = $55         ; temp pointer A
TMPPTB = $57         ; temp pointer B

; Temporary storage for floating point values (5 bytes)
; and temporary variables

FACTPB = $59         ; FAC temp store ($59 - $5d)
TMPVAR = $5a         ; temporary variable
TMPPTC = $5c         ; temporary pointer

; Floating point accumulator 1

FAC1EX = $5e         ; FAC1 exponent
FAC1M1 = $5f         ; FAC1 mantissa 1
FAC1M2 = $60         ; FAC1 mantissa 2
FAC1M3 = $61         ; FAC1 mantissa 3
FAC1M4 = $62         ; FAC1 mantissa 4
FAC1SI = $63         ; FAC1 sign
SGNFLG = $64         ; constant count/negative flag

BITS   = $65         ; unused

; Floating point accumulator 2

FAC2EX = $66         ; FAC2 exponent
FAC2M1 = $67         ; FAC2 mantissa 1
FAC2M2 = $68         ; FAC2 mantissa 2
FAC2M3 = $69         ; FAC2 mantissa 3
FAC2M4 = $6a         ; FAC2 mantissa 4
FAC2SI = $6b         ; FAC2 sign

; String pointer and FAC sign comparison and FAC rounding

STRPTR = $6c         ; string pointer & FAC variables

; this address is sometimes used as high btye for the STRPTR
; and as rounding byte (5th. byte of mantissa) for FAC1

FROUND = $6d         ; FAC1 mantissa 5 = rounding byte

; Temporary pointer and index used in many BASIC routines

TMPPTD = $6e         ; temp BASIC execute/array pointer low byte/index

; Basic CHRGET (with increment) and CHRGOT (no increment) routine
; Also ISNUM for check if character is numeric
; Copied to this location from CHRGET_ROM at $d399
;
; 0070 e6 77     CHRGET    INC TXTPTR
; 0072 d0 02               BNE CHRGOT
; 0074 e6 78               INC TXTPTR+1
; 0076 ad 60 ea  CHRGOT    LDA $ffff       ; modified by previous code
; 0079 c9 3a               CMP #':'        ; check of end of statement
; 007b b0 0a               BCS CHRRET
; 007d c9 20     ISNUM     CMP #' '        ; skip blanks
; 007f f0 ef               BEQ CHRGET
; 0081 38                  SEC
; 0082 e9 30               SBC #'0'
; 0084 38                  SEC
; 0085 e9 d0               SBC #$d0
; 0087 60        CHRRET    RTS

CHRGET = $70        ; Get program byte with pointer pre increment
CHRGOT = $76        ; Get program byte
TXTPTR = $77        ; Pointer to current program byte
ISNUM  = $7d        ; Check for numeric digit

; Random seed, five bytes ($88 - $8c)

RNDX   = $88        ; Random seed

; These three locations form a counter which is updated 60 times a
; second, and serves as a software clock which counts the number of
; jiffies that have elapsed since the computer was turned on.
; European computers running at 50 Hz add an additional count every
; 5th. jiffy in order to compensate the lower interrupt frequency.
; After 24 hours and one jiffy these locations are set back to $000000.

JIFFY_CLOCK = $8d   ; Count jiffies (1/60 seconds)

; Vector, which may be used to redirect the interrupt routine.
; It is initialized to IRQ_NORMAL ($e455), which handles updating
; the jiffy clock, blinking the cursor and scanning the keyboard
; ROM's with tape routines switch this vector during tape activities
; to routines handling write to tape or read from tape.

CINV   = $90        ; IRQ vector (IRQ_NORMAL)

; Vector, which may be used to redirect the break routine.
; The break routine is called after executing the BRK ($00) command
; either by intention or accidentally due to an error.
; It is initialized to MONITOR_BREAK ($d467), which saves the contents
; of all registers and starts BSM, the Bit Shifter Monitor.

CBINV  = $92        ; BRK vector (MONITOR_BREAK)

; Vector, which may be used to redirect the Non Maskable Interrupt.
; It is intialized to Basic_Reday ($b3ff).

NMINV  = $94        ; NMI vector (Basic_Reday)

; The STATUS byte is used to flag I/O errors or End-Of-Information
; A bit set to 1 indicates foloowing conditions:

; bit 0 : time out write
; bit 1 : time out read
; bit 4 : verify error
; bit 6 : EOI (End Of Information)
; bit 7 : device not present

STATUS = $96        ; Status byte for I/O operations

; Key_Index is used in the subroutine EDIT_KEY_SCAN
; It holds the index for the character tables or -1 ($ff) for no key

Key_Index = $97     ; Key index for character lookup

; The keyflags are used to select the character lookup table for
; NORMAL, SHIFTED or CONTROL.
; Flags are set by setting the corresponding bit to 0

; bit 7:  0 = <shift>
; bit 6:  0 = <control>

Key_Flags = $98

; The power flag activates power scrolling (continuous scrolling)
; when set. It is active in direct mode and inactive in run mode.
; Bit 7 $80 activates BASIC editor scrolling
; Bit 6 $40 activates Monitor scrolling

Power_Flag = $99    ; $00 = power srolling off

; The default bank holds the configuration for the bank register $FFF0
; If the operating system runs from ROM its value is $00
; Loadable BSOS runs for configuration $ec

Default_Bank = $9a  ; $00 = OS running in ROM

; The Stop_Flag is set by the keyboard scan routine
; $ff = no STOP key pressed, $ef = STOP key pressed

Stop_Flag = $9b     ; $ef = 1110 1111 flags STOP key pressed

; Originally used as variable SVXT for tape routines
; Mow used by Parse_DOS_Parameter

Source_Unit = $9c   ; Source unit for COPY command

; VERCK flags LOAD (0) or VERIFY ($80) mode for the load routines
; MERGE uses the value $40

VERCK         = $9d ; LOAD or VERIFY flag

; Counter for the number of keys in keyboard buffer

CharsInBuffer = $9e ; number of keys buffered

; Flag indicating reverse mode for screen output

ReverseFlag  = $9f  ; 0 = normal   non zero = reverse

; IEEE-488 output: deferred character flag

C3PO         = $a0  ; 0 = no character waiting, $ff = character waiting

LastInputCol = $a1  ; screen input stops reading at LastInputVol
InputRow     = $a3  ; store screen input row number (0-24)
InputCol     = $a4  ; store screen input column (0-79)

; The IEEE-488 output routine CIOUT delays the output by one character,
; which is stored in BSOUR. CIOUT checks on each call, if a character
; is stored in BSOUR for transmisson, by testing the flag C3PO.
; If C3PO is negative, the character in BSOUR is sent and the actual
; character is stored in BSOUR. If BSOUR is empty (C3PO == 0), the only
; action is storing the actual character in BSOUR and making C3PO
; negative. The delay in sending makes it possible  to send the
; EOI (End Of Information) along with the last character to transmit.

BSOUR  = $a5        ; IEEE-488  output: deferred character (buffer)

; The keyscan interrupt routine uses this location to indicate which key
; is currently being pressed. The value here is then used as an index
; into the appropriate keyboard table to determine which character to
; print when a key is struck.
; The correspondence between the key pressed and the number stored here
; is as follows:

; $00          $10   2      $20   4      $30   6       $40   9
; $01          $11  [DOWN]  $21   UE     $31   AE      $41
; $02   sz     $12          $22   O      $32   L       $42  [HOME]
; $03  [DEL]   $13   0      $23   [      $33  [RETURN] $43   7
; $04   9      $14   ,      $24   U      $34   J       $44   0
; $05   6      $15   N      $25   T      $35   G       $45   7
; $06   3      $16   V      $26   E      $36   D       $46   4
; $07   <   ]  $17   Y      $27   Q      $37   A       $47   1
; $08   1      $18   3      $28   ]      $38   5       $48
; $09          $19  [SHIFT] $29   P      $39   OE      $49
; $0A          $1A          $2A   I      $3A   K       $4a  [STOP]
; $0B  [RIGHT] $1B   .      $2B   +      $3B   #       $4b   8
; $0C   M      $1C   .      $2C   Z      $3C   H       $4c   ´
; $0D  [SPACE] $1D   B      $2D   R      $3D   F       $4d   9
; $0E   X      $1E   C      $2E   W      $3E   S       $4e   6
; $0F  [CTRL]  $1F  [SHIFT] $2F  [TAB]   $3F  [ESC]    $4f   3

SFDX   = $a6         ; which key

; When this flag is set to a nonzero value, it indicates to the routine
; that normally flashes the cursor not to do so. The cursor blink is
; turned off when there are characters in the keyboard buffer, or when
; the program is running.

BLNSW   = $a7        ; cursor enable, $00 = flash cursor

; The routine that blinks the cursor uses this location to tell when
; it's time for a blink. The number 20 is put here and decremented every
; jiffy until it reaches zero. Then the cursor state is changed, the
; number 20 is put back here, and the cycle starts all over again.

BLNCT   = $a8

; The cursor is formed by printing the inverse of the character that
; occupies the cursor position. If that characters is the letter A, for
; example, the flashing cursor merely alternates between printing an A
; and a reverse-A. This location keeps track of the normal screen code
; of the character that is located at the cursor position, so that it
; may be restored when the cursor moves on.

GDBLN  = $a9         ; character under cursor

; This location keeps track of whether, during the current cursor blink,
; the character under the cursor was reversed, or was restored to
; normal. This location will contain 0 if the character is reversed, and
; 1 if the character is not reversed.

BLNON  = $aa         ; cursor blink phase

; The current unit number for wedge commands is held in Wedge_Unit
; It is initialized to 8 and can be changed with #<unit>

Wedge_Unit = $ab     ; current device for DOS wedge commands

; input from keyboard or screen, $xx = input is available from the
; screen, $00 = input should be obtained from the keyboard

CRSW   = $ac         ; input from keyboard or screen

Target_Unit = $ad    ; used by DOS Copy

; The number of currently open I/O files is stored here. The maximum
; number that can be open at one time is ten. The number stored here is
; used as the index to the end of the tables that hold the file numbers,
; device numbers, and secondary addresses.

LDTND  = $ae         ; open file count

; The default value of this location is 0.

DFLTN  = $af         ; input device number

; The default value of this location is 3.

DFLTO  = $b0         ; output device number

                     ; number   device
                     ; ------   ------
                     ;  0      keyboard    - input only
                     ;  1      cassette #1 - disabled in BSOS
                     ;  2      cassette #2 - disabled in BSOS
                     ;  3      screen      - input / output
                     ;  4-31   IEEE-488 bus

DOS_FC     = $b1     ; used for DOS_Copy
DOS_EOF    = $b2     ; used for DOS_Copy
PC_Adjust  = $b3     ; used in monitor
SCROLLING  = $b4     ; unused
MONCNT     = $b5     ; BSM counter variable

; Theses variables are used to store the value for the bank switching
; register while performing the RENUMBER command.

R_Bank     = $b6     ; Read  Bank value for bank switching
W_Bank     = $b7     ; Write Bank value for bank switching
ZP_b8      = $b8     ; unused
DOS_RL     = $b9     ; used for DOS_Copy
Dis_Line   = $ba     ; Disassembler
DosPtr     = $bb     ; used for DS$
Mon_Format = $bd     ; Disassembler
Dis_Length = $be     ; Disassembler
Mon_A      = $bf     ; Disassembler
Mon_B      = $c0     ; Disassembler
Mon_Op     = $c1     ; Disassembler
Mon_Lo     = $c2     ; Disassembler
Mon_Hi     = $c3     ; Disassembler

; The Screen Pointer ScrPtr contains the screen memory address
; of the current cursor position

ScrPtr     = $c4      ; screen pointer ($8000 - $87cf)
CursorCol  = $c6      ; cursor column (0 - 79)

SAL        = $c7      ; used for windows scrolling
EAL        = $c9      ; used for LOAD, SAVE and BSM

Mon_Tmp    = $cb      ; Monitor temporary
Mon_ZP     = $cc      ; Monitor ZP flag

; A nonzero value in this location indicates that the editor is in quote
; mode. Quote mode is toggled every time that you type in a quotation
; mark on a given line, the first quote mark turns it on, the second
; turns it off, the third turns it on, etc.

; If the editor is in this mode when a cursor control character or other
; nonprinting character is entered, a printed equivalent will appear on
; the screen instead of the cursor movement or other control operation
; taking place. Instead, that action is deferred until the string is
; sent to the string by a PRINT statement, at which time the cursor
; movement or other control operation will take place.

; The exception to this rule is the DELETE key, which will function
; normally within quote mode. The only way to print a character which is
; equivalent to the DELETE key is by entering insert mode. Quote mode
; may be exited by printing a closing quote or by hitting the RETURN or
; SHIFT-RETURN or ESC keys.

QTSW   = $cd        ; quote switch non zero:inside quotes

BITTS  = $ce        ; unused (transmitter byte buffer)
EOT    = $cf        ; unused (end of tape)
ZD0    = $d0        ; unused

FNLEN  = $d1        ; Length of filename - for file open and DOS
LA     = $d2        ; Local     Address
SA     = $d3        ; Secondary Address
FA     = $d4        ; First     Address

RigMargin  = $d5    ; right margin of window (0 - 79)
TAPE1      = $d6    ; unused
CursorRow  = $d8    ; current corsor row
DATAX      = $d9    ; temprary storage
FNADR      = $da    ; file name address
INSRT      = $dc    ; # of inserts outstanding
ROPRTY     = $dd    ; unused
FSBLK      = $de    ; unused
ScreenRows = $df    ; current screen rows - 1 (24 or 29)
TopMargin  = $e0    ; bottom margin of window (0 - screenrows-1)
BotMargin  = $e1    ; top margin of window
LefMargin  = $e2    ; left margin of window
XMAX       = $e3    ; length of keyboard buffer-1 = 9
LSTX       = $e4    ; last key pressed
KOUNT      = $e5    ; repeat speed counter
DELAY      = $e6    ; repeat delay
CHIME      = $e7    ; chime counter

; save the last character processed by Edit_CHROUT in PrevChar
; this is used to identify the seuence <HOME><HOME>, which resets
; the window to full screen

PrevChar   = $e8    ; used for key press repetion
SCRIV      = $e9    ; EDIT_CHRIN vector
SCROV      = $eb    ; EDIT_CHROUT vector
JIFFY6     = $f8    ; 50Hz jiffy clock compensation counter
BPTR       = $f9    ; multi purpose
STAL       = $fb    ; start address
MEMUSS     = $fd    ; end   address

; the bottom of the stack is used from the BASIC formatting routine
; which converts numbers to strings.
; The 4 top addresses $01fc-$01ff are used by the BASIC tokenizer
; for storing link and line number of an entered BASIC line,
; so the usable stack range is limited to $0110 - $01fb.
; BASIC initializes the stack pointer to $fa

STACK      = $0100

; The input buffer accepts input lines with a maximum of 80 characters
; It is also used as workspace for the BASIC tokenizer.

BUF        = $0200

LAT        = $0251  ; Logical Address Table
FAT        = $025b  ; First   Address Table (unit / device)
SAT        = $0265  ; Second  Address Table
KEYD       = $026f  ; keyboard buffer (10 byte)

; Commodore BASIC 4 used the area $027a - $0339
; as buffer for tape operations (TAPE1 buffer)
; BSOS has no TAPE routine and uses it for storing routines
; for accessing memory at different banks. These routines must
; be located at low RAM, because the ROM area is switched off
; while accessing High RAM.
; The area is used by the Monitor and RENUMBER command only.

Bank_Store = Bank_Fetch + Bank_Store_Start - Bank_Fetch_Start
Bank_Fetch     = $027a
Mon_Register   = $02a0
Dis_Buf_Length = $02b0
Dis_Buf        = $02b1
Ass_Buf_Length = $02c0
Ass_Buf        = $02c1
Ass_Index      = $02d0

; jump vector table for interception of BASIC routines
; position and named like the C128 table

IERROR  = $0300     ; DEF_ERROR   BASIC error handler
IMAIN   = $0302     ; DEF_MAIN    BASIC main loop
ICRNCH  = $0304     ; DEF_CRUNCH  BASIC tokenizer
IQPLOP  = $0306     ; DEF_QPLOP   BASIC statement lister
IGONE   = $0308     ; DEF_GONE    BASIC interpret statement
IEVAL   = $030a     ; DEF_EVAL    BASIC evaluate expression

; The area $033a - $03c9 was the tape buffer 2 on BASIC 2
; BASIC 4 uses this area for variables and buffers related to the
; BASIC 4 disk commands, like DOPEN, DCLOSE, DIRECTORY, etc.

DOS_Tmp     = $033a
DOS_Drive_1 = $033b
DOS_Drive_2 = $033c
DOS_Attr    = $033d

; DOS_flags for parsing BASIC 4 DOS commands

; bit 0: $01 = source Filename given
; bit 1: $02 = target Filename given
; bit 2: $04 = logical address set in LA
; bit 3: $08 = primary address set in FA
; bit 4: $10 = drive 1 set
; bit 5: $20 = drive 2 set
; bit 6: $40 = W (Write) or L (Relative file) given
; bit 7: $80 = Save and replace flag '@'

DOS_Flags          = $033e
DOS_Id             = $033f
DOS_Command_Length = $0341
DOS_Filename       = $0342
DOS_Command_Buffer = $0353
DOS_Status         = $03ad
TABS_SET           = $03ee    ; 80 bits TAB table
Reset_Vector       = $03fa    ; set but unused
Ignore_Timeout     = $03fc

SCREEN_RAM         = $8000

; *****************************
; MCS 6520 Peripheral Adapter 1
; *****************************

;  #| Adr. |Bit7|Bit6|Bit5|Bit4|Bit3|Bit2|Bit1|Bit0| Function
; --+------+----+----+----+----+----+----+----+----+------------
;  0| E810 |CASR| EOI|    |    |Select Keyboard Row| PIA1_Port_A
; --+------+----+----+----+----+----+----+----+----+------------
;  1| E811 |  0 |  0 |  1 |  1 |  1 |  x |  0 |  0 | PIA1_Cont_A
; --+------+----+----+----+----+----+----+----+----+------------
;  2| E812 |          Keyboard Row (8 keys)        | PIA1_Port_B
; --+------+----+----+----+----+----+----+----+----+------------
;  3| E813 |  0 |  0 |  1 |  1 |  1 |  1 |  0 |  1 | PIA1_Cont_B
; --+------+----+----+----+----+----+----+----+----+------------

PIA1_Port_A = $e810
PIA1_Cont_A = $e811
PIA1_Port_B = $e812
PIA1_Cont_B = $e813

; *****************************
; MCS 6520 Peripheral Adapter 2
; *****************************

;  #| Adr. |Bit7|Bit6|Bit5|Bit4|Bit3|Bit2|Bit1|Bit0| Function
; --+------+----+----+----+----+----+----+----+----+------------
;  0| E820 |             IEEE-488 DATA IN          | PIA2_Port_A
; --+------+----+----+----+----+----+----+----+----+------------
;  1| E821 |    |    |    |    |NDAC|    |    |    | PIA2_Cont_A
; --+------+----+----+----+----+----+----+----+----+------------
;  2| E822 |             IEEE-488 DATA OUT         | PIA2_Port_B
; --+------+----+----+----+----+----+----+----+----+------------
;  3| E823 | SRQ|    |    |    | DAV|    |    |    | PIA2_Cont_B
; --+------+----+----+----+----+----+----+----+----+------------

PIA2_Port_A = $e820
PIA2_Cont_A = $e821
PIA2_Port_B = $e822
PIA2_Cont_B = $e823

; ************************************
; MCS 6522 Versatile Interface Adapter
; ************************************

;  #| Adr. |Bit7|Bit6|Bit5|Bit4|Bit3|Bit2|Bit1|Bit0| Function
; --+------+----+----+----+----+----+----+----+----+--------------
;  0| E840 | DAV|NRFD|    |    |    | ATN|NRFD|NDAC| Port_B
; --+------+----+----+----+----+----+----+----+----+--------------
;  1| E841 |              User-Port                | Port_A
; --+------+----+----+----+----+----+----+----+----+--------------
;  2| E842 |  0 |  0 |  0 |  1 |  1 |  1 |  1 |  0 | DDR_B
; --+------+----+----+----+----+----+----+----+----+--------------
;  3| E843 |       User-Port Data Direction        | DDR_A
; --+------+----+----+----+----+----+----+----+----+--------------
;  4| E844 |    |    |    |    |    |    |    |    | Timer 1 low
; --+------+----+----+----+----+----+----+----+----+--------------
;  5| E845 |    |    |    |    |    |    |    |    | Timer 1 high
; --+------+----+----+----+----+----+----+----+----+--------------
;  6| E846 |    |    |    |    |    |    |    |    | Timer 1 latch
; --+------+----+----+----+----+----+----+----+----+--------------
;  7| E847 |    |    |    |    |    |    |    |    | Timer 1 latch
; --+------+----+----+----+----+----+----+----+----+--------------
;  8| E848 |    |    |    |    |    |    |    |    | Timer 2 low
; --+------+----+----+----+----+----+----+----+----+--------------
;  9| E849 |    |    |    |    |    |    |    |    | Timer 2 high
; --+------+----+----+----+----+----+----+----+----+--------------
; 10| E84A |    Shift Register                     | Shift
; --+------+----+----+----+----+----+----+----+----+--------------
; 11| E84B |    Auxiliary Control Register         | ACR
; --+------+----+----+----+----+----+----+----+----+--------------
; 12| E84C |    |    |    |    |    |    |    |    | PCR
; --+------+----+----+----+----+----+----+----+----+--------------
; 13| E84D |    Interrupt Flag Register            | IFR
; --+------+----+----+----+----+----+----+----+----+--------------
; 14| E84E |    Interrupt Enable Register          | IER
; --+------+----+----+----+----+----+----+----+----+--------------
; 15| E84F |    No Handshake Register              | no_HS
; --+------+----+----+----+----+----+----+----+----+--------------

VIA_Port_B           = $e840
VIA_Port_A           = $e841  ; unused
VIA_DDR_B            = $e842
VIA_DDR_A            = $e843  ; unused
VIA_Timer_1_Lo       = $e844
VIA_Timer_1_Hi       = $e845
VIA_Timer_1_Latch_Lo = $e846  ; unused
VIA_Timer_1_Latch_Hi = $e847  ; unused
VIA_Timer_2_Lo       = $e848
VIA_Timer_2_Hi       = $e849
VIA_Shift            = $e84a

VIA_ACR              = $e84b  ; Auxiliary Control Register
; bit 7: Timer 1 : Output Enable    1 = continuous 0 = single
; bit 6: Timer 1 : Free-Run Enable  1 = PB7 pulse  0 = IRQ
; bit 5: Timer 2 : Control          1 = pulse      0 = single

VIA_PCR              = $e84c

VIA_IFR              = $e84d  ; Interrupt Flag Register
; 7        IRQ
;  6       T1
;   5      T2
;    4     CB1
;     3    CB2
;      2   SR
;       1  CA1
;        0 CA2

VIA_IER              = $e84e  ; Interrupt Enable Register
VIA_Port_A_no_HS     = $e84f  ; unused




CRT_Address          = $e880
CRT_Value            = $e881

* = $b000   ; *** b000 ***  Commodore 8296


; *********************
  Basic_Statement_Table
; *********************

          .WORD Basic_END       - 1
          .WORD Basic_FOR       - 1
          .WORD Basic_NEXT      - 1
          .WORD Basic_DATA      - 1
          .WORD Basic_INPUTN    - 1
          .WORD Basic_INPUT     - 1
          .WORD Basic_DIM       - 1
          .WORD Basic_READ      - 1
          .WORD Basic_LET       - 1
          .WORD Basic_GOTO      - 1
          .WORD Basic_RUN       - 1
          .WORD Basic_IF        - 1
          .WORD Basic_RESTORE   - 1
          .WORD Basic_GOSUB     - 1
          .WORD Basic_RETURN    - 1
          .WORD Basic_REM       - 1
          .WORD Basic_STOP      - 1
          .WORD Basic_ON        - 1
          .WORD Basic_WAIT      - 1
          .WORD Basic_LOAD      - 1
          .WORD Basic_SAVE      - 1
          .WORD Basic_VERIFY    - 1
          .WORD Basic_DEF       - 1
          .WORD Basic_POKE      - 1
          .WORD Basic_PRINTN    - 1
          .WORD Basic_PRINT     - 1
          .WORD Basic_CONT      - 1
          .WORD Basic_LIST      - 1
          .WORD Basic_CLR       - 1
          .WORD Basic_CMD       - 1
          .WORD Basic_SYS       - 1
          .WORD OPEN            - 1
          .WORD CLOSE           - 1
          .WORD Basic_GET       - 1
          .WORD Basic_NEW       - 1
          .WORD Basic_GO        - 1
          .WORD Basic_CONCAT    - 1
          .WORD Basic_DOPEN     - 1
          .WORD Basic_DCLOSE    - 1
          .WORD Basic_RECORD    - 1
          .WORD Basic_HEADER    - 1
          .WORD Basic_COLLECT   - 1
          .WORD Basic_BACKUP    - 1
          .WORD Basic_COPY      - 1
          .WORD Basic_APPEND    - 1
          .WORD Basic_DSAVE     - 1
          .WORD Basic_DLOAD     - 1
          .WORD Basic_DIRECTORY - 1
          .WORD Basic_RENAME    - 1
          .WORD Basic_SCRATCH   - 1
          .WORD Basic_DIRECTORY - 1

          .SIZE

; ********************
  Basic_Function_Table
; ********************

          .WORD Basic_SGN
          .WORD Basic_INT
          .WORD Basic_ABS
          .WORD Basic_USR
          .WORD Basic_FRE
          .WORD Basic_POS
          .WORD Basic_SQR
          .WORD Basic_RND
          .WORD Basic_LOG
          .WORD Basic_EXP
          .WORD Basic_COS
          .WORD Basic_SIN
          .WORD Basic_TAN
          .WORD Basic_ATN
          .WORD Basic_PEEK
          .WORD Basic_LEN
          .WORD Basic_STR
          .WORD Basic_VAL
          .WORD Basic_ASC
          .WORD Basic_CHR
          .WORD Basic_LEFT
          .WORD Basic_RIGHT
          .WORD Basic_MID

          .SIZE

; ********************
  Basic_Operator_Table
; ********************

          .BYTE $79, Op_PLUS     - 1
          .BYTE $79, Op_MINUS    - 1
          .BYTE $7b, Op_MULTIPLY - 1
          .BYTE $7b, Op_DIVIDE   - 1
          .BYTE $7f, Op_POWER    - 1
          .BYTE $50, Op_AND      - 1
          .BYTE $46, Op_OR       - 1
          .BYTE $7d, Op_NEGATE   - 1
          .BYTE $5a, Op_NOT      - 1
          .BYTE $64, Op_COMPARE  - 1

          .SIZE

; *******************
  Basic_Keyword_Table
; *******************

          .BYTE "END"^        ; 80
          .BYTE "FOR"^        ; 81
          .BYTE "NEXT"^       ; 82
          .BYTE "DATA"^       ; 83
          .BYTE "INPUT#"^     ; 84
          .BYTE "INPUT"^      ; 85
          .BYTE "DIM"^        ; 86
          .BYTE "READ"^       ; 87
          .BYTE "LET"^        ; 88
          .BYTE "GOTO"^       ; 89
          .BYTE "RUN"^        ; 8a
          .BYTE "IF"^         ; 8b
          .BYTE "RESTORE"^    ; 8c
          .BYTE "GOSUB"^      ; 8d
          .BYTE "RETURN"^     ; 8e
          .BYTE "REM"^        ; 8f
          .BYTE "STOP"^       ; 90
          .BYTE "ON"^         ; 91
          .BYTE "WAIT"^       ; 92
          .BYTE "LOAD"^       ; 93
          .BYTE "SAVE"^       ; 94
          .BYTE "VERIFY"^     ; 95
          .BYTE "DEF"^        ; 96
          .BYTE "POKE"^       ; 97
          .BYTE "PRINT#"^     ; 98
          .BYTE "PRINT"^      ; 99
          .BYTE "CONT"^       ; 9a
          .BYTE "LIST"^       ; 9b
          .BYTE "CLR"^        ; 9c
          .BYTE "CMD"^        ; 9d
          .BYTE "SYS"^        ; 9e
          .BYTE "OPEN"^       ; 9f
          .BYTE "CLOSE"^      ; a0
          .BYTE "GET"^        ; a1
          .BYTE "NEW"^        ; a2
          .BYTE "TAB("^       ; a3
          .BYTE "TO"^         ; a4
          .BYTE "FN"^         ; a5
          .BYTE "SPC("^       ; a6
          .BYTE "THEN"^       ; a7
          .BYTE "NOT"^        ; a8
          .BYTE "STEP"^       ; a9
          .BYTE "+"^          ; aa
          .BYTE "-"^          ; ab
          .BYTE "*"^          ; ac
          .BYTE "/"^          ; ad
          .BYTE "^"^          ; ae
          .BYTE "AND"^        ; af
          .BYTE "OR"^         ; b0
          .BYTE ">"^          ; b1
          .BYTE "="^          ; b2
          .BYTE "<"^          ; b3
          .BYTE "SGN"^        ; b4
          .BYTE "INT"^        ; b5
          .BYTE "ABS"^        ; b6
          .BYTE "USR"^        ; b7
          .BYTE "FRE"^        ; b8
          .BYTE "POS"^        ; b9
          .BYTE "SQR"^        ; ba
          .BYTE "RND"^        ; bb
          .BYTE "LOG"^        ; bc
          .BYTE "EXP"^        ; bd
          .BYTE "COS"^        ; be
          .BYTE "SIN"^        ; bf
          .BYTE "TAN"^        ; c0
          .BYTE "ATN"^        ; c1
          .BYTE "PEEK"^       ; c2
          .BYTE "LEN"^        ; c3
          .BYTE "STR$"^       ; c4
          .BYTE "VAL"^        ; c5
          .BYTE "ASC"^        ; c6
          .BYTE "CHR$"^       ; c7
          .BYTE "LEFT$"^      ; c8
          .BYTE "RIGHT$"^     ; c9
          .BYTE "MID$"^       ; ca
          .BYTE "GO"^         ; cb
          .BYTE "CONCAT"^     ; cc
          .BYTE "DOPEN"^      ; cd
          .BYTE "DCLOSE"^     ; ce
          .BYTE "RECORD"^     ; cf
          .BYTE "HEADER"^     ; d0
          .BYTE "COLLECT"^    ; d1
          .BYTE "BACKUP"^     ; d2
          .BYTE "COPY"^       ; d3
          .BYTE "APPEND"^     ; d4
          .BYTE "DSAVE"^      ; d5
          .BYTE "DLOAD"^      ; d6
          .BYTE "CATALOG"^    ; d7
          .BYTE "RENAME"^     ; d8
          .BYTE "SCRATCH"^    ; d9
          .BYTE "DIRECTORY"^  ; da
          .BYTE $00           ; db

          .SIZE

; *********
  Msg_Start
; *********

          .BYTE "NEXT WITHOUT FOR"^
Msg_SYNTA .BYTE "SYNTAX"^
Msg_GOSUB .BYTE "RETURN WITHOUT GOSUB"^
          .BYTE "OUT OF DATA"^
Msg_QUANT .BYTE "ILLEGAL QUANTITY"^
Msg_FLOW  .BYTE "OVERFLOW"^
Msg_OOM   .BYTE "OUT OF MEMORY"^
Msg_UNDEF .BYTE "UNDEF'D STATEMENT"^
Msg_SUBSC .BYTE "BAD SUBSCRIPT"^
Msg_REDIM .BYTE "REDIM'D ARRAY"^
Msg_DIV   .BYTE "DIVISION BY ZERO"^
Msg_DIREC .BYTE "ILLEGAL DIRECT"^
Msg_TYPE  .BYTE "TYPE MISMATCH"^
Msg_LONG  .BYTE "STRING TOO LONG"^
Msg_DATA  .BYTE "FILE DATA"^
Msg_COMPL .BYTE "FORMULA TOO COMPLEX"^
          .BYTE "CAN'T CONTINUE"^
Msg_FUNC  .BYTE "UNDEF'D FUNCTION"^
Msg_ERR   .BYTE " ERROR",0
Msg_IN    .BYTE " IN ",0

          .SIZE

; *********
  Msg_READY
; *********

          .BYTE "\rREADY.\r",0

; *********
  Msg_BREAK
; *********

          .BYTE "\rBREAK",0


; FOR TO STEP NEXT data structure on stack
; ========================================

; 00 : TXTPTR
; 01 : TXTPTR+1  address of loop body

; 02 : CURLIN+1
; 03 : CURLIN    line #  of loop body

; 04 : FAC M4
; 05 : FAC M3
; 06 : FAC M2    value after TO
; 07 : FAC M1
; 08 : FAC EX

; 09 : sign
; 0a : FAC M4
; 0b : FAC M3
; 0c : FAC M2    value after STEP
; 0d : FAC M1
; 0e : FAC EX

; 0f : FORPNT+1
; 10 : FORPNT    address of index variable

; 11 : 81        loop marker

; ***********************
  Find_Active_FOR ; $b322
; ***********************

; Output: X = stackpointer to loop structure
;         Z = found flag
;         FORPNT = address of index variable

          TSX                 ; X = stack pointer
          INX
          INX                 ; skip return address of current subroutine
          INX
          INX                 ; skip return address of calling subroutine
FAF_10    LDA STACK+1,X
          CMP #$81            ; loop marker ?
          BNE FAF_Ret
          LDA FORPNT+1        ; index variable given ?
          BNE FAF_20
          LDA STACK+2,X       ; index variable low
          STA FORPNT
          LDA STACK+3,X       ; index variable high
          STA FORPNT+1
FAF_20    CMP STACK+3,X       ; index address high match ?
          BNE FAF_30
          LDA FORPNT
          CMP STACK+2,X       ; index address low  match ?
          BEQ FAF_Ret         ; OK found correct data structure
FAF_30    TXA
          CLC
          ADC #$12            ; try outer loop
          TAX
          BNE FAF_10
FAF_Ret   RTS

; *********************
  Open_Up_Space ; $b350
; *********************

; Input:  A = new top of variables low
;         Y = new top of variables high
;         TMPPTA = target pointer (upper boundary)
;         TMPPTB = source pointer (upper boundary)
;         TMPPTC = source pointer (lower boundary)

          JSR Check_Mem_Avail ; may trigger a garbage collection
          STA STREND
          STY STREND+1        ; save new top of variables
          SEC
          LDA TMPPTB
          SBC TMPPTC
          STA INDEXA
          TAY
          LDA TMPPTB+1
          SBC TMPPTC+1
          TAX                 ; Y/X = bytes to move
          INX                 ; pages + 1
          TYA
          BEQ OUS_40          ; no partial page
          LDA TMPPTB
          SEC
          SBC INDEXA
          STA TMPPTB
          BCS OUS_10
          DEC TMPPTB+1        ; TMPPTB = source ptr
          SEC
OUS_10    LDA TMPPTA
          SBC INDEXA
          STA TMPPTA
          BCS OUS_30
          DEC TMPPTA+1        ; TMPPTA = target ptr
          BCC OUS_30          ; branch always
OUS_20    LDA (TMPPTB),Y
          STA (TMPPTA),Y
OUS_30    DEY
          BNE OUS_20
          LDA (TMPPTB),Y
          STA (TMPPTA),Y
OUS_40    DEC TMPPTB+1
          DEC TMPPTA+1
          DEX
          BNE OUS_30
          RTS

; *************************
  Check_Stack_Avail ; $b393
; *************************

          TSX
          CPX #$20
          BCC Error_Out_Of_Memory
          RTS

; **************
  BSOS_Bank_Init
; **************

          .BYTE 0             ; changed by BSOS loader

          .FILL $b3a0-* (0)

; ***********************
  Check_Mem_Avail ; $b3a0
; ***********************

; Input:  A = new top of variables low
;         Y = new top of variables high
; Return if OK
; Jump to OOM error if not

          CPY FRETOP+1
          BCC CMA_Ret
          BNE CMA_10
          CMP FRETOP
          BCC CMA_Ret
CMA_10    PHA                 ; not enough space
          TYA                 ; call garbage collectiom
          PHA
          JSR Garbage_Collection
          PLA
          TAY                 ; restore new top high
          PLA                 ; restore new to low
          CPY FRETOP+1        ; compare again
          BCC CMA_Ret
          BNE Error_Out_Of_Memory
          CMP FRETOP
          BCS Error_Out_Of_Memory
CMA_Ret   RTS

          .FILL $b3cd-* (0)

; ***************************
  Error_Out_Of_Memory ; $b3cd
; ***************************

          LDX #[Msg_OOM - Msg_Start] ; $4d

; *******************
  Basic_Error ; $b3cf
; *******************

; Input:  X = Offset from Msg_Start for message

          JMP (IERROR)

; *********
  DEF_ERROR
; *********

          JSR CLRCHN          ; close open channels
          STA IOPMPT          ; A = 0 from CLRCHN
          JSR Print_CR
          JSR Print_Question_Mark
Berr_20   LDA Msg_Start,X
          PHA
          AND #$7f
          JSR CHROUT
          INX
          PLA
          BPL Berr_20
Berr_30   JSR Flush_BASIC_Stack
          LDA #<Msg_ERR
          LDY #>Msg_ERR
Berr_40   JSR Print_String
          LDY CURLIN+1
          INY
          BEQ Basic_Ready
          JSR Print_IN

          .FILL $b3ff-* ($ea)

; ********************
  Basic_Ready ; $ b3ff
; ********************

          LDA #<Msg_READY
          LDY #>Msg_READY
          JSR Print_String

; ***************************
  Get_Basic_Statement ; $b406
; ***************************

          JMP (IMAIN)

; ********
  DEF_MAIN
; ********

          JSR Read_Power_String
          STX TXTPTR
          STY TXTPTR+1
          JSR CHRGET
          TAX
          BEQ Get_Basic_Statement; empty line
          LDX #$ff
          STX CURLIN+1        ; invalidate CURLIN
          BCC New_Basic_Line  ; started with a line number
          JMP Wedge_Parser    ; direct command

; **********************
  New_Basic_Line ; $b41f
; **********************

; This routine uses the addresses $01fc-$01ff for constructing
; the link and line number for the line stored in the buffer at $0200
; So these bytes are not available for stack operations.
; That's why the Flush_Stack routine initializes the stack pointer to $fa.

          JSR Scan_Linenumber ; Line number
          JSR Tokenize_Line   ; Crunch line
          STY COUNT           ; new line length (incl. link & number)
          JSR Find_BASIC_Line ; does this line exist?
          BCC NBL_30          ; if not -> create a new line
          LDY #1              ; Y = 1
          LDA (TMPPTC),Y      ; link high
          STA INDEXA+1        ; source pointer INDEXA high
          LDA VARTAB
          STA INDEXA          ; source pointer INDEXA low
          LDA TMPPTC+1
          STA INDEXB+1        ; target pointer INDEXB high
          LDA TMPPTC
          DEY                 ; Y = 0
          SBC (TMPPTC),Y      ; negative length of line
          CLC
          ADC VARTAB          ; subtract line length from VARTAB
          STA VARTAB          ; by adding the negative length to VARTAB
          STA INDEXB          ; move target pointer INDEXB low
          LDA VARTAB+1
          ADC #$ff
          STA VARTAB+1        ; VARTAB -= length of current line
          SBC TMPPTC+1
          TAX                 ; pages to move
          SEC
          LDA TMPPTC
          SBC VARTAB          ; bytes to move
          TAY
          BCS NBL_10
          INX                 ; increment pages to move
          DEC INDEXB+1
NBL_10    CLC
          ADC INDEXA
          BCC NBL_20
          DEC INDEXA+1
          CLC
NBL_20    LDA (INDEXA),Y      ; move program code above deleted line
          STA (INDEXB),Y      ; downwards
          INY
          BNE NBL_20          ; inner loop moves 1 page
          INC INDEXA+1
          INC INDEXB+1
          DEX                 ; pages to move
          BNE NBL_20
NBL_30    JSR Reset_BASIC_Execution
          JSR Rechain
          LDA BUF
          BEQ Get_Basic_Statement
          CLC
          LDA VARTAB
          STA TMPPTB
          ADC COUNT
          STA TMPPTA
          LDY VARTAB+1
          STY TMPPTB+1
          BCC NBL_40
          INY
NBL_40    STY TMPPTA+1
          JSR Open_Up_Space
          LDA LINNUM
          LDY LINNUM+1
          STA BUF-2
          STY BUF-1
          LDA STREND
          LDY STREND+1
          STA VARTAB
          STY VARTAB+1
          LDY COUNT
          DEY
NBL_50    LDA BUF-4,Y         ; copy buffer to program
          STA (TMPPTC),Y
          DEY
          BPL NBL_50

; *************************
  Reset_And_Rechain ; $b4ad
; *************************

          JSR Reset_BASIC_Execution
          JSR Rechain
          JMP Get_Basic_Statement

; ***************
  Rechain ; $b4b6
; ***************

          LDX TXTTAB
          LDA TXTTAB+1
          LDY #1
          BNE Rech_30
Rech_10   LDY #4
Rech_20   INY
          LDA (INDEXA),Y
          BNE Rech_20         ; scan for 0
          TYA
          SEC                 ; + 1
          ADC INDEXA
          TAX                 ; X = new address low
          LDY #0
          STA (INDEXA),Y      ; store link low
          TYA                 ; A = 0
          ADC INDEXA+1        ; A = new address high
          INY                 ; Y = 1
          STA (INDEXA),Y      ; store link high
Rech_30   STX INDEXA
          STA INDEXA+1
          LDA (INDEXA),Y      ; link high
          BNE Rech_10         ; more lines
          RTS

          .FILL $b4e2-* (0)

; *******************
  Read_String ; $b4e2
; *******************

          LDX #0
ReaS_10   JSR CHRIN
          CMP #CR
          BEQ ReaS_20
          STA BUF,X
          INX
          CPX #81
          BCC ReaS_10
          LDX #[Msg_LONG - Msg_Start] ; $b0 : STRING TOO LONG
          JMP Basic_Error
ReaS_20   JMP Terminate_BUF

; *********************
  Tokenize_Line ; $b4fb
; *********************

          JMP (ICRNCH)

; **********
  DEF_CRUNCH
; **********

          LDX TXTPTR
          LDY #4
          STY GARBFL          ; clear bits 7-4
ToLi_01   LDA BUF,X           ; get next char
          BPL ToLi_02         ; normal char
          CMP #$ff            ; Pi ?
          BEQ ToLi_08         ; treat Pi as normal char
          INX                 ; no action on this char
          BNE ToLi_01         ; next one
ToLi_02   CMP #' '            ; no action on blank
          BEQ ToLi_08
          STA ENDCHR          ; save char
          CMP #$22            ; quote ?
          BEQ ToLi_12         ; handle string
          BIT GARBFL
          BVS ToLi_08
          CMP #'?'            ; short for print
          BNE ToLi_03
          LDA #$99            ; PRINT token
          BNE ToLi_08
ToLi_03   CMP #'0'
          BCC ToLi_04         ; is symbol
          CMP #$3c            ; '<'
          BCC ToLi_08
ToLi_04   STY TMPPTD          ; save Y
          LDY #0
          STY COUNT           ; keyword count
          STX TXTPTR          ; update pointer
          LDA #>Basic_Keyword_Table
          STA INDEXA+1
          LDA #<Basic_Keyword_Table
          STA INDEXA
          BNE ToLi_06         ; branch always
ToLi_05   INX                 ; inc buffer  pointer X
          INC INDEXA          ; inc keyword pointer INDEXA
          BNE ToLi_06
          INC INDEXA+1
ToLi_06   LDA BUF,X           ; char - keyword char
          SEC
          SBC (INDEXA),Y
          BEQ ToLi_05         ; match, continue with next char
          CMP #$80            ; match with difference $80 -> found
          BNE ToLi_13
          ORA COUNT           ; token = $80 | count
ToLi_07   LDY TMPPTD          ; restore Y (started with 4)
ToLi_08   INX                 ; point to char after parsed word
          INY                 ; point to token insert position - 5
          STA BUF-5,Y         ; insert token at start of word
          LDA BUF-5,Y         ; reload to set flags
          BEQ ToLi_16         ; zero -> end of line
          SEC
          SBC #':'            ; colon ?
          BEQ ToLi_09         ; branch on colon
          CMP #$49            ; DATA token ? ($83 = $3a + $49)
          BNE ToLi_10
ToLi_09   STA GARBFL          ; store colon or $49 for DATA
ToLi_10   SEC
          SBC #$55            ; REM token ? ($8f = $3a + $55)
          BNE ToLi_01         ; no special tokens -> continue parse
          STA ENDCHR          ; store REM marker in ENDCHR
ToLi_11   LDA BUF,X
          BEQ ToLi_08         ; end of parsed text
          CMP ENDCHR
          BEQ ToLi_08         ; end of copied text
ToLi_12   INY                 ; copy text in quotes or after REM or DATA
          STA BUF-5,Y
          INX
          BNE ToLi_11         ; continue copy
ToLi_13   LDX TXTPTR          ; found keyword match
          INC COUNT           ; set count to next token
ToLi_14   LDA (INDEXA),Y      ;
          PHP                 ; save flags
          INC INDEXA          ; let INDEXA point to next token
          BNE ToLi_15
          INC INDEXA+1
ToLi_15   PLP                 ; restore flags
          BPL ToLi_14         ; true if not single character keyword
          LDA (INDEXA),Y      ; load 1st. char of next token keyword
          BNE ToLi_06         ; jump if not at end of table
          LDA BUF,X           ; reread parse char
          BPL ToLi_07         ; start searching from start of table
ToLi_16   STA BUF-3,Y         ; end of parse, store zeroes at end of line
          DEC TXTPTR+1        ; set TXTPTR to BUF-1
          LDA #$ff
          STA TXTPTR
          RTS

; ***********************
  Find_BASIC_Line ; $b5a3
; ***********************

          LDA TXTTAB
          LDX TXTTAB+1

; **************************
  Find_BASIC_Line_AX ; $b5a7
; **************************

          LDY #1
          STA TMPPTC
          STX TMPPTC+1
          LDA (TMPPTC),Y      ; link high
          BEQ FBL_30          ; branch on EOP
          TAX                 ; X = link high
          LDY #3
          LDA LINNUM+1
          CMP (TMPPTC),Y
          BCC FBL_Ret         ; branch if beyond
          BNE FBL_10
          DEY                 ; Y = 2
          LDA LINNUM
          CMP (TMPPTC),Y
          BEQ FBL_Ret         ; (C=1) found
          BCC FBL_Ret         ; (C=0) not found
FBL_10    LDY #0
          LDA (TMPPTC),Y      ; Link low
          BCS Find_BASIC_Line_AX  ; branch always
FBL_30    CLC                 ; Carry clear = not found
FBL_Ret   RTS

          .FILL $b5d2-* (0)

; *****************
  Basic_NEW ; $b5d2
; *****************

          BNE FBL_Ret         ; return if NEW is not a single statement

; ***********
  Perform_NEW
; ***********

          LDA #0
          TAY
          STA (TXTTAB),Y      ; zero link
          INY
          STA (TXTTAB),Y
          LDA TXTTAB
          CLC
          ADC #2
          STA VARTAB          ; VARTAB = TXTTAB + 2
          LDA TXTTAB+1
          ADC #0
          STA VARTAB+1

; *********************
  Reset_BASIC_Execution
; *********************

          JSR Reset_BASIC_Exec_Pointer
          LDA #0              ; set for next condition

; *********
  Basic_CLR
; *********

          BNE FBS_Ret         ; return if not single statement

; **********************
  Reset_Variable_Pointer
; **********************

          LDA MEMSIZ
          LDY MEMSIZ+1
          STA FRETOP
          STY FRETOP+1
          NOP
          NOP
          NOP
          NOP
          JSR CLALL
          LDA VARTAB
          LDY VARTAB+1
          STA ARYTAB
          STY ARYTAB+1
          STA STREND
          STY STREND+1
RVP_10    JSR Basic_RESTORE

; *************************
  Flush_BASIC_Stack ; $b60e
; *************************

          LDX #TEMPST         ; clear string descriptor stack
          STX TEMPPT
          PLA
          TAY
          PLA
          LDX #$fa            ; reset stackpointer
          TXS
          PHA
          TYA
          PHA
          LDA #0
          STA OLDTXT+1
          STA SUBFLG
FBS_Ret   RTS

; ************************
  Reset_BASIC_Exec_Pointer
; ************************

          CLC                 ; TXTPTR = TXTTAB - 1
          LDA TXTTAB
          ADC #$ff
          STA TXTPTR
          LDA TXTTAB+1
          ADC #$ff
          STA TXTPTR+1
RBEP_Ret  RTS

; **********
  Basic_LIST
; **********

          BCC LIST_10         ; C=0 : number after LIST
          BEQ LIST_10         ; Z=1 : end of statement
          CMP #$ab            ; '-' token
          BNE RBEP_Ret        ; -> RTS
LIST_10   JSR Scan_Linenumber ; starting line or 0 for non numeric
          JSR Find_BASIC_Line ; setup TMPPTC
          JSR CHRGOT          ; last character read
          BEQ LIST_15         ; no end line
          CMP #$ab            ; '-' token
          BNE RBEP_Ret        ; -> RTS
          JSR CHRGET
          JSR Scan_Linenumber ; read end line
          BNE RBEP_Ret        ; more chars after end line -> RTS
LIST_15   PLA                 ; remove return address
          PLA
          LDA LINNUM
          ORA LINNUM+1
          BNE LIST_20         ; end line != 0 ?
          DEC LINNUM+1        ; end line  = $ff00 = 65280

; loop for line listing

LIST_20   LDY #1

; check for EOP and STOP

          LDA (TMPPTC),Y      ; link address high
          BEQ LIST_50         ; -> end of program
          JSR STOP            ; check STOP key
          JSR Print_CR        ; start listing with newline

; get line #

          INY                 ; Y=2
          LDA (TMPPTC),Y      ; line # lo
          TAX
          INY                 ; Y=3
          LDA (TMPPTC),Y      ; line # hi

; check for last line to list

          CMP LINNUM+1        ; compare with end line hi
          BNE LIST_25         ; not equal
          CPX LINNUM          ; compare with end line lo
          BEQ LIST_30         ; match -> print it
LIST_25   BCS LIST_50         ; line # > end line


; loop for printing characters

LIST_30   JSR List_Line

; follow link

LIST_60   TAY                 ; Y=0
          LDA (TMPPTC),Y      ; link low
          TAX
          INY
          LDA (TMPPTC),Y      ; link high
          STX TMPPTC          ; TMPPTC = link
          STA TMPPTC+1
          BNE LIST_20         ; continue with next line

; next line if not EOP

LIST_50   JMP Basic_Ready     ; LIST finished

          .SIZE

; *****************
  List_Line ; $b689
; *****************

          JSR Print_Integer_XA; print line #
          LDA #' '            ; print blank after line #
          LDY #3              ; before basic text

LiLi_08   JSR Print_Char
          CMP #QUOTE
          BNE LiLi_20

; print quoted string

LiLi_10   INY
          LDA (TMPPTC),Y
          BEQ LiLi_Ret
          JSR Print_Char      ; print it
          CMP #QUOTE
          BNE LiLi_10

; get next char

LiLi_20   INY                 ; Y++
          LDA (TMPPTC),Y      ; next character
          BEQ LiLi_Ret
          JMP (IQPLOP)        ; hook for extensions

; *********
  DEF_QPLOP
; *********

          BPL LiLi_08         ; continue printing if not a token
          CMP #$ff            ; is it the special char PI ?
          BEQ LiLi_08         ; yes, print it

; print keyword from token

          TAX
          TYA
          PHA                 ; save Y
          LDY #>[Basic_Keyword_Table-1]
          STY INDEXA+1
          LDY #<[Basic_Keyword_Table-1]
          STY INDEXA
          LDY #0
LiLi_30   DEX                 ; token--
          BPL LiLi_60         ; count down finished
LiLi_40   INC INDEXA          ; increment address to keyword table
          BNE LiLi_50
          INC INDEXA+1
LiLi_50   LDA (INDEXA),Y      ; load next keyword char
          BPL LiLi_40         ; -> inside keyword
          BMI LiLi_30         ; -> end of keyword
LiLi_60   INY
          LDA (INDEXA),Y      ; next char from keyword table
          PHA
          AND #$7f
          JSR Print_Char      ; print it
          PLA
          BPL LiLi_60
          PLA
          TAY
          BNE LiLi_20
LiLi_Ret  RTS

          .FILL $b6de-* (0)

; *****************
  Basic_FOR ; $b6de
; *****************

          LDA #$80
          STA SUBFLG          ; Inhibit integer index
          JSR Basic_LET       ; define index variable
          JSR Find_Active_FOR
          BNE FOR_10          ; branch if none
          TXA
          ADC #15             ; add 16 (C=1 from Find_Active_FOR)
          TAX
          TXS
FOR_10    PLA                 ; remove return address
          PLA                 ; now there is space for 18 bytes
          JSR Check_Stack_Avail
          JSR Skip_To_EOS     ; search start of loop body
          CLC
          TYA                 ; Y = position of delimiter (0 or ':')
          ADC TXTPTR          ; loop body low
          PHA
          LDA TXTPTR+1        ; loop body high
          ADC #0
          PHA
          LDA CURLIN+1        ; line # high for body
          PHA
          LDA CURLIN          ; line # low  for body
          PHA
          LDA #$a4            ; TO token
          JSR Need_A
          JSR Eval_Numeric    ; read end value
          LDA FAC1SI
          ORA #$7f
          AND FAC1M1
          STA FAC1M1
          CLC                 ; push without sign
          JSR Push_FAC1       ; push TO value
          LDA #<REAL_1
          LDY #>REAL_1
          JSR Load_FAC1_AY    ; default 1.0 for STEP value
          JSR CHRGOT
          CMP #$a9            ; STEP token
          BNE FOR_30
          JSR CHRGET
          JSR Eval_Numeric
FOR_30    JSR Get_FAC1_Sign
          STA FAC1SI
          SEC                 ; push with sign
          JSR Push_FAC1       ; push STEP value
          LDA FORPNT+1
          PHA
          LDA FORPNT
          PHA
          LDA #$81
          PHA
          BNE Execute         ; always

          .FILL $b74a-* (0)

; ***************
  Execute ; $b74a
; ***************

          JSR Kernal_STOP
          LDY TXTPTR+1
          CPY #2
          BEQ Exec_10
          LDA TXTPTR
          STA OLDTXT          ; save pointer if not direct
          STY OLDTXT+1
Exec_10   LDY #0
          LDA (TXTPTR),Y
          BNE Inpr_40         ; branch if not at line end
          LDY #2
          LDA (TXTPTR),Y      ; link high
          CLC                 ; C=0 : normal end
          BEQ END_40          ; end of program -> READY.
          INY                 ; Y = 3
          LDA (TXTPTR),Y      ; new line # to CURLIN
          STA CURLIN
          INY
          LDA (TXTPTR),Y
          STA CURLIN+1
          TYA
          ADC TXTPTR          ; TXTPTR = next statement
          STA TXTPTR
          BCC Start_Program
          INC TXTPTR+1

; *************
  Start_Program
; *************

          JMP (IGONE)

; ********
  DEF_GONE
; ********

          JSR Any_Except_Pi   ; Pi must not start a statement
          JSR Interpret
          JMP Execute

; *****************
  Interpret ; $b785
; *****************

; Input:  A = first character of new statement
;         Flags set from GETCHR

          BEQ REST_Ret        ; branch on empty statement
Inpr_10   SBC #$80            ; token -> number
          BCC Inpr_30         ; branch to LET if not token
          CMP #$23            ; $80-$a2 may start a statement
          BCC Inpr_20         ; use jump table
          CMP #$4b            ; $a3-$cb are functions or operators
          BCC Inpr_50
          SBC #$28            ; BASIC-4 token
Inpr_20   ASL A
          TAY
          LDA Basic_Statement_Table+1,Y
          PHA
          LDA Basic_Statement_Table,Y
          PHA
          JMP CHRGET          ; RTS from CHRGET jumps to statement code
Inpr_30   JMP Basic_LET       ; start with variable name
Inpr_40   CMP #':'
          BEQ Start_Program
Inpr_50   JMP Syntax_Error

; ****************
  Basic_GO ; $b7ac
; ****************

          JSR CHRGOT          ; execute GO TO command
          LDA #$a4            ; TO token
          JSR Need_A
          JMP Basic_GOTO

; *********************
  Basic_RESTORE ; $b7b7
; *********************

          SEC                 ; DATPTR = TXTTAB - 1
          LDA TXTTAB
          SBC #1
          LDY TXTTAB+1
          BCS REST_10
          DEY
REST_10   STA DATPTR
          STY DATPTR+1
REST_Ret  RTS

; ******************
  Basic_STOP ; $b7c6
; ******************

          BCS END_10          ; C=1 : BREAK

; ****************
  Basic_END ; b7c8
; ****************

          CLC                 ; C=0 : READY
END_10    BNE CONT_Ret
          LDA TXTPTR
          LDY TXTPTR+1
          LDX CURLIN+1
          INX                 ; CURLIN+1 = $ff : undefined
          BEQ END_30
          STA OLDTXT
          STY OLDTXT+1
END_20    LDA CURLIN
          LDY CURLIN+1
          STA OLDLIN
          STY OLDLIN+1
END_30    PLA
          PLA
END_40    LDA #<Msg_BREAK     ; $b31b
          LDY #>Msg_BREAK
          BCC END_50
          JMP Berr_40
END_50    JMP Basic_Ready

; ******************
  Basic_CONT ; $b7ee
; ******************

          BNE CONT_Ret
          LDX #$db
          LDY OLDTXT+1
          BNE CONT_10
          JMP Basic_Error
CONT_10   LDA OLDTXT
          STA TXTPTR
          STY TXTPTR+1
          LDA OLDLIN
          LDY OLDLIN+1
          STA CURLIN
          STY CURLIN+1
CONT_Ret  RTS

; *****************
  Basic_RUN ; $b808
; *****************

          BNE RUN_20          ; branch onheck_Stack_Avail
RUN_10    JMP Reset_BASIC_Execution
RUN_20    JSR Reset_Variable_Pointer
          JMP GOSUB_10

; *******************
  Basic_GOSUB ; $b813
; *******************

          JSR Check_Stack_Avail
          LDA TXTPTR+1
          PHA
          LDA TXTPTR
          PHA
          LDA CURLIN+1
          PHA
          LDA CURLIN
          PHA
          LDA #$8d            ; GOSUB token marker
          PHA
GOSUB_10  JSR CHRGOT
          JSR Basic_GOTO
          JMP Execute

          .FILL $b830-* (0)

; ******************
  Basic_GOTO ; $b830
; ******************

          JSR Scan_Linenumber ; read LINNUM
          JSR Skip_To_EOL     ; skip to end of line
          LDA CURLIN+1
          CMP LINNUM+1        ; CURLIN >= LINNUM ?
          BCS GOTO_10         ; search from start
          TYA                 ; EOL index
          SEC
          ADC TXTPTR          ; (A/X) = TXTPTR + length + 1 (carry)
          LDX TXTPTR+1
          BCC GOTO_20
          INX
          BCS GOTO_20         ; start search from current link
GOTO_10   LDA TXTTAB
          LDX TXTTAB+1
GOTO_20   JSR Find_BASIC_Line_AX
          BCC RET_10          ; undefined statement
          LDA TMPPTC
          SBC #1
          STA TXTPTR          ; TXTPTR = TMPPTC - 1
          LDA TMPPTC+1
          SBC #0
          STA TXTPTR+1
GOTO_Ret  RTS

; ********************
  Basic_RETURN ; $b85d
; ********************

          BNE GOTO_Ret        ; no raguments allowed
          LDA #$ff
          STA FORPNT+1        ; invalidate FORPNT
          JSR Find_Active_FOR ; remove open loops
          TXS
          CMP #$8d            ; GOSUB token marker ?
          BEQ RET_30           ; yes -> perform return
          LDX #[Msg_GOSUB - Msg_Start] ; $16
          .BYTE $2c           ; skip next instruction
RET_10    LDX #[Msg_UNDEF - Msg_Start] ; $5a
          JMP Basic_Error
RET_20    JMP Syntax_Error
RET_30    PLA                 ; marker
          PLA
          STA CURLIN
          PLA
          STA CURLIN+1
          PLA
          STA TXTPTR
          PLA
          STA TXTPTR+1

; ******************
  Basic_DATA ; $b883
; ******************

          JSR Skip_To_EOS

; **********************************
  Add_Y_To_Execution_Pointer ; $b886
; **********************************

          TYA
          CLC
          ADC TXTPTR
          STA TXTPTR
          BCC AYEP_Ret
          INC TXTPTR+1
AYEP_Ret  RTS

; *******************
  Skip_To_EOS ; $b891
; *******************

          LDX #':'            ; scan for ':' or zero
          .BYTE $2c

; *******************
  Skip_To_EOL ; $b894
; *******************

          LDX #0
          STX CHARAC
          LDY #0
          STY ENDCHR
NeSt_10   LDA ENDCHR
          LDX CHARAC
          STA CHARAC
          STX ENDCHR
NeSt_20   LDA (TXTPTR),Y
          BEQ AYEP_Ret
          CMP ENDCHR
          BEQ AYEP_Ret
          INY
          CMP #QUOTE
          BNE NeSt_20
          BEQ NeSt_10

; ****************
  Basic_IF ; $b8b3
; ****************

          JSR Eval_Expression
          JSR CHRGOT
          CMP #$89            ; GOTO token
          BEQ IF_10
          LDA #$a7            ; THEN token
          JSR Need_A
IF_10     LDA FAC1EX          ; IF clause != 0 (true) or 0 (false)
          BNE REM_10          ; branch if true

; *****************
  Basic_REM ; $b8c6
; *****************

          JSR Skip_To_EOL
          BEQ Add_Y_To_Execution_Pointer
REM_10    JSR CHRGOT
          BCS REM_20
          JMP Basic_GOTO
REM_20    JMP Interpret

; ********
  Basic_ON
; ********

          JSR Get_Byte_Value
          PHA
          CMP #$8d            ; GOSUB token
          BEQ ON_20
ON_10     CMP #$89            ; GOTO token
          BNE RET_20          ; -> syntax error
ON_20     DEC FAC1M4          ; ON - counter
          BNE ON_30
          PLA
          JMP Inpr_10
ON_30     JSR CHRGET
          JSR Scan_Linenumber
          CMP #','
          BEQ ON_20
          PLA
          RTS

; ***************
  Scan_Linenumber
; ***************

; Input:  A = 1st. character
; Output: LINNUM decoded (0-63999) valid range
;         LINNUM = 0 if (A) is not numeric (C=1)

          LDX #0
          STX LINNUM
          STX LINNUM+1
          BCS ScLi_Ret        ; return if (A) is not numeric
ScLi_10   LDX LINNUM+1
          CPX #25             ; $fa00 after multiplication
          BCS ON_10           ; value >= 64000 -> Syntax Error
          JSR Dec_Char
          JSR CHRGET
          BCC ScLi_10         ; next char if numeric
ScLi_Ret  RTS

; ********
  Dec_Char
; ********

; Input:  LINNUM = 16 bit unsigned integer
;         A      = new value to add
;         X      = LINNUM+1
; Output: LINNUM = LINNUM * 10 + (A)

; check on integer overflow is done on calling routine

          AND #15             ; char -> bin
          PHA                 ; save value to add
          LDA LINNUM
          ASL A               ; * 2
          ROL LINNUM+1
          ASL A               ; * 4
          ROL LINNUM+1
          ADC LINNUM          ; * 5
          STA LINNUM
          TXA                 ; old high byte of LINNUM
          ADC LINNUM+1
          STA LINNUM+1
          ASL LINNUM          ; * 10
          ROL LINNUM+1
          PLA                 ; value to add
          ADC LINNUM
          STA LINNUM
          BCC LIM_10
          INC LINNUM+1
LIM_10    RTS

          .FILL $b930-* (0)

; *****************
  Basic_LET ; $b930
; *****************

          JSR Parse_Name
          STA FORPNT
          STY FORPNT+1
          LDA #$b2            ; '=' token
          JSR Need_A
          LDA INTFLG          ; save attributes
          PHA                 ; of variable
          LDA VALTYP
          PHA
          JSR Eval_Expression ; FAC1 = value or pointer
          PLA                 ; VALTYP
          ROL A               ; C=1 : string   C=0 : numeric
          JSR Check_Var_Type
          BNE LET_20          ; branch for string
          PLA                 ; INTFLG

; ***********************
  Assign_Numeric_variable
; ***********************

          BPL LET_10          ; branch for real
          JSR Round_FAC1
          JSR Real_To_Integer
          LDY #0
          LDA FAC1M3
          STA (FORPNT),Y      ; integer high byte
          INY
          LDA FAC1M4
          STA (FORPNT),Y      ; integer low  byte
          RTS
LET_10    JMP FAC1_To_FORPNT

LET_20    PLA                 ; INTFLG

; ******************************
  Assign_String_Variable ; $b965
; ******************************

          LDY FORPNT+1
          CPY #>[Float_0_5 + 2]; void string descriptor for TI$
          BNE Assign_Normal_String
          JSR Free_String_FAC1
          CMP #6              ; setting TI$ requires 6 digits
          BNE ATSD_10
          LDY #0              ; FAC1 = 0.0
          STY FAC1EX
          STY FAC1SI
CLOCK_10  STY TMPPTD
          JSR Add_TI_String_Digit_To_FAC1
          JSR Multiply_FAC1_BY_10
          INC TMPPTD
          LDY TMPPTD
          JSR Add_TI_String_Digit_To_FAC1
          JSR FAC1_Round_And_Copy_To_FAC2
          TAX                 ; number is zero ?
          BEQ CLOCK_20
          INX
          TXA                 ; FAC2 *= 2
          JSR Add_And_Double  ; FAC1 = (FAC1 + FAC2) * 2
CLOCK_20  LDY TMPPTD
          INY
          CPY #6
          BNE CLOCK_10
          JSR Multiply_FAC1_BY_10
          JSR FAC1_LSR
          LDX #2
          SEI                 ; set jiffy clock
CLOCK_30  LDA FAC1M2,X
          STA JIFFY_CLOCK,X
          DEX
          BPL CLOCK_30
          CLI
          RTS

; ***************************
  Add_TI_String_Digit_To_FAC1
; ***************************

          LDA (INDEXA),Y
          JSR ISNUM
          BCC ATSD_20
ATSD_10   JMP Jump_To_Illegal_Quantity
ATSD_20   SBC #$2f            ; '0'-1
          JMP Add_A_To_FAC1

; ****************************
  Assign_Normal_String ; $b9ba
; ****************************

; 100 a$ = "hello"
;     FAC1M3 = pointer to descriptor in string descriptor stack ($0016)
;     $0016  = descriptor length = 5, pointer to static string in code
;     STRPTR = $0409
;     -> ANS_60 branch

; a$ = "hello"
;     FAC1M3 = pointer to descriptor in string descriptor stack ($0016)
;     $0016  = descriptor length = 5, pointer to dynamic string
;     STRPTR = $7ffa
;     -> ANS_60 branch

; a$ = ds$ (disk status)
;     FAC1M3 = pointer to descriptor in string descriptor stack ($0016)
;     $0016  = descriptor length = 12, pointer to dynamic string
;     STRPTR = $7fd6
;     -> ANS_50 branch

          LDY #1
          LDA (FAC1M3),Y
          STA STRPTR          ; STRPTR = string pointer
          INY
          LDA (FAC1M3),Y
          STA STRPTR+1        ; STRPTR = DS$ (Disk Status) ?
          CMP #4
          BCC ANS_50          ; string is in system area (DS$)

ANS_10    LDA STRPTR+1        ; STRPTR < FRETOP ?
ANS_20    CMP FRETOP+1
          BCC ANS_40          ; branch if static
          BNE ANS_30          ; branch if higher
          LDA STRPTR
          CMP FRETOP
          BCC ANS_40          ; branch if static
ANS_30    LDY FAC1M4
          CPY VARTAB+1
          BCC ANS_40          ; branch if not variable
          BNE ANS_50
          LDA FAC1M3
          CMP VARTAB
          BCS ANS_50
ANS_40    LDA FAC1M3          ; static string
          LDY FAC1M4
          JMP ANS_60

; assign string from string variable

ANS_50    LDY #0              ; allocate & copy string
          LDA (FAC1M3),Y      ; length
          JSR Allocate_String_A
          LDX STRPTR
          LDY STRPTR+1
          JSR Store_String_XY
          LDA FAC1M3
          LDY FAC1M4
          JSR Pop_Descriptor_Stack
          LDA #<FAC1EX        ; allocated descriptor
          LDY #>FAC1EX

; assign static string and create back reference

ANS_60    STA DESCPT
          STY DESCPT+1
          STA INDEXA
          STY INDEXA+1
          JSR Pop_Descriptor_Stack
          JSR Back_Reference_Position   ; from INDEXA
          BCC ANS_70          ; -> no back reference
          LDA FORPNT+1
          STA (INDEXC),Y      ; Y = 1
          DEY
          LDA FORPNT          ; store back reference
          STA (INDEXC),Y      ; for garbage collection

; invalidate old string

ANS_70    LDA FORPNT
          STA INDEXA
          LDA FORPNT+1
          STA INDEXA+1
          JSR Back_Reference_Position
          BCC ANS_80
          LDA #$ff            ; mark old string as obsolete
          STA (INDEXC),Y      ; Y = 1
          DEY                 ; Y = 0
          TXA                 ; length
          STA (INDEXC),Y

; copy new value to variable

ANS_80    LDY #2
ANS_90    LDA (DESCPT),Y
          STA (FORPNT),Y
          DEY
          BPL ANS_90
          RTS

; ***********************
  Back_Reference_Position
; ***********************

; Input:  INDEXA = pointer to string descriptor
; Output: INDEXA = points to start of string
;         INDEXC = points to the end of string + 1
;         X = length of string
;         Y = 1
;         C = 1 : INDEXA and INDEXC set
;         C = 0 : nothing changed

          LDY #0
          LDA (INDEXA),Y      ; A = length
          PHA                 ; push length
          BEQ BRP_no
          INY
          LDA (INDEXA),Y
          TAX                 ; X = pointer low
          INY
          LDA (INDEXA),Y      ; A = pointer high
          BMI BRP_no          ; return if not in lower RAM
          CMP FRETOP+1
          BCC BRP_no          ; return if not dynamic string
          BNE BRP_10
          CPX FRETOP
          BCC BRP_no          ; return if not dynamic string
BRP_10    STX INDEXA          ; INDEXA = string pointer
          STA INDEXA+1
          PLA                 ; length
          TAX                 ; return length in X
          CLC
          ADC INDEXA
          STA INDEXC
          LDA INDEXA+1
          ADC #0
          STA INDEXC+1        ; INDEXC = INDEXA + length
          LDY #1              ; expected by callers
          SEC
          RTS
BRP_no    PLA
          CLC
          RTS

; This subroutines converts a real value to a 16 bit integer.
; There is no sign or range check in this routine. So it may
; be used for signed integers (-32768 to 32767) or unsigned
; integers (0 to 65535).

; ********
  FAC1_INT
; ********

          JSR FAC1_LSR
          BIT FAC1SI
          BPL FACI_Ret
          SEC
          TYA
          SBC FAC1M4
          STA FAC1M4
          TYA
          SBC FAC1M3
          STA FAC1M3
FACI_Ret  RTS

          .FILL $ba88-* (0)

; ********************
  Basic_PRINTN ; $ba88
; ********************

          JSR Basic_CMD
          JMP Set_Default_Channels

; *********
  Basic_CMD
; *********

          JSR Get_Byte_Value  ; X = value
          BEQ CMD_10          ; -> no more parameter
          LDA #','
          JSR Need_A
CMD_10    PHP
          JSR CHKOUT          ; set channel
          STX IOPMPT          ; mark output redirected
          PLP
          JMP Basic_PRINT     ; do the printing


PRINT_10  JSR Print_String_From_Descriptor
PRINT_20  JSR CHRGOT

; ***********
  Basic_PRINT
; ***********

          BEQ Print_CR
PRINT_30  BEQ PRINT_Ret
          CMP #$a3            ; TAB(   token
          BEQ Tab_Spc
          CMP #$a6            ; SPC(   token
          CLC
          BEQ Tab_Spc
          CMP #','
          BEQ Comma_Tab
          CMP #';'
          BEQ TaSp_50
          JSR Eval_Expression
          BIT VALTYP
          BMI PRINT_10
          JSR Format_FAC1
          JSR Create_String_Descriptor
          JSR Print_String_From_Descriptor
          JSR Cursor_Right_Or_Space
          BNE PRINT_20           ; always

; *************
  Terminate_BUF
; *************

          LDA #0
          STA BUF,X
          LDX #<[BUF-1]
          LDY #>[BUF-1]
          LDA IOPMPT
          BNE PRINT_Ret

; ****************
  Print_CR ; $badf
; ****************

          LDA #CR
          JMP CHROUT
PRINT_Ret RTS

          .FILL $baf0-* (0)

; *****************
  Comma_Tab ; $baf0
; *****************

          LDA CursorCol
          SEC
CoTa_10   SBC #10
          BCS CoTa_10
          EOR #$ff
          ADC #1
          BNE TaSp_10           ; always

; *******
  Tab_Spc
; *******

          PHP                 ; C=1 TAB, C=0 SPC
          JSR Get_Next_Byte_Value
          CMP #')'
          BNE SynErr
          PLP
          BCC TaSp_20         ; SPC -> use X
          TXA
          SBC CursorCol       ; TAB -> use X - Col
          BCC TaSp_50         ; branch if TAB < Col
TaSp_10   TAX
TaSp_20   INX
          BNE TaSp_40         ; always
TaSp_30   JSR Cursor_Right_Or_Space
TaSp_40   DEX
          BNE TaSp_30
TaSp_50   JSR CHRGET
          JMP PRINT_30

; ********************
  Print_String ; $bb1d
; ********************

          JSR Create_String_Descriptor

; ************************************
  Print_String_From_Descriptor ; $bb20
; ************************************

          JSR Free_String_FAC1
          TAX
          BEQ PSFD_Ret        ; zero length ?
          LDY #0
PSFD_10   LDA (INDEXA),Y
          JSR CHROUT
          INY
          DEX
          BNE PSFD_10
PSFD_Ret  RTS

          .FILL $bb3a-* (0)

; *****************************
  Cursor_Right_Or_Space ; $bb3a
; *****************************

          LDA IOPMPT
          BEQ CROS_10
          LDA #' '
          .BYTE $2c
CROS_10   LDA #RIGHT
          .BYTE $2c

; *******************
  Print_Question_Mark
; *******************

          LDA #'?'

; **********
  Print_Char
; **********

          JMP CHROUT

          .FILL $bb4c-* (0)

; *****************
  Bad_Input ; $bb4c
; *****************

          LDA INPFLG
          BEQ BaIn_30
          BMI BaIn_10
          LDY #$ff            ; invalidate CURLIN
          BNE BaIn_20
BaIn_10   LDA DATLIN
          LDY DATLIN+1
BaIn_20   STA CURLIN
          STY CURLIN+1
SynErr    JMP Syntax_Error
BaIn_30   LDA IOPMPT
          BEQ BaIn_40
          LDX #[Msg_DATA - Msg_Start] ; $bf
          JMP Basic_Error
BaIn_40   LDA #<Msg_Redo_From_Start
          LDY #>Msg_Redo_From_Start
          JSR Print_String
          LDA OLDTXT
          LDY OLDTXT+1
          STA TXTPTR
          STY TXTPTR+1
          RTS

; *****************
  Basic_GET ; $bb7a
; *****************

          JSR Assert_Non_Direct
          CMP #'#'
          BNE GET_10
          JSR CHRGET
          JSR Get_Byte_Value  ; channel #
          JSR Need_Comma
          JSR CHKIN
          STX IOPMPT
GET_10    LDX #<[BUF+1]
          LDY #>[BUF+1]
          LDA #0
          STA BUF+1
          LDA #$40            ; no prompt
          JSR Read_Get
          LDX IOPMPT
          BNE SDC_10
          RTS

          .FILL $bba4-* (0)

; ********************
  Basic_INPUTN ; $bba4
; ********************

          JSR Get_Byte_Value
          JSR Need_Comma
          JSR CHKIN
          STX IOPMPT
          JSR Input_String

; ********************
  Set_Default_Channels
; ********************

          LDA IOPMPT
SDC_10    JSR CLRCHN
          LDX #0
          STX IOPMPT
          RTS

          .FILL $bbbe-* (0)

; *******************
  Basic_INPUT ; $bbbe
; *******************

          CMP #QUOTE
          BNE Input_String
          JSR Make_String_Descriptor_From_Code
          LDA #';'
          JSR Need_A          ; prompt delimiter
          JSR Print_String_From_Descriptor

; ************
  Input_String
; ************

          JSR Assert_Non_Direct
          LDA #','
          STA BUF-1
InSt_10   JSR Prompt_And_Input
          LDA IOPMPT
          BEQ InSt_20
          LDA STATUS
          AND #3              ; check time out bits
          BEQ InSt_20
          JSR Set_Default_Channels
          JMP Basic_DATA
InSt_20   LDA BUF
          BNE READ_10
          JMP Input_String_Patch
InSt_30   CLC
          JMP END_20

          .FILL $bbf5-* (0)

; ************************
  Prompt_And_Input ; $bbf5
; ************************

          LDA IOPMPT
          BNE PAI_10
          JSR Print_Question_Mark
          JSR Cursor_Right_Or_Space
PAI_10    JMP Read_String

; ******************
  Basic_READ ; $bc02
; ******************

          LDX DATPTR
          LDY DATPTR+1
          LDA #$98            ; flag for READ
          .BYTE $2c
READ_10    LDA #0

; ********
  Read_Get
; ********

          STA INPFLG
          STX INPPTR
          STY INPPTR+1

; loop reading variables

READ_15   JSR Parse_Name      ; address of variable
          STA FORPNT
          STY FORPNT+1        ; FORPNT = variable pointer
          LDA TXTPTR
          LDY TXTPTR+1        ; save TXTPTR
          STA YSAVE
          STY YSAVE+1
          LDX INPPTR          ; TXTPTR = INPPTR
          LDY INPPTR+1
          STX TXTPTR
          STY TXTPTR+1
          JSR CHRGOT
          BNE READ_35
          BIT INPFLG
          BVC READ_20         ; bit 6 set: GETIN
          JSR GETIN
          STA BUF
          LDX #<[BUF-1]
          LDY #>[BUF-1]
          BNE READ_30         ; always

READ_20   BMI READ_75         ; bit 7 set: READ
          LDA IOPMPT          ; else: INPUT
          BNE READ_25
          JSR Print_Question_Mark
READ_25   JSR Prompt_And_Input
READ_30   STX TXTPTR
          STY TXTPTR+1

; loop reading character

READ_35   JSR CHRGET
          BIT VALTYP
          BPL READ_60         ; -> numeric
          BIT INPFLG
          BVC READ_40         ; -> not GET
          INX
          STX TXTPTR          ; GET A$
          LDA #0
          STA CHARAC
          BEQ READ_45         ; always

; input or read string

READ_40   STA CHARAC
          CMP #QUOTE
          BEQ READ_50
          LDA #':'
          STA CHARAC
          LDA #','
READ_45   CLC
READ_50   STA ENDCHR
          LDA TXTPTR
          LDY TXTPTR+1
          ADC #0
          BCC READ_55
          INY
READ_55   JSR Create_String_Descriptor_AY
          JSR Restore_Execution_Pointer
          JSR Assign_String_Variable
          JMP READ_65

; input or read number

READ_60   JSR Read_Real_To_FAC1
          LDA INTFLG
          JSR Assign_Numeric_variable

; more to read ?

READ_65   JSR CHRGOT
          BEQ READ_70         ; -> nothing left
          CMP #','
          BEQ READ_70         ; comma or error
          JMP Bad_Input

READ_70   LDA TXTPTR
          LDY TXTPTR+1
          STA INPPTR          ; advance input pointer
          STY INPPTR+1
          LDA YSAVE
          LDY YSAVE+1
          STA TXTPTR          ; restore text pointer
          STY TXTPTR+1
          JSR CHRGOT
          BEQ READ_85         ; -> goto loop end
          JSR Need_Comma
          JMP READ_15         ; -> next item

; READ from DATA statements

READ_75   JSR Skip_To_EOS
          INY
          TAX
          BNE READ_80
          LDX #$2a
          INY
          LDA (TXTPTR),Y
          BEQ NEXT_30
          INY
          LDA (TXTPTR),Y
          STA DATLIN
          INY
          LDA (TXTPTR),Y
          INY
          STA DATLIN+1
READ_80   LDA (TXTPTR),Y
          TAX
          JSR Add_Y_To_Execution_Pointer
          CPX #$83            ; DATA token
          BNE READ_75
          JMP READ_35
;

READ_85   LDA INPPTR
          LDY INPPTR+1
          LDX INPFLG
          BPL READ_90
          JMP REST_10
READ_90   LDY #0
          LDA (INPPTR),Y
          BEQ READ_Ret
          LDA IOPMPT
          BNE READ_Ret
          LDA #<Msg_Extra_Ignored
          LDY #>Msg_Extra_Ignored
          JMP Print_String
READ_Ret  RTS

          .FILL $bcf7-* (0)

; *************************
  Msg_Extra_Ignored ; $bcf7
; *************************

          .BYTE "?EXTRA IGNORED\r",0

; *******************
  Msg_Redo_From_Start
; *******************

          .BYTE "?REDO FROM START\r",0

; ******************
  Basic_NEXT ; $bd19
; ******************

          BNE NEXT_10         ; branch if index after NEXT
          LDY #0
          BEQ NEXT_20
NEXT_10   JSR Parse_Name      ; address of index
          STA FORPNT
NEXT_20   STY FORPNT+1        ; address or zero if no index
          JSR Find_Active_FOR
          BEQ NEXT_40         ; branch if found
          LDX #0              ; index for next without for error
NEXT_30   BEQ CVT_40           ; -> basic error
NEXT_40   TXS                 ; set stack pointer
          TXA                 ; A = SP
          CLC
          ADC #4              ; A = SP + 4 (STEP value)
          PHA
          ADC #6
          STA INDEXB          ; address TO   value low
          PLA                 ; address STEP value low
          LDY #>[STACK]       ; address STEP value high
          JSR Load_FAC1_AY
          TSX                 ; X = SP    <-- DELETE obsolete
          LDA STACK+9,X       ; sign of STEP
          STA FAC1SI
          LDA FORPNT
          LDY FORPNT+1           ; address of index
          JSR Add_Var_AY_To_FAC1 ; FAC1 = index + STEP
          JSR FAC1_To_FORPNT
          LDY #>[STACK]          ; address TO value high
          JSR Compare_FAC1_INDEXB_Y
          TSX
          SEC
          SBC STACK+9,X          ; STEP sign
          BEQ NEXT_60            ; loop finished
          LDA STACK+15,X
          STA CURLIN
          LDA STACK+16,X
          STA CURLIN+1           ; line # of loop body
          LDA STACK+18,X
          STA TXTPTR
          LDA STACK+17,X
          STA TXTPTR+1           ; address of loop body
NEXT_50   JMP Execute            ; next iteration
NEXT_60   TXA
          ADC #$11               ; carry was set
          TAX
          TXS                    ; remove loop structure from stack
          JSR CHRGOT             ; character after NEXT
          CMP #','               ; comma ?
          BNE NEXT_50            ; continue with follow up statement
          JSR CHRGET             ; get another index
          JSR NEXT_10            ; perform NEXT again

; ********************
  Eval_Numeric ; $bd84
; ********************

          JSR Eval_Expression

; ******************
  Is_Numeric ; $bd87
; ******************

          CLC
          .BYTE $24

; *****************
  Is_String ; $bd89
; *****************

          SEC

; **********************
  Check_Var_Type ; $bd8a
; **********************

          BIT VALTYP          ; $FF = string   $00 = numeric
          BMI CVT_20          ; branch on string type
          BCS CVT_30          ; string assert -> TYPE MISMATCH
CVT_10    RTS
CVT_20    BCS CVT_10          ; looking for string, found string
CVT_30    LDX #[Msg_TYPE - Msg_Start] ; $a3
CVT_40    JMP Basic_Error     ; want string got numeric or vice versa

; called from $b947 Basic_LET
;             $c06b Op_COMPARE

; ***********************
  Eval_Expression ; $bd98
; ***********************

          LDX TXTPTR          ; TXTPTR--
          BNE EvEx_05
          DEC TXTPTR+1
EvEx_05   DEC TXTPTR
          LDX #0
          .BYTE $24           ; skip next PHA
EvEx_10   PHA                 ; push ACCSYM (comparison op + type)
          TXA
          PHA                 ; push X
          JSR Check_Stack_Avail
          JSR Evaluate
          LDA #0
          STA ACCSYM          ;clear type comparison flag
EvEx_15   JSR CHRGOT
EvEx_20   SEC
          SBC #$b1            ; > token ( start of comparison ops)
          BCC EvEx_25         ; -> binary operators
          CMP #3              ; ( 3 comparison operators > = < )
          BCS EvEx_25         ; -> function
          CMP #2              ; '>'  A = 1
          ADC #1              ; '='  A = 2
          EOR ACCSYM          ; '<'  A = 4
          CMP ACCSYM
          BCC SynErr1           ; -> syntax error
          STA ACCSYM          ; rememer comparison operator
          JSR CHRGET
          JMP EvEx_20         ; loop (maybe <= or >= or <>)

EvEx_25   LDX ACCSYM
          BNE EvEx_50
          BCS Pop_FAC2        ; function ( SGN INT ... MID$ )
          ADC #7
          BCC Pop_FAC2        ; ->
          ADC VALTYP          ; C=1               0 1 2 3 4  5  6
          BNE EvEx_30         ; binary operator ( + - * / ^ AND OR )
          JMP Concatenate     ; '+' with strings

EvEx_30   ADC #$ff
          STA INDEXA          ; op code (0-9 for '+' to '<')
          ASL A               ; op code * 2
          ADC INDEXA          ; op code * 3
          TAY                 ; Y = index
EvEx_35   PLA                 ; precedence
          CMP Basic_Operator_Table,Y
          BCS PoFA_20         ; previous op has higher precedence
          JSR Is_Numeric
EvEx_40   PHA                 ; save precedence
EvEx_45   JSR Use_Operator
          PLA                 ; restore precedence
          LDY YSAVE           ; restore index
          BPL EvEx_60
          TAX
          BEQ PoFA_10
          BNE PoFA_40         ; always

EvEx_50   LSR VALTYP          ; clear type
          TXA                 ; comparison operator
          ROL A               ; com op * 2
          LDX TXTPTR          ; TXTPTR--
          BNE EvEx_55
          DEC TXTPTR+1
EvEx_55   DEC TXTPTR
          LDY #27             ; index to Op_COMPARE
          STA ACCSYM          ; com op * 2
          BNE EvEx_35
EvEx_60   CMP Basic_Operator_Table,Y
          BCS PoFA_40         ; higher precedence
          BCC EvEx_40         ; lower  precedence

; ************
  Use_Operator
; ************

          LDA Basic_Operator_Table+2,Y
          PHA
          LDA Basic_Operator_Table+1,Y
          PHA
          JSR Push_Operand
          LDA ACCSYM
          JMP EvEx_10

SynErr1   JMP Syntax_Error

; ************
  Push_Operand
; ************

          LDX Basic_Operator_Table,Y ; operator priority
          SEC                        ; push with sign

; *********
  Push_FAC1
; *********

          PLA                 ; return address-1 low
          STA INDEXA
          PLA                 ; return address-1 high
          STA INDEXA+1
          BCC PuFA_10
          LDA FAC1SI          ; sign of operand
          PHA
PuFA_10   JSR Round_FAC1
          LDA FAC1M4
          PHA
          LDA FAC1M3
          PHA
          LDA FAC1M2
          PHA
          LDA FAC1M1
          PHA
          LDA FAC1EX
          PHA
          LDA INDEXA+1
          PHA
          LDA INDEXA
          PHA
          RTS

; ********
  Pop_FAC2
; ********

          LDY #$ff
          PLA
PoFA_10   BEQ PoFA_50
PoFA_20   CMP #$64            ; precedence of Op_COMPARE
          BEQ PoFA_30         ; strings may be comapred too
          JSR Is_Numeric
PoFA_30   STY YSAVE
PoFA_40   PLA
          LSR A               ; C = VALTYPE
          STA TANSGN          ; comparison operator
          PLA
          STA FAC2EX
          PLA
          STA FAC2M1
          PLA
          STA FAC2M2
          PLA
          STA FAC2M3
          PLA
          STA FAC2M4
          PLA
          STA FAC2SI
          EOR FAC1SI
          STA STRPTR
PoFA_50   LDA FAC1EX
          RTS                 ; -> use operator

          .FILL $be7e-* (0)

; ****************
  Evaluate ; $be7e
; ****************

          JMP (IEVAL)

; ****************
  DEF_EVAL ; $be81
; ****************

          LDA #0
          STA VALTYP          ; default numeric
Eva_10    JSR CHRGET
          BCS Eva_30          ; branch if not numeric
Eva_20    JMP Read_Real_To_FAC1
Eva_30    JSR Is_Alpha
          BCS JMP_Get_Var     ; branch to Get_Var
          CMP #$ff            ; Pi token
          BNE Eva_40
          LDA #<Float_PI
          LDY #>Float_PI
          JSR Load_FAC1_AY
          JMP CHRGET
Float_PI  .REAL $82490fdaa1   ; 3.14159265254
Eva_40    CMP # '.'
          BEQ Eva_20          ; real number starting with '.'
          CMP #$ab            ; '-' token sign
          BEQ Negate
          CMP #$aa            ; '+' token sign
          BEQ Eva_10
          CMP #QUOTE
          BNE Eva_50

; ********************************
  Make_String_Descriptor_From_Code
; ********************************

          LDA TXTPTR
          LDY TXTPTR+1
          ADC #0              ; INC (A,Y)
          BCC MSDF_10
          INY
MSDF_10   JSR Create_String_Descriptor
          JMP Restore_Execution_Pointer

Eva_50    CMP #$a8            ; NOT token
          BNE Eva_60
          LDY #24             ; NOT index to Op Table
          BNE Nega_10         ; always

; ******
  Op_NOT
; ******

; convert real in FAC1 to integer
; do a bitwise EOR (negate)
; convert result back to FAC1
; 0 : false, <> 0 : true

          JSR Real_To_Integer
          LDA FAC1M4
          EOR #$ff
          TAY
          LDA FAC1M3
          EOR #$ff
          JMP AY_To_Real

Eva_60    CMP #$a5            ; FN(  token
          BNE Eva_70
          JMP Eval_FNX
Eva_70    CMP #$b4            ; SGN( token
          BCC Eval_In_Parenthesis
          JMP Function_Call

; *******************
  Eval_In_Parenthesis
; *******************

          JSR Need_Left_Parenthesis
          JSR Eval_Expression

; **********************
  Need_Right_Parenthesis
; **********************

          LDA #')'
          .BYTE $2c

; *********************
  Need_Left_Parenthesis
; *********************

          LDA #'('
          .BYTE $2c

; **********
  Need_Comma
; **********

          LDA #','

; ******
  Need_A
; ******

          LDY #0
          CMP (TXTPTR),Y
          BNE Syntax_Error
          JMP CHRGET

; ************
  Syntax_Error
; ************

          LDX #[Msg_SYNTA - Msg_Start]
          JMP Basic_Error

; ******
  Negate
; ******

          LDY #21             ; index to Op_NEGATE
Nega_10   PLA
          PLA
          JMP EvEx_45

; ***********
  JMP_Get_Var
; ***********

          JMP Get_Var

; *************
  Any_Except_Pi
; *************

          JSR CHRGET
          CMP #$ff            ; Pi token
          BEQ Syntax_Error
          JMP CHRGOT

; ******************
  Input_String_Patch
; ******************

          LDA IOPMPT
          BNE InSt_40
          JMP InSt_30
InSt_40   LDA STATUS
          AND #$40            ; check EOF
          BNE InSt_50
          JMP InSt_10
InSt_50   JMP READ_10

; ************************
  Extended_Statement_Table
; ************************

          .WORD Renumber         - 1
          .WORD Monitor          - 1
          .WORD Delete           - 1
          .WORD Find_Text        - 1
          .WORD Replace          - 1
          .WORD Merge            - 1
          .WORD OLD              - 1

; **********************
  Extended_Keyword_Table
; **********************

          .BYTE "RENUMBER"^
          .BYTE "MONITOR"^
          .BYTE "DELETE"^
          .BYTE "FIND"^
          .BYTE "REPLACE"^
          .BYTE "MERGE"^
          .BYTE "OLD"^
          .BYTE 0

          .FILL $bf8c-* (0)

; *******
  Get_Var
; *******

; Parse_Name checks, whether the caller is Get_Var
; It does not create a so far unknown variable in this case

; Output: FAC1 a) integer value converted to real
;              b) real value
;              c) address of string (FAC1M3)

          JSR Parse_Name      ; call address checked in Create_Var !
          STA FAC1M3          ; A = VARPTR
          STY FAC1M4          ; Y = VARPTR+1
          LDA VARNAM
          LDY VARNAM+1
          LDX VALTYP
          BEQ Get_Numeric_Value
          LDX FAC1M4          ; VARPTR+1
          BPL GeVa_Ret        ; is assigned: no special variables
          CMP #'T'            ; TI$ - 1st. char
          BNE GeVa_10
          CPY #'I'+$80        ; TI$ - 2nd. char
          BNE GeVa_10
          JSR Load_Jiffyclock
          STY TMPVAR+1        ; TMPVAR+1 = 0
          DEY
          STY TMPPTD          ; TMPPTD = $ff
          LDY #6
          STY TMPVAR          ; # of digits
          LDY #$24            ; index to Decimal_Conversion_Table
          JSR Format_Jiffyclock
          JMP STR_10           ; create string and descriptor

GeVa_10   CMP #'D'            ; DS$ - 1st. char
          BNE GeVa_Ret
          CPY #'S'+$80        ; DS$ - 2nd. char
          BNE GeVa_Ret
          JSR Kernal_Read_DS
          LDA #<DOS_Status
          LDY #>DOS_Status
          JMP Create_String_Descriptor
GeVa_Ret  RTS

; *****************
  Get_Numeric_Value
; *****************

          LDX INTFLG
          BPL Load_Float
          LDY #0
          LDA (FAC1M3),Y
          TAX
          INY
          LDA (FAC1M3),Y
          TAY
          TXA
          JMP AY_To_Real

; **********
  Load_Float
; **********

          LDX FAC1M4
          BPL Load_Float_Var
          CMP #'T'            ; TI - 1st. char
          BNE Check_ST_Var
          CPY #'I'            ; TI - 2nd. char
          BNE Load_Float_Var
          JSR Load_Jiffyclock
          TYA                 ; FROUND := $00  FAC1SI := $00
          LDX #$a0            ; FAC1EX := $a0
          JMP CITR_10           ; normalize FAC1

          .FILL $c003-* (0)

; ***********************
  Load_Jiffyclock ; $c003
; ***********************

          LDA #<[JIFFY_CLOCK-2] ; load mixture of random seed
          LDY #>[JIFFY_CLOCK-2] ; and jiffy clock
          SEI
          JSR Load_FAC1_AY      ; FAC1M2/3/4 = Jiffy Clock
          CLI
          STY FAC1M1            ; FAC1M1 = 0
          RTS

; ************
  Check_ST_Var
; ************

          CMP #'S'
          BNE Check_DS_Var
          CPY #'T'
          BNE Check_DS_Var
          LDA STATUS
          JMP A_To_FAC1

; ************
  Check_DS_Var
; ************

          CMP #'D'
          BNE Load_Float_Var
          CPY #'S'
          BNE Load_Float_Var
          JSR Kernal_Read_DS
          AND #15
          ASL A
          STA GARBFL
          ASL A
          ASL A
          ADC GARBFL
          STA GARBFL
          LDA DOS_Status+1
          AND #15
          ADC GARBFL
          JMP A_To_FAC1

          .FILL $c040-* (0)

; **********************
  Load_Float_Var ; $c040
; **********************

          LDA FAC1M3
          LDY FAC1M4
          JMP Load_FAC1_AY

; *************
  Function_Call
; *************

; called from Evaluate
; Input:  A = function token
;         token  range = $b4 SGN - $ca MID$
;         scaled range = $68 SGN - $92 MID$

          ASL A               ; A = token * 2
          PHA                 ; save
          TAX                 ; X = token * 2
          JSR CHRGET
          CPX #$8f            ; limit of single numeric argument
          BCC FuCa_10         ; branch if not LEFT$, RIGHT$, MID$
          JSR Need_Left_Parenthesis
          JSR Eval_Expression
          JSR Need_Comma
          JSR Is_String       ; 1st. arg must be string
          PLA                 ; scaled token
          TAX                 ; X = $90 LEFT$, $92 RIGHT$, $94 MID$
          LDA FAC1M4
          PHA
          LDA FAC1M3          ; push pointer to 1st. argUment
          PHA
          TXA
          PHA                 ; save scaled token
          JSR Get_Byte_Value  ; get 2nd. argument (byte value)
          PLA
          TAY                 ; Y = scaled token
          TXA
          PHA                 ; push 2nd. argument
          JMP FuCa_20
FuCa_10   JSR Eval_In_Parenthesis
          PLA                 ; scaled token
          TAY                 ; Y = index
FuCa_20   LDA Basic_Function_Table-$68,Y
          STA FUNJMP
          LDA Basic_Function_Table-$67,Y
          STA FUNJMP+1
          JSR JUMPER
          JMP Is_Numeric

; *****
  Op_OR
; *****

          SEC
          .BYTE $24

; ******
  Op_AND
; ******

          CLC
          ROR CHARAC          ; bit7=1:OR bit7=0:AND
          JSR Real_To_Integer
          LDA FAC1M3
          PHA
          LDA FAC1M4
          PHA
          JSR FAC2_To_FAC1
          JSR Real_To_Integer
          PLA
          BIT CHARAC
          BPL ANDOR_10
          ORA FAC1M4
          TAY
          PLA
          ORA FAC1M3
          JMP AY_To_Real
ANDOR_10  AND FAC1M4
          TAY
          PLA
          AND FAC1M3
          JMP AY_To_Real

; ************
; Float_M32768
; ************

;         .REAL $9080000000   ; -32768

          .FILL $c0b6-* (0)

; ******************
  Op_COMPARE ; $c0b6
; ******************

; Input:  C = VALTYPE
;         TANSGN = comparison mask
;         FAC1 = right operand
;         FAC2 = left  operand

          JSR Check_Var_Type
          BCS OpCO_10         ; -> compare strings
          LDA FAC2SI          ; transfer sign to FAC2M1
          ORA #$7f
          AND FAC2M1
          STA FAC2M1
          LDA #<FAC2EX
          LDY #>FAC2EX
          JSR Compare_FAC1_AY ; -1: FAC1 > FAC2  +1: FAC1 < FAC2
          TAX                 ; set flags
          JMP OpCO_40
OpCO_10   LDA #0
          STA VALTYP          ; result = numeric (-1:true, 0:false)
          DEC ACCSYM          ; OBSOLETE
          JSR Free_String_FAC1
          STA FAC1EX
          STX FAC1M1          ; 1st. string
          STY FAC1M2
          LDA FAC2M3
          LDY FAC2M4
          JSR Free_String_AY
          STX FAC2M3          ; 2nd. string
          STY FAC2M4
          TAX                 ; X = length2
          SEC
          SBC FAC1EX          ; length difference
          BEQ OpCO_20         ; -> equal length
          LDA #1
          BCC OpCO_20
          LDX FAC1EX          ; X = length1 (shorter one)
          LDA #-1
OpCO_20   STA FAC1SI          ; store length1 <=> length2 (-1,0,1)
          LDY #-1
          INX
OpCO_30   INY
          DEX
          BNE OpCO_50
          LDX FAC1SI          ; equal so far
OpCO_40   BMI OpCO_60         ; left > right
          CLC
          BCC OpCO_60
OpCO_50   LDA (FAC2M3),Y
          CMP (FAC1M1),Y
          BEQ OpCO_30
          LDX #-1
          BCS OpCO_60
          LDX #1
OpCO_60   INX                 ; C=1 : string2 >= string1
          TXA                 ; C=0 : string2 <  string1
          ROL A
          AND TANSGN          ; ACCSYM comparison mask
          BEQ OpCO_70         ; > 1   = 2   < 4
          LDA #-1             ; true
OpCO_70   JMP A_To_FAC1


DIM_10    JSR Need_Comma

; *********
  Basic_DIM
; *********

          TAX
          JSR Get_Array_Address
          JSR CHRGOT
          BNE DIM_10
          RTS

; **********
  Parse_Name
; **********

          LDX #0
          JSR CHRGOT

; *****************
  Get_Array_Address
; *****************

          STX DIMFLG

; **************
  Get_FN_Address
; **************

          STA VARNAM
          JSR CHRGOT
          JSR Is_Alpha
          BCS Get_Address
GFA_Err   JMP Syntax_Error

; *******************
  Get_Address ; $c13f
; *******************

          LDX #0              ; set defaults
          STX VALTYP          ; numeric
          STX INTFLG          ; real
          JSR CHRGET          ; 2nd. char of name
          BCC GeAd_05         ; -> branch if numeric
          JSR Is_Alpha
          BCC GeAd_15         ; -> branch if not alpha
GeAd_05   TAX                 ; X = 2nd. char of name
GeAd_10   JSR CHRGET          ; skip all alphanumeric characters
          BCC GeAd_10         ; after the 2nd. one
          JSR Is_Alpha
          BCS GeAd_10
GeAd_15   CMP #'$'            ; string ?
          BNE GeAd_20
          LDA #$ff            ; set string flag
          STA VALTYP          ; $ff = string  $00 = numeric
          BNE GeAd_25         ; branch always
GeAd_20   CMP #'%'            ; integer ?
          BNE GeAd_30
          LDA SUBFLG          ; integer allowed ?
          BNE GFA_Err         ; -> not in this context
          LDA #$80
          STA INTFLG          ; integer flag
          ORA VARNAM
          STA VARNAM          ; mark variable as integer
GeAd_25   TXA                 ; A = 2nd. char
          ORA #$80            ; set string/integer bit
          TAX                 ; X = 2nd. char OR $80
          JSR CHRGET          ; next char after '$' or '%'
GeAd_30   STX VARNAM+1        ; store 2nd. char of name
          SEC
          ORA SUBFLG          ; Or with FOR, FN flag
          SBC #'('            ; array ?
          BNE GeAd_35         ; -> no
          JMP Find_Array      ; read subscripts
GeAd_35   LDY #0
          STY SUBFLG          ; clear integer disable flag
          LDA VARTAB
          LDX VARTAB+1        ; (A/X) = VARTAB
GeAd_40   STX TMPPTC+1        ; find variable in (VARTAB..ARYTAB)
GeAd_45   STA TMPPTC          ; TMPPTC = (A/X)
          CPX ARYTAB+1
          BNE GeAd_50
          CMP ARYTAB
          BEQ Create_Var      ; (A/X) == ARYTAB -> not found
GeAd_50   LDA VARNAM
          CMP (TMPPTC),Y      ; compare 1st. char
          BNE GeAd_60
          LDA VARNAM+1
          INY                 ; Y = 1
          CMP (TMPPTC),Y      ; compare 2nd. char
          BNE GeAd_55
          JMP CrVa_80           ; -> found
GeAd_55   DEY                 ; Y = 0
GeAd_60   CLC
          LDA TMPPTC
          ADC #7              ; TMPPTC += 7
          BCC GeAd_45
          INX
          BNE GeAd_40         ; branch always

; ********
  Is_Alpha
; ********

          CMP #'A'
          BCC IsAl_Ret
          SBC #'Z'+1
          SEC
          SBC #$a5            ; restore original content
IsAl_Ret  RTS                 ; C=1 if (A..Z)

; ******************
  Create_Var ; $c1c0
; ******************

          PLA
          PHA                 ; return address low
          CMP #<[Get_Var+2]   ; $8e called from Get_Var ?
          BNE CrVa_10
CrVa_05   LDA #<[Float_0_5 + 2]; void descriptor (0,0,0)
          LDY #>[Float_0_5 + 2]; or value in ROM
          RTS
CrVa_10   LDA VARNAM
          LDY VARNAM+1
          CMP #'T'            ; check reserved names
          BNE CrVa_20
          CPY #'I'+$80        ; TI$ = "hhmmss"  sets jiffy clock
          BEQ CrVa_05         ; create void descriptor
          CPY #'I'            ; TI  (read only variable)
          BNE CrVa_20
CrVa_15   JMP Syntax_Error    ; tried to use reserved name
CrVa_20   CMP #'S'
          BNE CrVa_25
          CPY #'T'            ; ST  (read only variable)
          BEQ CrVa_15
CrVa_25   CMP #'D'
          BNE CrVa_30
          CPY #'S'            ; DS  (read only variable)
          BEQ CrVa_15
          CPY #'S'+$80        ; DS$ (read only variable)
          BEQ CrVa_15
CrVa_30   LDA ARYTAB
          LDY ARYTAB+1        ; (A/Y)  = ARYTAB
          STA TMPPTC
          STY TMPPTC+1        ; TMPPTC = ARYTAB
          LDA STREND
          LDY STREND+1        ; (A/Y)  = STREND
          STA TMPPTB
          STY TMPPTB+1        ; TMPPTB = STREND
          CLC
          ADC #7              ; 7 bytes for a new variable
          BCC CrVa_35
          INY
CrVa_35   STA TMPPTA
          STY TMPPTA+1        ; TMPPTA = TMPPTB + 7
          JSR Open_Up_Space   ; move array space 7 bytes up
          LDA TMPPTA
          LDY TMPPTA+1
          INY
          STA ARYTAB
          STY ARYTAB+1        ; ARYTAB += 7
          STA TMPPTA
          STY TMPPTA+1        ; TMPPTA = ARYTAB

; scan through array area and adjust all dynamic string
; back references to the new descriptor position

CrVa_40   LDA TMPPTA
          LDX TMPPTA+1
CrVa_45   CPX STREND+1        ; TMPPTA == STREND ?
          BNE CrVa_50
          CMP STREND
          BEQ CrVa_75         ; -> initialize variable
CrVa_50   STA INDEXA
          STX INDEXA+1        ; INDEXA = TMPPTA
          LDY #0
          LDA (INDEXA),Y
          TAX                 ; X = 1st. char
          INY                 ; Y = 1
          LDA (INDEXA),Y
          PHP                 ; push flags of 2nd. char
          INY                 ; Y = 2
          LDA (INDEXA),Y      ; A = array length low
          ADC TMPPTA
          STA TMPPTA
          INY                 ; Y = 3
          LDA (INDEXA),Y      ; A = array length high
          ADC TMPPTA+1
          STA TMPPTA+1        ; TMPPTA += array length
          PLP                 ; flags of 2nd. char
          BPL CrVa_40         ; -> branch for real array
          TXA                 ; flags for 1st. char
          BMI CrVa_40         ;-> branch for integer
          INY                 ; Y = 4
          LDA (INDEXA),Y      ; A = # of dimensions
          LDY #0
          ASL A               ; dimensions * 2
          ADC #5              ; plus 5 bytes for header
          ADC INDEXA
          STA INDEXA
          BCC CrVa_55
          INC INDEXA+1        ; INDEXA += header size
CrVa_55   LDX INDEXA+1
          CPX TMPPTA+1        ; INDEXA == TMPPTA (end of array) ?
          BNE CrVa_60
          CMP TMPPTA
          BEQ CrVa_45         ; -> branch on end of array
CrVa_60   LDY #0
          LDA (INDEXA),Y      ; length
          BEQ CrVa_70         ; -> next item
          INY                 ; Y = 1
          CLC
          ADC (INDEXA),Y      ; A = length + address low
          STA TMPPTB
          TAX
          INY                 ; Y = 2
          LDA (INDEXA),Y      ; address high
          ADC #0
          STA TMPPTB+1        ; TMPPTB = back reference
          CMP FRETOP+1
          BCC CrVa_70         ; -> branch if not in string area
          BNE CrVa_65
          CPX FRETOP
          BCC CrVa_70         ; -> branch if not in string area
CrVa_65   DEY                 ; Y = 1
          LDA INDEXA+1        ; back reference high
          STA (TMPPTB),Y      ; store
          DEY                 ; Y = 0
          LDA INDEXA          ; back reference low
          STA (TMPPTB),Y      ; store
CrVa_70   LDA #3
          CLC
          ADC INDEXA
          STA INDEXA
          BCC CrVa_55
          INC INDEXA+1        ; INDEXA += 3 (next descriptor)
          BNE CrVa_55         ; branch always

CrVa_75   LDY #0
          LDA VARNAM
          STA (TMPPTC),Y      ; byte 0: 1st. char
          INY
          LDA VARNAM+1
          STA (TMPPTC),Y      ; byte 1: 2nd. char
          LDA #0
          INY
          STA (TMPPTC),Y      ; byte 2-6: 0
          INY
          STA (TMPPTC),Y
          INY
          STA (TMPPTC),Y
          INY
          STA (TMPPTC),Y
          INY
          STA (TMPPTC),Y
CrVa_80   LDA TMPPTC
          CLC
          ADC #2
          LDY TMPPTC+1
          BCC CrVa_85
          INY
CrVa_85   STA VARPTR          ; VARPTR = TMPPTC + 2
          STY VARPTR+1
          RTS

          .FILL $c2c8-* (0)

; ******************************
  Array_Pointer_To_First ; $c2c8
; ******************************

          LDA COUNT           ; # of dimensions
          ASL A               ; in bytes
          ADC #5              ; plus header size
          ADC TMPPTC          ; plus start of array
          LDY TMPPTC+1
          BCC APTF_10
          INY
APTF_10   STA TMPPTA          ; pointer to first elemnt
          STY TMPPTA+1
          RTS

; ************
  Float_M32768
; ************

          .QUAD $90800000  -1870659584

          .FILL $c2dd-* (0)

; *****************************
  Eval_Positive_Integer ; $c2dd
; *****************************

          JSR CHRGET
          JSR Eval_Expression

; ***************************
  Eval_Positive_Integer_Check
; ***************************

          JSR Is_Numeric
          LDA FAC1SI
          BMI RIT_10

; ***********************
  Real_To_Integer ; $c2ea
; ***********************

          LDA FAC1EX
          CMP #$90            ; check if -32767 >= value >= 32767
          BCC RIT_20
          LDA #<Float_M32768  ; check if value = -32768
          LDY #>Float_M32768
          JSR Compare_FAC1_AY
RIT_10    BNE Jump_To_Illegal_Quantity
RIT_20    JMP FAC1_INT

; ******************
  Find_Array ; $c2fc
; ******************

; This routine is jumped at from the Parse_Name routine
; after parsing the name of the array (VARNAM) and the
; left parenthesis '('

          LDA DIMFLG
          ORA INTFLG          ; push INTFLG (bit 7) and DIMFLG (6-0)
          PHA
          LDA VALTYP          ; push VALTYP
          PHA
          LDY #0
FiAr_05   TYA                 ; start loop evaluating subscripts
          PHA                 ; push Y
          LDA VARNAM+1
          PHA
          LDA VARNAM          ; push VARNAM
          PHA
          JSR Eval_Positive_Integer
          PLA
          STA VARNAM
          PLA
          STA VARNAM+1        ; pull VARNAM
          PLA
          TAY                 ; pull Y
          TSX                 ; X = stack pointer
          LDA STACK+2,X
          PHA                 ; push DIMFLG/INTFLG again
          LDA STACK+1,X
          PHA                 ; push VALTYP again
          LDA FAC1M3
          STA STACK+2,X
          LDA FAC1M4          ; replace value above these flags
          STA STACK+1,X       ; by the subscript pointer
          INY                 ; check next index
          JSR CHRGOT
          CMP #','
          BEQ FiAr_05         ; evaluate next subscript
          STY COUNT           ; # of subscripts
          JSR Need_Right_Parenthesis
          PLA
          STA VALTYP
          PLA
          STA INTFLG
          AND #$7f
          STA DIMFLG          ; restore array flags
          LDX ARYTAB
          LDA ARYTAB+1        ; start of search
FiAr_10   STX TMPPTC
          STA TMPPTC+1
          CMP STREND+1
          BNE FiAr_15
          CPX STREND
          BEQ FiAr_30           ; not found -> create default size array
FiAr_15   LDY #0
          LDA (TMPPTC),Y
          INY                 ; Y = 1
          CMP VARNAM          ; compare 1st. char
          BNE FiAr_20
          LDA VARNAM+1
          CMP (TMPPTC),Y      ; compare 2nd. char
          BEQ FiAr_25
FiAr_20   INY                 ; Y = 2
          LDA (TMPPTC),Y      ; length of header
          CLC
          ADC TMPPTC
          TAX
          INY
          LDA (TMPPTC),Y
          ADC TMPPTC+1        ; advance TMPPTC to next array
          BCC FiAr_10         ; branch always

; -------------
  Bad_Subscript
; -------------

          LDX #[Msg_SUBSC - Msg_Start] ; $6b
          .BYTE $2c

; ------------------------
  Jump_To_Illegal_Quantity
; ------------------------

          LDX #[Msg_QUANT - Msg_Start] ; $35
FiAr_Err  JMP Basic_Error

; array already declared and dimensioned

FiAr_25   LDX #[Msg_REDIM - Msg_Start] ; $78
          LDA DIMFLG          ; dimension statement ?
          BNE FiAr_Err        ; array already created
          JSR Array_Pointer_To_First
          LDA COUNT           ; # of subscripts
          LDY #4
          CMP (TMPPTC),Y      ; compare with # of declared dimensions
          BNE Bad_Subscript   ; error if no match
          JMP FiAr_70

; create array

FiAr_30   JSR Array_Pointer_To_First
          JSR Check_Mem_Avail
          LDY #0
          STY TMPPTD+1
          LDX #5              ; # of bytes per element (default REAL)
          LDA VARNAM
          STA (TMPPTC),Y      ; store 1st. char
          BPL FiAr_35         ; branch if REAL or STRING
          DEX                 ; # of bytes = 4
FiAr_35   INY                 ; Y = 1
          LDA VARNAM+1
          STA (TMPPTC),Y      ; store 2nd. char
          BPL FiAr_40         ; branch if REAL
          DEX
          DEX                 ; # of bytes (2 INTEGER, 3 STRING)
FiAr_40   STX TMPPTD          ; store size of elemnts
          LDA COUNT           ; # of subscripts
          INY                 ; Y = 2
          INY                 ; Y = 3
          INY                 ; Y = 4
          STA (TMPPTC),Y      ; store # of dimensions
FiAr_45   LDX #11             ; default dimension (0..10)
          LDA #0              ; high value
          BIT DIMFLG
          BVC FiAr_50         ; -> branch for default dimension
          PLA
          CLC
          ADC #1              ; add 1 because indices start at 0
          TAX
          PLA
          ADC #0              ; (X/A) = (subscript + 1)
FiAr_50   INY                 ; Y = 5,7,...
          STA (TMPPTC),Y      ; store dimension high
          INY                 ; Y = 6,8,...
          TXA
          STA (TMPPTC),Y      ; store dimension low
          JSR Mult_16x16
          STX TMPPTD          ; size low
          STA TMPPTD+1        ; size high
          LDY INDEXA
          DEC COUNT           ; decrement dimension counter
          BNE FiAr_45         ; loop for next dimension
          ADC TMPPTA+1
          BCS FiAr_76           ; -> out of memory
          STA TMPPTA+1
          TAY
          TXA
          ADC TMPPTA
          BCC FiAr_55
          INY
          BEQ FiAr_76           ; -> out of memory
FiAr_55   JSR Check_Mem_Avail
          STA STREND
          STY STREND+1        ; new top of array area
          LDA #0              ; zero array content
          INC TMPPTD+1        ; size high
          LDY TMPPTD          ; Y = size low
          BEQ FiAr_65
FiAr_60   DEY
          STA (TMPPTA),Y      ; clear array
          BNE FiAr_60
FiAr_65   DEC TMPPTA+1
          DEC TMPPTD+1
          BNE FiAr_60
          INC TMPPTA+1
          SEC
          LDA STREND
          SBC TMPPTC
          LDY #2
          STA (TMPPTC),Y      ; store array size low
          LDA STREND+1
          INY                 ; Y = 3
          SBC TMPPTC+1
          STA (TMPPTC),Y      ; store array size high
          LDA DIMFLG
          BNE FiAr_Ret
          INY                 ; Y = 4
FiAr_70   LDA (TMPPTC),Y      ; # of dimensions
          STA COUNT
          LDA #0
          STA TMPPTD          ; TMPPTD = 0
FiAr_72   STA TMPPTD+1
          INY                 ; Y = 5,7,...
          PLA
          TAX
          STA FAC1M3
          PLA
          STA FAC1M4          ; FAC1M3/4 = subscript
          CMP (TMPPTC),Y      ; compare with dimension high
          BCC FiAr_78         ; -> lower
          BNE FiAr_74         ; greater -> out of range
          INY                 ; Y = 6,8,...
          TXA
          CMP (TMPPTC),Y      ; compare with dimension low
          BCC FiAr_80         ; -> lower
FiAr_74   JMP Bad_Subscript
FiAr_76   JMP Error_Out_Of_Memory
FiAr_78   INY                 ; Y = 6,8,...
FiAr_80   LDA TMPPTD+1
          ORA TMPPTD
          CLC
          BEQ FiAr_82         ; TMPPTD == 0 ?
          JSR Mult_16x16
          TXA
          ADC FAC1M3
          TAX
          TYA
          LDY INDEXA
FiAr_82   ADC FAC1M4
          STX TMPPTD
          DEC COUNT
          BNE FiAr_72         ; next subscript
          STA TMPPTD+1
          LDX #5              ; standard item size (REAL)
          LDA VARNAM
          BPL FiAr_84         ; -> REAL or STRING
          DEX                 ; X = 4
FiAr_84   LDA VARNAM+1
          BPL FiAr_86         ; -> REAL
          DEX
          DEX                 ; X = 2
FiAr_86   STX FAC3M3          ; item size (I=2, S=3, R=5)
          LDA #0
          JSR Mult_16x16_A    ; # of items * item size
          TXA
          ADC TMPPTA
          STA VARPTR
          TYA
          ADC TMPPTA+1
          STA VARPTR+1        ; VARPTR = array element
          TAY
          LDA VARPTR          ; (A/Y) = VARPTR
FiAr_Ret  RTS

          .FILL $c477-* (0)

; ******************
  Mult_16x16 ; $c477
; ******************

          STY INDEXA
          LDA (TMPPTC),Y
          STA FAC3M3
          DEY
          LDA (TMPPTC),Y

; ************
  Mult_16x16_A
; ************

          STA FAC3M4          ; FAC3M3/3 = Dimension
          LDA #16
          STA TMPVAR          ; 16 bit multiplication
          LDX #0
          LDY #0
Mu16_10   TXA                 ; (X/Y) = FAC3M3 * TMPPTD
          ASL A
          TAX
          TYA
          ROL A
          TAY
          BCS FiAr_76
          ASL TMPPTD
          ROL TMPPTD+1
          BCC Mu16_20
          CLC
          TXA
          ADC FAC3M3
          TAX
          TYA
          ADC FAC3M4
          TAY
          BCS FiAr_76
Mu16_20   DEC TMPVAR          ; next bit
          BNE Mu16_10
          RTS

; *****************
  Basic_FRE ; $c4a8
; *****************

          LDA VALTYP
          BEQ FRE_10          ; -> numeric argument
          JSR Free_String_FAC1
FRE_10    JSR Garbage_Collection
          SEC
          LDA FRETOP
          SBC STREND
          TAY
          LDA FRETOP+1
          SBC STREND+1

; **********
  AY_To_Real
; **********

          LDX #0
          STX VALTYP          ; numeric result
          STA FAC1M1
          STY FAC1M2
          LDX #$90            ; exponent
          JMP ATOF_10

; *****************
  Basic_POS ; $c4c9
; *****************

          LDY CursorCol

; **********
  Y_To_Float
; **********

          LDA #0
          BEQ AY_To_Real      ; always

; *****************
  Assert_Non_Direct
; *****************

          LDX CURLIN+1
          INX
          BNE FiAr_Ret
          LDX #[Msg_DIREC - Msg_Start] ; $95
          .BYTE $2c

; ******************
  Undefined_Function
; ******************

          LDX #[Msg_FUNC - Msg_Start] ; $e9
          JMP Basic_Error

; *****************
  Basic_DEF ; $c4dc
; *****************

          JSR Get_FN          ; read function name
          JSR Assert_Non_Direct
          JSR Need_Left_Parenthesis
          LDA #$80
          STA SUBFLG          ; no integer function
          JSR Parse_Name
          JSR Is_Numeric      ; only numeric arguments
          JSR Need_Right_Parenthesis
          LDA #$b2            ; '=' token
          JSR Need_A
          PHA
          LDA VARPTR+1
          PHA
          LDA VARPTR          ; push function argument address
          PHA
          LDA TXTPTR+1
          PHA
          LDA TXTPTR          ; push function address
          PHA
          JSR Basic_DATA      ; skip to next statement
          JMP FNX_30           ; pull and store attributes

; ******
  Get_FN
; ******

          LDA #$a5            ; FN token
          JSR Need_A
          ORA #$80
          STA SUBFLG          ; no integer function
          JSR Get_FN_Address
          STA FUNCPT
          STY FUNCPT+1
          JMP Is_Numeric

; ********
  Eval_FNX
; ********

          JSR Get_FN          ; address of function descriptor
          PHA                 ; push FUNCPT
          TYA
          PHA                 ; push FUNCPT+1
          JSR Eval_In_Parenthesis
          JSR Is_Numeric      ; force numeric argument
          PLA
          STA FUNCPT+1
          PLA
          STA FUNCPT          ; restore function descriptor
          LDY #2
          LDA (FUNCPT),Y
          STA VARPTR
          TAX
          INY                 ; Y = 3
          LDA (FUNCPT),Y
          BEQ Undefined_Function
          STA VARPTR+1        ; VARPTR = address of argument variable
          INY                 ; Y = 4
FNX_10    LDA (VARPTR),Y      ; push value of variable (5 bytes)
          PHA
          DEY
          BPL FNX_10
          LDY VARPTR+1
          JSR FAC1_To_XY      ; (X/Y) = VARPTR - Y=0 on return
          LDA TXTPTR+1
          PHA
          LDA TXTPTR
          PHA                 ; push TXTPTR
          LDA (FUNCPT),Y
          STA TXTPTR
          INY                 ; Y = 1
          LDA (FUNCPT),Y
          STA TXTPTR+1        ; TXTPTR = function body
          LDA VARPTR+1
          PHA
          LDA VARPTR
          PHA                 ; push VARPTR
          JSR Eval_Numeric    ; execute function body
          PLA
          STA FUNCPT
          PLA
          STA FUNCPT+1        ; FUNCPT = VARPTR
          JSR CHRGOT
          BEQ FNX_20
          JMP Syntax_Error     ; function did not end properly
FNX_20    PLA
          STA TXTPTR
          PLA
          STA TXTPTR+1         ; restore execution pointer
FNX_30    LDY #0               ; restore value of argument variable
          PLA
          STA (FUNCPT),Y
          PLA
          INY
          STA (FUNCPT),Y
          PLA
          INY
          STA (FUNCPT),Y
          PLA
          INY
          STA (FUNCPT),Y
          PLA
          INY
          STA (FUNCPT),Y
          RTS

          .FILL $c58e-* (0)

; *****************
  Basic_STR ; $c58e
; *****************

          JSR Is_Numeric
          LDY #0
          JSR Format_FAC1_Y
          PLA
          PLA
STR_10    LDA #<STACK-1
          LDY #>STACK-1
          BEQ Create_String_Descriptor

; ********************
  Allocate_String_FAC1
; ********************

          LDX FAC1M3
          LDY FAC1M4
          STX DESCPT
          STY DESCPT+1

; *****************
  Allocate_String_A
; *****************

          JSR Allocate_String_Space
          STX FAC1M1          ; addres low
          STY FAC1M2          ; address high
          STA FAC1EX          ; length
          RTS

; ************************
  Create_String_Descriptor
; ************************

          LDX #QUOTE          ; quote is the only valid delimiter
          STX CHARAC
          STX ENDCHR

; ***************************
  Create_String_Descriptor_AY
; ***************************

          STA STRPTR
          STY STRPTR+1        ; set STRPTR from (A/Y)
          STA FAC1M1
          STY FAC1M2          ; set FAC1M1 from (A/Y)
          LDY #-1             ; start loop with 0
CSD_10    INY
          LDA (STRPTR),Y
          BEQ CSD_30          ; end of string
          CMP CHARAC          ; closing delimiter
          BEQ CSD_20
          CMP ENDCHR
          BNE CSD_10          ; loop
CSD_20    CMP #QUOTE
          BEQ CSD_40
CSD_30    CLC
CSD_40    STY FAC1EX          ; string length
          TYA
          ADC STRPTR          ; TMPPTD = STRPTR + strlen
          STA TMPPTD
          LDX STRPTR+1
          BCC CSD_50
          INX
CSD_50    STX TMPPTD+1
          LDA STRPTR+1
          BEQ CSD_60          ; -> allocate if on ZP
          CMP #2              ; -> allocate if in buffer
          BNE Push_String_Descriptor
CSD_60    TYA                 ; A = length
          JSR Allocate_String_FAC1
          LDX STRPTR
          LDY STRPTR+1
          JSR Store_String_XY ; Copy string from (X/Y) to (FRESPC)

; **********************
  Push_String_Descriptor
; **********************

          LDX TEMPPT
          CPX #TEMPST+9       ; top of temp string descriptors
          BNE PuSD_10
          LDX #Msg_COMPL-Msg_Start ; $c8 FORMULA TOO COMPLEX
PuSD_Err  JMP Basic_Error
PuSD_10   LDA FAC1EX          ; push FAC1 descriptor
          STA 0,X
          LDA FAC1M1
          STA 1,X
          LDA FAC1M2
          STA 2,X
          LDY #0
          STX FAC1M3          ; mark stack position
          STY FAC1M4
          STY FROUND
          DEY                 ; Y = $ff
          STY VALTYP          ; type = string
          STX LASTPT          ; remember last used position
          INX
          INX
          INX
          STX TEMPPT          ; increase string stack pointer
          RTS

; *****************************
  Allocate_String_Space ; $c61d
; *****************************

; Input:  A = length of string

; Output: A = length of string
;         X = address low
;         Y = address high

          LSR GARBFL          ; clear bit 7 of GARBFL
ASS_10    TAX                 ; string length
          BEQ ASS_50          ; 0 : nothing to do
          PHA                 ; save length
          SEC
          LDA FRETOP
          SBC #2
          STA INDEXA
          LDA FRETOP+1
          SBC #0
          STA INDEXA+1        ; INDEXA = FRETOP - 2
          TAY                 ; Y = INDEXA+1
          TXA                 ; A = length
          EOR #$ff
          SEC                 ; add -length
          ADC INDEXA          ; (A/Y) = INDEXA - length
          BCS ASS_30
          DEY
ASS_30    CPY STREND+1
          BCC ASS_60          ; OOM: try garbage collection
          BNE ASS_40
          CMP STREND
          BCC ASS_60          ; OOM: try garbage collection
ASS_40    STA FRESPC
          STY FRESPC+1        ; FRESPC = INDEXA - length
          LDY #1
          LDA #$ff
          STA (INDEXA),Y      ; mark as unassigned
          DEY                 ; Y = 0
          PLA
          STA (INDEXA),Y      ; store length
          LDX FRESPC
          LDY FRESPC+1
          STX FRETOP
          STY FRETOP+1        ; FRETOP = FRESPC
ASS_50    RTS
ASS_60    LDX #[Msg_OOM - Msg_Start] ; $4d
          LDA GARBFL
          BMI PuSD_Err           ; -> Out Of Memory
          JSR Garbage_Collection
          SEC
          ROR GARBFL          ; mark: collection done
          PLA                 ; length
          BNE ASS_10          ; always

          .FILL $c66a-* (0)

; **************************
  Garbage_Collection ; $c66a
; **************************

          LDA MEMSIZ
          STA FRESPC          ; new location of string
          STA FUNCPT          ; old location of string
          LDA MEMSIZ+1
          STA FRESPC+1
          STA FUNCPT+1

GaCo_05   LDA FRETOP          ; if (FRETOP >= FUNCPT)
          CMP FUNCPT
          LDA FRETOP+1
          SBC FUNCPT+1
          BCS GaCo_45         ; finish

          LDA FUNCPT
          SBC #1              ; subtract 2 (C=0)
          STA FUNCPT
          BCS GaCo_10
          DEC FUNCPT+1        ; FUNCPT -= 2

GaCo_10   LDY #1
          LDA (FUNCPT),Y      ; reference high
          DEY                 ; Y = 0
          CMP #$ff            ; obsolete flag
          BNE GaCo_15         ; branch to string copy
          LDA FUNCPT          ; C = 1 from CMP #$ff
          SBC (FUNCPT),Y      ; subtract length
          STA FUNCPT
          BCS GaCo_05         ; loop
          DEC FUNCPT+1
          BNE GaCo_05         ; loop always

GaCo_15   STA INDEXA+1        ; reference high
          LDA (FUNCPT),Y
          STA INDEXA          ; reference low
          SEC
          LDA FUNCPT
          SBC (INDEXA),Y      ; subtract length
          STA FUNCPT
          BCS GaCo_20
          DEC FUNCPT+1        ; FUNCPT -= length

GaCo_20   LDA FRESPC
          BNE GaCo_25
          DEC FRESPC+1
GaCo_25   DEC FRESPC          ; FRESPC--

          LDA INDEXA+1        ; reference high
          STA (FRESPC),Y
          CLC
          LDA FRESPC
          SBC (INDEXA),Y      ; subtract length + borrow
          STA FRESPC
          BCS GaCo_30
          DEC FRESPC+1        ; FRESPC -= (length+1)

GaCo_30   CMP FUNCPT          ; if (FRESPC == FUNCPT)
          BNE GaCo_35         ; copy
          LDA FRESPC+1
          CMP FUNCPT+1
          BEQ GaCo_05         ; loop

GaCo_35   LDA (INDEXA),Y      ; length
          TAY
GaCo_40   LDA (FUNCPT),Y      ; copy string & low reference
          STA (FRESPC),Y
          DEY
          BNE GaCo_40
          LDA (FUNCPT),Y
          STA (FRESPC),Y
          INY                 ; Y = 1
          LDA FRESPC          ; store new reference
          STA (INDEXA),Y
          INY
          LDA FRESPC+1
          STA (INDEXA),Y
          BNE GaCo_05         ; loop always
GaCo_45   LDA FRESPC
          STA FRETOP
          LDA FRESPC+1
          STA FRETOP+1
          RTS

; ********
  FAC1_LSB
; ********

          LDX #FAC1EX
FACX_LSB  LDY #0
          STY BITS
FACB_10   CMP #-7
          BCS FACB_Ret
          TAY
          LDA 4,X
          STA FROUND
          ORA BITS
          STA BITS
          LDA 3,X
          STA 4,X
          LDA 2,X
          STA 3,X
          LDA 1,X
          STA 2,X
          LDA #0
          STA 1,X
          TYA
          ADC #8
          BNE FACB_10
FACB_Ret  TAY
          RTS

          .FILL $c74f-* (0)

; *******************
  Concatenate ; $c74f
; *******************

          LDA FAC1M4
          PHA
          LDA FAC1M3
          PHA
          JSR Evaluate
          JSR Is_String
          PLA
          STA STRPTR
          PLA
          STA STRPTR+1
          LDY #0
          LDA (STRPTR),Y
          CLC
          ADC (FAC1M3),Y
          BCC Conc_10
          LDX #Msg_LONG-Msg_Start ; $b0 STRING TOO LONG
          JMP Basic_Error
Conc_10   JSR Allocate_String_FAC1
          JSR Store_String_STRPTR ; store first part
          LDA DESCPT
          LDY DESCPT+1
          JSR Free_String_AY
          JSR Store_String_INDEXA ; store second part
          LDA STRPTR
          LDY STRPTR+1
          JSR Free_String_AY
          JSR Push_String_Descriptor
          JMP EvEx_15

; *******************
  Store_String_STRPTR
; *******************

          LDY #0
          LDA (STRPTR),Y      ; A = length
          PHA
          INY
          LDA (STRPTR),Y      ; X = address low
          TAX
          INY
          LDA (STRPTR),Y      ; Y = address high
          TAY
          PLA

; ***************
  Store_String_XY
; ***************

          STX INDEXA
          STY INDEXA+1

; ***************************
  Store_String_INDEXA ; $c79e
; ***************************

          TAY
          BEQ SSI_Ret
          PHA
SSI_10    DEY
          LDA (INDEXA),Y
          STA (FRESPC),Y
          TYA
          BNE SSI_10
          PLA
          CLC
          ADC FRESPC          ; FRESPC += length
          STA FRESPC          ; (used by Concatenate)
          BCC SSI_Ret
          INC FRESPC+1
SSI_Ret   RTS

; ****************************
  Eval_And_Free_String ; $c7b5
; ****************************

          JSR Is_String

; ****************
  Free_String_FAC1
; ****************

          LDA FAC1M3
          LDY FAC1M4

; **********************
  Free_String_AY ; $c7bc
; **********************

; Input:  (A/Y) = pointer to descriptor
; Output: (X/Y) = INDEXA = pointer to string
;         A     = length

          STA INDEXA
          STY INDEXA+1        ; INDEXA = pointer to descriptor
          JSR Pop_Descriptor_Stack
          BNE GSD_40          ; -> load if not temporary
          JSR Back_Reference_Position
          BCC GSD_40          ; -> branch if not dynamic string
          LDA #$ff
          STA (INDEXC),Y      ; invalidate string
          DEY                 ; Y = 0
          TXA
          STA (INDEXC),Y      ; store length
          LDX INDEXA
          LDY INDEXA+1
          CPY FRETOP+1
          BNE GSD_Ret
          CPX FRETOP
          BNE GSD_Ret         ; return if INDEXA != FRETOP
          PHA                 ; push length
          LDA INDEXC
          ADC #1              ; add 2 (1 + carry)
          STA FRETOP
          LDA INDEXC+1
          ADC #0
          STA FRETOP+1
          PLA
          RTS
GSD_40    LDY #0              ; load descriptor from pointer
          LDA (INDEXA),Y
          PHA
          INY
          LDA (INDEXA),Y
          TAX
          INY
          LDA (INDEXA),Y
          TAY
          STX INDEXA
          STY INDEXA+1
          PLA
GSD_Ret   RTS

          .FILL $c811-* (0)

; ****************************
  Pop_Descriptor_Stack ; $c811
; ****************************

          CPY LASTPT+1
          BNE PDS_Ret
          CMP LASTPT
          BNE PDS_Ret
          STA TEMPPT
          SBC #3
          STA LASTPT
          LDY #0
PDS_Ret   RTS

; *********
  Basic_CHR
; *********

          JSR Eval_Byte       ; get byte in X
          TXA
          PHA
          LDA #1
          JSR Allocate_String_A
          PLA
          LDY #0
          STA (FAC1M1),Y
          PLA
          PLA
          JMP Push_String_Descriptor

; **********
  Basic_LEFT
; **********

          JSR Pop_DESCPT      ; get string address and 2nd. argument
          CMP (DESCPT),Y      ; compare argument with length
          TYA                 ; A = 0
LEFT_10   BCC LEFT_20         ; branch if arg < length
          LDA (DESCPT),Y      ; get total length
          TAX                 ; string length
          TYA                 ; A = 0
LEFT_20   PHA                 ; push start index (0 for LEFT$)
LEFT_30   TXA                 ; A  = new length
LEFT_40   PHA                 ; push new length
          JSR Allocate_String_A
          LDA DESCPT
          LDY DESCPT+1
          JSR Free_String_AY  ; free string argument
          PLA
          TAY                 ; Y = length
          PLA                 ; A = start index
          CLC
          ADC INDEXA
          STA INDEXA
          BCC LEFT_50
          INC INDEXA+1        ; INDEX += start index
LEFT_50   TYA                 ; new length
          JSR Store_String_INDEXA
          JMP Push_String_Descriptor

; ***********
  Basic_RIGHT
; ***********

          JSR Pop_DESCPT      ; get string address and 2nd. argument
          CLC
          SBC (DESCPT),Y      ; argument - length
          EOR #$ff            ; length - argument
          JMP LEFT_10         ; share code with LEFT$

; *********
  Basic_MID
; *********

          LDA #255            ; default value for 3rd. argument
          STA FAC1M4
          JSR CHRGOT
          CMP #')'
          BEQ MID_10
          JSR Need_Comma
          JSR Get_Byte_Value  ; 3rd. argument to FAC1M4
MID_10    JSR Pop_DESCPT      ; get string address and 2nd. argument
          BEQ ASC_Err         ; null string -> error
          DEX                 ; start index to offset
          TXA
          PHA                 ; push offset
          CLC
          LDX #0
          SBC (DESCPT),Y      ; offset - length
          BCS LEFT_30
          EOR #$ff            ; length - offset
          CMP FAC1M4
          BCC LEFT_40         ; new length = rest of string
          LDA FAC1M4          ; new length
          BCS LEFT_40         ; branch always

; **********
  Pop_DESCPT
; **********

          JSR Need_Right_Parenthesis
          PLA
          TAY                 ; return address low
          PLA
          STA FUNJMP          ; return address high
          PLA
          PLA
          PLA
          TAX                 ; X = length
          PLA
          STA DESCPT
          PLA
          STA DESCPT+1        ; DESCPT = string address
          LDA FUNJMP
          PHA                 ; return address high
          TYA
          PHA                 ; return address low
          LDY #0
          TXA                 ; A = length
          RTS

; *********
  Basic_LEN
; *********

          JSR Eval_String_Desc
          JMP Y_To_Float

; ****************
  Eval_String_Desc
; ****************

          JSR Eval_And_Free_String
          LDX #0
          STX VALTYP
          TAY
          RTS

; *********
  Basic_ASC
; *********

          JSR Eval_String_Desc
          BEQ ASC_10          ; ASC(""") was a syntax error in BASIC 4
          LDY #0              ; here we return 0
          LDA (INDEXA),Y
          TAY
ASC_10    JMP Y_To_Float
ASC_Err   JMP Jump_To_Illegal_Quantity

          .FILL $c8d1-* (0)

; ***************************
  Get_Next_Byte_Value ; $c8d1
; ***************************

          JSR CHRGET

; **************
  Get_Byte_Value
; **************

          JSR Eval_Numeric

; *********
  Eval_Byte
; *********

          JSR Eval_Positive_Integer_Check
          LDX FAC1M3
          BNE ASC_Err
          LDX FAC1M4
          JMP CHRGOT

; *****************
  Basic_VAL ; $c8e3
; *****************

          JSR Eval_String_Desc
          BNE VAL_10
          JMP Clear_FAC1
VAL_10    LDX TXTPTR
          LDY TXTPTR+1
          STX TMPPTD
          STY TMPPTD+1        ; TMPPTD = TXTPTR
          LDX INDEXA
          STX TXTPTR
          CLC
          ADC INDEXA
          STA INDEXB
          LDX INDEXA+1
          STX TXTPTR+1        ; TXTPTR = INDEXA
          BCC VAL_20          ; INDEXB = INDEXA + length
          INX
VAL_20    STX INDEXB+1
          LDY #0
          LDA (INDEXB),Y      ; back reference low
          PHA
          TYA
          STA (INDEXB),Y      ; add zero delimiter for CHRGET
          JSR CHRGOT
          JSR Read_Real_To_FAC1
          PLA
          LDY #0
          STA (INDEXB),Y      ; restore back reference low

; *************************
  Restore_Execution_Pointer
; *************************

          LDX TMPPTD
          LDY TMPPTD+1
          STX TXTPTR
          STY TXTPTR+1
          RTS

          .FILL $c921-* (0)

; *************************
  Get_Word_And_Byte ; $c921
; *************************

          JSR Eval_Numeric
          JSR FAC1_To_LINNUM

; *******************
  Need_Comma_Get_Byte
; *******************

          JSR Need_Comma
          JMP Get_Byte_Value

; **************
  FAC1_To_LINNUM
; **************

          LDA FAC1SI
          BMI ASC_Err         ; only positive numbers
          LDA FAC1EX
          CMP #$91
          BCS ASC_Err         ; -> greater 65536
          JSR FAC1_LSR
          LDA FAC1M3
          LDY FAC1M4
          STY LINNUM
          STA LINNUM+1
          RTS

; **********
  Basic_PEEK
; **********

          LDA LINNUM+1
          PHA
          LDA LINNUM
          PHA
          JSR FAC1_To_LINNUM
          LDY #0
          LDA (LINNUM),Y
          TAY
          PLA
          STA LINNUM
          PLA
          STA LINNUM+1
          JMP Y_To_Float

; **********
  Basic_POKE
; **********

          JSR Get_Word_And_Byte
          TXA
          LDY #0
          STA (LINNUM),Y
          RTS

; **********
  Basic_WAIT
; **********

          JSR Get_Word_And_Byte
          STX FORPNT
          LDX #0
          JSR CHRGOT
          BEQ WAIT_10
          JSR Need_Comma_Get_Byte
WAIT_10   STX FORPNT+1
          LDY #0
WAIT_20   LDA (LINNUM),Y
          EOR FORPNT+1
          AND FORPNT
          BEQ WAIT_20
WAIT_Ret  RTS

; ***************
  Add_0_5_To_FAC1
; ***************

          LDA #<Float_0_5
          LDY #>Float_0_5
          JMP Add_Var_AY_To_FAC1

; *************
  AY_Minus_FAC1
; *************

          JSR Load_FAC2_From_AY

; ********
  Op_MINUS
; ********

          LDA FAC1SI
          EOR #$ff
          STA FAC1SI
          EOR FAC2SI
          STA STRPTR          ; pos = ADD, neg = SUB
          LDA FAC1EX
          JMP Op_PLUS

          .FILL $c99d-* (0)

; ******************
  Add_Var_AY_To_FAC1
; ******************

          JSR Load_FAC2_From_AY

; ***************
  Op_PLUS ; $c9a0
; ***************

          BNE PLUS_10         ; -> branch if FAC1 is not 0
          JMP FAC2_To_FAC1    ; FAC1 = FAC2
PLUS_10   LDX FROUND
          STX FUNJMP+1        ; copy rounding byte
          LDX #FAC2EX         ; X points to FAC2
          LDA FAC2EX

; ***************************
  AddSub_FAC2_To_FAC1 ; $c9ad
; ***************************

; The mantissa of the FAC with the lower exponent is shifted
; right until both exponents become equal.

; Input:  A = exponent of FAC2
;         X = address  of FAC2
;         STRPTR ($00:Add, $80:Subtract)

; Output: FAC1 = FAC1 + FAC2 (for STRPTR == $00)
;         FAC1 = FAC1 - FAC2 (for STRPTR == $80)

          TAY                 ; Y = exp 2
          BEQ WAIT_Ret        ; return if FAC2 is zero
          SEC
          SBC FAC1EX          ; A = exp 2 - exp 1
          BEQ AFTF_30         ; -> exponents are equal
          BCC AFTF_10         ; -> exp 2 < exp 1
          STY FAC1EX          ; exp 1 = exp 2
          LDY FAC2SI
          STY FAC1SI          ; sign 1 = sign 2
          EOR #$ff
          ADC #0              ; A = exp 1 - exp 2
          LDY #0
          STY FUNJMP+1        ; clear FAC2 rounding byte
          LDX #FAC1EX         ; X points to FAC1
          BNE AFTF_20         ; always
AFTF_10   LDY #0
          STY FROUND          ; clear FAC1 rounding byte
AFTF_20   JSR Shift_FACX_A
AFTF_30   BIT STRPTR          ; add or subtract ?
          BPL AFTF_60         ; -> add mantissa of FAC2 to FAC1
          LDY #FAC1EX
          CPX #FAC2EX         ; if (X == FAC2) Y = FAC1
          BEQ AFTF_40
          LDY #FAC2EX         ; else           Y = FAC2
AFTF_40   SEC
          EOR #$ff            ; negate rounding byte
          ADC FUNJMP+1
          STA FROUND
          LDA 4,Y
          SBC 4,X
          STA FAC1M4
          LDA 3,Y
          SBC 3,X
          STA FAC1M3
          LDA 2,Y
          SBC 2,X
          STA FAC1M2
          LDA 1,Y
          SBC 1,X
          STA FAC1M1
AFTF_50   BCS Normalise_FAC1
          JSR Negate_FAC1
          JMP Normalise_FAC1

          .FILL $ca0d-* (0)

; **************
  Normalise_FAC1
; **************

          LDY #0              ; Y = 0
          TYA                 ; A = 0
          CLC
NF1_10    LDX FAC1M1          ; MSB of mantissa
          BNE AFTF_70         ; -> shift bitwise
          LDX FAC1M2          ; shift bytes
          STX FAC1M1
          LDX FAC1M3
          STX FAC1M2
          LDX FAC1M4
          STX FAC1M3
          LDX FROUND
          STX FAC1M4
          STY FROUND          ; = 0
          ADC #8              ; A = shift count
          CMP #32             ; maximum shift = 32 bit
          BNE NF1_10          ; loop

; **********
  Clear_FAC1
; **********

          LDA #0
CF1_10    STA FAC1EX
          STA FAC1SI
          RTS

AFTF_60   ADC FUNJMP+1        ; FAC1 rounding byte
          STA FROUND
          LDA FAC1M4          ; add FAC2 mantissa to FAC1
          ADC FAC2M4
          STA FAC1M4
          LDA FAC1M3
          ADC FAC2M3
          STA FAC1M3
          LDA FAC1M2
          ADC FAC2M2
          STA FAC1M2
          LDA FAC1M1
          ADC FAC2M1
          STA FAC1M1
          JMP Mantissa_Overflow

AFTF_65   ADC #1
          ASL FROUND
          ROL FAC1M4
          ROL FAC1M3
          ROL FAC1M2
          ROL FAC1M1
AFTF_70   BPL AFTF_65
          SEC
          SBC FAC1EX
          BCS Clear_FAC1
          EOR #$ff
          ADC #1
          STA FAC1EX

; *****************
  Mantissa_Overflow
; *****************

          BCC AFTF_Ret
AFTF_80   INC FAC1EX
          BEQ Overflow_Error
          ROR FAC1M1
          ROR FAC1M2
          ROR FAC1M3
          ROR FAC1M4
          ROR FROUND
AFTF_Ret  RTS

; ***********
  Negate_FAC1
; ***********

          LDA FAC1SI
          EOR #$ff
          STA FAC1SI

; ********************
  Negate_FAC1_Mantissa
; ********************

          LDA FAC1M1
          EOR #$ff
          STA FAC1M1
          LDA FAC1M2
          EOR #$ff
          STA FAC1M2
          LDA FAC1M3
          EOR #$ff
          STA FAC1M3
          LDA FAC1M4
          EOR #$ff
          STA FAC1M4
          LDA FROUND
          EOR #$ff
          STA FROUND
          INC FROUND
          BNE IFM_Ret

; *****************
  Inc_FAC1_Mantissa
; *****************

          INC FAC1M4
          BNE IFM_Ret
          INC FAC1M3
          BNE IFM_Ret
          INC FAC1M2
          BNE IFM_Ret
          INC FAC1M1
IFM_Ret   RTS

; **************
  Overflow_Error
; **************

          LDX #Msg_FLOW-Msg_Start ; $45 OVERFLOW
          JMP Basic_Error

; **********
  Shift_FAC3
; **********

          LDA FAC3M4
          STA FROUND
          LDA FAC3M3
          STA FAC3M4
          LDA FAC3M2
          STA FAC3M3
          LDA FAC3M1
          STA FAC3M2
          LDA #0
          STA FAC3M1
          RTS

          .FILL $cacf-* (0)

; perform a byte shift right on FAC X
; the LSB byte goes to FROUND

; ************
  Shift_FACX_A
; ************

          JSR FACX_LSB
          LDA FROUND          ; byte shifted off
          CPY #0
          BPL SFA_40          ; return if done
SFA_10    LSR 1,X
          ROR 2,X
          ROR 3,X
          ROR 4,X
          ROR A               ; A gets bits shifted out
          INY
          BNE SFA_10
SFA_40    CLC
          RTS

          .FILL $caf2-* (0)

; **************
  REAL_1 ; $caf2
; **************

          .REAL $8100000000   ;    1.00000000000
VLOG_A    .BYTE $03
          .REAL $7f5e56cb79   ;    0.43425594189
          .REAL $80139b0b64   ;    0.57658454124
          .REAL $8076389316   ;    0.96180075919
          .REAL $8238aa3b20   ;    2.88539007306

; ***********
  HALF_SQRT_2
; ***********

          .REAL $803504f334   ;    0.70710678119
SQRT_2    .REAL $813504f334   ;    1.41421356238

; *********
  MINUS_0_5
; *********

          .REAL $8080000000   ;   -0.50000000000
LN_2      .REAL $80317217f8   ;    0.69314718060

; *********
  Basic_LOG
; *********

          JSR Get_FAC1_Sign
          BEQ LOG_10
          BPL LOG_20
LOG_10    JMP Jump_To_Illegal_Quantity
LOG_20    LDA FAC1EX
          SBC #$7f
          PHA
          LDA #$80
          STA FAC1EX
          LDA #<HALF_SQRT_2
          LDY #>HALF_SQRT_2
          JSR Add_Var_AY_To_FAC1
          LDA #<SQRT_2
          LDY #>SQRT_2
          JSR AY_Divided_By_FAC1
          LDA #<REAL_1
          LDY #>REAL_1
          JSR AY_Minus_FAC1
          LDA #<VLOG_A
          LDY #>VLOG_A
          JSR Square_And_Series_Eval
          LDA #<MINUS_0_5
          LDY #>MINUS_0_5
          JSR Add_Var_AY_To_FAC1
          PLA
          JSR Add_A_To_FAC1
          LDA #<LN_2
          LDY #>LN_2

; *********************
  Multiply_FAC1_With_AY
; *********************

          JSR Load_FAC2_From_AY

; ***********
  Op_MULTIPLY
; ***********

          BEQ MULT_Ret
          JSR Check_FAC
          LDA #0
          STA FAC3M1
          STA FAC3M2
          STA FAC3M3
          STA FAC3M4
          LDA FROUND
          JSR Mult_SubA
          LDA FAC1M4
          JSR Mult_SubA
          LDA FAC1M3
          JSR Mult_SubA
          LDA FAC1M2
          JSR Mult_SubA
          LDA FAC1M1
          JSR Mult_SubB
          JMP FAC3_To_FAC1

; *********
  Mult_SubA
; *********

          BNE Mult_SubB       ; do multiply if A is not zero
          JMP Shift_FAC3      ; else shift FAC3 right 8 bits

; *********
  Mult_SubB
; *********

          LSR A
          ORA #$80            ; make sure, that A remains not zero
MULT_20   TAY                 ; until 8 shifts are done
          BCC MULT_30
          CLC
          LDA FAC3M4
          ADC FAC2M4
          STA FAC3M4
          LDA FAC3M3
          ADC FAC2M3
          STA FAC3M3
          LDA FAC3M2
          ADC FAC2M2
          STA FAC3M2
          LDA FAC3M1
          ADC FAC2M1
          STA FAC3M1
MULT_30   ROR FAC3M1
          ROR FAC3M2
          ROR FAC3M3
          ROR FAC3M4
          ROR FROUND
          TYA
          LSR A
          BNE MULT_20
MULT_Ret  RTS

          .FILL $cbc2-* (0)

; *************************
  Load_FAC2_From_AY ; $cbc2
; *************************

; Input:  (A/Y) = address of packed floating point value
; Output: FAC2  = read floating point value
;         A     = exponent of FAC1
;         Y     = 0

          STA INDEXA
          STY INDEXA+1
          LDY #4
          LDA (INDEXA),Y
          STA FAC2M4
          DEY
          LDA (INDEXA),Y
          STA FAC2M3
          DEY
          LDA (INDEXA),Y
          STA FAC2M2
          DEY
          LDA (INDEXA),Y      ; bit7 = sign
          STA FAC2SI          ; transfer sign to FAC2SI bit7
          EOR FAC1SI          ; EOR with sign of FAC1
          STA STRPTR          ; flag sign comparison
          LDA FAC2SI          ; load sign/byte 1 of mantissa
          ORA #$80            ; replace sign with 1 (normalize)
          STA FAC2M1          ; M1 is now in unpacked mode
          DEY
          LDA (INDEXA),Y      ; exponent
          STA FAC2EX
          LDA FAC1EX          ; return with FAC1 exp in A
          RTS

; *********
  Check_FAC
; *********

          LDA FAC2EX
ChFA_10   BEQ ChFA_50         ; -> set FAC1 = 0.0
          CLC
          ADC FAC1EX          ; (exp 1 + exp 2)
          BCC ChFA_20         ; -> no overflow
          BMI ChFA_Err        ; -> overflow
          CLC
          .BYTE $2c
ChFA_20   BPL ChFA_50         ; -> underflow
          ADC #$80            ; correct bias
          STA FAC1EX          ; exp 1 += exp 2
          BEQ ChFA_30
          LDA STRPTR
ChFA_30   STA FAC1SI
          RTS
ChFA_40   LDA FAC1SI
          EOR #$ff
          BMI ChFA_Err
ChFA_50   PLA
          PLA
          JMP Clear_FAC1      ; underflow -> set FAC1 = 0.0
ChFA_Err  JMP Overflow_Error  ; overflow  -> error

          .FILL $cc18-* (0)

; ***************************
  Multiply_FAC1_BY_10 ; $cc18
; ***************************

          JSR FAC1_Round_And_Copy_To_FAC2   ; FAC2 = FAC1
          TAX                               ; A = Exponent
          BEQ Mul10_Ret
          CLC
          ADC #2                            ; FAC2 *= 4
          BCS ChFA_Err

; **************
  Add_And_Double
; **************

          LDX #0
          STX STRPTR                        ; choose ADD
          JSR AddSub_FAC2_To_FAC1           ; FAC1 += FAC2   (*  5)
          INC FAC1EX                        ; FAC1 *= 2      (* 10)
          BEQ ChFA_Err
Mul10_Ret RTS

; ********
  Float_10
; ********

          .REAL $8420000000   ;   10.00000000000

; *****************
  Divide_FAC1_By_10
; *****************

          JSR FAC1_Round_And_Copy_To_FAC2
          LDA #<Float_10
          LDY #>Float_10
          LDX #0

; *****************
  Divide_FAC2_By_AY
; *****************

          STX STRPTR
          JSR Load_FAC1_AY
          JMP Op_DIVIDE

; ******************
  AY_Divided_By_FAC1
; ******************

          JSR Load_FAC2_From_AY

; *********
  Op_DIVIDE
; *********

          BEQ Divide_By_Zero
          JSR Round_FAC1
          LDA #0
          SEC
          SBC FAC1EX
          STA FAC1EX
          JSR Check_FAC
          INC FAC1EX
          BEQ ChFA_Err
          LDX #$fc            ; wrap around index
          LDA #1
DIV_10    LDY FAC2M1
          CPY FAC1M1
          BNE DIV_20
          LDY FAC2M2
          CPY FAC1M2
          BNE DIV_20
          LDY FAC2M3
          CPY FAC1M3
          BNE DIV_20
          LDY FAC2M4
          CPY FAC1M4
DIV_20    PHP
          ROL A
          BCC DIV_30
          INX
          STA FAC3M4,X
          BEQ DIV_60
          BPL DIV_70
          LDA #1
DIV_30    PLP
          BCS DIV_50
DIV_40    ASL FAC2M4
          ROL FAC2M3
          ROL FAC2M2
          ROL FAC2M1
          BCS DIV_20
          BMI DIV_10
          BPL DIV_20
DIV_50    TAY
          LDA FAC2M4
          SBC FAC1M4
          STA FAC2M4
          LDA FAC2M3
          SBC FAC1M3
          STA FAC2M3
          LDA FAC2M2
          SBC FAC1M2
          STA FAC2M2
          LDA FAC2M1
          SBC FAC1M1
          STA FAC2M1
          TYA
          JMP DIV_40
DIV_60    LDA #$40
          BNE DIV_30
DIV_70    ASL A
          ASL A
          ASL A
          ASL A
          ASL A
          ASL A
          STA FROUND
          PLP
          JMP FAC3_To_FAC1

; **************
  Divide_By_Zero
; **************

          LDX #Msg_DIV-Msg_Start ; $85
          JMP Basic_Error

; ************
  FAC3_To_FAC1
; ************

          LDA FAC3M1
          STA FAC1M1
          LDA FAC3M2
          STA FAC1M2
          LDA FAC3M3
          STA FAC1M3
          LDA FAC3M4
          STA FAC1M4
          JMP Normalise_FAC1

; ********************
  Load_FAC1_AY ; $ccd8
; ********************

          STA INDEXA
          STY INDEXA+1
          LDY #4
LFAY_10   LDA (INDEXA),Y
          STA FAC1EX,Y
          DEY
          BPL LFAY_10
          INY                 ; Y = 0
          STY FROUND          ; rounding byte
          LDA FAC1M1
          STA FAC1SI
          ORA #$80
          STA FAC1M1
          LDA FAC1EX
          RTS

; ********
  Set_FAC1
; ********

          STA FAC1M1
          STA FAC1M2
          STA FAC1M3
          STA FAC1M4
          RTS

          .FILL $ccfd-* (0)

; **********************
  FAC1_To_FACTPB ; $ccfd
; **********************

          LDX #FACTPB ; $59
          .BYTE $2c

; **************
  FAC1_To_FACTPA
; **************

          LDX #<FACTPA
          LDY #>FACTPA
          BEQ FAC1_To_XY      ; always

; **************
  FAC1_To_FORPNT
; **************

          LDX FORPNT
          LDY FORPNT+1

; **********
  FAC1_To_XY
; **********

          JSR Round_FAC1
          STX INDEXA
          STY INDEXA+1
          LDY #4
          LDA FAC1M4
          STA (INDEXA),Y
          DEY
          LDA FAC1M3
          STA (INDEXA),Y
          DEY
          LDA FAC1M2
          STA (INDEXA),Y
          DEY
          LDA FAC1SI
          ORA #$7f
          AND FAC1M1
          STA (INDEXA),Y
          DEY
          LDA FAC1EX
          STA (INDEXA),Y
          STY FROUND
          RTS

; ************
  FAC2_To_FAC1
; ************

          LDA FAC2SI

; *********************
  Copy_ABS_FAC2_To_FAC1
; *********************

          STA FAC1SI
          LDX #5
F1F2_10   LDA FAC2EX-1,X
          STA FAC1EX-1,X
          DEX
          BNE F1F2_10
          STX FROUND ; 0
          RTS

; ***************************
  FAC1_Round_And_Copy_To_FAC2
; ***************************

          JSR Round_FAC1

; ************
  FAC1_To_FAC2
; ************

          LDX #6
FA12_10   LDA FAC1EX-1,X
          STA FAC2EX-1,X
          DEX
          BNE FA12_10
          STX FROUND ; 0
FA12_Ret  RTS

; **********
  Round_FAC1
; **********

          LDA FAC1EX
          BEQ FA12_Ret
          ASL FROUND
          BCC FA12_Ret

; ********
  Inc_FAC1
; ********

          JSR Inc_FAC1_Mantissa
          BNE FA12_Ret
          JMP AFTF_80

; *************
  Get_FAC1_Sign
; *************

          LDA FAC1EX
          BEQ GFS_Ret
GFS_10    LDA FAC1SI
GFS_20    ROL A
          LDA #$ff
          BCS GFS_Ret
          LDA #1
GFS_Ret   RTS

; *********
  Basic_SGN
; *********

          JSR Get_FAC1_Sign

; *********
  A_To_FAC1
; *********

          STA FAC1M1
          LDA #0
          STA FAC1M2
          LDX #$88
ATOF_10   LDA FAC1M1
          EOR #$ff
          ROL A               ; clear carry for negative numbers

; ***********************
  Convert_Integer_To_Real
; ***********************

          LDA #0
          STA FAC1M4
          STA FAC1M3
CITR_10   STX FAC1EX
          STA FROUND
          STA FAC1SI
          JMP AFTF_50

; *********
  Basic_ABS
; *********

          LSR FAC1SI          ; clear bit 7 (sign)
          RTS

; ***************
  Compare_FAC1_AY
; ***************

          STA INDEXB

; *********************
  Compare_FAC1_INDEXB_Y
; *********************

          STY INDEXB+1        ; (INDEXB) = operand 2
          LDY #0
          LDA (INDEXB),Y      ; exp 2
          INY                 ; Y = 1
          TAX
          BEQ Get_FAC1_Sign   ; branch if operand 2 is zero
          LDA (INDEXB),Y      ; M1
          EOR FAC1SI          ; EOR both sign bits
          BMI GFS_10          ; branch on different signs
          CPX FAC1EX          ; compare exponents
          BNE CFAY_10         ; branch if not equal
          LDA (INDEXB),Y      ; M1
          ORA #$80            ; remove sign
          CMP FAC1M1          ; compare M1's
          BNE CFAY_10
          INY                 ; Y = 2
          LDA (INDEXB),Y
          CMP FAC1M2          ; compare M2's
          BNE CFAY_10
          INY                 ; Y = 3
          LDA (INDEXB),Y
          CMP FAC1M3          ; compare M3's
          BNE CFAY_10
          INY                 ; Y = 4
          LDA #$7f
          CMP FROUND          ; $7f >= FROUND ?
          LDA (INDEXB),Y
          SBC FAC1M4          ; compare M4's and FROUND
          BEQ FLSR_Ret
CFAY_10   LDA FAC1SI
          BCC CFAY_20
          EOR #$ff
CFAY_20   JMP GFS_20

; ********
  FAC1_LSR
; ********

; Shift FAC1 right until the exponent is at $a0.
; This is the value for which the four mantissa bytes
; represent a 32 bit integer value.

          LDA FAC1EX
          BNE FLSR_20
FLSR_10   JMP Set_FAC1        ; clear mantissa for zero exp
FLSR_20   SEC
          SBC #$a0
          JSR FAC1_LSB        ; shift bytes
          BEQ FLSR_40         ; -> done
          LDA BITS            ; check integer status
          BEQ FLSR_30         ; branch on integer
          LDA #$80            ; real
FLSR_30   LSR FAC1M1          ; do a bit shift
          ROR FAC1M2
          ROR FAC1M3
          ROR FAC1M4
          ROR FROUND
          ORA FROUND          ; remember bits shifted off
          INY
          BNE FLSR_30
          BIT FAC1SI
          BPL FLSR_40         ; positive: finished
          ASL A               ; any 1 bits shifted off ?
          BCC FLSR_40         ; -> number was exact integer
          JSR Inc_FAC1_Mantissa ; subtract 1 from negative number
FLSR_40   STY FROUND          ; FROUND = 0
FLSR_Ret  RTS

          .FILL $ce02-* (0)

; *****************
  Basic_INT ; $ce02
; *****************

; The BASIC int function is not restricted to the 16 bit
; range of integer variables. Its range is 32 bit.
; INT does not round, it looks for the integer lower or
; equal to the given value. E.g: int(-1.1) results in -2.

          LDA FAC1EX
          CMP #$a0
          BCS FLSR_Ret        ; -> no bits after decimal point
          JSR FAC1_LSR        ; normalise to integer
          LDA #$a0
          STA FAC1EX          ; set exponent for integer mantissa
          LDA FAC1M4
          BIT FAC1SI
          BPL INT_10
          SEC
          LDA #0
          SBC FAC1M4
INT_10    STA CHARAC          ; needed from Basic_EXP
          JMP Normalise_FAC1  ; normalise back to real

          .FILL $ce29-* (0)

; *************************
  Read_Real_To_FAC1 ; $ce29
; *************************

; This subroutine parses a string via CHRGET and
; converts it into a floating point value in FAC1.

;         TMPVAR   = digits after decimal point
;         TMPVAR+1 = exponent
;         TMPPTC   = bit 7 : flag for '.' decimal point
;         TMPPTC+1 = bit 7 : flag for '-' sign

          LDY #0
          LDX #10
RRTF_02   STY TMPVAR,X        ; clear TMPVAR, TMPPTC and FAC1
          DEX
          BPL RRTF_02         ; X = $ff at end
          BCC RRTF_34         ; -> numeric
          CMP #'+'            ; positive sign ?
          BEQ RRTF_04         ; -> get next
          CMP #'-'            ; negative sign ?
          BNE RRTF_06
          STX SGNFLG          ; sign flag = $ff
RRTF_04   JSR CHRGET          ; next character after sign
          BCC RRTF_34         ; -> numeric
RRTF_06   CMP #'.'            ; decimal point ?
          BEQ RRTF_20         ; -> now the fractional part
          CMP #'E'            ; exponent ?
          BNE RRTF_22
          JSR CHRGET          ; read character of exponent
          BCC RRTF_40         ; -> numeric
          CMP #$aa            ; '+' token
          BEQ RRTF_10
          CMP #'+'            ; '+' sign of exponent
          BEQ RRTF_10
          CMP #$ab            ; '-' token
          BEQ RRTF_08
          CMP #'-'            ; '-' sign of exponent
          BNE RRTF_12
RRTF_08   ROR TMPPTC+1        ; flag negative sign
RRTF_10   JSR CHRGET          ; read character of exponent
          BCC RRTF_40         ; -> numeric
RRTF_12   BIT TMPPTC+1
          BPL RRTF_22         ; -> positive exponent
          LDA #0
          SEC
          SBC TMPVAR+1        ; -> negative exponent
          JMP RRTF_24

RRTF_20   ROR TMPPTC          ; bit 7 = flag for '.'
          BIT TMPPTC
          BVC RRTF_04         ; break if 2nd. dot read

RRTF_22   LDA TMPVAR+1        ; exponent read
RRTF_24   SEC
          SBC TMPVAR          ; minus # of digits after '.'
          STA TMPVAR+1        ; effective exponent
          BEQ RRTF_30         ; -> zero exponent
          BPL RRTF_28         ; -> pos. exponent

RRTF_26   JSR Divide_FAC1_By_10 ; neg. exponent
          INC TMPVAR+1
          BNE RRTF_26
          BEQ RRTF_30

RRTF_28   JSR Multiply_FAC1_BY_10 ; apply positive exponent
          DEC TMPVAR+1
          BNE RRTF_28

RRTF_30   LDA SGNFLG
          BMI RRTF_32         ; -> negate result
          RTS

RRTF_32   JMP Op_NEGATE

RRTF_34   PHA                 ; result = result * 10 + digit
          BIT TMPPTC
          BPL RRTF_36
          INC TMPVAR          ; count digits after decimal point
RRTF_36   JSR Multiply_FAC1_BY_10
          PLA
          AND #15             ; PETSCII -> binary
          JSR Add_A_To_FAC1
          JMP RRTF_04

          .FILL $ceb4-* (0)

; *********************
  Add_A_To_FAC1 ; $ceb4
; *********************

          PHA
          JSR FAC1_Round_And_Copy_To_FAC2
          PLA
          JSR A_To_FAC1
          LDA FAC2SI
          EOR FAC1SI
          STA STRPTR
          LDX FAC1EX
          JMP Op_PLUS

; read digits for exponent

RRTF_40   LDA TMPVAR+1        ; exponent so far
          CMP #10             ; alreay two digits ?
          BCC RRTF_42         ; -> OK if less than 10
          LDA #100            ; exponent = 100
          BIT TMPPTC+1
          BMI RRTF_44         ; -> negative exponent
          JMP Overflow_Error  ; max value = 37
RRTF_42   ASL A               ; * 2
          ASL A               ; * 4
          CLC
          ADC TMPVAR+1        ; * 5
          ASL A               ; * 10
          CLC
          LDY #0
          ADC (TXTPTR),Y
          SEC
          SBC #'0'
RRTF_44   STA TMPVAR+1        ; new value for exponent
          JMP RRTF_10

; *********
  REAL_1e8
; *********

          .REAL $9b3ebc2000   ; 1e8

; *********
  REAL_9x9
; *********

          .REAL $9e6e6b27fe   ;  999999999.5

; *********
  REAL_1e9
; *********

          .REAL $9e6e6b2800   ; 1e9

BSOS_TEXT .BYTE "BSOS BOOT"

; **********
  Option_ROM
; **********

          LDX #3
OpRO_10   LDA $9000,X         ; check $9000 ROM
          CMP BSOS_TEXT,X
          BNE OpRO_20
          DEX
          BPL OpRO_10
          JSR $9004
OpRO_20   LDX #3
OpRO_30   LDA $a000,X         ; check $a000 ROM
          CMP BSOS_TEXT,X
          BNE OpRO_40
          DEX
          BPL OpRO_30
          JMP $a004
OpRO_40   RTS

; *********
  BOOT_File
; *********

          BIT Key_Flags
          BPL OpRO_40         ; skip if SHIFT pressed
          LDA #<BSOS_TEXT     ; look for boot file
          STA FNADR
          LDA #>BSOS_TEXT
          STA FNADR+1
          LDA #?BSOS_TEXT
          STA FNLEN
          JSR Wedge_Prepare   ; set FA and STATUS
          LDA #0
          STA SA              ; enforce load to $0401
          LDA TXTTAB
          LDX TXTTAB+1
          STA EAL             ; TXTTAB (normally $0401)
          STX EAL+1
          JSR Open_Load_File
          LDA STATUS
          BEQ BOFi_10
          JSR UNTLK           ; not there
          JMP Kernal_Read_DS  ; clear status and return
BOFi_10   JSR LoFi_30         ; load boot file
          LDA EAL
          STA VARTAB
          LDA EAL+1
          STA VARTAB+1
          JSR Reset_BASIC_Execution
          JSR Rechain
          JMP Execute

          .FILL $cf78-* (0)

; ********
  Print_IN
; ********

          LDA #<Msg_IN
          LDY #>Msg_IN
          JSR To_Print_String
          LDA CURLIN+1
          LDX CURLIN

; ****************
  Print_Integer_XA
; ****************

          STA FAC1M1
          STX FAC1M2
          LDX #$90
          SEC
          JSR Convert_Integer_To_Real
          JSR Format_FAC1

; ***************
  To_Print_String
; ***************

          JMP Print_String

; *******************
  Format_FAC1 ; $cf93
; *******************

          LDY #1              ; start of string storage

; =====================
  Format_FAC1_Y ; $cf95
; =====================

; Format floating point number in FAC1
; The string is stored starting at $ff for Y=0
; and extending into the bottom of the stack

          LDA #0
          STA TMPVAR          ; 10's exponent

; the first character is blank for positive or '-'
; for negative numbers

          LDA #' '
          BIT FAC1SI
          BPL FoFA_02
          LDA #'-'
FoFA_02   STA STACK-1,Y       ; 1.st char ' ' or '-'
          STA FAC1SI          ; delete sign info from FAC1
          STY TMPPTD          ; save Y
          INY                 ; next string position
          LDA #'0'            ; default for value zero

; if the value is zero, store '0' and finish

          LDX FAC1EX
          BNE FoFA_04         ; -> non zero
          JMP FoFA_94         ; store '0' and finish

; if the value is less than 1.0, scale it with 1.0e+9
; and store the scaled 10's exponent (-9) in TMPVAR
; this saves 9 iterations in loop FoFA_08

FoFA_04   LDA #0
          CPX #$81            ; exponent for >= 1.0
          BCS FoFA_06
          LDA #<REAL_1e9
          LDY #>REAL_1e9
          JSR Multiply_FAC1_With_AY
          LDA #-9
FoFA_06   STA TMPVAR          ; current 10's exponent

; scale FAC1 up until the number has more than 8 digits

FoFA_08   LDA #<REAL_1e8
          LDY #>REAL_1e8
          JSR Compare_FAC1_AY
          BPL FoFA_12         ; FAC1 >= REAL_1e8 ->
          JSR Multiply_FAC1_BY_10
          DEC TMPVAR          ; decrement 10's exponent
          BNE FoFA_08         ; always

; scale FAC1 down until the number has less than 10 digits

FoFA_10   JSR Divide_FAC1_By_10
          INC TMPVAR          ; increment 10's exponent
FoFA_12   LDA #<REAL_9x9
          LDY #>REAL_9x9      ; 999999999.5
          JSR Compare_FAC1_AY
          BPL FoFA_10         ; FAC1 > REAL_9x9 -> continue scaling

; scaling is done - now convert the digits before the decimal
; point into a 32 bit integer

          JSR Add_0_5_To_FAC1 ; add 0.5 for rounding
          JSR FAC1_LSR        ; convert to integer

; choose fixed point format if -2 < exp < 10
; else format in exponential format

          LDX #1
          LDA TMPVAR          ; current 10's exponent
          CLC
          ADC #10             ; exp difference
          BMI FoFA_14         ; value < 1.0
          CMP #11
          BCS FoFA_16         ; value >= 1e9
          ADC #$ff
          TAX                 ; X = exp + 9
          LDA #2              ; fixed point
FoFA_14   SEC
FoFA_16   SBC #2
          STA TMPVAR+1        ; exp print = 0 or exp+8
          STX TMPVAR          ; digits before decimal point
          TXA
          BEQ FoFA_18         ; -> if no digits before point
          BPL FoFA_22
FoFA_18   LDY TMPPTD
          LDA #'.'
          INY
          STA STACK-1,Y       ; insert decimal point
          TXA
          BEQ FoFA_20
          LDA #'0'
          INY
          STA STACK-1,Y       ; insert '0'
FoFA_20   STY TMPPTD
FoFA_22   LDY #0

; =================
  Format_Jiffyclock
; =================

          LDX #$80
FoFA_78   CLC
          LDA FAC1M4
          ADC Decimal_Conversion_Table+3,Y
          STA FAC1M4
          LDA FAC1M3
          ADC Decimal_Conversion_Table+2,Y
          STA FAC1M3
          LDA FAC1M2
          ADC Decimal_Conversion_Table+1,Y
          STA FAC1M2
          LDA FAC1M1
          ADC Decimal_Conversion_Table,Y
          STA FAC1M1
          INX
          BCS FoFA_80
          BPL FoFA_78
          BMI FoFA_82

FoFA_80   BMI FoFA_78
FoFA_82   TXA
          BCC FoFA_84
          EOR #$ff
          ADC #10
FoFA_84   ADC #'0'-1
          INY
          INY
          INY
          INY                 ; Y += 4
          STY VARPTR          ; save index to table
          LDY TMPPTD          ; get index to string
          INY
          TAX
          AND #$7f
          STA STACK-1,Y       ; store digit
          DEC TMPVAR          ; # of digits
          BNE FoFA_86         ; -> if not zero
          LDA #'.'
          INY
          STA STACK-1,Y       ; store decimal point
FoFA_86   STY TMPPTD          ; save string index
          LDY VARPTR          ; get table index
          TXA
          EOR #$ff
          AND #$80
          TAX
          CPY #$24            ; end of decimal table ?
          BEQ FoFA_88
          CPY #$3c            ; end of jiffy table ?
          BNE FoFA_78

; remove trailing zeroes

FoFA_88   LDY TMPPTD          ; get string index
FoFA_90   LDA STACK-1,Y
          DEY
          CMP #'0'
          BEQ FoFA_90
          CMP #'.'
          BEQ FoFA_91
          INY
FoFA_91   LDA #'+'            ; default sign for exponent
          LDX TMPVAR+1
          BEQ FoFA_95         ; -> no exponent
          BPL FoFA_92         ; -> positive exponent
          LDA #0
          SEC
          SBC TMPVAR+1        ; negate exponent
          TAX
          LDA #'-'            ; negative sign for exponent
FoFA_92   STA STACK+1,Y
          LDA #'E'
          STA STACK,Y
          TXA
          LDX #'0'-1
          SEC
FoFA_93   INX
          SBC #10
          BCS FoFA_93
          ADC #'0'+10
          STA STACK+3,Y
          TXA
          STA STACK+2,Y
          LDA #0
          STA STACK+4,Y
          BEQ FoFA_96         ; always

FoFA_94   STA STACK-1,Y
FoFA_95   LDA #0
          STA STACK,Y
FoFA_96   LDA #0
          LDY #1
          RTS

          .FILL $d0c7-* (0)

; *****************
  Float_0_5 ; $d0c7
; *****************

          .REAL $8000000000   ;    0.50000000000

; ************************
  Decimal_Conversion_Table
; ************************

          .QUAD $fa0a1f00     ; -100000000
          .QUAD $00989680     ;   10000000
          .QUAD $fff0bdc0     ;   -1000000
          .QUAD $000186a0     ;     100000
          .QUAD $ffffd8f0     ;     -10000
          .QUAD $000003e8     ;       1000
          .QUAD $ffffff9c     ;       -100
          .QUAD $0000000a     ;         10
          .QUAD $ffffffff     ;         -1

; **********************
  Jiffy_Conversion_Table
; **********************

          .QUAD $ffdf0a80     ;   -2160000
          .QUAD $00034bc0     ;     216000
          .QUAD $ffff7360     ;     -36000
          .QUAD $00000e10     ;       3600
          .QUAD $fffffda8     ;       -600
          .QUAD $0000003c     ;         60

; *****************
  Basic_SQR ; $d108
; *****************

          JSR FAC1_Round_And_Copy_To_FAC2
          LDA #<Float_0_5
          LDY #>Float_0_5
          JSR Load_FAC1_AY    ; perform (arg)^0.5

; ********
  Op_POWER
; ********

          BEQ Basic_EXP       ; -> FAC1 == 0
          LDA FAC2EX
          BNE PWR_10
          JMP CF1_10
PWR_10    LDX #<FUNCPT
          LDY #>FUNCPT
          JSR FAC1_To_XY
          LDA FAC2SI
          BPL PWR_20
          JSR Basic_INT
          LDA #<FUNCPT
          LDY #>FUNCPT
          JSR Compare_FAC1_AY
          BNE PWR_20
          TYA
          LDY CHARAC
PWR_20    JSR Copy_ABS_FAC2_To_FAC1
          TYA
          PHA
          JSR Basic_LOG
          LDA #<FUNCPT
          LDY #>FUNCPT
          JSR Multiply_FAC1_With_AY
          JSR Basic_EXP
          PLA
          LSR A
          BCC NEGA_Ret

; *********
  Op_NEGATE
; *********

          LDA FAC1EX
          BEQ NEGA_Ret
          LDA FAC1SI
          EOR #$ff            ; change sign
          STA FAC1SI
NEGA_Ret  RTS

; *********
  REV_LOG_2
; *********

          .REAL $8138aa3b29   ;    1.44269504072
VAR_EXP   .BYTE $07
          .REAL $7134583e56   ;    0.00002149876
          .REAL $74167eb31b   ;    0.00014352314
          .REAL $772feee385   ;    0.00134226348
          .REAL $7a1d841c2a   ;    0.00961401701
          .REAL $7c6359580a   ;    0.05550512686
          .REAL $7e75fde7c6   ;    0.24022638460
          .REAL $8031721810   ;    0.69314718619
          .REAL $8100000000   ;    1.00000000000

; *********
  Basic_EXP
; *********

          LDA #<REV_LOG_2
          LDY #>REV_LOG_2
          JSR Multiply_FAC1_With_AY
          LDA FROUND
          ADC #$50
          BCC EXP_10
          JSR Inc_FAC1
EXP_10    STA FUNJMP+1        ; FROUND + $50
          JSR FAC1_To_FAC2
          LDA FAC1EX
          CMP #$88
          BCC EXP_30          ; -> value < 128
EXP_20    JSR ChFA_40         ; Floating Point Exception
EXP_30    JSR Basic_INT       ; convert to integer
          LDA CHARAC
          EOR #$80
          PHA
          LDX #5
EXP_40    LDA FAC2EX,X
          LDY FAC1EX,X
          STA FAC1EX,X
          STY FAC2EX,X
          DEX
          BPL EXP_40
          LDA FUNJMP+1
          STA FROUND
          JSR Op_MINUS
          JSR Op_NEGATE
          LDA #<VAR_EXP
          LDY #>VAR_EXP
          JSR Eval_Series_AY
          LDA #0
          STA STRPTR
          PLA
          JSR ChFA_10
          RTS

          .FILL $d1d7-* (0)

; ******************************
  Square_And_Series_Eval ; $d1d7
; ******************************

          STA TMPPTD
          STY TMPPTD+1
          JSR FAC1_To_FACTPA
          LDA #<FACTPA        ; Y = 0
          JSR Multiply_FAC1_With_AY
          JSR Eval_Series
          LDA #<FACTPA
          LDY #>FACTPA
          JMP Multiply_FAC1_With_AY

; **************
  Eval_Series_AY
; **************

          STA TMPPTD
          STY TMPPTD+1

; ***********
  Eval_Series
; ***********

          JSR FAC1_To_FACTPB
          LDA (TMPPTD),Y
          STA SGNFLG          ; # of terms
          LDY TMPPTD
          INY
          TYA
          BNE EvSe_10
          INC TMPPTD+1
EvSe_10   STA TMPPTD
          LDY TMPPTD+1
EvSe_20   JSR Multiply_FAC1_With_AY
          LDA TMPPTD
          LDY TMPPTD+1
          CLC
          ADC #5              ; advance polynomial pointer
          BCC EvSe_30
          INY
EvSe_30   STA TMPPTD
          STY TMPPTD+1
          JSR Add_Var_AY_To_FAC1
          LDA #<FACTPB
          LDY #>FACTPB
          DEC SGNFLG
          BNE EvSe_20         ; -> next polynomial
          RTS

RND_VA    .QUAD $9835447a     ; -1741339526
RND_VB    .QUAD $6828b146     ;  1747497286

; *********
  Basic_RND
; *********

; The random factor argument from RND(arg) is interpreted:
; arg < 0 : use argument as random seed
; arg = 0 : use timer 1 and 2 for random seed
; arg > 0 : start with fixed random seed from ROM

          JSR Get_FAC1_Sign
          BMI RND_20
          BNE RND_10
          LDA VIA_Timer_1_Lo  ; timer seed
          STA FAC1M1
          LDA VIA_Timer_2_Lo
          STA FAC1M2
          LDA VIA_Timer_1_Hi
          STA FAC1M3
          LDA VIA_Timer_2_Hi
          STA FAC1M4
          JMP RND_30
RND_10    LDA #<RNDX          ; fixed seed
          LDY #>RNDX
          JSR Load_FAC1_AY
          LDA #<RND_VA
          LDY #>RND_VA
          JSR Multiply_FAC1_With_AY
          LDA #<RND_VB
          LDY #>RND_VB
          JSR Add_Var_AY_To_FAC1
RND_20    LDX FAC1M4          ; argument seed
          LDA FAC1M1
          STA FAC1M4
          STX FAC1M1
          LDX FAC1M2
          LDA FAC1M3
          STA FAC1M2
          STX FAC1M3
RND_30    LDA #0
          STA FAC1SI
          LDA FAC1EX
          STA FROUND
          LDA #$80
          STA FAC1EX
          JSR Normalise_FAC1
          LDX #<RNDX
          LDY #>RNDX
          JMP FAC1_To_XY

; *********
  Basic_COS
; *********

          LDA #<PI_Half
          LDY #>PI_Half
          JSR Add_Var_AY_To_FAC1

; *****************
  Basic_SIN ; $d289
; *****************

          JSR FAC1_Round_And_Copy_To_FAC2
          LDA #<Two_PI
          LDY #>Two_PI
          LDX FAC2SI
          JSR Divide_FAC2_By_AY ; arg / (2 pi)
          JSR FAC1_Round_And_Copy_To_FAC2
          JSR Basic_INT
          LDA #0
          STA STRPTR
          JSR Op_MINUS
          LDA #<Float_0_25
          LDY #>Float_0_25
          JSR AY_Minus_FAC1
          LDA FAC1SI
          PHA
          BPL SIN_10
          JSR Add_0_5_To_FAC1
          LDA FAC1SI
          BMI SIN_20
          LDA TANSGN
          EOR #$ff
          STA TANSGN
SIN_10    JSR Op_NEGATE
SIN_20    LDA #<Float_0_25
          LDY #>Float_0_25
          JSR Add_Var_AY_To_FAC1
          PLA
          BPL SIN_30
          JSR Op_NEGATE
SIN_30    LDA #<VAR_SIN
          LDY #>VAR_SIN
          JMP Square_And_Series_Eval

; *********
  Basic_TAN
; *********

          JSR FAC1_To_FACTPA
          LDA #0
          STA TANSGN
          JSR Basic_SIN
          LDX #<FUNCPT
          LDY #>FUNCPT
          JSR FAC1_To_XY
          LDA #<FACTPA
          LDY #>FACTPA
          JSR Load_FAC1_AY
          LDA #0
          STA FAC1SI
          LDA TANSGN
          JSR TAN_10
          LDA #<FUNCPT
          LDY #>FUNCPT
          JMP AY_Divided_By_FAC1

; ******
  TAN_10
; ******

          PHA
          JMP SIN_10
PI_Half   .REAL $81490fdaa2   ;    1.57079632673
Two_PI    .REAL $83490fdaa2   ;    6.28318530694

; **********
  Float_0_25
; **********

          .REAL $7f00000000   ;    0.25000000000
VAR_SIN   .BYTE $05
          .REAL $84e61a2d1b   ;  -14.38139067218
          .REAL $862807fbf8   ;   42.00779712200
          .REAL $8799688901   ;  -76.70417025685
          .REAL $872335dfe1   ;   81.60522368550
          .REAL $86a55de728   ;  -41.34170210361
          .REAL $83490fdaa2   ;    6.28318530694

; *****************
  Basic_ATN ; $d32c
; *****************

          LDA FAC1SI
          PHA                 ; save sign
          LDA #0
          STA FAC1SI          ; use symmetry of arctangent
          LDA FAC1EX
          CMP #$81
          PHP                 ; save flags
          BCC ATN_20          ; -> arg < 1.0
          LDA #<REAL_1
          LDY #>REAL_1
          JSR AY_Divided_By_FAC1
ATN_20    LDA #<VAR_ATN
          LDY #>VAR_ATN
          JSR Square_And_Series_Eval
          PLP                 ; restore comparison flags
          BCC ATN_30          ; -> arg < 1.0
          LDA #<PI_Half
          LDY #>PI_Half
          JSR AY_Minus_FAC1
ATN_30    PLA
          STA FAC1SI          ; use same sign as arguemnt
          RTS

          .FILL $d35c-* (0)

; ***************
  VAR_ATN ; $d35c
; ***************

          .BYTE $0b
          .REAL $76b383bdd3   ;   -0.00068479391
          .REAL $791ef4a6f5   ;    0.00485094216
          .REAL $7b83fcb010   ;   -0.01611170184
          .REAL $7c0c1f67ca   ;    0.03420963805
          .REAL $7cde53cbc1   ;   -0.05427913276
          .REAL $7d1464704c   ;    0.07245719654
          .REAL $7db7ea517a   ;   -0.08980239538
          .REAL $7d6330887e   ;    0.11093241343
          .REAL $7e9244993a   ;   -0.14283980767
          .REAL $7e4ccc91c7   ;    0.19999912049
          .REAL $7faaaaaa13   ;   -0.33333331568
          .REAL $8100000000   ;    1.00000000000

; **********
  CHRGET_ROM
; **********

          INC TXTPTR
          BNE CHRG_10
          INC TXTPTR+1
CHRG_10   LDA $ea60           ; dummy address
          CMP #':'
          BCS CHRG_20
          CMP #' '
          BEQ CHRGET_ROM
          SEC
          SBC #'0'
          SEC
          SBC #$d0
CHRG_20   RTS

          .REAL $804fc75258   ;    0.81163515709

; **********************
  Init_BASIC_RAM_Vectors
; **********************

          JSR Flush_BASIC_Stack
          LDA #$4c            ; JMP code
          STA JUMPER
          STA Basic_USR
          LDA #<Jump_To_Illegal_Quantity
          LDY #>Jump_To_Illegal_Quantity
          STA USRVEC
          STY USRVEC+1
          LDX #$1c
IBRV_10   LDA CHRGET_ROM-1,X
          STA CHRGET-1,X
          DEX
          BNE IBRV_10         ; X=0 on exit
          STX IOPMPT          ; 0
          STX LASTPT+1        ; 0
          STX $0400           ; BASIC start
          LDY #4              ; X=0  Y=4
          STY TXTTAB+1        ; >$0401
          STX LINNUM
          STY LINNUM+1        ; $0400
          LDA #8
          STA Wedge_Unit
          LDY #1              ; start RAM test at $0401
          STY TXTTAB          ; (TXTTAB) = $0401
IBRV_20   LDA (LINNUM),Y
          TAX                 ; save content
          LDA #$55            ; test pattern
          STA (LINNUM),Y
          CMP (LINNUM),Y
          BNE IBRV_30         ; failed
          ASL A               ; shift pattern
          STA (LINNUM),Y
          CMP (LINNUM),Y
          BNE IBRV_30         ; failed
          TXA                 ; restore content
          STA (LINNUM),Y
          INY                 ; next address
          BNE IBRV_20         ; loop
          INC LINNUM+1
          BPL IBRV_20         ; loop for LINNUM < $8000
IBRV_30   LDA LINNUM+1
          STY MEMSIZ
          STA MEMSIZ+1        ; top of RAM + 1
          STY FRETOP
          STA FRETOP+1
          JSR Init_RAM_Vectors
          LDA #<Start_Message
          LDY #>Start_Message
          JSR Print_String
          LDA MEMSIZ
          SEC
          SBC TXTTAB
          TAX
          LDA MEMSIZ+1
          SBC TXTTAB+1
          JSR Print_Integer_XA
          LDA #<Bytes_Free_Message
          LDY #>Bytes_Free_Message
          JSR Print_String
          JSR Perform_NEW
          JSR Option_ROM
          JSR BOOT_File
          JMP Basic_Ready

; ******************
  Bytes_Free_Message
; ******************

          .BYTE " BYTES FREE\r",0

; *******
  Monitor
; *******
          LDA #>[Basic_Ready+1]
          PHA
          LDA #<[Basic_Ready+1]
          PHA
          LDA #0              ; clear if not already 0
          PHA                 ; Y
          PHA                 ; X
          PHA                 ; A
          PHA                 ; SR

; *************
  MONITOR_BREAK
; *************

          CLD
          LDX #1              ; 1 for BRK
          CMP #$20            ; T2 single step IRQ
          BNE MOBR_05
          DEX                 ; 0 for STEP IRQ
MOBR_05   STX PC_Adjust
          JSR Kernal_CLRCHN
          PLA
          STA Mon_Register+7  ; Y
          PLA
          STA Mon_Register+6  ; X
          PLA
          STA Mon_Register+5  ; A
          PLA
          STA Mon_Register+4  ; SR
          JSR Install_Bank_Access ; Carry = 1
          PLA
          SBC PC_Adjust
          STA Mon_Register+1  ; PC lo
          PLA
          SBC #0
          STA Mon_Register    ; PC hi
          LDA CINV
          STA Mon_Register+3  ; IRQ lo
          LDA CINV+1
          STA Mon_Register+2  ; IRQ hi
          TSX
          STX Mon_Register+8  ; SP
          LDA R_Bank
          STA Mon_Register+9  ; RB
          LDA W_Bank
          STA Mon_Register+10 ; WB
          CLI
          LDX PC_Adjust
          BEQ MOBR_20         ; no greetings on single step mode
          LDY #-1
MOBR_10   INY
          LDA Mon_Start,Y
          BEQ MOBR_20
          JSR EDIT_CHROUT
          JMP MOBR_10
MOBR_20   LDA #'R'
          BNE Mon_20          ; always

; *********
  Mon_Error
; *********

          LDA #'?'
          JSR EDIT_CHROUT

; ********
  Mon_Main
; ********

          JSR Mon_Print_CR
          LDA #$40
          STA Power_Flag      ; activate power scrolling
Mon_10    JSR Mon_CHRIN
          BEQ Mon_Main
          CMP #' '
          BEQ Mon_10
Mon_20    LDX #24
Mon_30    DEX
          BMI Mon_Error
          CMP Mon_Commands,X
          BNE Mon_30
          LDA Mon_Sub_Hi,X
          PHA
          LDA Mon_Sub_Lo,X
          PHA
          RTS

; **********************
  Mon_Print_A_Hex_Values
; **********************

          STA MONCNT
          LDY #0
MPAH_10   JSR Mon_Print_Blank
          JSR Bank_Fetch
          JSR Print_Hex_Byte
          INY
          CPY #8
          BNE MPAH_12
          JSR Mon_Print_Blank
MPAH_12   CPY MONCNT
          BCC MPAH_10
          JSR Mon_Print_Blank
          LDA MONCNT
          CMP #16
          BNE MPAH_Ret
          LDY #0
MPAH_20   JSR Bank_Fetch
          AND #$7f
          CMP #$20
          BCC MPAH_30
          CMP #$60
          BCC MPAH_40
MPAH_30   LDA #'.'
MPAH_40   JSR EDIT_CHROUT
          INY
          CPY #8
          BNE MPAH_42
          JSR Mon_Print_Blank
MPAH_42   CPY MONCNT
          BCC MPAH_20
MPAH_Ret  RTS

; *****************
  Mon_STAL_Register
; *****************

          LDA #<[Mon_Register+4]
          STA STAL
          LDA #>[Mon_Register+4]
          STA STAL+1
          LDA #7              ; 7 bytes to display
          RTS

; ***************
  Mon_Print_Blank
; ***************

          LDA #$20            ; ' '
          .BYTE $2c

; ************
  Mon_Print_CR
; ************

          LDA #CR
          JMP EDIT_CHROUT


  Mon_Start .BYTE "BS MONITOR "

; ************
  Mon_Commands
; ************

          .BYTE "#$./:;@ABCDFGHLMNRSTUWX",0

; **********
  Mon_Sub_Hi
; **********

          .BYTE >[Mon_Unit-1]           ; #
          .BYTE >[Mon_Dir-1]            ; $
          .BYTE >[Assemble-1]           ; .
          .BYTE >[Mon_Load-1]           ; /
          .BYTE >[Modify_Memory-1]      ; :
          .BYTE >[Modify_Register-1]    ; ;
          .BYTE >[Mon_Wedge-1]          ; @
          .BYTE >[Assemble-1]           ; A
          .BYTE >[Mon_Set_Bank-1]       ; B
          .BYTE >[Mon_Compare-1]        ; C
          .BYTE >[Disassemble-1]        ; D
          .BYTE >[Mon_Fill-1]           ; F
          .BYTE >[Mon_Go-1]             ; G
          .BYTE >[Mon_Hunt-1]           ; H
          .BYTE >[Mon_Load-1]           ; L
          .BYTE >[Display_Memory-1]     ; M
          .BYTE >[Mon_Next]             ; N
          .BYTE >[Display_Register-1]   ; R
          .BYTE >[Mon_Save-1]           ; S
          .BYTE >[Mon_Transfer-1]       ; T
          .BYTE >[Mon_Disk-1]           ; U
          .BYTE >[Mon_Write_Bank-1]     ; W
          .BYTE >[Mon_Exit-1]           ; X

; **********
  Mon_Sub_Lo
; **********

          .BYTE <[Mon_Unit-1]           ; #
          .BYTE <[Mon_Dir-1]            ; $
          .BYTE <[Assemble-1]           ; .
          .BYTE <[Mon_Load-1]           ; /
          .BYTE <[Modify_Memory-1]      ; :
          .BYTE <[Modify_Register-1]    ; ;
          .BYTE <[Mon_Wedge-1]          ; @
          .BYTE <[Assemble-1]           ; A
          .BYTE <[Mon_Set_Bank-1]       ; B
          .BYTE <[Mon_Compare-1]        ; C
          .BYTE <[Disassemble-1]        ; D
          .BYTE <[Mon_Fill-1]           ; F
          .BYTE <[Mon_Go-1]             ; G
          .BYTE <[Mon_Hunt-1]           ; H
          .BYTE <[Mon_Load-1]           ; L
          .BYTE <[Display_Memory-1]     ; M
          .BYTE <[Mon_Next]             ; N
          .BYTE <[Display_Register-1]   ; R
          .BYTE <[Mon_Save-1]           ; S
          .BYTE <[Mon_Transfer-1]       ; T
          .BYTE <[Mon_Disk-1]           ; U
          .BYTE <[Mon_Write_Bank-1]     ; W
          .BYTE <[Mon_Exit-1]           ; X

; **********
  Mon_Prompt
; **********

          PHA
          JSR Mon_Print_CR
          PLA
          JMP EDIT_CHROUT

; ****************
  Display_Register
; ****************

          LDX #0
DiRe_10   LDA Mon_Message,X
          JSR EDIT_CHROUT
          INX
          CPX #42
          BNE DiRe_10
          LDA R_Bank
          STA Mon_Register+9
          LDA W_Bank
          STA Mon_Register+10
          LDA #';'
          JSR Mon_Prompt
          JSR Mon_Print_Blank
          LDA Mon_Register    ; display PC
          JSR Print_Hex_Byte
          LDA Mon_Register+1
          JSR Print_Hex_Byte
          JSR Mon_Print_Blank
          LDA Mon_Register+2  ; display IRQ vector
          JSR Print_Hex_Byte
          LDA Mon_Register+3
          JSR Print_Hex_Byte
          JSR Mon_STAL_Register
          JSR Mon_Print_A_Hex_Values
          LDA Mon_Register+4  ; SR
          STA MONCNT
          LDX #8
DiRe_20   LDA #'0'
          ASL MONCNT
          ADC #0
          JSR EDIT_CHROUT
          DEX
          BNE DiRe_20
          LDA PC_Adjust
          BNE To_Mon_Main     ; branch if not stepping
          LDA Mon_Register+1
          STA STAL
          LDA Mon_Register
          STA STAL+1
          JMP Disa_15


; ************
  Mon_Cmp_Addr
; ************

          LDA Dis_Line        ; negative: compare addresses
          BMI Cmp_STAL_MEMUSS
          INC Dis_Line
          LDA #16
          CMP Dis_Line        ; line count > 16 ?
          RTS

; ***************
  Cmp_STAL_MEMUSS
; ***************

          LDA MEMUSS          ; end addr >= start addr ?
          CMP STAL
          LDA MEMUSS+1
          SBC STAL+1
          RTS

; ****************
  Display_16_Bytes
; ****************

          LDA #':'
          JSR Mon_Prompt
Dis_16    JSR Mon_Print_STAL
          LDA #16             ; dump 16 bytes per line
          JSR Mon_Print_A_Hex_Values
          LDA #16
          JMP Add_STAL

; **************
  Display_Memory
; **************

          JSR Mon_Get_Addr
DiMe_10   JSR Check_STOP_Key  ; STOP key pressed?
          BEQ To_Mon_Main
          JSR Mon_Cmp_Addr
          BCC To_Mon_Main     ; STAL > MEMUSS ?
          JSR Display_16_Bytes
          BNE DiMe_10         ; always
To_Mon_Main
          JMP Mon_Main

; ************
  Mon_Get_Addr
; ************

          LDY #0              ; reset line count
          STY Dis_Line
          DEY                 ; Y = $ff
          STY MEMUSS
          STY MEMUSS+1        ; default end address = $ffff
          JSR Mon_CHRIN       ; detect CR or skip blank
          BEQ MGA_Ret         ; use last value for STAL
          JSR Hex_To_STAL     ; read start address to STAL
          BCC MGA_Err
          JSR Mon_CHRIN       ; detect CR or skip blank
          BEQ MGA_Ret
          LDX #MEMUSS
          JSR Read_Hex_Word  ; read end address
          BCC MGA_Err
          DEC Dis_Line        ; disable line count
MGA_Ret   RTS
MGA_Err   PLA
          PLA
To_Mon_Err
          JMP Mon_Error

; ***************
  Modify_Register
; ***************

          LDX #0
MoRe_10   JSR Read_Hex
          STA Mon_Register,X
          INX
          CPX #11
          BCC MoRe_10
          LDA Mon_Register+9
          STA R_Bank
          LDA Mon_Register+10
          STA W_Bank
          JMP Mon_Main

; *************
  Modify_Memory
; *************

          JSR Hex_To_STAL
          BCC To_Mon_Err
          LDA #16
MoMe_10   STA MONCNT
          LDA STAL
          STA BPTR
          LDA STAL+1
          STA BPTR+1
          LDY #0
MoMe_20   JSR Read_Hex
          BCC To_Mon_Err
          STA Mon_Tmp
          JSR Bank_Store
          JSR Bank_Fetch
          CMP Mon_Tmp
          BNE To_Mon_Err      ; not RAM
MoMe_30   INY
          CPY MONCNT
          BCC MoMe_20
          BCS To_Mon_Main

; ******
  Mon_Go
; ******

          JSR Mon_CHRIN
          BEQ MoGo_10
          CMP #' '
          BNE To_Mon_Err
          JSR Read_Hex
          STA Mon_Register
          JSR Read_Hex
          STA Mon_Register+1
MoGo_10   SEI
          LDA Mon_Register+2  ; IRQ
          STA CINV+1
          LDA Mon_Register+3
          STA CINV

; ********
  Mon_Step
; ********

          LDX Mon_Register+8  ; SP
          TXS
          LDA Mon_Register    ; PC high
          PHA
          LDA Mon_Register+1  ; PC low
          PHA
          LDA Mon_Register+4  ; SR
          PHA
          LDA Mon_Register+5
          LDX Mon_Register+6
          LDY Mon_Register+7
          RTI

; ********
  Mon_Exit
; ********

          LDX Mon_Register+8  ; SP
          TXS
          JMP Basic_Ready

; *************
  Set_DOS_FNADR
; *************

          LDA #<DOS_Filename
          STA FNADR
          LDA #>DOS_Filename
          STA FNADR+1
          RTS

; ********
  Mon_Load
; ********

          LDA #0              ; load flag
          .BYTE $2c           ; skip 2 bytes

; ********
  Mon_Save
; ********

          LDA #$80            ; save flag
          STA VERCK           ; (0) LOAD, ($80) SAVE
          LDY #1
          STY SA              ; use file load address
          DEY                 ; Y = 0
          JSR Set_DOS_FNADR
          JSR Wedge_Prepare   ; set FA and STATUS
MLS_10    JSR Mon_CHRIN
          BEQ MLS_Err         ; filename required
          CMP #QUOTE          ; filename must be quoted
          BNE MLS_10          ; skip until leading quote
MLS_20    JSR Mon_CHRIN       ; next char in string
          BEQ MLS_Err         ; no ending quote
          CMP #QUOTE          ; ending quote?
          BEQ MLS_50
          STA (FNADR),Y       ; append to filename
          INY                 ; next
          CPY #16
          BCC MLS_20          ; loop
MLS_Err   JMP Mon_Error

MLS_30    BIT VERCK           ; LOAD or SAVE ?
MLS_35    BMI MLS_Err         ; SAVE needs range
          JSR Load_File
          JMP Mon_Main        ; OK - done

MLS_50    STY FNLEN
          JSR Mon_CHRIN       ; parameter after filename
          BEQ MLS_30
          CMP #','            ; comma needed
          BNE MLS_50
          JSR Read_Hex        ; read device
          STA FA
          JSR Mon_CHRIN
          BEQ MLS_30          ; no range -> LOAD
          CMP #','            ; comma needed
          BNE MLS_Err
          JSR Hex_To_STAL     ; STAL = start address
          LDA #0
          STA SA              ; relocate to EAL
          JSR Mon_CHRIN
          CMP #','
          BNE MLS_Err
          LDX #EAL
          JSR Read_Hex_Word   ; EAL  = end address
          BCC MLS_Err
          BIT VERCK           ; (0) LOAD or ($80) SAVE
          BPL MLS_Err
          JSR Save_File
          JMP Mon_Main

; *************
  Make_Hex_Byte
; *************

          PHA
          LSR A
          LSR A
          LSR A
          LSR A
          JSR Nibble_To_Hex
          TAX
          PLA
          AND #15
          JMP Nibble_To_Hex

; **************
  Mon_Print_STAL
; **************

          LDA STAL+1
          JSR Print_Hex_Byte
          LDA STAL

; **************
  Print_Hex_Byte
; **************

          JSR Make_Hex_Byte

; ************
  Mon_Print_XA
; ************

          PHA
          TXA
          JSR EDIT_CHROUT
          PLA
          JMP EDIT_CHROUT

; *************
  Nibble_To_Hex
; *************

          CLC
          ADC #$f6
          BCC NTH_10
          ADC #6
NTH_10    ADC #$3a
          RTS

; ***********
  Hex_To_STAL
; ***********

          LDX #STAL

; *************
  Read_Hex_Word
; *************

          JSR Read_Hex        ; X points to word address
          BCC RHW_Ret
          STA 1,X             ; high byte
          JSR Read_Hex
          STA 0,X             ; low  byte
RHW_Ret   RTS

; ********
  Read_Hex
; ********

; read a two digit hex number, allow leading blanks

          JSR SCRIN
          CMP #' '
          BEQ Read_Hex
Read_Hex_A
          JSR Is_Hex
          BCC ReHe_Ret         ; error
          JSR Hex_To_Bin
          ASL A
          ASL A
          ASL A
          ASL A
          STA Mon_Tmp
          JSR SCRIN
          JSR Is_Hex
          BCC ReHe_Ret         ; error
          JSR Hex_To_Bin
          ORA Mon_Tmp
          SEC
ReHe_Ret  RTS

          .FILL $d7af - * (0)

; *************
  Kernal_RECORD
; *************

          LDA #1
          STA DOS_Tmp         ; default for position
          JSR CHRGOT
          LDA #'#'
          JSR Need_A
          JSR DOS_Get_Byte    ; get lfn
          CPX #0
          BEQ RECO_40
          STX LA
          JSR Need_Comma
          BEQ DOS_JMP_Syntax_Error
          BCC RECO_10         ; -> numeric
          JSR Need_Left_Parenthesis
          JSR Eval_Expression
          JSR FAC1_To_LINNUM
          JSR Need_Right_Parenthesis
          JMP RECO_20
RECO_10   JSR Eval_Expression ; get record #
          JSR FAC1_To_LINNUM
RECO_20   JSR CHRGOT
          BEQ RECO_30
          JSR Need_Comma
          BEQ DOS_JMP_Syntax_Error
          JSR DOS_Get_Byte    ; get position
          CPX #0
          BEQ RECO_40
          CPX #$ff
          BEQ RECO_40
          STX DOS_Tmp
          JSR CHRGOT
          BNE DOS_JMP_Syntax_Error
RECO_30   JMP Build_Record_Command
RECO_40   JMP DOS_JMP_Illegal_Quantity

; *************************
  Allow_Drive_Unit_Filename
; *************************

          AND #$e6
          BEQ Check_Filename_Given

; ********************
  DOS_JMP_Syntax_Error
; ********************

          JMP Syntax_Error

; ********************
  Check_Filename_Given
; ********************

          LDA DOS_Flags
          AND #1
          CMP #1
          BNE DOS_JMP_Syntax_Error
          LDA DOS_Flags
          RTS

; ********************
  Allow_Drive_And_Unit
; ********************

          AND #$e7
          BNE DOS_JMP_Syntax_Error
          RTS

; ************
  No_WL_Record
; ************

          AND #$c4
          BNE DOS_JMP_Syntax_Error
          LDA DOS_Flags

; *********************
  Check_Filename_Syntax
; *********************

          AND #3
          CMP #3
          BNE DOS_JMP_Syntax_Error
          LDA DOS_Flags
          RTS

; *******************
  Check_Record_Syntax
; *******************

          AND #5
          CMP #5
          BNE DOS_JMP_Syntax_Error
          LDA DOS_Flags
          RTS

; ***************
  DOS_Build_Table
; ***************

          .BYTE $ff
          ;-------------------- directory $00
          .BYTE "$"
          .BYTE $d1           ; drive 1

          ;-------------------- dopen     $02
          .BYTE $d1           ; drive 1
          .BYTE ":"
          .BYTE $f1           ; file 1
          .BYTE ","
          .BYTE $e1           ; L,S,W
          .BYTE ","
          .BYTE $e0           ; Record length

          ;-------------------- append    $09
          .BYTE $d1           ; drive 1
          .BYTE ":"
          .BYTE $f1           ; file 1
          .BYTE ",A"

          ;-------------------- header    $0e
          .BYTE "N"
          .BYTE $d1           ; drive 1
          .BYTE ":"
          .BYTE $f1           ; file 1
          .BYTE ","
          .BYTE $d0           ; ID

          ;-------------------- collect   $14
          .BYTE "V"
          .BYTE $d1           ; drive 1

          ;-------------------- backup    $16
          .BYTE "D"
          .BYTE $d2           ; drive 2
          .BYTE "="
          .BYTE $d1           ; drive 1

          ;-------------------- copy      $1a
          .BYTE "C"
          .BYTE $d2           ; drive 2
          .BYTE ":"
          .BYTE $f2           ; file 2
          .BYTE "="
          .BYTE $d1           ; drive 1
          .BYTE ":"
          .BYTE $f1           ; file 1

          ;-------------------- concat    $22
          .BYTE "C"
          .BYTE $d2           ; drive 2
          .BYTE ":"
          .BYTE $f2           ; file 2
          .BYTE "="
          .BYTE $d2           ; drive 2
          .BYTE ":"
          .BYTE $f2           ; file 2
          .BYTE ","
          .BYTE $d1           ; drive 1
          .BYTE ":"
          .BYTE $f1           ; file 1

          ;-------------------- rename    $2e
          .BYTE "R"
          .BYTE $d1           ; drive 1
          .BYTE ":"
          .BYTE $f2           ; file 2
          .BYTE "="
          .BYTE $d1           ; drive 1
          .BYTE ":"
          .BYTE $f1           ; file 1

          ;-------------------- scratch   $36
          .BYTE "S"
          .BYTE $d1           ; drive 1
          .BYTE ":"
          .BYTE $f1           ; file 1

; ****************
  Kernal_DIRECTORY
; ****************

          JSR Parse_DOS_Parameter
          JSR Allow_Drive_And_Unit
          LDY #0
          LDX #1
          LDA DOS_Flags
          AND #16
          BEQ DIRE_10
          INX                 ; drive given
DIRE_10   TXA
          JSR Build_DOS_Command

; **************
  Wedge_Call_Dir
; **************

          LDA #$60            ; secondary address 0 for LOAD
          STA SA
          LDA #14             ; logical address used for loading directory
          STA LA
          JSR UNLSN
          JSR Open_File
          LDX #14
          JSR Kernal_CHKIN    ; input from floppy
          LDY #3              ; 1st time: skip load address + next line link
WCD_10    JSR ACPTR           ; read until length in blocks read
          TAX                 ; file size low in X
          LDA STATUS
          BNE WCD_80          ; abort if status bad
          JSR ACPTR           ; file size high in A
          DEY
          BNE WCD_10          ; if not done
          JSR Print_Integer_XA; output number of blocks
          LDA #' '            ; output separator space
          JSR EDIT_CHROUT
WCD_20    JSR ACPTR           ; get char
          BEQ WCD_40          ; branch if end of line
          LDX STATUS          ; get status
          BNE WCD_80          ; abort if bad status
          JSR EDIT_CHROUT
          JSR Check_STOP_Key  ; abort if STOP key pressed
          BEQ WCD_80
          JSR GETIN_10        ; read keyboard
          CMP #' '
          BNE WCD_20          ; continue if not SPACE pressed
WCD_30    JSR GETIN_10        ; read keyboard
          BEQ WCD_30          ; loop until any key pressed
          BNE WCD_20          ; branch always: continue reading dir characters

WCD_40    LDA #CR             ; end of line: output CR
          JSR EDIT_CHROUT
          LDY #2              ; further passes: skip line link only
          BNE WCD_10          ; branch always

WCD_80    JSR Kernal_CLRCHN   ; exit: clear channel
          LDA #14             ; close directory
          JMP Close_LA_in_A

; ************
  Mon_Set_Bank
; ************

          JSR Read_Hex
          STA R_Bank
          JMP Mon_Main

; **************
  Mon_Write_Bank
; **************

          JSR Read_Hex
          STA W_Bank
          JMP Mon_Main

; *********
  Mon_CHRIN
; *********

          JSR Kernal_CHRIN
          CMP #CR
          RTS

; **********
  Hex_To_Bin
; **********

          CMP #$3a
          PHP
          AND #15
          PLP
          BCC HTB_Ret
          ADC #8
HTB_Ret   RTS

; ******
  Is_Int
; ******

          CMP #'$'
          BEQ IH_True
          CMP #'+'
          BEQ IH_True
          CMP #'-'
          BEQ IH_True

; ******
  Is_Hex
; ******

          CMP #'F'+1
          BCS IH_False
          CMP #'A'
          BCS IH_True

; ******
  Is_Dec
; ******

          CMP #'0'
          BCC IH_False
          CMP #'9'+1
          BCS IH_False
IH_True   SEC
          RTS                 ; carry 1 : true
IH_False  CLC
          RTS                 ; carry 0 : false

          .FILL $d92f - * (0)

; **************
  Select_Free_SA
; **************

          LDY #$61            ; start with SA = $62
SFSA_10   INY
          TYA
          LDX LDTND           ; # of open files
SFSA_20   DEX
          BMI SFSA_30         ; -> not in use : take this SA
          CMP SAT,X
          BEQ SFSA_10         ; -> in use: try next
          BNE SFSA_20
SFSA_30   STY SA
          RTS

; ********************
  Kernal_DOPEN ; $d942
; ********************

          JSR Parse_DOS_Parameter
          JSR Check_Record_Syntax
          AND #$22            ; 2nd. filename or drive ?
          BNE DOPEN_Err
          JSR Select_Free_SA  ; choose free secondary address
          LDX #0              ; buffer index
          LDA #3              ; length of build string (open read)
          BIT DOS_Flags
          BVC DOPEN_20        ; -> not a write file
          PHP                 ; save flags
          LDA #7              ; length of build string (open write)
          PLP                 ; restore flags
DOPEN_20  BPL DOPEN_30        ; -> not a replacement
          LDY #'@'            ; insert save & replace command
          STY DOS_Command_Buffer
          INX                 ; advance buffer index
DOPEN_30  LDY #2              ; start  of build string (open)
          JSR Build_DOS_Command_X
          JMP Mf563
DOPEN_Err JMP Syntax_Error

          .SIZE

          .FILL $d977-* (0)

; *********************
  Kernal_APPEND ; $d977
; *********************

          JSR Parse_DOS_Parameter
          JSR Check_Record_Syntax
          AND #$e2            ; @,W,L,drive 2 or file 2 ?
          BNE DOPEN_Err
          JSR Select_Free_SA
          LDY #9              ; start  of build string (append)
          LDA #5              ; length of build string (append)
          JSR Build_DOS_Command
          JMP Mf563

          .FILL $d991-* (0)

; **********************
  Kernal_Read_DS ; $d991
; **********************

          LDA FA
          BNE KRD_10
          LDA #8              ; default 8 if not set
          STA FA
KRD_10    JSR TALK
          LDA #$6f
          STA SA
          JSR TKSA
          LDX #0
KDR_20    JSR ACPTR
          STA DOS_Status,X
          INX
          CMP #' '
          BCC KDR_30          ; end (normally CR)
          CPX #41             ; buffer length
          BCC KDR_20
KDR_30    LDA #0
          STA DOS_Status,X
          JSR UNTLK
          LDA DOS_Status      ; load first character
          RTS

; *****
  SCRIN
; *****

          LDY CursorCol
          LDA (ScrPtr),Y
          AND #$7f            ; clear reverse bit
          CMP #$20
          BCS SCRI_10
          ORA #$40            ; display -> PET
SCRI_10   INC CursorCol
          RTS

          .FILL $d9d2-* (0)

; *********************
  Kernal_HEADER ; $d9d2
; *********************

          JSR Parse_DOS_Parameter
          JSR Allow_Drive_Unit_Filename
          AND #$11
          CMP #$11            ; name & drive set ?
          BNE DOPEN_Err
          JSR Close_All_Device_Files
          JSR Are_You_Sure
          BCS HEAD_20         ; cancel if not 'YES'
          LDY #14             ; start  of build string
          LDA #4              ; length of build string
          LDX DOS_Id          ; ID given ?
          BEQ HEAD_10
          LDA #6              ; command includes ID
HEAD_10   JSR Put_DOS_Command
          JSR Kernal_Read_DS
          CMP #'2'
          BCC HEAD_20         ; status < 20 are warnings
          JSR In_Direct_Mode
          BNE HEAD_20
          LDY #<MSG_BAD_DISK  ; $c5
          JMP Display_Kernal_Message
HEAD_20   RTS

          .FILL $da07-* (0)

; *********************
  Kernal_DCLOSE ; $da07
; *********************

          JSR Parse_DOS_Parameter
          AND #$f3            ; allow lfn only
          BEQ CLOSE_10
          JMP Syntax_Error
CLOSE_10  JSR Clear_Status
          LDA LA
          BEQ Close_All_Device_Files
          JMP Close_LA_in_A

; ******************************
  Close_All_Device_Files ; $da1b
; ******************************

          LDA FA              ; Close all open files on device FA
          LDX LDTND
CLOSE_20  DEX
          BMI CLOSE_Ret
          CMP FAT,X
          BNE CLOSE_20
          LDA LAT,X
          JSR Close_File_A
          CLV
          BVC Close_All_Device_Files
CLOSE_Ret RTS

; ****************************
  Build_Record_Command ; $da31
; ****************************

          LDA LA
          JSR LOOKUP_LA
          BEQ BRC_10
          LDY #<MSG_FILE_NOT_O; $17
          JMP Handle_IO_Error
BRC_10    JSR Set_LFS_From_X
          JSR Clear_Status

; *********************
  DOS_Record_No ; $da43
; *********************

          LDA #'P'
          STA DOS_Command_Buffer
          LDA SA
          STA DOS_Command_Buffer+1
          LDA LINNUM
          STA DOS_Command_Buffer+2
          LDA LINNUM+1
          STA DOS_Command_Buffer+3
          LDA DOS_Tmp
          STA DOS_Command_Buffer+4
          LDX #5
          JSR DOS_SETNAM
          JMP PDC_10

; **********************
  Kernal_COLLECT ; $da65
; **********************

          JSR Parse_DOS_Parameter
          JSR Allow_Drive_And_Unit
          JSR Close_All_Device_Files
          LDY #$14
          LDX #1
          LDA DOS_Flags
          AND #16             ; drive set ?
          BEQ COLL_10
          INX
COLL_10   TXA
          JMP Put_DOS_Command

; *************
  Kernal_BACKUP
; *************

          JSR Parse_DOS_Parameter
          AND #$30
          CMP #$30            ; two drives set ?
          BEQ BACK_10
BACK_Err  JMP Syntax_Error
BACK_10   LDA DOS_Flags
          AND #$c7
          BNE BACK_Err
          JSR Close_All_Device_Files
          LDY #$16
          LDA #4

; ***************
  Put_DOS_Command
; ***************

          JSR Build_DOS_Command
PDC_10    JSR LISTEN
          LDA #$6f            ; SA #15
          JMP Send_DOS_Command

          .FILL $daa7-* (0)

; *******************
  Kernal_COPY ; $daa7
; *******************

          JSR Parse_DOS_Parameter
          LDA Source_Unit     ; check source unit
          BEQ KECO_10         ; not specified
          CMP FA              ; same as target ?
          BEQ KECO_10         ; yes, stay here
          JMP DOS_Copy        ; -> extended COPY
KECO_10   LDY #$1a            ; offset
          LDA #8              ; command length
          JMP Put_DOS_Command

          .FILL $dac7 - * (0)

; *********************
  Kernal_CONCAT ; $dac7
; *********************

          JSR Parse_DOS_Parameter
          JSR No_WL_Record
          LDY #$22
          LDA #12
          JMP Put_DOS_Command

; ***************************
  Copy_Filename_To_DOS_Buffer
; ***************************

          LDA FNLEN
          STA DOS_Tmp
          LDA FNADR
          STA MEMUSS
          LDA FNADR+1
          STA MEMUSS+1

; *************************
  Copy_MEMUSS_To_DOS_Buffer
; *************************

          TYA
          PHA
          LDY DOS_Tmp
          BEQ CMDB_20
          LDY #0
CMDB_10   LDA (MEMUSS),Y
          STA DOS_Command_Buffer,X
          INX
          INY
          CPY DOS_Tmp
          BNE CMDB_10
          BEQ CMDB_30
CMDB_20   DEX
CMDB_30   PLA
          TAY
          SEC
          RTS

; *************
  Insert_DOS_Id
; *************

          LDA DOS_Id
          STA DOS_Command_Buffer,X
          INX
          LDA DOS_Id+1
          STA DOS_Command_Buffer,X
          INX
          TXA
          RTS

; ********************
  Kernal_DSAVE ; $db0d
; ********************

          JSR Parse_DOS_Parameter
          JSR Check_Filename_Given
          AND #$66            ; no 2nd. file ?
          BEQ DSAVE_10
          JMP Syntax_Error
DSAVE_10  LDY #2
          LDA DOS_Flags
          AND #$80
          BEQ DSAVE_20
          LDA #'@'            ; save & replace
          STA DOS_Command_Buffer
          LDX #1
          LDA #3
          JSR Build_DOS_Command_X
          JMP Mf6e0
DSAVE_20  LDA #3
          JSR Build_DOS_Command
          JMP Mf6e0

; ********************
  Kernal_DLOAD ; $db3a
; ********************

          JSR Parse_DOS_Parameter
          JSR Check_Filename_Given
          AND #$e6
          BEQ DLOAD_20
DLOAD_10  JMP Syntax_Error
DLOAD_20  LDY #2
          LDA #3
          JSR Build_DOS_Command
          LDA #0
          STA VERCK
          JMP Load_Verify_Params_Set

; *********************
  Kernal_RENAME ; $db55
; *********************

          JSR Parse_DOS_Parameter
          JSR Check_Filename_Syntax
          AND #$e4
          BNE DLOAD_10
          LDY #$2e
          LDA #8
          JMP Put_DOS_Command

; **********************
  Kernal_SCRATCH ; $db66
; **********************

          JSR Parse_DOS_Parameter
          JSR Allow_Drive_Unit_Filename
          JSR Are_You_Sure
          BCS DiSt_Ret
          LDY #$36
          LDA #4
          JSR Put_DOS_Command
          JSR In_Direct_Mode
          BNE DiSt_Ret
          JSR Kernal_Read_DS
          LDA #CR
          JSR EDIT_CHROUT

; **************
  Display_Status
; **************

          LDY #0
DiSt_10   LDA DOS_Status,Y
          INY
          JSR EDIT_CHROUT
          CMP #' '            ; check for end
          BCS DiSt_10
DiSt_Ret  RTS

          .FILL $db9e-* (0)

; ********************
  Are_You_Sure ; $db9e
; ********************

          JSR In_Direct_Mode
          BNE AYS_20
          LDY #<MSG_SURE      ; $b6
          JSR Display_Kernal_Message
          JSR Kernal_CLRCHN
          JSR Kernal_CHRIN
          CMP #'Y'
          BNE AYS_10
          JSR Kernal_CHRIN
          CMP #CR
          BEQ AYS_20
          CMP #'E'
          BNE AYS_10
          JSR Kernal_CHRIN
          CMP #'S'
          BNE AYS_10
          JSR Kernal_CHRIN
          CMP #CR
          BEQ AYS_20
AYS_10    CMP #CR
          SEC
          BEQ AYS_Ret
          JSR Kernal_CHRIN
          BNE AYS_10
AYS_20    CLC
AYS_Ret   RTS

          .FILL $dbe1-* (0)

; ********************
  Clear_Status ; $dbe1
; ********************

          LDA #0
          STA STATUS          ; clear STATUS
          RTS

          .FILL $dbfa-* (0)

; *************************
  Build_DOS_Command ; $dbfa
; *************************

          LDX #0

; *******************
  Build_DOS_Command_X
; *******************

          STA DOS_Command_Length
          JSR Clear_Status
BDC_10    DEC DOS_Command_Length
          BMI DOS_SETNAM      ; -> finished
          INY
          LDA DOS_Build_Table,Y
          BPL BDC_90          ; -> insert
          CMP #$f1            ; insert file 1
          BNE BDC_20
          JSR Copy_Filename_To_DOS_Buffer
BDC_20    CMP #$f2            ; insert file 2
          BNE BDC_30
          JSR Copy_MEMUSS_To_DOS_Buffer
BDC_30    CMP #$e0            ; insert 2nd. attribute
          BNE BDC_40          ; W,S or R,record length
          LDA DOS_Attr        ; record length
          BNE BDC_90          ; always
BDC_40    CMP #$d0            ; insert ID
          BNE BDC_50
          JSR Insert_DOS_Id
BDC_50    CMP #$e1            ; insert 1st. attribute
          BNE BDC_60
          JSR Write_Attribute
          BNE BDC_90
BDC_60    CMP #$d1            ; insert drive 1
          BNE BDC_70
          LDA DOS_Drive_1
          BPL BDC_80
BDC_70    CMP #$d2            ; insert drive 2
          BNE BDC_10
          LDA DOS_Drive_2
BDC_80    ORA #'0'
BDC_90    STA DOS_Command_Buffer,X
          INX
          BNE BDC_10

; **********
  DOS_SETNAM
; **********

          STX FNLEN
          LDA #<DOS_Command_Buffer
          STA FNADR
          LDA #>DOS_Command_Buffer
          STA FNADR+1
          RTS

; ***************
  Write_Attribute
; ***************

          LDA DOS_Attr
          BEQ WrAt_10
          LDA #'L'            ; L,record length
          BNE WrAt_Ret
WrAt_10   LDA #'S'            ; W,S
          STA DOS_Attr
          LDA #'W'
WrAt_Ret  RTS

; This is the universal DOS parser
; It is called by all BASIC 4 DOS commands and scans and stores

; LA              = logical address
; FA              = primary address (UNIT)
; DOS_Drive_1     = source drive
; DOS_Drive_2     = target drive
; FNADR, FNLEN    = source filename
; MEMUSS, DOS_Tmp = target filename
; Access  mode
; Replace mode

; DOS_Flags for parsing BASIC 4 DOS commands

; bit 0: $01 = source Filename given
; bit 1: $02 = target Filename given
; bit 2: $04 = logical address set in LA
; bit 3: $08 = primary address set in FA
; bit 4: $10 = drive 1 set
; bit 5: $20 = drive 2 set
; bit 6: $40 = W (Write) or L (Relative file) given
; bit 7: $80 = Save and replace flag '@'

; The routine returns with the flags stored in DOS_Flags
; and in the accumulator.

; ***************************
  Parse_DOS_Parameter ; $dc68
; ***************************

          LDX #0              ; clear:
          STX DOS_Flags       ; all flags
          STX LA              ; logical address
          STX DOS_Attr        ; attribute
          STX DOS_Drive_1     ; source drive
          STX DOS_Drive_2     ; target drive
          STX FNLEN           ; filename length
          STX DOS_Tmp         ; temporary storage
          STX DOS_Id          ; ID
          STX Source_Unit     ; for cross UNIT copy
          LDX #8              ; preset DOS device
          STX FA              ; with unit 8
          JSR CHRGOT          ; start parsing
          BNE PDP_02          ; continue
          JMP PDP_68          ; finish

PDP_02    CMP #'#'            ; logical address ?
          BEQ PDP_10
          CMP #'W'            ; write mode ?
          BEQ PDP_12
          CMP #'L'            ; relative file ?
          BEQ PDP_14
          CMP #'R'            ; read mode ?
          BNE PDP_04
          JMP PDP_37

PDP_04    CMP #'D'            ; Drive ?
          BEQ PDP_26          ; parse drive #
          CMP #$91            ; ON token
          BEQ PDP_22          ; parse unit D(value)
          CMP #'U'            ; Unit ?
          BEQ PDP_24          ; parse unit value
          CMP #QUOTE
          BEQ PDP_20
          CMP #'I'            ; ID parameter on HEADER ?
          BEQ PDP_30
          CMP #'('
          BEQ PDP_20
PDP_08    JMP Syntax_Error    ; parse error

PDP_10    LDA DOS_Flags       ; get logical address
          AND #4              ; test if set already
          BNE PDP_08          ; error if set
          JSR DOS_Parse_Value ; get logical address
          CPX #0              ; is address equal zero ?
          BEQ PDP_28          ; -> illegal quantity
          STX LA              ; store logical address
          LDA #4              ; logical address defined
          JSR Set_DOS_Flags
          JMP PDP_44

PDP_12    BIT DOS_Flags       ; process W parameter
          BVS PDP_08          ; bit 6 already set ?
          JSR CHRGET          ; skip 'W'
          JMP PDP_16          ; continue

PDP_14    JSR DOS_Parse_Value ; get record length
          CPX #0              ; is it zero ?
          BEQ PDP_28          ; -> illegal quantity
          CPX #$ff            ; ist it 255 ?
          BEQ PDP_28          ; -> illegal quantity
          STX DOS_Attr        ; store record length

PDP_16    LDA #$40            ; mark W or L set
          JSR Set_DOS_Flags
          JMP PDP_44

PDP_20    JMP PDP_38

PDP_22    JSR DOS_Parse_Unit
          STX Source_Unit
          JMP PDP_44
PDP_24    JSR Get_Unit_Value
          STX Source_Unit
          JMP PDP_44
PDP_26    LDA DOS_Flags
          AND #16             ; drive # already set ?
          BNE PDP_08          ; error if so
          JSR DOS_Parse_Value
          CPX #10             ; original ROM had CPX #2 (D0 and D1 only)
          BCS PDP_28          ; error for drive # > 9
          STX DOS_Drive_1     ; store drive #
          STX DOS_Drive_2     ; store drive #
          LDA #16             ; mark drive # set
          JSR Set_DOS_Flags
          JMP PDP_44
PDP_28    JMP DOS_JMP_Illegal_Quantity
PDP_30    LDA DOS_Attr        ; test DOS_Attr
          AND #$ff            ; this is needless
          BEQ PDP_32          ; continue if zero
          JMP Syntax_Error    ; error if not zero
PDP_32    LDY #0              ; parse ID string for HEADER
          LDX #0
PDP_34    INC TXTPTR          ; advance TXTPTR
          BNE PDP_36
          INC TXTPTR+1
PDP_36    LDA (TXTPTR),Y      ; get ID string
          STA DOS_Id,X
          INX
          CPX #2              ; maximum 2 characters
          BCC PDP_34
          LDA #$ff
          STA DOS_Attr        ; mark ID defined
PDP_37    JSR CHRGET          ; advance to next character
          JMP PDP_44
PDP_38    LDA DOS_Flags
          AND #1              ; error if filename defined
          JSR DOS_Parse_Filename
          STA FNLEN
          STA DOS_Command_Length
          JSR Set_DOS_FNADR
          LDY #0
PDP_40    LDA (INDEXA),Y      ; copy string to filename
          STA DOS_Filename,Y  ; store filename
          INY
          CPY DOS_Command_Length
          BCC PDP_40
          LDA #1              ; mark filename defined
          JSR Set_DOS_Flags
PDP_44    JSR CHRGOT          ; next character to parse
          BNE PDP_46          ; there is more
          JMP PDP_68          ; finish parsing
PDP_46    CMP #','            ; comma ?
          BNE PDP_48          ; look for tokens
          JSR CHRGET          ; next character after comma
          JMP PDP_02          ; parse next sequence
PDP_48    CMP #$91            ; ON token
          BNE PDP_50
          JMP PDP_22          ; parse unit
PDP_50    CMP #$a4            ; TO token
          BEQ PDP_52
          JMP Syntax_Error
PDP_52    JSR CHRGET
          CMP #'D'
          BEQ PDP_56          ; parse target drive
          CMP #$91            ; ON token
          BEQ PDP_58          ; get UNIT
          CMP #'U'
          BEQ PDP_60          ; get UNIT value
          CMP #QUOTE
          BEQ PDP_62
          CMP #'('
          BEQ PDP_62
PDP_54    JMP Syntax_Error
PDP_56    LDA DOS_Flags
          AND #$20            ; Drive 2 defined ?
          BNE PDP_54          ; error if so
          JSR DOS_Parse_Value
          CPX #10             ; original ROM: CPX #2 (D0 and D1 only)
          BCS DOS_JMP_Illegal_Quantity
          STX DOS_Drive_2
          LDA #$20            ; mark drive 2 defined
          JSR Set_DOS_Flags
          JMP PDP_64
PDP_58    JSR DOS_Parse_Unit
          JMP PDP_64
PDP_60    JSR Get_Unit_Value
          JMP PDP_64
PDP_62    LDA DOS_Flags
          AND #2              ; error if target filename there
          JSR DOS_Parse_Filename
          STA DOS_Tmp         ; length of target filename
          STX MEMUSS          ; save descriptor in MEMUSS
          STY MEMUSS+1
          LDA #2              ; mark target filename parsed
          JSR Set_DOS_Flags
PDP_64    JSR CHRGOT          ; current character
          BEQ PDP_68          ; finish
          CMP #','            ; another comma
          BEQ PDP_52          ; continue
          CMP #$91            ; ON token
          BEQ PDP_58          ; continue
          CMP #'U'
          BEQ PDP_60          ; get UNIT
PDP_66    JMP Syntax_Error
PDP_68    LDA DOS_Flags
          RTS

; *************
  Set_DOS_Flags
; *************

          ORA DOS_Flags
          STA DOS_Flags
          RTS

          .FILL $de27 - * (0)

; ************************
  DOS_JMP_Illegal_Quantity
; ************************

          LDX #Msg_QUANT-Msg_Start ; $35
          JMP Basic_Error

; **************
  DOS_Parse_Unit
; **************

          JSR CHRGET
          CMP #'U'
          BNE PDP_66

; **************
  Get_Unit_Value
; **************

          JSR DOS_Parse_Value
          CPX #32
          BCS DOS_JMP_Illegal_Quantity
          CPX #3
          BCC DOS_JMP_Illegal_Quantity
          STX FA
          LDA #8
          JMP Set_DOS_Flags

          .FILL $de49 - * (0)

; ******************
  DOS_Parse_Filename
; ******************

          BNE PDP_66
          JSR Eval_Expression
          JSR Eval_And_Free_String
          TAX                 ; string length
          BEQ DOS_JMP_Illegal_Quantity
          LDY #0
          LDA (INDEXA),Y
          CMP #'@'            ; replace character
          BNE DPF_30
          BIT DOS_Flags       ; @ already used ?
          BPL DPF_10
          JMP Syntax_Error
DPF_10    INC INDEXA          ; skip @
          BNE DPF_20
          INC INDEXA+1
DPF_20    DEX                 ; length - @
          LDA #$80
          JSR Set_DOS_Flags
DPF_30    TXA                 ; string length
          BEQ DOS_JMP_Illegal_Quantity
          CMP #17
          BCC DPF_40
          LDX #[Msg_LONG - Msg_Start] ; $b0 : STRING TOO LONG
          JMP Basic_Error
DPF_40    LDX INDEXA          ; string address low
          LDY INDEXA+1        ; string address high
          RTS

          .FILL $de87 - * (0)

; ***************
  DOS_Parse_Value
; ***************

          JSR CHRGET

; ************
  DOS_Get_Byte
; ************

          BNE DGB_10
          JMP Syntax_Error
DGB_10    BCC DGB_20
          JSR Need_Left_Parenthesis
          JSR Get_Byte_Value
          JMP Need_Right_Parenthesis
DGB_20    JMP Get_Byte_Value

; *************
  Start_Message
; *************

          .PET '*** BSOS 8296 ***\r\r',0

; ********
  Renumber
; ********

; check for arguments: RENUMBER new start, increment, old start

          LDA #10
          STA RENINC          ; preset increment low
          STA RENNEW          ; preset start low
          LDA #0
          STA RENINC+1
          STA RENNEW+1
          JSR CHRGOT
          BCS Renu_15         ; no arguments
          JSR Scan_Linenumber
          LDA LINNUM
          STA RENNEW          ; start low
          ORA LINNUM+1
          BNE Renu_10
Renu_Err  JMP Jump_To_Illegal_Quantity
Renu_10   LDA LINNUM+1
          STA RENNEW+1        ; start high
          JSR CHRGOT
          CMP #','
          BNE Renu_15
          JSR CHRGET
          JSR Scan_Linenumber
          LDA LINNUM
          STA RENINC          ; inc low
          ORA LINNUM+1
          BEQ Renu_Err
          LDA LINNUM+1
          STA RENINC+1        ; inc high
          JSR CHRGOT
          CMP #','
          BNE Renu_15
          JSR CHRGET
          JSR Scan_Linenumber ; get old start
          JSR Find_Power_Line ; find start line
          LDY #2
          LDA (TMPPTB),Y      ; previous # low
          CMP RENNEW
          INY
          LDA (TMPPTB),Y      ; previous # high
          SBC RENNEW+1
          BCS Renu_Err        ; New line # would be less than previous
          JSR Reset_BPTR
          BNE Renu_20         ; always

; phase 1: build table of old and new numbers

Renu_15   JSR Reset_Renumber_Pointer
Renu_20   JSR Install_Bank_Access
          LDA #$80
          STA R_Bank
          STA W_Bank

; start of new line numbers

Renu_25   LDY #1
          LDA (TMPPTC),Y      ; link high
          BEQ Renu_30         ; finished
          INY                 ; Y = 2

; next table entry

          LDA (TMPPTC),Y      ; old line low
          JSR Bank_Store
          INY                 ; Y = 3
          LDA (TMPPTC),Y      ; old line high
          JSR Bank_Store
          LDY #1
          LDA RENNEW+1        ; new line high
          JSR Bank_Store
          DEY                 ; Y = 0
          LDA RENNEW          ; new line low
          JSR Bank_Store

; increment new line

          CLC
          LDA RENNEW
          ADC RENINC
          STA RENNEW
          LDA RENNEW+1
          ADC RENINC+1
          STA RENNEW+1
          CMP #$fa            ; > 64000
          BCS Renu_Err        ; line # overflow

; increment table pointer

          LDA #4
          JSR Add_BPTR

; next basic line

          JSR Update_Link
          BNE Renu_25         ; branch if link is not zero

; table finished

Renu_30   LDY #3
          LDA #$ff            ; end marker
Renu_35   JSR Bank_Store
          DEY
          BPL Renu_35

; phase 2: build a renumbered copy in bank 2

          LDA #$8c
          STA W_Bank
          JSR Reset_Renumber_Pointer

; copy link - will be recalculated at end

Renu_40   LDY #0
          LDA (TMPPTC),Y      ; link low
          JSR Bank_Store
          INY
          LDA (TMPPTC),Y      ; link high
          JSR Bank_Store
          BEQ Renu_45         ; finished

; exchange line number from table or copy if not found

          INY
          LDA (TMPPTC),Y      ; line # low
          TAX
          INY
          LDA (TMPPTC),Y      ; line # high
          JSR Find_Entry
          LDY #2
          LDA LINNUM
          JSR Bank_Store
          INY
          LDA LINNUM+1
          JSR Bank_Store
          JSR Xfer_Line
          INY                 ; Add Y + 1
          TYA
          JSR Add_BPTR
          JSR Update_Link
          LDA BPTR+1
          CMP #$fb
          BCC Renu_40
          JMP Error_Out_Of_Memory

; copy new program from bank 2 to BASIC memory

Renu_45   LDA #$8c            ; bank 1
          STA R_Bank
          CLC
          LDA BPTR
          ADC #3
          STA RENNEW          ; end address low
          LDA BPTR+1
          ADC #0
          TAX                 ; end address high
          LDA #0
          STA STAL
          LDA #$80
          STA STAL+1
          JSR Reset_Renumber_Pointer
          LDY #0
Renu_50   JSR Bank_Fetch
          STA (TMPPTC),Y
          CPY RENNEW
          BNE Renu_55
          CPX STAL+1
          BEQ Renu_60
Renu_55   INY
          BNE Renu_50
          INC TMPPTC+1
          INC STAL+1
          BNE Renu_50
Renu_60   LDA TMPPTC+1
Renu_90   STY VARTAB          ; entry for Delete routine
          STA VARTAB+1
          JSR Reset_BASIC_Execution
          JSR Rechain
          JMP Basic_Ready

          .FILL $e000-* (0)

; *****************
  EDITOR_JUMP_TABLE
; *****************

          JMP EDIT_RESET
          JMP EDIT_GETIN
          JMP EDIT_CHRIN
          JMP EDIT_CHROUT
          JMP IRQ_MAIN
          JMP IRQ_NORMAL
          JMP IRQ_END
          JMP EDIT_CLEAR
          JMP EDIT_CHARSET_TEXT
          JMP EDIT_CHARSET_GRAPHICS
          JMP EDIT_RESET_CRT
          JMP EDIT_SCROLL_DOWN
          JMP EDIT_SCROLL_UP
          JMP EDIT_KEY_SCAN
          JMP EDIT_BEEP
          JMP EDIT_BEEP
          JMP EDIT_TOP_LEFT
          JMP EDIT_BOTTOM_RIGHT
          RTS ; EDIT_REPEAT

; **********
  EDIT_RESET
; **********

          JSR Edit_Init
          JSR EDIT_RESET_CRT

; **********
  EDIT_CLEAR
; **********

          LDX TopMargin
EDCL_10   JSR Cursor_BOL
          JSR Edit_Erase_To_EOL
          CPX BotMargin
          INX
          BCC EDCL_10         ; fall

; *********
  EDIT_HOME
; *********

          LDX TopMargin
          STX CursorRow       ; fall

; *********************
  Edit_Goto_Left_Margin
; *********************

          LDY LefMargin
          STY CursorCol       ; fall

; ******************
  Edit_Use_CursorRow
; ******************

          LDX CursorRow
          JMP Update_ScrPtr

; ************
  EDIT_SET_CRT
; ************

; Input:  A = table low
;         X = table high
;         Y = # of registers

          STA SAL
          STX SAL+1
ESC_10    LDA (SAL),Y
          STY CRT_Address
          STA CRT_Value
          DEY
          BPL ESC_10
          RTS


; *****************
  Edit_Program_Rows
; *****************

; Input:  A = maximum raster address (7 or 9)
;         Y = screen rows (30 or 25)

          STY ScreenRows
          INY
          LDX #6
          STX CRT_Address
          STY CRT_Value
          LDX #9
          STX CRT_Address
          STA CRT_Value
          RTS

          .FILL $e0a7-* (0)

; ******************
  EDIT_GETIN ; $e0a7
; ******************

          LDY KEYD            ; get next character
          LDX #0              ; scroll keyboard buffer
EDGE_10   LDA KEYD+1,X
          STA KEYD,X
          INX
          CPX CharsInBuffer
          BCC EDGE_10
          DEC CharsInBuffer
          TYA                 ; return character in (A)
          CLI
          RTS

; *************
  Edit_Get_Line
; *************

          JSR EDIT_CHROUT
EGL_10    LDA CharsInBuffer
          STA BLNSW           ; empty buffer -> blink cursor
          BEQ EGL_10          ; loop until char in buffer
          SEI                 ; disable IRQ while working with buffer
          LDA BLNON           ; blink phase
          BEQ EGL_20          ; normal ?
          LDY #0
          STY BLNON           ; blink phase normal
          INY
          STY BLNCT           ; start with visible cursor
          LDA GDBLN           ; character under cursor
          LDY CursorCol
          STA (ScrPtr),Y
EGL_20    JSR EDIT_GETIN
          CMP #$83            ; RUN key ?
          BNE EGL_40
          LDX #8
          STX CharsInBuffer
EGL_30    LDA RUN_String-1,X  ; DLOAD"*" RUN
          STA KEYD-1,X
          DEX
          BNE EGL_30
          BEQ EGL_10          ; always
EGL_40    CMP #CR             ; RETURN ?
          BNE Edit_Get_Line
          LDY RigMargin
          STY CRSW            ; not 0 -> Screen Input
          LDA #' '            ; Ignore trailing blanks
EGL_50    CMP (ScrPtr),Y
          BNE EGL_60
          DEY
          BNE EGL_50
EGL_60    INY
          STY LastInputCol    ; position after last non blank char
          JSR Edit_To_Left_Margin
          STY QTSW            ; = 0 (off)
          LDA InputRow
          CMP CursorRow
          BNE Edit_CHRIN_Screen
          LDA InputCol
          STA CursorCol
          CMP LastInputCol
          BCC Edit_CHRIN_Screen
          BCS ECS_40

          .SIZE

          .FILL $e116-* (0)

; ******************
  EDIT_CHRIN ; $e116
; ******************

          TYA
          PHA
          TXA
          PHA
          JMP (SCRIV)         ; default: jump to next statement

; *******************
  Edit_CHRIN_Standard
; *******************

          LDA CRSW
          BEQ EGL_10

; *****************
  Edit_CHRIN_Screen
; *****************

          LDY CursorCol
          LDA (ScrPtr),Y      ; get char at cursor position
          CMP #$74            ; code for Pi
          BNE ECS_05
          LDA #$ff
          BNE ECS_30
ECS_05    STA DATAX           ; save it in DATAX
          AND #$3f            ; lower case, symbols and digits
          ASL DATAX           ; reverse bit 7 -> carry
          BIT DATAX           ; uppercase or graphics ?
          BPL ECS_10          ; branch if not
          ORA #$80            ; convert upper case to PETSCII
ECS_10    BCC ECS_20          ; branch if not reversed
          LDX QTSW            ; quote mode ?
          BNE ECS_30          ; no conversion in quote mode
ECS_20    BVS ECS_30          ; no conversion for graphics
          ORA #$40            ; display code to PETSCII
ECS_30    INC CursorCol       ; advance cursor
          JSR Edit_Quote_Toggle
          CPY LastInputCol    ; at end of input ?
          BCC ECS_50          ; return if not
ECS_40    LDA #0
          STA CRSW            ; switch input to keyboard
          LDA #CR             ; load CR
          LDX #3              ; screen channel
          CPX DFLTO           ; output = screen ?
          BEQ ECS_50          ; don't echo CR
          JSR EDIT_CHROUT
ECS_50    STA DATAX           ; save character in DATAX
          PLA
          TAX                 ; restore X
          PLA
          TAY                 ; restore Y
          LDA DATAX
ECS_Ret   RTS

; *****************
  Edit_Quote_Toggle
; *****************

          CMP #QUOTE
          BNE EQT_Ret
          SBC QTSW
          STA QTSW
          LDA #QUOTE
EQT_Ret   RTS

; *****************
  Edit_Display_Char
; *****************

          LDX ReverseFlag
          BEQ EDC_10
          ORA #$80
EDC_10    LDX INSRT        ;  3  ; # of inserts outstanding
          BEQ EDC_20       ;  3
          DEC INSRT
EDC_20    STA (ScrPtr),Y   ;  6
          LDA #1           ;  2
          STA BLNCT        ;  3
          CPY RigMargin    ;  3
          INY              ;  2
          BCC EDC_30       ;  3 = 28 [total 85]

; ************************
 Edit_Chrout_Epilog_Return
; ************************

          JSR Edit_Cursor_Down
          LDY LefMargin
EDC_30    STY CursorCol    ;  3

; ******************
  Edit_Chrout_Epilog
; ******************

          PLA              ;  4
          TAY              ;  2 ; restore Y
          PLA              ;  4
          TAX              ;  2 ; restore X
          PLA              ;  4
          STA PrevChar     ;  3 ; save last used character
          CLI              ;  2
          RTS              ;  6 = 27 [total 112]

; **************
  Edit_Wrap_Back
; **************

          LDY LefMargin
          LDX TopMargin
          CPX CursorRow
          BCS EWB_10          ; don't wrap on top row
          LDY RigMargin
          DEC CursorRow
          JSR Edit_Use_CursorRow
EWB_10    STY CursorCol
          JMP Edit_Chrout_Epilog

; *****************
  Edit_Erase_To_EOL
; *****************

          LDA #' '
EETE_10   STA (ScrPtr),Y
          CPY RigMargin
          INY
          BCC EETE_10
          RTS

; *******************
  Edit_To_Left_Margin
; *******************

          LDY LefMargin
          STY CursorCol
          LDY #0
          RTS

; ****************
  Edit_Full_Screen
; ****************

          LDA #0
          STA TopMargin
          STA LefMargin
          LDA ScreenRows      ; bottom margin
          LDX #79             ; right  margin

; *****************
  EDIT_BOTTOM_RIGHT
; *****************

          STA BotMargin
          STX RigMargin
          RTS

; *************
  EDIT_TOP_LEFT
; *************

          STA TopMargin
          STX LefMargin
          RTS

CO_Shift  JMP Edit_CHROUT_Shifted

; ******
  CO_Tab
; ******

          LDY CursorCol
          CPY RigMargin
          BCS EdDC_05         ; CO_Exit
          INC CursorCol
          JSR IS_TAB
          BEQ CO_Tab
          JMP CO_Exit

          .SIZE

CO_Size   JMP Edit_Screen_25

; ****************
  Edit_Delete_Char
; ****************

          LDX LefMargin
          CPX CursorCol
EdDC_05   BCS CO_Exit        ; no delete on left margin
          DEC CursorCol
EdDC_10   LDA (ScrPtr),Y
          DEY
          STA (ScrPtr),Y
          INY
          CPY RigMargin
          INY
          BCC EdDC_10
          DEY
          LDA #' '
          STA (ScrPtr),Y
          BNE CO_Exit

          .SIZE

          .FILL $e202-* (0)

; *******************
  EDIT_CHROUT ; $e202
; *******************

          PHA            ;  3
          STA DATAX      ;  3
          TXA            ;  2
          PHA            ;  3
          TYA            ;  2
          PHA            ;  3
          JMP (SCROV)    ;  5    ; -> Edit_CHROUT_Standard
                         ; 19

; ****************************
  Edit_CHROUT_Standard ; $e20c
; ****************************

          LDA #0         ;  2
          STA CRSW       ;  3 ; input from keyboard
          LDY CursorCol  ;  3
          LDA DATAX      ;  3 ; char to display (PETSCII)
          BMI CO_Shift   ;  2
          CMP #' '       ;  2 ; printable ?
          BCS CO_Normal  ;  3 = 16 [total 35]
          CMP #CR             ; RETURN
          BEQ CO_Return
          CMP #ESC            ; ESCAPE
          BEQ CO_Escape
          LDX INSRT           ; insert mode ?
          BNE CO_Rev
          CMP #DEL            ; DELETE
          BEQ Edit_Delete_Char
          LDX QTSW            ; quote mode ?
          BNE CO_Rev
          CMP #RIGHT          ; cursor RIGHT
          BEQ CO_Right
          CMP #DOWN           ; cursor DOWN
          BEQ CO_Down
          CMP #RVS            ; REVERSE
          BEQ CO_RVS
          CMP #BELL           ; ring bell
          BEQ CO_Bell
          CMP #CTRLN          ; select text character set
          BEQ CO_ChText
          CMP #CTRLB          ; select new character set
          BEQ CO_ChNew
          CMP #CTRLO          ; set top left window corner
          BEQ CO_Top
          CMP #TAB            ; TAB
          BEQ CO_Tab
          CMP #CTRLY          ; scroll window up
          BEQ CO_ScUp
          CMP #CTRLV          ; Delete to EOL
          BEQ CO_DEOL
          CMP #CTRLU          ; delete line
          BEQ CO_DLine
          CMP #CTRLD          ; toggle screen size
          BEQ CO_Size
          CMP #HOME           ; HOME
          BEQ CO_Home
          CMP #CTRLA          ; scroll window down
          BEQ CO_ScDown
CO_Exit   JMP Edit_Chrout_Epilog

; Dispatch area for Edit_CHROUT_Standard

CO_Normal AND #$3f               ;  2 ; PETSCII -> display code
          JSR Edit_Quote_Toggle  ; 17
          JMP Edit_Display_Char  ;  3 = 22 [total 57]

CO_Right  CPY RigMargin
          INC CursorCol
          BCC CO_Exit
          JMP Edit_Chrout_Epilog_Return

CO_Down   JSR Edit_Cursor_Down
          BNE CO_Exit         ; always

CO_RVS    LDA #$80
          STA ReverseFlag
          BNE CO_Exit         ; always

CO_Bell   JSR EDIT_BEEP
          BEQ CO_Exit         ; always

CO_ChText JSR EDIT_CHARSET_TEXT
          BMI CO_Exit         ; always

CO_Return JMP CO_Screen_Return

CO_Escape JMP CO_JMP_Escape

CO_ChNew  LDA #$10
CO_Switch JSR Edit_Switch_Char_ROM
          BNE CO_Exit         ; always

CO_Rev    ORA #$80
          JMP Edit_Display_Char

CO_Top    LDX CursorRow
          STX TopMargin
          STY LefMargin
          BPL CO_Exit         ; always

CO_ScDown JMP CS_ScDown

CO_ScUp   JSR EDIT_SCROLL_UP
          JSR Power_Scroll_Up
          JSR Edit_Use_CursorRow
          BNE CO_Exit         ; always

CO_DEOL   LDA #' '
CODE_10   STA (ScrPtr),Y
          CPY RigMargin
          INY
          BCC CODE_10
          BCS CO_Exit

CO_DLine  LDA TopMargin
          PHA
          LDA CursorRow
          STA TopMargin
          JSR EDIT_SCROLL_UP
          JMP TM_Epi

CO_Home   CMP PrevChar             ; twice pressed ?
          BNE COHo_10
CoHo_05   JSR Edit_Full_Screen     ; 2nd. <HOME> resets margins
COHo_10   JSR EDIT_HOME
          JMP Edit_Chrout_Epilog

Edit_Screen_30
          LDA #7              ; maximum raster address
          LDY #29             ; 30 rows
          BNE Edit_Screen_Program
Edit_Screen_25
          LDA #9              ; maximum raster address
          LDY #24             ; 25 rows (default)
Edit_Screen_Program
          JSR Edit_Program_Rows
          JSR Edit_Full_Screen
          JMP CS_Clear

CS_Return JMP CO_Screen_Return

; ****************
  Edit_Insert_Char
; ****************

          LDY RigMargin
          LDA (ScrPtr),Y
          CMP #' '
          BNE CS_Exit       ; right most char not blank
InCh_10   DEY
          CPY CursorCol     ; clc if left from cursor
          LDA (ScrPtr),Y
          INY
          BCC InCh_20
          STA (ScrPtr),Y
          DEY
          BNE InCh_10       ; at first column
InCh_20   LDA #' '
          STA (ScrPtr),Y
          TYA
          ADC INSRT
          CMP RigMargin
          BCS CS_Exit
          INC INSRT
          BNE CS_Exit         ; always

          .SIZE

; *******************
  Edit_CHROUT_Shifted
; *******************

          AND #$7f
          CMP #$7f            ; Pi
          BEQ CS_Pi
          CMP #' '            ; printable ?
          BCS CS_Print
          CMP #CR             ; shifted RETURN
          BEQ CS_Return
          LDX QTSW            ; quote mode
          BNE CS_Rev
          CMP #DEL            ; INSERT
          BEQ Edit_Insert_Char
          LDX INSRT           ; insert mode ?
          BNE CS_Rev
          CMP #RIGHT          ; cursor LEFT
          BEQ CS_Left
          CMP #DOWN           ; cursor UP
          BEQ CS_Up
          CMP #RVS            ; REVERSE OFF
          BEQ CS_RVS
          CMP #HOME           ; CLEAR
          BEQ CS_Clear
          CMP #TAB            ; shifted TAB
          BEQ CS_Tab
          CMP #CTRLV          ; shifted Ctrl-V
          BEQ CS_Delete_BOL
          CMP #CTRLB          ; select old character set
          BEQ CS_ChOld
          CMP #CTRLY          ; scroll window down
          BEQ CS_ScDown
          CMP #CTRLO          ; set window bottom right
          BEQ CS_Bottom
          CMP #CTRLN          ; select graphics character set
          BEQ CS_Graph
          CMP #CTRLU          ; shifted Ctrl-U
          BEQ CS_Insert_Line
          CMP #CTRLD          ; switch to 26 row screen
          BEQ CS_Size
CS_Exit   JMP Edit_Chrout_Epilog

; Dispatch area for Edit_CHROUT_Shifted

CS_Size   JMP Edit_Screen_30
CS_Pi     LDA #$74
          .BYTE $2c
CS_Print  ORA #$40            ; PETSCII to display
          JMP Edit_Display_Char

CS_Rev    ORA #$c0            ; reverse upper case
          JMP Edit_Display_Char

CS_RVS    LDA #0
          STA ReverseFlag
          BEQ CS_Exit         ; always

CS_Clear  JSR EDIT_CLEAR
          BNE CS_Exit         ; always

CS_ChOld  LDA #$30
          JMP CO_Switch

CS_Bottom LDA CursorRow
          STA BotMargin
          STY RigMargin
          BPL CS_Exit       ; always

CS_Graph  JSR EDIT_CHARSET_GRAPHICS
          JMP Edit_Chrout_Epilog

CS_Left   LDY LefMargin
          CPY CursorCol
          DEC CursorCol
          BCC CS_Exit
          JMP Edit_Wrap_Back

CS_Tab    JSR IS_TAB
          LDA TABS_SET,X
          EOR BITPOS,Y        ; toggle TAB bit
          STA TABS_SET,X
          JMP Edit_Chrout_Epilog

CS_Up     LDX TopMargin
          CPX CursorRow
          BCS CS_ScDown
          DEC CursorRow
          BPL COSW_10         ; always

CS_ScDown JSR EDIT_SCROLL_DOWN
          JSR Power_Scroll_Down
COSW_10   JSR Edit_Use_CursorRow
          JMP Edit_Chrout_Epilog

; *************
  CS_Delete_BOL
; *************

          LDA #' '
          LDY LefMargin
CSDB_10   CPY CursorCol
          BCS CS_Exit
          STA (ScrPtr),Y
          INY
          BNE CSDB_10

          .SIZE

; **************
  CS_Insert_Line
; **************

          LDA TopMargin
          PHA
          LDA CursorRow
          STA TopMargin
          JSR EDIT_SCROLL_DOWN
TM_Epi    PLA
          STA TopMargin
          JSR Edit_Goto_Left_Margin
          JMP Edit_Chrout_Epilog

          .SIZE

; ****************
  Edit_Cursor_Down
; ****************

          LSR InputRow        ; invalidate InputRow
          LDX CursorRow
          CPX BotMargin
          BCC CSCD_10
          JSR EDIT_SCROLL_UP
          JMP Power_Scroll_Up
CSCD_10   INC CursorRow
          JMP Edit_Use_CursorRow

          .SIZE

; ****************
  CO_Screen_Return
; ****************

          LDY #0
          STY Power_Flag
          LDY LefMargin
          STY CursorCol
          JSR Edit_Cursor_Down

; *************
  CO_JMP_Escape
; *************

          LDA #0
          STA INSRT           ; clear insert mode
          STA ReverseFlag     ; clear reverse mode
          STA QTSW            ; clear quote mode
          JMP Edit_Chrout_Epilog

; ***********
  Edit_Scroll
; ***********

          JSR Set_Screen_SAL  ; 25
ES_10     LDA (SAL),Y         ;  5
          STA (ScrPtr),Y      ;  6
          CPY RigMargin       ;  3
          INY                 ;  2
          BCC ES_10           ;  3
          RTS
                              ; total = 25 + 80 * 19 + 2 = 1547

; ****************
  EDIT_SCROLL_DOWN
; ****************

          LDX BotMargin       ;    3
ESD_10    JSR Cursor_BOL      ;   28
          CPX TopMargin       ;    3
          BEQ ESD_30          ;    2
          DEX                 ;    2
          JSR Edit_Scroll     ; 1552
          BCS ESD_10          ;    3
ESD_30    JMP Edit_Erase_To_EOL  ; total = 1100 + 24 * 1590 = 39260

          .SIZE

; **************
  EDIT_SCROLL_UP
; **************

          LDX TopMargin
ESU_10    JSR Cursor_BOL
          CPX BotMargin
          BCS ESU_30
          INX
          JSR Edit_Scroll
          BCS ESU_10
ESU_30    JMP Edit_Erase_To_EOL

          .SIZE

          .FILL $e442-* (0)

; ********
  IRQ_MAIN
; ********

          PHA
          TXA
          PHA
          TYA
          PHA
          TSX
          LDA STACK+4,X
          AND #16
          BEQ IRQ_05
          JMP (CBINV)
IRQ_05    JMP (CINV)

; **********
  IRQ_NORMAL
; **********

          JSR Kernal_UDTIM    ; increment jiffy clock
          LDA BLNSW           ; software cursor
          BNE IRQ_20          ; branch if not visible
          DEC BLNCT           ; blink count down
          BNE IRQ_20
          LDA #20             ; reset blink count down
          STA BLNCT
          LDY CursorCol
          LSR BLNON           ; BLNON = 0 : C = old value
          LDA (ScrPtr),Y
          BCS IRQ_10
          INC BLNON           ; BLNON = 1 : reverse character
          STA GDBLN           ; save character under cursor
IRQ_10    EOR #$80
          STA (ScrPtr),Y      ; invert character
IRQ_20    JSR EDIT_KEY_SCAN
IRQ_END   PLA
          TAY
          PLA
          TAX
          PLA
          RTI

; ******
  Delete
; ******

          JSR CHRGOT
          JSR Scan_Linenumber ; start #
          JSR Find_BASIC_Line
          LDA TMPPTC
          STA RENINC
          LDA TMPPTC+1
          STA RENINC+1
          JSR CHRGOT
          CMP #'-'
          BNE DelErr
          JSR CHRGET
          JSR Scan_Linenumber ; end #
          LDA LINNUM
          ORA LINNUM+1
          BNE Del_10
          DEC LINNUM+1        ; end number = $ff00
Del_10    JSR Find_BASIC_Line
          BCC Del_20          ; -> not found
          JSR Update_Link     ; First line after DELETE range
Del_20    LDX VARTAB+1
          LDY #0              ; Y = 0
Del_30    LDA (TMPPTC),Y      ; copy upper part of program
          STA (RENINC),Y      ; into area to delete
          INY
          BNE Del_30
          INC RENINC+1
          INC TMPPTC+1
          CPX TMPPTC+1        ; reached VARTAB ?
          BCS Del_30
          LDY RENINC
          LDA RENINC+1
          JMP Renu_90         ; set VARTAB, reset BASIC
DelErr    JMP Jump_To_Illegal_Quantity
          .SIZE

; ***************
  Get_Record_Size
; ***************

          LDY #0
          STY STATUS
          JSR Send_Filename
          JSR Kernal_Read_DS
          LDA #$6d
          STA SA
          LDA DOS_Status
          CMP #'5'
          BNE GRS_90
          DEC DOS_RL
          LDA #$9d
          JSR CHROUT
          JSR CHROUT
          LDA DOS_RL
          JSR Print_Hex_Byte
          LDA DOS_RL
          CMP #2
          BCC GRS_90
          LDY FNLEN
          DEY
          STA (FNADR),Y       ; try next record length
          JMP Get_Record_Size
GRS_90    RTS

; ***********
  Mon_Message
; ***********

          .BYTE "\r   PC  IRQ  SR AC XR YR SP RB WB SV-BDIZC"

; ******
  IS_TAB
; ******

          LDA CursorCol
          AND #7
          TAY                 ; bit position
          LDA CursorCol
          LSR A
          LSR A
          LSR A               ; Column / 8
          TAX                 ; word index
          LDA BITPOS,Y
          AND TABS_SET,X
          RTS

; ******
  BITPOS
; ******

          .BYTE $80,$40,$20,$10,$08,$04,$02,$01

; ********
  Mon_Fill
; ********

          LDX #BPTR           ; start address
          JSR Read_Hex_Word
          BCC MoFi_Err
          LDX #MEMUSS         ; end   address
          JSR Read_Hex_Word
          BCC MoFi_Err
          JSR  Read_Hex       ; fill byte
          BCC MoFi_Err
          TAX
          LDY #0
MoFi_10   LDA MEMUSS
          CMP BPTR            ; set or clear carry
          LDA MEMUSS+1
          SBC BPTR+1
          BCC MoFi_End        ; BPTR > MEMUSS ?
          TXA
          JSR Bank_Store
          JSR Inc_BPTR
          JMP MoFi_10
MoFi_End  JMP Mon_Main
MoFi_Err  JMP Mon_Error

          .SIZE


; ****************
  Open_Disk_Buffer
; ****************

          JSR Preset_U1
          JSR Kernal_CHRIN
          STA DOS_Command_Buffer+1
          JSR Hex_To_STAL
          JSR Kernal_CHRIN    ; skip blank
          LDX #5
ODB_20    JSR Mon_CHRIN
          STA DOS_Command_Buffer,X
          INX
          CPX #40
          BCS ODB_30
          CMP #' '
          BCS ODB_20
ODB_30    JSR DOS_SETNAM
          JSR Wedge_Prepare   ; set FA, clear status
          STA Dis_Line        ; Dis_Line = 0
          JSR LISTEN          ; open fa,9,"#"
          LDA #$f9            ; sa = 9
          JSR SECOND
          LDA #'#'            ; open buffer
          JSR CIOUT
          JMP UNLSN


; ********
  Mon_Disk
; ********

;         U1 1000 0 18 01 - memory,drive,track,sector

          JSR Open_Disk_Buffer
          LDA DOS_Command_Buffer+1
          CMP #'2'
          BEQ Mon_Output_Block
          JSR Mon_Disk_Comm
          JSR TALK
          LDA #$69
          STA SA
          JSR TKSA
          LDY #0
MIB_30    JSR ACPTR
          STA (STAL),Y
          INY
          BNE MIB_30
          JSR UNTLK
          JSR Close_Disk_File
          JMP DiMe_10         ; display loaded block

; ****************
  Mon_Output_Block
; ****************

;         U2 1000 0 18 01 - memory,drive,track,sector

          JSR Reset_BP
          JSR LISTEN
          LDA #$69
          STA SA
          JSR SECOND
          LDY #0
MOB_10    LDA (STAL),Y
          JSR CIOUT
          INY
          BNE MOB_10
          JSR UNLSN
          JSR Mon_Disk_Comm
          JSR Close_Disk_File
          JMP DiMe_10         ; display output block

          .FILL $e606-* (0)

; *********
  Edit_Init
; *********

          LDA #$7f
          STA VIA_IER         ; disable all interrupts
          LDX #$6d
          LDA #0
          STA PrevChar        ; clear # of HOME key pressed
EdIn_10   STA JIFFY_CLOCK,X   ; clear all kernal variables
          DEX
          BPL EdIn_10
          STX Key_Flags       ; $FF = Clear all flags
          LDA BSOS_Bank_Init
          STA Default_Bank
          LDA #<IRQ_NORMAL    ; set default IRQ vector
          STA CINV
          LDA #>IRQ_NORMAL
          STA CINV+1
          LDA #9
          STA XMAX            ; size of keyboard bufferX
          LDA #3
          STA DFLTO           ; standard output channel
          LDA #15
          STA PIA1_Port_A     ; Keyboard row select
          ASL A
          STA VIA_Port_B
          STA VIA_DDR_B
          STX PIA2_Port_B
          STX VIA_Timer_1_Hi  ; Timer 1 latch hi = $ff
          LDA #$3d
          STA PIA1_Cont_B
          BIT PIA1_Port_B     ; Keyboard row
          LDA #$3c
          STA PIA2_Cont_A
          STA PIA2_Cont_B
          STA PIA1_Cont_A
          STX PIA2_Port_B
          LDA #14
          STA BLNCT
          STA BLNSW
          STA DELAY
          STA KOUNT
          STA VIA_IER         ; enable CA1, SR, CB2 interrupt
          LDA #24
          STA ScreenRows
          JSR Edit_Full_Screen
          LDX #12
          LDA #0
EdIn_20   STA TABS_SET,X
          DEX
          BPL EdIn_20
          LDA #<Edit_CHRIN_Standard
          LDX #>Edit_CHRIN_Standard
          STA SCRIV
          STX SCRIV+1
          LDA #<Edit_CHROUT_Standard
          LDX #>Edit_CHROUT_Standard
          STA SCROV
          STX SCROV+1
          LDA #16
          STA CHIME
          JSR Double_Beep

; ***********
  Double_Beep
; ***********

          JSR EDIT_BEEP

; *********
  EDIT_BEEP
; *********

          LDY CHIME
          BEQ BEEP_Ret
          LDA #16             ; shift out - rate controlled by timer 2
          STA VIA_ACR         ; free running mode
          LDA #15
          STA VIA_Shift       ; set shift pattern 0000 1111
          LDX #7
BEEP_10   LDA SOUND_TAB-1,X
          STA VIA_Timer_2_Lo  ; set sustain time
          LDA CHIME
BEEP_20   DEY
          BNE BEEP_20           ; inner wait loop
          SEC
          SBC #1
          BNE BEEP_20           ; outer wait loop
          DEX
          BNE BEEP_10           ; next note
          STX VIA_Shift       ; x=0 clear shift register
          STX VIA_ACR         ; x=0 clear access control register
BEEP_Ret  RTS

; **************
  Set_Screen_SAL
; **************

          TXA
          PHA
          AND #15
          TAX
          LDA Line_Addr_Lo,X
          STA SAL
          PLA
          TAX
          LDA Line_Addr_Hi,X
          STA SAL+1
          RTS

; **********
  Cursor_BOL
; **********

; Input:  X       = cursor row (0 - 24)
; Output: ScrPtr  = screen address of row X
;         Y       = left margin

          LDY LefMargin

; *************
  Update_ScrPtr
; *************

          TXA
          PHA
          AND #15             ; Line lo repeats after 16 lines
          TAX
          LDA Line_Addr_Lo,X
          STA ScrPtr
          PLA
          TAX
          LDA Line_Addr_Hi,X
          STA ScrPtr+1
          RTS

; **********
  RUN_String
; **********

;               dL"*<CR>rU<CR>
          .BYTE $44,$cc,$22,$2a,$0d,$52,$d5,$0d

; ********
  CRT_TEXT
; ********

;              Value  6845 CRT Register
;         ---------------------------------------------------
          .BYTE  58           ;  0: Horizontal Total
          .BYTE  40           ;  1: Horizontal Displayed
          .BYTE  44           ;  2: Horizontal Sync Position
          .BYTE   8           ;  3: Horizontal and Vertical Sync Widths
          .BYTE  32           ;  4: Vertical Total
          .BYTE   9           ;  5: Vertical Total Adjust
          .BYTE  25           ;  6: Vertical Displayed
          .BYTE  30           ;  7: Vertical Sync position
          .BYTE   0           ;  8: Interlace and Skew
          .BYTE   9           ;  9: Maximum Raster Address
          .BYTE   0           ; 10: Cursor Start Raster
          .BYTE   0           ; 11: Cursor End Raster
          .BYTE $10           ; 12: Display Start Address (High)
          .BYTE $00           ; 13: Display Start Address (Low)
          .BYTE $00           ; 14: Cursor Address (High)
          .BYTE $00           ; 15: Cursor Address (Low)
          .BYTE $00           ; 16: Light Pen Address (High)
          .BYTE $00           ; 17: Light Pen Address (Low)


; ************
  CRT_GRAPHICS
; ************

;              Value  6845 CRT Register
;         ---------------------------------------------------
          .BYTE  58           ;  0: Horizontal Total
          .BYTE  40           ;  1: Horizontal Displayed
          .BYTE  44           ;  2: Horizontal Sync Position
          .BYTE   8           ;  3: Horizontal and Vertical Sync Widths
          .BYTE  41           ;  4: Vertical Total                  !!!
          .BYTE   3           ;  5: Vertical Total Adjust           !!!
          .BYTE  25           ;  6: Vertical Displayed
          .BYTE  34           ;  7: Vertical Sync position          !!!
          .BYTE   0           ;  8: Interlace and Skew
          .BYTE   7           ;  9: Maximum Raster Address          !!!


; ***
  OLD
; ***
          LDA #1
          TAY
          STA (TXTTAB),Y      ; non zero link
          DEY
          STA (TXTTAB),Y
          JSR Rechain         ; restore all links
          CLC
          LDA INDEXA
          ADC #2
          TAY
          LDA INDEXA+1
          ADC #0
          JMP Renu_90         ; set VARTAB and reset BASIC

; **************
  Check_Mon_Line
; **************

          TXA
          PHA
          JSR Cursor_BOL
          LDA (ScrPtr),Y
          CMP #'.'            ; disassemble listing
          BEQ CML_10
          CMP #':'            ; memory dump
          BNE CML_20
CML_10    STA Mon_A           ; remember mode
          INY
          STY CursorCol
          JSR Hex_To_STAL
          CLC
          BCC CML_30
CML_20    SEC
CML_30    PLA
          TAX
          RTS

; **************
  Check_Mon_Down
; **************

          LDX TopMargin
CMDO_10   CPX BotMargin
          BCS CMDO_Ret        ; not found: C=1
          INX
          JSR Check_Mon_Line
          BCS CMDO_10
          JSR Sub_STAL_16
          CLC                 ; found: C=0
CMDO_Ret  RTS

          .FILL $e74e-* (0)

; ****************
  SOUND_TAB ; e74e
; ****************

          .BYTE $0e,$1e,$3e,$7e,$3e,$1e,$0e

; ********************
  Line_Addr_Lo ; $e755
; ********************

          .BYTE $00,$50,$a0,$f0,$40,$90,$e0,$30
          .BYTE $80,$d0,$20,$70,$c0,$10,$60,$b0
          .BYTE $00,$50,$a0,$f0,$40,$90,$e0,$30
          .BYTE $80

; ********************
  Line_Addr_Hi ; $e76e
; ********************

          .BYTE $80,$80,$80,$80,$81,$81,$81,$82 ;  0 -  7
          .BYTE $82,$82,$83,$83,$83,$84,$84,$84 ;  8 - 15
          .BYTE $85,$85,$85,$85,$86,$86,$86,$87 ; 16 - 23
          .BYTE $87,$87,$88,$88,$88,$89,$89,$89 ; 24 - 31

B_P_0     .BYTE "B-P 9 0\r"
U1        .BYTE "U1:9 "

; ********
  Reset_BP
; ********

          JSR DOS_Open_Comm_Write
          LDY #0
RBP_30    LDA B_P_0,Y
          JSR CIOUT
          INY
          CPY #?B_P_0
          BCC RBP_30
          JMP UNLSN

; *********
  Preset_U1
; *********

          LDX #4
PU1_10    LDA U1,X
          STA DOS_Command_Buffer,X
          DEX
          BPL PU1_10
          RTS

; *************
  Mon_Disk_Comm
; *************

          JSR DOS_Open_Comm_Write
          LDX #0
MDC_10    LDA DOS_Command_Buffer,X
          INX
          JSR CIOUT
          CMP #' '
          BCS MDC_10
          JMP UNLSN

          .FILL $e800-* (0)

          .BYTE "HALL OF FAME:"
          .BYTE "CHUCK PEDDLE - "
          .BYTE "BILL MENSCH - "
          .BYTE "JACK TRAMIEL - "
          .BYTE "IRA VELINSKY - "
          .BYTE "JOHN FEAGANS - "
          .BYTE "BILL GATES - "
          .BYTE "JIM BUTTERFIELD - "
          .BYTE "BRAD TEMPLETON - "
          .BYTE "JIM CONELLEY - "
          .BYTE "NILS EILERS - "
          .BYTE "VICE TEAM - "


          .FILL $e924-* (0)

; *************
  EDIT_KEY_SCAN
; *************

; Initialize

          LDA PIA1_Port_A     ; Keyboard row select
          AND #%11110000      ; Select row 0
          STA PIA1_Port_A     ; Keyboard row select
          LDA Key_Flags
          ORA #%11000000      ; 7 no <shift> and 6 no <ctrl>
          STA Key_Flags
          LDA #$ff
          STA Key_Index       ; invalidate Key_Index
          STA SFDX            ; invalidate SFDX
          LDX #$4f            ; check key 79 -> 0

; Load next keyboard row int oaccumulator

ScKbd_02  LDA PIA1_Port_B     ; Keyboard row
          CMP PIA1_Port_B     ; Keyboard row
          BNE ScKbd_02        ; repeat until no bounce

; Rotate accumulator for all 8 keys of this row

          LDY #8              ; Test the 8 keys of the row
ScKbd_04  LSR A               ; next key -> carry
          BCS ScKbd_10        ; 1 -> not pressed
          PHA                 ; Save scanned row

; Test for right or left shift key

          LDA #%01111111      ; mask for <shift> pressed
          CPX #$19            ; Right Shift ?
          BEQ ScKbd_06        ; -> pressed
          CPX #$1f            ; Left Shift ?
          BEQ ScKbd_06        ; -> pressed

; Test for control key (RVS on older keyboards)

          LDA #%10111111      ; mask for <ctrl> pressed
          CPX #15             ; <RVS = CTRL> ?
          BEQ ScKbd_06        ; -> pressed

; normal key, save key index

          STX Key_Index
          BNE ScKbd_08        ; branch always

; flag shift or control in Key_Flags

ScKbd_06  AND Key_Flags
          STA Key_Flags       ; save shift and control status

; continue with next index

ScKbd_08  PLA                 ; restore row
ScKbd_10  DEX                 ; next key index
          BMI ScKbd_12        ; finished

; next key in this row

          DEY                 ; next column
          BNE ScKbd_04

; row scan finished -> next row

          INC PIA1_Port_A     ; next keyboard row
          BNE ScKbd_02        ; Branch always

; keyboard scan finished - check if a keypress occured

ScKbd_12  LDX Key_Index       ; any key ?
          BPL ScKbd_13        ; branch on key press
          STX LSTX            ; invalidate last key pressed
ScKbd_22  RTS

; is it the same key index as in the last scan ?

ScKbd_13  CPX LSTX            ; still holding the same key ?
          BNE ScKbd_16        ; other key
          LDY DELAY
          BEQ ScKbd_14        ; branch if delay expired
          DEC DELAY           ; else decrement repeat delay counter
          BNE ScKbd_22        ; branch if delay not expired
ScKbd_14  DEC KOUNT           ; decrement repeat speed counter
          BNE ScKbd_22        ; branch if repeat speed count not expired
          LDY #4              ; set for 4/60ths of a second
          CPX #$0b            ; index for cursor <- ->
          BNE ScKbd_15        ; normaö repeat speed
          LDY #2              ; cursor left right repeat faster
ScKbd_15  STY KOUNT           ; set repeat speed counter
          BNE ScKbd_18        ; branch always

; new key press - reset delay

ScKbd_16  STX LSTX            ; save key index
          LDA #21
          STA DELAY           ; set repeat delay count
ScKbd_18  JSR Lookup_Keycode
          CPX #15
          BEQ ScKbd_30        ; <CONTROL> doesn't go into buffer
          LDX CharsInBuffer
          CPX XMAX
          BCS ScKbd_26        ; buffer full

; add key to keyboard buffer

ScKbd_24  STA KEYD,X
          INC CharsInBuffer   ; put key into buffer

; check for STOP key

ScKbd_26  LDY #$ff            ; Clear STOP flag
          CMP #3              ; <STOP>
          BNE ScKbd_28
          LDY #$ef            ; Set STOP flag
ScKbd_28  STY Stop_Flag
ScKbd_30  STA SFDX
          RTS

; **************
  Lookup_Keycode
; **************

          LDA KEYBOARD_CONTROL,X
          BIT Key_Flags
          BVS LoKe_20         ; no control
          BMI LoKe_10
          ORA #$80            ; shift control
LoKe_10   RTS
LoKe_20   BMI LoKe_30         ; no shift
          LDA KEYBOARD_SHIFTED,X
          RTS
LoKe_30   LDA KEYBOARD_NORMAL,X
          RTS

; ********************
  Edit_Switch_Char_ROM
; ********************

; Input:   A = $10 (new charset)   $30 (old charset)

           LDY #12
           STY CRT_Address
           STA CRT_Value
           RTS


; **************
  EDIT_RESET_CRT
; **************

          LDY #17
          .BYTE $2c           ; skip next instruction

; *****************
  EDIT_CHARSET_TEXT
; *****************

          LDY #9
          LDA #14
          STA VIA_PCR
          LDA #<CRT_TEXT
          LDX #>CRT_TEXT
          JMP EDIT_SET_CRT

; *********************
  EDIT_CHARSET_GRAPHICS
; *********************

          LDY #9
          LDA #12
          STA VIA_PCR
          LDA #<CRT_GRAPHICS
          LDX #>CRT_GRAPHICS
          JMP EDIT_SET_CRT

; *****************
  Read_Power_String
; *****************

          LDA #$80            ; activate power scrolling
          STA Power_Flag
          JSR Read_String
          ASL Power_Flag      ; deactivate power scrolling
          RTS

; ****************
  Check_Linenumber
; ****************

          TXA                 ; X = Row
          PHA
          PHA
          AND #15
          TAX
          CLC
          LDA Line_Addr_Lo,X
          ADC LefMargin
          STA TXTPTR
          PLA
          TAX
          LDA Line_Addr_Hi,X
          ADC #0
          STA TXTPTR+1
          JSR CHRGOT
          BCS ChLi_Ret        ; no  number
          JSR Scan_Linenumber
          CLC                 ; has number
ChLi_Ret  PLA
          TAX
          RTS

; ******************
  Check_Line_Upwards
; ******************

          LDX BotMargin
CLU_10    CPX TopMargin
          BEQ CLU_Ret         ; carry set -> no number
          DEX
          JSR Check_Linenumber
          BCS CLU_10
CLU_Ret   RTS

; ********************
  Check_Line_Downwards
; ********************

          LDX TopMargin
CLD_10    CPX BotMargin
          BEQ CLD_Ret         ; carry set -> no number
          INX
          JSR Check_Linenumber
          BCS CLD_10
CLD_Ret   RTS

; ***************
  Power_Scroll_Up
; ***************

          LDA Power_Flag      ; active ?
          BEQ PSU_Ret         ; -> neither BASIC nor monitor
          LDA CursorRow       ; save row
          PHA
          LDA CursorCol
          PHA                 ; save col
          LDX BotMargin
          DEX
          JSR Cursor_BOL      ; one row above bottom line
          LDA #' '            ; check, if this line is blank
PSU_10    CMP (ScrPtr),Y
          BNE PSU_30          ; don't list on non empty line
          INY
          CPY RigMargin
          BCC PSU_10
          STX CursorRow
          BIT Power_Flag
          BMI PSU_15          ; -> BASIC MODE

          JSR Check_Mon_Up
          BCS PSU_30
          LDX BotMargin
          DEX
          DEX
          STX CursorRow
          JSR Mon_Auto
          LDA #0
          STA QTSW
          LDA #$40
          STA Power_Flag      ; keep it active
          BNE PSU_30          ; always

PSU_15    JSR Check_Line_Upwards
          BCS PSU_30
          INC LINNUM
          BNE PSU_20
          INC LINNUM+1
PSU_20    JSR Find_Power_Line
          JSR List_BASIC_Line
PSU_30    PLA
          STA CursorCol
          PLA
          STA CursorRow       ; restore row
          JMP Edit_Use_CursorRow
PSU_Ret   RTS

; *****************
  Power_Scroll_Down
; *****************

          LDA Power_Flag
          BEQ PSU_Ret         ; -> neither BASIC nor monitor
          LDA CursorRow       ; save row
          PHA
          LDA CursorCol
          PHA                 ; save col
          BIT Power_Flag
          BMI PSD_10          ;  -> BASIC MODE

          JSR Check_Mon_Down
          BCS PSU_30
          JSR EDIT_HOME
          LDA #':'
          JSR EDIT_CHROUT
          JSR Dis_16
          LDA #$40
          STA Power_Flag
          LDA #0
          STA QTSW
          BEQ PSU_30

PSD_10    JSR Check_Line_Downwards
          BCS PSU_30
          JSR Find_Power_Line
          LDA TMPPTC
          CMP TXTTAB
          BNE PSD_20
          LDA TMPPTC+1
          CMP TXTTAB+1
          BEQ PSU_30
PSD_20    LDA TMPPTB
          STA TMPPTC
          LDA TMPPTB+1
          STA TMPPTC+1
          JSR EDIT_HOME
          JSR List_BASIC_Line
          LDX CursorRow
          CPX TopMargin
          BEQ PSU_30
          LDY CursorCol       ; Basic line was oversize
          LDA #' '            ; erase to EOL and scroll again
PSD_30    STA (ScrPtr),Y
          CPY RigMargin
          INY
          BCC PSD_30
          LDA TopMargin
          PHA
          INX
          STX TopMargin
          JSR EDIT_SCROLL_DOWN
          PLA
          STA TopMargin
          LDY #1
          LDA (TMPPTC),Y      ; link hi
          TAX
          DEY
          LDA (TMPPTC),Y      ; link lo
          STA TMPPTC
          STX TMPPTC+1
          INC CursorRow
          JSR List_BASIC_Line
          JMP PSU_30          ; always

          .SIZE

; ***************
  List_BASIC_Line
; ***************

          JSR Edit_Goto_Left_Margin
          LDY #1
          LDA (TMPPTC),Y      ; check link for valid line
          BEQ LBL_Ret
          INY
          LDA (TMPPTC),Y      ; line # lo
          TAX
          INY
          LDA (TMPPTC),Y      ; line # hi
          JSR List_Line       ; returns A=0
          STA QTSW
LBL_Ret   RTS

; ***************
  Find_Power_Line
; ***************

          LDA TXTTAB
          LDX TXTTAB+1
          STA TMPPTB
          STX TMPPTB+1
FPL_10    STA TMPPTC
          STX TMPPTC+1
          LDY #1
          LDA (TMPPTC),Y      ; link hi
          BEQ FPL_40
          INY                 ; Y = 2
          LDA (TMPPTC),Y      ; line # lo
          CMP LINNUM
          INY                 ; Y = 3
          LDA (TMPPTC),Y      ; line # hi
          SBC LINNUM+1
          BCS FPL_40          ; >= LINNUM
          LDA TMPPTC
          STA TMPPTB
          LDX TMPPTC+1        ; last ptr
          STX TMPPTB+1
          DEY                 ; Y = 2
          DEY                 ; Y = 1
          LDA (TMPPTC),Y      ; link hi
          TAX
          DEY                 ; Y = 0
          LDA (TMPPTC),Y      ; link lo
          BCC FPL_10          ; branch always
FPL_40    RTS

; ***************
  KEYBOARD_NORMAL
; ***************

; The keyboard table has 80 ($50) entries scanned backwards
; The map is organized in 10 rows x 8 columns
; Val = Scancode assigned to this key
; X   = Index of this key
; R   = Physical row on keyboard (1-5)
; C   = Physical column on keyboard (1-16 and k1-k3 for keypad)
; Key = Description

;               Val     X  R  C Key
;         --------------------------------
          .PET $16  ; 00  -  - Ctrl V
          .PET $00  ; 01  -  -
          .PET $be  ; 02  1 12 SZ  ?
#if BSOS_KBD
          .PET $14  ; 03  1 16 DEL INST
#else
          .PET $13  ; 03  1 16 HOME CLR
#endif
          .PET '9'  ; 04  1 10 9   )
          .PET '6'  ; 05  1  7 6   &
          .PET '3'  ; 06  1  4 3   Paragraph
          .PET '<'  ; 07  1  1 <   >

          .PET '1'  ; 08  3 k1 1
          .PET '-'  ; 09  4 12 -   _
          .PET $15  ; 0a  -  - Ctrl U
#if BSOS_KBD
          .PET $1d  ; 0b  4 15 RIGHT LEFT
#else
          .PET $14  ; 0b  4 15 DEL INST
#endif
          .PET 'm'  ; 0c  4  9 m
          .PET ' '  ; 0d  5  1 SPACE
          .PET 'x'  ; 0e  4  4 x
          .PET $00  ; 0f  4  1 CTRL (used by index)

          .PET '2'  ; 10  3 k2 2
#if BSOS_KBD
          .PET $11  ; 11  4 14 DOWN UP
#else
          .PET $03  ; 11  4 14 STOP RUN
#endif
          .PET $0f  ; 12  -  - Ctrl O
          .PET '0'  ; 13  4 k1 0
          .PET ','  ; 14  4 10 ,
          .PET 'n'  ; 15  4  8 n
          .PET 'v'  ; 16  4  6 v
          .PET 'y'  ; 17  4  3 y

          .PET '3'  ; 18  3 k3 3
          .PET $00  ; 19  4 13 Right SHIFT (used by index)
          .PET $19  ; 1a  -  - Ctrl Y
          .PET '.'  ; 1b  4 11 .
          .PET '.'  ; 1c  4 k2 .
          .PET 'b'  ; 1d  4  7 b
          .PET 'c'  ; 1e  4  5 c
          .PET $00  ; 1f  4  2 Left SHIFT (used by index)

          .PET '4'  ; 20  2 k1 4
          .PET $bd  ; 21  2 12 u umlaut
          .PET 'o'  ; 22  2 10 o
          .PET '['  ; 23  2 14 [   ^
          .PET 'u'  ; 24  2  8 u
          .PET 't'  ; 25  2  6 t
          .PET 'e'  ; 26  2  4 e
          .PET 'q'  ; 27  2  2 q

          .PET ']'  ; 28  2 15 ]   \
          .PET 'p'  ; 29  2 11 p
          .PET 'i'  ; 2a  2  9 i
          .PET '+'  ; 2b  2 13 +
          .PET 'z'  ; 2c  2  7 z
          .PET 'r'  ; 2d  2  5 r
          .PET 'w'  ; 2e  2  3 w
          .PET $09  ; 2f  2  1 TAB

          .PET '6'  ; 30  2 k3 6
          .PET $bb  ; 31  3 13 a umlaut
          .PET 'l'  ; 32  3 11 l
          .PET $0d  ; 33  3 15 RETURN
          .PET 'j'  ; 34  3  9 j
          .PET 'g'  ; 35  3  7 g
          .PET 'd'  ; 36  3  5 d
          .PET 'a'  ; 37  3  3 a

          .PET '5'  ; 38  2 k2 5
          .PET $bc  ; 39  3 12 o umlaut
          .PET 'k'  ; 3a  3 10 k
          .PET '#'  ; 3b  3 14 #
          .PET 'h'  ; 3c  3  8 h
          .PET 'f'  ; 3d  3  6 f
          .PET 's'  ; 3e  3  4 s
          .PET $1b  ; 3f  3  1 ESC

          .PET '9'  ; 40  1 k3 9
          .PET $00  ; 41  -  -
#if BSOS_KBD
          .PET $13  ; 42  1 16 HOME
#else
          .PET $11  ; 42  1 16 DOWN UP
#endif
          .PET '7'  ; 43  1 k1 7
          .PET '0'  ; 44  1 11 0
          .PET '7'  ; 45  1  8 7
          .PET '4'  ; 46  1  5 4
          .PET '1'  ; 47  1  2 1

          .PET $00  ; 48  -  -
          .PET $0e  ; 49  -  - Ctrl N
#if BSOS_KBD
          .PET $03  ; 4a  1 15 STOP (RUN)
#else
          .PET $1d  ; 4a  1 15 RIGHT LEFT
#endif
          .PET '8'  ; 4b  1 k2 Keypad 8
          .PET $af  ; 4c  1 13 ACUTE (GRAVE)
          .PET '8'  ; 4d  1  9
          .PET '5'  ; 4e  1  6
          .PET '2'  ; 4f  1  3

; ****************
  KEYBOARD_SHIFTED
; ****************

          .PET $96  ; 00    Shift Ctrl V
          .PET $00  ; 01
          .PET '?'  ; 02
#if BSOS_KBD
          .PET $94  ; 03    INST
#else
          .PET $93  ; 03    CLR
#endif
          .PET ')'  ; 04    )
          .PET '&'  ; 05    &
          .PET '@'  ; 06    Paragraph
          .PET '>'  ; 07    >

          .PET $a2  ; 08    Graph a2  KP 1
          .PET '_'  ; 09    UNDERLINE
          .PET $95  ; 0a    Shift Ctrl U
#if BSOS_KBD
          .PET $9d  ; 0b    LEFT
#else
          .PET $94  ; 0b    INST
#endif
          .PET 'M'  ; 0c    M
          .PET $a0  ; 0d    SHIFT SPACE
          .PET 'X'  ; 0e    X
          .PET $00  ; 0f    CTRL (used by index)

          .PET $a3  ; 10    Graph a3
#if BSOS_KBD
          .PET $91  ; 11    Cursor UP
#else
          .PET $93  ; 11    RUN
#endif
          .PET $8f  ; 12    Shift Ctrl O
          .PET $a1  ; 13    Graph a1  KP 0
          .PET ';'  ; 14    ;
          .PET 'N'  ; 15    N
          .PET 'V'  ; 16    V
          .PET 'Y'  ; 17    Y

          .PET $a4  ; 18    Graph a4   KP 3
          .PET $00  ; 19    Right SHIFT (used by index)
          .PET $99  ; 1a    Shift Ctrl Y
          .PET $ff  ; 1b    KP . Pi
          .PET ':'  ; 1c    :
          .PET 'B'  ; 1d    B
          .PET 'C'  ; 1e    C
          .PET $00  ; 1f    Left SHIFT (used by index)

          .PET $a5  ; 20    Graph a5   KP 4
          .PET $f3  ; 21    U umlaut
          .PET 'O'  ; 22    O
          .PET '^'  ; 23    Circumflex
          .PET 'U'  ; 24    U
          .PET 'T'  ; 25    T
          .PET 'E'  ; 26    E
          .PET 'Q'  ; 27    Q

          .PET $5c  ; 28    Backslash
          .PET 'P'  ; 29    P
          .PET 'I'  ; 2a    I
          .PET '*'  ; 2b    *
          .PET 'Z'  ; 2c    Z
          .PET 'R'  ; 2d    R
          .PET 'W'  ; 2e    W
          .PET $89  ; 2f    Shift TAB

          .PET $a7  ; 30    Graph a7   KP 6
          .PET $f1  ; 31    A umlaut
          .PET 'L'  ; 32    L
          .PET $8d  ; 33    SHIFT RETURN
          .PET 'J'  ; 34    J
          .PET 'G'  ; 35    G
          .PET 'D'  ; 36    D
          .PET 'A'  ; 37    A

          .PET $a6  ; 38    Graph a6   KP 5
          .PET $f2  ; 39    O umlaut
          .PET 'K'  ; 3a    K
          .PET $27  ; 3b    '
          .PET 'H'  ; 3c    H
          .PET 'F'  ; 3d    F
          .PET 'S'  ; 3e    S
          .PET $1b  ; 3f    ESC

          .PET $aa  ; 40    Graph aa   KP 9
          .PET $00  ; 41
#if BSOS_KBD
          .PET $93  ; 42    CLR
#else
          .PET $91  ; 42    CURSOR UP
#endif
          .PET $a8  ; 43    Graph a8   KP 7
          .PET '='  ; 44    =
          .PET '/'  ; 45    /
          .PET '$'  ; 46    $
          .PET '!'  ; 47    !

          .PET $00  ; 48
          .PET $8e  ; 49    Shift Ctrl N
#if BSOS_KBD
          .PET $83  ; 4a    RUN
#else
          .PET $9d  ; 4a    CURSOR LEFT
#endif
          .PET $a9  ; 4b    Graph a9   KP 8
          .PET $c0  ; 4c    GRAVE
          .PET '('  ; 4d    (
          .PET '%'  ; 4e    %
          .PET '"'  ; 4f    "

          .PET 0

; ****************
  KEYBOARD_CONTROL
; ****************

          .BYTE $00           ;                                  10h  -------
          .BYTE $00           ; SHIFT                            10g  LEFT SHIFT
          .BYTE $00           ; ?                                10f  SZ ?
          .BYTE $00           ; INS                              10e  DEL INST
          .BYTE $dd           ; }                                10d  9 )
          .BYTE $00           ; &                                10c  6 &
          .BYTE $00           ; `                                10b  3 Paragraph
          .BYTE $00           ; >                                10a  < >

          .BYTE $00           ; Graph a2                         9h  KP 1
          .BYTE $00           ; UNDERLINE                        9g  - _
          .BYTE $00           ; Shift Ctrl U                     9f  -------
          .BYTE $00           ; LEFT                             9e  CURSOR <->
          .BYTE $00           ; M                                9d  M
          .BYTE $00           ; SHIFT SPC                        9c  SPACE
          .BYTE $18           ; X                                9b  X
          .BYTE $00           ; Control                          9a  CTRL (by index)

          .BYTE $00           ; Graph a3                         8h  KP 2
          .BYTE $00           ; 8g  CURSOR V^
          .BYTE $00           ; Shift Ctrl O                     8f  -------
          .BYTE $00           ; Graph a1                         8e  KP 0
          .BYTE $00           ; ;                                8d  ,
          .BYTE $0e           ; N                                8c  N
          .BYTE $16           ; V                                8b  V
          .BYTE $19           ; Y                                8a  Y

          .BYTE $00           ; Graph a4                         7h  KP 3
          .BYTE $00           ; SHIFT                            7g  RIGHT SHIFT
          .BYTE $00           ; Shift Ctrl Y                     7f  -------
          .BYTE $de           ; ~                                7e  KP . Pi
          .BYTE $00           ; :                                7d  . :
          .BYTE $02           ; B                                7c  B
          .BYTE $03           ; C                                7b  C
          .BYTE $00           ; SHIFT                            7a  LEFT SHIFT

          .BYTE $00           ; Graph a5                         6h  KP 4
          .BYTE $00           ;                                  6g  UE
          .BYTE $0f           ; O                                6f  O
          .BYTE $00           ; ARROW UP                         6e  Arrow up
          .BYTE $15           ; U                                6d  U
          .BYTE $14           ; T                                6c  T
          .BYTE $05           ; E                                6b  E
          .BYTE $11           ; Q                                6a  Q

          .BYTE $00           ; 5h  ] Backslash
          .BYTE $10           ; P                                5g  P
          .BYTE $09           ; I                                5f  I
          .BYTE $00           ; *                                5e  + *
          .BYTE $1a           ; Z                                5d  Z
          .BYTE $12           ; R                                5c  R
          .BYTE $17           ; W                                5b  W
          .BYTE $00           ; SET TAB                          5a  TAB

          .BYTE $00           ; Graph a7                         4h  KP 6
          .BYTE $00           ;                                  4g  AE
          .BYTE $0c           ; L                                4f  L
          .BYTE $00           ; SHIFT RET                        4e  RETURN
          .BYTE $0a           ; J                                4d  J
          .BYTE $07           ; G                                4c  G
          .BYTE $04           ; D                                4b  D
          .BYTE $01           ; A                                4a  A

          .BYTE $00           ; Graph a6                         3h  KP 5
          .BYTE $00           ;                                  3g  OE
          .BYTE $0b           ; K                                3f  K
          .BYTE $00           ; '                                3e  # '
          .BYTE $08           ; H                                3d  H
          .BYTE $06           ; F                                3c  F
          .BYTE $13           ; S                                3b  S
          .BYTE $1b           ; ESC                              3a  ESC

          .BYTE $00           ; Graph aa                         2h  KP 9
          .BYTE $00           ; SHIFT                            2g  -------
          .BYTE $00           ; CLR                              2f  HOME CLR
          .BYTE $00           ; Graph a8                         2e  KP 7
          .BYTE $00           ; =                                2d  0 =
          .BYTE $dc           ; |                                2c  7 /
          .BYTE $00           ; $                                2b  4 $
          .BYTE $00           ; !                                2a  1 !

          .BYTE $00           ; SHIFT                            1h  -------
          .BYTE $00           ; Shift Ctrl N                     1g  -------
          .BYTE $00           ; 1f  [ \
          .BYTE $00           ; Graph a9                         1e  KP 8
          .BYTE $00           ;                                  1d  ACUTE GRAVE
          .BYTE $db           ; {                                1c  8 (
          .BYTE $00           ; %                                1b  5 %
          .BYTE $00           ; "                                1a  2 "
          .BYTE $00           ; SHIFT

; **********
  Find_Entry
; **********

          STX LINNUM          ; save old #
          STA LINNUM+1

; ***********
  Find_LINNUM
; ***********

          TYA
          PHA
          LDY #0
          STY STAL            ; STAL = $8000
          LDA #$80
          STA STAL+1
          STA R_Bank
FiEn_10   LDY #3              ; old line high
          JSR Bank_Fetch
          CMP #$ff            ; EOT
          BEQ FiEn_20
          CMP LINNUM+1
          BNE FiEn_30
          DEY                 ; old line low
          JSR Bank_Fetch
          CMP LINNUM
          BNE FiEn_30
          DEY                 ; new line high
          JSR Bank_Fetch
          STA LINNUM+1
          DEY                 ; new line low
          JSR Bank_Fetch
          STA LINNUM
FiEn_20   PLA
          TAY
          RTS
FiEn_30   LDA #4
          JSR Add_STAL
          BNE FiEn_10
          RTS

; *******************
  Install_Bank_Access
; *******************

          LDX #0
FSC_10    LDA Bank_Fetch_Start,X
          STA Bank_Fetch,X
          INX
          CPX #[Bank_Store_End - Bank_Fetch_Start]
          BCC FSC_10
          RTS

; ****************
  Bank_Fetch_Start
; ****************

          LDA R_Bank
          SEI
          STA $FFF0
          LDA (STAL),Y
          PHA
          LDA Default_Bank
          STA $FFF0
          CLI
          PLA
          RTS

; **************
  Bank_Fetch_End
; **************

; ****************
  Bank_Store_Start
; ****************

          PHA
          LDA W_Bank
          SEI
          STA $FFF0
          PLA
          STA (BPTR),Y
          PHA
          LDA Default_Bank
          STA $FFF0
          CLI
          PLA
          RTS

; **************
  Bank_Store_End
; **************


; ********
  Get_Next
; ********

          INC TXTPTR
          BNE GeNe_10
          INC TXTPTR+1
GeNe_10   LDA (TXTPTR,X)      ; X = 0
          RTS

; *********
  Xfer_Line
; *********

; copy BASIC line and adjust targets for

; GOTO
; GOSUB
; THEN
; GO TO
; RUN

; Set TXTPTR to start of BASIC line

          CLC
          LDA TMPPTC
          ADC #3
          STA TXTPTR
          LDA TMPPTC+1
          ADC #0
          STA TXTPTR+1
          LDX #0              ; source index
          LDY #3              ; destination index
XfLi_10   INY
          JSR Get_Next        ; next byte
          JSR Bank_Store      ; store
          BEQ XfLi_Ret        ; finished
          CMP #QUOTE
          BNE XfLi_30
XfLi_20   INY
          JSR Get_Next        ; inside string
          JSR Bank_Store      ; store
          BEQ XfLi_Ret        ; finished
          CMP #QUOTE
          BNE XfLi_20         ; continue string copy
          BEQ XfLi_10         ; reenter normal loop
XfLi_30   CMP #$8f            ; REM token
          BNE XfLi_50
XfLi_40   INY
          JSR Get_Next        ; after REM
          JSR Bank_Store      ; store
          BNE XfLi_40
          RTS
XfLi_50   CMP #$89            ; GOTO token
          BCC XfLi_10         ; no further action
          BEQ XfLi_70
          CMP #$8a            ; RUN token
          BEQ XfLi_70
          CMP #$8d            ; GOSUB token
          BEQ XfLi_70
          CMP #$a7            ; THEN token
          BEQ XfLi_70
          CMP #$cb            ; GO token
          BNE XfLi_60
XfLi_55   INY
          JSR Get_Next
          JSR Bank_Store
          CMP #' '            ; skip blanks after GO
          BEQ XfLi_55
XfLi_60   CMP #$a4            ; TO token
          BNE XfLi_10         ; continue
XfLi_70   JSR Exchange_Number
          CMP #0
          BNE XfLi_50         ; continue if not EOL
XfLi_Ret  RTS


; ***************
  Exchange_Number
; ***************

          INY                 ; char after token
          JSR CHRGET
          BCS ExNu_20         ; no number e.g. after THEN
          JSR Scan_Linenumber
          JSR Find_LINNUM
          TYA
          PHA
          LDA LINNUM
          STA FAC1M2
          LDA LINNUM+1
          STA FAC1M1
          LDX #$90
          SEC
          JSR Convert_Integer_To_Real
          JSR Format_FAC1
          PLA
          TAY
          LDX #1
ExNu_10   LDA STACK,X
          BEQ ExNu_20
          JSR Bank_Store
          INY
          INX
          BNE ExNu_10
ExNu_20   LDX#0
          JSR CHRGOT          ; char after target
          JSR Bank_Store
          CMP #','            ; on .. goto or on .. gosub ?
          BEQ Exchange_Number
ExNu_Ret  RTS

; **********************
  Reset_Renumber_Pointer
; **********************

; read basic program with pointer TMPPTC

          LDA TXTTAB
          STA TMPPTC
          LDA TXTTAB+1
          STA TMPPTC+1

; **********
  Reset_BPTR
; **********

          LDA #0
          STA BPTR
          LDA #$80
          STA BPTR+1
          RTS

; ***********
  Update_Link
; ***********

          LDY #0
          LDA (TMPPTC),Y      ; link low
          TAX
          INY                 ; Y = 1
          LDA (TMPPTC),Y      ; link high
          STX TMPPTC
          STA TMPPTC+1        ; Z flag set if link high is zero
          RTS


; ****************
  Extended_Command
; ****************

          LDY #0
          STY COUNT           ; count command #
ExCo_10   DEY
          LDX TXTPTR
          DEX
ExCo_20   INX
          INY
          LDA BUF,X
          SEC
          SBC Extended_Keyword_Table,Y
          BEQ ExCo_20         ; character match
          CMP #$80            ; match with difference $80 -> OK
          BNE ExCo_30         ; not this keyword
          PLA                 ; remove CALL
          PLA
          STX TXTPTR
          LDA COUNT           ; command #
          ASL A
          TAY
          LDA Extended_Statement_Table+1,Y
          PHA
          LDA Extended_Statement_Table,Y
          PHA
          JMP CHRGET          ; RTS from CHRGET jumps to statement code
ExCo_30   INC COUNT           ; try next keyword
ExCo_40   INY
          LDA Extended_Keyword_Table-1,Y
          BPL ExCo_40
          LDA Extended_Statement_Table,Y
          BNE ExCo_10         ; next keyword if not end of table
          RTS                 ; finished scan


; *********
  Find_Text
; *********

          JSR Tokenize_Line
          JSR CHRGET
          STA RENNEW          ; delimiter
          JSR Reset_Renumber_Pointer
FiTe_10   LDY #3
          STY RENNEW+1
          JSR Contains_Pattern
          BNE FiTe_20
          JSR List_BASIC_Line
          JSR Mon_Print_CR
FiTe_20   JSR Update_Link
          BNE FiTe_10
          JMP Basic_Ready

; ****************
  Contains_Pattern
; ****************

CoPa_10   LDX TXTPTR          ; text to find - 1
          LDY RENNEW+1
CoPa_20   INY
          INX
          LDA BUF,X           ; next pattern
          BEQ CoPa_Ret        ; match
          CMP RENNEW          ; delimiter
          BEQ CoPa_Ret        ; match
          CMP (TMPPTC),Y      ; next program byte
          BEQ CoPa_20         ; continue compare
          INC RENNEW+1        ; advance search pos
          LDA (TMPPTC),Y
          BNE CoPa_10
          LDA #1
CoPa_Ret  RTS

; **************
  Load_Directory
; **************

          JSR Open_Load_File  ; open file with SA = $60
          LDY STREND+1        ; load directory into free RAM
          INY
          STY EAL+1
          LDY #0
          STY EAL
          STY STATUS
          LDY #2              ; header start
LoDi_10   LDX EAL+1           ; next page
          INX
          CPX FRETOP+1        ; end of free RAM
          BCC LoDi_20         ; branch if OK
          JMP Error_Out_Of_Memory
LoDi_20   STX EAL+1
LoDi_30   JSR ACPTR           ; read next byte
          STA (EAL),Y
          LDA STATUS
          BNE LoDi_40         ; branch on EOI
          INY
          BNE LoDi_30         ; loop
          BEQ LoDi_10         ; increment page
LoDi_40   JMP LoFi_70         ; Untalk & Close

; *****************
  DOS_Get_Dir_Entry
; *****************

; Read directory entry from loaded $ file
; and store results in FNLEN and DOS_FC
; Store filename address in FNADR
; X = 0 flags no entry found on exit

          CLC                 ; advance to next entry
          LDA DosPtr          ; start address
          ADC #32
          STA DosPtr
          BCC DGDE_05
          INC DosPtr+1

DGDE_05   LDY #3              ; scan after size word

DGDE_10   INY
          LDA (DosPtr),Y
          CMP #QUOTE
          BCC DGDE_10         ; skip blanks before filename
          BNE DGDE_80         ; no quote -> blocks free
          DEY                 ; byte for drive
          DEY                 ; byte for 'S' command
          TYA
          ORA DosPtr          ; set FNADR
          STA FNADR
          LDA DosPtr+1
          STA FNADR+1
          LDY #0              ; prepare scratch command
          LDA #'S'
          STA (FNADR),Y
          INY
          LDA DOS_Drive_2     ; target drive
          ORA #'0'
          STA (FNADR),Y
          INY
          LDA #':'
          STA (FNADR),Y       ; overwrite opening quote

DGDE_20   INY
          LDA (FNADR),Y
          CMP #QUOTE          ; closing quote
          BEQ DGDE_40
          CPY #19             ; max length + "S0:"
          BCC DGDE_20

DGDE_40   STY FNLEN           ; length of filename

DGDE_60   INY
          LDA (FNADR),Y
          CMP #' '            ; skip blanks
          BEQ DGDE_60
          CMP #'*'            ; splat file ?
          BEQ DOS_Get_Dir_Entry
          STA DOS_FC          ; PRG, SEQ, USR, REL
          LDY #0              ; flag success

DGDE_80   RTS                 ; Y != 0 for no file

; *************
  DOS_Add_Comma
; *************

          LDA #','
          STA (FNADR),Y
          INY
          RTS

; DOS_Copy is an enhancement of the BASIC 4 COPY command.
; It is called from the original COPY if Source Unit and
; Target unit differ
; DOS_Copy uses the free RAM between variable storage and
; string storage (STREND - FRETOP)
; First a call to the Garbage_Collection maximises the
; free RAM area. The first 256 byte block after STREND is
; used as a transfer buffer. The area STREND + 256 is used
; to store the directory of the source unit. If the
; remaining space is not sufficient to load the directory
; an OOM (Out Of Memory) error occurs.

; ********
  DOS_Copy
; ********

          JSR Garbage_Collection
          LDA FA              ; target unit
          STA Target_Unit     ; save it
          LDA Source_Unit
          STA FA
          LDA #'$'            ; directory command
          STA DOS_Command_Buffer
          LDA #3              ; 3 parameter
          LDX #1              ; write after $
          LDY #2              ; build d1:f1
          JSR Build_DOS_Command_X
          JSR Load_Directory
          LDA #0              ; start of directory
          STA DosPtr
          LDX STREND+1
          INX
          INX
          STX DosPtr+1

DOSC_10   JSR DOS_Get_Dir_Entry
          TYA                 ; 0: success
          BEQ DOSC_15
          RTS

DOSC_15   STY DOS_RL          ; record length
          STY LINNUM          ; initialize record #
          STY LINNUM+1
          INY
          STY DOS_Tmp         ; pos in record# = 1
          LDY FNLEN
          JSR DOS_Add_Comma
          LDA DOS_FC          ; Filetype
          CMP #'R'            ; REL file ?
          BNE DOSC_20
          LDA #'L'            ; REL type
          STA (FNADR),Y
          INY
          JSR DOS_Add_Comma   ; "St:FILENAME,L,CHR$(RL)"
          LDA #254            ; max record length
          STA DOS_RL
          BNE DOSC_25         ; branch always

DOSC_20   STA (FNADR),Y       ; "St:FILENAME,S"
          INY
          JSR DOS_Add_Comma
          LDA #'W'

DOSC_25   STA (FNADR),Y       ; "St:FILENAME,S,W"

; Scratch target file (avoid @ syntax)

          LDA Target_Unit
          STA FA
          JSR PDC_10          ; send DOS command

; Remove 'S' from Scratch command

          INC FNADR           ; always inside page

; Add ",S" ",P" ",U" or ",L,CHR$(RL)"

          INC FNLEN           ; "t:FILENAME,S"
          LDA DOS_RL          ; REL file ?
          BEQ DOSC_35         ; branch if not
          INC FNLEN           ; "t:FILENAME,L,"
          INC FNLEN           ; "t:FILENAME,L,(RL)"

; print filename

DOSC_35   JSR Print_Filename
          JSR Open_Read_File

; Open write file

DOSC_47   LDA DOS_RL
          BNE DOSC_50
          INC FNLEN           ; "s:FILENAME,S,W"
          INC FNLEN

DOSC_50   JSR Open_Write_File

; Copy file

DOSC_55   LDA Source_Unit
          STA FA
          JSR TALK
          LDA #$6d
          STA SA
          JSR TKSA
          LDY #0
          STY STATUS

DOSC_60   JSR ACPTR
          STA (STREND),Y
          INY
          LDA STATUS
          STA DOS_EOF
          BNE DOSC_65
          CPY DOS_RL          ; copy max DOS_RL bytes
          BNE DOSC_60         ; DOS_RL=0 -> copy 256 bytes

DOSC_65   STY DOS_FC          ; Byte count
          JSR UNTLK
          LDA DOS_RL
          BEQ DOSC_66
          JSR Kernal_Read_DS
          CMP #'0'
          BNE DOSC_75

DOSC_66   LDA Target_Unit
          STA FA
          LDA #$6e
          STA SA
          LDY #0
          STY STATUS
          LDA DOS_RL
          BEQ DOSC_67
          JSR Send_Record_No

DOSC_67   JSR LISTEN
          LDA #$6e
          STA SA
          JSR SECOND

DOSC_70   LDA (STREND),Y
          JSR CIOUT
          LDA STATUS
          BNE DOSC_75
          INY
          CPY DOS_FC
          BNE DOSC_70
          JSR UNLSN
          LDA DOS_EOF
          BEQ DOSC_55
          LDA DOS_RL
          BEQ DOSC_75
          JSR Kernal_Read_DS
          CMP #'0'
          BEQ DOSC_55
          CMP #'5'            ; ignore record not present
          BEQ DOSC_55

DOSC_75   JSR UNLSN
          LDA Target_Unit
          STA FA
          LDA #$6e
          STA SA
          JSR Close_Disk_File ; close write file
          LDA #CR
          JSR CHROUT
          LDA Source_Unit
          STA FA
          LDA #$6d
          STA SA
          JSR Close_Disk_File ; close read file
          JMP DOSC_10         ; next file

; **************
  Send_Record_No
; **************

          INC LINNUM
          BNE SRN_10
          INC LINNUM+1
SRN_10    JSR DOS_Record_No
          JSR Kernal_Read_DS
          LDY #0
          STY STATUS
          RTS

; **************
  Print_Filename
; **************

          JSR In_Direct_Mode
          BNE PrFi_90
          LDY #0
PrFi_10   LDA (FNADR),Y
          INY
          JSR CHROUT
          CMP #'L'
          BNE PrFi_20
          LDA (FNADR),Y
          CMP#','
          BNE PrFi_20
          JSR CHROUT
          LDA #'$'
          JSR CHROUT
          INY
          LDA (FNADR),Y
          JMP Print_Hex_Byte
PrFi_20   CPY FNLEN
          BCC PrFi_10
PrFi_90   RTS

; **************
  Open_Read_File
; **************

          LDA Source_Unit
          STA FA
          LDA #$6d            ; channel 13
          STA SA
          LDY #0
          STY STATUS          ; clear status
          LDA DOS_Drive_1     ; source drive
          ORA #'0'
          STA (FNADR),Y       ; into filename
          LDA DOS_RL          ; REL file ?
          BEQ ORF_10          ; branch if not
          JMP Get_Record_Size
ORF_10    JMP Send_Filename

; ***************
  Open_Write_File
; ***************

          LDA Target_Unit
          STA FA
          LDA #$6e
          STA SA
          LDY #0
          STY STATUS
          LDA DOS_Drive_2
          ORA #'0'
          STA (FNADR),Y
          JMP Send_Filename

; ***********
  Sub_STAL_16
; ***********

          SEC
          LDA STAL
          SBC #16
          STA STAL
          BCS SuST_Ret
          DEC STAL+1
SuST_Ret  RTS

          .FILL $f000 - * (0)

; ***************
  KERNAL_MESSAGES
; ***************

MSG_TOO_MANY    .BYTE "TOO MANY FILES"^
MSG_FILE_OPEN   .BYTE "FILE OPEN"^
MSG_FILE_NOT_O  .BYTE "FILE NOT OPEN"^
MSG_FILE_NOT_F  .BYTE "FILE NOT FOUND"^
MSG_SEARCHING   .BYTE "\rSEARCHING "^
MSG_FOR         .BYTE "FOR "^
MSG_PRESS       .BYTE "\rPRESS PLAY "^
MSG_RECORD      .BYTE "& RECORD "^
MSG_ON_TAPE     .BYTE "ON TAPE #"^
MSG_LOAD        .BYTE "\rLOAD"^
MSG_WRITING     .BYTE "\rWRITING "^
MSG_VERIFY      .BYTE "\rVERIFY"^
MSG_DEVICE_NOT  .BYTE "DEVICE NOT PRESENT"^
MSG_NOT_INPUT   .BYTE "NOT INPUT FILE"^
MSG_NOT_OUTPUT  .BYTE "NOT OUTPUT FILE"^
MSG_FOUND       .BYTE "\rFOUND "^
MSG_OK          .BYTE "\rOK\r"^
MSG_READY       .BYTE "\rREADY.\r"^
MSG_SURE        .BYTE "\rARE YOU SURE ?"^
MSG_BAD_DISK    .BYTE "\r? BAD DISK \r"^

; ****
  TALK
; ****

          LDA #%01000000      ; TALK cmd: $40..$5e
          .BYTE $2c           ; skip next statement

; ******
  LISTEN
; ******

          LDA #%00100000      ; LISTEN cmd: $20..$3e

; *******
  TALI_10
; *******

          PHA                 ; save talk or listen bit
          LDA VIA_Port_B
          ORA #%00000010      ; $02
          STA VIA_Port_B      ; set NRFD (bit 1) high
          LDA #%00111100      ; $3c
          STA PIA2_Cont_A     ; set NDAC (bit 3) high
          BIT C3PO            ; data in output buffer ?
          BEQ TALI_20         ; branch if not
          LDA #%00110100      ; $34
          STA PIA1_Cont_A     ; set NDAC (bit 3) low
          JSR Send_IEEE_Byte  ; flush buffer (BSOUR)
          LDA #0
          STA C3PO            ; clear buffer flag
          LDA #%00111100      ; $3c
          STA PIA1_Cont_A     ; set NDAC (bit 3) high
TALI_20   PLA                 ; restore talk or listen bit
          ORA FA              ; combine signal with adress
          STA BSOUR           ; store in output buffer
TALI_30   LDA VIA_Port_B      ; load signals
          BPL TALI_30         ; wait until DAV high
          AND #%11111011      ; $fb
          STA VIA_Port_B      ; set ATN (bit 2) low

; **************
  Send_IEEE_Byte
; **************

          LDA #%00111100      ; $3c
          STA PIA2_Cont_B     ; set DAV (bit 3) high
          LDA VIA_Port_B      ; loadsignals
          AND #%01000001      ; mask NRFD & NDAC
          CMP #%01000001      ; both high ?
          BEQ Device_Not_Present
          LDA BSOUR           ; load byte to send
          EOR #$ff            ; invert it
          STA PIA2_Port_B     ; DATA OUT
SIB_10    BIT VIA_Port_B      ; test signals
          BVC SIB_10          ; wait until NRFD high
          LDA #%00110100      ; $34
          STA PIA2_Cont_B     ; set DAV (bit 3) low
SIB_20    LDA #$ff            ; set timer to MAX
          STA VIA_Timer_1_Hi
SIB_30    LDA VIA_Port_B      ; load signals
          BIT VIA_IFR         ; check timer, expect NDAC high in ca. 65 ms
          BVS Time_Out_Writing
          LSR A               ; NDAC -> carry
          BCC SIB_30          ; repeat until NDAC high
tby6      LDA #%00111100      ; $3c
          STA PIA2_Cont_B     ; set DAV (bit 3) high
          LDA #$ff            ; release data lines
          STA PIA2_Port_B
          RTS

; ******
  SECOND
; ******

          STA BSOUR           ; output buffer
          JSR Send_IEEE_Byte  ; send it

; *******
  Set_ATN
; *******

          LDA VIA_Port_B
          ORA #%00000100      ; $04
          STA VIA_Port_B      ; set ATN high
          RTS

; ****************
  Time_Out_Writing
; ****************

          LDA Ignore_Timeout  ; load timeout flag (addr. 1020, bit 7)
          BPL Timo_W          ; timeout if flag cleared (default value)
          JSR Kernal_STOP
          BNE SIB_20          ; restart timer and try again to transmit

; ****************
  Time_Out_Reading
; ****************

          LDA Ignore_Timeout
          BPL Timo_R
          JSR Kernal_STOP
          BNE Acptr_10
Timo_W    LDA #1              ; flag time out on writing
Timo_S    JSR Set_STATUS
          BNE tby6            ; branch always

; ******************
  Device_Not_Present
; ******************

          LDA #$80
          BMI Timo_S
Timo_R    LDA #2              ; flag time out reading
          JSR Set_STATUS

; *****************
  Set_NRFD_NDAC_low
; *****************

          LDA VIA_Port_B
          AND #%11111101      ; $fd
          STA VIA_Port_B      ; set NRFD (bit 1) low
          LDA #%00110100      ; $34
          STA PIA2_Cont_A     ; set NDAC (bit 3) low
          LDA #CR             ; load CR
          RTS

; **********************
  Display_Kernal_Message
; **********************

          LDA KERNAL_MESSAGES,Y  ; Y = offset for string
          PHP                 ; save status (possible end marker)
          AND #$7f            ; clear bit 7
          JSR EDIT_CHROUT     ; dispay it
          INY                 ; next character
          PLP                 ; restore status
          BPL Display_Kernal_Message
          RTS                 ; bit 7 = end marker

; ****
  TKSA
; ****

          STA BSOUR           ; SA (A) to Buffer
          JSR Send_IEEE_Byte  ; send it
          JSR Set_NRFD_NDAC_low
          JMP Set_ATN

; *****
  CIOUT
; *****

          BIT C3PO            ; C3PO = 0 flags empty buffer
          BMI Ciout_10        ; branch if not empty
          DEC C3PO            ; set flag for not empty
          BNE Ciout_20        ; branch always
Ciout_10  PHA                 ; save current byte
          JSR Send_IEEE_Byte  ; send byte from buffer
          PLA                 ; restore current byte
Ciout_20  STA BSOUR           ; put it into buffer
          RTS

; *****
  UNTLK
; *****

          LDA VIA_Port_B
          AND #%11111011      ; $fb
          STA VIA_Port_B      ; set ATN low
          LDA #%01011111      ; $5f
          .BYTE $2c           ; skip next statement

; *****
  UNLSN
; *****

          LDA #%00111111      ; $3f
          JSR TALI_10
          BNE Set_ATN         ; branch always

; *****
  ACPTR
; *****

          LDA #%00110100      ; $34
          STA PIA2_Cont_A     ; set NDAC (bit 3) low
          LDA VIA_Port_B
          ORA #%00000010      ; $02
          STA VIA_Port_B      ; set NRFD (bit 1) high
Acptr_10  LDA #$ff
          STA VIA_Timer_1_Hi  ; set timer
Acptr_20  BIT VIA_IFR
          BVS Time_Out_Reading; timeout after 65 ms
          BIT VIA_Port_B      ; test DAV (bit 7)
          BMI Acptr_20        ; loop until DAV (bit 7) low
          LDA VIA_Port_B
          AND #%11111101      ; $fd
          STA VIA_Port_B      ; set NRFD (bit 1) low
          BIT PIA1_Port_A     ; test for EOI
          BVS Acptr_30        ; branch if not
          LDA #%01000000      ; set EOI flag
          JSR Set_STATUS
Acptr_30  LDA PIA2_Port_A     ; read data byte
          EOR #$ff            ; invert it
          PHA                 ; save read byte
          LDA #%00111100      ; $3c
          STA PIA2_Cont_A     ; set NDAC (bit 3) high
Acptr_40  BIT VIA_Port_B      ; test DAV
          BPL Acptr_40        ; loop until DAV (bit 7) high
          LDA #%00110100      ; $34
          STA PIA2_Cont_A     ; set NDAC (bit 3) low
          PLA                 ; restore read byte
          RTS

; ************
  Kernal_GETIN
; ************

          LDA #0
          STA STATUS          ; clear status
          LDA DFLTN           ; current input device
          BNE KeIn_10         ; branch if not keyboard
GETIN_10  LDA CharsInBuffer   ; test keyboard queue
          BEQ KeIn_30         ; return if empty
          SEI                 ; disable interrupt
          JMP EDIT_GETIN      ; get character from keyboard queue

; ************
  Kernal_CHRIN
; ************

          LDA DFLTN           ; current input device
          BNE KeIn_10         ; branch if not keyboard
          LDA CursorCol       ; get current cursor column
          STA InputCol        ; start input here
          LDA CursorRow       ; get current cursor row
          STA InputRow        ; start input here
          JMP EDIT_CHRIN      ; continue at EDIT_CHRIN
KeIn_10   CMP #4              ; test device number
          BCS KeIn_20         ; branch if IEEE-488 device
          STA CRSW            ; device is screen (3)
          LDA RigMargin       ; limit input column
          STA LastInputCol    ; at right margin
          JMP EDIT_CHRIN      ; continue at EDIT_CHRIN
KeIn_20   LDA STATUS          ; It's IEEE-488 input
          BEQ KeIn_40         ; continue at ACPTR if status is OK
          LDA #CR             ; status flags some error, return CR
KeIn_30   RTS                 ; return
KeIn_40   JMP ACPTR           ; continue at ACPTR

          .FILL $f266 - * (0)

; *************
  Kernal_CHROUT
; *************

          PHA                 ; save character
          LDA DFLTO           ; load current output device
          CMP #4              ; 4 = start of IEEE-488 devices
          PLA                 ; restore character
          BCS KeCH_10         ; branch if IEEE-488 device
          JMP EDIT_CHROUT     ; continue at display on screen
KeCH_10   JMP CIOUT           ; continue on IEEE-488 output

; ************
  Check_Mon_Up
; ************

          LDX BotMargin
CMDU_10   CPX TopMargin
          BEQ CMDU_Ret        ; not found: C=1
          DEX
          JSR Check_Mon_Line
          BCS CMDU_10
          LDA #16
          LDX Mon_A
          CPX #':'            ; dump ?
          BEQ CMDU_20
          INC Dis_Length
          LDA Dis_Length      ; disass
CMDU_20   JSR Add_STAL
          CLC
CMDU_Ret  RTS

          .FILL $f2a2 - * (0)

; ************
  Kernal_CLALL
; ************

          LDA #0
          STA LDTND           ; set # of open files to zero

; *************
  Kernal_CLRCHN
; *************

          LDA DFLTO           ; default output device
          CMP #4              ; screen or IEEE-488 ?
          BCC KeCL_10         ; branch if screen
          JSR UNLSN           ; send unlisten
KeCL_10   LDA DFLTN           ; default input device
          CMP #4              ; IEEE-488 or not ?
          BCC Set_Default_IO
          JSR UNTLK           ; send untalk

; **************
  Set_Default_IO
; **************

          LDA #3
          STA DFLTO
          LDA #0
          STA DFLTN
          RTS

; *********
  LOOKUP_LA
; *********

          LDX LDTND           ; # of open files
LOOK_10   DEX
          BMI LOOK_Ret        ; -> not found
          CMP LAT,X
          BNE LOOK_10
LOOK_Ret  RTS

          .FILL $f2cd-* (0)

; **********************
  Set_LFS_From_X ; $f2cd
; **********************

; Input:  X = index to file
; Output: A = FA

          LDA LAT,X
          STA LA
          LDA SAT,X
          STA SA
          LDA FAT,X
          STA FA
          RTS

; ************
  Kernal_CLOSE
; ************

          JSR Get_Open_Close_Parameter
          LDA LA

; *************
  Close_LA_in_A
; *************

          JSR LOOKUP_LA
          BNE ClFi_20

; ************
  Close_File_A
; ************

          JSR Set_LFS_From_X
          CMP #4
          BCC ClFi_10         ; keyboard or screen
          JSR Close_Disk_File
ClFi_10   DEC LDTND
          CPX LDTND
          BEQ ClFi_20
          LDY LDTND
          LDA LAT,Y
          STA LAT,X
          LDA FAT,Y
          STA FAT,X
          LDA SAT,Y
          STA SAT,X
ClFi_20   RTS

          .FILL $f335 - * (0)

; **************
  Check_STOP_Key
; **************

          LDA Stop_Flag
          CMP #$ef
          BNE ChST_Ret
          PHP
          JSR Kernal_CLRCHN
          STA CharsInBuffer
          PLP
ChST_Ret  RTS

; ***********
  Kernal_STOP
; ***********

          JSR Check_STOP_Key
          JMP Basic_STOP

; ************************
  Kernal_Message_If_Direct
; ************************

          JSR In_Direct_Mode
          BNE ChST_Ret
          JMP Display_Kernal_Message

; **************
  In_Direct_Mode
; **************

          LDA TXTPTR+1
          CMP #2
          RTS

; *********
  Load_File
; *********

          LDA FA              ; primary device address
          CMP #4              ; start of IEEE-488 devices
          BCS LoFi_15
LoFi_10   JMP Syntax_Error    ; no loading from devices 0-3
LoFi_15   LDY FNLEN
          BEQ LoFi_10         ; error for zero length filenames
          LDX SA              ; 1: use load address from file
          JSR Open_Load_File  ; open file with SA = $60
          CPX #0              ; ignore load address ?
          BEQ LoFi_20
          STY EAL
          STA EAL+1
LoFi_20   LDA STATUS          ; check time out bit
          BEQ LoFi_25         ; no time out -> continue
          JMP Display_File_Not_Found
LoFi_25   JSR In_Direct_Mode
          BNE LoFi_30
          JSR Display_Load_Or_Verify
          LDA EAL+1
          JSR Print_Hex_Byte
          LDA EAL
          JSR Print_Hex_Byte
          LDA #'-'
          JSR EDIT_CHROUT
LoFi_30   LDY #0              ; remains zero for loop
LoFi_35   STY STATUS          ; clear status bits
LoFi_40   JSR Kernal_STOP     ; STOP key pressed?
          JSR ACPTR           ; read next byte
          BIT VERCK           ; load (0) or verify ($80)
          BPL LoFi_45         ; branch if loading
          CMP (EAL),Y         ; verify
          BEQ LoFi_55         ; branch if OK
          LDA #%00010000      ; flag verify error $10
          JSR Set_STATUS      ; and stop verifying
          BNE LoFi_70         ; branch always
LoFi_45   STA (EAL),Y         ; store byte
LoFi_50   LDA (EAL),Y         ; this comparison is false for an
          CMP (EAL),Y         ; unfinished write cycle to EEPROM
          BNE LoFi_50         ; repeat until EEPROM bit toggle ceased
LoFi_55   INC EAL             ; increment write address
          BNE LoFi_60
          INC EAL+1
          JSR In_Direct_Mode
          BNE LoFi_60
          JSR Print_EAL
LoFi_60   BIT STATUS          ; Get EOF marker in bit 6
          BVC LoFi_40         ; repeat until EOF
LoFi_70   JSR UNTLK
          JSR Close_Disk_File
          JSR In_Direct_Mode
          BEQ LoFi_80
          RTS
LoFi_80   JMP Print_EAL

; **************
  Open_Load_File
; **************

          LDA #$60            ; secondary address for loading
          STA SA
          JSR Send_Filename
          JSR TALK            ; send primary address
          LDA SA
          JSR TKSA            ; send secondary address
          JSR ACPTR           ; load address low
          TAY                 ; Y = load address low
          JMP ACPTR           ; A = load address high

; *****
  Merge
; *****

          LDA #$40            ; load and merge file
          BNE KeLO_10         ; always

          .FILL $f401 - * (0)

; ***********
  Kernal_LOAD
; ***********

          LDA #0
KeLO_10   STA VERCK

; ***********
  Load_Verify
; ***********

          JSR Get_File_Parameter
          BIT VERCK
          BVC Load_Verify_Params_Set
          SEC
          LDA VARTAB          ; set merge address
          SBC #2
          STA EAL
          LDA VARTAB+1
          SBC #0
          STA EAL+1
          LDA #0
          STA SA

; **********************
  Load_Verify_Params_Set
; **********************

          JSR Load_File       ; load file into RAM
          BIT VERCK           ; (0) LOAD, ($80) VERIFY
          BMI LVPS_Ret        ; done for verify
          LDY #<MSG_READY     ; $ae
          JSR Kernal_Message_If_Direct
          JSR In_Direct_Mode
          BNE LVPS_20
          LDA EAL+1
          STA VARTAB+1        ; update VARPTR
          LDA EAL
          STA VARTAB
          JMP Reset_And_Rechain
LVPS_20   JSR Reset_BASIC_Exec_Pointer
          JMP RVP_10
LVPS_Ret  RTS

; *********
  Print_EAL
; *********

          LDA EAL+1
          JSR Print_Hex_Byte
          LDA EAL
          JSR Print_Hex_Byte
          LDX #4
          LDA #$9d            ; cursor left
PrEA_10   JSR EDIT_CHROUT
          DEX
          BNE PrEA_10
PrEA_Ret  RTS

          .FILL $f46d - * (0)

; **********************
  Display_Load_Or_Verify
; **********************

          LDY #<MSG_LOAD      ; $5f
          BIT VERCK
          BPL DLOV_10
          LDY #<MSG_VERIFY    ; $6d
DLOV_10   JSR Kernal_Message_If_Direct
          LDY #<[MSG_SEARCHING + 7];$39 add "ING"
          JMP Kernal_Message_If_Direct

; ******************
  Get_File_Parameter
; ******************

          LDX #0
          STX STATUS
          STX FNLEN
          INX
          STX SA              ; SA = 1
          LDX #8
          STX FA              ; FA = 8
          JSR ChrGot_Or_RTS
          JSR Set_Filename_From_String
          JSR ChrGot_Or_RTS
          JSR Get_Comma_And_Byte
          STX FA
          JSR ChrGot_Or_RTS
          JSR Get_Comma_And_Byte
          STX SA
          LDX TXTTAB          ; default: start of BASIC
          LDA TXTTAB+1
          STX EAL
          STA EAL+1
GFP_Ret   RTS

; ******************
  Get_Comma_And_Byte
; ******************

          JSR Get_Comma_And_Chr
          JMP Get_Byte_Value

; *************
  Send_Filename
; *************

          LDY FNLEN
          BEQ GFP_Ret
          JSR LISTEN
          LDA SA
          ORA #$f0

; ****************
  Send_DOS_Command
; ****************

          JSR SECOND
          LDA STATUS
          BPL SeDC_10
          LDY #<MSG_DEVICE_NOT; $74
          JMP Handle_IO_Error
SeDC_10   LDY #0
SeDC_20   LDA (FNADR),Y
          JSR CIOUT
          INY
          CPY FNLEN
          BNE SeDC_20
          JMP UNLSN

          .FILL $f4f6 - * (0)

; *************
  Kernal_VERIFY
; *************

          LDA #$80
          STA VERCK
          JSR Load_Verify
          LDA STATUS
          AND #16
          BEQ VERI_OK
          LDY #<[MSG_VERIFY+1]; $6e
          JMP Handle_IO_Error
VERI_OK   LDY #<MSG_OK        ; $aa
          JMP Display_Kernal_Message

; ************************
  Get_Open_Close_Parameter
; ************************

          LDX #0              ; clear
          STX SA              ; secondary address
          STX STATUS          ; status
          STX FNLEN           ; length of filename
          JSR Set_FA_to_8     ; default device 8
          JSR Assert_Not_At_End
          JSR Get_Byte_Value
          STX LA              ; store logical address
          JSR ChrGot_Or_RTS
          JSR Get_Comma_And_Byte
          STX FA              ; store primary address
          JSR ChrGot_Or_RTS
          JSR Get_Comma_And_Byte
          STX SA              ; store secondary address
          JSR ChrGot_Or_RTS
          JSR Get_Comma_And_Chr
          JMP Set_Filename_From_String

          .FILL $f53c - * (0)

; ************************
  Set_Filename_From_String
; ************************

          JSR Eval_Expression
          JSR Eval_And_Free_String
          STA FNLEN
          LDA INDEXA
          STA FNADR
          LDA INDEXA+1
          STA FNADR+1
          RTS

; *************
  ChrGot_Or_RTS
; *************

          JSR CHRGOT
          BNE Get_Ret
          PLA
          PLA
Get_Ret   RTS

; *****************
  Get_Comma_And_Chr
; *****************

          JSR Need_Comma

; *****************
  Assert_Not_At_End
; *****************

          JSR CHRGOT
          BNE Get_Ret
Err_f55d  JMP Syntax_Error

; ***********
  Kernal_OPEN
; ***********

          JSR Get_Open_Close_Parameter
Mf563     LDA LA

; *********
  Open_File
; *********

          BEQ Err_f55d
          LDY #<MSG_FILE_OPEN
          JSR LOOKUP_LA
          BEQ Handle_IO_Error
          LDX LDTND
          LDY #0              ; also MSG # for TOO MANY FILES
          STY STATUS
          CPX #10
          BEQ Handle_IO_Error
          INC LDTND
          LDA LA
          STA LAT,X
          LDA SA
          ORA #$60
          STA SA
          STA SAT,X
          LDA FA
          STA FAT,X
          BEQ Get_Ret         ; open keyboard
          CMP #3
          BEQ Get_Ret         ; open screen
          BCC Err_f55d        ; no tape support
          JMP Send_Filename

          .FILL $f5ad - * (0)


; **********************
  Display_File_Not_Found
; **********************

          LDY #<MSG_FILE_NOT_F; $24

; ***************
  Handle_IO_Error
; ***************

          JSR Kernal_CLALL
          LDA #CR
          JSR Kernal_CHROUT
          LDA #$3f            ; '?'
          JSR Kernal_CHROUT
          JSR Display_Kernal_Message
          JMP Berr_30


; *************
  Disass_Single
; *************

          LDA #'.'
          JSR Mon_Prompt
          JSR Mon_Print_Blank
          JSR Dis_Inst        ; Disassemble
          JMP Print_Dis_Line

; ***********
  Disassemble
; ***********

          JSR Mon_Get_Addr
Disa_10   JSR Check_STOP_Key  ; STOP key pressed?
          BEQ Disa_Main
          JSR Mon_Cmp_Addr
          BCC Disa_Main       ; STAL > MEMUSS ?
Disa_15   JSR Disass_Single
          LDA PC_Adjust
          BNE Disa_10
          INC PC_Adjust
Disa_Main JMP Mon_Main

; **************
  Print_Dis_Line
; **************

          PHA                 ; save mne index
          LDY #0
Disa_20   LDA Mon_Op,Y        ; next byte
          JSR Print_Hex_Byte
          JMP Disa_50
Disa_40   JSR Mon_Print_Blank
          JSR Mon_Print_Blank
Disa_50   JSR Mon_Print_Blank
          CPY Dis_Length
          INY
          BCC Disa_20         ; next byte
          CPY #3
          BCC Disa_40         ; blanks
          PLA                 ; restore mne index
          JSR Store_Mnemonic
          JSR Store_Address
          JSR Print_Dis_Buf
          SEC
          LDA Dis_Length      ; carry is set
          JMP AdST_00



; ********
  Dis_Inst
; ********

          JSR Mon_Print_STAL
          JSR Mon_Print_Blank
          LDY #2              ; fetch 3 bytes
DiIn_10   JSR Bank_Fetch
          STA Mon_Op,Y
          DEY
          BPL DiIn_10         ; opcode in A

; **************
  Analyze_Opcode
; **************

; instruction pattern: aaa bbb cc
; aaa = instruction
; bbb = addressing mode
; cc  = group

; 1. analyze group cc
; ------------------------------------------
; cc = 00  one byte instructions, branches
; cc = 01  ORA,AND,EOR,ADC,STA,LDA,CMP,SBC
; cc = 10  ASL,ROL,LSR,ROR,STX,LDX,DEC,INC
; cc = 11  illegal opcodes

          TAY                 ; save opcode
          LSR A               ; bit 0 -> carry
          BCC AnOp_10
          LSR A               ; bit 1 -> carry
          BCS AnOp_30         ; 11 -> no valid opcode
          CMP #$22            ; invalid opcode $89 ?
          BEQ AnOp_30
          AND #7              ; mask addressing mode bbb
          ORA #$80            ; set bit 7
AnOp_10   LSR A               ; A,X = aaa bbb (cc = x0)
          TAX                 ; A,X = aaa bb  (cc = 10)
          LDA admode_index,X  ; get addressing mode index
          BCS AnOp_20         ; branch on cc = 10
          LSR A               ; move nibble for cc = 00
          LSR A
          LSR A
          LSR A
AnOp_20   AND #15             ; mask addressing mode index
          BNE AnOp_40         ; branch for valid mode
AnOp_30   LDY #$80            ; set invalid opcode
          LDA #0
AnOp_40   TAX                 ; X = addressing mode index
          LDA admode_format,X ; A = addressing mode format
          STA Mon_Format      ; format
          AND #3
          STA Dis_Length      ; length
          TYA                 ; restore opcode
          AND #$8f            ; mask
          TAX                 ; X =
          TYA                 ; restore opcode
          LDY #3              ; Y = 3
          CPX #$8a            ; TXS,TAX,TSX,DEX,NOP
          BEQ AnOp_70
AnOp_50   LSR A
          BCC AnOp_70
          LSR A
AnOp_60   LSR A
          ORA #$20
          DEY
          BNE AnOp_60
          INY
AnOp_70   DEY
          BNE AnOp_50
          RTS

; ************
  admode_index
; ************

          .BYTE $40           ; $4 BRK        $0 ---
          .BYTE $02           ; $0 ---        $2 ASL zz
          .BYTE $45           ; $4 PHP        $5 ASL A
          .BYTE $03           ; $0 ---        $3 ASL nnnn

          .BYTE $d0           ; $d BPL oo     $0 ---
          .BYTE $08           ; $0 ---        $8 ASL zz,X
          .BYTE $40           ; $4 CLC        $0 ---
          .BYTE $09           ; $0 ---        $9 ASL nnnn,X

          .BYTE $30           ; $3 JSR nnnn   $0 --
          .BYTE $22           ; $2 BIT zz     $2 ROL zz
          .BYTE $45           ; $4 PLP        $5 ROL A
          .BYTE $33           ; $3 BIT nnnn   $3 ROL nnnn

          .BYTE $d0           ; $d BMI oo     $0 ---
          .BYTE $08           ; $0 ---        $8 ROL zz,X
          .BYTE $40           ; $4 SEC        $0 ---
          .BYTE $09           ; $0 ---        $9 ROL nnnn,X

          .BYTE $40           ; $4 RTI        $0 ---
          .BYTE $02           ; $0 ---        $2 LSR zz
          .BYTE $45           ; $4 PHA        $5 LSR A
          .BYTE $33           ; $3 JMP nnnn   $3 LSR nnnn

          .BYTE $d0           ; $d BVC oo     $0 ---
          .BYTE $08           ; $0 ---        $8 LSR zz,X
          .BYTE $40           ; $4 CLI        $0 ---
          .BYTE $09           ; $0 ---        $9 LSR nnnn,X

          .BYTE $40           ; $4 RTS        $0 ---
          .BYTE $02           ; $0 ---        $2 ROR zz
          .BYTE $45           ; $4 PLA        $5 ROR A
          .BYTE $b3           ; $b JMP (nnnn) $3 ROR nnnn

          .BYTE $d0           ; $d BVS oo     $0 ---
          .BYTE $08           ; $0 ---        $8 ROR zz,X
          .BYTE $40           ; $4 SEI        $0 ---
          .BYTE $09           ; $0 ---        $9 ROR nnnn,X

          .BYTE $00           ; $0 ---        $0 ---
          .BYTE $22           ; $2 STY zz     $2 STX zz
          .BYTE $44           ; $4 DEY        $4 TXA
          .BYTE $33           ; $3 STY nnnn   $3 STX nnnn

          .BYTE $d0           ; $d BCC oo     $0 ---
          .BYTE $8c           ; $8 STY zz,X   $c STX zz,Y
          .BYTE $44           ; $4 TYA        $4 TXS
          .BYTE $00           ; $0 ---        $0 ---

          .BYTE $11           ; $1 LDY #      $1 LDX #
          .BYTE $22           ; $2 LDY zz     $2 LDX zz
          .BYTE $44           ; $4 TAY        $4 TAX
          .BYTE $33           ; $3 LDY nnnn   $3 LDX nnnn

          .BYTE $d0           ; $d BCS oo     $0 ---
          .BYTE $8c           ; $8 LDY zz,X   $c LDX zz,Y
          .BYTE $44           ; $4 CLV        $4 TSX
          .BYTE $9a           ; $9 LDY nnnn,X $a LDX nnnn,Y

          .BYTE $10           ; $1 CPY #      $0 ---
          .BYTE $22           ; $2 CPY zz     $2 DEC zz
          .BYTE $44           ; $4 INY        $4 DEX
          .BYTE $33           ; $3 CPY nnnn   $3 DEC nnnn

          .BYTE $d0           ; $d BNE oo     $0 ---
          .BYTE $08           ; $0 ---        $8 DEC zz,X
          .BYTE $40           ; $4 CLD        $0 ---
          .BYTE $09           ; $0 ---        $9 DEC nnnn,X

          .BYTE $10           ; $1 CPX #      $0 ---
          .BYTE $22           ; $2 CPX zz     $2 INC zz
          .BYTE $44           ; $4 INX        $4 NOP
          .BYTE $33           ; $3 CPX nnnn   $3 INC nnnn

          .BYTE $d0           ; $d BEQ oo     $0 ---
          .BYTE $08           ; $0 ---        $8 INC zz,X
          .BYTE $40           ; $4 SED        $0 ---
          .BYTE $09           ; $0 ---        $9 INC nnnn,X

          .BYTE $62           ; $6 (zz,X)     $2 zz
          .BYTE $13           ; $1 #          $3 nnnn
          .BYTE $78           ; $7 (zz),Y     $8 zz,X
          .BYTE $a9           ; $a nnnn,Y     $9 nnnn,X

           .FILL $f6c3 - * (0)


; **********
  Kernal_SYS
; **********

          JSR Eval_Numeric
          JSR FAC1_To_LINNUM
          JMP (LINNUM)

; **************
  Set_Save_Range
; **************

          LDA VARTAB
          STA EAL
          LDA VARTAB+1
          STA EAL+1
          LDA TXTTAB+1
          STA STAL+1
          LDA TXTTAB
          STA STAL
          RTS

; ***********
  Kernal_SAVE
; ***********

          JSR Get_File_Parameter
Mf6e0     JSR Set_Save_Range

; *********
  Save_File
; *********

          LDA FA              ; primary address
          CMP #4              ; unit number >= 4
          BCS SaFi_20         ; branch if OK
SaFi_10   JMP Syntax_Error    ; wrong unit or no filename
SaFi_20   LDA #$61            ; secondary address for saving
          STA SA
          LDY FNLEN           ; length of filename
          BEQ SaFi_10         ; error if zero
          JSR Send_Filename
          JSR LISTEN          ; Send Listen
          LDA SA
          JSR SECOND          ; Send Listen Secondary
          LDY STAL            ; save start low
          LDX STAL+1          ; save start high
          TYA
          JSR CIOUT           ; send start low
          TXA
          JSR CIOUT           ; send start high
          LDA #0
          STA STAL            ; clear pointer low
SaFi_30   CPY EAL             ; compare to end address low
          BNE SaFi_40         ; not yet
          CPX EAL+1           ; compare to end address high
          BEQ SaFi_50         ; branch if at end
SaFi_40   LDA (STAL),Y        ; load next byte
          JSR CIOUT           ; send it
          JSR Kernal_STOP     ; check STOP key
          INY                 ; increment Y (low address)
          BNE SaFi_30         ; continue loop if not zero
          INX                 ; increment X (high address)
          STX STAL+1          ; update piointer
          BNE SaFi_30         ; branch always
SaFi_50   JSR UNLSN           ; Unlisten and fall through

; ***************
  Close_Disk_File
; ***************

          JSR LISTEN          ; send listen
          LDA SA
          AND #%11101111      ; $ef
          ORA #%11100000      ; $e0 + unit
          JSR SECOND          ; send secondary listen
          JMP UNLSN           ; send unlisten

; **************
  Store_Mnemonic
; **************

          LDX #0
          TAY
          LDA Mnemonic_Left,Y
          STA Mon_A
          LDA Mnemonic_Right,Y
          STA Mon_B
PrMn_10   LDA #0
          LDY #5
PrMn_20   ASL Mon_B
          ROL Mon_A
          ROL A
          DEY
          BNE PrMn_20
          ADC #$3f
          STA Dis_Buf,X
          INX
          CPX #3
          BCC PrMn_10
          RTS

          .FILL $f768 - * (0)

; ************
  Kernal_UDTIM
; ************

          INC JIFFY_CLOCK+2   ; 1 jiffy = 1/60 sec
          BNE ud_20
          INC JIFFY_CLOCK+1
          BNE ud_10
          INC JIFFY_CLOCK
ud_10     LDA JIFFY_CLOCK
          CMP #$4f            ; MSB of $4f1a00 = 24 * 60 * 60 * 60
          BCC ud_20
          LDA JIFFY_CLOCK+1
          CMP #$1a
          BCC ud_20
          LDA #0
          STA JIFFY_CLOCK
          STA JIFFY_CLOCK+1
ud_20     DEC JIFFY6          ; insert additional jiffy count every 5th. call
          BNE ud_30           ; to generate 60Hz jiffy clock from 50Hz signal
          LDA #6
          STA JIFFY6
          BNE Kernal_UDTIM    ; branch always
ud_30     RTS

          .FILL $f7af - * (0)

; ************
  Kernal_CHKIN
; ************

; Input:  X = local address
; Output: DFLTN (Default Input) set to device FA
;         IEEE-488 device will be talker

          PHA                 ; save A
          LDA #0
          STA STATUS          ; clear status
          TXA
          PHA                 ; save X
          JSR LOOKUP_LA
          BNE CHERR_17
          JSR Set_LFS_From_X
          CMP #4              ; A = FA
          BCC CHKIN_10        ; keyboard or screen
          JSR TALK
          LDA SA
          JSR TKSA
          LDA STATUS
          BMI CHERR_74
          LDA FA
CHKIN_10  STA DFLTN
          PLA
          TAX
          PLA
          RTS

CHERR_17  LDY #<MSG_FILE_NOT_O
          .BYTE $2c
CHERR_74  LDY #<MSG_DEVICE_NOT
          .BYTE $2c
CHERR_94  LDY #<MSG_NOT_OUTPUT
CHERR_IO  JMP Handle_IO_Error

          .FILL $f7fe - * (0)

; *************
  Kernal_CHKOUT
; *************

; Input:  X = local address
; Output: DFLTO (Default Output) set to device FA
;         IEEE-488 device will be listener

          PHA                 ; save A
          LDA #0
          STA STATUS          ; clear status
          TXA
          PHA                 ; save X
          JSR LOOKUP_LA
          BNE CHERR_17        ; file not open
          JSR Set_LFS_From_X
          BEQ CHERR_94        ; cannot write to keyboard
          CMP #4
          BCC KeCo_10         ; -> screen
          JSR LISTEN
          LDA SA
          JSR SECOND
          LDA STATUS
          BMI CHERR_74
          LDA FA
KeCo_10   STA DFLTO
          PLA
          TAX
          PLA
          RTS

; **************
  Set_Wedge_Unit
; **************

          JSR CHRGET
          BCC SWUN_10
          LDX Wedge_Unit      ; X = Unit
          TYA                 ; A = 0
          JSR Print_Integer_XA
          JSR Print_CR
          JMP Basic_Ready
SWUN_10   JSR Scan_Linenumber
          LDA LINNUM
          STA Wedge_Unit
          JMP Basic_Ready

; ************
  Wedge_Parser
; ************

          LDY #0
          STY VERCK           ; no verify
          LDA (TXTPTR),Y
          CMP #'@'            ; wedge control
          BEQ Command_Or_Status
          CMP #'>'            ; wedge control
          BEQ Command_Or_Status
          CMP #'$'            ; directory
          BEQ Wedge_Directory
          CMP #'#'
          BEQ Set_Wedge_Unit
          CMP #'/'
          BEQ Wedge_Load
          CMP #'^'
          BEQ Wedge_Run
          JSR Extended_Command
          JSR Tokenize_Line
          JMP Start_Program

; *****************
  Command_Or_Status
; *****************

          INC TXTPTR
          LDA (TXTPTR),Y
          BEQ Get_Status
          CMP #'$'            ; dir command
          BEQ Wedge_Directory

; ************
  Send_Command
; ************

          JSR DOS_Open_Comm_Write
SeCo_10   LDA (TXTPTR),Y
          BEQ SeCo_20
          JSR CIOUT
          INY
          BPL SeCo_10
SeCo_20   JSR UNLSN

; **********
  Get_Status
; **********

          JSR Wedge_Prepare
          JSR Print_Status
          JMP Basic_Ready

; ***************
  Wedge_Directory
; ***************

          JSR Wedge_Filename
          JSR Wedge_Prepare
          JSR Wedge_Call_Dir
          JMP Basic_Ready

; ************
  Print_Status
; ************

          JSR Clear_Status
          JSR Kernal_Read_DS
          JMP Display_Status

RUN_Now   .BYTE "RUN:\r"

; *********
  Wedge_Run
; *********

          LDX #5              ; put "RUN" into keyboard buffer
          STX CharsInBuffer
WeRu_10   LDA RUN_Now-1,X
          STA KEYD-1,X
          DEX
          BNE WeRu_10

; **********
  Wedge_Load
; **********

          JSR CHRGET
          CMP #'0'            ; Skip size info in dir listings
          BCC WeLo_10
          CMP #'9'+1
          BCC Wedge_Load
WeLo_10   JSR Wedge_Filename
          JSR Wedge_Prepare
          JMP Load_Verify_Params_Set

; *************
  Wedge_Prepare
; *************

          LDA Wedge_Unit
          STA FA
          LDA #0
          STA STATUS
          RTS

; **************
  Wedge_Filename
; **************

          LDY #-1
          JSR CHRGOT
          CMP #$22            ; quote
          BNE WeFi_10
          INC TXTPTR          ; skip quote
WeFi_10   INY
          LDA (TXTPTR),y
          BEQ WeFi_20
          CMP #$22            ; quote
          BNE WeFi_10
WeFi_20   STY FNLEN           ; store length
          LDA TXTPTR
          STA FNADR
          LDA TXTPTR + 1
          STA FNADR + 1
          LDA Wedge_Unit
          STA FA
          RTS

; *************
  Mnemonic_Left
; *************

          .BYTE >"BRK"
          .BYTE >"PHP"
          .BYTE >"BPL"
          .BYTE >"CLC"
          .BYTE >"JSR"
          .BYTE >"PLP"
          .BYTE >"BMI"
          .BYTE >"SEC"
          .BYTE >"RTI"
          .BYTE >"PHA"
          .BYTE >"BVC"
          .BYTE >"CLI"
          .BYTE >"RTS"
          .BYTE >"PLA"
          .BYTE >"BVS"
          .BYTE >"SEI"
          .BYTE >"???"
          .BYTE >"DEY"
          .BYTE >"BCC"
          .BYTE >"TYA"
          .BYTE >"LDY"
          .BYTE >"TAY"
          .BYTE >"BCS"
          .BYTE >"CLV"
          .BYTE >"CPY"
          .BYTE >"INY"
          .BYTE >"BNE"
          .BYTE >"CLD"
          .BYTE >"CPX"
          .BYTE >"INX"
          .BYTE >"BEQ"
          .BYTE >"SED"
          .BYTE >"???"
          .BYTE >"BIT"
          .BYTE >"JMP"
          .BYTE >"JMP"
          .BYTE >"STY"
          .BYTE >"LDY"
          .BYTE >"CPY"
          .BYTE >"CPX"
          .BYTE >"TXA"
          .BYTE >"TXS"
          .BYTE >"TAX"
          .BYTE >"TSX"
          .BYTE >"DEX"
          .BYTE >"???"
          .BYTE >"NOP"
          .BYTE >"???"
          .BYTE >"ASL"
          .BYTE >"ROL"
          .BYTE >"LSR"
          .BYTE >"ROR"
          .BYTE >"STX"
          .BYTE >"LDX"
          .BYTE >"DEC"
          .BYTE >"INC"
          .BYTE >"ORA"
          .BYTE >"AND"
          .BYTE >"EOR"
          .BYTE >"ADC"
          .BYTE >"STA"
          .BYTE >"LDA"
          .BYTE >"CMP"
          .BYTE >"SBC"

; **************
  Mnemonic_Right
; **************

          .BYTE <"BRK"
          .BYTE <"PHP"
          .BYTE <"BPL"
          .BYTE <"CLC"
          .BYTE <"JSR"
          .BYTE <"PLP"
          .BYTE <"BMI"
          .BYTE <"SEC"
          .BYTE <"RTI"
          .BYTE <"PHA"
          .BYTE <"BVC"
          .BYTE <"CLI"
          .BYTE <"RTS"
          .BYTE <"PLA"
          .BYTE <"BVS"
          .BYTE <"SEI"
          .BYTE <"???"
          .BYTE <"DEY"
          .BYTE <"BCC"
          .BYTE <"TYA"
          .BYTE <"LDY"
          .BYTE <"TAY"
          .BYTE <"BCS"
          .BYTE <"CLV"
          .BYTE <"CPY"
          .BYTE <"INY"
          .BYTE <"BNE"
          .BYTE <"CLD"
          .BYTE <"CPX"
          .BYTE <"INX"
          .BYTE <"BEQ"
          .BYTE <"SED"
          .BYTE <"???"
          .BYTE <"BIT"
          .BYTE <"JMP"
          .BYTE <"JMP"
          .BYTE <"STY"
          .BYTE <"LDY"
          .BYTE <"CPY"
          .BYTE <"CPX"
          .BYTE <"TXA"
          .BYTE <"TXS"
          .BYTE <"TAX"
          .BYTE <"TSX"
          .BYTE <"DEX"
          .BYTE <"???"
          .BYTE <"NOP"
          .BYTE <"???"
          .BYTE <"ASL"
          .BYTE <"ROL"
          .BYTE <"LSR"
          .BYTE <"ROR"
          .BYTE <"STX"
          .BYTE <"LDX"
          .BYTE <"DEC"
          .BYTE <"INC"
          .BYTE <"ORA"
          .BYTE <"AND"
          .BYTE <"EOR"
          .BYTE <"ADC"
          .BYTE <"STA"
          .BYTE <"LDA"
          .BYTE <"CMP"
          .BYTE <"SBC"

; *************
  admode_format
; *************

;                 76543210
;                 --------
;                 x         $
;                  x        ($
;                   x       #$
;                    x      ,X
;                     x     )
;                      x    ,Y
;                       xx  length - 1

           .BYTE %00000000  ; 0         implicit
           .BYTE %00100001  ; 1  $#     immediate
           .BYTE %10000001  ; 2  $zz    zeropage
           .BYTE %10000010  ; 3  $nnnn  absolute
           .BYTE %00000000  ; 4         implicit
           .BYTE %00000000  ; 5         implicit
           .BYTE %01011001  ; 6 ($zz,X) indexed indirect
           .BYTE %01001101  ; 7 ($zz),Y indirect indexed
           .BYTE %10010001  ; 8 $zz,X   zeropage,X
           .BYTE %10010010  ; 9 $nnnn,X absolute,X
           .BYTE %10000110  ; a $nnnn,Y absolute,Y
           .BYTE %01001010  ; b ($nnnn) indirect
           .BYTE %10000101  ; c $zz,Y   zeropage,Y
           .BYTE %10011101  ; d $nnnn   relative

adr_char1  .BYTE ",),#($"
adr_char2  .BYTE "Y",0,"X$$",0

; *************
  Store_Address
; *************

          LDA Mon_Format
          STA Mon_A
          LDY #3              ; buffer pointer after mnemonic
          LDA Dis_Length
          BEQ StAd_Ret        ; finish for implied address
          LDA #' '            ; store blank
          STA Dis_Buf+3
          INY                 ; inc buffer pointer
          LDX #5              ; 6 flags to process
StAd_10   CPX #2              ; flag2: address
          BNE StAd_30
          LDA Dis_Length
          CMP #1
          BEQ StAd_20         ; 8 bit operand
          LDA Mon_Hi
          JSR Store_Hex
StAd_20   LDA Mon_A
          CMP #$e8            ; branch ?
          BCS StAd_50         ; compute target
          LDA Mon_Lo          ; low  byte of operand
          JSR Store_Hex
StAd_30   ASL Mon_A
          BCC StAd_40
          LDA adr_char1,X
          STA Dis_Buf,Y
          INY
          LDA adr_char2,X
          BEQ StAd_40
          STA Dis_Buf,Y
          INY
StAd_40   DEX
          BPL StAd_10
          BMI StAd_Ret
StAd_50   JSR Offset_To_Target
          JSR Store_Hex_XA
StAd_Ret  STY Dis_Buf_Length
          RTS


; ************
  Store_Hex_XA
; ************
          PHA
          TXA
          JSR Store_Hex
          PLA

; *********
  Store_Hex
; *********

          PHA
          LSR A
          LSR A
          LSR A
          LSR A
          JSR Nibble_To_Hex
          STA Dis_Buf,Y
          INY
          PLA
          AND #15
          JSR Nibble_To_Hex
          STA Dis_Buf,Y
          INY
          RTS


; *************
  Print_Dis_Buf
; *************

          LDY #0
PDB_10    LDA Dis_Buf,Y
          JSR EDIT_CHROUT
          INY
          CPY Dis_Buf_Length
          BCC PDB_10
          RTS

; ***********
  Ass_Operand
; ***********

          JSR Mon_CHRIN
          BEQ AsOp_30         ; finished
          CMP #' '
          BEQ Ass_Operand     ; ignore blanks
          JSR Get_Constant
          BEQ AsOp_30         ; no chars left
          STA Ass_Buf,Y
          INY
          CPY #16
          BCC Ass_Operand
AsOp_30   LDA Ass_Buf         ; 1.st char of mnemonic
          CMP #'B'
          BNE AsOp_Ret        ; no branch
          LDA Ass_Buf+1       ; 2nd. char of mnemonic
          CMP #'I'
          BEQ AsOp_Ret        ; BIT
          CMP #'R'
          BEQ AsOp_Ret        ; BRK
          LDA Mon_Hi
          BEQ AsOp_40
          SEC                 ; convert target to offset
          LDA Mon_Lo
          SBC STAL
          SEC
          SBC #2
          STA Mon_Lo
AsOp_Ret  RTS
AsOp_40   JMP Expand_Target


; ********
  Assemble
; ********

; Strategy: convert operand to disassembler format
; Loop opcode from 0 to 255 and call disassembler
; until mnemonic and operand match.

          JSR Hex_To_STAL      ; target address
          BCC Ass_Err
Ass_010   LDY #0               ; reset buffer pointer
          STY Mon_Op
          STY Mon_Lo
          STY Mon_Hi
Ass_020   JSR Mon_CHRIN        ; get next char
          BEQ Ass_Err
          CMP #' '
          BEQ Ass_010          ; restart on blank
          STA Ass_Buf,Y        ; save char
          INY
          CPY #3
          BNE Ass_020          ; look for more
          JSR Mon_CHRIN
          BEQ Ass_040          ; Mnemonic only
          CMP #' '
          BNE Ass_Err          ; blank after mnemonic is mandatory
          STA Ass_Buf+3
          INY
          JSR Ass_Operand
Ass_040   STY Ass_Buf_Length
Ass_050   LDA Mon_Op
          JSR Analyze_Opcode
          STA Ass_Index
          JSR Store_Mnemonic
          JSR Store_Address
          LDX Ass_Buf_Length
          CPX Dis_Buf_Length
          BNE Ass_070
Ass_060   DEX
          BMI Ass_080         ; match
          LDA Ass_Buf,X
          CMP Dis_Buf,X
          BEQ Ass_060
Ass_070   INC Mon_Op          ; try next op code
          BNE Ass_050
          LDA Mon_ZP          ; was a zP mode ?
          BNE Ass_Err
          DEC Mon_ZP          ; invalidate
          JSR Expand_Address
          JMP Ass_050         ; now try two byte operands
Ass_Err   JMP Mon_Error
Ass_080   STX Dis_Line        ; disable disassembler line count
          LDA STAL
          STA BPTR
          LDA STAL+1
          STA BPTR+1
          LDY Dis_Length
Ass_090   LDA Mon_Op,Y        ; store instruction
          JSR Bank_Store
          JSR Bank_Fetch
          CMP Mon_Op,Y        ; successfull ?
          BNE Ass_Err
          DEY
          BPL Ass_090
          JSR Edit_To_Left_Margin
          LDA #$9d            ; Cursor UP
          JSR EDIT_CHROUT
          LDA #'A'
          JSR Mon_Prompt
          JSR Mon_Print_Blank
          JSR Mon_Print_STAL
          JSR Mon_Print_Blank
          LDA Ass_Index
          JSR Print_Dis_Line
          LDA #CR
          JSR EDIT_CHROUT
          SEI                 ; prompt to keyboard buffer
          LDA #'A'
          STA KEYD
          LDA #' '
          STA KEYD+1
          LDA STAL+1
          JSR Make_Hex_Byte
          STX KEYD+2
          STA KEYD+3
          LDA STAL
          JSR Make_Hex_Byte
          STX KEYD+4
          STA KEYD+5
          LDA #' '
          STA KEYD+6
          LDX #7
          STX CharsInBuffer
          CLI
          JMP Mon_10

; ********
  Inc_STAL
; ********

          LDA #1

; ********
  Add_STAL
; ********

          CLC
AdST_00   ADC STAL
          STA STAL
          BCC AdST_Ret
          INC STAL+1
AdST_Ret  RTS


; ********
  Inc_BPTR
; ********

          LDA #1

; ********
  Add_BPTR
; ********

          CLC
AdBP_00   ADC BPTR
          STA BPTR
          BCC AdBP_Ret
AdBP_10   INC BPTR+1
AdBP_Ret  RTS


; *******************
  DOS_Open_Comm_Write
; *******************

          JSR Wedge_Prepare   ; set FA and STATUS
          JSR LISTEN
          LDA #$6f
          STA SA
          JMP SECOND

; *********
  Mon_Wedge
; *********

          JSR Mon_CHRIN
          BEQ Mon_Wedge_Status
          PHA
          JSR DOS_Open_Comm_Write
          PLA
MoWe_10   JSR CIOUT
          JSR Mon_CHRIN
          BNE MoWe_10
          JSR UNLSN

; ****************
  Mon_Wedge_Status
; ****************

          JSR Mon_Print_CR
          JSR Wedge_Prepare
          JSR Print_Status
          JMP Mon_Main

; *******
  Mon_Dir
; *******

          LDY #0
          LDA #'$'
MoDi_10   STA DOS_Filename,Y
          INY
          JSR Mon_CHRIN
          BNE MoDi_10
          STY FNLEN
          JSR Set_DOS_FNADR
          JSR Mon_Print_CR
          JSR Wedge_Prepare
          JSR Wedge_Call_Dir
          JMP Mon_Main

; ****************
  Init_RAM_Vectors
; ****************

          LDX #RBVT_END - ROM_BASIC_Vector_Table - 1
IRV_10    LDA ROM_BASIC_Vector_Table,X
          STA IERROR,X
          DEX
          BPL IRV_10
          RTS

; **********************
  ROM_BASIC_Vector_Table
; **********************

          .WORD DEF_ERROR     ; $0300 IERROR
          .WORD DEF_MAIN      ; $0302 IMAIN
          .WORD DEF_CRUNCH    ; $0304 ICRNCH
          .WORD DEF_QPLOP     ; $0306 IQPLOP
          .WORD DEF_GONE      ; $0308 IGONE
          .WORD DEF_EVAL      ; $030a IEVAL
RBVT_END

; ********
  Mon_Auto
; ********

          LDX Mon_A
          CPX #':'
          BEQ MoAu_10
          JMP Disass_Single
MoAu_10   JMP Display_16_Bytes

          .FILL $fbc4 - * (0)

; **********
  Set_STATUS
; **********

          ORA STATUS
          STA STATUS
          RTS


; *********
  Mon_Get_3
; *********

          JSR Hex_To_STAL
          BCC MG3_Err
          LDX #MEMUSS
          JSR Read_Hex_Word
          BCC MG3_Err
          LDX #BPTR
          JSR Read_Hex_Word
          BCC MG3_Err
          LDY #0
          RTS
MG3_Err   PLA
          PLA
          JMP Mon_Error

; ***********
  Mon_Compare
; ***********

          JSR Mon_Get_3       ; STAL MEMUSS BPTR
          JSR Mon_Print_CR
MoCo_10   LDA #BPTR
          STA Bank_Fetch+7
          LDA W_Bank
          JSR Bank_Fetch+2    ; LDA (BPTR),Y
          STA Mon_A
          LDA #STAL
          STA Bank_Fetch+7
          JSR Bank_Fetch      ; LDA (STAL),Y
          CMP Mon_A
          BEQ MoCo_20
          JSR Mon_Print_STAL
          JSR Mon_Print_Blank
MoCo_20   JSR Inc_STAL
          JSR Inc_BPTR
          JSR Cmp_STAL_MEMUSS
          BCS MoCo_10
          JMP Mon_Main

; ************
  Mon_Transfer
; ************

          JSR Mon_Get_3       ; STAL MEMUSS BPTR
          LDA BPTR            ; BPTR > STAL ?
          CMP STAL
          LDA BPTR+1
          SBC STAL+1
          BCS MoTr_20         ; BPTR > STAL: copy backward
MoTr_10   JSR Bank_Fetch
          JSR Bank_Store
          JSR Inc_STAL
          JSR Inc_BPTR
          JSR Cmp_STAL_MEMUSS
          BCS MoTr_10
MoTr_Ret  JMP Mon_Main
MoTr_Err  JMP Mon_Error
MoTr_20   SEC
          LDA MEMUSS          ; exchange STAL <-> MEMUSS
          LDX STAL
          STX MEMUSS
          STA STAL
          SBC MEMUSS
          STA Mon_A           ; Mon_A = MEMUSS - STAL
          LDA MEMUSS+1
          LDX STAL+1
          STX MEMUSS+1
          STA STAL+1
          SBC MEMUSS+1
          STA Mon_A+1
          BCC MoTr_Err        ; Error: MEMUSS < STAL
          CLC
          LDA BPTR            ; BPTR += (MEMUSS - STAL)
          ADC Mon_A
          STA BPTR
          LDA BPTR+1
          ADC Mon_A+1
          STA BPTR+1
MoTr_30   JSR Bank_Fetch
          JSR Bank_Store
          JSR Cmp_STAL_MEMUSS ; STAL == MEMUSS -> finished
          BCS MoTr_Ret
          LDA STAL
          BNE MoTr_40
          DEC STAL+1
MoTr_40   DEC STAL
          LDA BPTR
          BNE MoTr_50
          DEC BPTR+1
MoTr_50   DEC BPTR
          JMP MoTr_30

; ********
  Mon_Hunt
; ********

          JSR Mon_Get_Addr    ; get range
          LDY #0
MoHu_10   JSR Mon_CHRIN       ; skip blanks
          BEQ MoHu_Err
          CMP #' '
          BEQ MoHu_10
          CMP #$22            ; quote ?
          BEQ MoHu_40         ; string
          JSR Read_Hex_A      ; get first byte
          BCC MoHu_Err
          BCS MoHu_30         ; continue reading hex
MoHu_20   JSR Read_Hex        ; loop for reading hex bytes
          BCC MoHu_50         ; end of line
MoHu_30   STA DOS_Filename,Y
          INY
          CPY #16
          BCC MoHu_20
          BCS MoHu_50
MoHu_40   JSR Mon_CHRIN       ; loop for reading string
          BEQ MoHu_50
          CMP #$22            ; quote
          BEQ MoHu_50
          STA DOS_Filename,Y
          INY
          CPY #16
          BCC MoHu_40
MoHu_50   STY MONCNT
          JSR Mon_Print_CR
MoHu_60   JSR Check_STOP_Key  ; STOP key pressed?
          BEQ MoHu_Ret
          JSR Mon_Cmp_Addr
          BCC MoHu_Ret
          LDY #0
MoHu_70   JSR Bank_Fetch
          CMP DOS_Filename,Y
          BNE MoHu_80         ; no match
          INY
          CPY MONCNT
          BCC MoHu_70
          JSR Mon_Print_STAL
          JSR Mon_Print_Blank
MoHu_80   JSR Inc_STAL
          BNE MoHu_60
MoHu_Ret  JMP Mon_Main
MoHu_Err  JMP Mon_Error


          .FILL $fd16 - * (0)

; ***********
  Entry_RESET
; ***********

          LDX #$ff
          SEI
          TXS
          CLD
          JSR EDIT_RESET
          LDA #<Basic_Ready
          STA NMINV
          LDA #>Basic_Ready
          STA NMINV+1
          LDA #<MONITOR_BREAK
          STA CBINV
          LDA #>MONITOR_BREAK
          STA CBINV+1
          LDA #<Mon_Error
          STA Reset_Vector
          LDA #>Mon_Error
          STA Reset_Vector+1
          LDA #0
          STA Ignore_Timeout
          CLI
          JMP Init_BASIC_RAM_Vectors

          .FILL $fd49 - * (0)

; *********
  Entry_NMI
; *********

          JMP (NMINV)

; ***********
  Set_FA_to_8
; ***********

          LDX #8
          STX FA
          RTS

; ********
  Mon_Unit
; ********

          JSR Read_Hex
          BCC MoUn_10
          CMP #16
          BCS MoUn_10
          CMP #4
          BCC MoUn_10
          STA Wedge_Unit
MoUn_10   JSR Mon_Print_Blank
          LDA Wedge_Unit
          JSR Print_Hex_Byte
          JSR Mon_Print_CR
          JMP Mon_Main

; ********
  Mon_Next
; ********

          SEI
          LDA #<Mon_Step_IRQ
          STA CINV
          LDA #>Mon_Step_IRQ
          STA CINV+1
          LDA #$a0            ; enable T2 time out interrupt
          STA VIA_IER         ; interrupt enable register
          LDA #47             ; overhead + 1 cycle
          STA VIA_Timer_2_Lo
          LDA #0
          STA VIA_Timer_2_Hi  ; trigger start of timer T2
          JMP Mon_Step

; ************
  Mon_Step_IRQ
; ************

          LDA VIA_IFR
          AND #$20            ; T2 timeout interrupt ?
          BEQ MSI_10
          BIT VIA_Timer_2_Lo  ; clear interrupt
          JMP (CBINV)
MSI_10    JMP IRQ_NORMAL


; ************
  Get_Constant
; ************

          JSR Is_Int
          BCC GeCo_Ret
          CMP #'$'
          BNE GeCo_45
GeCo_10   JSR Mon_CHRIN       ; parse hex constant
          JSR Is_Hex
          BCC GeCo_30
          JSR Hex_To_Bin
          LDX #4
GeCo_20   ASL Mon_Lo
          ROL Mon_Hi
          DEX
          BNE GeCo_20
          ORA Mon_Lo
          STA Mon_Lo
          JMP GeCo_10
GeCo_25   LDX Mon_Tmp
          CPX #'-'
          BNE GeCo_30
          LDX Mon_Hi
          BNE GeCo_Ret        ; no negative 16 bit values
          PHA
          LDA #0
          SBC Mon_Lo          ; carry was set from CPX
          STA Mon_Lo
          PLA
GeCo_30   PHA                 ; push char after constant
          LDA #'$'
          STA Ass_Buf,Y
          INY
          TYA
          CLC
          ADC #16
          TAY
          LDA Mon_Hi
          STA Mon_ZP
          BEQ GeCo_40
          JSR Store_Hex
GeCo_40   LDA Mon_Lo
          JSR Store_Hex
          TYA
          SEC
          SBC #16
          TAY
          PLA                 ; pop char after constant
GeCo_Ret  CMP #CR             ; EOI
          RTS
GeCo_45   STA Mon_Tmp         ; save sign
          CMP #'+'
          BEQ GeCo_70
          CMP #'-'
          BEQ GeCo_70
GeCo_50   LDX Mon_Lo
          STX LINNUM
          LDX Mon_Hi
          STX LINNUM+1
          JSR Dec_Char
          STA Mon_Lo
          LDA LINNUM+1
          STA Mon_Hi
GeCo_70   JSR Mon_CHRIN
          JSR Is_Dec
          BCS GeCo_50
          BCC GeCo_25         ; finished


; **************
  Expand_Address
; **************

          LDY Ass_Buf_Length
ExAd_10   LDA Ass_Buf-1,Y
          CMP #'$'
          BEQ ExAd_20
          STA Ass_Buf+1,Y
          DEY
          BNE ExAd_10
ExAd_20   LDA #'0'
          STA Ass_Buf,Y
          STA Ass_Buf+1,Y
          INC Ass_Buf_Length
          INC Ass_Buf_Length
          RTS

; *************
  Expand_Target
; *************

; Take branch offset, stored in Mon_Lo
; Convert it it to ASCII target of format $xxxx
; Store it in Ass_Buf after the branch mnemonic
; E.g.: BEQ $1234
;       ^   ^    ^
;       0   4    9

          LDA #'$'
          STA Ass_Buf+4
          LDY #21             ; 5 + 16
          JSR Offset_To_Target
          JSR Store_Hex_XA
          LDY #9              ; length of branch instruction
          RTS


; ****************
  Offset_To_Target
; ****************

; Input:  Mon_Lo  = Offset
;         STAL    = PC
; Output: X       = Target Hi
;         A       = Target Lo

          LDX STAL+1
          LDA Mon_Lo
          BPL OTT_10
          DEX
OTT_10    CLC
          ADC STAL
          BCC OTT_20
          INX
OTT_20    CLC
          ADC #2
          BCC OTT_30
          INX
OTT_30    RTS

          .SIZE

; *******
  Replace
; *******

          JSR CHRGOT
          CMP #QUOTE
          BEQ Repl_00
          JSR Tokenize_Line
          JSR CHRGET
Repl_00   STA RENNEW          ; 1st. delimiter
          LDX TXTPTR
Repl_01   INX
          LDA BUF,X
          BEQ Repl_Err
          CMP RENNEW          ; 2nd. delimiter ?
          BNE Repl_01
          STX RENNEW+2        ; remember position
          LDA #0
          STA BUF,X
          TXA
          CLC                 ; subtract one more
          SBC TXTPTR
          STA RENNEW+3        ; length of search string
Repl_02   INX
          LDA BUF,X
          BEQ Repl_Err
          CMP RENNEW          ; 3rd. delimiter ?
          BNE Repl_02
          LDA #0
          STA BUF,X
          TXA
          CLC                 ; subtract one more
          SBC RENNEW+2
          STA RENNEW+4        ; length of replace string
          JSR Reset_Renumber_Pointer
Repl_08   LDY #3
          STY RENNEW+1        ; start position for scan
Repl_10   JSR Check_STOP_Key  ; STOP key pressed?
          BEQ Repl_Ret
          JSR Contains_Pattern
          BNE Repl_20
          JSR Replace_String
          INC RENNEW+1
          JMP Repl_10
Repl_20   JSR Update_Link
          BNE Repl_08
          JSR Reset_Variable_Pointer
Repl_Ret  JMP Basic_Ready
Repl_Err  JMP Syntax_Error


; **************
  Replace_String
; **************

          SEC
          LDA RENNEW+4        ; length of replacement string
          SBC RENNEW+3        ; length of search string
          STA RENNEW          ; difference
          BNE ReSt_30
ReSt_05   TYA
          SEC
          SBC RENNEW+3        ; length of search string
          TAY
          LDX RENNEW+2        ; position of replacement
ReSt_10   INX
          LDA BUF,X
          BEQ ReSt_20
          STA (TMPPTC),Y
          INY
          BNE ReSt_10         ; always
ReSt_20   LDA RENNEW
          BEQ ReSt_25
          JSR Rechain
ReSt_25   JSR List_BASIC_Line
          JSR Mon_Print_CR
          RTS
ReSt_30   BCC ReSt_50
          TYA
          PHA
          LDA TMPPTC
          PHA
          LDA TMPPTC+1
          PHA
          CLC
          TYA
          ADC TMPPTC
          STA TMPPTC
          BCC ReSt_35
          INC TMPPTC+1
ReSt_35   LDA VARTAB          ; search str < replace str
          STA TMPPTB
          ADC RENNEW
          STA TMPPTA
          LDY VARTAB+1
          STY TMPPTB+1
          BCC ReSt_40
          INY
ReSt_40   STY TMPPTA+1
          JSR Open_Up_Space
          LDA STREND
          STA VARTAB
          LDA STREND+1
          STA VARTAB+1
          PLA
          STA TMPPTC+1
          PLA
          STA TMPPTC
ReSt_45   PLA
          TAY
          BNE ReSt_05         ; always
ReSt_50   TYA
          PHA
          ADC TMPPTC
          STA TMPPTA
          LDA TMPPTC+1
          ADC #0
          STA TMPPTA+1
          SEC
          LDA RENNEW+3        ; length of search string
          SBC RENNEW+4        ; length of replacement string
          STA RENNEW
          SEC
          LDA TMPPTA
          SBC RENNEW
          STA TMPPTB
          LDA TMPPTA+1
          SBC #0
          STA TMPPTB+1
          LDY #0
ReSt_60   LDA (TMPPTA),Y
          STA (TMPPTB),Y
          INC TMPPTB
          BNE ReSt_62
          INC TMPPTB+1
ReSt_62   INC TMPPTA
          BNE ReSt_64
          INC TMPPTA+1
ReSt_64   LDA VARTAB
          CMP TMPPTA
          BNE ReSt_60
          LDX VARTAB+1
          CPX TMPPTA+1
          BNE ReSt_60
          SBC RENNEW
          STA VARTAB
          STA STREND
          TXA
          SBC #0
          STA VARTAB+1
          STA STREND+1
          JMP ReSt_45
ReSt_Ret  RTS

          .FILL $ff93-* (0)

; ************
  Basic_CONCAT
; ************

          JMP Kernal_CONCAT

; ***********
  Basic_DOPEN
; ***********

          JMP Kernal_DOPEN

; ************
  Basic_DCLOSE
; ************

          JMP Kernal_DCLOSE

; ************
  Basic_RECORD
; ************

          JMP Kernal_RECORD

; ************
  Basic_HEADER
; ************

          JMP Kernal_HEADER

; *************
  Basic_COLLECT
; *************

          JMP Kernal_COLLECT

; ************
  Basic_BACKUP
; ************

          JMP Kernal_BACKUP

; **********
  Basic_COPY
; **********

          JMP Kernal_COPY

; ************
  Basic_APPEND
; ************

          JMP Kernal_APPEND

; ***********
  Basic_DSAVE
; ***********

          JMP Kernal_DSAVE

; ***********
  Basic_DLOAD
; ***********

          JMP Kernal_DLOAD

; ***************
  Basic_DIRECTORY
; ***************

          JMP Kernal_DIRECTORY

; ************
  Basic_RENAME
; ************

          JMP Kernal_RENAME

; *************
  Basic_SCRATCH
; *************

          JMP Kernal_SCRATCH

; *******
  Read_DS
; *******

          JMP Kernal_Read_DS

; ****
  OPEN
; ****

          JMP Kernal_OPEN

; *****
  CLOSE
; *****

          JMP Kernal_CLOSE

; *****
  CHKIN
; *****

          JMP Kernal_CHKIN

; ******
  CHKOUT
; ******

          JMP Kernal_CHKOUT

; ******
  CLRCHN
; ******

          JMP Kernal_CLRCHN

; *****
  CHRIN
; *****

          JMP Kernal_CHRIN

; ******
  CHROUT
; ******

          JMP Kernal_CHROUT

; **********
  Basic_LOAD
; **********

          JMP Kernal_LOAD

; **********
  Basic_SAVE
; **********

          JMP Kernal_SAVE

; ************
  Basic_VERIFY
; ************

          JMP Kernal_VERIFY

; *********
  Basic_SYS
; *********

          JMP Kernal_SYS

; ****
  STOP
; ****

          JMP Kernal_STOP

; *****
  GETIN
; *****

          JMP Kernal_GETIN

; *****
  CLALL
; *****

          JMP Kernal_CLALL

; *****
  UDTIM
; *****

          JMP Kernal_UDTIM
          .FILL $fffa-* ($8c)

; ***************
  HardwareVectors
; ***************

          .WORD Entry_NMI
          .WORD Entry_RESET
          .WORD IRQ_MAIN
