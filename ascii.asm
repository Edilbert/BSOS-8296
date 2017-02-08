; ***********************************************
; * 4K Character ROM / EPROM for Commodore 8296 *
; ***********************************************

; Use the Bit Shift Assembler "bsa" for assembly of this source

.STORE $E000, $1000, "ascii.eprom"

* = $e000

; *****
  Se000
; *****

    .BITS  . . * * * * . .  ; $00
    .BITS  . * . . . . * .
    .BITS  . . * * * . . .
    .BITS  . . * . . * . .
    .BITS  . . . * * * . .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . * * . . .  ; $01
    .BITS  . . * . . * . .
    .BITS  . * . . . . * .
    .BITS  . * * * * * * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . * * * * * . .  ; $02
    .BITS  . . * . . . * .
    .BITS  . . * . . . * .
    .BITS  . . * * * * . .
    .BITS  . . * . . . * .
    .BITS  . . * . . . * .
    .BITS  . * * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . * * * . .  ; $03
    .BITS  . . * . . . * .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . . * . . . * .
    .BITS  . . . * * * . .
    .BITS  . . . . . . . .

    .BITS  . * * * * . . .  ; $04
    .BITS  . . * . . * . .
    .BITS  . . * . . . * .
    .BITS  . . * . . . * .
    .BITS  . . * . . . * .
    .BITS  . . * . . * . .
    .BITS  . * * * * . . .
    .BITS  . . . . . . . .

    .BITS  . * * * * * * .  ; $05
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .

    .BITS  . * * * * * * .  ; $06
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . * * * . .  ; $07
    .BITS  . . * . . . * .
    .BITS  . * . . . . . .
    .BITS  . * . . * * * .
    .BITS  . * . . . . * .
    .BITS  . . * . . . * .
    .BITS  . . . * * * . .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ; $08
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * * * * * * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . . . * * * . .  ; $09
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . * * * .  ; $0a
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . * . . . * . .
    .BITS  . . * * * . . .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ; $0b
    .BITS  . * . . . * . .
    .BITS  . * . . * . . .
    .BITS  . * * * . . . .
    .BITS  . * . . * . . .
    .BITS  . * . . . * . .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . * . . . . . .  ; $0c
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ; $0d
    .BITS  . * * . . * * .
    .BITS  . * . * * . * .
    .BITS  . * . * * . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ; $0e
    .BITS  . * * . . . * .
    .BITS  . * . * . . * .
    .BITS  . * . . * . * .
    .BITS  . * . . . * * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . . . * * . . .  ; $0f
    .BITS  . . * . . * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * . . * . .
    .BITS  . . . * * . . .
    .BITS  . . . . . . . .

    .BITS  . * * * * * . .  ; $10
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * * * * * . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . * * . . .  ; $11
    .BITS  . . * . . * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . * . * .
    .BITS  . . * . . * . .
    .BITS  . . . * * . * .
    .BITS  . . . . . . . .

    .BITS  . * * * * * . .  ; $12
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * * * * * . .
    .BITS  . * . . * . . .
    .BITS  . * . . . * . .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ; $13
    .BITS  . * . . . . * .
    .BITS  . * . . . . . .
    .BITS  . . * * * * . .
    .BITS  . . . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . * * * * * .  ; $14
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ; $15
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ; $16
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * . . * . .
    .BITS  . . * . . * . .
    .BITS  . . . * * . . .
    .BITS  . . . * * . . .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ; $17
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . * * . * .
    .BITS  . * . * * . * .
    .BITS  . * * . . * * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ; $18
    .BITS  . * . . . . * .
    .BITS  . . * . . * . .
    .BITS  . . . * * . . .
    .BITS  . . * . . * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . . * . . . * .  ; $19
    .BITS  . . * . . . * .
    .BITS  . . * . . . * .
    .BITS  . . . * * * . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .

    .BITS  . * * * * * * .  ; $1a
    .BITS  . . . . . . * .
    .BITS  . . . . . * . .
    .BITS  . . . * * . . .
    .BITS  . . * . . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ; $1b
    .BITS  . . * . . . . .
    .BITS  . . * . . . . .
    .BITS  . . * . . . . .
    .BITS  . . * . . . . .
    .BITS  . . * . . . . .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $1c
    .BITS  . * . . . . . .
    .BITS  . . * . . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . * . .
    .BITS  . . . . . . * .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ; $1d
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . * . . . .  ; $1e
    .BITS  . . * * * . . .
    .BITS  . * . * . * . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $1f
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * * * *

    .BITS  . . . . . . . .  ; $20
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $21
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .

    .BITS  . . * . . * . .  ; $22
    .BITS  . . * . . * . .
    .BITS  . . * . . * . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . * . . * . .  ; $23
    .BITS  . . * . . * . .
    .BITS  . * * * * * * .
    .BITS  . . * . . * . .
    .BITS  . * * * * * * .
    .BITS  . . * . . * . .
    .BITS  . . * . . * . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $24
    .BITS  . . . * * * * .
    .BITS  . . * . * . . .
    .BITS  . . . * * * . .
    .BITS  . . . . * . * .
    .BITS  . . * * * * . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $25
    .BITS  . * * . . . * .
    .BITS  . * * . . * . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  . . * . . * * .
    .BITS  . * . . . * * .
    .BITS  . . . . . . . .

    .BITS  . . * * . . . .  ; $26
    .BITS  . * . . * . . .
    .BITS  . * . . * . . .
    .BITS  . . * * . . . .
    .BITS  . * . . * . * .
    .BITS  . * . . . * . .
    .BITS  . . * * * . * .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $27
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . * . .  ; $28
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . * . .
    .BITS  . . . . . . . .

    .BITS  . . * . . . . .  ; $29
    .BITS  . . . * . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  . . * . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $2a
    .BITS  . . * . * . * .
    .BITS  . . . * * * . .
    .BITS  . . * * * * * .
    .BITS  . . . * * * . .
    .BITS  . . * . * . * .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $2b
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . * * * * * .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $2c
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .

    .BITS  . . . . . . . .  ; $2d
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $2e
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . * * . . .
    .BITS  . . . * * . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $2f
    .BITS  . . . . . . * .
    .BITS  . . . . . * . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  . . * . . . . .
    .BITS  . * . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ; $30
    .BITS  . * . . . . * .
    .BITS  . * . . . * * .
    .BITS  . * . * * . * .
    .BITS  . * * . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $31
    .BITS  . . . * * . . .
    .BITS  . . * . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . * * * * * .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ; $32
    .BITS  . * . . . . * .
    .BITS  . . . . . . * .
    .BITS  . . . . * * . .
    .BITS  . . * * . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ; $33
    .BITS  . * . . . . * .
    .BITS  . . . . . . * .
    .BITS  . . . * * * . .
    .BITS  . . . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . . * . .  ; $34
    .BITS  . . . . * * . .
    .BITS  . . . * . * . .
    .BITS  . . * . . * . .
    .BITS  . * * * * * * .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . . . .

    .BITS  . * * * * * * .  ; $35
    .BITS  . * . . . . . .
    .BITS  . * * * * . . .
    .BITS  . . . . . * . .
    .BITS  . . . . . . * .
    .BITS  . * . . . * . .
    .BITS  . . * * * . . .
    .BITS  . . . . . . . .

    .BITS  . . . * * * . .  ; $36
    .BITS  . . * . . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . * * * * * * .  ; $37
    .BITS  . * . . . . * .
    .BITS  . . . . . * . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ; $38
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ; $39
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * * .
    .BITS  . . . . . . * .
    .BITS  . . . . . * . .
    .BITS  . . * * * . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $3a
    .BITS  . . . . . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $3b
    .BITS  . . . . . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .

    .BITS  . . . . * * * .  ; $3c
    .BITS  . . . * * . . .
    .BITS  . . * * . . . .
    .BITS  . * * . . . . .
    .BITS  . . * * . . . .
    .BITS  . . . * * . . .
    .BITS  . . . . * * * .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $3d
    .BITS  . . . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . * * * . . . .  ; $3e
    .BITS  . . . * * . . .
    .BITS  . . . . * * . .
    .BITS  . . . . . * * .
    .BITS  . . . . * * . .
    .BITS  . . . * * . . .
    .BITS  . * * * . . . .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ; $3f
    .BITS  . * . . . . * .
    .BITS  . . . . . . * .
    .BITS  . . . . * * . .
    .BITS  . . . * . . . .
    .BITS  . . . . . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . . . . .

    .BITS  . . . * . . . .  ; $40
    .BITS  . . . . * . . .
    .BITS  . . . . . * . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  * * * * * * * *  ; $41
    .BITS  . * * * * * * *
    .BITS  . . * * * * * *
    .BITS  . . . * * * * *
    .BITS  . . . . * * * *
    .BITS  . . . . . * * *
    .BITS  . . . . . . * *
    .BITS  . . . . . . . *

    .BITS  * * * * * * * *  ; $42
    .BITS  * * * * * * * *
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $43
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * * * *
    .BITS  * * * * * * * *
    .BITS  * * * * * * * *
    .BITS  * * * * * * * *

    .BITS  . . . . . . . .  ; $44
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . * * * *
    .BITS  . . . . * * * *
    .BITS  . . . . * * * *
    .BITS  . . . . * * * *

    .BITS  . . . . * * * *  ; $45
    .BITS  . . . . * * * *
    .BITS  . . . . * * * *
    .BITS  . . . . * * * *
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $46
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . * . .
    .BITS  . . . . . . * *
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $47
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  * * * . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . * * *  ; $48
    .BITS  . . . . . * * *
    .BITS  . . . . . * * *
    .BITS  . . . . . * * *
    .BITS  . . . . . * * *
    .BITS  . . . . . * * *
    .BITS  . . . . . * * *
    .BITS  . . . . . * * *

    .BITS  * * . . . . . .  ; $49
    .BITS  * * . . . . . .
    .BITS  * * . . . . . .
    .BITS  * * . . . . . .
    .BITS  * * . . . . . .
    .BITS  * * . . . . . .
    .BITS  * * . . . . . .
    .BITS  * * . . . . . .

    .BITS  . . . . . . * *  ; $4a
    .BITS  . . . . . . * *
    .BITS  . . . . . . * *
    .BITS  . . . . . . * *
    .BITS  . . . . . . * *
    .BITS  . . . . . . * *
    .BITS  . . . . . . * *
    .BITS  . . . . . . * *

    .BITS  * . . . . . . .  ; $4b
    .BITS  . * . . . . . .
    .BITS  . . * . . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . * . .
    .BITS  . . . . . . * .
    .BITS  . . . . . . . *

    .BITS  * . . . . . . .  ; $4c
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * * * * * * * *

    .BITS  . . . . . . . *  ; $4d
    .BITS  . . . . . . * .
    .BITS  . . . . . * . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  . . * . . . . .
    .BITS  . * . . . . . .
    .BITS  * . . . . . . .

    .BITS  * * * * * * * *  ; $4e
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  * * * * * * * *  ; $4f
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .

    .BITS  * * * * * * * *  ; $50
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *

    .BITS  * * * * * * * *  ; $51
    .BITS  * * * * * * * .
    .BITS  * * * * * * . .
    .BITS  * * * * * . . .
    .BITS  * * * * . . . .
    .BITS  * * * . . . . .
    .BITS  * * . . . . . .
    .BITS  * . . . . . . .

    .BITS  . . . . . . . .  ; $52
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . * *
    .BITS  . . . . . * . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  . . . . . . . .  ; $53
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .

    .BITS  . . . . . . . .  ; $54
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * . . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  * * * . . . . .  ; $55
    .BITS  * * * . . . . .
    .BITS  * * * . . . . .
    .BITS  * * * . . . . .
    .BITS  * * * . . . . .
    .BITS  * * * . . . . .
    .BITS  * * * . . . . .
    .BITS  * * * . . . . .

    .BITS  * * * * * * * *  ; $56
    .BITS  * * * * * * * *
    .BITS  * * * * * * * *
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  * * * * . . . .  ; $57
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $58
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * * * *
    .BITS  * * * * * * * *
    .BITS  * * * * * * * *

    .BITS  . . . . . . . .  ; $59
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * * * *
    .BITS  * * * * * * * *

    .BITS  * * * * . . . .  ; $5a
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .

    .BITS  . . . . . . . .  ; $5b
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * . * . * . * .
    .BITS  . * . * . * . *
    .BITS  * . * . * . * .
    .BITS  . * . * . * . *

    .BITS  . . . . . . . *  ; $5c
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  * * * * * * * *

    .BITS  * . * . * . * .  ; $5d
    .BITS  . * . * . * . *
    .BITS  * . * . * . * .
    .BITS  . * . * . * . *
    .BITS  * . * . * . * .
    .BITS  . * . * . * . *
    .BITS  * . * . * . * .
    .BITS  . * . * . * . *

    .BITS  . . . . . . . .  ; $5e
    .BITS  . . . . . . . .
    .BITS  . . . . . . . *
    .BITS  . . * * * * * .
    .BITS  . * . * . * . .
    .BITS  . . . * . * . .
    .BITS  . . . * . * . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $5f
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * * * *

    .BITS  . . . . . . . .  ; $60
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $61
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  . . . . * . . .  ; $62
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * * * *
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $63
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  * * * * * * * *
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $64
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  * * * * * . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $65
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * * * *
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  . . . . . . . .  ; $66
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * * * *
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $67
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  * * * * * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  . . . . . . . .  ; $68
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . * * * *
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  . . . . . . . .  ; $69
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * * * *
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  . . . . . . . .  ; $6a
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  . . . . * . . .  ; $6b
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  * * * * * * * *
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  . . . . * . . .  ; $6c
    .BITS  . . . * . . . .
    .BITS  . . * * * * . .
    .BITS  . * . . . . * .
    .BITS  . * * * * * * .
    .BITS  . * . . . . . .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . * * . . .  ; $6d
    .BITS  . . * . . * . .
    .BITS  . . * . . . . .
    .BITS  . * * * . . . .
    .BITS  . . * . . . . .
    .BITS  . . * . . . . *
    .BITS  . * . * * * * .
    .BITS  . . . . . . . .

    .BITS  . . . * . . . .  ; $6e
    .BITS  . . . . * . . .
    .BITS  . . * * * * . .
    .BITS  . * . . . . * .
    .BITS  . * * * * * * .
    .BITS  . * . . . . . .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $6f
    .BITS  . . . * . . . .
    .BITS  . . * . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . * * * . .  ; $70
    .BITS  . . * . . . * .
    .BITS  . * . . * . * .
    .BITS  . * . * . * * .
    .BITS  . * . . * * . .
    .BITS  . . * . . . . .
    .BITS  . . . * * * * .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $71
    .BITS  . . . . . . . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . * * .
    .BITS  * . * * * . * .
    .BITS  * . . . . . . .

    .BITS  . . * . . . . .  ; $72
    .BITS  . . . * . . . .
    .BITS  . . * * * . . .
    .BITS  . . . . . * . .
    .BITS  . . * * * * . .
    .BITS  . * . . . * . .
    .BITS  . . * * * . * .
    .BITS  . . . . . . . .

    .BITS  . . . * . . . .  ; $73
    .BITS  . . . . * . . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . * * .
    .BITS  . . * * * . * .
    .BITS  . . . . . . . .

    .BITS  . . . * . . . .  ; $74
    .BITS  . . * . * . . .
    .BITS  . . * * * . . .
    .BITS  . . . . . * . .
    .BITS  . . * * * * . .
    .BITS  . * . . . * . .
    .BITS  . . * * * . * .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $75
    .BITS  . . . * . * . .
    .BITS  . . * * * * . .
    .BITS  . * . . . . * .
    .BITS  . * * * * * * .
    .BITS  . * . . . . . .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $76
    .BITS  . . . * . * . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $77
    .BITS  . . . * . * . .
    .BITS  . . * * * * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $78
    .BITS  . . . * . * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . * * .
    .BITS  . . * * * . * .
    .BITS  . . . . . . . .

    .BITS  . . . * * * * *  ; $79
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  * * . * . . . .
    .BITS  . . * * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . . . . .

    .BITS  . * * * * * * *  ; $7a
    .BITS  . . * . . . . *
    .BITS  . . . * . . . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  . . * . . . . *
    .BITS  . * * * * * * *
    .BITS  . . . . . . . .

    .BITS  . * . * * . * .  ; $7b
    .BITS  . . * . . * . .
    .BITS  . * . . . . * .
    .BITS  . * * * * * * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . * . * * . * .  ; $7c
    .BITS  . . * . . * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * . . * . .
    .BITS  . . . * * . . .
    .BITS  . . . . . . . .

    .BITS  . . . * * . . .  ; $7d
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ; $7e
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . * * * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . * * * . .
    .BITS  . * . . . . . .

    .BITS  . . . . * . . .  ; $7f
    .BITS  . . . * . * . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . * * * . .  ; $80
    .BITS  . . * . . . * .
    .BITS  . * . . * . * .
    .BITS  . * . * . * * .
    .BITS  . * . . * * . .
    .BITS  . . * . . . . .
    .BITS  . . . * * * * .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $81
    .BITS  . . . . . . . .
    .BITS  . . * * * . . .
    .BITS  . . . . . * . .
    .BITS  . . * * * * . .
    .BITS  . * . . . * . .
    .BITS  . . * * * . * .
    .BITS  . . . . . . . .

    .BITS  . * . . . . . .  ; $82
    .BITS  . * . . . . . .
    .BITS  . * . * * * . .
    .BITS  . * * . . . * .
    .BITS  . * . . . . * .
    .BITS  . * * . . . * .
    .BITS  . * . * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $83
    .BITS  . . . . . . . .
    .BITS  . . * * * * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . . .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . * .  ; $84
    .BITS  . . . . . . * .
    .BITS  . . * * * . * .
    .BITS  . * . . . * * .
    .BITS  . * . . . . * .
    .BITS  . * . . . * * .
    .BITS  . . * * * . * .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $85
    .BITS  . . . . . . . .
    .BITS  . . * * * * . .
    .BITS  . * . . . . * .
    .BITS  . * * * * * * .
    .BITS  . * . . . . . .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . * * . .  ; $86
    .BITS  . . . * . . * .
    .BITS  . . . * . . . .
    .BITS  . * * * * * . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $87
    .BITS  . . . . . . . .
    .BITS  . . * * * . * .
    .BITS  . * . . . * * .
    .BITS  . * . . . * * .
    .BITS  . . * * * . * .
    .BITS  . . . . . . * .
    .BITS  . . * * * * . .

    .BITS  . * . . . . . .  ; $88
    .BITS  . * . . . . . .
    .BITS  . * . * * * . .
    .BITS  . * * . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $89
    .BITS  . . . . . . . .
    .BITS  . . . * * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . . * . .  ; $8a
    .BITS  . . . . . . . .
    .BITS  . . . . * * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . * . . . * . .
    .BITS  . . * * * . . .

    .BITS  . * . . . . . .  ; $8b
    .BITS  . * . . . . . .
    .BITS  . * . . . * . .
    .BITS  . * . . * . . .
    .BITS  . * . * . . . .
    .BITS  . * * . * . . .
    .BITS  . * . . . * . .
    .BITS  . . . . . . . .

    .BITS  . . . * * . . .  ; $8c
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $8d
    .BITS  . . . . . . . .
    .BITS  . * * * . * * .
    .BITS  . * . . * . . *
    .BITS  . * . . * . . *
    .BITS  . * . . * . . *
    .BITS  . * . . * . . *
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $8e
    .BITS  . . . . . . . .
    .BITS  . * . * * * . .
    .BITS  . * * . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $8f
    .BITS  . . . . . . . .
    .BITS  . . * * * * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $90
    .BITS  . . . . . . . .
    .BITS  . * . * * * . .
    .BITS  . * * . . . * .
    .BITS  . * * . . . * .
    .BITS  . * . * * * . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .

    .BITS  . . . . . . . .  ; $91
    .BITS  . . . . . . . .
    .BITS  . . * * * . * .
    .BITS  . * . . . * * .
    .BITS  . * . . . * * .
    .BITS  . . * * * . * .
    .BITS  . . . . . . * .
    .BITS  . . . . . . * .

    .BITS  . . . . . . . .  ; $92
    .BITS  . . . . . . . .
    .BITS  . * . * * * . .
    .BITS  . * * . . . * .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $93
    .BITS  . . . . . . . .
    .BITS  . . * * * * * .
    .BITS  . * . . . . . .
    .BITS  . . * * * * . .
    .BITS  . . . . . . * .
    .BITS  . * * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . * . . . .  ; $94
    .BITS  . . . * . . . .
    .BITS  . * * * * * . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . * .
    .BITS  . . . . * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $95
    .BITS  . . . . . . . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . * * .
    .BITS  . . * * * . * .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $96
    .BITS  . . . . . . . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * . . * . .
    .BITS  . . . * * . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $97
    .BITS  . . . . . . . .
    .BITS  . * . . . . . *
    .BITS  . * . . * . . *
    .BITS  . * . . * . . *
    .BITS  . * . . * . . *
    .BITS  . . * * . * * .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $98
    .BITS  . . . . . . . .
    .BITS  . * . . . . * .
    .BITS  . . * . . * . .
    .BITS  . . . * * . . .
    .BITS  . . * . . * . .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $99
    .BITS  . . . . . . . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . * * .
    .BITS  . . * * * . * .
    .BITS  . . . . . . * .
    .BITS  . . * * * * . .

    .BITS  . . . . . . . .  ; $9a
    .BITS  . . . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . * . .
    .BITS  . . . * * . . .
    .BITS  . . * . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ; $9b
    .BITS  . . * . . . . .
    .BITS  . . * . . . . .
    .BITS  . . * . . . . .
    .BITS  . . * . . . . .
    .BITS  . . * . . . . .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $9c
    .BITS  . * . . . . . .
    .BITS  . . * . . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . * . .
    .BITS  . . . . . . * .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ; $9d
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . * . . . .  ; $9e
    .BITS  . . * . * . . .
    .BITS  . * . . . * . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $9f
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * * * *

    .BITS  . . . . . . . .  ; $a0
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $a1
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .

    .BITS  . . * . . * . .  ; $a2
    .BITS  . . * . . * . .
    .BITS  . . * . . * . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . * . . * . .  ; $a3
    .BITS  . . * . . * . .
    .BITS  . * * * * * * .
    .BITS  . . * . . * . .
    .BITS  . * * * * * * .
    .BITS  . . * . . * . .
    .BITS  . . * . . * . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $a4
    .BITS  . . . * * * * .
    .BITS  . . * . * . . .
    .BITS  . . . * * * . .
    .BITS  . . . . * . * .
    .BITS  . . * * * * . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $a5
    .BITS  . * * . . . * .
    .BITS  . * * . . * . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  . . * . . * * .
    .BITS  . * . . . * * .
    .BITS  . . . . . . . .

    .BITS  . . * * . . . .  ; $a6
    .BITS  . * . . * . . .
    .BITS  . * . . * . . .
    .BITS  . . * * . . . .
    .BITS  . * . . * . * .
    .BITS  . * . . . * . .
    .BITS  . . * * * . * .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $a7
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . * . .  ; $a8
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . * . .
    .BITS  . . . . . . . .

    .BITS  . . * . . . . .  ; $a9
    .BITS  . . . * . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  . . * . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $aa
    .BITS  . . * . * . * .
    .BITS  . . . * * * . .
    .BITS  . . * * * * * .
    .BITS  . . . * * * . .
    .BITS  . . * . * . * .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $ab
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . * * * * * .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $ac
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .

    .BITS  . . . . . . . .  ; $ad
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $ae
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . * * . . .
    .BITS  . . . * * . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $af
    .BITS  . . . . . . * .
    .BITS  . . . . . * . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  . . * . . . . .
    .BITS  . * . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ; $b0
    .BITS  . * . . . . * .
    .BITS  . * . . . * * .
    .BITS  . * . * * . * .
    .BITS  . * * . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $b1
    .BITS  . . . * * . . .
    .BITS  . . * . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . * * * * * .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ; $b2
    .BITS  . * . . . . * .
    .BITS  . . . . . . * .
    .BITS  . . . . * * . .
    .BITS  . . * * . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ; $b3
    .BITS  . * . . . . * .
    .BITS  . . . . . . * .
    .BITS  . . . * * * . .
    .BITS  . . . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . . * . .  ; $b4
    .BITS  . . . . * * . .
    .BITS  . . . * . * . .
    .BITS  . . * . . * . .
    .BITS  . * * * * * * .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . . . .

    .BITS  . * * * * * * .  ; $b5
    .BITS  . * . . . . . .
    .BITS  . * * * * . . .
    .BITS  . . . . . * . .
    .BITS  . . . . . . * .
    .BITS  . * . . . * . .
    .BITS  . . * * * . . .
    .BITS  . . . . . . . .

    .BITS  . . . * * * . .  ; $b6
    .BITS  . . * . . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . * * * * * * .  ; $b7
    .BITS  . * . . . . * .
    .BITS  . . . . . * . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ; $b8
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ; $b9
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * * .
    .BITS  . . . . . . * .
    .BITS  . . . . . * . .
    .BITS  . . * * * . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $ba
    .BITS  . . . . . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $bb
    .BITS  . . . . . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .

    .BITS  . . . . * * * .  ; $bc
    .BITS  . . . * * . . .
    .BITS  . . * * . . . .
    .BITS  . * * . . . . .
    .BITS  . . * * . . . .
    .BITS  . . . * * . . .
    .BITS  . . . . * * * .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $bd
    .BITS  . . . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . * * * . . . .  ; $be
    .BITS  . . . * * . . .
    .BITS  . . . . * * . .
    .BITS  . . . . . * * .
    .BITS  . . . . * * . .
    .BITS  . . . * * . . .
    .BITS  . * * * . . . .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ; $bf
    .BITS  . * . . . . * .
    .BITS  . . . . . . * .
    .BITS  . . . . * * . .
    .BITS  . . . * . . . .
    .BITS  . . . . . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . . . . .

    .BITS  . . . * . . . .  ; $c0
    .BITS  . . . . * . . .
    .BITS  . . . . . * . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . * * . . .  ; $c1
    .BITS  . . * . . * . .
    .BITS  . * . . . . * .
    .BITS  . * * * * * * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . * * * * * . .  ; $c2
    .BITS  . . * . . . * .
    .BITS  . . * . . . * .
    .BITS  . . * * * * . .
    .BITS  . . * . . . * .
    .BITS  . . * . . . * .
    .BITS  . * * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . * * * . .  ; $c3
    .BITS  . . * . . . * .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . . * . . . * .
    .BITS  . . . * * * . .
    .BITS  . . . . . . . .

    .BITS  . * * * * . . .  ; $c4
    .BITS  . . * . . * . .
    .BITS  . . * . . . * .
    .BITS  . . * . . . * .
    .BITS  . . * . . . * .
    .BITS  . . * . . * . .
    .BITS  . * * * * . . .
    .BITS  . . . . . . . .

    .BITS  . * * * * * * .  ; $c5
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .

    .BITS  . * * * * * * .  ; $c6
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . * * * . .  ; $c7
    .BITS  . . * . . . * .
    .BITS  . * . . . . . .
    .BITS  . * . . * * * .
    .BITS  . * . . . . * .
    .BITS  . . * . . . * .
    .BITS  . . . * * * . .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ; $c8
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * * * * * * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . . . * * * . .  ; $c9
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . * * * .  ; $ca
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . * . . . * . .
    .BITS  . . * * * . . .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ; $cb
    .BITS  . * . . . * . .
    .BITS  . * . . * . . .
    .BITS  . * * * . . . .
    .BITS  . * . . * . . .
    .BITS  . * . . . * . .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . * . . . . . .  ; $cc
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ; $cd
    .BITS  . * * . . * * .
    .BITS  . * . * * . * .
    .BITS  . * . * * . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ; $ce
    .BITS  . * * . . . * .
    .BITS  . * . * . . * .
    .BITS  . * . . * . * .
    .BITS  . * . . . * * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . . . * * . . .  ; $cf
    .BITS  . . * . . * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * . . * . .
    .BITS  . . . * * . . .
    .BITS  . . . . . . . .

    .BITS  . * * * * * . .  ; $d0
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * * * * * . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . * * . . .  ; $d1
    .BITS  . . * . . * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . * . * .
    .BITS  . . * . . * . .
    .BITS  . . . * * . * .
    .BITS  . . . . . . . .

    .BITS  . * * * * * . .  ; $d2
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * * * * * . .
    .BITS  . * . . * . . .
    .BITS  . * . . . * . .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ; $d3
    .BITS  . * . . . . * .
    .BITS  . * . . . . . .
    .BITS  . . * * * * . .
    .BITS  . . . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . * * * * * .  ; $d4
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ; $d5
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ; $d6
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * . . * . .
    .BITS  . . * . . * . .
    .BITS  . . . * * . . .
    .BITS  . . . * * . . .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ; $d7
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . * * . * .
    .BITS  . * . * * . * .
    .BITS  . * * . . * * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ; $d8
    .BITS  . * . . . . * .
    .BITS  . . * . . * . .
    .BITS  . . . * * . . .
    .BITS  . . * . . * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . . * . . . * .  ; $d9
    .BITS  . . * . . . * .
    .BITS  . . * . . . * .
    .BITS  . . . * * * . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .

    .BITS  . * * * * * * .  ; $da
    .BITS  . . . . . . * .
    .BITS  . . . . . * . .
    .BITS  . . . * * . . .
    .BITS  . . * . . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .

    .BITS  . . . . * * . .  ; $db
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . * . . . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $dc
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .

    .BITS  . . * * . . . .  ; $dd
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . * . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . * * . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $de
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . * * . . * .
    .BITS  . * . . * * . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $df
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * * * *

    .BITS  . . . . . . . .  ; $e0
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $e1
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  . . . . * . . .  ; $e2
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * * * *
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $e3
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  * * * * * * * *
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $e4
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  * * * * * . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $e5
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * * * *
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  . . . . . . . .  ; $e6
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * * * *
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $e7
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  * * * * * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  . . . . . . . .  ; $e8
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . * * * *
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  . . . . . . . .  ; $e9
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * * * *
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  . . . . . . . .  ; $ea
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  . . . . * . . .  ; $eb
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  * * * * * * * *
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  . . . . * . . .  ; $ec
    .BITS  . . . * . . . .
    .BITS  . . * * * * . .
    .BITS  . * . . . . * .
    .BITS  . * * * * * * .
    .BITS  . * . . . . . .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . * * . . .  ; $ed
    .BITS  . . * . . * . .
    .BITS  . . * . . . . .
    .BITS  . * * * . . . .
    .BITS  . . * . . . . .
    .BITS  . . * . . . . *
    .BITS  . * . * * * * .
    .BITS  . . . . . . . .

    .BITS  . . . * . . . .  ; $ee
    .BITS  . . . . * . . .
    .BITS  . . * * * * . .
    .BITS  . * . . . . * .
    .BITS  . * * * * * * .
    .BITS  . * . . . . . .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $ef
    .BITS  . . . * . . . .
    .BITS  . . * . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . * * * . .  ; $f0
    .BITS  . . * . . . * .
    .BITS  . * . . * . * .
    .BITS  . * . * . * * .
    .BITS  . * . . * * . .
    .BITS  . . * . . . . .
    .BITS  . . . * * * * .
    .BITS  . . . . . . . .

    .BITS  . * . * * . * .  ; $f1
    .BITS  . . * . . * . .
    .BITS  . * . . . . * .
    .BITS  . * * * * * * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . * . * * . * .  ; $f2
    .BITS  . . * . . * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * . . * . .
    .BITS  . . . * * . . .
    .BITS  . . . . . . . .

    .BITS  . . . * * . . .  ; $f3
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ; $f4
    .BITS  . . . . . . . .
    .BITS  . . . . . . . *
    .BITS  . . * * * * * .
    .BITS  . * . * . * . .
    .BITS  . . . * . * . .
    .BITS  . . . * . * . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $f5
    .BITS  . . . * . * . .
    .BITS  . . * * * * . .
    .BITS  . * . . . . * .
    .BITS  . * * * * * * .
    .BITS  . * . . . . . .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $f6
    .BITS  . . . * . * . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $f7
    .BITS  . . . * . * . .
    .BITS  . . * * * * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ; $f8
    .BITS  . . . * . * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . * * .
    .BITS  . . * * * . * .
    .BITS  . . . . . . . .

    .BITS  . . . * * * * *  ; $f9
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  * * . * . . . .
    .BITS  . . * * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . . . . .

    .BITS  . * * * * * * *  ; $fa
    .BITS  . . * . . . . *
    .BITS  . . . * . . . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  . . * . . . . *
    .BITS  . * * * * * * *
    .BITS  . . . . . . . .

    .BITS  . . * . . * . .  ; $fb
    .BITS  . . . . . . . .
    .BITS  . . * * * . . .
    .BITS  . . . . . * . .
    .BITS  . . * * * * . .
    .BITS  . * . . . * . .
    .BITS  . . * * * . * .
    .BITS  . . . . . . . .

    .BITS  . . * . . * . .  ; $fc
    .BITS  . . . . . . . .
    .BITS  . . * * * * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . * . . * . .  ; $fd
    .BITS  . . . . . . . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . * * .
    .BITS  . . * * * . * .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ; $fe
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . * * * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . * * * . .
    .BITS  . * . . . . . .

    .BITS  . . . . * . . .  ; $ff
    .BITS  . . . * . * . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . * * * . .  ;
    .BITS  . . * . . . * .
    .BITS  . * . . * . * .
    .BITS  . * . * . * * .
    .BITS  . * . . * * . .
    .BITS  . . * . . . . .
    .BITS  . . . * * * * .
    .BITS  . . . . . . . .

    .BITS  . . . * * . . .  ;
    .BITS  . . * . . * . .
    .BITS  . * . . . . * .
    .BITS  . * * * * * * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . * * * * * . .  ;
    .BITS  . . * . . . * .
    .BITS  . . * . . . * .
    .BITS  . . * * * * . .
    .BITS  . . * . . . * .
    .BITS  . . * . . . * .
    .BITS  . * * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . * * * . .  ;
    .BITS  . . * . . . * .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . . * . . . * .
    .BITS  . . . * * * . .
    .BITS  . . . . . . . .

    .BITS  . * * * * . . .  ;
    .BITS  . . * . . * . .
    .BITS  . . * . . . * .
    .BITS  . . * . . . * .
    .BITS  . . * . . . * .
    .BITS  . . * . . * . .
    .BITS  . * * * * . . .
    .BITS  . . . . . . . .

    .BITS  . * * * * * * .  ;
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .

    .BITS  . * * * * * * .  ;
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . * * * . .  ;
    .BITS  . . * . . . * .
    .BITS  . * . . . . . .
    .BITS  . * . . * * * .
    .BITS  . * . . . . * .
    .BITS  . . * . . . * .
    .BITS  . . . * * * . .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ;
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * * * * * * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . . . * * * . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . * * * .  ;
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . * . . . * . .
    .BITS  . . * * * . . .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ;
    .BITS  . * . . . * . .
    .BITS  . * . . * . . .
    .BITS  . * * * . . . .
    .BITS  . * . . * . . .
    .BITS  . * . . . * . .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . * . . . . . .  ;
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ;
    .BITS  . * * . . * * .
    .BITS  . * . * * . * .
    .BITS  . * . * * . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ;
    .BITS  . * * . . . * .
    .BITS  . * . * . . * .
    .BITS  . * . . * . * .
    .BITS  . * . . . * * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . . . * * . . .  ;
    .BITS  . . * . . * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * . . * . .
    .BITS  . . . * * . . .
    .BITS  . . . . . . . .

    .BITS  . * * * * * . .  ;
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * * * * * . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . * * . . .  ;
    .BITS  . . * . . * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . * . * .
    .BITS  . . * . . * . .
    .BITS  . . . * * . * .
    .BITS  . . . . . . . .

    .BITS  . * * * * * . .  ;
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * * * * * . .
    .BITS  . * . . * . . .
    .BITS  . * . . . * . .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ;
    .BITS  . * . . . . * .
    .BITS  . * . . . . . .
    .BITS  . . * * * * . .
    .BITS  . . . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . * * * * * .  ;
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ;
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ;
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * . . * . .
    .BITS  . . * . . * . .
    .BITS  . . . * * . . .
    .BITS  . . . * * . . .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ;
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . * * . * .
    .BITS  . * . * * . * .
    .BITS  . * * . . * * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ;
    .BITS  . * . . . . * .
    .BITS  . . * . . * . .
    .BITS  . . . * * . . .
    .BITS  . . * . . * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . . * . . . * .  ;
    .BITS  . . * . . . * .
    .BITS  . . * . . . * .
    .BITS  . . . * * * . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .

    .BITS  . * * * * * * .  ;
    .BITS  . . . . . . * .
    .BITS  . . . . . * . .
    .BITS  . . . * * . . .
    .BITS  . . * . . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ;
    .BITS  . . * . . . . .
    .BITS  . . * . . . . .
    .BITS  . . * . . . . .
    .BITS  . . * . . . . .
    .BITS  . . * . . . . .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . * . . . . . .
    .BITS  . . * . . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . * . .
    .BITS  . . . . . . * .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ;
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . * * * . .
    .BITS  . . * . * . * .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . * . . . .
    .BITS  . . * . . . . .
    .BITS  . * * * * * * *
    .BITS  . . * . . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .

    .BITS  . . * . . * . .  ;
    .BITS  . . * . . * . .
    .BITS  . . * . . * . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . * . . * . .  ;
    .BITS  . . * . . * . .
    .BITS  . * * * * * * .
    .BITS  . . * . . * . .
    .BITS  . * * * * * * .
    .BITS  . . * . . * . .
    .BITS  . . * . . * . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ;
    .BITS  . . . * * * * .
    .BITS  . . * . * . . .
    .BITS  . . . * * * . .
    .BITS  . . . . * . * .
    .BITS  . . * * * * . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . * * . . . * .
    .BITS  . * * . . * . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  . . * . . * * .
    .BITS  . * . . . * * .
    .BITS  . . . . . . . .

    .BITS  . . * * . . . .  ;
    .BITS  . * . . * . . .
    .BITS  . * . . * . . .
    .BITS  . . * * . . . .
    .BITS  . * . . * . * .
    .BITS  . * . . . * . .
    .BITS  . . * * * . * .
    .BITS  . . . . . . . .

    .BITS  . . . . . * . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . * . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . * . .
    .BITS  . . . . . . . .

    .BITS  . . * . . . . .  ;
    .BITS  . . . * . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  . . * . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ;
    .BITS  . . * . * . * .
    .BITS  . . . * * * . .
    .BITS  . . * * * * * .
    .BITS  . . . * * * . .
    .BITS  . . * . * . * .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . * * * * * .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . * * . . .
    .BITS  . . . * * . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . * .
    .BITS  . . . . . * . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  . . * . . . . .
    .BITS  . * . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ;
    .BITS  . * . . . . * .
    .BITS  . * . . . * * .
    .BITS  . * . * * . * .
    .BITS  . * * . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ;
    .BITS  . . . * * . . .
    .BITS  . . * . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . * * * * * .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ;
    .BITS  . * . . . . * .
    .BITS  . . . . . . * .
    .BITS  . . . . * * . .
    .BITS  . . * * . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ;
    .BITS  . * . . . . * .
    .BITS  . . . . . . * .
    .BITS  . . . * * * . .
    .BITS  . . . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . . * . .  ;
    .BITS  . . . . * * . .
    .BITS  . . . * . * . .
    .BITS  . . * . . * . .
    .BITS  . * * * * * * .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . . . .

    .BITS  . * * * * * * .  ;
    .BITS  . * . . . . . .
    .BITS  . * * * * . . .
    .BITS  . . . . . * . .
    .BITS  . . . . . . * .
    .BITS  . * . . . * . .
    .BITS  . . * * * . . .
    .BITS  . . . . . . . .

    .BITS  . . . * * * . .  ;
    .BITS  . . * . . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . * * * * * * .  ;
    .BITS  . * . . . . * .
    .BITS  . . . . . * . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ;
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ;
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * * .
    .BITS  . . . . . . * .
    .BITS  . . . . . * . .
    .BITS  . . * * * . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .

    .BITS  . . . . * * * .  ;
    .BITS  . . . * * . . .
    .BITS  . . * * . . . .
    .BITS  . * * . . . . .
    .BITS  . . * * . . . .
    .BITS  . . . * * . . .
    .BITS  . . . . * * * .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . * * * . . . .  ;
    .BITS  . . . * * . . .
    .BITS  . . . . * * . .
    .BITS  . . . . . * * .
    .BITS  . . . . * * . .
    .BITS  . . . * * . . .
    .BITS  . * * * . . . .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ;
    .BITS  . * . . . . * .
    .BITS  . . . . . . * .
    .BITS  . . . . * * . .
    .BITS  . . . * . . . .
    .BITS  . . . . . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * * * *
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ;
    .BITS  . . . * * * . .
    .BITS  . . * * * * * .
    .BITS  . * * * * * * *
    .BITS  . * * * * * * *
    .BITS  . . . * * * . .
    .BITS  . . * * * * * .
    .BITS  . . . . . . . .

    .BITS  . . . * . . . .  ;
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * * * *
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  * * * * * * * *
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  * * * * * * * *
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * * * *
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . * . . . . .  ;
    .BITS  . . * . . . . .
    .BITS  . . * . . . . .
    .BITS  . . * . . . . .
    .BITS  . . * . . . . .
    .BITS  . . * . . . . .
    .BITS  . . * . . . . .
    .BITS  . . * . . . . .

    .BITS  . . . . . * . .  ;
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * . . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  . . . . * . . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . * . .
    .BITS  . . . . . . * *
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  * * * . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  * . . . . . . .  ;
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * * * * * * * *

    .BITS  * . . . . . . .  ;
    .BITS  . * . . . . . .
    .BITS  . . * . . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . * . .
    .BITS  . . . . . . * .
    .BITS  . . . . . . . *

    .BITS  . . . . . . . *  ;
    .BITS  . . . . . . * .
    .BITS  . . . . . * . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  . . * . . . . .
    .BITS  . * . . . . . .
    .BITS  * . . . . . . .

    .BITS  * * * * * * * *  ;
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .

    .BITS  * * * * * * * *  ;
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *

    .BITS  . . . . . . . .  ;
    .BITS  . . * * * * . .
    .BITS  . * * * * * * .
    .BITS  . * * * * * * .
    .BITS  . * * * * * * .
    .BITS  . * * * * * * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * * * *
    .BITS  . . . . . . . .

    .BITS  . . * * . * * .  ;
    .BITS  . * * * * * * *
    .BITS  . * * * * * * *
    .BITS  . * * * * * * *
    .BITS  . . * * * * * .
    .BITS  . . . * * * . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .

    .BITS  . * . . . . . .  ;
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . * *
    .BITS  . . . . . * . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  * . . . . . . *  ;
    .BITS  . * . . . . * .
    .BITS  . . * . . * . .
    .BITS  . . . * * . . .
    .BITS  . . . * * . . .
    .BITS  . . * . . * . .
    .BITS  . * . . . . * .
    .BITS  * . . . . . . *

    .BITS  . . . . . . . .  ;
    .BITS  . . * * * * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ;
    .BITS  . . . * * * . .
    .BITS  . . * . * . * .
    .BITS  . * * * . * * *
    .BITS  . . * . * . * .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . * .  ;
    .BITS  . . . . . . * .
    .BITS  . . . . . . * .
    .BITS  . . . . . . * .
    .BITS  . . . . . . * .
    .BITS  . . . . . . * .
    .BITS  . . . . . . * .
    .BITS  . . . . . . * .

    .BITS  . . . . * . . .  ;
    .BITS  . . . * * * . .
    .BITS  . . * * * * * .
    .BITS  . * * * * * * *
    .BITS  . . * * * * * .
    .BITS  . . . * * * . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  * * * * * * * *
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  * . * . . . . .  ;
    .BITS  . * . * . . . .
    .BITS  * . * . . . . .
    .BITS  . * . * . . . .
    .BITS  * . * . . . . .
    .BITS  . * . * . . . .
    .BITS  * . * . . . . .
    .BITS  . * . * . . . .

    .BITS  . . . . * . . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . *
    .BITS  . . * * * * * .
    .BITS  . * . * . * . .
    .BITS  . . . * . * . .
    .BITS  . . . * . * . .
    .BITS  . . . . . . . .

    .BITS  * * * * * * * *  ;
    .BITS  . * * * * * * *
    .BITS  . . * * * * * *
    .BITS  . . . * * * * *
    .BITS  . . . . * * * *
    .BITS  . . . . . * * *
    .BITS  . . . . . . * *
    .BITS  . . . . . . . *

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  * * * * . . . .  ;
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * * * *
    .BITS  * * * * * * * *
    .BITS  * * * * * * * *
    .BITS  * * * * * * * *

    .BITS  * * * * * * * *  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * * * *

    .BITS  * . . . . . . .  ;
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .

    .BITS  * . * . * . * .  ;
    .BITS  . * . * . * . *
    .BITS  * . * . * . * .
    .BITS  . * . * . * . *
    .BITS  * . * . * . * .
    .BITS  . * . * . * . *
    .BITS  * . * . * . * .
    .BITS  . * . * . * . *

    .BITS  . . . . . . . *  ;
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * . * . * . * .
    .BITS  . * . * . * . *
    .BITS  * . * . * . * .
    .BITS  . * . * . * . *

    .BITS  * * * * * * * *  ;
    .BITS  * * * * * * * .
    .BITS  * * * * * * . .
    .BITS  * * * * * . . .
    .BITS  * * * * . . . .
    .BITS  * * * . . . . .
    .BITS  * * . . . . . .
    .BITS  * . . . . . . .

    .BITS  . . . . . . * *  ;
    .BITS  . . . . . . * *
    .BITS  . . . . . . * *
    .BITS  . . . . . . * *
    .BITS  . . . . . . * *
    .BITS  . . . . . . * *
    .BITS  . . . . . . * *
    .BITS  . . . . . . * *

    .BITS  . . . . * . . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * * * *
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . * * * *
    .BITS  . . . . * * * *
    .BITS  . . . . * * * *
    .BITS  . . . . * * * *

    .BITS  . . . . * . . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * * * *
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * * * *
    .BITS  * * * * * * * *

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . * * * *
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  . . . . * . . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  * * * * * * * *
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * * * *
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  . . . . * . . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  * * * * * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  * * . . . . . .  ;
    .BITS  * * . . . . . .
    .BITS  * * . . . . . .
    .BITS  * * . . . . . .
    .BITS  * * . . . . . .
    .BITS  * * . . . . . .
    .BITS  * * . . . . . .
    .BITS  * * . . . . . .

    .BITS  * * * . . . . .  ;
    .BITS  * * * . . . . .
    .BITS  * * * . . . . .
    .BITS  * * * . . . . .
    .BITS  * * * . . . . .
    .BITS  * * * . . . . .
    .BITS  * * * . . . . .
    .BITS  * * * . . . . .

    .BITS  . . . . . * * *  ;
    .BITS  . . . . . * * *
    .BITS  . . . . . * * *
    .BITS  . . . . . * * *
    .BITS  . . . . . * * *
    .BITS  . . . . . * * *
    .BITS  . . . . . * * *
    .BITS  . . . . . * * *

    .BITS  * * * * * * * *  ;
    .BITS  * * * * * * * *
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  * * * * * * * *  ;
    .BITS  * * * * * * * *
    .BITS  * * * * * * * *
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * * * *
    .BITS  * * * * * * * *
    .BITS  * * * * * * * *

    .BITS  . . . . . . . *  ;
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  * * * * * * * *

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .

    .BITS  . . . . * * * *  ;
    .BITS  . . . . * * * *
    .BITS  . . . . * * * *
    .BITS  . . . . * * * *
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  * * * * * . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  * * * * . . . .  ;
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  * * * * . . . .  ;
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  . . . . * * * *
    .BITS  . . . . * * * *
    .BITS  . . . . * * * *
    .BITS  . . . . * * * *

    .BITS  . . . * * * . .  ;
    .BITS  . . * . . . * .
    .BITS  . * . . * . * .
    .BITS  . * . * . * * .
    .BITS  . * . . * * . .
    .BITS  . . * . . . . .
    .BITS  . . . * * * * .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . * * * . . .
    .BITS  . . . . . * . .
    .BITS  . . * * * * . .
    .BITS  . * . . . * . .
    .BITS  . . * * * . * .
    .BITS  . . . . . . . .

    .BITS  . * . . . . . .  ;
    .BITS  . * . . . . . .
    .BITS  . * . * * * . .
    .BITS  . * * . . . * .
    .BITS  . * . . . . * .
    .BITS  . * * . . . * .
    .BITS  . * . * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . * * * * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . . .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . * .  ;
    .BITS  . . . . . . * .
    .BITS  . . * * * . * .
    .BITS  . * . . . * * .
    .BITS  . * . . . . * .
    .BITS  . * . . . * * .
    .BITS  . . * * * . * .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . * * * * . .
    .BITS  . * . . . . * .
    .BITS  . * * * * * * .
    .BITS  . * . . . . . .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . * * . .  ;
    .BITS  . . . * . . * .
    .BITS  . . . * . . . .
    .BITS  . * * * * * . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . * * * . * .
    .BITS  . * . . . * * .
    .BITS  . * . . . * * .
    .BITS  . . * * * . * .
    .BITS  . . . . . . * .
    .BITS  . . * * * * . .

    .BITS  . * . . . . . .  ;
    .BITS  . * . . . . . .
    .BITS  . * . * * * . .
    .BITS  . * * . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . * * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . . * . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . * * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . * . . . * . .
    .BITS  . . * * * . . .

    .BITS  . * . . . . . .  ;
    .BITS  . * . . . . . .
    .BITS  . * . . . * . .
    .BITS  . * . . * . . .
    .BITS  . * . * . . . .
    .BITS  . * * . * . . .
    .BITS  . * . . . * . .
    .BITS  . . . . . . . .

    .BITS  . . . * * . . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . * * * . * * .
    .BITS  . * . . * . . *
    .BITS  . * . . * . . *
    .BITS  . * . . * . . *
    .BITS  . * . . * . . *
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . * . * * * . .
    .BITS  . * * . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . * * * * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . * . * * * . .
    .BITS  . * * . . . * .
    .BITS  . * * . . . * .
    .BITS  . * . * * * . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . * * * . * .
    .BITS  . * . . . * * .
    .BITS  . * . . . * * .
    .BITS  . . * * * . * .
    .BITS  . . . . . . * .
    .BITS  . . . . . . * .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . * . * * * . .
    .BITS  . * * . . . * .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . * * * * * .
    .BITS  . * . . . . . .
    .BITS  . . * * * * . .
    .BITS  . . . . . . * .
    .BITS  . * * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . * . . . .  ;
    .BITS  . . . * . . . .
    .BITS  . * * * * * . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . * .
    .BITS  . . . . * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . * * .
    .BITS  . . * * * . * .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * . . * . .
    .BITS  . . . * * . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . * . . . . . *
    .BITS  . * . . * . . *
    .BITS  . * . . * . . *
    .BITS  . * . . * . . *
    .BITS  . . * * . * * .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . * . . . . * .
    .BITS  . . * . . * . .
    .BITS  . . . * * . . .
    .BITS  . . * . . * . .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . * * .
    .BITS  . . * * * . * .
    .BITS  . . . . . . * .
    .BITS  . . * * * * . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . * . .
    .BITS  . . . * * . . .
    .BITS  . . * . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ;
    .BITS  . . * . . . . .
    .BITS  . . * . . . . .
    .BITS  . . * . . . . .
    .BITS  . . * . . . . .
    .BITS  . . * . . . . .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . * . . . . . .
    .BITS  . . * . . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . * . .
    .BITS  . . . . . . * .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ;
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . * * * . .
    .BITS  . . * . * . * .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . * . . . .
    .BITS  . . * . . . . .
    .BITS  . * * * * * * *
    .BITS  . . * . . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .

    .BITS  . . * . . * . .  ;
    .BITS  . . * . . * . .
    .BITS  . . * . . * . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . * . . * . .  ;
    .BITS  . . * . . * . .
    .BITS  . * * * * * * .
    .BITS  . . * . . * . .
    .BITS  . * * * * * * .
    .BITS  . . * . . * . .
    .BITS  . . * . . * . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ;
    .BITS  . . . * * * * .
    .BITS  . . * . * . . .
    .BITS  . . . * * * . .
    .BITS  . . . . * . * .
    .BITS  . . * * * * . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . * * . . . * .
    .BITS  . * * . . * . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  . . * . . * * .
    .BITS  . * . . . * * .
    .BITS  . . . . . . . .

    .BITS  . . * * . . . .  ;
    .BITS  . * . . * . . .
    .BITS  . * . . * . . .
    .BITS  . . * * . . . .
    .BITS  . * . . * . * .
    .BITS  . * . . . * . .
    .BITS  . . * * * . * .
    .BITS  . . . . . . . .

    .BITS  . . . . . * . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . * . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . * . .
    .BITS  . . . . . . . .

    .BITS  . . * . . . . .  ;
    .BITS  . . . * . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  . . * . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ;
    .BITS  . . * . * . * .
    .BITS  . . . * * * . .
    .BITS  . . * * * * * .
    .BITS  . . . * * * . .
    .BITS  . . * . * . * .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . * * * * * .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . * * . . .
    .BITS  . . . * * . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . * .
    .BITS  . . . . . * . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  . . * . . . . .
    .BITS  . * . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ;
    .BITS  . * . . . . * .
    .BITS  . * . . . * * .
    .BITS  . * . * * . * .
    .BITS  . * * . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ;
    .BITS  . . . * * . . .
    .BITS  . . * . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . * * * * * .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ;
    .BITS  . * . . . . * .
    .BITS  . . . . . . * .
    .BITS  . . . . * * . .
    .BITS  . . * * . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ;
    .BITS  . * . . . . * .
    .BITS  . . . . . . * .
    .BITS  . . . * * * . .
    .BITS  . . . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . . * . .  ;
    .BITS  . . . . * * . .
    .BITS  . . . * . * . .
    .BITS  . . * . . * . .
    .BITS  . * * * * * * .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . . . .

    .BITS  . * * * * * * .  ;
    .BITS  . * . . . . . .
    .BITS  . * * * * . . .
    .BITS  . . . . . * . .
    .BITS  . . . . . . * .
    .BITS  . * . . . * . .
    .BITS  . . * * * . . .
    .BITS  . . . . . . . .

    .BITS  . . . * * * . .  ;
    .BITS  . . * . . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . * * * * * * .  ;
    .BITS  . * . . . . * .
    .BITS  . . . . . * . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ;
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ;
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * * .
    .BITS  . . . . . . * .
    .BITS  . . . . . * . .
    .BITS  . . * * * . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . * . . . .

    .BITS  . . . . * * * .  ;
    .BITS  . . . * * . . .
    .BITS  . . * * . . . .
    .BITS  . * * . . . . .
    .BITS  . . * * . . . .
    .BITS  . . . * * . . .
    .BITS  . . . . * * * .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . * * * . . . .  ;
    .BITS  . . . * * . . .
    .BITS  . . . . * * . .
    .BITS  . . . . . * * .
    .BITS  . . . . * * . .
    .BITS  . . . * * . . .
    .BITS  . * * * . . . .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ;
    .BITS  . * . . . . * .
    .BITS  . . . . . . * .
    .BITS  . . . . * * . .
    .BITS  . . . * . . . .
    .BITS  . . . . . . . .
    .BITS  . . . * . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * * * *
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . * * . . .  ;
    .BITS  . . * . . * . .
    .BITS  . * . . . . * .
    .BITS  . * * * * * * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . * * * * * . .  ;
    .BITS  . . * . . . * .
    .BITS  . . * . . . * .
    .BITS  . . * * * * . .
    .BITS  . . * . . . * .
    .BITS  . . * . . . * .
    .BITS  . * * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . * * * . .  ;
    .BITS  . . * . . . * .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . . * . . . * .
    .BITS  . . . * * * . .
    .BITS  . . . . . . . .

    .BITS  . * * * * . . .  ;
    .BITS  . . * . . * . .
    .BITS  . . * . . . * .
    .BITS  . . * . . . * .
    .BITS  . . * . . . * .
    .BITS  . . * . . * . .
    .BITS  . * * * * . . .
    .BITS  . . . . . . . .

    .BITS  . * * * * * * .  ;
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .

    .BITS  . * * * * * * .  ;
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . * * * . .  ;
    .BITS  . . * . . . * .
    .BITS  . * . . . . . .
    .BITS  . * . . * * * .
    .BITS  . * . . . . * .
    .BITS  . . * . . . * .
    .BITS  . . . * * * . .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ;
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * * * * * * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . . . * * * . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . * * * . .
    .BITS  . . . . . . . .

    .BITS  . . . . * * * .  ;
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . . . . . * . .
    .BITS  . * . . . * . .
    .BITS  . . * * * . . .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ;
    .BITS  . * . . . * . .
    .BITS  . * . . * . . .
    .BITS  . * * * . . . .
    .BITS  . * . . * . . .
    .BITS  . * . . . * . .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . * . . . . . .  ;
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ;
    .BITS  . * * . . * * .
    .BITS  . * . * * . * .
    .BITS  . * . * * . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ;
    .BITS  . * * . . . * .
    .BITS  . * . * . . * .
    .BITS  . * . . * . * .
    .BITS  . * . . . * * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . . . * * . . .  ;
    .BITS  . . * . . * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * . . * . .
    .BITS  . . . * * . . .
    .BITS  . . . . . . . .

    .BITS  . * * * * * . .  ;
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * * * * * . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . * . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . * * . . .  ;
    .BITS  . . * . . * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . * . * .
    .BITS  . . * . . * . .
    .BITS  . . . * * . * .
    .BITS  . . . . . . . .

    .BITS  . * * * * * . .  ;
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * * * * * . .
    .BITS  . * . . * . . .
    .BITS  . * . . . * . .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . . * * * * . .  ;
    .BITS  . * . . . . * .
    .BITS  . * . . . . . .
    .BITS  . . * * * * . .
    .BITS  . . . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . . * * * * * .  ;
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ;
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * * * * . .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ;
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . * . . * . .
    .BITS  . . * . . * . .
    .BITS  . . . * * . . .
    .BITS  . . . * * . . .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ;
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . * . * * . * .
    .BITS  . * . * * . * .
    .BITS  . * * . . * * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . * . . . . * .  ;
    .BITS  . * . . . . * .
    .BITS  . . * . . * . .
    .BITS  . . . * * . . .
    .BITS  . . * . . * . .
    .BITS  . * . . . . * .
    .BITS  . * . . . . * .
    .BITS  . . . . . . . .

    .BITS  . . * . . . * .  ;
    .BITS  . . * . . . * .
    .BITS  . . * . . . * .
    .BITS  . . . * * * . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . . . . .

    .BITS  . * * * * * * .  ;
    .BITS  . . . . . . * .
    .BITS  . . . . . * . .
    .BITS  . . . * * . . .
    .BITS  . . * . . . . .
    .BITS  . * . . . . . .
    .BITS  . * * * * * * .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  * * * * * * * *
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  * . * . . . . .  ;
    .BITS  . * . * . . . .
    .BITS  * . * . . . . .
    .BITS  . * . * . . . .
    .BITS  * . * . . . . .
    .BITS  . * . * . . . .
    .BITS  * . * . . . . .
    .BITS  . * . * . . . .

    .BITS  . . . . * . . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  * * . . * * . .  ;
    .BITS  * * . . * * . .
    .BITS  . . * * . . * *
    .BITS  . . * * . . * *
    .BITS  * * . . * * . .
    .BITS  * * . . * * . .
    .BITS  . . * * . . * *
    .BITS  . . * * . . * *

    .BITS  * * . . * * . .  ;
    .BITS  . * * . . * * .
    .BITS  . . * * . . * *
    .BITS  * . . * * . . *
    .BITS  * * . . * * . .
    .BITS  . * * . . * * .
    .BITS  . . * * . . * *
    .BITS  * . . * * . . *

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  * * * * . . . .  ;
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * * * *
    .BITS  * * * * * * * *
    .BITS  * * * * * * * *
    .BITS  * * * * * * * *

    .BITS  * * * * * * * *  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * * * *

    .BITS  * . . . . . . .  ;
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .
    .BITS  * . . . . . . .

    .BITS  * . * . * . * .  ;
    .BITS  . * . * . * . *
    .BITS  * . * . * . * .
    .BITS  . * . * . * . *
    .BITS  * . * . * . * .
    .BITS  . * . * . * . *
    .BITS  * . * . * . * .
    .BITS  . * . * . * . *

    .BITS  . . . . . . . *  ;
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *
    .BITS  . . . . . . . *

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * . * . * . * .
    .BITS  . * . * . * . *
    .BITS  * . * . * . * .
    .BITS  . * . * . * . *

    .BITS  * . . * * . . *  ;
    .BITS  . . * * . . * *
    .BITS  . * * . . * * .
    .BITS  * * . . * * . .
    .BITS  * . . * * . . *
    .BITS  . . * * . . * *
    .BITS  . * * . . * * .
    .BITS  * * . . * * . .

    .BITS  . . . . . . * *  ;
    .BITS  . . . . . . * *
    .BITS  . . . . . . * *
    .BITS  . . . . . . * *
    .BITS  . . . . . . * *
    .BITS  . . . . . . * *
    .BITS  . . . . . . * *
    .BITS  . . . . . . * *

    .BITS  . . . . * . . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * * * *
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . * * * *
    .BITS  . . . . * * * *
    .BITS  . . . . * * * *
    .BITS  . . . . * * * *

    .BITS  . . . . * . . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * * * *
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * * * *
    .BITS  * * * * * * * *

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . * * * *
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  . . . . * . . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  * * * * * * * *
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * * * *
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  . . . . * . . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  * * * * * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .

    .BITS  * * . . . . . .  ;
    .BITS  * * . . . . . .
    .BITS  * * . . . . . .
    .BITS  * * . . . . . .
    .BITS  * * . . . . . .
    .BITS  * * . . . . . .
    .BITS  * * . . . . . .
    .BITS  * * . . . . . .

    .BITS  * * * . . . . .  ;
    .BITS  * * * . . . . .
    .BITS  * * * . . . . .
    .BITS  * * * . . . . .
    .BITS  * * * . . . . .
    .BITS  * * * . . . . .
    .BITS  * * * . . . . .
    .BITS  * * * . . . . .

    .BITS  . . . . . * * *  ;
    .BITS  . . . . . * * *
    .BITS  . . . . . * * *
    .BITS  . . . . . * * *
    .BITS  . . . . . * * *
    .BITS  . . . . . * * *
    .BITS  . . . . . * * *
    .BITS  . . . . . * * *

    .BITS  * * * * * * * *  ;
    .BITS  * * * * * * * *
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  * * * * * * * *  ;
    .BITS  * * * * * * * *
    .BITS  * * * * * * * *
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * * * * *
    .BITS  * * * * * * * *
    .BITS  * * * * * * * *

    .BITS  . . . . . . . *  ;
    .BITS  . . . . . . * .
    .BITS  . * . . . * . .
    .BITS  . * . . * . . .
    .BITS  . * . * . . . .
    .BITS  . * * . . . . .
    .BITS  . * . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . . . . .  ;
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .

    .BITS  . . . . * * * *  ;
    .BITS  . . . . * * * *
    .BITS  . . . . * * * *
    .BITS  . . . . * * * *
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  . . . . * . . .  ;
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  . . . . * . . .
    .BITS  * * * * * . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  * * * * . . . .  ;
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .
    .BITS  . . . . . . . .

    .BITS  * * * * . . . .  ;
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  * * * * . . . .
    .BITS  . . . . * * * *
    .BITS  . . . . * * * *
    .BITS  . . . . * * * *
    .BITS  . . . . * * * *

