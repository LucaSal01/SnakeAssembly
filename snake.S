.org $8000
.define pixel_clear   $08 
.define following_parts $05 
.define parts_to_clear  $07 
.define check_pixel $09
.define Random_Value  $10
.define Random_Parts_Position $11
.define Starting_Pixel_Position $200
.define parts_Color  #03    

compareY:
LDY $18
JMP Down_input

start:
LDX #$FF
TXS
LDX #0
LDA #16
STA $02
LDA #01
STA $03

;loop start
Loop:
JSR RandomGen
LDY Random_Parts_Position
LDA parts_Color
STA $200,Y
LDY $4000
CPY #00
BEQ compareY
STY $18

;Down Input 
Down_input:
CPY #02
BNE Up_input 
JSR Add_Parts
CLC
ADC #16
STA $00
TAY
LDA #00
CMP $0200,Y
BNE incerment_parts
LDY #00
JSR FindParts
JSR Print_pixel
JMP PixelCleared

;Up input 
Up_input: 
CPY #01
BNE Left_input
JSR Add_Parts
SBC #16
STA $00
TAY
LDA #00
CMP $0200,Y
BNE incerment_parts
LDY #00
JSR FindParts
JSR Print_pixel
JMP PixelCleared

;Left Input
Left_input: 
CPY #04
BNE Right_input
JSR Add_Parts
SBC #1
STA $00
TAY
LDA #00
CMP $0200,Y
BNE incerment_parts
LDY #00
JSR FindParts
JSR Print_pixel
JMP PixelCleared


Right_input:
CPY #08
BNE Loop
JSR Add_Parts
CLC
ADC #1
STA $00
TAY
LDA #00
CMP $0200,Y
BNE incerment_parts
LDY #00
JSR FindParts
JSR Print_pixel
JMP PixelCleared


incerment_parts:
LDA #01
CMP $0200,Y
BEQ End
LDX #00
INX
LDA #01
STA $0200,Y
LDA #03
LDY Random_Value
STA $0200,Y
STY Random_Parts_Position
JMP collecting_parts

collecting_parts:
LDA $02
CPX #0
BNE UP_Down_Loop
JMP Loop

UP_Down_Loop:
CLC
ADC #16
STA $02
LDA $03
ADC #01
STA $03
DEX
JMP collecting_parts

End:
JMP End

Check_Apple:
TAY
LDA #03
CMP $0200,Y
BEQ incerment_parts
LDY #00

Print_pixel:
LDA #1
LDX $00
STA $0200, X
JSR Clear_pixel
RTS

Clear_pixel:
LDA #0
LDY check_pixel
STA $0200,Y
LDY #00
RTS

Add_Parts:
LDX following_parts
TYA 
STA $0300,X
LDA $00
INX
STX following_parts
RTS

FindParts:
LDX parts_to_clear
LDA $0300,X
STA pixel_clear
LDA #00
STA $0300,X
INX
STX parts_to_clear
RTS

PixelCleared:
LDX pixel_clear
CPX #08
BEQ RIGHT
CPX #04
BEQ LEFT
CPX #02
BEQ DOWN
CPX #01
BEQ UP
JMP Loop

RIGHT:
LDA check_pixel
CLC
ADC #1
STA check_pixel
JMP Loop

LEFT:
LDA check_pixel
SBC #1
STA check_pixel
JMP Loop

DOWN:
LDA check_pixel
CLC
ADC #16
STA check_pixel
JMP Loop


UP:
LDA check_pixel
SBC #16
STA check_pixel
JMP Loop

RandomGen:
LDA Random_Value
CLC
ADC pixel_clear
ADC following_parts
ADC parts_to_clear
STA Random_Value
RTS

.goto $FFFA
.dw start ; non maskable
.dw start ; reset
.DW start ; interrupt
