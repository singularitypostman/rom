;
; SkoolKit control file for the 48K Spectrum ROM.
;
; Annotations taken from 'The Complete Spectrum ROM Disassembly' by Dr Ian
; Logan and Dr Frank O'Hara, published by Melbourne House.
;

@ $0000 start
@ $0000 replace=/#pi/#CHR(960)
@ $0000 replace=/#power/#CHR(8593)
@ $0000 org=$0000
@ $0000 set-handle-unsupported-macros=1
@ $0000 label=START
c $0000 THE 'START'
D $0000 The maskable interrupt is disabled and the #REGde register pair set to hold the 'top of possible RAM'.
  $0000 Disable the 'keyboard interrupt'.
  $0001 +00 for start (but +FF for 'NEW').
  $0002 Top of possible RAM.
  $0005 Jump forward.
@ $0008 label=ERROR_1
c $0008 THE 'ERROR' RESTART
D $0008 The error pointer is made to point to the position of the error.
  $0008 The address reached by the interpreter is copied to the error pointer before proceeding.
@ $0010 label=PRINT_A_1
c $0010 THE 'PRINT A CHARACTER' RESTART
D $0010 The #REGa register holds the code of the character that is to be printed.
  $0010 Jump forward immediately.
s $0013
  $0013,5,5:$FF Unused locations.
@ $0018 label=GET_CHAR
c $0018 THE 'COLLECT CHARACTER' RESTART
D $0018 The contents of the location currently addressed by CH-ADD are fetched. A return is made if the value represents a printable character, otherwise CH-ADD is incremented and the tests repeated.
  $0018 Fetch the value that is addressed by CH-ADD.
@ $001C label=TEST_CHAR
  $001C Find out if the character is printable.
  $001F Return if it is so.
@ $0020 label=NEXT_CHAR
c $0020 THE 'COLLECT NEXT CHARACTER' RESTART
D $0020 As a BASIC line is interpreted, this routine is called repeatedly to step along the line.
  $0020 CH-ADD needs to be incremented.
  $0023 Jump back to test the new value.
s $0025
  $0025,3,3:$FF Unused locations.
@ $0028 label=FP_CALC
c $0028 THE 'CALCULATOR' RESTART
D $0028 The floating point calculator is entered at #R$335B.
  $0028 Jump forward immediately.
s $002B
  $002B,5,5:$FF Unused locations.
@ $0030 label=BC_SPACES
c $0030 THE 'MAKE BC SPACES' RESTART
D $0030 This routine creates free locations in the work space. The number of locations is determined by the current contents of the #REGbc register pair.
  $0030 Save the 'number'.
  $0031 Fetch the present address of the start of the work space and save that also before proceeding.
@ $0038 label=MASK_INT
c $0038 THE 'MASKABLE INTERRUPT' ROUTINE
D $0038 The real time clock is incremented and the keyboard scanned whenever a maskable interrupt occurs.
  $0038 Save the current values held in these registers.
  $003A The lower two bytes of the frame counter are incremented every 20 ms. (U.K.) The highest byte of the frame counter is only incremented when the value of the lower two bytes is zero.
@ $0048 label=KEY_INT
  $0048 Save the current values held in these registers.
  $004A Now scan the keyboard.
  $004D Restore the values.
  $0051 The maskable interrupt is enabled before returning.
@ $0053 label=ERROR_2
c $0053 THE 'ERROR-2' ROUTINE
D $0053 The return address to the interpreter points to the 'DEFB' that signifies which error has occurred. This 'DEFB' is fetched and transferred to ERR-NR.
D $0053 The machine stack is cleared before jumping forward to clear the calculator stack.
  $0053 The address on the stack points to the error code.
@ $0055 label=ERROR_3
  $0055 It is transferred to ERR-NR.
  $0058 The machine stack is cleared before exiting via #R$16C5.
s $005F
  $005F,7,7:$FF Unused locations.
@ $0066 label=RESET
c $0066 THE 'NON-MASKABLE INTERRUPT' ROUTINE
D $0066 This routine is not used in the standard Spectrum but the code allows for a system reset to occur following activation of the NMI line. The system variable at 5CB0, named here NMIADD, has to have the value zero for the reset to occur.
  $0066 Save the current values held in these registers.
  $0068 The two bytes of NMIADD must both be zero for the reset to occur.
  $006D Note: this should have been 'JR Z'!
  $006F Jump to #R$0000.
@ $0070 label=NO_RESET
  $0070 Restore the current values to these registers and return.
@ $0074 label=CH_ADD_1
c $0074 THE 'CH-ADD+1' SUBROUTINE
D $0074 The address held in CH-ADD is fetched, incremented and restored. The contents of the location now addressed by CH-ADD are fetched. The entry points of #R$0077 and #R$0078 are used to set CH-ADD for a temporary period.
  $0074 Fetch the address.
@ $0077 label=TEMP_PTR1
  $0077 Increment the pointer.
@ $0078 label=TEMP_PTR2
  $0078 Set CH-ADD.
  $007B Fetch the addressed value and then return.
@ $007D label=SKIP_OVER
c $007D THE 'SKIP-OVER' SUBROUTINE
D $007D The value brought to the subroutine in the #REGa register is tested to see if it is printable. Various special codes lead to #REGhl being incremented once or twice, and CH-ADD amended accordingly.
  $007D Return with the carry flag reset if ordinary character code.
  $0080 Return if the end of the line has been reached.
  $0083 Return with codes +00 to +0F but with carry set.
  $0086 Return with codes +18 to +20 again with carry set.
  $008A Skip over once.
  $008B Jump forward with codes +10 to +15 (INK to OVER).
  $008F Skip over once more (AT and TAB).
@ $0090 label=SKIPS
  $0090 Return with the carry flag set and CH-ADD holding the appropriate address.
@ $0095 label=TOKENS
t $0095 THE TOKEN TABLE
D $0095 All the tokens used by the Spectrum are expanded by reference to this table. The last code of each token is 'inverted' by having its bit 7 set.
  $0096,3,2:B1
  $0099,6,5:B1
  $009F,2,1:B1
  $00A1,2,1:B1
  $00A3,5,4:B1
  $00A8,7,6:B1
  $00AF,4,3:B1
  $00B3,2,1:B1
  $00B5,3,2:B1
  $00B8,4,3:B1
  $00BC,4,3:B1
  $00C0,3,2:B1
  $00C3,3,2:B1
  $00C6,3,2:B1
  $00C9,3,2:B1
  $00CC,3,2:B1
  $00CF,3,2:B1
  $00D2,3,2:B1
  $00D5,3,2:B1
  $00D8,2,1:B1
  $00DA,3,2:B1
  $00DD,3,2:B1
  $00E0,3,2:B1
  $00E3,3,2:B1
  $00E6,3,2:B1
  $00E9,4,3:B1
  $00ED,2,1:B1
  $00EF,3,2:B1
  $00F2,4,3:B1
  $00F6,4,3:B1
  $00FA,3,2:B1
  $00FD,3,2:B1
  $0100,2,1:B1
  $0102,3,2:B1
  $0105,2,1:B1
  $0107,2,1:B1
  $0109,2,1:B1
  $010B,4,3:B1
  $010F,4,3:B1
  $0113,2,1:B1
  $0115,4,3:B1
  $0119,6,5:B1
  $011F,3,2:B1
  $0122,6,5:B1
  $0128,4,3:B1
  $012C,5,4:B1
  $0131,6,5:B1
  $0137,7,6:B1
  $013E,5,4:B1
  $0143,6,5:B1
  $0149,4,3:B1
  $014D,6,5:B1
  $0153,3,2:B1
  $0156,5,4:B1
  $015B,5,4:B1
  $0160,6,5:B1
  $0166,7,6:B1
  $016D,4,3:B1
  $0171,3,2:B1
  $0174,6,5:B1
  $017A,5,4:B1
  $017F,4,3:B1
  $0183,4,3:B1
  $0187,4,3:B1
  $018B,7,6:B1
  $0192,3,2:B1
  $0195,6,5:B1
  $019B,8,7:B1
  $01A3,3,2:B1
  $01A6,3,2:B1
  $01A9,3,2:B1
  $01AC,5,4:B1
  $01B1,6,5:B1
  $01B7,5,4:B1
  $01BC,4,3:B1
  $01C0,4,3:B1
  $01C4,3,2:B1
  $01C7,5,4:B1
  $01CC,4,3:B1
  $01D0,4,3:B1
  $01D4,5,4:B1
  $01D9,4,3:B1
  $01DD,3,2:B1
  $01E0,4,3:B1
  $01E4,9,8:B1
  $01ED,2,1:B1
  $01EF,3,2:B1
  $01F2,4,3:B1
  $01F6,5,4:B1
  $01FB,6,5:B1
  $0201,4,3:B1
@ $0205 label=KEYTABLE_A
b $0205 THE KEY TABLES
D $0205 There are six separate key tables. The final character code obtained depends on the particular key pressed and the 'mode' being used.
N $0205 (a) The main key table - L mode and CAPS SHIFT.
  $0205 B
  $0206 H
  $0207 Y
  $0208 6
  $0209 5
  $020A T
  $020B G
  $020C V
  $020D N
  $020E J
  $020F U
  $0210 7
  $0211 4
  $0212 R
  $0213 F
  $0214 C
  $0215 M
  $0216 K
  $0217 I
  $0218 8
  $0219 3
  $021A E
  $021B D
  $021C X
  $021D SYMBOL SHIFT
  $021E L
  $021F O
  $0220 9
  $0221 2
  $0222 W
  $0223 S
  $0224 Z
  $0225 SPACE
  $0226 ENTER
  $0227 P
  $0228 0
  $0229 1
  $022A Q
  $022B A
@ $022C label=KEYTABLE_B
N $022C (b) Extended mode. Letter keys and unshifted.
  $022C READ
  $022D BIN
  $022E LPRINT
  $022F DATA
  $0230 TAN
  $0231 SGN
  $0232 ABS
  $0233 SQR
  $0234 CODE
  $0235 VAL
  $0236 LEN
  $0237 USR
  $0238 PI
  $0239 INKEY$
  $023A PEEK
  $023B TAB
  $023C SIN
  $023D INT
  $023E RESTORE
  $023F RND
  $0240 CHR$
  $0241 LLIST
  $0242 COS
  $0243 EXP
  $0244 STR$
  $0245 LN
@ $0246 label=KEYTABLE_C
N $0246 (c) Extended mode. Letter keys and either shift.
  $0246 ~
  $0247 BRIGHT
  $0248 PAPER
  $0249 \
  $024A ATN
  $024B {
  $024C }
  $024D CIRCLE
  $024E IN
  $024F VAL$
  $0250 SCREEN$
  $0251 ATTR
  $0252 INVERSE
  $0253 OVER
  $0254 OUT
  $0255 #CHR169
  $0256 ASN
  $0257 VERIFY
  $0258 |
  $0259 MERGE
  $025A ]
  $025B FLASH
  $025C ACS
  $025D INK
  $025E [
  $025F BEEP
@ $0260 label=KEYTABLE_D
N $0260 (d) Control codes. Digit keys and CAPS SHIFT.
  $0260 DELETE
  $0261 EDIT
  $0262 CAPS LOCK
  $0263 TRUE VIDEO
  $0264 INV. VIDEO
  $0265 Cursor left
  $0266 Cursor down
  $0267 Cursor up
  $0268 Cursor right
  $0269 GRAPHICS
@ $026A label=KEYTABLE_E
N $026A (e) Symbol code. Letter keys and symbol shift.
  $026A STOP
  $026B *
  $026C ?
  $026D STEP
  $026E >=
  $026F TO
  $0270 THEN
  $0271 #power
  $0272 AT
  $0273 -
  $0274 +
  $0275 =
  $0276 .
  $0277 ,
  $0278 ;
  $0279 "
  $027A <=
  $027B <
  $027C NOT
  $027D >
  $027E OR
  $027F /
  $0280 <>
  $0281 #CHR163
  $0282 AND
  $0283 :
@ $0284 label=KEYTABLE_F
N $0284 (f) Extended mode. Digit keys and symbol shift.
  $0284 FORMAT
  $0285 DEF FN
  $0286 FN
  $0287 LINE
  $0288 OPEN
  $0289 CLOSE
  $028A MOVE
  $028B ERASE
  $028C POINT
  $028D CAT
@ $028E label=KEY_SCAN
c $028E THE 'KEYBOARD SCANNING' SUBROUTINE
D $028E This very important subroutine is called by both the #R$02BF(main keyboard subroutine) and the #R$2634(INKEY$ routine) (in #R$24FB).
D $028E In all instances the #REGe register is returned with a value in the range of +00 to +27, the value being different for each of the forty keys of the keyboard, or the value +FF, for no-key.
D $028E The #REGd register is returned with a value that indicates which single shift key is being pressed. If both shift keys are being pressed then the #REGd and #REGe registers are returned with the values for the CAPS SHIFT and SYMBOL SHIFT keys respectively.
D $028E If no key is being pressed then the #REGde register pair is returned holding +FFFF.
D $028E The zero flag is returned reset if more than two keys are being pressed, or neither key of a pair of keys is a shift key.
  $028E The initial key value for each line will be +2F, +2E,..., +28. (Eight lines.)
  $0290 Initialise #REGde to 'no-key'.
  $0293 #REGc=port address, #REGb=counter.
N $0296 Now enter a loop. Eight passes are made with each pass having a different initial key value and scanning a different line of five keys. (The first line is CAPS SHIFT, Z, X, C, V.)
@ $0296 label=KEY_LINE
  $0296 Read from the port specified.
  $0298 A pressed key in the line will set its respective bit, from bit 0 (outer key) to bit 4 (inner key).
  $029B Jump forward if none of the five keys in the line are being pressed.
  $029D The key-bits go to the #REGh register whilst the initial key value is fetched.
@ $029F label=KEY_3KEYS
  $029F If three keys are being pressed on the keyboard then the #REGd register will no longer hold +FF - so return if this happens.
@ $02A1 label=KEY_BITS
  $02A1 Repeatedly subtract 8 from the present key value until a key-bit is found.
  $02A7 Copy any earlier key value to the #REGd register.
  $02A8 Pass the new key value to the #REGe register.
  $02A9 If there is a second, or possibly a third, pressed key in this line then jump back.
@ $02AB label=KEY_DONE
  $02AB The line has been scanned so the initial key value is reduced for the next pass.
  $02AC The counter is shifted and the jump taken if there are still lines to be scanned.
N $02B0 Four tests are now made.
  $02B0 Accept any key value which still has the #REGd register holding +FF, i.e. a single key pressed or 'no-key'.
  $02B3 Accept the key value for a pair of keys if the #REGd key is CAPS SHIFT.
  $02B6 Accept the key value for a pair of keys if the #REGd key is SYMBOL SHIFT.
  $02B9 It is however possible for the #REGe key of a pair to be SYMBOL SHIFT - so this has to be considered.
  $02BE Return with the zero flag set if it was SYMBOL SHIFT and 'another key'; otherwise reset.
@ $02BF label=KEYBOARD
c $02BF THE 'KEYBOARD' SUBROUTINE
D $02BF This subroutine is called on every occasion that a maskable interrupt occurs. In normal operation this will happen once every 20 ms. The purpose of this subroutine is to scan the keyboard and decode the key value. The code produced will, if the 'repeat' status allows it, be passed to the system variable LAST-K. When a code is put into this system variable bit 5 of FLAGS is set to show that a 'new' key has been pressed.
  $02BF Fetch a key value in the #REGde register pair but return immediately if the zero flag is reset.
N $02C3 A double system of 'KSTATE system variables' (KSTATE0-KSTATE3 and KSTATE4-KSTATE7) is used from now on.
N $02C3 The two sets allow for the detection of a new key being pressed (using one set) whilst still within the 'repeat period' of the previous key to have been pressed (details in the other set).
N $02C3 A set will only become free to handle a new key if the key is held down for about 1/10th. of a second, i.e. five calls to #R$02BF.
  $02C3 Start with KSTATE0.
@ $02C6 label=K_ST_LOOP
  $02C6 Jump forward if a 'set is free', i.e. KSTATE0/4 holds +FF.
  $02CA However if the set is not free decrease its '5 call counter' and when it reaches zero signal the set as free.
N $02D1 After considering the first set change the pointer and consider the second set.
@ $02D1 label=K_CH_SET
  $02D1 Fetch the low byte of the address and jump back if the second set has still to be considered.
N $02D8 Return now if the key value indicates 'no-key' or a shift key only.
  $02D8 Make the necessary tests and return if needed. Also change the key value to a 'main code'.
N $02DC A key stroke that is being repeated (held down) is now separated from a new key stroke.
  $02DC Look first at KSTATE0.
  $02DF Jump forward if the codes match - indicating a repeat.
  $02E2 Save the address of KSTATE0.
  $02E3 Now look at KSTATE4.
  $02E6 Jump forward if the codes match - indicating a repeat.
N $02E9 But a new key will not be accepted unless one of the sets of KSTATE system variables is 'free'.
  $02E9 Consider the second set.
  $02EB Jump forward if 'free'.
  $02ED Now consider the first set.
  $02EE Continue if the set is 'free' but exit if not.
N $02F1 The new key is to be accepted. But before the system variable LAST-K can be filled, the KSTATE system variables, of the set being used, have to be initialised to handle any repeats and the key's code has to be decoded.
@ $02F1 label=K_NEW
  $02F1 The code is passed to the #REGe register and to KSTATE0/4.
  $02F3 The '5 call counter' for this set is reset to '5'.
  $02F6 The third system variable of the set holds the REPDEL value (normally 0.7 secs.).
  $02FB Point to KSTATE3/7.
N $02FC The decoding of a 'main code' depends upon the present state of MODE, bit 3 of FLAGS and the 'shift byte'.
  $02FC Fetch MODE.
  $02FF Fetch FLAGS.
  $0302 Save the pointer whilst the 'main code' is decoded.
  $0307 The final code value is saved in KSTATE3/7, from where it is collected in case of a repeat.
N $0308 The next three instructions are common to the handling of both 'new keys' and 'repeat keys'.
@ $0308 label=K_END
  $0308 Enter the final code value into LAST-K and signal 'a new key'.
  $030F Finally return.
@ $0310 label=K_REPEAT
N $0310 A key will 'repeat' on the first occasion after the delay period (REPDEL - normally 0.7s) and on subsequent occasions after the delay period (REPPER - normally 0.1s).
  $0310 Point to the '5 call counter' of the set being used and reset it to 5.
  $0313 Point to the third system variable - the REPDEL/REPPER value - and decrement it.
  $0315 Exit from the #R$02BF subroutine if the delay period has not passed.
  $0316 However once it has passed the delay period for the next repeat is to be REPPER.
  $031A The repeat has been accepted so the final code value is fetched from KSTATE3/7 and passed to #R$0308.
@ $031E label=K_TEST
c $031E THE 'K-TEST' SUBROUTINE
D $031E The key value is tested and a return made if 'no-key' or 'shift-only'; otherwise the 'main code' for that key is found.
  $031E Copy the shift byte.
  $031F Clear the #REGd register for later.
  $0321 Move the key number.
  $0322 Return now if the key was 'CAPS SHIFT' only or 'no-key'.
  $0325 Jump forward unless the #REGe key was SYMBOL SHIFT.
  $0329 However accept SYMBOL SHIFT and another key; return with SYMBOL SHIFT only.
N $032C The 'main code' is found by indexing into the main key table.
@ $032C label=K_MAIN
  $032C The base address of the #R$0205(main key table).
  $032F Index into the table and fetch the 'main code'.
  $0331 Signal 'valid keystroke' before returning.
@ $0333 label=K_DECODE
c $0333 THE 'KEYBOARD DECODING' SUBROUTINE
D $0333 This subroutine is entered with the 'main code' in the #REGe register, the value of FLAGS in the #REGd register, the value of MODE in the #REGc register and the 'shift byte' in the #REGb register.
D $0333 By considering these four values and referring, as necessary, to the #R$0205(six key tables) a 'final code' is produced. This is returned in the #REGa register.
  $0333 Copy the 'main code'.
  $0334 Jump forward if a digit key is being considered; also SPACE, ENTER and both shifts.
  $0338 Decrement the MODE value.
  $0339 Jump forward, as needed, for modes 'K', 'L', 'C' and 'E'.
N $033E Only 'graphics' mode remains and the 'final code' for letter keys in graphics mode is computed from the 'main code'.
  $033E Add the offset.
  $0340 Return with the 'final code'.
N $0341 Letter keys in extended mode are considered next.
@ $0341 ssub=LD HL,$022C-$41
@ $0341 label=K_E_LET
  $0341 The base address for #R$022C(table 'b').
  $0344 Jump forward to use this table if neither shift key is being pressed.
  $0347 Otherwise use the base address for #R$0246(table 'c').
N $034A Key tables 'b-f' are all served by the following look-up routine. In all cases a 'final code' is found and returned.
@ $034A label=K_LOOK_UP
  $034A Clear the #REGd register.
  $034C Index the required table and fetch the 'final code'.
  $034E Then return.
N $034F Letter keys in 'K', 'L' or 'C' modes are now considered. But first the special SYMBOL SHIFT codes have to be dealt with.
@ $034F ssub=LD HL,$026A-$41
@ $034F label=K_KLC_LET
  $034F The base address for #R$026A(table 'e').
  $0352 Jump back if using the SYMBOL SHIFT key and a letter key.
  $0356 Jump forward if currently in 'K' mode.
  $035A If CAPS LOCK is set then return with the 'main code'.
  $035F Also return in the same manner if CAPS SHIFT is being pressed.
  $0361 However if lower case codes are required then +20 has to be added to the 'main code' to give the correct 'final code'.
N $0364 The 'final code' values for tokens are found by adding +A5 to the 'main code'.
  $0364 Add the required offset and return.
N $0367 Next the digit keys, SPACE, ENTER and both shifts are considered.
@ $0367 label=K_DIGIT
  $0367,3,c2,1 Proceed only with the digit keys, i.e. return with SPACE (+20), ENTER (+0D) and both shifts (+0E).
  $036A Now separate the digit keys into three groups - according to the mode.
  $036B Jump with 'K', 'L' and 'C' modes, and also with 'G' mode. Continue with 'E' mode.
@ $0370 ssub=LD HL,$0284-$30
  $0370 The base address for #R$0284(table 'f').
  $0373 Use this table for SYMBOL SHIFT and a digit key in extended mode.
  $0377,4,c2,2 Jump forward with digit keys '8' and '9'.
N $037B The digit keys '0' to '7' in extended mode are to give either a 'paper colour code' or an 'ink colour code' depending on the use of CAPS SHIFT.
  $037B Reduce the range +30 to +37 giving +10 to +17.
  $037D Return with this 'paper colour code' if CAPS SHIFT is not being used.
  $037F But if it is then the range is to be +18 to +1F instead - indicating an 'ink colour code'.
N $0382 The digit keys '8' and '9' are to give 'BRIGHT' and 'FLASH' codes.
@ $0382 label=K_8_9
  $0382 +38 and +39 go to +02 and +03.
  $0384 Return with these codes if CAPS SHIFT is not being used. (These are 'BRIGHT' codes.)
  $0386 Subtract '2' if CAPS SHIFT is being used; giving +00 and +01 (as 'FLASH' codes).
N $0389 The digit keys in graphics mode are to give the block graphic characters (+80 to +8F), the GRAPHICS code (+0F) and the DELETE code (+0C).
@ $0389 ssub=LD HL,$0260-$30
@ $0389 label=K_GRA_DGT
  $0389 The base address of #R$0260(table 'd').
  $038C,8,c2,2,c2,2 Use this table directly for both digit key '9' that is to give GRAPHICS, and digit key '0' that is to give DELETE.
  $0394 For keys '1' to '8' make the range +80 to +87.
  $0398 Return with a value from this range if neither shift key is being pressed.
  $039A But if 'shifted' make the range +88 to +8F.
N $039D Finally consider the digit keys in 'K', 'L' and 'C' modes.
@ $039D label=K_KLC_DGT
  $039D Return directly if neither shift key is being used. (Final codes +30 to +39.)
  $039F Use #R$0260(table 'd') if the CAPS SHIFT key is also being pressed.
@ $03A1 ssub=LD HL,$0260-$30
N $03A6 The codes for the various digit keys and SYMBOL SHIFT can now be found.
  $03A6 Reduce the range to give +20 to +29.
  $03A8 Separate the '@' character from the others.
  $03AC The '_' character has also to be separated.
  $03AE Return now with the 'final codes' +21, +23 to +29.
  $03AF,3,c2,1 Give the '_' character a code of +5F.
@ $03B2 label=K_AT_CHAR
  $03B2,3,c2,1 Give the '@' character a code of +40.
@ $03B5 label=BEEPER
c $03B5 THE 'BEEPER' SUBROUTINE
D $03B5 The loudspeaker is activated by having D4 low during an OUT instruction that is using port '254'. When D4 is high in a similar situation the loudspeaker is deactivated. A 'beep' can therefore be produced by regularly changing the level of D4.
D $03B5 Consider now the note 'middle C' which has the frequency 261.63 Hz. In order to get this note the loudspeaker will have to be alternately activated and deactivated every 1/523.26th of a second. In the Spectrum the system clock is set to run at 3.5 MHz. and the note of 'middle C' will require that the requisite OUT instruction be executed as close as possible to every 6689 T states. This last value, when reduced slightly for unavoidable overheads, represents the 'length of the timing loop' in this subroutine.
D $03B5 This subroutine is entered with the #REGde register pair holding the value 'f*t', where a note of given frequency 'f' is to have a duration of 't' seconds, and the #REGhl register pair holding a value equal to the number of T states in the 'timing loop' divided by 4, i.e. for the note 'middle C' to be produced for one second #REGde holds +0105 (INT(261.3*1)) and #REGhl holds +066A (derived from 6689/4-30.125).
  $03B5 Disable the interrupt for the duration of a 'beep'.
  $03B6 Save #REGl temporarily.
  $03B7 Each '1' in the #REGl register is to count 4 T states, but take INT (#REGl/4) and count 16 T states instead.
  $03BB Go back to the original value in #REGl and find how many were lost by taking 3-(#REGa mod 4).
@ $03C1 nowarn
  $03C1 The base address of the timing loop.
  $03C5 Alter the length of the timing loop. Use an earlier starting point for each '1' lost by taking INT (#REGl/4).
  $03C7 Fetch the present border colour and move it to bits 2, 1 and 0 of the #REGa register.
  $03CF Ensure the MIC output is 'off'.
N $03D1 Now enter the sound generation loop. #REGde complete passes are made, i.e. a pass for each cycle of the note.
@ $03D1 label=BE_IX_3
N $03D1 The #REGhl register holds the 'length of the timing loop' with 16 T states being used for each '1' in the #REGl register and 1024 T states for each '1' in the #REGh register.
  $03D1 Add 4 T states for each earlier entry port that is used.
@ $03D2 label=BE_IX_2
@ $03D3 label=BE_IX_1
@ $03D4 label=BE_IX_0
  $03D4 The values in the #REGb and #REGc registers will come from the #REGh and #REGl registers - see below.
@ $03D6 label=BE_H_L_LP
  $03D6 The 'timing loop', i.e. #REGbc*4 T states. (But note that at the half-cycle point, #REGc will be equal to #REGl+1.)
N $03DF The loudspeaker is now alternately activated and deactivated.
  $03DF Flip bit 4.
  $03E1 Perform the OUT operation, leaving the border unchanged.
  $03E3 Reset the #REGb register.
  $03E4 Save the #REGa register.
  $03E5 Jump if at the half-cycle point.
N $03E9 After a full cycle the #REGde register pair is tested.
  $03E9 Jump forward if the last complete pass has been made already.
  $03ED Fetch the saved value.
  $03EE Reset the #REGc register.
  $03EF Decrease the pass counter.
  $03F0 Jump back to the required starting location of the loop.
N $03F2 The parameters for the second half-cycle are set up.
@ $03F2 label=BE_AGAIN
  $03F2 Reset the #REGc register.
  $03F3 Add 16 T states as this path is shorter.
  $03F4 Jump back.
N $03F6 Upon completion of the 'beep' the maskable interrupt has to be enabled.
@ $03F6 label=BE_END
  $03F6 Enable interrupt.
  $03F7 Finally return.
@ $03F8 label=BEEP
c $03F8 THE 'BEEP' COMMAND ROUTINE
D $03F8 The address of this routine is found in the #R$1AE3(parameter table).
D $03F8 The subroutine is entered with two numbers on the calculator stack. The topmost number (P) represents the 'pitch' of the note and the number underneath it (t) represents the 'duration'.
  $03F8 The floating-point calculator is used to manipulate the two values: t, P.
B $03F9,1 #R$33C0: t, P, P
B $03FA,1 #R$36AF: t, P, i (where i=INT P)
B $03FB,1 #R$342D(st_mem_0): t, P, i (mem-0 holds i)
B $03FC,1 #R$300F: t, p (where p is the fractional part of P)
B $03FD,6,1,5 #R$33C6: Stack the decimal value K=0.0577622606 (which is a little below 12*(2#power0.5)-1)
B $0403,1 #R$30CA: t, pK
B $0404,1 #R$341B(stk_one): t, pK, 1
B $0405,1 #R$3014: t, pK+1
B $0406,1 #R$369B
N $0407 Now perform several tests on i, the integer part of the 'pitch'.
  $0407 This is 'mem-0-1st' (MEMBOT).
  $040A Fetch the exponent of i.
  $040B Give an error if i is not in the integral (short) form.
  $040E Copy the sign byte to the #REGc register.
  $0410 Copy the low-byte to the #REGb register, and to the #REGa register.
  $0413 Again give report B if i does not satisfy the test: -128<=i<=+127.
  $041C Fetch the low-byte and test it further.
  $041F Accept -60<=i<=67.
  $0422 Reject -128 to -61.
N $0425 Note: the range +70 to +127 will be rejected later on.
N $0425 The correct frequency for the 'pitch' i can now be found.
@ $0425 label=BE_i_OK
  $0425 Start '6' octaves below middle C.
@ $0427 label=BE_OCTAVE
  $0427 Repeatedly reduce i in order to find the correct octave.
  $042C Add back the last subtraction.
  $042E Save the octave number.
  $042F The base address of the '#R$046E(semitone table)'.
  $0432 Consider the table and pass the 'A th.' value to the calculator stack. (Call it C.)
N $0438 Now the fractional part of the 'pitch' can be taken into consideration.
  $0438 t, pK+1, C
B $0439,1 #R$30CA: t, C(pK+1)
B $043A,1 #R$369B
N $043B The final frequency f is found by modifying the 'last value' according to the octave number.
  $043B Fetch the octave number.
  $043C Multiply the 'last value' by 2 to the power of the octave number.
  $043E t, f
B $043F,1 #R$342D(st_mem_0): Copy the frequency (f) to mem-0
B $0440,1 #R$33A1: t
N $0441 Attention is now turned to the 'duration'.
B $0441,1 #R$33C0
B $0441,1 #R$33C0: t, t
B $0442,1 #R$369B
  $0443 The value 'INT t' must be in the range +00 to +0A.
N $044A The number of complete cycles in the 'beep' is given by f*t so this value is now found.
  $044A t
B $044B,1 #R$340F(get_mem_0): t, f
B $044C,1 #R$30CA: f*t
N $044D The result is left on the calculator stack whilst the length of the 'timing loop' required for the 'beep' is computed.
B $044D,1 #R$340F(get_mem_0)
B $044D,1 #R$340F(get_mem_0): f*t, f
B $044E,6,1,5 #R$33C6: Stack the value (3.5*10#power6)/8=437500
B $0454,1 #R$343C: f*t, 437500, f
B $0455,1 #R$31AF: f*t, 437500/f
B $0456,3,1,2 #R$33C6: f*t, 437500/f, 30.125 (dec.)
B $0459,1 #R$300F: f*t, 437500/f-30.125
B $045A,1 #R$369B
N $045B Note: the value 437500/f gives the 'half-cycle' length of the note and reducing it by 30.125 allows for 120.5 T states in which to actually produce the note and adjust the counters etc.
N $045B The values can now be transferred to the required registers.
  $045B The 'timing loop' value is compressed into the #REGbc register pair and saved.
N $045F Note: if the timing loop value is too large then an error will occur (returning via #R$0008), thereby excluding 'pitch' values of +70 to +127.
  $045F The f*t value is compressed into the #REGbc register pair.
  $0462 Move the 'timing loop' value to the #REGhl register pair.
  $0463 Move the f*t value to the #REGde register pair.
N $0465 However before making the 'beep' test the value f*t.
  $0465 Return if f*t has given the result of 'no cycles' required.
  $0468 Decrease the cycle number and jump to #R$03B5 (making at least one pass).
N $046C Report B - integer out of range.
@ $046C label=REPORT_B
M $046C,2 Call the error handling routine.
B $046D,1
@ $046E label=SEMITONES
b $046E THE 'SEMI-TONE' TABLE
D $046E This table holds the frequencies of the twelve semi-tones in an octave.
  $046E 261.63 Hz - C
  $0473 277.18 Hz - C#
  $0478 293.66 Hz - D
  $047D 311.13 Hz - D#
  $0482 329.63 Hz - E
  $0487 349.23 Hz - F
  $048C 369.99 Hz - F#
  $0491 392.00 Hz - G
  $0496 415.30 Hz - G#
  $049B 440.00 Hz - A
  $04A0 466.16 Hz - A#
  $04A5 493.88 Hz - B
@ $04AA label=PROGNAME
c $04AA THE 'PROGRAM NAME' SUBROUTINE (ZX81)
D $04AA The following subroutine applies to the ZX81 and was not removed when the program was rewritten for the Spectrum.
@ $04C2 nowarn
@ $04C2 label=SA_BYTES
c $04C2 THE 'SA-BYTES' SUBROUTINE
D $04C2 This subroutine is called to save the header information and later the actual program/data block to tape.
  $04C2 Pre-load the machine stack with the address #R$053F.
@ $04C6 keep
  $04C6 This constant will give a leader of about 5 seconds for a 'header'.
  $04C9 Jump forward if saving a header.
@ $04CD keep
  $04CD This constant will give a leader of about 2 seconds for a program/data block.
@ $04D0 label=SA_FLAG
  $04D0 The flag is saved.
  $04D1 The 'length' is incremented and the 'base address' reduced to allow for the flag.
  $04D4 The maskable interrupt is disabled during the save.
  $04D5 Signal 'MIC on' and border to be red.
  $04D7 Give a value to #REGb.
N $04D8 A loop is now entered to create the pulses of the leader. Both the 'MIC on' and the 'MIC off' pulses are 2,168 T states in length. The colour of the border changes from red to cyan with each 'edge'.
@ $04D8 label=SA_LEADER
N $04D8 Note: an 'edge' will be a transition either from 'on' to 'off', or from 'off' to 'on'.
  $04D8 The main timing period.
  $04DA MIC on/off, border red/cyan, on each pass.
  $04DE The main timing constant.
  $04E0 Decrease the low counter.
  $04E1 Jump back for another pulse.
  $04E3 Allow for the longer path (reduce by 13 T states).
  $04E4 Decrease the high counter.
  $04E5 Jump back for another pulse until completion of the leader.
N $04E8 A sync pulse is now sent.
@ $04EA label=SA_SYNC_1
  $04EA MIC off for 667 T states from 'OUT to OUT'.
  $04EC MIC on and red.
  $04EE Signal 'MIC off and cyan'.
  $04F0 MIC on for 735 T States from 'OUT to OUT'.
@ $04F2 label=SA_SYNC_2
  $04F4 Now MIC off and border cyan.
N $04F6 The header v. program/data flag will be the first byte to be saved.
@ $04F6 keep
  $04F6 +3B is a timing constant; +0E signals 'MIC off and yellow'.
  $04F9 Fetch the flag and pass it to the #REGl register for 'sending'.
  $04FB Jump forward into the saving loop.
N $04FE The byte saving loop is now entered. The first byte to be saved is the flag; this is followed by the actual data bytes and the final byte sent is the parity byte that is built up by considering the values of all the earlier bytes.
@ $04FE label=SA_LOOP
  $04FE The 'length' counter is tested and the jump taken when it has reached zero.
  $0502 Fetch the next byte that is to be saved.
@ $0505 label=SA_LOOP_P
  $0505 Fetch the current 'parity'.
  $0506 Include the present byte.
@ $0507 label=SA_START
  $0507 Restore the 'parity'. Note that on entry here the 'flag' value initialises 'parity'.
  $0508 Signal 'MIC on and blue'.
  $050A Set the carry flag. This will act as a 'marker' for the 8 bits of a byte.
  $050B Jump forward.
N $050E When it is time to send the 'parity' byte then it is transferred to the #REGl register for saving.
@ $050E label=SA_PARITY
  $050E Get final 'parity' value.
  $050F Jump back.
N $0511 The following inner loop produces the actual pulses. The loop is entered at #R$0514 with the type of the bit to be saved indicated by the carry flag. Two passes of the loop are made for each bit thereby making an 'off pulse' and an 'on pulse'. The pulses for a reset bit are shorter by 855 T states.
@ $0511 label=SA_BIT_2
  $0511 Come here on the second pass and fetch 'MIC off and yellow'.
  $0512 Set the zero flag to show 'second pass'.
@ $0514 label=SA_BIT_1
  $0514 The main timing loop; always 801 T states on a second pass.
  $0516 Jump, taking the shorter path, if saving a '0'.
  $0518 However if saving a '1' then add 855 T states.
@ $051A label=SA_SET
@ $051C label=SA_OUT
  $051C On the first pass 'MIC on and blue' and on the second pass 'MIC off and yellow'.
  $051E Set the timing constant for the second pass.
  $0520 Jump back at the end of the first pass; otherwise reclaim 13 T states.
  $0523 Clear the carry flag and set #REGa to hold +01 (MIC on and blue) before continuing into the '8 bit loop'.
N $0525 The '8 bit loop' is entered initially with the whole byte in the #REGl register and the carry flag set. However it is re-entered after each bit has been saved until the point is reached when the 'marker' passes to the carry flag leaving the #REGl register empty.
@ $0525 label=SA_8_BITS
  $0525 Move bit 7 to the carry and the 'marker' leftwards.
  $0527 Save the bit unless finished with the byte.
  $052A Decrease the 'counter'.
  $052B Advance the 'base address'.
  $052D Set the timing constant for the first bit of the next byte.
  $052F Return (to #R$053F) if the BREAK key is being pressed.
  $0535 Otherwise test the 'counter' and jump back even if it has reached zero (so as to send the 'parity' byte).
  $053A Exit when the 'counter' reaches +FFFF. But first give a short delay.
@ $053C label=SA_DELAY
E $04C2 Note: a reset bit will give a 'MIC off' pulse of 855 T states followed by a 'MIC on' pulse of 855 T states, whereas a set bit will give pulses of exactly twice as long. Note also that there are no gaps either between the sync pulse and the first bit of the flag, or between bytes.
@ $053F label=SA_LD_RET
c $053F THE 'SA/LD-RET' SUBROUTINE
D $053F This subroutine is common to both saving and loading.
D $053F The border is set to its original colour and the BREAK key tested for a last time.
  $053F Save the carry flag. (It is reset after a loading error.)
  $0540 Fetch the original border colour from its system variable.
  $0545 Move the border colour to bits 2, 1 and 0.
  $0548 Set the border to its original colour.
  $054A Read the BREAK key for a last time.
  $054F Enable the maskable interrupt.
  $0550 Jump unless a break is to be made.
N $0552 Report D - BREAK-CONT repeats.
@ $0552 label=REPORT_D
M $0552,2 Call the error handling routine.
B $0553,1
N $0554 Continue here.
@ $0554 label=SA_LD_END
  $0554 Retrieve the carry flag.
  $0555 Return to the calling routine.
@ $0556 label=LD_BYTES
c $0556 THE 'LD-BYTES' SUBROUTINE
D $0556 This subroutine is called to load the header information and later load or verify an actual block of data from a tape.
  $0556 This resets the zero flag. (#REGd cannot hold +FF.)
  $0557 The #REGa register holds +00 for a header and +FF for a block of data. The carry flag is reset for verifying and set for loading.
  $0558 Restore #REGd to its original value.
  $0559 The maskable interrupt is now disabled.
  $055A The border is made white.
@ $055E nowarn
  $055E Preload the machine stack with the address #R$053F.
  $0562 Make an initial read of port '254'.
  $0564 Rotate the byte obtained but keep only the EAR bit.
  $0567 Signal red border.
  $0569 Store the value in the #REGc register (+22 for 'off' and +02 for 'on' - the present EAR state).
  $056A Set the zero flag.
N $056B The first stage of reading a tape involves showing that a pulsing signal actually exists (i.e. 'on/off' or 'off/on' edges).
@ $056B label=LD_BREAK
  $056B Return if the BREAK key is being pressed.
@ $056C label=LD_START
  $056C Return with the carry flag reset if there is no 'edge' within approx. 14,000 T states. But if an 'edge' is found the border will go cyan.
N $0571 The next stage involves waiting a while and then showing that the signal is still pulsing.
@ $0571 keep
  $0571 The length of this waiting period will be almost one second in duration.
@ $0574 label=LD_WAIT
  $057B Continue only if two edges are found within the allowed time period.
N $0580 Now accept only a 'leader signal'.
@ $0580 label=LD_LEADER
  $0580 The timing constant.
  $0582 Continue only if two edges are found within the allowed time period.
  $0587 However the edges must have been found within about 3,000 T states of each other.
  $058C Count the pair of edges in the #REGh register until '256' pairs have been found.
N $058F After the leader come the 'off' and 'on' parts of the sync pulse.
@ $058F label=LD_SYNC
  $058F The timing constant.
  $0591 Every edge is considered until two edges are found close together - these will be the start and finishing edges of the 'off' sync pulse.
  $059B The finishing edge of the 'on' pulse must exist. (Return carry flag reset.)
N $059F The bytes of the header or the program/data block can now be loaded or verified. But the first byte is the type flag.
  $059F The border colours from now on will be blue and yellow.
  $05A3 Initialise the 'parity matching' byte to zero.
  $05A5 Set the timing constant for the flag byte.
  $05A7 Jump forward into the byte loading loop.
N $05A9 The byte loading loop is used to fetch the bytes one at a time. The flag byte is first. This is followed by the data bytes and the last byte is the 'parity' byte.
@ $05A9 label=LD_LOOP
  $05A9 Fetch the flags.
  $05AA Jump forward only when handling the first byte.
  $05AC Jump forward if verifying a tape.
  $05AE Make the actual load when required.
  $05B1 Jump forward to load the next byte.
@ $05B3 label=LD_FLAG
  $05B3 Keep the carry flag in a safe place temporarily.
  $05B5 Return now if the type flag does not match the first byte on the tape. (Carry flag reset.)
  $05B7 Restore the carry flag now.
  $05BA Increase the counter to compensate for its 'decrease' after the jump.
N $05BD If a data block is being verified then the freshly loaded byte is tested against the original byte.
@ $05BD label=LD_VERIFY
  $05BD Fetch the original byte.
  $05C0 Match it against the new byte.
  $05C1 Return if 'no match'. (Carry flag reset.)
N $05C2 A new byte can now be collected from the tape.
@ $05C2 label=LD_NEXT
  $05C2 Increase the 'destination'.
@ $05C4 label=LD_DEC
  $05C4 Decrease the 'counter'.
  $05C5 Save the flags.
  $05C6 Set the timing constant.
@ $05C8 label=LD_MARKER
  $05C8 Clear the 'object' register apart from a 'marker' bit.
N $05CA The following loop is used to build up a byte in the #REGl register.
@ $05CA label=LD_8_BITS
  $05CA Find the length of the 'off' and 'on' pulses of the next bit.
  $05CD Return if the time period is exceeded. (Carry flag reset.)
  $05CE Compare the length against approx. 2,400 T states, resetting the carry flag for a '0' and setting it for a '1'.
  $05D1 Include the new bit in the #REGl register.
  $05D3 Set the timing constant for the next bit.
  $05D5 Jump back whilst there are still bits to be fetched.
N $05D8 The 'parity matching' byte has to be updated with each new byte.
  $05D8 Fetch the 'parity matching' byte and include the new byte.
  $05DA Save it once again.
N $05DB Passes round the loop are made until the 'counter' reaches zero. At that point the 'parity matching' byte should be holding zero.
  $05DB Make a further pass if the #REGde register pair does not hold zero.
  $05DF Fetch the 'parity matching' byte.
  $05E0 Return with the carry flag set if the value is zero. (Carry flag reset if in error.)
@ $05E3 label=LD_EDGE_2
c $05E3 THE 'LD-EDGE-2' AND 'LD-EDGE-1' SUBROUTINES
D $05E3 These two subroutines form the most important part of the LOAD/VERIFY operation.
D $05E3 The subroutines are entered with a timing constant in the #REGb register, and the previous border colour and 'edge-type' in the #REGc register.
D $05E3 The subroutines return with the carry flag set if the required number of 'edges' have been found in the time allowed, and the change to the value in the #REGb register shows just how long it took to find the 'edge(s)'.
D $05E3 The carry flag will be reset if there is an error. The zero flag then signals 'BREAK pressed' by being reset, or 'time-up' by being set.
D $05E3 The entry point #R$05E3 is used when the length of a complete pulse is required and #R$05E7 is used to find the time before the next 'edge'.
  $05E3 In effect call #R$05E7 twice, returning in between if there is an error.
@ $05E7 label=LD_EDGE_1
  $05E7 Wait 358 T states before entering the sampling loop.
@ $05E9 label=LD_DELAY
N $05ED The sampling loop is now entered. The value in the #REGb register is incremented for each pass; 'time-up' is given when #REGb reaches zero.
@ $05ED label=LD_SAMPLE
  $05ED Count each pass.
  $05EE Return carry reset and zero set if 'time-up'.
  $05EF Read from port +7FFE, i.e. BREAK and EAR.
  $05F3 Shift the byte.
  $05F4 Return carry reset and zero reset if BREAK was pressed.
  $05F5 Now test the byte against the 'last edge-type'; jump back unless it has changed.
N $05FA A new 'edge' has been found within the time period allowed for the search. So change the border colour and set the carry flag.
  $05FA Change the 'last edge-type' and border colour.
  $05FD Keep only the border colour.
  $05FF Signal 'MIC off'.
  $0601 Change the border colour (red/cyan or blue/yellow).
  $0603 Signal the successful search before returning.
E $05E3 Note: the #R$05E7 subroutine takes 465 T states, plus an additional 58 T states for each unsuccessful pass around the sampling loop.
E $05E3 For example, therefore, when awaiting the sync pulse (see #R$058F) allowance is made for ten additional passes through the sampling loop. The search is thereby for the next edge to be found within, roughly, 1100 T states (465+10*58+overhead). This will prove successful for the sync 'off' pulse that comes after the long 'leader pulses'.
@ $0605 label=SAVE_ETC
c $0605 THE 'SAVE, LOAD, VERIFY and MERGE' COMMAND ROUTINES
D $0605 This entry point is used for all four commands. The value held in T-ADDR, however, distinguishes between the four commands. The first part of the following routine is concerned with the construction of the 'header information' in the work space.
  $0605 Drop the address - #R$1B52.
  $0606 Reduce T-ADDR-lo by +E0, giving +00 for SAVE, +01 for LOAD, +02 for VERIFY and +03 for MERGE.
  $060E Pass the parameters of the 'name' to the calculator stack.
  $0611 Jump forward if checking syntax.
@ $0616 keep
  $0616 Allow seventeen locations for the header of a SAVE but thirty four for the other commands.
@ $0621 label=SA_SPACE
  $0621 The required amount of space is made in the work space.
  $0622 Copy the start address to the #REGix register pair.
  $0625,8,2,c2,4 A program name can have up to ten characters but first enter eleven space characters into the prepared area.
@ $0629 label=SA_BLANK
  $062D A null name is +FF only.
  $0631 The parameters of the name are fetched and its length is tested.
  $0634 This is '-10'.
  $0637 In effect jump forward if the length of the name is not too long (i.e. no more than ten characters).
  $063C But allow for the LOADing, VERIFYing and MERGEing of programs with 'null' names or extra long names.
@ $0642 label=REPORT_F
N $0642 Report F - Invalid file name.
M $0642,2 Call the error handling routine.
B $0643,1
@ $0644 label=SA_NULL
N $0644 Continue to handle the name of the program.
  $0644 Jump forward if the name has a 'null' length.
@ $0648 keep
  $0648 But truncate longer names.
@ $064B label=SA_NAME
N $064B The name is now transferred to the work space (second location onwards).
  $064B Copy the start address to the #REGhl register pair.
  $064E Step to the second location.
  $064F Switch the pointers over and copy the name.
@ $0652 label=SA_DATA
N $0652 The many different parameters, if any, that follow the command are now considered. Start by handling 'xxx "name" DATA'.
  $0652 Is the present code the token 'DATA'?
  $0655 Jump if not.
  $0657 However it is not possible to have 'MERGE name DATA'.
  $065F Advance CH-ADD.
  $0660 Look in the variables area for the array.
  $0663 Set bit 7 of the array's name.
  $0665 Jump if handling an existing array.
@ $0667 keep
  $0667 Signal 'using a new array'.
  $066A Consider the value in T-ADDR and give an error if trying to SAVE or VERIFY a new array.
@ $0670 label=REPORT_2
N $0670 Report 2 - Variable not found.
M $0670,2 Call the error handling routine.
B $0671,1
@ $0672 label=SA_V_OLD
N $0672 Continue with the handling of an existing array.
  $0672 Note: this fails to exclude simple strings.
  $0675 Jump forward if checking syntax.
  $067A Point to the 'low length' of the variable.
  $067B The low length byte goes into the work space, followed by the high length byte.
  $0684 Step past the length bytes.
@ $0685 label=SA_V_NEW
N $0685 The next part is common to both 'old' and 'new' arrays. Note: syntax path error.
  $0685 Copy the array's name.
  $0688 Assume an array of numbers.
  $068A Jump if it is so.
  $068E It is an array of characters.
@ $068F label=SA_V_TYPE
  $068F Save the 'type' in the first location of the header area.
@ $0692 label=SA_DATA_1
N $0692 The last part of the statement is examined before joining the other pathways.
  $0692 Save the pointer in #REGde.
  $0693,3,1,c2 Is the next character a ')'?
  $0696 Give report C if it is not.
  $0698 Advance CH-ADD.
  $0699 Move on to the next statement if checking syntax.
  $069C Return the pointer to the #REGhl register pair before jumping forward. (The pointer indicates the start of an existing array's contents.)
@ $06A0 label=SA_SCR
N $06A0 Now consider 'SCREEN$'.
  $06A0 Is the present code the token SCREEN$?
  $06A2 Jump if not.
  $06A4 However it is not possible to have 'MERGE name SCREEN$'.
  $06AC Advance CH-ADD.
  $06AD Move on to the next statement if checking syntax.
  $06B0 The display area and the attribute area occupy +1B00 locations and these locations start at +4000; these details are passed to the header area in the work space.
  $06C1 Jump forward.
@ $06C3 label=SA_CODE
N $06C3 Now consider 'CODE'.
  $06C3 Is the present code the token 'CODE'?
  $06C5 Jump if not.
  $06C7 However it is not possible to have 'MERGE name CODE'.
  $06CF Advance CH-ADD.
  $06D0 Jump forward if the statement has not finished.
  $06D5 However it is not possible to have 'SAVE name CODE' by itself.
  $06DC Put a zero on the calculator stack - for the 'start'.
  $06DF Jump forward.
@ $06E1 label=SA_CODE_1
N $06E1 Look for a 'starting address'.
  $06E1 Fetch the first number.
  $06E4,3,1,c2 Is the present character a comma?
  $06E7 Jump if it is - the number was a 'starting address'.
  $06E9 However refuse 'SAVE name CODE' that does not have a 'start' and a 'length'.
@ $06F0 label=SA_CODE_2
  $06F0 Put a zero on the calculator stack - for the 'length'.
  $06F3 Jump forward.
@ $06F5 label=SA_CODE_3
N $06F5 Fetch the 'length' as it was specified.
  $06F5 Advance CH-ADD.
  $06F6 Fetch the 'length'.
@ $06F9 label=SA_CODE_4
N $06F9 The parameters are now stored in the header area of the work space.
  $06F9 But move on to the next statement now if checking syntax.
  $06FC Compress the 'length' into the #REGbc register pair and store it.
  $0705 Compress the 'starting address' into the #REGbc register pair and store it.
  $070E Transfer the 'pointer' to the #REGhl register pair as usual.
@ $0710 label=SA_TYPE_3
N $0710 'SCREEN$' and 'CODE' are both of type 3.
  $0710 Enter the 'type' number.
  $0714 Rejoin the other pathways.
@ $0716 label=SA_LINE
N $0716 Now consider 'LINE' and 'no further parameters'.
  $0716 Is the present code the token 'LINE'?
  $0718 Jump if it is.
  $071A Move on to the next statement if checking syntax.
  $071D When there are no further parameters an +80 is entered.
  $0721 Jump forward.
@ $0723 label=SA_LINE_1
N $0723 Fetch the 'line number' that must follow 'LINE'.
  $0723 However only allow 'SAVE name LINE number'.
  $072A Advance CH-ADD.
  $072B Pass the number to the calculator stack.
  $072E Move on to the next statement if checking syntax.
  $0731 Compress the 'line number' into the #REGbc register pair and store it.
@ $073A label=SA_TYPE_0
N $073A 'LINE' and 'no further parameters' are both of type 0.
  $073A Enter the 'type' number.
N $073E The parameters that describe the program, and its variables, are found and stored in the header area of the work space.
  $073E The pointer to the end of the variables area.
  $0741 The pointer to the start of the BASIC program.
  $0745 Now perform the subtraction to find the length of the 'program + variables'; store the result.
  $074E Repeat the operation but this time storing the length of the 'program' only.
  $0759 Transfer the 'pointer' to the #REGhl register pair as usual.
@ $075A label=SA_ALL
N $075A In all cases the header information has now been prepared.
N $075A #LIST { The location 'IX+00' holds the type number. } { Locations 'IX+01 to IX+0A' hold the name (+FF in 'IX+01' if null). } { Locations 'IX+0B and IX+0C' hold the number of bytes that are to be found in the 'data block'. } { Locations 'IX+0D to IX+10' hold a variety of parameters whose exact interpretation depends on the 'type'. } LIST#
N $075A The routine continues with the first task being to separate SAVE from LOAD, VERIFY and MERGE.
  $075A Jump forward when handling a SAVE command.
N $0761 In the case of a LOAD, VERIFY or MERGE command the first seventeen bytes of the 'header area' in the work space hold the prepared information, as detailed above; and it is now time to fetch a 'header' from the tape.
  $0761 Save the 'destination' pointer.
@ $0762 keep
  $0762 Form in the #REGix register pair the base address of the 'second header area'.
@ $0767 label=LD_LOOK_H
N $0767 Now enter a loop, leaving it only when a 'header' has been LOADed.
  $0767 Make a copy of the base address.
@ $0769 keep
  $0769 LOAD seventeen bytes.
  $076C Signal 'header'.
  $076D Signal 'LOAD'.
  $076E Now look for a header.
  $0771 Retrieve the base address.
  $0773 Go round the loop until successful.
N $0775 The new 'header' is now displayed on the screen but the routine will only proceed if the 'new' header matches the 'old' header.
  $0775 Ensure that channel 'S' is open.
  $077A Set the scroll counter.
  $077E Signal 'names do not match'.
  $0780 Compare the 'new' type against the 'old' type.
  $0786 Jump if the 'types' do not match.
  $0788 But if they do, signal 'ten characters are to match'.
@ $078A label=LD_TYPE
  $078A Clearly the 'header' is nonsense if 'type 4 or more'.
@ $078E ssub=LD DE,$09C1-1
N $078E The appropriate message - 'Program:', 'Number array:', 'Character array:' or 'Bytes:' is printed.
  $078E The base address of the message block.
  $0791 Save the #REGc register whilst the appropriate message is printed.
N $0796 The 'new name' is printed and as this is done the 'old' and the 'new' names are compared.
  $0796 Make the #REGde register pair point to the 'new name' and the #REGhl register pair to the 'old name'.
  $079D Ten characters are to be considered.
  $079F Jump forward if the match is to be against an actual name.
  $07A3 But if the 'old name' is 'null' then signal 'ten characters already match'.
@ $07A6 label=LD_NAME
N $07A6 A loop is entered to print the characters of the 'new name'. The name will be accepted if the 'counter' reaches zero, at least.
  $07A6 Consider each character of the 'new name' in turn.
  $07A8 Match it against the appropriate character of the 'old name'.
  $07AA Do not count it if it does not does not match.
@ $07AD label=LD_CH_PR
  $07AD Print the 'new' character.
  $07AE Loop for ten characters.
  $07B0 Accept the name only if the counter has reached zero.
  $07B4 Follow the 'new name' with a 'carriage return'.
N $07B7 The correct header has been found and the time has come to consider the three commands LOAD, VERIFY, and MERGE separately.
  $07B7 Fetch the pointer.
  $07B8 'SCREEN$' and 'CODE' are handled with VERIFY.
  $07BF Jump forward if using a LOAD command.
  $07C6 Jump forward if using a MERGE command; continue into #R$07CB with a VERIFY command.
@ $07CB label=VR_CONTRL
c $07CB THE 'VERIFY' CONTROL ROUTINE
D $07CB The verification process involves the loading of a block of data, a byte at a time, but the bytes are not stored - only checked. This routine is also used to load blocks of data that have been described with 'SCREEN$' or 'CODE'.
  $07CB Save the 'pointer'.
  $07CC Fetch the 'number of bytes' as described in the 'old' header.
  $07D2 Fetch also the number from the 'new' header.
  $07D8 Jump forward if the 'length' is unspecified, e.g. 'LOAD name CODE' only.
  $07DC Give report R if attempting to load a larger block than has been requested.
  $07E0 Accept equal 'lengths'.
  $07E2 Also give report R if trying to verify blocks that are of unequal size. ('Old length' greater than 'new length'.)
N $07E9 The routine continues by considering the 'destination pointer'.
@ $07E9 label=VR_CONT_1
  $07E9 Fetch the 'pointer', i.e. the 'start'.
  $07EA This 'pointer' will be used unless it is zero, in which case the 'start' found in the 'new' header will be used instead.
N $07F4 The verify/load flag is now considered and the actual load made.
@ $07F4 label=VR_CONT_2
  $07F4 Move the 'pointer' to the #REGix register pair.
  $07F7 Jump forward unless using the VERIFY command, with the carry flag signalling 'LOAD'.
  $07FF Signal 'VERIFY'.
@ $0800 label=VR_CONT_3
  $0800 Signal 'accept data block only' before loading the block.
@ $0802 label=LD_BLOCK
c $0802 THE 'LOAD A DATA BLOCK' SUBROUTINE
@ $0806 label=REPORT_R
D $0802 This subroutine is common to all the tape loading routines. In the case of LOAD and VERIFY it acts as a full return from the cassette handling routines but in the case of MERGE the data block has yet to be merged.
  $0802 Load/verify a data block.
  $0805 Return unless an error.
N $0806 Report R - Tape loading error.
@ $0806 label=REPORT_R
M $0806,2 Call the error handling routine.
B $0807,1
@ $0808 label=LD_CONTRL
c $0808 THE 'LOAD' CONTROL ROUTINE
D $0808 This routine controls the LOADing of a BASIC program, and its variables, or an array.
  $0808 Fetch the 'number of bytes' as given in the 'new header'.
  $080E Save the 'destination pointer'.
  $080F Jump forward unless trying to LOAD a previously undeclared array.
  $0813 Add three bytes to the length - for the name, the low length and the high length of a new variable.
  $0817 Jump forward.
N $0819 Consider now if there is enough room in memory for the new data block.
@ $0819 label=LD_CONT_1
  $0819 Fetch the size of the existing 'program+variables or array'.
  $0820 Jump forward if no extra room will be required (taking into account the reclaiming of the presently used memory).
N $0825 Make the actual test for room.
@ $0825 keep
@ $0825 label=LD_CONT_2
  $0825 Allow an overhead of five bytes.
  $0829 Move the result to the #REGbc register pair and make the test.
N $082E Now deal with the LOADing of arrays.
@ $082E label=LD_DATA
  $082E Fetch the 'pointer' anew.
  $082F Jump forward if LOADing a BASIC program.
  $0835 Jump forward if LOADing a new array.
  $0839 Fetch the 'length' of the existing array by collecting the length bytes from the variables area.
  $083D Point to its old name.
  $083E Add three bytes to the length - one for the name and two for the 'length'.
  $0841 Save the #REGix register pair temporarily whilst the old array is reclaimed.
N $084C Space is now made available for the new array - at the end of the present variables area.
@ $084C label=LD_DATA_1
  $084C Find the pointer to the end-marker of the variables area - the '80-byte'.
  $0850 Fetch the 'length' of the new array.
  $0856 Save this 'length'.
  $0857 Add three bytes - one for the name and two for the 'length'.
  $085A '#REGix+0E' of the old header gives the name of the array.
  $085D The name is saved whilst the appropriate amount of room is made available. In effect #REGbc spaces before the 'new 80-byte'.
  $0863 The name is entered.
  $0864 The 'length' is fetched and its two bytes are also entered.
  $0869 #REGhl now points to the first location that is to be filled with data from the tape.
  $086A This address is moved to the #REGix register pair; the carry flag set; 'data block' is signalled; and the block LOADed.
N $0873 Now deal with the LOADing of a BASIC program and its variables.
@ $0873 label=LD_PROG
  $0873 Save the 'destination pointer'.
  $0874 Find the address of the end marker of the current variables area - the '80-byte'.
  $0878 Save #REGix temporarily.
  $087C Fetch the 'length' of the new data block.
  $0882 Keep a copy of the 'length' whilst the present program and variables areas are reclaimed.
  $0887 Save the pointer to the program area and the length of the new data block.
  $0889 Make sufficient room available for the new program and its variables.
  $088C Restore the #REGix register pair.
  $0890 The system variable VARS has also to be set for the new program.
  $089B If a line number was specified then it too has to be considered.
  $08A1 Jump if 'no number'; otherwise set NEWPPC and NSPPC.
N $08AD The data block can now be LOADed.
@ $08AD label=LD_PROG_1
  $08AD Fetch the 'length'.
  $08AE Fetch the 'start'.
  $08B0 Signal 'LOAD'.
  $08B1 Signal 'data block' only.
  $08B3 Now LOAD it.
@ $08B6 label=ME_CONTRL
c $08B6 THE 'MERGE' CONTROL ROUTINE
D $08B6 There are three main parts to this routine.
D $08B6 #LIST { Load the data block into the work space. } { Merge the lines of the new program into the old program. } { Merge the new variables into the old variables. } LIST#
D $08B6 Start therefore with the loading of the data block.
  $08B6 Fetch the 'length' of the data block.
  $08BC Save a copy of the 'length'.
  $08BD Now make 'length+1' locations available in the work space.
  $08BF Place an end marker in the extra location.
  $08C1 Move the 'start' pointer to the #REGhl register pair.
  $08C2 Fetch the original 'length'.
  $08C3 Save a copy of the 'start'.
  $08C4 Now set the #REGix register pair for the actual load.
  $08C7 Signal 'LOAD'.
  $08C8 Signal 'data block only'.
  $08CA Load the data block.
N $08CD The lines of the new program are merged with the lines of the old program.
  $08CD Fetch the 'start' of the new program.
  $08CE Initialise #REGde to the 'start' of the old program.
N $08D2 Enter a loop to deal with the lines of the new program.
@ $08D2 label=ME_NEW_LP
  $08D2 Fetch a line number and test it.
  $08D5 Jump when finished with all the lines.
N $08D7 Now enter an inner loop to deal with the lines of the old program.
@ $08D7 label=ME_OLD_LP
  $08D7 Fetch the high line number byte and compare it. Jump forward if it does not match but in any case advance both pointers.
  $08DD Repeat the comparison for the low line number bytes.
@ $08DF label=ME_OLD_L1
  $08DF Now retreat the pointers.
  $08E1 Jump forward if the correct place has been found for a line of the new program.
  $08E3 Otherwise find the address of the start of the next old line.
  $08E9 Go round the loop for each of the 'old lines'.
@ $08EB label=ME_NEW_L2
  $08EB Enter the 'new line' and go round the outer loop again.
N $08F0 In a similar manner the variables of the new program are merged with the variables of the old program.
@ $08F0 label=ME_VAR_LP
  $08F0 the new variables in turn.
  $08F0 Fetch each variable name in turn and test it.
  $08F2 Return when all the variables have been considered.
  $08F5 Save the current new pointer.
  $08F6 Fetch VARS (for the old program).
N $08F9 Now enter an inner loop to search the existing variables area.
@ $08F9 label=ME_OLD_VP
  $08F9 Fetch each variable name and test it.
  $08FC Jump forward once the end marker is found. (Make an 'addition'.)
  $08FE Compare the names (first bytes).
  $08FF Jump forward to consider it further, returning here if it proves not to match fully.
@ $0901 label=ME_OLD_V1
  $0901 Save the new variable's name whilst the next 'old variable' is located.
  $0906 Restore the pointer to the #REGde register pair and go round the loop again.
N $0909 The old and new variables match with respect to their first bytes but variables with long names will need to be matched fully.
@ $0909 label=ME_OLD_V2
  $0909 Consider bits 7, 6 and 5 only.
  $090B Accept all the variable types except 'long named variables'.
  $090F Make #REGde point to the first character of the 'new name'.
  $0911 Save the pointer to the 'old name'.
N $0912 Enter a loop to compare the letters of the long names.
@ $0912 label=ME_OLD_V3
  $0912 Update both the 'old' and the 'new' pointers.
  $0914 Compare the two letters Jump forward if the match fails.
  $0918 Go round the loop until the 'last character' is found.
  $091B Fetch the pointer to the start of the 'old' name and jump forward - successful.
@ $091E label=ME_OLD_V4
  $091E Fetch the pointer and jump back - unsuccessful.
N $0921 Come here if the match was found.
@ $0921 label=ME_VAR_L1
  $0921 Signal 'replace' variable.
N $0923 And here if not. (#REGa holds +80 - variable to be 'added'.)
@ $0923 label=ME_VAR_L2
  $0923 Fetch pointer to 'new' name.
  $0924 Switch over the registers.
  $0925 The zero flag is to be set if there is to be a 'replacement', reset for an 'addition'.
  $0926 Signal 'handling variables'.
  $0927 Now make the entry.
  $092A Go round the loop to consider the next new variable.
@ $092C label=ME_ENTER
c $092C THE 'MERGE A LINE OR A VARIABLE' SUBROUTINE
D $092C This subroutine is entered with the following parameters:
D $092C #LIST { Carry flag reset - MERGE a BASIC line. } { Carry flag set - MERGE a variable. } { Zero flag reset - it will be an 'addition'. } { Zero flag set - it is a 'replacement'. } { #REGhl register pair - points to the start of the new entry. } { #REGde register pair - points to where it is to MERGE. } LIST#
  $092C Jump if handling an 'addition'.
  $092E Save the flags.
  $092F Save the 'new' pointer whilst the 'old' line or variable is reclaimed.
  $093D Restore the flags.
N $093E The new entry can now be made.
@ $093E label=ME_ENT_1
  $093E Save the flags.
  $093F Make a copy of the 'destination' pointer.
  $0940 Find the length of the 'new' variable/line.
  $0943 Save the pointer to the 'new' variable/line.
  $0946 Fetch PROG - to avoid corruption.
  $0949 Save PROG on the stack and fetch the 'new' pointer.
  $094A Save the length.
  $094B Retrieve the flags.
  $094C Jump forward if adding a new variable.
  $094E A new line is added before the 'destination' location.
  $094F,3 Make the room for the new line.
  $0953 Jump forward.
@ $0955 label=ME_ENT_2
  $0955 Make the room for the new variable.
@ $0958 label=ME_ENT_3
  $0958 Point to the first new location.
  $0959 Retrieve the length.
  $095A Retrieve PROG and store it in its correct place.
  $095F Also fetch the 'new' pointer.
  $0963 Again save the length and the 'new' pointer.
  $0965 Switch the pointers and copy the 'new' variable/line into the room made for it.
N $0968 The 'new' variable/line has now to be removed from the work space.
  $0968 Fetch the 'new' pointer.
  $0969 Fetch the length.
  $096A Save the 'old' pointer. (Points to the location after the 'added' variable/line.)
  $096B Remove the variable/line from the work space.
  $096E Return with the 'old' pointer in the #REGde register pair.
@ $0970 label=SA_CONTRL
c $0970 THE 'SAVE' CONTROL ROUTINE
D $0970 The operation of saving a program or a block of data is very straightforward.
  $0970 Save the 'pointer'.
  $0971 Ensure that channel 'K' is open.
  $0976 Signal 'first message'.
  $0977 Print the message 'Start tape, then press any key.' (see #R$09A1).
  $097D Signal 'screen will require to be cleared'.
  $0981 Wait for a key to be pressed.
N $0984 Upon receipt of a keystroke the 'header' is saved.
  $0984 Save the base address of the 'header' on the machine stack.
@ $0986 keep
  $0986 Seventeen bytes are to be saved.
  $0989 Signal 'it is a header'.
  $098A Send the 'header', with a leading 'type' byte and a trailing 'parity' byte.
N $098D There follows a short delay before the program/data block is saved.
  $098D Retrieve the pointer to the 'header'.
  $098F The delay is for fifty interrupts, i.e. one second.
@ $0991 label=SA_1_SEC
  $0994 Fetch the length of the data block that is to be saved.
  $099A Signal 'data block'.
  $099C Fetch the 'start of block pointer' and save the block.
@ $09A1 label=CASSETTE
t $09A1 THE CASSETTE MESSAGES
D $09A1 Each message is given with the last character inverted (+80 hex.).
  $09A1 Initial byte is stepped over.
  $09A2,31,30:B1
@ $09C1 label=BLOCK_HDR
  $09C1,10,B1:8:B1
  $09CB,15,B1:13:B1
  $09DA,18,B1:16:B1
  $09EC,8,B1:6:B1
@ $09F4 label=PRINT_OUT
c $09F4 THE 'PRINT-OUT' ROUTINES
D $09F4 All of the printing to the main part of the screen, the lower part of the screen and the printer is handled by this set of routines.
D $09F4 This routine is entered with the #REGa register holding the code for a control character, a printable character or a token.
  $09F4 The current print position.
  $09F7,5,c2,3 If the code represents a printable character then jump.
  $09FC Print a question mark for codes in the range +00 to +05.
  $0A00 And also for codes +18 to +1F.
@ $0A04 ssub=LD HL,$0A11-6
  $0A04 Base of the #R$0A11(control character table).
  $0A07 Move the code to the #REGde register pair.
  $0A0A Index into the table and fetch the offset.
  $0A0C Add the offset and make an indirect jump to the appropriate subroutine.
@ $0A11 label=CTRL_CHARS
b $0A11 THE 'CONTROL CHARACTER' TABLE
  $0A11 PRINT comma
  $0A12 EDIT
  $0A13 Cursor left
  $0A14 Cursor right
  $0A15 Cursor down
  $0A16 Cursor up
  $0A17 DELETE
  $0A18 ENTER
  $0A19 Not used
  $0A1A Not used
  $0A1B INK control
  $0A1C PAPER control
  $0A1D FLASH control
  $0A1E BRIGHT control
  $0A1F INVERSE control
  $0A20 OVER control
  $0A21 AT control
  $0A22 TAB control
@ $0A23 label=PO_BACK_1
c $0A23 THE 'CURSOR LEFT' SUBROUTINE
D $0A23 The subroutine is entered with the #REGb register holding the current line number and the #REGc register with the current column number.
  $0A23 Move leftwards by one column.
  $0A24 Accept the change unless up against the lefthand side.
  $0A29 If dealing with the printer jump forward.
  $0A2F Go up one line.
  $0A30 Set column value.
  $0A32 Test against top line. Note: this ought to be +19.
  $0A35 Accept the change unless at the top of the screen.
  $0A37 Unacceptable so down a line.
@ $0A38 label=PO_BACK_2
  $0A38 Set to lefthand column.
@ $0A3A label=PO_BACK_3
  $0A3A Make an indirect return via #R$0DD9 and #R$0ADC.
@ $0A3D label=PO_RIGHT
c $0A3D THE 'CURSOR RIGHT' SUBROUTINE
D $0A3D This subroutine performs an operation identical to the BASIC statement 'PRINT OVER 1;CHR$ 32;'.
  $0A3D Fetch P-FLAG and save it on the machine stack.
  $0A41 Set P-FLAG to OVER 1.
  $0A45,c2 A 'space'.
  $0A47 Print the character.
  $0A4A Fetch the old value of P-FLAG.
  $0A4E Finished. Note: the programmer has forgotten to exit via #R$0ADC.
@ $0A4F label=PO_ENTER
c $0A4F THE 'CARRIAGE RETURN' SUBROUTINE
D $0A4F If the printing being handled is going to the printer then a carriage return character leads to the printer buffer being emptied. If the printing is to the screen then a test for 'scroll?' is made before decreasing the line number.
  $0A4F Jump if handling the printer.
  $0A56 Set to lefthand column.
  $0A58 Scroll if necessary.
  $0A5B Now down a line.
  $0A5C Make an indirect return via #R$0DD9 and #R$0ADC.
@ $0A5F label=PO_COMMA
c $0A5F THE 'PRINT COMMA' SUBROUTINE
D $0A5F The current column value is manipulated and the #REGa register set to hold +00 (for TAB 0) or +10 (for TAB 16).
  $0A5F Why again?
  $0A62 Current column number.
  $0A63 Move rightwards by two columns and then test.
  $0A65 The #REGa register will be +00 or +10.
  $0A67 Exit via #R$0AC3.
@ $0A69 label=PO_QUEST
c $0A69 THE 'PRINT A QUESTION MARK' SUBROUTINE
D $0A69 A question mark is printed whenever an attempt is made to print an unprintable code.
  $0A69,c2 The character '?'.
  $0A6B Now print this character instead.
@ $0A6D nowarn
@ $0A6D label=PO_TV_2
c $0A6D THE 'CONTROL CHARACTERS WITH OPERANDS' ROUTINE
D $0A6D The control characters from INK to OVER require a single operand whereas the control characters AT and TAB are required to be followed by two operands.
D $0A6D The present routine leads to the control character code being saved in TVDATA-lo, the first operand in TVDATA-hi or the #REGa register if there is only a single operand required, and the second operand in the #REGa register.
  $0A6D Save the first operand in TVDATA-hi and change the address of the 'output' routine to #R$0A87.
N $0A75 Enter here when handling the characters AT and TAB.
@ $0A75 nowarn
@ $0A75 label=PO_2_OPER
  $0A75 The character code will be saved in TVDATA-lo and the address of the 'output' routine changed to #R$0A6D.
N $0A7A Enter here when handling the colour items - INK to OVER.
@ $0A7A nowarn
@ $0A7A label=PO_1_OPER
  $0A7A The 'output' routine is to be changed to #R$0A87.
@ $0A7D label=PO_TV_1
  $0A7D Save the control character code.
N $0A80 The current 'output' routine address is changed temporarily.
  $0A80 #REGhl will point to the 'output' routine address.
  $0A83 Enter the new 'output' routine address and thereby force the next character code to be considered as an operand.
N $0A87 Once the operands have been collected the routine continues.
@ $0A87 nowarn
@ $0A87 label=PO_CONT
  $0A87 Restore the original address for #R$09F4.
  $0A8D Fetch the control code and the first operand if there are indeed two operands.
  $0A90 The 'last' operand and the control code are moved.
  $0A92 Jump forward if handling INK to OVER.
  $0A97 Jump forward if handling TAB.
N $0A99 Now deal with the AT control character.
  $0A99 The line number.
  $0A9A The column number.
  $0A9B Reverse the column number, i.e. +00 to +1F becomes +1F to +00.
  $0A9E Must be in range.
  $0AA0 Add in the offset to give #REGc holding +21 to +02.
  $0AA3 Jump forward if handling the printer.
  $0AA9 Reverse the line number, i.e. +00 to +15 becomes +16 to +01.
@ $0AAC label=PO_AT_ERR
  $0AAC If appropriate jump forward.
  $0AAF The range +16 to +01 becomes +17 to +02.
  $0AB1 And now +18 to +03.
  $0AB2 If printing in the lower part of the screen then consider whether scrolling is needed.
  $0AB9 Give report 5 - Out of screen, if required.
@ $0ABF label=PO_AT_SET
  $0ABF Return via #R$0DD9 and #R$0ADC.
N $0AC2 And the TAB control character.
@ $0AC2 label=PO_TAB
  $0AC2 Fetch the first operand.
@ $0AC3 label=PO_FILL
  $0AC3 The current print position.
  $0AC6 Add the current column value.
  $0AC7 Find how many spaces, modulo 32, are required and return if the result is zero.
  $0ACB Use #REGd as the counter.
  $0ACC Suppress 'leading space'.
@ $0AD0 label=PO_SPACE
  $0AD0,8,c2,6 Print #REGd number of spaces.
  $0AD8 Now finished.
@ $0AD9 label=PO_ABLE
c $0AD9 PRINTABLE CHARACTER CODES
D $0AD9 The required character (or characters) is printed by calling #R$0B24 followed by #R$0ADC.
  $0AD9 Print the character(s) and continue into #R$0ADC.
@ $0ADC label=PO_STORE
c $0ADC THE 'POSITION STORE' SUBROUTINE
D $0ADC The new position's 'line and column' values and the 'pixel' address are stored in the appropriate system variables.
  $0ADC Jump forward if handling the printer.
  $0AE2 Jump forward if handling the lower part of the screen.
  $0AE8 Save the values that relate to the main part of the screen.
  $0AEF Then return.
@ $0AF0 label=PO_ST_E
  $0AF0 Save the values that relate to the lower part of the screen.
  $0AFB Then return.
@ $0AFC label=PO_ST_PR
  $0AFC Save the values that relate to the printer buffer.
  $0B02 Then return.
@ $0B03 label=PO_FETCH
c $0B03 THE 'POSITION FETCH' SUBROUTINE
D $0B03 The current position's parameters are fetched from the appropriate system variables.
  $0B03 Jump forward if handling the printer.
  $0B09 Fetch the values relating to the main part of the screen and return if this was the intention.
  $0B15,7 Otherwise fetch the values relating to the lower part of the screen.
@ $0B1D label=PO_F_PR
  $0B1D,6 Fetch the values relating to the printer buffer.
@ $0B24 label=PO_ANY
c $0B24 THE 'PRINT ANY CHARACTER(S)' SUBROUTINE
D $0B24 Ordinary character codes, token codes and user-defined graphic codes, and graphic codes are dealt with separately.
  $0B24 Jump forward with ordinary character codes.
  $0B28 Jump forward with token codes and UDG codes.
  $0B2C Move the graphic code.
  $0B2D Construct the graphic form.
  $0B30 #REGhl has been disturbed so 'fetch' again.
  $0B33 Make #REGde point to the start of the graphic form, i.e. MEMBOT.
  $0B36 Jump forward to print the graphic character.
N $0B38 Graphic characters are constructed in an ad hoc manner in the calculator's memory area, i.e. mem-0 and mem-1.
@ $0B38 label=PO_GR_1
  $0B38 This is MEMBOT.
  $0B3B In effect call the following subroutine twice.
@ $0B3E label=PO_GR_2
  $0B3E Determine bit 0 (and later bit 2) of the graphic code.
  $0B41 The #REGa register will hold +00 or +0F depending on the value of the bit in the code.
  $0B43 Save the result in #REGc.
  $0B44 Determine bit 1 (and later bit 3) of the graphic code.
  $0B47 The #REGa register will hold +00 or +F0.
  $0B49 The two results are combined.
  $0B4A The #REGa register holds half the character form and has to be used four times. This is done for the upper half of the character form and then the lower.
@ $0B4C label=PO_GR_3
N $0B52 Token codes and user-defined graphic codes are now separated.
@ $0B52 label=PO_T_UDG
  $0B52 Jump forward with token codes.
  $0B56 UDG codes are now +00 to +0F.
  $0B58 Save the current position values on the machine stack.
  $0B59 Fetch the base address of the UDG area and jump forward.
@ $0B5F label=PO_T
  $0B5F Now print the token and return via #R$0B03.
N $0B65 The required character form is identified.
@ $0B65 label=PO_CHAR
  $0B65 The current position is saved.
  $0B66 The base address of the character area is fetched.
@ $0B6A label=PO_CHAR_2
  $0B6A The print address is saved.
  $0B6B This is FLAGS.
  $0B6E Allow for a leading space.
  $0B70,4,c2,2 Jump forward if the character is not a 'space'.
  $0B74 But 'suppress' if it is.
@ $0B76 label=PO_CHAR_3
  $0B76 Now pass the character code to the #REGhl register pair.
  $0B79 The character code is in effect multiplied by 8.
  $0B7C The base address of the character form is found.
  $0B7D The current position is fetched and the base address passed to the #REGde register pair.
@ $0B7F label=PR_ALL
c $0B7F THE 'PRINT ALL CHARACTERS' SUBROUTINE
D $0B7F This subroutine is used to print all '8*8' bit characters. On entry the #REGde register pair holds the base address of the character form, the #REGhl register the destination address and the #REGbc register pair the current 'line and column' values.
  $0B7F Fetch the column number.
  $0B80 Move one column rightwards.
  $0B81 Jump forward unless a new line is indicated.
  $0B85 Move down one line.
  $0B86 Column number is +21.
  $0B87 Jump forward if handling the screen.
  $0B8D Save the base address whilst the printer buffer is emptied.
  $0B92 Copy the new column number.
@ $0B93 label=PR_ALL_1
  $0B93 Test whether a new line is being used. If it is see if the display requires to be scrolled.
N $0B99 Now consider the present state of INVERSE and OVER.
  $0B99 Save the position values and the destination address on the machine stack.
  $0B9B Fetch P-FLAG and read bit 0.
  $0B9E Prepare the 'OVER mask' in the #REGb register, i.e. OVER 0=+00 and OVER 1=+FF.
@ $0BA4 label=PR_ALL_2
  $0BA4 Read bit 2 of P-FLAG and prepare the 'INVERSE mask' in the #REGc register, i.e. INVERSE 0=+00 and INVERSE 1=+FF.
  $0BA8 Set the #REGa register to hold the 'pixel-line' counter and clear the carry flag.
  $0BAB Jump forward if handling the screen.
  $0BB1 Signal 'printer buffer no longer empty'.
  $0BB5 Set the carry flag to show that the printer is being used.
@ $0BB6 label=PR_ALL_3
  $0BB6 Exchange the destination address with the base address before entering the loop.
N $0BB7 The character can now be printed. Eight passes of the loop are made - one for each 'pixel-line'.
@ $0BB7 label=PR_ALL_4
  $0BB7 The carry flag is set when using the printer. Save this flag in F'.
  $0BB8 Fetch the existing 'pixel-line'.
  $0BB9 Use the 'OVER mask' and then XOR the result with the 'pixel-line' of the character form.
  $0BBB Finally consider the 'INVERSE mask'.
  $0BBC Enter the result.
  $0BBD Fetch the printer flag and jump forward if required.
  $0BC0 Update the destination address.
@ $0BC1 label=PR_ALL_5
  $0BC1 Update the 'pixel-line' address of the character form.
  $0BC2 Decrease the counter and loop back unless it is zero.
N $0BC5 Once the character has been printed the attribute byte is to be set as required.
  $0BC5 Make the #REGh register hold a correct high-address for the character area.
  $0BC7 Set the attribute byte only if handling the screen.
  $0BCE Restore the original destination address and the position values.
  $0BD0 Decrease the column number and increase the destination address before returning.
N $0BD3 When the printer is being used the destination address has to be updated in increments of +20.
  $0BD3 Save the printer flag again.
  $0BD4 The required increment value.
  $0BD6 Add the value and pass the result back to the #REGe register.
  $0BD8 Fetch the flag.
  $0BD9 Jump back into the loop.
@ $0BDB label=PO_ATTR
c $0BDB THE 'SET ATTRIBUTE BYTE' SUBROUTINE
@ $0BFA label=PO_ATTR_1
@ $0C08 label=PO_ATTR_2
D $0BDB The appropriate attribute byte is identified and fetched. The new value is formed by manipulating the old value, ATTR-T, MASK-T and P-FLAG. Finally this new value is copied to the attribute area.
  $0BDB The high byte of the destination address is divided by eight and ANDed with +03 to determine which third of the screen is being addressed, i.e. 00, 01 or 02.
  $0BE1 The high byte for the attribute area is then formed.
  $0BE4 #REGd holds ATTR-T, and #REGe holds MASK-T.
  $0BE8 The old attribute value.
  $0BE9 The values of MASK-T and ATTR-R are taken into account.
  $0BEC Jump forward unless dealing with PAPER 9.
  $0BF2 The old paper colour is ignored and depending on whether the ink colour is light or dark the new paper colour will be black (000) or white (111).
@ $0BFA label=PO_ATTR_1
  $0BFA Jump forward unless dealing with INK 9.
  $0C00 The old ink colour is ignored and depending on whether the paper colour is light or dark the new ink colour will be black (000) or white (111).
@ $0C08 label=PO_ATTR_2
  $0C08 Enter the new attribute value and return.
@ $0C0A label=PO_MSG
c $0C0A THE 'MESSAGE PRINTING' SUBROUTINE
D $0C0A This subroutine is used to print messages and tokens. The #REGa register holds the 'entry number' of the message or token in a table. The #REGde register pair holds the base address of the table.
  $0C0A The high byte of the last entry on the machine stack is made zero so as to suppress trailing spaces (see below).
  $0C0E Jump forward.
N $0C10 Enter here when expanding token codes.
@ $0C10 label=PO_TOKENS
  $0C10 The base address of the #R$0095(token table).
  $0C13 Save the code on the stack. (Range +00 to +5A, RND to COPY).
N $0C14 The table is searched and the correct entry printed.
@ $0C14 label=PO_TABLE
  $0C14 Locate the required entry.
  $0C17 Print the message/token.
  $0C19,9,c2,7 A 'space' will be printed before the message/token if required.
N $0C22 The characters of the message/token are printed in turn.
@ $0C22 label=PO_EACH
  $0C22 Collect a code.
  $0C23 Cancel any 'inverted bit'.
  $0C25 Print the character.
  $0C28 Collect the code again.
  $0C29 Advance the pointer.
  $0C2A The 'inverted bit' goes to the carry flag and signals the end of the message/token; otherwise jump back.
N $0C2D Now consider whether a 'trailing space' is required.
  $0C2D For messages, #REGd holds +00; for tokens, #REGd holds +00 to +5A.
  $0C2E Jump forward if the last character was a '$'.
  $0C32 Return if the last character was any other before 'A'.
@ $0C35 label=PO_TR_SP
  $0C35 Examine the value in #REGd and return if it indicates a message, RND, INKEY$ or PI.
  $0C39,c2 All other cases will require a 'trailing space'.
@ $0C3B label=PO_SAVE
c $0C3B THE 'PO-SAVE' SUBROUTINE
D $0C3B This subroutine allows for characters to be printed 'recursively'. The appropriate registers are saved whilst #R$0010 is called.
  $0C3B Save the #REGde register pair.
  $0C3C Save #REGhl and #REGbc.
  $0C3D Print the single character.
  $0C3E Restore #REGhl and #REGbc.
  $0C3F Restore #REGde.
  $0C40 Finished.
@ $0C41 label=PO_SEARCH
c $0C41 THE 'TABLE SEARCH' SUBROUTINE
D $0C41 The subroutine returns with the #REGde register pair pointing to the initial character of the required entry and the carry flag reset if a 'leading space' is to be considered.
  $0C41 Save the 'entry number'.
  $0C42 #REGhl now holds the base address.
  $0C43 Compensate for the 'DEC A' below.
@ $0C44 label=PO_STEP
  $0C44 Wait for an 'inverted character'.
  $0C49 Count through the entries until the correct one is found.
  $0C4C #REGde points to the initial character.
  $0C4D Fetch the 'entry number' and return with carry set for the first thirty two entries.
  $0C51,4,1,c2,1 However if the intial character is a letter then a leading space may be needed.
@ $0C55 label=PO_SCR
c $0C55 THE 'TEST FOR SCROLL' SUBROUTINE
D $0C55 This subroutine is called whenever there might be the need to scroll the display. This occurs on three occasions:
D $0C55 #LIST { when handling a 'carriage return' character } { when using AT in an INPUT line } { when the current line is full and the next line has to be used } LIST#
D $0C55 On entry the #REGb register holds the line number under test.
  $0C55 Return immediately if the printer is being used.
@ $0C5A nowarn
  $0C5A Pre-load the machine stack with the address of #R$0DD9.
  $0C5E Transfer the line number.
  $0C5F Jump forward if considering 'INPUT ... AT ...'.
  $0C66 Return, via #R$0DD9, if the line number is greater than the value of DF-SZ; give report 5 if it is less; otherwise continue.
  $0C6C Jump forward unless dealing with an 'automatic listing'.
  $0C72 Fetch the line counter.
  $0C75 Decrease this counter.
  $0C76 Jump forward if the listing is to be scrolled.
  $0C78 Otherwise open channel 'K', restore the stack pointer, flag that the automatic listing has finished and return via #R$0DD9.
N $0C86 Report 5 - Out of screen.
@ $0C86 label=REPORT_5
M $0C86,2 Call the error handling routine.
B $0C87,1
N $0C88 Now consider if the prompt 'scroll?' is required.
@ $0C88 label=PO_SCR_2
  $0C88 Decrease the scroll counter and proceed to give the prompt only if it becomes zero.
N $0C8D Proceed to give the prompt message.
  $0C8D The counter is reset.
  $0C93 The current values of ATTR-T and MASK-T are saved.
  $0C97 The current value of P-FLAG is saved.
  $0C9B Channel 'K' is opened.
  $0CA0 The message 'scroll?' is message '0'. This message is now printed.
@ $0CA1 nowarn
  $0CA7 Signal 'clear the lower screen after a keystroke'.
  $0CAB This is FLAGS.
  $0CAE Signal 'L mode'.
  $0CB0 Signal 'no key yet'.
  $0CB2 Note: #REGde should be pushed also.
  $0CB3 Fetch a single key code.
  $0CB6 Restore the registers.
  $0CB7,14,c2,8,c2,2 There is a jump forward to #R$0D00 - 'BREAK - CONT repeats' - if the keystroke was 'BREAK', 'STOP', 'N' or 'n'; otherwise accept the keystroke as indicating the need to scroll the display.
  $0CC5 Open channel 'S'.
  $0CCA Restore the value of P-FLAG.
  $0CCE Restore the values of ATTR-T and MASK-T.
N $0CD2 The display is now scrolled.
@ $0CD2 label=PO_SCR_3
  $0CD2 The whole display is scrolled.
  $0CD5 The line and column numbers for the start of the line above the lower part of the display are found and saved.
  $0CDC The corresponding attribute byte for this character area is then found. The #REGhl register pair holds the address of the byte.
N $0CE8 The line in question will have 'lower part' attribute values and the new line at the bottom of the display may have 'ATTR-P' values so the attribute values are exchanged.
  $0CE8 #REGde points to the first attribute byte of the bottom line.
  $0CEB The value is fetched.
  $0CEC The 'lower part' value.
  $0CED There are thirty two bytes.
  $0CEF Exchange the pointers.
@ $0CF0 label=PO_SCR_3A
  $0CF0 Make the first exchange and then proceed to use the same values for the thirty two attribute bytes of the two lines being handled.
  $0CF6 The line and column numbers of the bottom line of the 'upper part' are fetched before returning.
N $0CF8 The 'scroll?' message.
@ $0CF8 label=SCROLL
B $0CF8,1 Initial marker - stepped over.
T $0CF9,7,6:B1 The '?' is inverted.
N $0D00 Report D - BREAK - CONT repeats.
@ $0D00 label=REPORT_D_2
M $0D00,2 Call the error handling routine.
B $0D01,1
N $0D02 The lower part of the display is handled as follows:
@ $0D02 label=PO_SCR_4
  $0D02 The 'out of screen' error is given if the lower part is going to be 'too large' and a return made if scrolling is unnecessary.
  $0D0C The #REGa register will now hold 'the number of scrolls to be made'.
  $0D0E The line and column numbers are now saved.
  $0D0F The 'scroll number', ATTR-T, MASK-T and P-FLAG are all saved.
  $0D18 The 'permanent' colour items are to be used.
  $0D1B The 'scroll number' is fetched.
N $0D1C The lower part of the screen is now scrolled #REGa number of times.
@ $0D1C label=PO_SCR_4A
  $0D1C Save the 'number'.
  $0D1D This is DF-SZ.
  $0D20 The value in DF-SZ is incremented; the #REGb register set to hold the former value and the #REGa register the new value.
  $0D24 This is S-POSN-hi.
  $0D27 The jump is taken if only the lower part of the display is to be scrolled (#REGb=old DF-SZ).
  $0D2A Otherwise S-POSN-hi is incremented and the whole display scrolled (#REGb=+18).
@ $0D2D label=PO_SCR_4B
  $0D2D Scroll #REGb lines.
  $0D30 Fetch and decrement the 'scroll number'.
  $0D32 Jump back until finished.
  $0D34 Restore the value of P-FLAG.
  $0D38 Restore the values of ATTR-T and MASK-T.
  $0D3C In case S-POSN has been changed #R$0DD9 is called to give a matching value to DF-CC.
  $0D47 Reset the flag to indicate that the lower screen is being handled, fetch the line and column numbers, and then return.
@ $0D4D label=TEMPS
c $0D4D THE 'TEMPORARY COLOUR ITEMS' SUBROUTINE
D $0D4D This is a most important subroutine. It is used whenever the 'permanent' details are required to be copied to the 'temporary' system variables. First ATTR-T and MASK-T are considered.
  $0D4D #REGa is set to hold +00.
  $0D4E The current values of ATTR-P and MASK-P are fetched.
  $0D51 Jump forward if handing the main part of the screen.
  $0D57 Otherwise use +00 and the value in BORDCR instead.
@ $0D5B label=TEMPS_1
  $0D5B Now set ATTR-T and MASK-T.
N $0D5E Next P-FLAG is considered.
  $0D5E This is P-FLAG.
  $0D61 Jump forward if dealing with the lower part of the screen (#REGa=+00).
  $0D63 Otherwise fetch the value of P-FLAG and move the odd bits to the even bits.
@ $0D65 label=TEMPS_2
  $0D65,5,1,b2,2 Proceed to copy the even bits of #REGa to P-FLAG.
@ $0D6B label=CLS
c $0D6B THE 'CLS' COMMAND ROUTINE
D $0D6B The address of this routine is found in the #R$1ABE(parameter table).
D $0D6B In the first instance the whole of the display is 'cleared' - the 'pixels' are all reset and the attribute bytes are set to equal the value in ATTR-P - then the lower part of the display is reformed.
  $0D6B The whole of the display is 'cleared'.
@ $0D6E label=CLS_LOWER
  $0D6E This is TV-FLAG.
  $0D71 Signal 'do not clear the lower screen after keystroke'.
  $0D73 Signal 'lower part'.
  $0D75 Use the permanent values, i.e. ATTR-T is copied from BORDCR.
  $0D78 The lower part of the screen is now 'cleared' with these values.
N $0D7E With the exception of the attribute bytes for lines 22 and 23 the attribute bytes for the lines in the lower part of the display will need to be made equal to ATTR-P.
  $0D7E Attribute byte at start of line 22.
  $0D81 Fetch ATTR-P.
  $0D84 The line counter.
  $0D85 Jump forward into the loop.
@ $0D87 label=CLS_1
  $0D87 +20 characters per line.
@ $0D89 label=CLS_2
  $0D89 Go back along the line setting the attribute bytes.
@ $0D8E label=CLS_3
  $0D8E Loop back until finished.
N $0D90 The size of the lower part of the display can now be fixed.
  $0D90 It will be two lines in size.
N $0D94 It now remains for the following 'house keeping' tasks to be performed.
@ $0D94 label=CL_CHAN
  $0D94 Open channel 'K'.
  $0D99 Fetch the address of the current channel and make the output address #R$09F4 and the input address #R$10A8.
@ $0D9C nowarn
@ $0DA0 label=CL_CHAN_A
@ $0DA4 nowarn
  $0DA7 First the output address then the input address.
@ $0DAA keep
  $0DAA As the lower part of the display is being handled the 'lower print line' will be line 23.
  $0DAD Return via #R$0DD9.
@ $0DAF label=CL_ALL
c $0DAF THE 'CLEARING THE WHOLE DISPLAY AREA' SUBROUTINE
D $0DAF This subroutine is called from #R$0D6B, #R$12A2, and #R$1795.
@ $0DAF keep
  $0DAF The system variable COORDS is reset to zero.
  $0DB5 Signal 'the screen is clear'.
  $0DB9 Perform the 'house keeping' tasks.
  $0DBC Open channel 'S'.
  $0DC1 Use the 'permanent' values.
  $0DC4 Now 'clear' the 24 lines of the display.
  $0DC9 Ensure that the current output address is #R$09F4.
@ $0DCC nowarn
  $0DD2 Reset the scroll counter.
@ $0DD6 keep
  $0DD6 As the upper part of the display is being handled the 'upper print line' will be line 0. Continue into #R$0DD9.
@ $0DD9 label=CL_SET
c $0DD9 THE 'CL-SET' SUBROUTINE
D $0DD9 This subroutine is entered with the #REGbc register pair holding the line and column numbers of a character area, or the #REGc register holding the column number within the printer buffer. The appropriate address of the first character bit is then found. The subroutine returns via #R$0ADC so as to store all the values in the required system variables.
  $0DD9 The start of the printer buffer.
  $0DDC Jump forward if handling the printer buffer.
  $0DE2 Transfer the line number.
  $0DE3 Jump forward if handling the main part of the display.
  $0DE9 The top line of the lower part of the display is called 'line +18' and this has to be converted.
@ $0DEE label=CL_SET_1
  $0DEE The line and column numbers are saved.
  $0DEF The line number is moved.
  $0DF0 The address for the start of the line is formed in #REGhl.
  $0DF3 The line and column numbers are fetched back.
@ $0DF4 label=CL_SET_2
  $0DF4 The column number is now reversed and transferred to the #REGde register pair.
  $0DFA The required address is now formed, and the address and the line and column numbers are stored by jumping to #R$0ADC.
@ $0DFE label=CL_SC_ALL
c $0DFE THE 'SCROLLING' SUBROUTINE
D $0DFE The number of lines of the display that are to be scrolled has to be held on entry to the main subroutine in the #REGb register.
  $0DFE The entry point after 'scroll?'
N $0E00 The main entry point - from above and when scrolling for INPUT...AT.
@ $0E00 label=CL_SCROLL
  $0E00 Find the starting address of the line.
  $0E03 There are eight pixel lines to a complete line.
N $0E05 Now enter the main scrolling loop. The #REGb register holds the number of the top line to be scrolled, the #REGhl register pair the starting address in the display area of this line and the #REGc register the pixel line counter.
@ $0E05 label=CL_SCR_1
  $0E05 Save both counters.
  $0E06 Save the starting address.
  $0E07 Jump forward unless dealing at the present moment with a 'third' of the display.
N $0E0D The pixel lines of the top lines of the 'thirds' of the display have to be moved across the 2K boundaries. (Each 'third' is 2K.)
  $0E0D The result of this manipulation is to leave #REGhl unchanged and #REGde pointing to the required destination.
@ $0E13 keep
  $0E13 There are +20 characters.
  $0E16 Decrease the counter as one line is being dealt with.
  $0E17 Now move the thirty two bytes.
N $0E19 The pixel lines within the 'thirds' can now be scrolled. The #REGa register holds, on the first pass, +01 to +07, +09 to +0F, or +11 to +17.
@ $0E19 label=CL_SCR_3
  $0E19 Again #REGde is made to point to the required destination, this time only thirty two locations away.
  $0E1F Save the line number in #REGb.
  $0E20 Now find how many characters there are remaining in the 'third'.
  $0E25 Pass the 'character total' to the #REGc register.
  $0E26 Fetch the line number.
  $0E27 #REGbc holds the 'character total' and a pixel line from each of the characters is 'scrolled'.
  $0E2B Now prepare to increment the address to jump across a 'third' boundary.
  $0E2D Increase #REGhl by +0700.
  $0E2E Jump back if there are any 'thirds' left to consider.
N $0E32 Now find if the loop has been used eight times - once for each pixel line.
  $0E32 Fetch the original address.
  $0E33 Address the next pixel line.
  $0E34 Fetch the counters.
  $0E35 Decrease the pixel line counter and jump back unless eight lines have been moved.
N $0E38 Next the attribute bytes are scrolled. Note that the #REGb register still holds the number of lines to be scrolled and the #REGc register holds zero.
  $0E38 The required address in the attribute area and the number of characters in #REGb lines are found.
  $0E3B The displacement for all the attribute bytes is thirty two locations away.
  $0E40 The attribute bytes are 'scrolled'.
N $0E42 It remains now to clear the bottom line of the display.
  $0E42 The #REGb register is loaded with +01 and #R$0E44 is entered.
@ $0E44 label=CL_LINE
c $0E44 THE 'CLEAR LINES' SUBROUTINE
D $0E44 This subroutine will clear the bottom #REGb lines of the display.
  $0E44 The line number is saved for the duration of the subroutine.
  $0E45 The starting address for the line is formed in #REGhl.
  $0E48 Again there are eight pixel lines to be considered.
N $0E4A Now enter a loop to clear all the pixel lines.
@ $0E4A label=CL_LINE_1
  $0E4A Save the line number and the pixel line counter.
  $0E4B Save the address.
  $0E4C Save the line number in #REGa.
@ $0E4D label=CL_LINE_2
  $0E4D Find how many characters are involved in '#REGb mod 8' lines. Pass the result to the #REGc register. (#REGc will hold +00 i.e. 256 dec. for a 'third'.)
  $0E53 Fetch the line number.
  $0E54 Make the #REGbc register pair hold one less than the number of characters.
  $0E57 Make #REGde point to the first character.
  $0E59 Clear the pixel-byte of the first character.
  $0E5B Make #REGde point to the second character and then clear the pixel-bytes of all the other characters.
@ $0E5E keep
  $0E5E For each 'third' of the display #REGhl has to be increased by +0701.
  $0E62 Now decrease the line number.
  $0E63 Discard any extra lines and pass the 'third' count to #REGb.
  $0E66 Jump back if there are still 'thirds' to be dealt with.
N $0E68 Now find if the loop has been used eight times.
  $0E68 Update the address for each pixel line.
  $0E6A Fetch the counters.
  $0E6B Decrease the pixel line counter and jump back unless finished.
N $0E6E Next the attribute bytes are set as required. The value in ATTR-P will be used when handling the main part of the display and the value in BORDCR when handling the lower part.
  $0E6E The address of the first attribute byte and the number of bytes are found.
  $0E71 #REGhl will point to the first attribute byte and #REGde the second.
  $0E74 Fetch the value in ATTR-P.
  $0E77 Jump forward if handling the main part of the screen.
  $0E7D Otherwise use BORDCR instead.
@ $0E80 label=CL_LINE_3
  $0E80 Set the attribute byte.
  $0E81 One byte has been done.
  $0E82 Now copy the value to all the attribute bytes.
  $0E84 Restore the line number.
  $0E85 Set the column number to the lefthand column and return.
@ $0E88 label=CL_ATTR
c $0E88 THE 'CL-ATTR' SUBROUTINE
D $0E88 This subroutine has two separate functions.
D $0E88 #LIST { For a given display area address the appropriate attribute address is returned in the #REGde register pair. Note that the value on entry points to the 'ninth' line of a character. } { For a given line number, in the #REGb register, the number of character areas in the display from the start of that line onwards is returned in the #REGbc register pair. } LIST#
  $0E88 Fetch the high byte.
  $0E89 Multiply this value by thirty two.
  $0E8C Go back to the 'eight' line.
  $0E8D Address the attribute area.
  $0E8F Restore to the high byte and transfer the address to #REGde.
  $0E91 This is always zero.
  $0E92 The line number.
  $0E93 Multiply by thirty two.
  $0E98 Move the result to the #REGbc register pair before returning.
@ $0E9B label=CL_ADDR
c $0E9B THE 'CL-ADDR' SUBROUTINE
D $0E9B For a given line number, in the #REGb register, the appropriate display file address is formed in the #REGhl register pair.
  $0E9B The line number has to be reversed.
  $0E9E The result is saved in #REGd.
  $0E9F In effect '(#REGa mod 8)*32'. In a 'third' of the display the low byte for the first line is +00, for the second line +20, etc.
  $0EA4 The low byte goes into #REGl.
  $0EA5 The true line number is fetched.
  $0EA6 In effect '64+8*INT (#REGa/8)'. For the upper 'third' of the display the high byte is +40, for the middle 'third' +48, and for the lower 'third' +50.
  $0EAA The high byte goes to #REGh.
  $0EAB Finished.
@ $0EAC label=COPY
c $0EAC THE 'COPY' COMMAND ROUTINE
D $0EAC The address of this routine is found in the #R$1AD6(parameter table).
D $0EAC The one hundred and seventy six pixel lines of the display are dealt with one by one.
  $0EAC The maskable interrupt is disabled during COPY.
  $0EAD The 176 lines.
  $0EAF The base address of the display.
N $0EB2 The following loop is now entered.
@ $0EB2 label=COPY_1
  $0EB2 Save the base address and the number of the line.
  $0EB4 It is called 176 times.
  $0EB7 Fetch the line number and the base address.
  $0EB9 The base address is updated by 256 locations for each line of pixels.
  $0EBA Jump forward and hence round the loop again directly for the eight pixel lines of a character line.
N $0EBF For each new line of characters the base address has to be updated.
  $0EBF Fetch the low byte.
  $0EC0 Update it by +20 bytes.
  $0EC2 The carry flag will be reset when 'within thirds' of the display.
  $0EC3 Change the carry flag.
  $0EC4 The #REGa register will hold +F8 when within a 'third' but +00 when a new 'third' is reached.
  $0EC7 The high byte of the address is now updated.
@ $0EC9 label=COPY_2
  $0EC9 Jump back until 176 lines have been printed.
  $0ECB Jump forward to the end routine.
@ $0ECD label=COPY_BUFF
c $0ECD THE 'COPY-BUFF' SUBROUTINE
D $0ECD This subroutine is called whenever the printer buffer is to have its contents passed to the printer.
  $0ECD Disable the maskable interrupt.
  $0ECE The base address of the printer buffer.
  $0ED1 There are eight pixel lines.
@ $0ED3 label=COPY_3
  $0ED3 Save the line number.
  $0ED4 Print the line.
  $0ED7 Fetch the line number.
  $0ED8 Jump back until 8 lines have been printed.
N $0EDA Continue into the #R$0EDA routine.
@ $0EDA label=COPY_END
  $0EDA Stop the printer motor.
  $0EDE Enable the maskable interrupt and continue into #R$0EDF.
@ $0EDF label=CLEAR_PRB
c $0EDF THE 'CLEAR PRINTER BUFFER' SUBROUTINE
D $0EDF The printer buffer is cleared by calling this subroutine.
  $0EDF The base address of the printer buffer.
  $0EE2 Reset the printer 'column'.
  $0EE5 Clear the #REGa register.
  $0EE6 Also clear the #REGb register (in effect #REGb holds 256).
@ $0EE7 label=PRB_BYTES
  $0EE7 The 256 bytes of the printer buffer are all cleared in turn.
  $0EEB Signal 'the buffer is empty'.
  $0EEF Set the printer position and return via #R$0DD9 and #R$0ADC.
@ $0EF4 label=COPY_LINE
c $0EF4 THE 'COPY-LINE' SUBROUTINE
D $0EF4 The subroutine is entered with the #REGhl register pair holding the base address of the thirty two bytes that form the pixel-line and the #REGb register holding the pixel-line number.
  $0EF4 Copy the pixel-line number.
  $0EF5 The #REGa register will hold +00 until the last two lines are being handled.
  $0EFA Slow the motor for the last two pixel lines only.
  $0EFC The #REGd register will hold either +00 or +02.
N $0EFD There are three tests to be made before doing any 'printing'.
@ $0EFD label=COPY_L_1
  $0EFD Jump forward unless the BREAK key is being pressed.
M $0F02,10 But if it is then stop the motor, enable the maskable interrupt, clear the printer buffer and exit via the error handling routine - 'BREAK-CONT repeats'.
  $0F02
B $0F0B,1
@ $0F0C label=COPY_L_2
  $0F0C Fetch the status of the printer.
  $0F0F Make an immediate return if the printer is not present.
  $0F10 Wait for the stylus.
  $0F12 There are thirty two bytes.
N $0F14 Now enter a loop to handle these bytes.
@ $0F14 label=COPY_L_3
  $0F14 Fetch a byte.
  $0F15 Update the pointer.
  $0F16 Eight bits per byte.
@ $0F18 label=COPY_L_4
  $0F18 Move #REGd left.
  $0F1A Move each bit into the carry.
  $0F1C Move #REGd back again, picking up the carry from #REGe.
@ $0F1E label=COPY_L_5
  $0F1E Again fetch the status of the printer and wait for the signal from the encoder.
  $0F23 Now go ahead and pass the 'bit' to the printer. Note: bit 2 low starts the motor, bit 1 high slows the motor, and bit 7 is high for the actual 'printing'.
  $0F26 'Print' each bit.
  $0F28 Decrease the byte counter.
  $0F29 Jump back whilst there are still bytes; otherwise return.
@ $0F2C label=EDITOR
c $0F2C THE 'EDITOR' ROUTINES
D $0F2C The editor is called on two occasions:
D $0F2C #LIST { From the #R$12A2(main execution routine) so that the user can enter a BASIC line into the system. } { From the #R$2089(INPUT command routine). } LIST#
D $0F2C First the 'error stack pointer' is saved and an alternative address provided.
  $0F2C The current value is saved on the machine stack.
@ $0F30 nowarn
@ $0F30 label=ED_AGAIN
  $0F30 This is #R$107F.
  $0F33 Any event that leads to the error handling routine being used will come back to #R$107F.
N $0F38 A loop is now entered to handle each keystroke.
@ $0F38 label=ED_LOOP
  $0F38 Return once a key has been pressed.
  $0F3B Save the code temporarily.
  $0F3C Fetch the duration of the keyboard click.
@ $0F41 keep
  $0F41 And the pitch.
  $0F44 Now make the 'pip'.
  $0F47 Restore the code.
@ $0F48 nowarn
  $0F48 Pre-load the machine stack with the address of #R$0F38.
N $0F4C Now analyse the code obtained.
  $0F4C Accept all character codes, graphic codes and tokens.
  $0F50 Also accept ','.
  $0F54 Jump forward if the code represents an editing key.
N $0F58 The control keys - INK to TAB - are now considered.
@ $0F58 keep
  $0F58 INK and PAPER will require two locations.
  $0F5B Copy the code to #REGd.
  $0F5C Jump forward with INK and PAPER.
N $0F60 AT and TAB would be handled as follows:
  $0F60 Three locations required.
  $0F61 Jump forward unless dealing with 'INPUT LINE...'.
  $0F68 Get the second code and put it in #REGe.
N $0F6C The other bytes for the control characters are now fetched.
@ $0F6C label=ED_CONTR
  $0F6C Get another code.
  $0F6F Save the previous codes.
  $0F70 Fetch K-CUR.
  $0F73 Signal 'K mode'.
  $0F77 Make two or three spaces.
  $0F7A Restore the previous codes.
  $0F7B Point to the first location.
  $0F7C Enter first code.
  $0F7D Then enter the second code which will be overwritten if there are only two codes - i.e. with INK and PAPER.
  $0F7F Jump forward.
@ $0F81 label=ADD_CHAR
N $0F81 The following subroutine actually adds a code to the current EDIT or INPUT line.
  $0F81 Signal 'K mode'.
  $0F85 Fetch the cursor position.
  $0F88 Make a single space.
@ $0F8B label=ADD_CH_1
  $0F8B Enter the code into the space and signal that the cursor is to occur at the location after. Then return indirectly to #R$0F38.
N $0F92 The editing keys are dealt with as follows:
@ $0F92 label=ED_KEYS
  $0F92 The code is transferred to the #REGde register pair.
@ $0F95 ssub=LD HL,$0FA0-1
  $0F95 The base address of the #R$0FA0(editing keys table).
  $0F98 The entry is addressed and then fetched into #REGe.
  $0F9A The address of the handling routine is saved on the machine stack.
  $0F9C The #REGhl register pair is set and an indirect jump made to the required routine.
@ $0FA0 label=EDITKEYS
b $0FA0 THE 'EDITING KEYS' TABLE
  $0FA0 EDIT
  $0FA1 Cursor left
  $0FA2 Cursor right
  $0FA3 Cursor down
  $0FA4 Cursor up
  $0FA5 DELETE
  $0FA6 ENTER
  $0FA7 SYMBOL SHIFT
  $0FA8 GRAPHICS
@ $0FA9 label=ED_EDIT
c $0FA9 THE 'EDIT KEY' SUBROUTINE
D $0FA9 When in 'editing mode' pressing the EDIT key will bring down the 'current BASIC line'. However in 'INPUT mode' the action of the EDIT key is to clear the current reply and allow a fresh one.
  $0FA9 Fetch the current line number.
  $0FAC But jump forward if in 'INPUT mode'.
  $0FB3 Find the address of the start of the current line and hence its number.
  $0FB9 If the line number returned is zero then simply clear the editing area.
  $0FBE Save the address of the line.
  $0FBF Move on to collect the length of the line.
@ $0FC3 keep
  $0FC3 Add +0A to the length and test that there is sufficient room for a copy of the line.
  $0FCC Now clear the editing area.
  $0FCF Fetch the current channel address and exchange it for the address of the line.
  $0FD3 Save it temporarily.
  $0FD4 Open channel 'R' so that the line will be copied to the editing area.
  $0FD9 Fetch the address of the line.
  $0FDA Go to before the line.
  $0FDB Decrement the current line number so as to avoid printing the cursor.
  $0FDE Print the BASIC line.
  $0FE1 Increment the current line number. Note: the decrementing of the line number does not always stop the cursor from being printed.
  $0FE4 Fetch the start of the line in the editing area and step past the line number and the length to find the address for K-CUR.
  $0FEE Fetch the former channel address and set the appropriate flags before returning to #R$0F38.
@ $0FF3 label=ED_DOWN
c $0FF3 THE 'CURSOR DOWN EDITING' SUBROUTINE
  $0FF3 Jump forward if in 'INPUT mode'.
  $0FF9 This is E-PPC.
  $0FFC The next line number is found and a new automatic listing produced.
@ $1001 label=ED_STOP
  $1001 'STOP in INPUT' report.
  $1005 Jump forward.
@ $1007 label=ED_LEFT
c $1007 THE 'CURSOR LEFT EDITING' SUBROUTINE
  $1007 The cursor is moved.
  $100A Jump forward.
@ $100C label=ED_RIGHT
c $100C THE 'CURSOR RIGHT EDITING' SUBROUTINE
  $100C The current character is tested and if it is 'carriage return' then return.
  $1010 Otherwise make the cursor come after the character.
@ $1011 label=ED_CUR
  $1011,3 Set the system variable K-CUR.
@ $1015 label=ED_DELETE
c $1015 THE 'DELETE EDITING' SUBROUTINE
  $1015 Move the cursor leftwards.
@ $1018 keep
  $1018 Reclaim the current character.
@ $101E label=ED_IGNORE
c $101E THE 'ED-IGNORE' SUBROUTINE
  $101E The next two codes from the key-input routine are ignored.
@ $1024 label=ED_ENTER
c $1024 THE 'ENTER EDITING' SUBROUTINE
  $1024 The addresses of #R$0F38 and #R$107F are discarded.
@ $1026 label=ED_END
  $1026 The old value of ERR-SP is restored.
  $102A Now return if there were no errors.
  $102F Otherwise make an indirect jump to the error routine.
@ $1031 label=ED_EDGE
c $1031 THE 'ED-EDGE' SUBROUTINE
D $1031 The address of the cursor is in the #REGhl register pair and will be decremented unless the cursor is already at the start of the line. Care is taken not to put the cursor between control characters and their parameters.
  $1031 #REGde will hold either E-LINE (for editing) or WORKSP (for INPUTing).
  $1035 The carry flag will become set if the cursor is already to be at the start of the line.
  $1038 Correct for the subtraction.
  $1039 Drop the return address.
  $103A Return via #R$0F38 if the carry flag is set.
  $103B Restore the return address.
  $103C Move the current address of the cursor to #REGbc.
N $103E Now enter a loop to check that control characters are not split from their parameters.
@ $103E label=ED_EDGE_1
  $103E #REGhl will point to the character in the line after that addressed by #REGde.
  $1041 Fetch a character code.
  $1042 Jump forward if the code does not represent INK to TAB.
  $1048 Allow for one parameter.
  $1049 Fetch the code anew.
  $104A Carry is reset for TAB.
  $104C Note: this splits off AT and TAB but AT and TAB in this form are not implemented anyway so it makes no difference.
  $104E Jump forward unless dealing with AT and TAB which would have two parameters, if used.
@ $1051 label=ED_EDGE_2
  $1051 Prepare for true subtraction.
  $1052 The carry flag will be reset when the 'updated pointer' reaches K-CUR.
  $1055 For the next loop use the 'updated pointer', but if exiting use the 'present pointer' for K-CUR. Note: it is the control character that is deleted when using DELETE.
@ $1059 label=ED_UP
c $1059 THE 'CURSOR UP EDITING' SUBROUTINE
  $1059 Return if in 'INPUT mode'.
  $105E Fetch the current line number and its start address.
  $1064 #REGhl now points to the previous line.
  $1065 This line's number is fetched.
  $1068 This is E-PPC-hi.
  $106B The line number is stored.
@ $106E label=ED_LIST
  $106E A new automatic listing is now produced and channel 'K' re-opened before returning to #R$0F38.
@ $1076 label=ED_SYMBOL
c $1076 THE 'ED-SYMBOL' SUBROUTINE
D $1076 If SYMBOL and GRAPHICS codes were used they would be handled as follows:
  $1076 Jump back unless dealing with INPUT LINE.
@ $107C label=ED_GRAPH
  $107C Jump back.
@ $107F label=ED_ERROR
c $107F THE 'ED-ERROR' SUBROUTINE
D $107F Come here when there has been some kind of error.
  $107F Jump back if using other than channel 'K'.
  $1085 Cancel the error number and give a 'rasp' before going around the editor again.
@ $1097 label=CLEAR_SP
c $1097 THE 'CLEAR-SP' SUBROUTINE
D $1097 The editing area or the work space is cleared as directed.
  $1097 Save the pointer to the space.
  $1098 #REGde will point to the first character and #REGhl the last.
  $109C The correct amount is now reclaimed.
  $109F The system variables K-CUR and MODE ('K mode') are initialised before fetching the pointer and returning.
@ $10A8 label=KEY_INPUT
c $10A8 THE 'KEYBOARD INPUT' SUBROUTINE
D $10A8 This important subroutine returns the code of the last key to have been pressed, but note that CAPS LOCK, the changing of the mode and the colour control parameters are handled within the subroutine.
  $10A8 Copy the edit-line or the INPUT-line to the screen if the mode has changed.
  $10AF Return with both carry and zero flags reset if no new key has been pressed.
  $10B5 Otherwise fetch the code and signal that it has been taken.
  $10BC Save the code temporarily.
  $10BD Clear the lower part of the display if necessary, e.g. after 'scroll?'.
  $10C4 Fetch the code.
  $10C5,4,c2,2 Accept all characters and token codes.
  $10C9 Jump forward with most of the control character codes.
  $10CD Jump forward with the 'mode' codes and the CAPS LOCK code.
N $10D1 Now deal with the FLASH, BRIGHT and INVERSE codes.
  $10D1 Save the code.
  $10D2 Keep only bit 0.
  $10D4 #REGc holds +00 (=OFF) or +01 (=ON).
  $10D5 Fetch the code.
  $10D6 Rotate it once (losing bit 0).
  $10D7 Increase it by +12 giving +12 for FLASH, +13 for BRIGHT, and +14 for INVERSE.
N $10DB The CAPS LOCK code and the mode codes are dealt with 'locally'.
@ $10DB label=KEY_M_CL
  $10DB Jump forward with 'mode' codes.
  $10DD This is FLAGS2.
  $10E0 Flip bit 3 of FLAGS2. This is the CAPS LOCK flag.
  $10E4 Jump forward.
@ $10E6 label=KEY_MODE
  $10E6 Check the lower limit.
  $10E9 Reduce the range.
  $10EB This is MODE.
  $10EE Has it been changed?
  $10EF Enter the new 'mode' code.
  $10F0 Jump if it has changed; otherwise make it 'L mode'.
@ $10F4 label=KEY_FLAG
  $10F4 Signal 'the mode might have changed'.
  $10F8 Reset the carry flag and return.
N $10FA The control key codes (apart from FLASH, BRIGHT and INVERSE) are manipulated.
@ $10FA label=KEY_CONTR
  $10FA Save the code.
  $10FB Make the #REGc register hold the parameter (+00 to +07).
  $10FE #REGa now holds the INK code.
  $1100 But if the code was an 'unshifted' code then make #REGa hold the PAPER code.
N $1105 The parameter is saved in K-DATA and the channel address changed from #R$10A8 to #R$110D.
@ $1105 label=KEY_DATA
  $1105 Save the parameter.
@ $1108 nowarn
  $1108 This is #R$110D.
  $110B Jump forward.
N $110D Note: on the first pass entering at #R$10A8 the #REGa register is returned holding a 'control code' and then on the next pass, entering at #R$110D, it is the parameter that is returned.
@ $110D label=KEY_NEXT
  $110D Fetch the parameter.
@ $1110 nowarn
  $1110 This is #R$10A8.
N $1113 Now set the input address in the first channel area.
@ $1113 label=KEY_CHAN
  $1113 Fetch the channel address.
  $1118 Now set the input address.
N $111B Finally exit with the required code in the #REGa register.
@ $111B label=KEY_DONE_2
  $111B Show a code has been found and return.
@ $111D label=ED_COPY
c $111D THE 'LOWER SCREEN COPYING' SUBROUTINE
D $111D This subroutine is called whenever the line in the editing area or the INPUT area is to be printed in the lower part of the screen.
  $111D Use the permanent colours.
  $1120 Signal that the 'mode is to be considered unchanged' and the 'lower screen does not need clearing'.
  $1128 Save the current value of S-POSNL.
  $112C Keep the current value of ERR-SP.
@ $1130 nowarn
  $1130 This is #R$1167.
  $1133 Push this address on to the machine stack to make #R$1167 the entry point following an error.
  $1138 Push the value of ECHO-E on to the stack.
  $113C Make #REGhl point to the start of the space and #REGde the end.
  $1141 Now print the line.
  $1144 Exchange the pointers and print the cursor.
  $1148 Next fetch the current value of S-POSNL and exchange it with ECHO-E.
  $114C Pass ECHO-E to #REGde.
  $114D Again fetch the permanent colours.
N $1150 The remainder of any line that has been started is now completed with spaces printed with the 'permanent' PAPER colour.
@ $1150 label=ED_BLANK
  $1150 Fetch the current line number and subtract the old line number.
  $1154 Jump forward if no 'blanking' of lines required.
  $1156 Jump forward if not on the same line.
  $1158 Fetch the old column number and subtract the new column number.
  $115C Jump if no spaces required.
@ $115E label=ED_SPACES
  $115E,c2 A 'space'.
  $1160 Save the old values.
  $1161 Print it.
  $1164 Fetch the old values.
  $1165 Back again.
N $1167 New deal with any errors.
@ $1167 label=ED_FULL
  $1167 Give out a 'rasp'.
  $1172 Cancel the error number.
  $1176 Fetch the current value of S-POSNL and jump forward.
N $117C The normal exit upon completion of the copying over of the edit or the INPUT line.
@ $117C label=ED_C_DONE
  $117C The new position value.
  $117D The 'error address'.
N $117E But come here after an error.
@ $117E label=ED_C_END
  $117E The old value of ERR-SP is restored.
  $1182 Fetch the old value of S-POSNL.
  $1183 Save the new position values.
  $1184 Set the system variables.
  $1187 The old value of S-POSNL goes into ECHO-E.
  $118B X-PTR is cleared in a suitable manner and the return made.
@ $1190 label=SET_HL
c $1190 THE 'SET-HL' AND 'SET-DE' SUBROUTINES
D $1190 These subroutines return with #REGhl pointing to the first location and #REGde the 'last' location of either the editing area or the work space.
  $1190 Point to the last location of the editing area.
  $1194 Clear the carry flag.
@ $1195 label=SET_DE
  $1195 Point to the start of the editing area and return if in 'editing mode'.
  $119E Otherwise change #REGde.
  $11A2 Return if now intended.
  $11A3 Fetch STKBOT and then return.
@ $11A7 label=REMOVE_FP
c $11A7 THE 'REMOVE-FP' SUBROUTINE
D $11A7 This subroutine removes the hidden floating-point forms in a BASIC line.
  $11A7 Each character in turn is examined.
  $11A8 Is it a number marker?
@ $11AA keep
  $11AA It will occupy six locations.
  $11AD Reclaim the floating point number.
  $11B0 Fetch the code again.
  $11B1 Update the pointer.
  $11B2 Is it a carriage return?
  $11B4 Back if not. But make a simple return if it is.
@ $11B7 label=NEW
c $11B7 THE 'NEW' COMMAND ROUTINE
D $11B7 The address of this routine is found in the #R$1AA8(parameter table).
  $11B7 Disable the maskable interrupt.
  $11B8 The NEW flag.
  $11BA The existing value of RAMTOP is preserved.
  $11BE Load the alternate registers with the following system variables (P-RAMT, RASP, PIP, UDG). All of which will also be preserved.
N $11CB The main entry point.
@ $11CB label=START_NEW
  $11CB Save the flag for later.
  $11CC Make the border white in colour.
  $11D0 Set the I register to hold the value of +3F.
  $11D4,6 Wait 24 T states.
N $11DA Now the memory is checked.
@ $11DA label=RAM_CHECK
  $11DA Transfer the value in #REGde (#R$0000=+FFFF, #R$11B7=RAMTOP).
@ $11DC label=RAM_FILL
  $11DC Enter the value of +02 into every location above +3FFF.
@ $11E2 label=RAM_READ
  $11E2 Prepare for true subtraction.
  $11E3 The carry flag will become reset when the top is reached.
  $11E6 Update the pointer.
  $11E7 Jump when at top.
  $11E9 +02 goes to +01.
  $11EA But if zero then RAM is faulty. Use current #REGhl as top.
  $11EC +01 goes to +00.
  $11ED Step to the next test unless it fails.
@ $11EF label=RAM_DONE
  $11EF #REGhl points to the last actual location in working order.
N $11F0 Next restore the 'preserved' system variables. (Meaningless when coming from #R$0000.)
  $11F0 Restore P-RAMT, RASP, PIP and UDG.
  $11FD Test the #R$0000/#R$11B7 flag.
  $11FE Jump forward if coming from the #R$11B7 command routine.
N $1200 Overwrite the system variables when coming from #R$0000 and initialise the user-defined graphics area.
  $1200 Top of physical RAM.
@ $1203 nowarn
  $1203 Last byte of 'U' in character set.
@ $1206 keep
  $1206 There are this number of bytes in twenty one letters.
  $1209 Switch the pointers.
  $120A Now copy the character forms of the letter 'A' to 'U'.
  $120C Switch the pointers back.
  $120D Point to the first byte.
  $120E Now set UDG.
  $1211 Down one location.
@ $1212 keep
  $1212 Set the system variables RASP and PIP.
N $1219 The remainder of the routine is common to both the #R$0000 and the #R$11B7 operations.
@ $1219 label=RAM_SET
  $1219 Set RAMTOP.
@ $121C ssub=LD HL,$3D00-$100
  $121C Initialise the system variable CHARS.
N $1222 Next the machine stack is set up.
  $1222 The top location is made to hold +3E.
  $1227 The next location is left holding zero.
  $1228 These two locations represent the 'last entry'.
  $1229 Step down two locations to find the correct value for ERR-SP.
N $122E The initialisation routine continues with:
  $122E Interrupt mode 1 is used.
  $1230 #REGiy holds +ERR-NR always.
  $1234 The maskable interrupt can now be enabled. The real-time clock will be updated and the keyboard scanned every 1/50th of a second.
  $1235 The base address of the channel information area.
  $123B The initial channel data is moved from the table (#R$15AF) to the channel information area.
@ $123E keep
  $1244 The system variable DATADD is made to point to the last location of the channel data.
  $1249 And PROG and VARS to the the location after that.
  $1250 The end-marker of the variables area.
  $1252 Move on one location to find the value for E-LINE.
  $1256 Make the edit-line be a single 'carriage return' character.
  $1259 Now enter an end marker.
  $125B Move on one location to find the value for WORKSP, STKBOT and STKEND.
  $1265 Initialise the colour system variables to FLASH 0, BRIGHT 0, PAPER 7, INK 0.
@ $1270 keep
  $1270 Initialise the system variables REPDEL and REPPER.
  $1276 Make KSTATE-0 hold +FF.
  $1279 Make KSTATE-4 hold +FF.
  $127C Next move the initial stream data from its table to the streams area.
@ $1282 keep
  $1287 Signal 'printer in use' and clear the printer buffer.
  $128E Set the size of the lower part of the display and clear the whole display.
  $1295 Now print the message '#CHR169 1982 Sinclair Research Ltd' on the bottom line.
@ $1296 ssub=LD DE,$1539-1
  $129C Signal 'the lower part will required to be cleared'.
  $12A0 Jump forward into the main execution loop.
@ $12A2 label=MAIN_EXEC
c $12A2 THE 'MAIN EXECUTION' LOOP
D $12A2 The main loop controls the 'editing mode', the execution of direct commands and the production of reports.
  $12A2 The lower part of the screen is to be two lines in size.
  $12A6 Produce an automatic listing.
@ $12A9 label=MAIN_1
  $12A9 All the areas from E-LINE onwards are given their minimum configurations.
@ $12AC label=MAIN_2
  $12AC Channel 'K' is opened before calling the #R$0F2C.
  $12B1 The #R$0F2C is called to allow the user to build up a BASIC line.
  $12B4 The current line is scanned for correct syntax.
  $12B7 Jump forward if the syntax is correct.
  $12BD Jump forward if other than channel 'K' is being used.
  $12C3 Point to the start of the line with the error.
  $12C6 Remove the floating-point forms from this line.
  $12C9 Reset ERR-NR and jump back to #R$12AC leaving the listing unchanged.
N $12CF The 'edit-line' has passed syntax and the three types of line that are possible have to be distinguished from each other.
@ $12CF label=MAIN_3
  $12CF Point to the start of the line.
  $12D2 Set CH-ADD to the start also.
  $12D5 Fetch any line number into #REGbc.
  $12D8 Is the line number a valid one?
  $12DA Jump if it is so, and add the new line to the existing program.
  $12DD Fetch the first character of the line and see if the line is 'carriage return only'.
  $12E0 If it is then jump back.
N $12E2 The 'edit-line' must start with a direct BASIC command so this line becomes the first line to be interpreted.
  $12E2 Clear the whole display unless the flag says it is unnecessary.
  $12E9 Clear the lower part anyway.
  $12EC Set the appropriate value for the scroll counter.
  $12F4 Signal 'line execution'.
  $12F8 Ensure ERR-NR is correct.
  $12FC Deal with the first statement in the line.
  $1300 Now the line is interpreted. Note: the address #R$1303 goes on to the machine stack and is addressed by ERR-SP.
N $1303 After the line has been interpreted and all the actions consequential to it have been completed a return is made to #R$1303, so that a report can be made.
@ $1303 label=MAIN_4
  $1303 The maskable interrupt must be enabled.
  $1304 Signal 'ready for a new key'.
  $1308 Empty the printer buffer if it has been used.
  $130F Fetch the error number and increment it.
@ $1313 label=MAIN_G
  $1313 Save the new value.
@ $1314 keep
  $1314 The system variables FLAGX, X-PTR-hi and DEFADD are all set to zero.
@ $1320 keep
  $1320 Ensure that stream +00 points to channel 'K'.
  $1326 Clear all the work areas and the calculator stack.
  $1329 Signal 'editing mode'.
  $132D Clear the lower screen.
  $1330 Signal 'the lower screen will require clearing'.
  $1334 Fetch the report value.
  $1335 Make a copy in #REGb.
  $1336 Jump forward with report numbers '0 to 9'.
  $133A Add the ASCII letter offset value.
@ $133C label=MAIN_5
  $133C,6,3,c2,1 Print the report code and follow it with a 'space'.
  $1342 Fetch the report value (used to identify the required report message).
  $1343 Print the message.
  $1349 Follow it by a 'comma' and a 'space'.
@ $134A ssub=LD DE,$1537-1
  $1350 Now fetch the current line number and print it as well.
  $1357,3,c2,1 Follow it by a ':'.
  $135A Fetch the current statement number into the #REGbc register pair and print it.
  $1362 Clear the editing area.
  $1365 Fetch the error number again.
  $1368 Increment it as usual.
  $1369 If the program was completed successfully there cannot be any 'CONTinuing' so jump.
  $136B If the program halted with 'STOP statement' or 'BREAK into program' CONTinuing will be from the next statement; otherwise SUBPPC is unchanged.
@ $1373 label=MAIN_6
@ $1376 keep
@ $1376 label=MAIN_7
  $1376 The system variables OLDPPC and OSPCC have now to be made to hold the CONTinuing line and statement numbers.
  $137C The values used will be those in PPC and SUBPPC unless NSPPC indicates that the 'break' occurred before a 'jump' (i.e. after a GO TO statement etc.).
@ $1384 label=MAIN_8
@ $1386 label=MAIN_9
  $1386 NSPPC is reset to indicate 'no jump'.
  $138A 'K mode' is selected.
  $138E And finally the jump back is made but no program listing will appear until requested.
@ $1391 label=REPORTS
t $1391 THE REPORT MESSAGES
D $1391 Each message is given with the last character inverted (+80 hex.).
  $1391 Initial byte is stepped over.
  $1392,2,1:B1
  $1394,16,15:B1
  $13A4,18,17:B1
  $13B6,15,14:B1
  $13C5,13,12:B1
  $13D2,13,12:B1
  $13DF,14,13:B1
  $13ED,20,19:B1
  $1401,11,10:B1
  $140C,14,13:B1
  $141A,16,15:B1
  $142A,20,19:B1
  $143E,17,16:B1
  $144F,20,19:B1
  $1463,11,10:B1
  $146E,17,16:B1
  $147F,16,15:B1
  $148F,13,12:B1
  $149C,16,15:B1
  $14AC,18,17:B1
  $14BE,14,13:B1
  $14CC,18,17:B1
  $14DE,14,13:B1
  $14EC,14,13:B1
  $14FA,14,13:B1
  $1508,14,13:B1
  $1516,15,14:B1
  $1525,18,17:B1
@ $1537 label=COMMA_SPC
N $1537 There are also the following two messages.
  $1537,2,1:B1
@ $1539 label=COPYRIGHT
  $1539,28,B1:26:B1
@ $1555 label=REPORT_G
c $1555 Report G - No room for line
  $1555 'G' has the code '10+07+30'.
@ $1557 keep
  $1557 Clear #REGbc.
  $155A Jump back to give the report.
@ $155D label=MAIN_ADD
c $155D THE 'MAIN-ADD' SUBROUTINE
D $155D This subroutine allows for a new BASIC line to be added to the existing BASIC program in the program area. If a line has both an old and a new version then the old one is 'reclaimed'. A new line that consists of only a line number does not go into the program area.
  $155D Make the new line number the 'current line'.
  $1561 Fetch CH-ADD and save the address in #REGde.
@ $1565 nowarn
  $1565 Push the address of #R$1555 on to the machine stack. ERR-SP will now point to #R$1555.
  $1569 Fetch WORKSP.
  $156C Find the length of the line from after the line number to the 'carriage return' character inclusively.
  $156F Save the length.
  $1570 Move the line number to the #REGhl register pair.
  $1572 Is there an existing line with this number?
  $1575 Jump if there was not.
  $1577 Find the length of the 'old' line and reclaim it.
@ $157D label=MAIN_ADD1
  $157D Fetch the length of the 'new' line and jump forward if it is only a 'line number and a carriage return'.
  $1583 Save the length.
  $1584 Four extra locations will be needed, i.e. two for the number and two for the length.
  $1588 Make #REGhl point to the location before the 'destination'.
  $1589 Save the current value of PROG to avoid corruption when adding a first line.
  $158E Space for the new line is created.
  $1591 The old value of PROG is fetched and restored.
  $1595 A copy of the line length (without parameters) is taken.
  $1597 Make #REGde point to the end location of the new area and #REGhl to the 'carriage return' character of the new line in the editing area.
  $159D Now copy over the line.
  $159F Fetch the line's number.
  $15A2 Destination into #REGhl and number into #REGde.
  $15A3 Fetch the new line's length.
  $15A4 The high length byte.
  $15A6 The low length byte.
  $15A8 The low line number byte.
  $15AA The high line number byte.
@ $15AB label=MAIN_ADD2
  $15AB Drop the address of #R$1555.
  $15AC Jump back and this time do produce an automatic listing.
@ $15AF label=CHANINFO
b $15AF THE 'INITIAL CHANNEL INFORMATION'
D $15AF Initially there are four channels - 'K', 'S', 'R', and 'P' - for communicating with the 'keyboard', 'screen', 'work space' and 'printer'. For each channel the output routine address comes before the input routine address and the channel's code.
W $15AF,4,2
  $15B3,1,T1
L $15AF,5,4
  $15C3,1 End marker.
@ $15C4 label=REPORT_J
c $15C4 Report J - Invalid I/O device
M $15C4,2 Call the error handling routine.
B $15C5,1
@ $15C6 label=STRMDATA
b $15C6 THE 'INITIAL STREAM DATA'
D $15C6 Initially there are seven streams - +FD to +03.
  $15C6,2 Leads to channel 'K' (keyboard)
  $15C8,2 Leads to channel 'S' (screen)
  $15CA,2 Leads to channel 'R' (work space)
  $15CC,2 Leads to channel 'K' (keyboard)
  $15CE,2 Leads to channel 'K' (keyboard)
  $15D0,2 Leads to channel 'S' (screen)
  $15D2,2 Leads to channel 'P' (printer)
@ $15D4 label=WAIT_KEY
c $15D4 THE 'WAIT-KEY' SUBROUTINE
B $15E5,1
D $15D4 This subroutine is the controlling subroutine for calling the current input subroutine.
  $15D4 Jump forward if the flag indicates the lower screen does not require clearing.
  $15DA Otherwise signal 'consider the mode as having changed'.
@ $15DE label=WAIT_KEY1
  $15DE Call the input subroutine indirectly via #R$15E6.
  $15E1 Return with acceptable codes.
  $15E2 Both the carry flag and the zero flag are reset if 'no key is being pressed'; otherwise signal an error.
N $15E4 Report 8 - End of file.
@ $15E4 label=REPORT_8
M $15E4,2 Call the error handling routine.
B $15E5,1
@ $15E6 label=INPUT_AD
c $15E6 THE 'INPUT-AD' SUBROUTINE
D $15E6 The registers are saved and #REGhl made to point to the input address.
  $15E6 Save the registers.
  $15E8 Fetch the base address for the current channel information.
  $15EB Step past the output address.
  $15ED Jump forward.
@ $15EF label=OUT_CODE
c $15EF THE 'MAIN PRINTING' SUBROUTINE
D $15EF The subroutine is called with either an absolute value or a proper character code in the #REGa register.
  $15EF Increase the value in the #REGa register by +30.
@ $15F2 label=PRINT_A_2
  $15F2 Save the registers.
  $15F4 Fetch the base address for the current channel. This will point to an output address.
N $15F7 Now call the actual subroutine. #REGhl points to the output or the input address as directed.
@ $15F7 label=CALL_SUB
  $15F7 Fetch the low byte.
  $15F8 Fetch the high byte.
  $15FA Move the address to the #REGhl register pair.
  $15FB Call the actual subroutine.
  $15FE Restore the registers.
  $1600 Return will be from here unless an error occurred.
@ $1601 label=CHAN_OPEN
c $1601 THE 'CHAN-OPEN' SUBROUTINE
D $1601 This subroutine is called with the #REGa register holding a valid stream number - normally +FD to +03. Then depending on the stream data a particular channel will be made the current channel.
  $1601 The value in the #REGa register is doubled and then increased by +16.
  $1604 The result is moved to #REGl.
  $1605 The address 5C16 is the base address for stream +00.
  $1607 Fetch the first two bytes of the required stream's data.
  $160A Give an error if both bytes are zero; otherwise jump forward.
N $160E Report O - Invalid stream.
@ $160E label=REPORT_O
M $160E,2 Call the error handling routine.
B $160F,1
N $1610 Using the stream data now find the base address of the channel information associated with that stream.
@ $1610 label=CHAN_OP_1
  $1610 Reduce the stream data.
  $1611 The base address of the whole channel information area.
  $1614 Form the required address in this area.
@ $1615 label=CHAN_FLAG
c $1615 THE 'CHAN-FLAG' SUBROUTINE
D $1615 The appropriate flags for the different channels are set by this subroutine.
  $1615 The #REGhl register pair holds the base address for a particular channel.
  $1618 Signal 'using other than channel 'K''.
  $161C Step past the output and the input addresses and make #REGhl point to the channel code.
  $1620 Fetch the code.
  $1621 The base address of the #R$162D(channel code look-up table).
  $1624 Index into this table and locate the required offset, but return if there is not a matching channel code.
  $1628 Pass the offset to the #REGde register pair.
  $162B,1 Point #REGhl at the appropriate flag setting routine.
@ $162C label=CALL_JUMP
  $162C Jump to the routine.
@ $162D label=CHANCODE
b $162D THE 'CHANNEL CODE LOOK-UP' TABLE
  $162D,2,T1:1 Channel 'K', offset +06 (#R$1634).
  $162F,2,T1:1 Channel 'S', offset +12 (#R$1642).
  $1631,2,T1:1 Channel 'P', offset +1B (#R$164D).
  $1633,1 End marker.
@ $1634 label=CHAN_K
c $1634 THE 'CHANNEL 'K' FLAG' SUBROUTINE
  $1634 Signal 'using lower screen'.
  $1638 Signal 'ready for a key'.
  $163C Signal 'using channel 'K''.
  $1640 Jump forward.
@ $1642 label=CHAN_S
c $1642 THE 'CHANNEL 'S' FLAG' SUBROUTINE
  $1642 Signal 'using main screen'.
@ $1646 label=CHAN_S_1
  $1646 Signal 'printer not being used'.
  $164A Exit via #R$0D4D so as to set the colour system variables.
@ $164D label=CHAN_P
c $164D THE 'CHANNEL 'P' FLAG' SUBROUTINE
  $164D,4 Signal 'printer in use'.
@ $1652 keep
@ $1652 label=ONE_SPACE
c $1652 THE 'MAKE-ROOM' SUBROUTINE
D $1652 This is a very important subroutine. It is called on many occasions to 'open up' an area. In all cases the #REGhl register pair points to the location after the place where 'room' is required and the #REGbc register pair holds the length of the 'room' needed. When a single space only is required then the subroutine is entered at #R$1652.
  $1652 Just the single extra location is required.
@ $1655 label=MAKE_ROOM
  $1655 Save the pointer.
  $1656 Make sure that there is sufficient memory available for the task being undertaken.
  $1659 Restore the pointer.
  $165A Alter all the pointers before making the 'room'.
  $165D Make #REGhl hold the new STKEND.
  $1660 Switch 'old' and 'new'.
  $1661 Now make the 'room' and return.
E $1652 Note: this subroutine returns with the #REGhl register pair pointing to the location before the new 'room' and the #REGde register pair pointing to the last of the new locations. The new 'room' therefore has the description '(#REGhl)+1' to '(#REGde)' inclusive.
E $1652 However as the 'new locations' still retain their 'old values' it is also possible to consider the new 'room' as having been made after the original location '(#REGhl)' and it thereby has the description '(#REGhl)+2' to '(#REGde)+1'.
E $1652 In fact the programmer appears to have a preference for the 'second description' and this can be confusing.
@ $1664 label=POINTERS
c $1664 THE 'POINTERS' SUBROUTINE
D $1664 Whenever an area has to be 'made' or 'reclaimed' the system variables that address locations beyond the 'position' of the change have to be amended as required. On entry the #REGbc register pair holds the number of bytes involved and the #REGhl register pair addresses the location before the 'position'.
  $1664 These registers are saved.
  $1665 Copy the address of the 'position'.
  $1666 This is VARS, the first of the fourteen system pointers.
N $166B A loop is now entered to consider each pointer in turn. Only those pointers that point beyond the 'position' are changed.
@ $166B label=PTR_NEXT
  $166B Fetch the two bytes of the current pointer.
  $166E Exchange the system variable with the address of the 'position'.
  $166F The carry flag will become set if the system variable's address is to be updated.
  $1673 Restore the 'position'.
  $1674 Jump forward if the pointer is to be left; otherwise change it.
  $1676 Save the old value.
  $1677 Now add the value in #REGbc to the old value.
  $167A Enter the new value into the system variable - high byte before low byte.
  $167D Point again to the high byte.
  $167E Fetch the old value.
@ $167F label=PTR_DONE
  $167F Point to the next system variable and jump back until all fourteen have been considered.
N $1683 Now find the size of the block to be moved.
  $1683 Put the old value of STKEND in #REGhl and restore the other registers.
  $1686 Now find the difference between the old value of STKEND and the 'position'.
  $1689 Transfer the result to #REGbc and add 1 for the inclusive byte.
  $168C Reform the old value of STKEND and pass it to #REGde before returning.
@ $168F label=LINE_ZERO
c $168F THE 'COLLECT A LINE NUMBER' SUBROUTINE
D $168F On entry the #REGhl register pair points to the location under consideration. If the location holds a value that constitutes a suitable high byte for a line number then the line number is returned in #REGde. However if this is not so then the location addressed by #REGde is tried instead; and should this also be unsuccessful line number zero is returned.
B $168F,2 Line number zero.
@ $1691 label=LINE_NO_A
  $1691 Consider the other pointer.
@ $1692 nowarn
  $1692 Use line number zero.
N $1695 The usual entry point is here.
@ $1695 label=LINE_NO
  $1695 Fetch the high byte and test it.
  $1698 Jump if not suitable.
  $169A Fetch the high byte and low byte and return.
@ $169E label=RESERVE
c $169E THE 'RESERVE' SUBROUTINE
D $169E This subroutine is normally called by using #R$0030.
D $169E On entry here the last value on the machine stack is WORKSP and the value above it is the number of spaces that are to be 'reserved'.
D $169E This subroutine always makes 'room' between the existing work space and the calculator stack.
  $169E Fetch the current value of STKBOT and decrement it to get the last location of the work space.
  $16A2 Now make '#REGbc spaces'.
  $16A5 Point to the first new space and then the second.
  $16A7 Fetch the old value of WORKSP and restore it.
  $16AC Restore #REGbc - number of spaces.
  $16AD Switch the pointers.
  $16AE Make #REGhl point to the first of the displaced bytes.
  $16AF Now return.
E $169E Note: it can also be considered that the subroutine returns with the #REGde register pair pointing to a 'first extra byte' and the #REGhl register pair pointing to a 'last extra byte', these extra bytes having been added after the original '(#REGhl)+1' location.
@ $16B0 label=SET_MIN
c $16B0 THE 'SET-MIN' SUBROUTINE
D $16B0 This subroutine resets the editing area and the areas after it to their minimum sizes. In effect it 'clears' the areas.
  $16B0 Fetch E-LINE.
  $16B3 Make the editing area hold only the 'carriage return' character and the end marker.
  $16BB Move on to clear the work space.
N $16BF Entering here will 'clear' the work space and the calculator stack.
@ $16BF label=SET_WORK
  $16BF Fetch the WORKSP.
  $16C2 This clears the work space.
N $16C5 Entering here will 'clear' only the calculator stack.
@ $16C5 label=SET_STK
  $16C5 Fetch STKBOT.
  $16C8 This clears the stack.
N $16CB In all cases make MEM address the calculator's memory area.
  $16CB Save STKEND.
  $16CC The base of the memory area.
  $16CF Set MEM to this address.
  $16D2 Restore STKEND to the #REGhl register pair before returning.
@ $16D4 label=REC_EDIT
c $16D4 THE 'RECLAIM THE EDIT-LINE' SUBROUTINE
  $16D4 Fetch E-LINE.
  $16D8 Reclaim the memory.
@ $16DB label=INDEXER_1
c $16DB THE 'INDEXER' SUBROUTINE
D $16DB This subroutine is used on several occasions to look through tables. The entry point is at #R$16DC.
  $16DB Move on to consider the next pair of entries.
@ $16DC label=INDEXER
  $16DC Fetch the first of a pair of entries but return if it is zero - the end marker.
  $16DF Compare it to the supplied code.
  $16E0 Point to the second entry.
  $16E1 Jump back if the correct entry has not been found.
  $16E3,1 The carry flag is set upon a successful search.
@ $16E5 label=CLOSE
c $16E5 THE 'CLOSE #' COMMAND ROUTINE
D $16E5 The address of this routine is found in the #R$1B02(parameter table).
D $16E5 This command allows the user to close streams. However for streams +00 to +03 the 'initial' stream data is restored and these streams cannot therefore be closed.
  $16E5 The existing data for the stream is fetched.
  $16E8 Check the code in that stream's channel.
@ $16EB keep
  $16EB Prepare to make the stream's data zero.
  $16EE Prepare to identify the use of streams +00 to +03.
  $16F2 The carry flag will be set with streams +04 to +0F.
  $16F3 Jump forward with these streams; otherwise find the correct entry in the #R$15C6(initial stream data table).
@ $16F5 keep
@ $16F5 ssub=LD BC,$15C6+$0E
  $16F9 Fetch the initial data for streams +00 to +03.
@ $16FC label=CLOSE_1
  $16FC,4 Now enter the data: either zero and zero, or the initial values.
@ $1701 label=CLOSE_2
c $1701 THE 'CLOSE-2' SUBROUTINE
D $1701 The code of the channel associated with the stream being closed has to be 'K', 'S', or 'P'.
  $1701 Save the address of the stream's data.
  $1702 Fetch the base address of the channel information area and find the channel data for the stream being closed.
  $1706 Step past the subroutine addresses and pick up the code for that channel.
  $170A Save the pointer.
  $170B The base address of the #R$1716(CLOSE stream look-up table).
  $170E Index into this table and locate the required offset.
  $1711 Pass the offset to the #REGbc register pair.
  $1714 Jump to the appropriate routine.
@ $1716 label=CLOSESTRM
b $1716 THE 'CLOSE STREAM LOOK-UP' TABLE
  $1716,2,T1:1 Channel 'K', offset +05 (#R$171C)
  $1718,2,T1:1 Channel 'S', offset +03 (#R$171C)
  $171A,2,T1:1 Channel 'P', offset +01 (#R$171C)
E $1716 Note: there is no end marker at the end of this table.
@ $171C label=CLOSE_STR
c $171C THE 'CLOSE STREAM' SUBROUTINE
  $171C Fetch the channel information pointer and return.
@ $171E label=STR_DATA
c $171E THE 'STREAM DATA' SUBROUTINE
D $171E This subroutine returns in the #REGbc register pair the stream data for a given stream.
  $171E The given stream number is taken off the calculator stack.
  $1721 Give an error if the stream number is greater than +0F.
N $1725 Report O - Invalid stream.
@ $1725 label=REPORT_O_2
M $1725,2 Call the error handling routine.
B $1726,1
N $1727 Continue with valid stream numbers.
@ $1727 label=STR_DATA1
  $1727 Range now +03 to +12.
  $1729 And now +06 to +24.
  $172A The base address of the stream data area.
  $172D Move the stream code to the #REGbc register pair.
  $1730 Index into the data area and fetch the the two data bytes into the #REGbc register pair.
  $1734 Make the pointer address the first of the data bytes before returning.
@ $1736 label=OPEN
c $1736 THE 'OPEN #' COMMAND ROUTINE
D $1736 The address of this routine is found in the #R$1AFC(parameter table).
D $1736 This command allows the user to OPEN streams. A channel code must be supplied and it must be 'K', 'k', 'S', 's', 'P', or 'p'.
D $1736 Note that no attempt is made to give streams +00 to +03 their initial data.
  $1736 Use the calculator to exchange the stream number and the channel code.
B $1737,1 #R$343C
B $1738,1 #R$369B
  $1739 Fetch the data for the stream.
  $173C Jump forward if both bytes of the data are zero, i.e. the stream was in a closed state.
  $1740 Save #REGhl.
  $1741 Fetch CHANS - the base address of the channel information and find the code of the channel associated with the stream being OPENed.
  $1749 Return #REGhl.
  $174A,12,c2,2,c2,2,c2,2 The code fetched from the channel information area must be 'K', 'S' or 'P'; give an error if it is not.
@ $1756 label=OPEN_1
  $1756 Collect the appropriate data in #REGde.
  $1759 Enter the data into the two bytes in the stream information area.
  $175C Finally return.
@ $175D label=OPEN_2
c $175D THE 'OPEN-2' SUBROUTINE
D $175D The appropriate stream data bytes for the channel that is associated with the stream being opened are found.
  $175D Save #REGhl.
  $175E Fetch the parameters of the channel code.
  $1761 Give an error if the expression supplied is a null expression, e.g. OPEN #5,"".
N $1765 Report F - Invalid file name.
@ $1765 label=REPORT_F_2
M $1765,2 Call the error handling routine.
B $1766,1
N $1767 Continue if no error occurred.
@ $1767 label=OPEN_3
  $1767 The length of the expression is saved.
  $1768 Fetch the first character.
  $1769 Convert lower case codes to upper case ones.
  $176B Move code to the #REGc register.
  $176C The base address of the #R$177A(OPEN stream look-up table).
  $176F Index into this table and locate the required offset.
  $1772 Jump back if not found.
  $1774 Pass the offset to the #REGbc register pair.
  $1777 Make #REGhl point to the start of the appropriate subroutine.
  $1778 Fetch the length of the expression before jumping to the subroutine.
@ $177A label=OPENSTRM
b $177A THE 'OPEN STREAM LOOK-UP' TABLE
  $177A,2,T1:1 Channel 'K', offset +06 (#R$1781)
  $177C,2,T1:1 Channel 'S', offset +08 (#R$1785)
  $177E,2,T1:1 Channel 'P', offset +0A (#R$1789)
  $1780 End marker.
@ $1781 label=OPEN_K
c $1781 THE 'OPEN-K' SUBROUTINE
  $1781,2 The data bytes will be +01 and +00.
@ $1785 label=OPEN_S
c $1785 THE 'OPEN-S' SUBROUTINE
  $1785,2 The data bytes will be +06 and +00.
@ $1789 label=OPEN_P
c $1789 THE 'OPEN-P' SUBROUTINE
  $1789 The data bytes will be +10 and +00.
@ $178B label=OPEN_END
  $178B Decrease the length of the expression and give an error if it was not a single character.
  $1790 Otherwise clear the #REGd register, fetch #REGhl and return.
@ $1793 label=CAT_ETC
c $1793 THE 'CAT, ERASE, FORMAT and MOVE' COMMAND ROUTINES
D $1793 The address of this routine is found in the #R$1B06(parameter table).
D $1793 In the standard Spectrum system the use of these commands leads to the production of report O - Invalid stream.
  $1793 Give this report.
@ $1795 label=AUTO_LIST
c $1795 THE 'LIST and LLIST' COMMAND ROUTINES
D $1795 The routines in this part of the 16K program are used to produce listings of the current BASIC program. Each line has to have its line number evaluated, its tokens expanded and the appropriate cursors positioned.
D $1795 The entry point #R$1795 is used by both #R$12A2 and #R$1059 to produce a single page of the listing.
  $1795 The stack pointer is saved allowing the machine stack to be reset when the listing is finished (see #R$0C55).
  $1799 Signal 'automatic listing in the main screen'.
  $179D Clear this part of the screen.
  $17A0 Switch to the editing area.
  $17A4 Now clear the the lower part of the screen as well.
  $17AA Then switch back.
  $17AE Signal 'screen is clear'.
  $17B2 Now fetch the the 'current' line number and the 'automatic' line number.
  $17B9 If the 'current' number is less than the 'automatic' number then jump forward to update the 'automatic' number.
N $17BF The 'automatic' number has now to be altered to give a listing with the 'current' line appearing near the bottom of the screen.
  $17BF Save the 'automatic' number.
  $17C0 Find the address of the start of the 'current' line and produce an address roughly a 'screen before it' (negated).
@ $17C3 keep
  $17C9 Save the 'result' on the machine stack whilst the 'automatic' line address is also found (in #REGhl).
  $17CD The 'result' goes to the #REGbc register pair.
N $17CE A loop is now entered. The 'automatic' line number is increased on each pass until it is likely that the 'current' line will show on a listing.
@ $17CE label=AUTO_L_1
  $17CE Save the 'result'.
  $17CF Find the address of the start of the line after the present 'automatic' line (in #REGde).
  $17D2 Restore the 'result'.
  $17D3 Perform the computation and jump forward if finished.
  $17D6 Move the next line's address to the #REGhl register pair and collect its line number.
  $17DB Now S-TOP can be updated and the test repeated with the new line.
N $17E1 Now the 'automatic' listing can be made.
@ $17E1 label=AUTO_L_2
  $17E1 When E-PPC is less than S-TOP.
@ $17E4 label=AUTO_L_3
  $17E4 Fetch the top line's number and hence its address.
  $17EA If the line cannot be found use #REGde instead.
@ $17ED label=AUTO_L_4
  $17ED The listing is produced.
  $17F0 The return will be to here unless scrolling was needed to show the current line.
@ $17F5 label=LLIST
c $17F5 THE 'LLIST' ENTRY POINT
D $17F5 The address of this routine is found in the #R$1ADC(parameter table).
D $17F5 The printer channel will need to be opened.
  $17F5 Use stream +03.
  $17F7 Jump forward.
@ $17F9 label=LIST
c $17F9 THE 'LIST' ENTRY POINT
D $17F9 The address of this routine is found in the #R$1AAE(parameter table).
D $17F9 The 'main screen' channel will need to be opened.
  $17F9 Use stream +02.
@ $17FB label=LIST_1
  $17FB Signal 'an ordinary listing in the main part of the screen'.
  $17FF Open the channel unless checking syntax.
  $1805 With the present character in the #REGa register see if the stream is to be changed.
  $1809 Jump forward if unchanged.
  $180B,3,1,c2 Is the present character a ';'?
  $180E Jump if it is.
  $1810,c2 Is it a ','?
  $1812 Jump if it is not.
@ $1814 label=LIST_2
  $1814 A numeric expression must follow, e.g. LIST #5,20.
  $1818 Jump forward with it.
@ $181A label=LIST_3
  $181A Otherwise use zero and also jump forward.
N $181F Come here if the stream was unaltered.
@ $181F label=LIST_4
  $181F Fetch any line or use zero if none supplied.
@ $1822 label=LIST_5
  $1822 If checking the syntax of the edit-line move on to the next statement.
  $1825 Line number to #REGbc.
  $1828 High byte to #REGa.
  $1829 Limit the high byte to the correct range and pass the whole line number to #REGhl.
  $182D Set E-PPC and find the address of the start of this line or the first line after it if the actual line does not exist.
@ $1833 label=LIST_ALL
  $1833 Flag 'before the current line'.
N $1835 Now the controlling loop for printing a series of lines is entered.
@ $1835 label=LIST_ALL_1
  $1835 Print the whole of a BASIC line.
  $1838 This will be a 'carriage return'.
  $1839 Jump back unless dealing with an automatic listing.
  $183F Also jump back if there is still part of the main screen that can be used.
  $1847 A return can be made at this point if the screen is full and the current line has been printed (#REGe=+00).
  $1849 However if the current line is missing from the listing then S-TOP has to be updated and a further line printed (using scrolling).
@ $1855 label=OUT_LINE
c $1855 THE 'PRINT A WHOLE BASIC LINE' SUBROUTINE
D $1855 The #REGhl register pair points to the start of the line - the location holding the high byte of the line number.
D $1855 Before the line number is printed it is tested to determine whether it comes before the 'current' line, is the 'current' line, or comes after.
  $1855 Fetch the 'current' line number and compare it.
  $185C Pre-load the #REGd register with the current line cursor.
  $185E Jump forward if printing the 'current' line.
@ $1860 keep
  $1860 Load the #REGd register with zero (it is not the cursor) and set #REGe to hold +01 if the line is before the 'current' line and +00 if after. (The carry flag comes from #R$1980.)
@ $1865 label=OUT_LINE1
  $1865 Save the line marker.
  $1868,5 Fetch the high byte of the line number and make a full return if the listing has been finished.
  $186E The line number can now be printed - with leading spaces.
  $1871 Move the pointer on to address the first command code in the line.
  $1874 Signal 'leading space allowed'.
  $1878 Fetch the cursor code and jump forward unless the cursor is to be printed.
  $187C So print the cursor now.
@ $187D label=OUT_LINE2
  $187D Signal 'no leading space now'.
@ $1881 label=OUT_LINE3
  $1881 Save the registers.
  $1882 Move the pointer to #REGde.
  $1883 Signal 'not in quotes'.
  $1887 This is FLAGS.
  $188A Signal 'print in K-mode'.
  $188C Jump forward unless in INPUT mode.
  $1892 Signal 'print in L-mode'.
N $1894 Now enter a loop to print all the codes in the rest of the BASIC line - jumping over floating-point forms as necessary.
@ $1894 label=OUT_LINE4
  $1894 Fetch the syntax error pointer and jump forward unless it is time to print the error marker.
  $189C,5,c2,3 Print the error marker now. It is a flashing '?'.
@ $18A1 label=OUT_LINE5
  $18A1 Consider whether to print the cursor.
  $18A4 Move the pointer to #REGhl now.
  $18A5 Fetch each character in turn.
  $18A6 If the character is a 'number marker' then the hidden floating-point form is not to be printed.
  $18A9 Update the pointer for the next pass.
  $18AA Is the character a 'carriage return'?
  $18AC Jump if it is.
  $18AE Switch the pointer to #REGde.
  $18AF Print the character.
  $18B2 Go around the loop for at least one further pass.
N $18B4 The line has now been printed.
@ $18B4 label=OUT_LINE6
  $18B4 Restore the #REGde register pair and return.
@ $18B6 label=NUMBER
c $18B6 THE 'NUMBER' SUBROUTINE
D $18B6 If the #REGa register holds the 'number marker' then the #REGhl register pair is advanced past the floating-point form.
  $18B6 Is the character a 'number marker'?
  $18B8 Return if not.
  $18B9 Advance the pointer six times so as to step past the 'number marker' and the five locations holding the floating-point form.
  $18BF Fetch the current code before returning.
@ $18C1 label=OUT_FLASH
c $18C1 THE 'PRINT A FLASHING CHARACTER' SUBROUTINE
D $18C1 The 'error cursor' and the 'mode cursors' are printed using this subroutine.
  $18C1 Switch to the alternate registers.
  $18C2 Save the values of ATTR-T and MASK-T on the machine stack.
  $18C6 Ensure that FLASH is active.
  $18CA Use these modified values for ATTR-T and MASK-T.
  $18CD This is P-FLAG.
  $18D0 Save P-FLAG also on the machine stack.
  $18D2 Ensure INVERSE 0, OVER 0, and not PAPER 9 nor INK 9.
  $18D4 The character is printed.
  $18D7 The former value of P-FLAG is restored.
  $18DB The former values of ATTR-T and MASK-T are also restored before returning.
@ $18E1 label=OUT_CURS
c $18E1 THE 'PRINT THE CURSOR' SUBROUTINE
D $18E1 A return is made if it is not the correct place to print the cursor but if it is then 'C', 'E', 'G', 'K' or 'L' will be printed.
  $18E1 Fetch the address of the cursor but return if the correct place is not being considered.
  $18E8 The current value of MODE is fetched and doubled.
  $18ED Jump forward unless dealing with Extended mode or Graphics.
  $18EF Add the appropriate offset to give 'E' or 'G'.
  $18F1 Jump forward to print it.
@ $18F3 label=OUT_C_1
  $18F3 This is FLAGS.
  $18F6 Signal 'K-mode'.
  $18F8,c2 The character 'K'.
  $18FA Jump forward to print 'K' if 'the printing is to be in K-mode'.
  $18FE The 'printing is to be in L-mode' so signal 'L-MODE'.
  $1900 Form the character 'L'.
  $1901 Jump forward if not in 'C-mode'.
  $1907,c2 The character 'C'.
@ $1909 label=OUT_C_2
  $1909 Save the #REGde register pair whilst the cursor is printed - FLASHing.
  $190E Return once it has been done.
E $18E1 Note: it is the action of considering which cursor-letter is to be printed that determines the mode - 'K', 'L' or 'C'.
@ $190F label=LN_FETCH
c $190F THE 'LN-FETCH' SUBROUTINE
D $190F This subroutine is entered with the #REGhl register pair addressing a system variable - S-TOP or E-PPC.
D $190F The subroutine returns with the system variable holding the line number of the following line.
  $190F The line number held by the system variable is collected.
  $1912 The pointer is saved.
  $1913 The line number is moved to the #REGhl register pair and incremented.
  $1915 The address of the start of this line is found, or the next line if the actual line number is not being used.
  $1918 The number of that line is fetched.
  $191B The pointer to the system variable is restored.
@ $191C label=LN_STORE
  $191C Return if in 'INPUT mode'.
  $1921 Otherwise proceed to enter the line number into the two locations of the system variable.
  $1924 Return when it has been done.
@ $1925 label=OUT_SP_2
c $1925 THE 'PRINTING CHARACTERS IN A BASIC LINE' SUBROUTINE
D $1925 All of the character/token codes in a BASIC line are printed by repeatedly calling this subroutine.
D $1925 The entry point #R$192A is used when printing line numbers which may require leading spaces.
  $1925 The #REGa register will hold +20 for a space or +FF for no-space.
  $1926 Test the value and return if there is not to be a space.
  $1928 Jump forward to print a space.
@ $192A label=OUT_SP_NO
  $192A Clear the #REGa register.
N $192B The #REGhl register pair holds the line number and the #REGbc register the value for 'repeated subtraction' (-1000, -100 or -10).
@ $192B label=OUT_SP_1
  $192B The 'trial subtraction'.
  $192C Count each 'trial'.
  $192D Jump back until exhausted.
  $192F Restore last 'subtraction' and discount it.
  $1932 If no 'subtractions' were possible jump back to see if a space is to be printed.
  $1934 Otherwise print the digit.
N $1937 This entry point is used for all characters, tokens and control characters.
@ $1937 label=OUT_CHAR
  $1937 Return carry reset if handling a digit code.
  $193A Jump forward to print the digit.
  $193C Also print the control characters and 'space'.
  $1940 Signal 'print in K-mode'.
  $1944 Jump forward if dealing with the token 'THEN'.
  $1948,4,c2,2 Jump forward unless dealing with ':'.
  $194C Jump forward to print the ':' if in 'INPUT mode'.
  $1952 Jump forward if the ':' is 'not in quotes', i.e. an inter-statement marker.
  $1958 The ':' is inside quotes and can now be printed.
@ $195A label=OUT_CH_1
  $195A,4,c2,2 Accept for printing all characters except '"'.
  $195E Save the character code whilst changing the 'quote mode'.
  $195F Fetch FLAGS2 and flip bit 2.
  $1964 Enter the amended value and restore the character code.
@ $1968 label=OUT_CH_2
  $1968 Signal 'the next character is to be printed in L-mode'.
@ $196C label=OUT_CH_3
  $196C The present character is printed before returning.
E $1925 Note: it is the consequence of the tests on the present character that determines whether the next character is to be printed in 'K' or 'L' mode.
E $1925 Also note how the program does not cater for ':' in REM statements.
@ $196E label=LINE_ADDR
c $196E THE 'LINE-ADDR' SUBROUTINE
D $196E For a given line number, in the #REGhl register pair, this subroutine returns the starting address of that line or the 'first line after', in the #REGhl register pair, and the start of the previous line in the #REGde register pair.
D $196E If the line number is being used the zero flag will be set. However if the 'first line after' is substituted then the zero flag is returned reset.
  $196E Save the given line number.
  $196F Fetch the system variable PROG and transfer the address to the #REGde register pair.
N $1974 Now enter a loop to test the line number of each line of the program against the given line number until the line number is matched or exceeded.
@ $1974 label=LINE_AD_1
  $1974 The given line number.
  $1975 Compare the given line number against the addressed line number
  $1978 Return if carry reset; otherwise address the next line's number.
  $197D Switch the pointers and jump back to consider the next line of the program.
@ $1980 label=CP_LINES
c $1980 THE 'COMPARE LINE NUMBERS' SUBROUTINE
D $1980 The given line number in the #REGbc register pair is matched against the addressed line number.
  $1980 Fetch the high byte of the addressed line number and compare it.
  $1982 Return if they do not match.
  $1983 Next compare the low bytes.
  $1987 Return with the carry flag set if the addressed line number has yet to reach the given line number.
u $1988
C $1988
@ $198B label=EACH_STMT
c $198B THE 'FIND EACH STATEMENT' SUBROUTINE
D $198B This subroutine has two distinct functions.
D $198B #LIST { It can be used to find the #REGdth statement in a BASIC line - returning with the #REGhl register pair addressing the location before the start of the statement and the zero flag set. } { Also the subroutine can be used to find a statement, if any, that starts with a given token code (in the #REGe register). } LIST#
  $198B Set CH-ADD to the current byte.
  $198E Set a 'quotes off' flag.
N $1990 Enter a loop to handle each statement in the BASIC line.
@ $1990 label=EACH_S_1
  $1990 Decrease #REGd and return if the required statement has been found.
  $1992 Fetch the next character code and jump if it does not match the given token code.
  $1996 But should it match then return with the carry and the zero flags both reset.
N $1998 Now enter another loop to consider the individual characters in the line to find where the statement ends.
@ $1998 label=EACH_S_2
  $1998 Update the pointer and fetch the new code.
@ $199A label=EACH_S_3
  $199A Step over any number.
  $199D Update CH-ADD.
  $19A0,4,c2,2 Jump forward if the character is not a '"'.
  $19A4 Otherwise set the 'quotes flag'.
@ $19A5 label=EACH_S_4
  $19A5,4,c2,2 Jump forward if the character is a ':'.
  $19A9 Jump forward unless the code is the token 'THEN'.
@ $19AD label=EACH_S_5
  $19AD Read the 'quotes flag' and jump back at the end of each statement (including after 'THEN').
@ $19B1 label=EACH_S_6
  $19B1 Jump back unless at the end of a BASIC line.
  $19B5 Decrease the statement counter and set the carry flag before returning.
@ $19B8 label=NEXT_ONE
c $19B8 THE 'NEXT-ONE' SUBROUTINE
D $19B8 This subroutine can be used to find the 'next line' in the program area or the 'next variable' in the variables area. The subroutine caters for the six different types of variable that are used in the Spectrum system.
  $19B8 Save the address of the current line or variable.
  $19B9 Fetch the first byte.
  $19BA Jump forward if searching for a 'next line'.
  $19BE Jump forward if searching for the next string or array variable.
  $19C2 Jump forward with simple numeric and FOR-NEXT variables.
  $19C6 Long name numeric variables only.
@ $19C7 keep
@ $19C7 label=NEXT_O_1
  $19C7 A numeric variable will occupy five locations but a FOR-NEXT control variable will need eighteen locations.
@ $19CE label=NEXT_O_2
  $19CE The carry flag becomes reset for long named variables only, until the final character of the long name is reached.
  $19CF Increment the pointer and fetch the new code.
  $19D1 Jump back unless the previous code was the last code of the variable's name.
  $19D3 Now jump forward (#REGbc=+0005 or +0012).
@ $19D5 label=NEXT_O_3
  $19D5 Step past the low byte of the line number.
@ $19D6 label=NEXT_O_4
  $19D6 Now point to the low byte of the length.
  $19D7 Fetch the length into the #REGbc register pair.
  $19DA Allow for the inclusive byte.
N $19DB In all cases the address of the 'next' line or variable is found.
@ $19DB label=NEXT_O_5
  $19DB Point to the first byte of the 'next' line or variable.
  $19DC Fetch the address of the previous one and continue into the 'difference' subroutine.
@ $19DD label=DIFFER
c $19DD THE 'DIFFERENCE' SUBROUTINE
D $19DD The 'length' between two 'starts' is formed in the #REGbc register pair. The pointers are reformed but returned exchanged.
  $19DD Prepare for a true subtraction.
  $19DE Find the length from one 'start' to the next and pass it to the #REGbc register pair.
  $19E2 Reform the address and exchange them before returning.
@ $19E5 label=RECLAIM_1
c $19E5 THE 'RECLAIMING' SUBROUTINE
D $19E5 The main entry point is used when the address of the first location to be reclaimed is in the #REGde register pair and the address of the first location to be left alone is in the #REGhl register pair. The entry point #R$19E8 is used when the #REGhl register pair points to the first location to be reclaimed and the #REGbc register pair holds the number of bytes that are to be reclaimed.
  $19E5 Use the 'difference' subroutine to develop the appropriate values.
@ $19E8 label=RECLAIM_2
  $19E8 Save the number of bytes to be reclaimed.
  $19E9 All the system variable pointers above the area have to be reduced by #REGbc, so this number is 2's complemented before the pointers are altered.
  $19F3 Return the 'first location' address to the #REGde register pair and form the address of the first location to the left.
  $19F6 Save the 'first location' whilst the actual reclamation occurs.
  $19FA Now return.
@ $19FB label=E_LINE_NO
c $19FB THE 'E-LINE-NO' SUBROUTINE
D $19FB This subroutine is used to read the line number of the line in the editing area. If there is no line number, i.e. a direct BASIC line, then the line number is considered to be zero.
D $19FB In all cases the line number is returned in the #REGbc register pair.
  $19FB Pick up the pointer to the edit-line.
  $19FE Set CH-ADD to point to the location before any number.
  $1A02 Pass the first code to the #REGa register.
  $1A03 However before considering the code make the calculator's memory area a temporary calculator stack area.
  $1A09 Now read the digits of the line number. Return zero if no number exists.
  $1A0C Compress the line number into the #REGbc register pair.
  $1A0F Jump forward if the number exceeds 65,536.
  $1A11 Otherwise test it against 10,000.
@ $1A15 label=E_L_1
  $1A15 Give report C if over 9,999.
  $1A18 Return via #R$16C5 that restores the calculator stack to its rightful place.
@ $1A1B label=OUT_NUM_1
c $1A1B THE 'REPORT AND LINE NUMBER PRINTING' SUBROUTINE
D $1A1B The entry point #R$1A1B will lead to the number in the #REGbc register pair being printed. Any value over 9999 will not however be printed correctly.
D $1A1B The entry point #R$1A28 will lead to the number indirectly addressed by the #REGhl register pair being printed. This time any necessary leading spaces will appear. Again the limit of correctly printed numbers is 9999.
  $1A1B Save the other registers throughout the subroutine.
  $1A1D Clear the #REGa register.
  $1A1E Jump forward to print a zero rather than '-2' when reporting on the edit-line.
  $1A22 Move the number to the #REGhl register pair.
  $1A24 Flag 'no leading spaces'.
  $1A26 Jump forward to print the number.
@ $1A28 label=OUT_NUM_2
  $1A28 Save the #REGde register pair.
  $1A29 Fetch the number into the #REGde register pair and save the pointer (updated).
  $1A2D Move the number to the #REGhl register pair and flag 'leading spaces are to be printed'.
N $1A30 Now the integer form of the number in the #REGhl register pair is printed.
@ $1A30 label=OUT_NUM_3
  $1A30 This is '-1,000'.
  $1A33 Print a first digit.
  $1A36 This is '-100'.
  $1A39 Print the second digit.
  $1A3C This is '-10'.
  $1A3E Print the third digit.
  $1A41 Move any remaining part of the number to the #REGa register.
@ $1A42 label=OUT_NUM_4
  $1A42 Print the digit.
  $1A45 Restore the registers before returning.
@ $1A48 label=SYNTAX
b $1A48 THE SYNTAX TABLES
D $1A48 i. The offset table.
D $1A48 There is an offset value for each of the fifty BASIC commands.
  $1A48 #R$1AF9
  $1A49 #R$1B14
  $1A4A #R$1B06
  $1A4B #R$1B0A
  $1A4C #R$1B10
  $1A4D #R$1AFC
  $1A4E #R$1B02
  $1A4F #R$1AE2
  $1A50 #R$1AE1
  $1A51 #R$1AE3
  $1A52 #R$1AE7
  $1A53 #R$1AEB
  $1A54 #R$1AEC
  $1A55 #R$1AED
  $1A56 #R$1AEE
  $1A57 #R$1AEF
  $1A58 #R$1AF0
  $1A59 #R$1AF1
  $1A5A #R$1AD9
  $1A5B #R$1ADC
  $1A5C #R$1A8A
  $1A5D #R$1AC9
  $1A5E #R$1ACC
  $1A5F #R$1ACF
  $1A60 #R$1AA8
  $1A61 #R$1AF5
  $1A62 #R$1AB8
  $1A63 #R$1AA2
  $1A64 #R$1AA5
  $1A65 #R$1A90
  $1A66 #R$1A7D
  $1A67 #R$1A86
  $1A68 #R$1A9F
  $1A69 #R$1AE0
  $1A6A #R$1AAE
  $1A6B #R$1A7A
  $1A6C #R$1AC5
  $1A6D #R$1A98
  $1A6E #R$1AB1
  $1A6F #R$1A9C
  $1A70 #R$1AC1
  $1A71 #R$1AAB
  $1A72 #R$1ADF
  $1A73 #R$1AB5
  $1A74 #R$1A81
  $1A75 #R$1ABE
  $1A76 #R$1AD2
  $1A77 #R$1ABB
  $1A78 #R$1A8D
  $1A79 #R$1AD6
N $1A7A ii. The parameter table.
N $1A7A For each of the fifty BASIC commands there are up to eight entries in the parameter table. These entries comprise command class details, required separators and, where appropriate, command routine addresses.
@ $1A7A label=P_LET
  $1A7A #R$1C1F
  $1A7B,1,T1
  $1A7C #R$1C4E
@ $1A7D label=P_GO_TO
  $1A7D #R$1C82(CLASS_06)
  $1A7E #R$1C10
W $1A7F
@ $1A81 label=P_IF
  $1A81 #R$1C82(CLASS_06)
  $1A82 THEN
  $1A83 #R$1C11
W $1A84
@ $1A86 label=P_GO_SUB
  $1A86 #R$1C82(CLASS_06)
  $1A87 #R$1C10
W $1A88
@ $1A8A label=P_STOP
  $1A8A #R$1C10
W $1A8B
@ $1A8D label=P_RETURN
  $1A8D #R$1C10
W $1A8E
@ $1A90 label=P_FOR
  $1A90 #R$1C6C
  $1A91,1,T1
  $1A92 #R$1C82(CLASS_06)
  $1A93 TO
  $1A94 #R$1C82(CLASS_06)
  $1A95 #R$1C11
W $1A96
@ $1A98 label=P_NEXT
  $1A98 #R$1C6C
  $1A99 #R$1C10
W $1A9A
@ $1A9C label=P_PRINT
  $1A9C #R$1C11
W $1A9D
@ $1A9F label=P_INPUT
  $1A9F #R$1C11
W $1AA0
@ $1AA2 label=P_DIM
  $1AA2 #R$1C11
W $1AA3
@ $1AA5 label=P_REM
  $1AA5 #R$1C11
W $1AA6
@ $1AA8 label=P_NEW
  $1AA8 #R$1C10
W $1AA9
@ $1AAB label=P_RUN
  $1AAB #R$1C0D
W $1AAC
@ $1AAE label=P_LIST
  $1AAE #R$1C11
W $1AAF
@ $1AB1 label=P_POKE
  $1AB1 #R$1C7A(CLASS_08)
  $1AB2 #R$1C10
W $1AB3
@ $1AB5 label=P_RANDOM
  $1AB5 #R$1C0D
W $1AB6
@ $1AB8 label=P_CONT
  $1AB8 #R$1C10
W $1AB9
@ $1ABB label=P_CLEAR
  $1ABB #R$1C0D
W $1ABC
@ $1ABE label=P_CLS
  $1ABE #R$1C10
W $1ABF
@ $1AC1 label=P_PLOT
  $1AC1 #R$1CBE
  $1AC2 #R$1C10
W $1AC3
@ $1AC5 label=P_PAUSE
  $1AC5 #R$1C82(CLASS_06)
  $1AC6 #R$1C10
W $1AC7
@ $1AC9 label=P_READ
  $1AC9 #R$1C11
W $1ACA
@ $1ACC label=P_DATA
  $1ACC #R$1C11
W $1ACD
@ $1ACF label=P_RESTORE
  $1ACF #R$1C0D
W $1AD0
@ $1AD2 label=P_DRAW
  $1AD2 #R$1CBE
  $1AD3 #R$1C11
W $1AD4
@ $1AD6 label=P_COPY
  $1AD6 #R$1C10
W $1AD7
@ $1AD9 label=P_LPRINT
  $1AD9 #R$1C11
W $1ADA
@ $1ADC label=P_LLIST
  $1ADC #R$1C11
W $1ADD
@ $1ADF label=P_SAVE
  $1ADF #R$1CDB
@ $1AE0 label=P_LOAD
  $1AE0 #R$1CDB
@ $1AE1 label=P_VERIFY
  $1AE1 #R$1CDB
@ $1AE2 label=P_MERGE
  $1AE2 #R$1CDB
@ $1AE3 label=P_BEEP
  $1AE3 #R$1C7A(CLASS_08)
  $1AE4 #R$1C10
W $1AE5
@ $1AE7 label=P_CIRCLE
  $1AE7 #R$1CBE
  $1AE8 #R$1C11
W $1AE9
@ $1AEB label=P_INK
  $1AEB #R$1C96(CLASS_07)
@ $1AEC label=P_PAPER
  $1AEC #R$1C96(CLASS_07)
@ $1AED label=P_FLASH
  $1AED #R$1C96(CLASS_07)
@ $1AEE label=P_BRIGHT
  $1AEE #R$1C96(CLASS_07)
@ $1AEF label=P_INVERSE
  $1AEF #R$1C96(CLASS_07)
@ $1AF0 label=P_OVER
  $1AF0 #R$1C96(CLASS_07)
@ $1AF1 label=P_OUT
  $1AF1 #R$1C7A(CLASS_08)
  $1AF2 #R$1C10
W $1AF3
@ $1AF5 label=P_BORDER
  $1AF5 #R$1C82(CLASS_06)
  $1AF6 #R$1C10
W $1AF7
@ $1AF9 label=P_DEF_FN
  $1AF9 #R$1C11
W $1AFA
@ $1AFC label=P_OPEN
  $1AFC #R$1C82(CLASS_06)
  $1AFD,1,T1
  $1AFE #R$1C8C(CLASS_0A)
  $1AFF #R$1C10
W $1B00
@ $1B02 label=P_CLOSE
  $1B02 #R$1C82(CLASS_06)
  $1B03 #R$1C10
W $1B04
@ $1B06 label=P_FORMAT
  $1B06 #R$1C8C(CLASS_0A)
  $1B07 #R$1C10
W $1B08
@ $1B0A label=P_MOVE
  $1B0A #R$1C8C(CLASS_0A)
  $1B0B,1,T1
  $1B0C #R$1C8C(CLASS_0A)
  $1B0D #R$1C10
W $1B0E
@ $1B10 label=P_ERASE
  $1B10 #R$1C8C(CLASS_0A)
  $1B11 #R$1C10
W $1B12
@ $1B14 label=P_CAT
  $1B14 #R$1C10
E $1A48 Note: the requirements for the different command classes are as follows:
E $1A48 #LIST { #R$1C10 - No further operands. } { #R$1C1F - Used in LET. A variable is required. } { #R$1C4E - Used in LET. An expression, numeric or string, must follow. } { #R$1C0D - A numeric expression may follow. Zero to be used in case of default. } { #R$1C6C - A single character variable must follow. } { #R$1C11 - A set of items may be given. } { #R$1C82(CLASS_06) - A numeric expression must follow. } { #R$1C96(CLASS_07) - Handles colour items. } { #R$1C7A(CLASS_08) - Two numeric expressions, separated by a comma, must follow. } { #R$1CBE - As for CLASS_08 but colour items may precede the expressions. } { #R$1C8C(CLASS_0A) - A string expression must follow. } { #R$1CDB - Handles cassette routines. } LIST#
W $1B15
@ $1B17 label=LINE_SCAN
c $1B17 THE 'MAIN PARSER' OF THE BASIC INTERPRETER
D $1B17 The parsing routine of the BASIC interpreter is entered here when syntax is being checked, and at #R$1B8A when a BASIC program of one or more statements is to be executed.
D $1B17 Each statement is considered in turn and the system variable CH-ADD is used to point to each code of the statement as it occurs in the program area or the editing area.
  $1B17 Signal 'syntax checking'.
  $1B1B CH-ADD is made to point to the first code after any line number.
  $1B1E The system variable SUBPPC is initialised to +00 and ERR-NR to +FF.
  $1B26 Jump forward to consider the first statement of the line.
@ $1B28 label=STMT_LOOP
c $1B28 THE STATEMENT LOOP
D $1B28 Each statement is considered in turn until the end of the line is reached.
  $1B28 Advance CH-ADD along the line.
@ $1B29 label=STMT_L_1
  $1B29 The work space is cleared.
  $1B2C Increase SUBPPC on each passage around the loop.
  $1B2F But only '127' statements are allowed in a single line.
  $1B32 Fetch a character.
  $1B33 Clear the #REGb register for later.
  $1B35 Is the character a 'carriage return'?
  $1B37 Jump if it is.
  $1B39,4,c2,2 Go around the loop again if it is a ':'.
N $1B3D A statement has been identified so, first, its initial command is considered.
@ $1B3D nowarn
  $1B3D Pre-load the machine stack with the return address #R$1B76.
  $1B41 Save the command temporarily in the #REGc register whilst CH-ADD is advanced again.
  $1B44 Reduce the command's code by +CE, giving the range +00 to +31 for the fifty commands.
  $1B46 Give the appropriate error if not a command code.
  $1B49 Move the command code to the #REGbc register pair (#REGb holds +00).
  $1B4A The base address of the #R$1A48(syntax offset table).
  $1B4D The required offset is passed to the #REGc register and used to compute the base address for the command's entries in the #R$1A7A(parameter table).
  $1B50 Jump forward into the scanning loop with this address.
N $1B52 Each of the command class routines applicable to the present command is executed in turn. Any required separators are also considered.
@ $1B52 label=SCAN_LOOP
  $1B52 The temporary pointer to the entries in the #R$1A7A(parameter table).
@ $1B55 label=GET_PARAM
  $1B55 Fetch each entry in turn.
  $1B56 Update the pointer to the entries for the next pass.
@ $1B5A nowarn
  $1B5A Pre-load the machine stack with the return address #R$1B52.
  $1B5E Copy the entry to the #REGc register for later.
  $1B5F Jump forward if the entry is a 'separator'.
  $1B63 The base address of the #R$1C01(command class table).
  $1B66 Clear the #REGb register and index into the table.
  $1B69 Fetch the offset and compute the starting address of the required command class routine.
  $1B6B Push the address on to the machine stack.
  $1B6C Before making an indirect jump to the command class routine pass the command code to the #REGa register and set the #REGb register to +FF.
@ $1B6F label=SEPARATOR
c $1B6F THE 'SEPARATOR' SUBROUTINE
D $1B6F The report 'Nonsense in BASIC' is given if the required separator is not present. But note that when syntax is being checked the actual report does not appear on the screen - only the 'error marker'.
  $1B6F The current character is fetched and compared to the entry in the parameter table.
  $1B71 Give the error report if there is not a match.
  $1B74 Step past a correct character and return.
@ $1B76 label=STMT_RET
c $1B76 THE 'STMT-RET' SUBROUTINE
D $1B76 After the correct interpretation of a statement a return is made to this entry point.
  $1B76 The BREAK key is tested after every statement.
  $1B79 Jump forward unless it has been pressed.
N $1B7B Report L - BREAK into program.
@ $1B7B label=REPORT_L
M $1B7B,2 Call the error handling routine.
B $1B7C,1
N $1B7D Continue here as the BREAK key was not pressed.
@ $1B7D label=STMT_R_1
  $1B7D Jump forward if there is not a 'jump' to be made.
  $1B83 Fetch the 'new line' number and jump forward unless dealing with a further statement in the editing area.
@ $1B8A label=LINE_RUN
c $1B8A THE 'LINE-RUN' ENTRY POINT
D $1B8A This entry point is used wherever a line in the editing area is to be 'run'. In such a case the syntax/run flag (bit 7 of FLAGS) will be set.
D $1B8A The entry point is also used in the syntax checking of a line in the editing area that has more than one statement (bit 7 of FLAGS will be reset).
  $1B8A A line in the editing area is considered as line '-2'.
  $1B90 Make #REGhl point to the end marker of the editing area and #REGde to the location before the start of that area.
  $1B99 Fetch the number of the next statement to be handled before jumping forward.
@ $1B9E label=LINE_NEW
c $1B9E THE 'LINE-NEW' SUBROUTINE
D $1B9E There has been a jump in the program and the starting address of the new line has to be found.
  $1B9E The starting address of the line, or the 'first line after' is found.
  $1BA1 Collect the statement number.
  $1BA4 Jump forward if the required line was found; otherwise check the validity of the statement number - must be zero.
  $1BA9 Also check that the 'first line after' is not after the actual 'end of program'.
  $1BAE Jump forward with valid addresses; otherwise signal the error 'OK'.
N $1BB0 Report 0 - OK.
@ $1BB0 label=REPORT_0
M $1BB0,2 Use the error handling routine.
B $1BB1,1
E $1B9E Note: obviously not an error in the normal sense - but rather a jump past the program.
@ $1BB2 label=REM
c $1BB2 THE 'REM' COMMAND ROUTINE
D $1BB2 The address of this routine is found in the #R$1AA5(parameter table).
D $1BB2 The return address to #R$1B76 is dropped which has the effect of forcing the rest of the line to be ignored.
  $1BB2 Drop the address - #R$1B76.
@ $1BB3 label=LINE_END
c $1BB3 THE 'LINE-END' ROUTINE
D $1BB3 If checking syntax a simple return is made but when 'running' the address held by NXTLIN has to be checked before it can be used.
  $1BB3 Return if syntax is being checked; otherwise fetch the address in NXTLIN.
  $1BBA Return also if the address is after the end of the program - the 'run' is finished.
  $1BBE Signal 'statement zero' before proceeding.
@ $1BBF label=LINE_USE
c $1BBF THE 'LINE-USE' ROUTINE
D $1BBF This short routine has three functions:
D $1BBF #LIST { Change statement zero to statement '1'. } { Find the number of the new line and enter it into PPC. } { Form the address of the start of the line after. } LIST#
  $1BBF Statement zero becomes statement '1'.
  $1BC3 The line number of the line to be used is collected and passed to PPC.
  $1BCA Now find the 'length' of the line.
  $1BCE Switch over the values.
  $1BCF Form the address of the start of the line after in #REGhl and the location before the 'next' line's first character in #REGde.
@ $1BD1 label=NEXT_LINE
c $1BD1 THE 'NEXT-LINE' ROUTINE
D $1BD1 On entry the #REGhl register pair points to the location after the end of the 'next' line to be handled and the #REGde register pair to the location before the first character of the line. This applies to lines in the program area and also to a line in the editing area - where the next line will be the same line again whilst there are still statements to be interpreted.
  $1BD1 Set NXTLIN for use once the current line has been completed.
  $1BD4 As usual CH-ADD points to the location before the first character to be considered.
  $1BD8 The statement number is fetched.
  $1BD9 The #REGe register is cleared in case #R$198B is used.
  $1BDB Signal 'no jump'.
  $1BDF The statement number minus one goes into SUBPPC.
  $1BE3 A first statement can now be considered.
  $1BE6 However for later statements the 'starting address' has to be found.
  $1BEA Jump forward unless the statement does not exist.
N $1BEC Report N - Statement lost.
@ $1BEC label=REPORT_N
M $1BEC,2 Call the error handling routine.
B $1BED,1
@ $1BEE label=CHECK_END
c $1BEE THE 'CHECK-END' SUBROUTINE
D $1BEE This is an important routine and is called from many places in the monitor program when the syntax of the edit-line is being checked. The purpose of the routine is to give an error report if the end of a statement has not been reached and to move on to the next statement if the syntax is correct.
  $1BEE Do not proceed unless checking syntax.
  $1BF2 Drop the addresses of #R$1B52 and #R$1B76 before continuing into #R$1BF4.
@ $1BF4 label=STMT_NEXT
c $1BF4 THE 'STMT-NEXT' ROUTINE
D $1BF4 If the present character is a 'carriage return' then the 'next statement' is on the 'next line'; if ':' it is on the same line; but if any other character is found then there is an error in syntax.
  $1BF4 Fetch the present character.
  $1BF5 Consider the 'next line' if it is a 'carriage return'.
  $1BF9,5,c2,3 Consider the 'next statement' if it is a ':'.
  $1BFE Otherwise there has been a syntax error.
@ $1C01 label=CMDCLASS
b $1C01 THE 'COMMAND CLASS' TABLE
  $1C01 #R$1C10
  $1C02 #R$1C1F
  $1C03 #R$1C4E
  $1C04 #R$1C0D
  $1C05 #R$1C6C
  $1C06 #R$1C11
  $1C07 #R$1C82(CLASS_06)
  $1C08 #R$1C96(CLASS_07)
  $1C09 #R$1C7A(CLASS_08)
  $1C0A #R$1CBE
  $1C0B #R$1C8C(CLASS_0A)
  $1C0C #R$1CDB
@ $1C0D label=CLASS_03
c $1C0D THE 'COMMAND CLASSES - 00, 03 and 05'
D $1C0D The commands of class-03 may, or may not, be followed by a number. e.g. RUN and RUN 200.
  $1C0D A number is fetched but zero is used in cases of default.
N $1C10 The commands of class-00 must not have any operands, e.g. COPY and CONTINUE.
@ $1C10 label=CLASS_00
  $1C10 Set the zero flag for later.
N $1C11 The commands of class-05 may be followed by a set of items, e.g. PRINT and PRINT "222".
@ $1C11 label=CLASS_05
  $1C11 In all cases drop the address - #R$1B52.
  $1C12 If handling commands of classes 00 and 03 and syntax is being checked move on now to consider the next statement.
  $1C15 Save the line pointer in the #REGde register pair.
@ $1C16 label=JUMP_C_R
c $1C16 THE 'JUMP-C-R' ROUTINE
D $1C16 After the command class entries and the separator entries in the parameter table have been considered the jump to the appropriate command routine is made.
  $1C16 Fetch the pointer to the entries in the parameter table and fetch the address of the required command routine.
  $1C1C Exchange the pointers back and make an indirect jump to the command routine.
@ $1C1F label=CLASS_01
c $1C1F THE 'COMMAND CLASS 01' ROUTINE
D $1C1F Command class 01 is concerned with the identification of the variable in a LET, READ or INPUT statement.
  $1C1F Look in the variables area to determine whether or not the variable has been used already.
@ $1C22 label=VAR_A_1
c $1C22 THE 'VARIABLE IN ASSIGNMENT' SUBROUTINE
D $1C22 This subroutine develops the appropriate values for the system variables DEST and STRLEN.
  $1C22 Initialise FLAGX to +00.
  $1C26 Jump forward if the variable has been used before.
  $1C28 Signal 'a new variable'.
  $1C2C Give an error if trying to use an 'undimensioned array'.
N $1C2E Report 2 - Variable not found.
@ $1C2E label=REPORT_2_2
M $1C2E,2 Call the error handling routine.
B $1C2F,1
N $1C30 Continue with the handling of existing variables.
@ $1C30 label=VAR_A_2
  $1C30 The parameters of simple string variables and all array variables are passed to the calculator stack. (#R$2996 will 'slice' a string if required.)
  $1C33 Jump forward if handling a numeric variable.
  $1C39 Clear the #REGa register.
  $1C3A The parameters of the string of string array variable are fetched unless syntax is being checked.
  $1C40 This is FLAGX.
  $1C43 Bit 0 is set only when handling complete 'simple strings' thereby signalling 'old copy to be deleted'.
  $1C45 #REGhl now points to the string or the element of the array.
N $1C46 The pathways now come together to set STRLEN and DEST as required. For all numeric variables and 'new' string and string array variables STRLEN-lo holds the 'letter' of the variable's name. But for 'old' string and string array variables whether 'sliced' or complete it holds the 'length' in 'assignment'.
@ $1C46 label=VAR_A_3
  $1C46 Set STRLEN as required.
N $1C4A DEST holds the address for the 'destination' of an 'old' variable but in effect the 'source' for a 'new' variable.
  $1C4A Set DEST as required and return.
@ $1C4E label=CLASS_02
c $1C4E THE 'COMMAND CLASS 02' ROUTINE
D $1C4E Command class 02 is concerned with the actual calculation of the value to be assigned in a LET statement.
  $1C4E The address #R$1B52 is dropped.
  $1C4F The assignment is made.
  $1C52 Move on to the next statement either via #R$1BEE if checking syntax, or #R$1B76 if in 'run-time'.
@ $1C56 label=VAL_FET_1
c $1C56 THE 'FETCH A VALUE' SUBROUTINE
D $1C56 This subroutine is used by LET, READ and INPUT statements to first evaluate and then assign values to the previously designated variable.
D $1C56 The main entry point is used by LET and READ and considers FLAGS, whereas the entry point #R$1C59 is used by INPUT and considers FLAGX.
  $1C56 Use FLAGS.
@ $1C59 label=VAL_FET_2
  $1C59 Save FLAGS or FLAGX.
  $1C5A Evaluate the next expression.
  $1C5D Fetch the old FLAGS or FLAGX.
  $1C5E Fetch the new FLAGS.
  $1C61 The nature - numeric or string - of the variable and the expression must match.
  $1C64 Give report C if they do not.
  $1C66 Jump forward to make the actual assignment unless checking syntax (in which case simply return).
@ $1C6C label=CLASS_04
c $1C6C THE 'COMMAND CLASS 04' ROUTINE
D $1C6C The command class 04 entry point is used by FOR and NEXT statements.
  $1C6C Look in the variables area for the variable being used.
  $1C6F Save the #REGaf register pair whilst the discriminator byte is tested to ensure that the variable is a FOR-NEXT control variable.
  $1C76 Restore the flags register and jump to make the variable that has been found the 'variable in assignment'.
@ $1C79 label=NEXT_2NUM
c $1C79 THE 'EXPECT NUMERIC/STRING EXPRESSIONS' SUBROUTINE
D $1C79 There is a series of short subroutines that are used to fetch the result of evaluating the next expression. The result from a single expression is returned as a 'last value' on the calculator stack.
N $1C79 This entry point is used when CH-ADD needs updating to point to the start of the first expression.
  $1C79 Advance CH-ADD.
N $1C7A This entry point (CLASS-08) allows for two numeric expressions, separated by a comma, to be evaluated.
@ $1C7A label=EXPT_2NUM
  $1C7A Evaluate each expression in turn - so evaluate the first.
  $1C7D,4,c2,2 Give an error report if the separator is not a comma.
  $1C81 Advance CH-ADD.
N $1C82 This entry point (CLASS-06) allows for a single numeric expression to be evaluated.
@ $1C82 label=EXPT_1NUM
  $1C82 Evaluate the next expression.
  $1C85 Return as long as the result was numeric; otherwise it is an error.
N $1C8A Report C - Nonsense in BASIC.
@ $1C8A label=REPORT_C
M $1C8A,2 Call the error handling routine.
B $1C8B,1
N $1C8C This entry point (CLASS-0A) allows for a single string expression to be evaluated.
@ $1C8C label=EXPT_EXP
  $1C8C Evaluate the next expression.
  $1C8F This time return if the result indicates a string; otherwise give an error report.
@ $1C96 label=PERMS
c $1C96 THE 'SET PERMANENT COLOURS' SUBROUTINE (EQU. CLASS-07)
D $1C96 This subroutine allows for the current temporary colours to be made permanent. As command class 07 it is in effect the command routine for the six colour item commands.
  $1C96 The syntax/run flag is read.
  $1C9A Signal 'main screen'.
  $1C9E Only during a 'run' call #R$0D4D to ensure the temporary colours are the main screen colours.
  $1CA1 Drop the return address #R$1B52.
  $1CA2 Fetch the low byte of T-ADDR and subtract +13 to give the range +D9 to +DE which are the token codes for INK to OVER.
  $1CA7 Change the temporary colours as directed by the BASIC statement.
  $1CAA Move on to the next statement if checking syntax.
  $1CAD Now the temporary colour values are made permanent (both ATTR-P and MASK-P).
  $1CB3 This is P-FLAG, and that too has to be considered.
N $1CB7 The following instructions cleverly copy the even bits of the supplied byte to the odd bits, in effect making the permanent bits the same as the temporary ones.
  $1CB7 Move the mask leftwards.
  $1CB8 Impress onto the mask only the even bits of the other byte.
  $1CBC,1 Restore the result.
@ $1CBE label=CLASS_09
c $1CBE THE 'COMMAND CLASS 09' ROUTINE
D $1CBE This routine is used by PLOT, DRAW and CIRCLE statements in order to specify the default conditions of 'FLASH 8; BRIGHT 8; PAPER 8;' that are set up before any embedded colour items are considered.
  $1CBE Jump forward if checking syntax.
  $1CC3 Signal 'main screen'.
  $1CC7 Set the temporary colours for the main screen.
  $1CCA This is MASK-T.
  $1CCD Fetch its present value but keep only its INK part 'unmasked'.
  $1CD0 Restore the value which now indicates 'FLASH 8; BRIGHT 8; PAPER 8;'.
  $1CD1 Also ensure NOT 'PAPER 9'.
  $1CD5 Fetch the present character before continuing to deal with embedded colour items.
@ $1CD6 label=CL_09_1
  $1CD6 Deal with the locally dominant colour items.
  $1CD9 Now get the first two operands for PLOT, DRAW or CIRCLE.
@ $1CDB label=CLASS_0B
c $1CDB THE 'COMMAND CLASS 0B' ROUTINE
D $1CDB This routine is used by SAVE, LOAD, VERIFY and MERGE statements.
  $1CDB Jump to the cassette handling routine.
@ $1CDE label=FETCH_NUM
c $1CDE THE 'FETCH A NUMBER' SUBROUTINE
D $1CDE This subroutine leads to a following numeric expression being evaluated but zero being used instead if there is no expression.
  $1CDE Jump forward if at the end of a line.
  $1CE2,4,c2,2 But jump to #R$1C82 unless at the end of a statement.
N $1CE6 The calculator is now used to add the value zero to the calculator stack.
@ $1CE6 label=USE_ZERO
  $1CE6 Do not perform the operation if syntax is being checked.
  $1CEA Use the calculator.
B $1CEB,1 #R$341B(stk_zero)
B $1CEC,1 #R$369B
  $1CED Return with zero added to the stack.
@ $1CEE label=STOP
c $1CEE THE 'STOP' COMMAND ROUTINE
D $1CEE The address of this routine is found in the #R$1A8A(parameter table).
D $1CEE The command routine for STOP contains only a call to the error handling routine.
M $1CEE,2 Call the error handling routine.
B $1CEF,1
@ $1CF0 label=IF_CMD
c $1CF0 THE 'IF' COMMAND ROUTINE
D $1CF0 The address of this routine is found in the #R$1A81(parameter table).
D $1CF0 On entry the value of the expression between the IF and the THEN is the 'last value' on the calculator stack. If this is logically true then the next statement is considered; otherwise the line is considered to have been finished.
  $1CF0 Drop the return address - #R$1B76.
  $1CF1 Jump forward if checking syntax.
N $1CF6 Now use the calculator to 'delete' the last value on the calculator stack but leave the #REGde register pair addressing the first byte of the value.
  $1CF6 Use the calculator.
B $1CF7,1 #R$33A1
B $1CF8,1 #R$369B
  $1CF9 Make #REGhl point to the first byte and call #R$34E9.
  $1CFD If the value was 'FALSE' jump to the next line.
@ $1D00 label=IF_1
  $1D00 But if 'TRUE' jump to the next statement (after the THEN).
@ $1D03 label=FOR
c $1D03 THE 'FOR' COMMAND ROUTINE
D $1D03 The address of this routine is found in the #R$1A90(parameter table).
D $1D03 This command routine is entered with the VALUE and the LIMIT of the FOR statement already on the top of the calculator stack.
  $1D03 Jump forward unless a 'STEP' is given.
  $1D07 Advance CH-ADD and fetch the value of the STEP.
  $1D0B Move on to the next statement if checking syntax; otherwise jump forward.
N $1D10 There has not been a STEP supplied so the value '1' is to be used.
@ $1D10 label=F_USE_1
  $1D10 Move on to the next statement if checking syntax.
  $1D13 Otherwise use the calculator to place a '1' on the calculator stack.
B $1D14,1 #R$341B(stk_one)
B $1D15,1 #R$369B
N $1D16 The three values on the calculator stack are the VALUE (v), the LIMIT (l) and the STEP (s). These values now have to be manipulated.
@ $1D16 label=F_REORDER
  $1D16 v, l, s
B $1D17,1 #R$342D(st_mem_0): v, l, s (mem-0=s)
B $1D18,1 #R$33A1: v, l
B $1D19,1 #R$343C: l, v
B $1D1A,1 #R$340F(get_mem_0): l, v, s
B $1D1B,1 #R$343C: l, s, v
B $1D1C,1 #R$369B
N $1D1D A FOR control variable is now established and treated as a temporary calculator memory area.
  $1D1D The variable is found, or created if needed (v is used).
  $1D20 Make it a 'memory area'.
N $1D23 The variable that has been found may be a simple numeric variable using only six locations in which case it will need extending.
  $1D23 Fetch the variable's single character name.
  $1D25 Ensure bit 7 of the name is set.
@ $1D27 keep
  $1D27 It will have six locations at least.
  $1D2A Make #REGhl point after them.
  $1D2B Rotate the name and jump if it was already a FOR variable.
  $1D2E Otherwise create thirteen more locations.
  $1D33 Again make #REGhl point to the LIMIT position.
N $1D34 The initial values for the LIMIT and the STEP are now added.
@ $1D34 label=F_L_S
  $1D34 The pointer is saved.
  $1D35 l, s
B $1D36,1 #R$33A1: l
B $1D37,1 #R$33A1: -
B $1D38,1 #R$369B: #REGde still points to 'l'
  $1D39 The pointer is restored and both pointers exchanged.
  $1D3B The ten bytes of the LIMIT and the STEP are moved.
N $1D3F The looping line number and statement number are now entered.
  $1D3F The current line number.
  $1D42 Exchange the registers before adding the line number to the FOR control variable.
  $1D46 The looping statement is always the next statement whether it exists or not.
N $1D4C The #R$1DDA subroutine is called to test the possibility of a 'pass' and a return is made if one is possible; otherwise the statement after for FOR - NEXT loop has to be identified.
  $1D4C Is a 'pass' possible?
  $1D4F Return now if it is.
  $1D50 Fetch the variable's name.
  $1D53 Copy the present line number to NEWPPC.
  $1D59 Fetch the current statement number and two's complement it.
  $1D5E Transfer the result to the #REGd register.
  $1D5F Fetch the current value of CH-ADD.
  $1D62 The search will be for 'NEXT'.
N $1D64 Now a search is made in the program area, from the present point onwards, for the first occurrence of NEXT followed by the correct variable.
@ $1D64 label=F_LOOP
  $1D64 Save the variable's name.
  $1D65 Fetch the current value of NXTLIN.
  $1D69 The program area is now searched and #REGbc will change with each new line examined.
  $1D6C Upon return save the pointer.
  $1D70 Restore the variable's name.
  $1D71 If there are no further NEXTs then give an error.
  $1D73 Advance past the NEXT that was found.
  $1D74 Allow for upper and lower case letters before the new variable name is tested.
  $1D77 Jump forward if it matches.
  $1D79 Advance CH-ADD again and jump back if not the correct variable.
N $1D7C NEWPPC holds the line number of the line in which the correct NEXT was found. Now the statement number has to be found and stored in NSPPC.
@ $1D7C label=F_FOUND
  $1D7C Advance CH-ADD.
  $1D7D The statement counter in the #REGd register counted statements back from zero so it has to be subtracted from '1'.
  $1D80 The result is stored.
  $1D83 Now return - to #R$1B76.
N $1D84 Report I - FOR without NEXT.
@ $1D84 label=REPORT_I
M $1D84,2 Call the error handling routine.
B $1D85,1
@ $1D86 label=LOOK_PROG
c $1D86 THE 'LOOK-PROG' SUBROUTINE
D $1D86 This subroutine is used to find occurrences of either DATA, DEF FN or NEXT. On entry the appropriate token code is in the #REGe register and the #REGhl register pair points to the start of the search area.
  $1D86 Fetch the present character.
  $1D87,4,c2,2 Jump forward if it is a ':', which will indicate there are more statements in the present line.
N $1D8B Now a loop is entered to examine each further line in the program.
@ $1D8B label=LOOK_P_1
  $1D8B Fetch the high byte of the line number and return with carry set if there are no further lines in the program.
  $1D91 The line number is fetched and passed to NEWPPC.
  $1D98 Then the length is collected.
  $1D9C The pointer is saved whilst the address of the end of the line is formed in the #REGbc register pair.
  $1DA0 The pointer is restored.
  $1DA1 Set the statement counter to zero.
@ $1DA3 label=LOOK_P_2
  $1DA3 The end-of-line pointer is saved whilst the statements of the line are examined.
  $1DA8 Make a return if there was an 'occurrence'; otherwise consider the next line.
@ $1DAB label=NEXT
c $1DAB THE 'NEXT' COMMAND ROUTINE
D $1DAB The address of this routine is found in the #R$1A98(parameter table).
D $1DAB The 'variable in assignment' has already been determined (see #R$1C6C), and it remains to change the VALUE as required.
  $1DAB Jump to give the error report if the variable was not found.
  $1DB2 The address of the variable is fetched and the name tested further.
N $1DB9 Next the variable's VALUE (v) and STEP (s) are manipulated by the calculator.
  $1DB9 Step past the name.
  $1DBA Make the variable a temporary 'memory area'.
  $1DBD -
B $1DBE,1 #R$340F(get_mem_0): v
B $1DBF,1 #R$340F(get_mem_2): v, s
B $1DC0,1 #R$3014: v+s
B $1DC1,1 #R$342D(st_mem_0): v+s (v is replaced by v+s in mem-0)
B $1DC2,1 #R$33A1: -
B $1DC3,1 #R$369B: -
N $1DC4 The result of adding the VALUE and the STEP is now tested against the LIMIT by calling #R$1DDA.
  $1DC4 Test the new VALUE against the LIMIT.
  $1DC7 Return now if the FOR-NEXT loop has been completed.
N $1DC8 Otherwise collect the 'looping' line number and statement.
  $1DC8 Find the address of the low byte of the looping line number.
@ $1DCB keep
  $1DCF Now fetch this line number.
  $1DD3 Followed by the statement number.
  $1DD4 Exchange the numbers before jumping forward to treat them as the destination line of a GO TO command.
N $1DD8 Report 1 - NEXT without FOR.
@ $1DD8 label=REPORT_1
M $1DD8,2 Call the error handling routine.
B $1DD9,1 #R$368F
@ $1DDA label=NEXT_LOOP
c $1DDA THE 'NEXT-LOOP' SUBROUTINE
D $1DDA This subroutine is used to determine whether the LIMIT (l) has been exceeded by the present VALUE (v). Note has to be taken of the sign of the STEP (s).
D $1DDA The subroutine returns the carry flag set if the LIMIT is exceeded.
  $1DDA -
B $1DDB,1 #R$340F(get_mem_1): l
B $1DDC,1 #R$340F(get_mem_0): l, v
B $1DDD,1 #R$340F(get_mem_2): l, v, s
B $1DDE,1 #R$3506: l, v,( 1/0)
B $1DDF,2,1 #R$368F to #R$1DE2: l, v, (1/0)
B $1DE1,1 #R$343C: v, l
@ $1DE2 label=NEXT_1
B $1DE2,1 #R$300F: v-l or l-v
B $1DE3,1 #R$34F9: (1/0)
B $1DE4,2,1 #R$368F to #R$1DE9: (1/0)
B $1DE6,1 #R$369B: -
  $1DE7 Clear the carry flag and return - loop is possible.
N $1DE9 However if the loop is impossible the carry flag has to be set.
@ $1DE9 label=NEXT_2
B $1DE9,1 #R$369B: -
  $1DEA Set the carry flag and return.
@ $1DEC label=READ_3
c $1DEC THE 'READ' COMMAND ROUTINE
D $1DEC The READ command allows for the reading of a DATA list and has an effect similar to a series of LET statements.
D $1DEC Each assignment within a single READ statement is dealt with in turn. The system variable X-PTR is used as a storage location for the pointer to the READ statement whilst CH-ADD is used to step along the DATA list.
  $1DEC Come here on each pass, after the first, to move along the READ statement.
@ $1DED label=READ
N $1DED The address of this entry point is found in the #R$1AC9(parameter table).
  $1DED Consider whether the variable has been used before; find the existing entry if it has.
  $1DF0 Jump forward if checking syntax.
  $1DF5 Save the current pointer CH-ADD in X-PTR.
  $1DF9,8,4,c2,2 Fetch the current DATA list pointer and jump forward unless a new DATA statement has to be found.
  $1E01 The search is for 'DATA'.
  $1E03 Jump forward if the search is successful.
N $1E08 Report E - Out of DATA.
@ $1E08 label=REPORT_E
M $1E08,2 Call the error handling routine.
B $1E09,1
N $1E0A Continue - picking up a value from the DATA list.
@ $1E0A label=READ_1
  $1E0A Advance the pointer along the DATA list and set CH-ADD.
  $1E0D Fetch the value and assign it to the variable.
  $1E10 Fetch the current value of CH-ADD and store it in DATADD.
  $1E14 Fetch the pointer to the READ statement and clear X-PTR.
  $1E1B Make CH-ADD once again point to the READ statement.
@ $1E1E label=READ_2
  $1E1E,3,1,c2 Get the present character and see if it is a ','.
  $1E21 If it is then jump back as there are further items; otherwise return via either #R$1BEE (if checking syntax) or the RET instruction (to #R$1B76).
@ $1E27 label=DATA
c $1E27 THE 'DATA' COMMAND ROUTINE
D $1E27 The address of this routine is found in the #R$1ACC(parameter table).
D $1E27 During syntax checking a DATA statement is checked to ensure that it contains a series of valid expressions, separated by commas. But in 'run-time' the statement is passed by.
  $1E27 Jump forward unless checking syntax.
N $1E2C A loop is now entered to deal with each expression in the DATA statement.
@ $1E2C label=DATA_1
  $1E2C Scan the next expression.
  $1E2F,c2 Check for a comma separator.
  $1E31 Move on to the next statement if not matched.
  $1E34 Whilst there are still expressions to be checked go around the loop.
N $1E37 The DATA statement has to be passed by in 'run-time'.
@ $1E37 label=DATA_2
  $1E37 It is a 'DATA' statement that is to be passed by.
@ $1E39 label=PASS_BY
c $1E39 THE 'PASS-BY' SUBROUTINE
D $1E39 On entry the #REGa register will hold either the token 'DATA' or the token 'DEF FN' depending on the type of statement that is being passed by.
  $1E39 Make the #REGbc register pair hold a very high number.
  $1E3A Look back along the statement for the token.
@ $1E3C keep
  $1E3C Now look along the line for the statement after (the '#REGd-1'th statement from the current position).
@ $1E42 label=RESTORE
c $1E42 THE 'RESTORE' COMMAND ROUTINE
D $1E42 The address of this routine is found in the #R$1ACF(parameter table).
D $1E42 The operand for a RESTORE command is taken as a line number, zero being used if no operand is given.
  $1E42 Compress the operand into the #REGbc register pair.
@ $1E45 label=REST_RUN
  $1E45 Transfer the result to the #REGhl register pair.
  $1E47 Now find the address of that line or the 'first line after'.
  $1E4A Make DATADD point to the location before.
  $1E4E Return once it is done.
@ $1E4F label=RANDOMIZE
c $1E4F THE 'RANDOMIZE' COMMAND ROUTINE
D $1E4F The address of this routine is found in the #R$1AB5(parameter table).
D $1E4F The operand is compressed into the #REGbc register pair and transferred to the required system variable. However if the operand is zero the value in FRAMES1 and FRAMES2 is used instead.
  $1E4F Fetch the operand.
  $1E52 Jump forward unless the value of the operand is zero.
  $1E56 Fetch the two low order bytes of FRAMES instead.
@ $1E5A label=RAND_1
  $1E5A Now enter the result into the system variable SEED before returning.
@ $1E5F label=CONTINUE
c $1E5F THE 'CONTINUE' COMMAND ROUTINE
D $1E5F The address of this routine is found in the #R$1AB8(parameter table).
D $1E5F The required line number and statement number within that line are made the object of a jump.
  $1E5F The line number.
  $1E62 The statement number.
  $1E65 Jump forward.
@ $1E67 label=GO_TO
c $1E67 THE 'GO TO' COMMAND ROUTINE
D $1E67 The address of this routine is found in the #R$1A7D(parameter table).
D $1E67 The operand of a GO TO ought to be a line number in the range 1-9999 but the actual test is against an upper value of 61439.
  $1E67 Fetch the operand and transfer it to the #REGhl register pair.
  $1E6C Set the statement number to zero.
  $1E6E Give the error message 'Integer out of range' with line numbers over 61439.
N $1E73 This entry point is used to determine the line number of the next line to be handled in several instances.
@ $1E73 label=GO_TO_2
  $1E73 Enter the line number and then the statement number.
  $1E79 Return - to #R$1B76.
@ $1E7A label=OUT_CMD
c $1E7A THE 'OUT' COMMAND ROUTINE
D $1E7A The address of this routine is found in the #R$1AF1(parameter table).
D $1E7A The two parameters for the OUT instruction are fetched from the calculator stack and used as directed.
  $1E7A The operands are fetched.
  $1E7D The actual OUT instruction.
  $1E7F Return - to #R$1B76.
@ $1E80 label=POKE
c $1E80 THE 'POKE' COMMAND ROUTINE
D $1E80 The address of this routine is found in the #R$1AB1(parameter table).
D $1E80 In a similar manner to #R$1E7A(OUT), the POKE operation is performed.
  $1E80 The operands are fetched.
  $1E83 The actual POKE operation.
  $1E84 Return - to #R$1B76.
@ $1E85 label=TWO_PARAM
c $1E85 THE 'TWO-PARAM' SUBROUTINE
D $1E85 The topmost parameter on the calculator stack must be compressible into a single register. It is two's complemented if it is negative. The second parameter must be compressible into a register pair.
  $1E85 The parameter is fetched.
  $1E88 Give an error if it is too high a number.
  $1E8A Jump forward with positive numbers but two's complement negative numbers.
@ $1E8E label=TWO_P_1
  $1E8E Save the first parameter whilst the second is fetched.
  $1E92 The first parameter is restored before returning.
@ $1E94 label=FIND_INT1
c $1E94 THE 'FIND INTEGERS' SUBROUTINE
D $1E94 The 'last value' on the calculator stack is fetched and compressed into a single register or a register pair by entering at #R$1E94 and #R$1E99 respectively.
  $1E94 Fetch the 'last value'.
  $1E97 Jump forward.
@ $1E99 label=FIND_INT2
  $1E99 Fetch the 'last value'.
@ $1E9C label=FIND_I_1
  $1E9C In both cases overflow is indicated by a set carry flag.
  $1E9E Return with all positive numbers that are in range.
N $1E9F Report B - Integer out of range.
@ $1E9F label=REPORT_B_2
M $1E9F,2 Call the error handling routine.
B $1EA0,1
@ $1EA1 label=RUN
c $1EA1 THE 'RUN' COMMAND ROUTINE
D $1EA1 The address of this routine is found in the #R$1AAB(parameter table).
D $1EA1 The parameter of the RUN command is passed to NEWPPC by calling #R$1E67. The operations of 'RESTORE 0' and 'CLEAR 0' are then performed before a return is made.
  $1EA1 Set NEWPPC as required.
@ $1EA4 keep
  $1EA4 Now perform a 'RESTORE 0'.
  $1EAA Exit via the #R$1EAC command routine.
@ $1EAC label=CLEAR
c $1EAC THE 'CLEAR' COMMAND ROUTINE
D $1EAC The address of this routine is found in the #R$1ABB(parameter table).
D $1EAC This routine allows for the variables area to be cleared, the display area cleared and RAMTOP moved. In consequence of the last operation the machine stack is rebuilt thereby having the effect of also clearing the GO SUB stack.
  $1EAC Fetch the operand - using zero by default.
@ $1EAF label=CLEAR_RUN
  $1EAF Jump forward if the operand is other than zero. When called from #R$1EA1 there is no jump.
  $1EB3 If zero use the existing value in RAMTOP.
@ $1EB7 label=CLEAR_1
  $1EB7 Save the value.
  $1EB8 Next reclaim all the bytes of the present variables area.
  $1EC3 Clear the display area.
N $1EC6 The value in the #REGbc register pair which will be used as RAMTOP is tested to ensure it is neither too low nor too high.
  $1EC6 The current value of STKEND is increased by 50 before being tested. This forms the lower limit.
@ $1EC9 keep
  $1ED0 RAMTOP will be too low.
  $1ED2 For the upper test the value for RAMTOP is tested against P-RAMT.
  $1ED8 Jump forward if acceptable.
N $1EDA Report M - RAMTOP no good.
@ $1EDA label=REPORT_M
M $1EDA,2 Call the error handling routine.
B $1EDB,1
N $1EDC Continue with the CLEAR operation.
@ $1EDC label=CLEAR_2
  $1EDC Now the value can actually be passed to RAMTOP.
  $1EE0 Fetch the address of #R$1B76.
  $1EE1 Fetch the 'error address'.
  $1EE2 Enter a GO SUB stack end marker.
  $1EE4 Leave one location.
  $1EE5 Make the stack pointer point to an empty GO SUB stack.
  $1EE6 Next pass the 'error address' to the stack and save its address in ERR-SP.
  $1EEB An indirect return is now made to #R$1B76.
E $1EAC Note: when the routine is called from #R$1EA1 the values of NEWPPC and NSPPC will have been affected and no statements coming after RUN can ever be found before the jump is taken.
@ $1EED label=GO_SUB
c $1EED THE 'GO SUB' COMMAND ROUTINE
D $1EED The address of this routine is found in the #R$1A86(parameter table).
D $1EED The present value of PPC and the incremented value of SUBPPC are stored on the GO SUB stack.
  $1EED Save the address - #R$1B76.
  $1EEE Fetch the statement number and increment it.
  $1EF2 Exchange the 'error address' with the statement number.
  $1EF3 Reclaim the use of a location.
  $1EF4 Next save the present line number.
  $1EF9 Return the 'error address' to the machine stack and reset ERR-SP to point to it.
  $1EFE Return the address #R$1B76.
  $1EFF Now set NEWPPC and NSPPC to the required values.
@ $1F02 keep
  $1F02 But before making the jump make a test for room.
@ $1F05 label=TEST_ROOM
c $1F05 THE 'TEST-ROOM' SUBROUTINE
D $1F05 A series of tests is performed to ensure that there is sufficient free memory available for the task being undertaken.
  $1F05 Increase the value taken from STKEND by the value carried into the routine by the #REGbc register pair.
  $1F09 Jump forward if the result is over +FFFF.
  $1F0B Try it again allowing for a further eighty bytes.
@ $1F0C keep
  $1F12 Finally test the value against the address of the machine stack.
  $1F14 Return if satisfactory.
N $1F15 Report 4 - Out of memory.
@ $1F15 label=REPORT_4
  $1F15 This is a 'run-time' error and the error marker is not to be used.
@ $1F1A label=FREE_MEM
c $1F1A THE 'FREE MEMORY' SUBROUTINE
D $1F1A There is no BASIC command 'FRE' in the Spectrum but there is a subroutine for performing such a task.
D $1F1A An estimate of the amount of free space can be found at any time by using 'PRINT 65536-USR 7962'.
@ $1F1A keep
  $1F1A Do not allow any overhead.
  $1F1D Make the test and pass the result to the #REGbc register before returning.
@ $1F23 label=RETURN
c $1F23 THE 'RETURN' COMMAND ROUTINE
D $1F23 The address of this routine is found in the #R$1A8D(parameter table).
D $1F23 The line number and the statement number that are to be made the object of a 'return' are fetched from the GO SUB stack.
  $1F23 Fetch the address - #R$1B76.
  $1F24 Fetch the 'error address'.
  $1F25 Fetch the last entry on the GO SUB stack.
  $1F26 The entry is tested to see if it is the GO SUB stack end marker.
  $1F29 Jump if it is.
  $1F2B The full entry uses three locations only.
  $1F2C Exchange the statement number with the 'error address'.
  $1F2D Move the statement number.
  $1F2E Reset the error pointer.
  $1F32 Replace the address #R$1B76.
  $1F33 Jump back to change NEWPPC and NSPPC.
N $1F36 Report 7 - RETURN without GOSUB.
@ $1F36 label=REPORT_7
  $1F36,2 Replace the end marker and the 'error address'.
M $1F38,2 Call the error handling routine.
B $1F39,1
@ $1F3A label=PAUSE
c $1F3A THE 'PAUSE' COMMAND ROUTINE
D $1F3A The address of this routine is found in the #R$1AC5(parameter table).
D $1F3A The period of the pause is determined by counting the number of maskable interrupts as they occur every 1/50th of a second.
D $1F3A A pause is finished either after the appropriate number of interrupts or by the system variable FLAGS indicating that a key has been pressed.
  $1F3A Fetch the operand.
@ $1F3D label=PAUSE_1
  $1F3D Wait for a maskable interrupt.
  $1F3E Decrease the counter.
  $1F3F If the counter is thereby reduced to zero the pause has come to an end.
  $1F43 If the operand was zero #REGbc will now hold +FFFF and this value will be returned to zero. Jump with all other operand values.
@ $1F49 label=PAUSE_2
  $1F49 Jump back unless a key has been pressed.
N $1F4F The period of the pause has now finished.
@ $1F4F label=PAUSE_END
  $1F4F Signal 'no key pressed'.
  $1F53 Now return - to #R$1B76.
@ $1F54 label=BREAK_KEY
c $1F54 THE 'BREAK-KEY' SUBROUTINE
D $1F54 This subroutine is called in several instances to read the BREAK key. The carry flag is returned reset only if the SHIFT and the BREAK keys are both being pressed.
  $1F54 Form the port address +7FFE and read in a byte.
  $1F58 Examine only bit 0 by shifting it into the carry position.
  $1F59 Return if the BREAK key is not being pressed.
  $1F5A Form the port address +FEFE and read in a byte.
  $1F5E Again examine bit 0.
  $1F5F Return with carry reset if both keys are being pressed.
@ $1F60 label=DEF_FN
c $1F60 THE 'DEF FN' COMMAND ROUTINE
D $1F60 The address of this routine is found in the #R$1AF9(parameter table).
D $1F60 During syntax checking a DEF FN statement is checked to ensure that it has the correct form. Space is also made available for the result of evaluating the function.
D $1F60 But in 'run-time' a DEF FN statement is passed by.
  $1F60 Jump forward if checking syntax.
  $1F65 Otherwise pass by the 'DEF FN' statement.
N $1F6A First consider the variable of the function.
@ $1F6A label=DEF_FN_1
  $1F6A Signal 'a numeric variable'.
  $1F6E Check that the present code is a letter.
  $1F71 Jump forward if not.
  $1F73 Fetch the next character.
  $1F74,4,c2,2 Jump forward unless it is a '$'.
  $1F78 Change bit 6 as it is a string variable.
  $1F7C Fetch the next character.
@ $1F7D label=DEF_FN_2
  $1F7D,4,c2,2 A '(' must follow the variable's name.
  $1F81 Fetch the next character.
  $1F82,4,c2,2 Jump forward if it is a ')' as there are no parameters of the function.
N $1F86 A loop is now entered to deal with each parameter in turn.
@ $1F86 label=DEF_FN_3
  $1F86 The present code must be a letter.
@ $1F89 label=DEF_FN_4
  $1F8C Save the pointer in #REGde.
  $1F8D Fetch the next character.
  $1F8E,4,c2,2 Jump forward unless it is a '$'.
  $1F92 Otherwise save the new pointer in #REGde instead.
  $1F93 Fetch the next character.
@ $1F94 label=DEF_FN_5
  $1F94 Move the pointer to the last character of the name to the #REGhl register pair.
@ $1F95 keep
  $1F95 Now make six locations after that last character and enter a 'number marker' into the first of the new locations.
  $1F9F,7,c2,5 If the present character is a ',' then jump back as there should be a further parameter; otherwise jump out of the loop.
N $1FA6 Next the definition of the function is considered.
@ $1FA6 label=DEF_FN_6
  $1FA6,4,c2,2 Check that the ')' does exist.
  $1FAA The next character is fetched.
  $1FAB,4,c2,2 It must be an '='.
  $1FAF Fetch the next character.
  $1FB0 Save the nature - numeric or string - of the variable.
  $1FB4 Now consider the definition as an expression.
  $1FB7 Fetch the nature of the variable and check that it is of the same type as found for the definition.
@ $1FBD label=DEF_FN_7
  $1FBD Give an error report if it is required.
  $1FC0 Exit via #R$1BEE (thereby moving on to consider the next statement in the line).
@ $1FC3 label=UNSTACK_Z
c $1FC3 THE 'UNSTACK-Z' SUBROUTINE
D $1FC3 This subroutine is called in several instances in order to 'return early' from a subroutine when checking syntax. The reason for this is to avoid actually printing characters or passing values to/from the calculator stack.
  $1FC3 Is syntax being checked?
  $1FC6 Fetch the return address but ignore it in 'syntax-time'.
  $1FC8 In 'run-time' make a simple return to the calling routine.
@ $1FC9 label=LPRINT
c $1FC9 THE 'LPRINT and PRINT' COMMAND ROUTINES
D $1FC9 The address of this routine is found in the #R$1AD9(parameter table).
D $1FC9 The appropriate channel is opened as necessary and the items to be printed are considered in turn.
  $1FC9 Prepare to open channel 'P'.
  $1FCB Jump forward.
@ $1FCD label=PRINT
N $1FCD The address of this entry point is found in the #R$1A9C(parameter table).
  $1FCD Prepare to open channel 'S'.
@ $1FCF label=PRINT_1
  $1FCF Unless syntax is being checked open a channel.
  $1FD5 Set the temporary colour system variables.
  $1FD8 Call the print controlling subroutine.
  $1FDB Move on to consider the next statement (via #R$1BEE if checking syntax).
@ $1FDF label=PRINT_2
c $1FDF THE 'PRINT CONTROLLING' SUBROUTINE
D $1FDF This subroutine is called by the #R$1FCD, #R$1FC9 and #R$2089 command routines.
  $1FDF Get the first character.
  $1FE0 Jump forward if already at the end of the item list.
N $1FE5 Now enter a loop to deal with the 'position controllers' and the print items.
@ $1FE5 label=PRINT_3
  $1FE5 Deal with any consecutive position controllers.
  $1FEA Deal with a single print item.
  $1FED Check for further position controllers and print items until there are none left.
@ $1FF2 label=PRINT_4
  $1FF2,3,c2,1 Return now if the present character is a ')'; otherwise consider performing a 'carriage return'.
@ $1FF5 label=PRINT_CR
c $1FF5 THE 'PRINT A CARRIAGE RETURN' SUBROUTINE
  $1FF5 Return if checking syntax.
  $1FF8 Print a carriage return character and then return.
@ $1FFC label=PR_ITEM_1
c $1FFC THE 'PRINT ITEMS' SUBROUTINE
D $1FFC This subroutine is called from the #R$1FCD, #R$1FC9 and #R$2089 command routines.
D $1FFC The various types of print item are identified and printed.
  $1FFC The first character is fetched.
  $1FFD Jump forward unless it is an 'AT'.
N $2001 Now deal with an 'AT'.
  $2001 The two parameters are transferred to the calculator stack.
  $2004 Return now if checking syntax.
  $2007 The parameters are compressed into the #REGbc register pair.
  $200A The #REGa register is loaded with the AT control character before the jump is taken.
N $200E Next look for a 'TAB'.
@ $200E label=PR_ITEM_2
  $200E Jump forward unless it is a 'TAB'.
N $2012 Now deal with a 'TAB'.
  $2012 Get the next character.
  $2013 Transfer one parameter to the calculator stack.
  $2016 Return now if checking syntax.
  $2019 The value is compressed into the #REGbc register pair.
  $201C The #REGa register is loaded with the TAB control character.
N $201E The 'AT' and the 'TAB' print items are printed by making three calls to #R$0010.
@ $201E label=PR_AT_TAB
  $201E Print the control character.
  $201F Follow it with the first value.
  $2021 Finally print the second value, then return.
N $2024 Next consider embedded colour items.
@ $2024 label=PR_ITEM_3
  $2024 Return with carry reset if colour items were found. Continue if none were found.
  $2028 Next consider if the stream is to be changed.
  $202B Continue unless it was altered.
N $202C The print item must now be an expression, either numeric or string.
  $202C Evaluate the expression but return now if checking syntax.
  $2032 Test for the nature of the expression.
  $2036 If it is a string then fetch the necessary parameters; but if it is numeric then exit via #R$2DE3.
N $203C A loop is now set up to deal with each character in turn of the string.
@ $203C label=PR_STRING
  $203C Return now if there are no characters remaining in the string; otherwise decrease the counter.
  $2040 Fetch the code and increment the pointer.
  $2042 The code is printed and a jump taken to consider any further characters.
@ $2045 label=PR_END_Z
c $2045 THE 'END OF PRINTING' SUBROUTINE
D $2045 The zero flag will be set if no further printing is to be done.
  $2045,3,c2,1 Return now if the character is a ')'.
@ $2048 label=PR_ST_END
  $2048 Return now if the character is a 'carriage return'.
  $204B,3,c2,1 Make a final test against ':' before returning.
@ $204E label=PR_POSN_1
c $204E THE 'PRINT POSITION' SUBROUTINE
D $204E The various position controlling characters are considered by this subroutine.
  $204E Get the present character.
  $204F,4,c2,2 Jump forward if it is a ';'.
  $2053,9,c2,7 Also jump forward with a character other than a ',', but do not actually print the character if checking syntax.
  $205C Load the #REGa register with the 'comma' control code and print it, then jump forward.
@ $2061 label=PR_POSN_2
  $2061,c2 Is it a '''?
  $2063 Return now (with the zero flag reset) if not any of the position controllers.
  $2064 Print 'carriage return' unless checking syntax.
@ $2067 label=PR_POSN_3
  $2067 Fetch the next character.
  $2068 If not at the end of a print statement then jump forward.
  $206D Otherwise drop the return address from the stack.
@ $206E label=PR_POSN_4
  $206E Set the zero flag and return.
@ $2070 label=STR_ALTER
c $2070 THE 'ALTER STREAM' SUBROUTINE
D $2070 This subroutine is called whenever there is the need to consider whether the user wishes to use a different stream.
  $2070,4,c2,2 Unless the present character is a '#' return with the carry flag set.
  $2074 Advance CH-ADD.
  $2075 Pass the parameter to the calculator stack.
  $2078 Clear the carry flag.
  $2079 Return now if checking syntax.
  $207C The value is passed to the #REGa register.
  $207F Give report O if the value is over +0F.
  $2084 Use the channel for the stream in question.
  $2087 Clear the carry flag and return.
@ $2089 label=INPUT
c $2089 THE 'INPUT' COMMAND ROUTINE
D $2089 The address of this routine is found in the #R$1A9F(parameter table).
D $2089 This routine allows for values entered from the keyboard to be assigned to variables. It is also possible to have print items embedded in the INPUT statement and these items are printed in the lower part of the display.
  $2089 Jump forward if syntax is being checked.
  $208E Open channel 'K'.
  $2093 The lower part of the display is cleared.
@ $2096 label=INPUT_1
  $2096 Signal that the lower screen is being handled. Reset all other bits.
  $209A Call the subroutine to deal with the INPUT items.
  $209D Move on to the next statement if checking syntax.
  $20A0 Fetch the current print position.
  $20A4 Jump forward if the current position is above the lower screen.
  $20AA Otherwise set the print position to the top of the lower screen.
@ $20AD label=INPUT_2
  $20AD Reset S-POSN.
  $20B1 Now set the scroll counter.
  $20B7 Signal 'main screen'.
  $20BB Set the system variables and exit via #R$0D6E.
N $20C1 The INPUT items and embedded PRINT items are dealt with in turn by the following loop.
@ $20C1 label=IN_ITEM_1
  $20C1 Consider first any position control characters.
  $20C6,4,c2,2 Jump forward if the present character is not a '('.
  $20CA Fetch the next character.
  $20CB Now call the PRINT command routine to handle the items inside the brackets.
  $20CE Fetch the present character.
  $20CF,5,c2,3 Give report C unless the character is a ')'.
  $20D4 Fetch the next character and jump forward to see if there are any further INPUT items.
N $20D8 Now consider whether INPUT LINE is being used.
@ $20D8 label=IN_ITEM_2
  $20D8 Jump forward if it is not 'LINE'.
  $20DC Advance CH-ADD.
  $20DD Determine the destination address for the variable.
  $20E0 Signal 'using INPUT LINE'.
  $20E4 Give report C unless using a string variable.
  $20EB Jump forward to issue the prompt message.
N $20ED Proceed to handle simple INPUT variables.
@ $20ED label=IN_ITEM_3
  $20ED Jump to consider going round the loop again if the present character is not a letter.
  $20F3 Determine the destination address for the variable.
  $20F6 Signal 'not INPUT LINE'.
N $20FA The prompt message is now built up in the work space.
@ $20FA label=IN_PROMPT
  $20FA Jump forward if only checking syntax.
  $2100 The work space is set to null.
  $2103 This is FLAGX.
  $2106 Signal 'string result'.
  $2108 Signal 'INPUT mode'.
@ $210A keep
  $210A Allow the prompt message only a single location.
  $210D Jump forward if using 'LINE'.
  $2111 Jump forward if awaiting a numeric entry.
  $2118 A string entry will need three locations.
@ $211A label=IN_PR_1
  $211A Bit 6 of FLAGX will become set for a numeric entry.
@ $211C label=IN_PR_2
  $211C The required number of locations is made available.
  $211D A 'carriage return' goes into the last location.
  $211F Test bit 6 of the #REGc register and jump forward if only one location was required.
  $2124,5,c2,3 A 'double quotes' character goes into the first and second locations.
@ $2129 label=IN_PR_3
  $2129 The position of the cursor can now be saved.
N $212C In the case of INPUT LINE the EDITOR can be called without further preparation but for other types of INPUT the error stack has to be changed so as to trap errors.
  $212C Jump forward with 'INPUT LINE'.
  $2132 Save the current values of CH-ADD and ERR-SP on the machine stack.
@ $213A nowarn
@ $213A label=IN_VAR_1
  $213A This will be the 'return point' in case of errors.
  $213E Only change the error stack pointer if using channel 'K'.
@ $2148 label=IN_VAR_2
  $2148 Set #REGhl to the start of the INPUT line and remove any floating-point forms. (There will not be any except perhaps after an error.)
  $214E Signal 'no error yet'.
  $2152 Now get the INPUT and with the syntax/run flag indicating syntax, check the INPUT for errors; jump if in order; return to IN-VAR-1 if not.
@ $215E label=IN_VAR_3
  $215E Get a 'LINE'.
N $2161 All the system variables have to be reset before the actual assignment of a value can be made.
@ $2161 label=IN_VAR_4
  $2161 The cursor address is reset.
  $2165 The jump is taken if using other than channel 'K'.
  $216A The input-line is copied to the display and the position in ECHO-E made the current position in the lower screen.
@ $2174 label=IN_VAR_5
  $2174 This is FLAGX.
  $2177 Signal 'edit mode'.
  $2179 Jump forward if handling an INPUT LINE.
  $217F Drop the address IN-VAR-1.
  $2180 Reset the ERR-SP to its original address.
  $2184 Save the original CH-ADD address in X-PTR.
  $2188 Now with the syntax/run flag indicating 'run' make the assignment.
  $218F Restore the original address to CH-ADD and clear X-PTR.
  $2199 Jump forward to see if there are further INPUT items.
@ $219B label=IN_VAR_6
  $219B The length of the 'LINE' in the work space is found.
  $21A5 #REGde points to the start and #REGbc holds the length.
  $21A7 These parameters are stacked and the actual assignment made.
  $21AD Also jump forward to consider further items.
N $21AF Further items in the INPUT statement are considered.
@ $21AF label=IN_NEXT_1
  $21AF Handle any print items.
@ $21B2 label=IN_NEXT_2
  $21B2 Handle any position controllers.
  $21B5 Go around the loop again if there are further items; otherwise return.
@ $21B9 label=IN_ASSIGN
c $21B9 THE 'IN-ASSIGN' SUBROUTINE
D $21B9 This subroutine is called twice for each INPUT value: once with the syntax/run flag reset (syntax) and once with it set (run).
  $21B9 Set CH-ADD to point to the first location of the work space and fetch the character.
  $21C0 Is it a 'STOP'?
  $21C2 Jump if it is.
  $21C4 Otherwise make the assignment of the 'value' to the variable.
  $21CA Get the present character and check it is a 'carriage return'.
  $21CD Return if it is.
N $21CE Report C - Nonsense in BASIC.
@ $21CE label=REPORT_C_2
M $21CE,2 Call the error handling routine.
B $21CF,1
N $21D0 Come here if the INPUT line starts with 'STOP'.
@ $21D0 label=IN_STOP
  $21D0 But do not give the error report on the syntax-pass.
N $21D4 Report H - STOP in INPUT.
@ $21D4 label=REPORT_H
M $21D4,2 Call the error handling routine.
B $21D5,1
@ $21D6 label=IN_CHAN_K
c $21D6 THE 'IN-CHAN-K' SUBROUTINE
D $21D6 This subroutine returns with the zero flag reset only if channel 'K' is being used.
  $21D6,10,8,c2 The base address of the channel information for the current channel is fetched and the channel code compared to the character 'K'.
  $21E0 Return afterwards.
@ $21E1 label=CO_TEMP_1
c $21E1 THE 'COLOUR ITEM' ROUTINES
D $21E1 This set of routines can be readily divided into two parts:
D $21E1 #LIST { i. The embedded colour item' handler. } { ii. The 'colour system variable' handler. } LIST#
D $21E1 i. Embedded colour items are handled by calling #R$0010 as required.
D $21E1 A loop is entered to handle each item in turn. The entry point is at #R$21E2.
  $21E1 Consider the next character in the BASIC statement.
@ $21E2 label=CO_TEMP_2
  $21E2 Jump forward to see if the present code represents an embedded 'temporary' colour item. Return carry set if not a colour item.
  $21E6 Fetch the present character.
  $21E7,8,c2,2,c2,2 Jump back if it is either a ',' or a ';'; otherwise there has been an error.
  $21EF Exit via 'report C'.
@ $21F2 label=CO_TEMP_3
  $21F2 Return with the carry flag set if the code is not in the range +D9 to +DE (INK to OVER).
  $21F9 The colour item code is preserved whilst CH-ADD is advanced to address the parameter that follows it.
N $21FC The colour item code and the parameter are now 'printed' by calling #R$0010 on two occasions.
@ $21FC label=CO_TEMP_4
  $21FC The token range (+D9 to +DE) is reduced to the control character range (+10 to +15).
  $21FE The control character code is preserved whilst the parameter is moved to the calculator stack.
  $2203 A return is made at this point if syntax is being checked.
  $2207 The control character code is preserved whilst the parameter is moved to the #REGd register.
  $220D The control character is sent out.
  $220E Then the parameter is fetched and sent out before returning.
N $2211 ii. The colour system variables - ATTR-T, MASK-T and P-FLAG - are altered as required. On entry the control character code is in the #REGa register and the parameter is in the #REGd register.
@ $2211 label=CO_TEMP_5
N $2211 Note that all changes are to the 'temporary' system variables.
  $2211 Reduce the range and jump forward with INK and PAPER.
  $2217 Reduce the range once again and jump forward with FLASH and BRIGHT.
N $221D The colour control code will now be +01 for INVERSE and +02 for OVER and the system variable P-FLAG is altered accordingly.
  $221D Prepare to jump with OVER.
  $221F Fetch the parameter.
  $2220 Prepare the mask for OVER.
  $2222 Now jump.
  $2224 Bit 2 of the #REGa register is to be reset for INVERSE 0 and set for INVERSE 1; the mask is to have bit 2 set.
@ $2228 label=CO_TEMP_6
  $2228 Save the #REGa register whilst the range is tested.
  $2229 The correct range for INVERSE and OVER is only '0-1'.
  $222E Restore the #REGa register.
  $222F It is P-FLAG that is to be changed.
  $2232 Exit via #R$226C and alter P-FLAG using #REGb as a mask, i.e. bit 0 for OVER and bit 2 for INVERSE.
N $2234 PAPER and INK are dealt with by the following routine. On entry the carry flag is set for INK.
@ $2234 label=CO_TEMP_7
  $2234 Fetch the parameter.
  $2235 Prepare the mask for INK.
  $2237 Jump forward with INK.
  $2239 Multiply the parameter for PAPER by eight.
  $223C Prepare the mask for PAPER.
@ $223E label=CO_TEMP_8
  $223E Save the parameter in the #REGc register whilst the range of the parameter is tested.
  $223F Fetch the original value.
  $2240 Only allow PAPER/INK a range of '0' to '9'.
N $2244 Report K - Invalid colour.
@ $2244 label=REPORT_K
M $2244,2 Call the error handling routine.
B $2245,1
N $2246 Continue to handle PAPER and INK.
@ $2246 label=CO_TEMP_9
  $2246 Prepare to alter ATTR-T, MASK-T and P-FLAG.
  $2249 Jump forward with PAPER/INK '0' to '7'.
  $224D Fetch the current value of ATTR-T and use it unchanged, by jumping forward, with PAPER/INK '8'.
  $2250 But for PAPER/INK '9' the PAPER and INK colours have to be black and white.
  $2254 Jump for black INK/PAPER, but continue for white INK/PAPER.
@ $2257 label=CO_TEMP_A
  $2257 Move the value to the #REGc register.
N $2258 The mask (#REGb) and the value (#REGc) are now used to change ATTR-T.
@ $2258 label=CO_TEMP_B
  $2258 Move the value.
  $2259 Now change ATTR-T as needed.
N $225C Next MASK-T is considered.
  $225C The bits of MASK-T are set only when using PAPER/INK '8' or '9'.
  $2260 Now change MASK-T as needed.
N $2263 Next P-FLAG is considered.
  $2263 The appropriate mask is built up in the #REGb register in order to change bits 4 and 6 as necessary.
  $2268 The bits of P-FLAG are set only when using PAPER/INK '9'. Continue into #R$226C to manipulate P-FLAG.
@ $226C label=CO_CHANGE
N $226C The following subroutine is used to 'impress' upon a system variable the 'nature' of the bits in the #REGa register. The #REGb register holds a mask that shows which bits are to be 'copied over' from #REGa to (#REGhl).
  $226C The bits, specified by the mask in the #REGb register, are changed in the value and the result goes to form the system variable.
  $2270 Move on to address the next system variable.
  $2271 Return with the mask in the #REGa register.
N $2273 FLASH and BRIGHT are handled by the following routine.
  $2273 The zero flag will be set for BRIGHT.
  $2274 The parameter is fetched and rotated.
  $2276 Prepare the mask for FLASH.
  $2278 Jump forward with FLASH.
  $227A Rotate an extra time and prepare the mask for BRIGHT.
@ $227D label=CO_TEMP_D
  $227D Save the value in the #REGc register.
  $227E Fetch the parameter and test its range; only '0', '1' and '8' are allowable.
N $2287 The system variable ATTR-T can now be altered.
@ $2287 label=CO_TEMP_E
  $2287 Fetch the value.
  $2288 This is ATTR-T.
  $228B Now change the system variable.
N $228E The value in MASK-T is now considered.
  $228E The value is fetched anew.
  $228F The set bit of FLASH/BRIGHT '8' (bit 3) is moved to bit 7 (for FLASH) or bit 6 (for BRIGHT).
  $2292 Exit via #R$226C.
@ $2294 label=BORDER
c $2294 THE 'BORDER' COMMAND ROUTINE
D $2294 The address of this routine is found in the #R$1AF5(parameter table).
D $2294 The parameter of the BORDER command is used with an OUT command to actually alter the colour of the border. The parameter is then saved in the system variable BORDCR.
  $2294 The parameter is fetched and its range is tested.
  $229B The OUT instruction is then used to set the border colour.
  $229D The parameter is then multiplied by eight.
  $22A0 Is the border colour a 'light' colour?
  $22A2 Jump if so (the INK colour will be black).
  $22A4 Change the INK colour to white.
@ $22A6 label=BORDER_1
  $22A6 Set the system variable as required and return.
@ $22AA label=PIXEL_ADD
c $22AA THE 'PIXEL ADDRESS' SUBROUTINE
D $22AA This subroutine is called by #R$22CB and by #R$22DC. Is is entered with the co-ordinates of a pixel in the #REGbc register pair and returns with #REGhl holding the address of the display file byte which contains that pixel and #REGa pointing to the position of the pixel within the byte.
  $22AA Test that the y co-ordinate (in #REGb) is not greater than 175.
  $22B0 #REGb now contains 175 minus y.
  $22B1 #REGa holds b7b6b5b4b3b2b1b0, the bits of #REGb.
  $22B2 And now 0b7b6b5b4b3b2b1.
  $22B3 Now 10b7b6b5b4b3b2.
  $22B5 Now 010b7b6b5b4b3.
  $22B7,5,1,b2,2 Finally 010b7b6b2b1b0, so that #REGh becomes 64+8*INT(#REGb/64)+(#REGb mod 8), the high byte of the pixel address.
  $22BC #REGc contains x.
  $22BD #REGa starts as c7c6c5c4c3c2c1c0 and becomes c4c3c2c1c0c7c6c5.
  $22C0,4,1,b2,1 Now c4c3b5b4b3c7c6c5.
  $22C4 Finally b5b4b3c7c6c5c4c3, so that #REGl becomes 32*INT((#REGb mod 64)/8)+INT(x/8), the low byte.
  $22C7,3 #REGa holds x mod 8, so the pixel is bit (#REGa-7) within the byte.
@ $22CB label=POINT_SUB
c $22CB THE 'POINT' SUBROUTINE
D $22CB This subroutine is called from #R$267B. It is entered with the coordinates of a pixel on the calculator stack, and returns a last value of 1 if that pixel is ink colour, and 0 if it is paper colour.
  $22CB y-coordinate to #REGb, x to #REGc.
  $22CE Pixel address to #REGhl.
  $22D1 #REGb will count #REGa+1 loops to get the wanted bit of (#REGhl) to location 0.
@ $22D4 label=POINT_LP
  $22D4 The shifts.
  $22D7 The bit is 1 for ink, 0 for paper.
  $22D9 It is put on the calculator stack.
@ $22DC label=PLOT
c $22DC THE 'PLOT' COMMAND ROUTINE
D $22DC The address of this routine is found in the #R$1AC1(parameter table).
D $22DC This routine consists of a main subroutine plus one line to call it and one line to exit from it. The main routine is used twice by #R$2320 and the subroutine is called by #R$24B7. The routine is entered with the coordinates of a pixel on the calculator stack. It finds the address of that pixel and plots it, taking account of the status of INVERSE and OVER held in the P-FLAG.
  $22DC y-coordinate to #REGb, x to #REGc.
  $22DF The subroutine is called.
  $22E2 Exit, setting temporary colours.
@ $22E5 label=PLOT_SUB
  $22E5 The system variable is set.
  $22E9 Pixel address to #REGhl.
  $22EC #REGb will count #REGa+1 loops to get a zero to the correct place in #REGa.
  $22EE The zero is entered.
@ $22F0 label=PLOT_LOOP
  $22F0 Then lined up with the pixel bit position in the byte.
  $22F3 Then copied to #REGb.
  $22F4 The pixel-byte is obtained in #REGa.
  $22F5 P-FLAG is obtained and first tested for OVER.
  $22FA Jump if OVER 1.
  $22FC OVER 0 first makes the pixel zero.
@ $22FD label=PL_TST_IN
  $22FD Test for INVERSE.
  $22FF INVERSE 1 just leaves the pixel as it was (OVER 1) or zero (OVER 0).
  $2301 INVERSE 0 leaves the pixel complemented (OVER 1) or 1 (OVER 0).
@ $2303 label=PLOT_END
  $2303 The byte is entered. Its other bits are unchanged in every case.
  $2304 Exit, setting attribute byte.
@ $2307 label=STK_TO_BC
c $2307 THE 'STK-TO-BC' SUBROUTINE
D $2307 This subroutine loads two floating point numbers into the #REGbc register pair. It is thus used to pick up parameters in the range +00 to +FF. It also obtains in #REGde the 'diagonal move' values (+/-1,+/-1) which are used in #R$24B7.
  $2307 First number to #REGa.
  $230A Hence to #REGb.
  $230B Save it briefly.
  $230C Second number to #REGa.
  $230F Its sign indicator to #REGe.
  $2310 Restore first number.
  $2311 Its signs indicator to #REGd.
  $2312 Second number to #REGc.
  $2313 #REGbc, #REGde are now as required.
@ $2314 label=STK_TO_A
c $2314 THE 'STK-TO-A' SUBROUTINE
D $2314 This subroutine loads the #REGa register with the floating point number held at the top of the calculator stack. The number must be in the range 00-FF.
  $2314 Modulus of rounded last value to #REGa if possible; else, report error.
  $231A One to #REGc for positive last value.
  $231C Return if value was positive.
  $231D Else change #REGc to +FF (i.e. minus one).
  $231F Finished.
@ $2320 label=CIRCLE
c $2320 THE 'CIRCLE' COMMAND ROUTINE
D $2320 The address of this routine is found in the #R$1AE7(parameter table).
D $2320 This routine draws an approximation to the circle with centre co-ordinates X and Y and radius Z. These numbers are rounded to the nearest integer before use. Thus Z must be less than 87.5, even when (X,Y) is in the centre of the screen. The method used is to draw a series of arcs approximated by straight lines.
D $2320 CIRCLE has four parts:
D $2320 #LIST { i. Tests the radius. If its modulus is less than 1, just plot X,Y. } { ii. Calls #R$247D, which is used to set the initial parameters for both CIRCLE and DRAW. } { iii. Sets up the remaining parameters for CIRCLE, including the initial displacement for the first 'arc' (a straight line in fact). } { iv. Jumps to #R$2420 to use the arc-drawing loop. } LIST#
D $2320 Parts i. to iii. will now be explained in turn.
D $2320 i. The radius, say Z', is obtained from the calculator stack. Its modulus Z is formed and used from now on. If Z is less than 1, it is deleted from the stack and the point X,Y is plotted by a jump to PLOT.
  $2320 Get the present character.
  $2321,c2 Test for comma.
  $2323 If not so, report the error.
  $2326 Get next character (the radius).
  $2327 Radius to calculator stack.
  $232A Move to consider next statement if checking syntax.
  $232D Use calculator.
B $232E,1 #R$346A: X, Y, Z
B $232F,1 #R$3297: Z is re-stacked; its exponent is therefore available.
B $2330,1 #R$369B
  $2331 Get exponent of radius.
  $2332 Test whether radius less than 1.
  $2334 If not, jump.
  $2336 If less, delete it from the stack.
B $2337,1 #R$33A1: X, Y
B $2338,1 #R$369B
  $2339 Just plot the point X, Y.
N $233B ii. 2#pi is stored in mem-5 and #R$247D is called. This subroutine stores in the #REGb register the number of arcs required for the circle, viz. A=4*INT (#pi*SQR Z/4)+4, hence 4, 8, 12, etc., up to a maximum of 32. It also stores in mem-0 to mem-4 the quantities 2#pi/A, SIN(#pi/A), 0, COS (2#pi/A) and SIN (2#pi/A).
@ $233B label=C_R_GRE_1
B $233C,1 #R$341B(stk_pi_2): X, Y, Z, #pi/2
B $233D,1 #R$369B
  $233E Now increase exponent to 83 hex, changing #pi/2 into 2#pi.
  $2340 X, Y, Z, 2#pi.
B $2341,1 #R$342D(st_mem_5): (2#pi is copied to mem-5)
B $2342,1 #R$33A1: X, Y, Z
B $2343,1 #R$369B
  $2344 Set the initial parameters.
N $2347 iii. A test is made to see whether the initial 'arc' length is less than 1. If it is, a jump is made simply to plot X, Y. Otherwise, the parameters are set: X+Z and X-Z*SIN (#pi/A) are stacked twice as start and end point, and copied to COORDS as well; zero and 2*Z*SIN (#pi/A) are stored in mem-1 and mem-2 as initial increments, giving as first 'arc' the vertical straight line joining X+Z, y-Z*SIN (#pi/A) and X+Z, Y+Z*SIN (#pi/A). The arc-drawing loop at #R$2420 will ensure that all subsequent points remain on the same circle as these two points, with incremental angle 2#pi/A. But it is clear that these 2 points in fact subtend this angle at the point X+Z*(1-COS (#pi/A)), Y not at X, Y. Hence the end points of each arc of the circle are displaced right by an amount 2*(1-COS (#pi/A)), which is less than half a pixel, and rounds to one pixel at most.
@ $2347 label=C_ARC_GE1
  $2347 Save the arc-count in #REGb.
  $2348 X, Y, Z
B $2349,1 #R$33C0: X, Y, Z, Z
B $234A,1 #R$340F(get_mem_1): X, Y, Z, Z, SIN (#pi/A)
B $234B,1 #R$30CA: X, Y, Z, Z*SIN (#pi/A)
B $234C,1 #R$369B
  $234D Z*SIN (#pi/A) is half the initial 'arc' length; it is tested to see whether it is less than 0.5.
  $2350 If not, the jump is made.
  $2352
B $2353,1 #R$33A1: X, Y, Z
B $2354,1 #R$33A1: X, Y
B $2355,1 #R$369B
  $2356 Clear the machine stack.
  $2357 Jump to plot X, Y.
  $235A X, Y, Z, Z*SIN (#pi/A)
B $235B,1 #R$342D(st_mem_2): (Z*SIN (#pi/A) to mem-2 for now)
B $235C,1 #R$343C: X, Y, Z*SIN (#pi/A), Z
B $235D,1 #R$342D(st_mem_0): X, Y, Z*SIN (#pi/A), Z (Z is copied to mem-0)
B $235E,1 #R$33A1: X, Y, Z*SIN (#pi/A)
B $235F,1 #R$300F: X, Y-Z*SIN (#pi/A)
B $2360,1 #R$343C: Y-Z*SIN (#pi/A), X
B $2361,1 #R$340F(get_mem_0): Y-Z*SIN (#pi/A), X, Z
B $2362,1 #R$3014: Y-Z*SIN (#pi/A), X+Z
B $2363,1 #R$342D(st_mem_0): (X+Z is copied to mem-0)
B $2364,1 #R$343C: X+Z, Y-Z*SIN (#pi/A)
B $2365,1 #R$33C0: X+Z, Y-Z*SIN (#pi/A), Y-Z*SIN (#pi/A)
B $2366,1 #R$340F(get_mem_0): sa, sb, sb, sa
B $2367,1 #R$343C: sa, sb, sa, sb
B $2368,1 #R$33C0: sa, sb, sa, sb, sb
B $2369,1 #R$340F(get_mem_0): sa, sb, sa, sb, sb, sa
B $236A,1 #R$341B(stk_zero): sa, sb, sa, sb, sb, sa, 0
B $236B,1 #R$342D(st_mem_1): (mem-1 is set to zero)
B $236C,1 #R$33A1: sa, sb, sa, sb, sb, sa
B $236D,1 #R$369B
N $236E (Here sa denotes X+Z and sb denotes Y-Z*SIN (#pi/A).)
  $236E Incrementing the exponent byte of mem-2 sets mem-2 to 2*Z*SIN(#pi/A).
  $2371 The last value X+Z is moved from the stack to #REGa and copied to #REGl.
  $2375 It is saved in #REGhl.
  $2376 Y-Z*SIN (#pi/A) goes from the stack to #REGa and is copied to #REGh. #REGhl now holds the initial point.
  $237B It is copied to COORDS.
  $237E The arc-count is restored.
  $237F The jump is made to #R$2420.
E $2320 (The stack now holds X+Z, Y-Z*SIN (#pi/A), Y-Z*SIN (#pi/A), X+Z.)
@ $2382 label=DRAW
c $2382 THE 'DRAW' COMMAND ROUTINE
D $2382 The address of this routine is found in the #R$1AD2(parameter table).
D $2382 This routine is entered with the co-ordinates of a point X0, Y0, say, in COORDS. If only two parameters X, Y are given with the DRAW command, it draws an approximation to a straight line from the point X0, Y0 to X0+X, Y0+Y. If a third parameter G is given, it draws an approximation to a circular arc from X0, Y0 to X0+X, Y0+Y turning anti-clockwise through an angle G radians.
D $2382 The routine has four parts:
D $2382 #LIST { i. Just draws a line if only 2 parameters are given or if the diameter of the implied circle is less than 1. } { ii. Calls #R$247D to set the first parameters. } { iii. Sets up the remaining parameters, including the initial displacements for the first arc. } { iv. Enters the arc-drawing loop and draws the arc as a series of smaller arcs approximated by straight lines, calling the line-drawing subroutine at #R$24B7 as necessary. } LIST#
D $2382 Two subroutines, #R$247D and #R$24B7, follow the main routine. The above 4 parts of the main routine will now be treated in turn.
D $2382 i. If there are only 2 parameters, a jump is made to #R$2477. A line is also drawn if the quantity Z=(ABS X+ABS Y)/ABS SIN(G/2) is less than 1. Z lies between 1 and 1.5 times the diameter of the implied circle. In this section mem-0 is set to SIN (G/2), mem-1 to Y, and mem-5 to G.
  $2382 Get the current character.
  $2383,4,c2,2 If it is a comma, then jump.
  $2387 Move on to next statement if checking syntax.
  $238A Jump to just draw the line.
@ $238D label=DR_3_PRMS
  $238D Get next character (the angle).
  $238E Angle to calculator stack.
  $2391 Move on to next statement if checking syntax.
  $2394 X, Y, G are on the stack.
B $2395,1 #R$342D(st_mem_5): (G is copied to mem-5)
B $2396,1 #R$341B(stk_half): X, Y, G, 0.5
B $2397,1 #R$30CA: X, Y, G/2
B $2398,1 #R$37B5: X, Y, SIN (G/2)
B $2399,1 #R$33C0: X, Y, SIN (G/2), SIN (G/2)
B $239A,1 #R$3501: X, Y, SIN (G/2), (0/1)
B $239B,1 #R$3501: X, Y, SIN (G/2), (1/0)
B $239C,1 #R$368F: X, Y, SIN (G/2)
B $239D,1 to #R$23A3 (if SIN (G/2)=0 i.e. G=2#piN just draw a straight line).
B $239E,1 #R$33A1: X, Y
B $239F,1 #R$369B
  $23A0 Line X0, Y0 to X0+X, Y0+Y.
@ $23A3 label=DR_SIN_NZ
B $23A3,1 #R$342D(st_mem_0): (SIN (G/2) is copied to mem-0)
B $23A4,1 #R$33A1: X, Y are now on the stack.
B $23A5,1 #R$342D(st_mem_1): (Y is copied to mem-1).
B $23A6,1 #R$33A1: X
B $23A7,1 #R$33C0: X, X
B $23A8,1 #R$346A: X, X' (X'=ABS X)
B $23A9,1 #R$340F(get_mem_1): X, X', Y
B $23AA,1 #R$343C: X, Y, X'
B $23AB,1 #R$340F(get_mem_1): X, Y, X', Y
B $23AC,1 #R$346A: X, Y, X', Y' (Y'=ABS Y)
B $23AD,1 #R$3014: X, Y, X'+Y'
B $23AE,1 #R$340F(get_mem_0): X, Y, X'+Y', SIN (G/2)
B $23AF,1 #R$31AF: X, Y, (X'+Y')/SIN (G/2)=Z', say
B $23B0,1 #R$346A: X, Y, Z (Z=ABS Z')
B $23B1,1 #R$340F(get_mem_0): X, Y, Z, SIN (G/2)
B $23B2,1 #R$343C: X, Y, SIN (G/2), Z
B $23B3,1 #R$3297: (Z is re-stacked to make sure that its exponent is available).
B $23B4,1 #R$369B
  $23B5 Get exponent of Z.
  $23B6 If Z is greater than or equal to 1, jump.
  $23BA X, Y, SIN (G/2), Z
B $23BB,1 #R$33A1: X, Y, SIN (G/2)
B $23BC,1 #R$33A1: X, Y
B $23BD,1 #R$369B
  $23BE Just draw the line from X0, Y0 to X0+X, Y0+Y.
N $23C1 ii. Just calls #R$247D. This subroutine saves in the #REGb register the number of shorter arcs required for the complete arc, viz. A=4*INT (G'*SQR Z/8)+4, where G'=mod G, or 252 if this expression exceeds 252 (as can happen with a large chord and a small angle). So A is 4, 8, 12, ... , up to 252. The subroutine also stores in mem-0 to mem-4 the quantities G/A, SIN (G/2*A), 0, COS (G/A), SIN (G/A).
@ $23C1 label=DR_PRMS
  $23C1 The subroutine is called.
N $23C4 iii. Sets up the rest of the parameters as follow. The stack will hold these 4 items, reading up to the top: X0+X and Y0+Y as end of last arc; then X0 and Y0 as beginning of first arc. Mem-0 will hold X0 and mem-5 Y0. Mem-1 and mem-2 will hold the initial displacements for the first arc, U and V; and mem-3 and mem-4 will hold COS (G/A) and SIN (G/A) for use in the arc-drawing loop.
N $23C4 The formulae for U and V can be explained as follows. Instead of stepping along the final chord, of length L, say, with displacements X and Y, we want to step along an initial chord (which may be longer) of length L*W, where W=SIN (G/2*A)/SIN (G/2), with displacements X*W and Y*W, but turned through an angle (G/2-G/2*A), hence with true displacements:
N $23C4 #LIST { U=Y*W*SIN (G/2-G/2*A)+X*W*COS (G/2-G/2*A) } { Y=Y*W*COS (G/2-G/2*A)-X*W*SIN (G/2-G/2*A) } LIST#
N $23C4 These formulae can be checked from a diagram, using the normal expansion of COS (P-Q) and SIN (P-Q), where Q=G/2-G/2*A.
  $23C4 Save the arc-counter in #REGb.
  $23C5 X, Y, SIN(G/2), Z
B $23C6,1 #R$33A1: X, Y, SIN(G/2)
B $23C7,1 #R$340F(get_mem_1): X, Y, SIN(G/2), SIN(G/2*A)
B $23C8,1 #R$343C: X, Y, SIN(G/2*A), SIN(G/2)
B $23C9,1 #R$31AF: X, Y, SIN(G/2*A)/SIN(G/2)=W
B $23CA,1 #R$342D(st_mem_1): (W is copied to mem-1).
B $23CB,1 #R$33A1: X, Y
B $23CC,1 #R$343C: Y, X
B $23CD,1 #R$33C0: Y, X, X
B $23CE,1 #R$340F(get_mem_1): Y, X, X, W
B $23CF,1 #R$30CA: Y, X, X*W
B $23D0,1 #R$342D(st_mem_2): (X*W is copied to mem-2).
B $23D1,1 #R$33A1: Y, X
B $23D2,1 #R$343C: X, Y
B $23D3,1 #R$33C0: X, Y, Y
B $23D4,1 #R$340F(get_mem_1): X, Y, Y, W
B $23D5,1 #R$30CA: X, Y, Y*W
B $23D6,1 #R$340F(get_mem_2): X, Y, Y*W, X*W
B $23D7,1 #R$340F(get_mem_5): X, Y, Y*W, X*W,G
B $23D8,1 #R$340F(get_mem_0): X, Y, Y*W, X*W, G, G/A
B $23D9,1 #R$300F: X, Y, Y*W, X*W, G-G/A
B $23DA,1 #R$341B(stk_half): X, Y, Y*W, X*W, G-G/A, 1/2
B $23DB,1 #R$30CA: X, Y, Y*W, X*W, G/2-G/2*A=F
B $23DC,1 #R$33C0: X, Y, Y*W, X*W, F, F
B $23DD,1 #R$37B5: X, Y, Y*W, X*W, F, SIN F
B $23DE,1 #R$342D(st_mem_5): (SIN F is copied to mem-5).
B $23DF,1 #R$33A1: X, Y, Y*W, X*W,F
B $23E0,1 #R$37AA: X, Y, Y*W, X*W, COS F
B $23E1,1 #R$342D(st_mem_0): (COS F is copied to mem-0).
B $23E2,1 #R$33A1: X, Y, Y*W, X*W
B $23E3,1 #R$342D(st_mem_2): (X*W is copied to mem-2).
B $23E4,1 #R$33A1: X, Y, Y*W
B $23E5,1 #R$342D(st_mem_1): (Y*W is copied to mem-1).
B $23E6,1 #R$340F(get_mem_5): X, Y, Y*W, SIN F
B $23E7,1 #R$30CA: X, Y, Y*W*SIN F
B $23E8,1 #R$340F(get_mem_0): X, Y, Y*W*SIN F, X*W
B $23E9,1 #R$340F(get_mem_2): X, Y, Y*W*SIN F, X*W, COS F
B $23EA,1 #R$30CA: X, Y, Y*W*SIN F, X*W*COS F
B $23EB,1 #R$3014: X, Y, Y*W*SIN F+X*W*COS F=U
B $23EC,1 #R$340F(get_mem_1): X, Y, U, Y*W
B $23ED,1 #R$343C: X, Y, Y*W, U
B $23EE,1 #R$342D(st_mem_1): (U is copied to mem-1)
B $23EF,1 #R$33A1: X, Y, Y*W
B $23F0,1 #R$340F(get_mem_0): X, Y, Y*W, COS F
B $23F1,1 #R$30CA: X, Y, Y*W*COS F
B $23F2,1 #R$340F(get_mem_2): X, Y, Y*W*COS F, X*W
B $23F3,1 #R$340F(get_mem_5): X, Y, Y*W*COS F, X*W, SIN F
B $23F4,1 #R$30CA: X, Y, Y*W*COS F, X*W*SIN F
B $23F5,1 #R$300F: X, Y, Y*W*COS F-X*W*SIN F=V
B $23F6,1 #R$342D(st_mem_2): (V is copied to mem-2).
B $23F7,1 #R$346A: X, Y, V' (V'=ABS V)
B $23F8,1 #R$340F(get_mem_1): X, Y, V', U
B $23F9,1 #R$346A: X, Y, V', U' (U'=ABS U)
B $23FA,1 #R$3014: X, Y, U'+V'
B $23FB,1 #R$33A1: X, Y
B $23FC,1 #R$369B: (#REGde now points to U'+V').
  $23FD Get exponent of U'+V'.
  $23FE If U'+V' is less than 1, just tidy the stack and draw the line from X0, Y0 to X0+X, Y0+Y.
  $2404 Otherwise, continue with the parameters: X, Y, on the stack.
B $2406,1 #R$343C: Y, X
B $2407,1 #R$369B
  $2408 Get X0 into #REGa and so on to the stack.
  $240E Y, X, X0
B $240F,1 #R$342D(st_mem_0): (X0 is copied to mem-0).
B $2410,1 #R$3014: Y, X0+X
B $2411,1 #R$343C: X0+X, Y
B $2412,1 #R$369B
  $2413 Get Y0 into #REGa and so on to the stack.
  $2419 X0+X, Y, Y0
B $241A,1 #R$342D(st_mem_5): (Y0 is copied to mem-5).
B $241B,1 #R$3014: X0+X, Y0+Y
B $241C,1 #R$340F(get_mem_0): X0+X, Y0+Y, X0
B $241D,1 #R$340F(get_mem_5): X0+X, Y0+Y, X0, Y0
B $241E,1 #R$369B
  $241F Restore the arc-counter in #REGb.
N $2420 iv. The arc-drawing loop. This is entered at #R$2439 with the co-ordinates of the starting point on top of the stack, and the initial displacements for the first arc in mem-1 and mem-2. It uses simple trigonometry to ensure that all subsequent arcs will be drawn to points that lie on the same circle as the first two, subtending the same angle at the centre. It can be shown that if 2 points X1, Y1 and X2, Y2 lie on a circle and subtend an angle N at the centre, which is also the origin of co-ordinates, then X2=X1*COS N-Y1*SIN N, and Y2=X1*SIN N+Y1*COS N. But because the origin is here at the increments, say Un=Xn+1-Xn and Vn=Yn+1-Yn, thus achieving the desired result. The stack is shown below on the (n+1)th pass through the loop, as Xn and Yn are incremented by Un and Vn, after these are obtained from Un-1 and Vn-1. The 4 values on the top of the stack at #R$2425 are, in DRAW, reading upwards, X0+X, Y0+Y, Xn and Yn but to save space these are not shown until #R$2439. For the initial values in CIRCLE, see the end of CIRCLE, above. In CIRCLE too, the angle G must be taken to be 2#pi.
@ $2420 label=DRW_STEPS
  $2420 #REGb counts the passes through the loop.
  $2421 Jump when #REGb has reached zero.
  $2423 Jump into the loop to start.
@ $2425 label=ARC_LOOP
  $2425 (See text above for the stack).
B $2426,1 #R$340F(get_mem_1): Un-1
B $2427,1 #R$33C0: Un-1, Un-1
B $2428,1 #R$340F(get_mem_3): Un-1, Un-1, COS(G/A)
B $2429,1 #R$30CA: Un-1, Un-1*COS(G/A)
B $242A,1 #R$340F(get_mem_2): Un-1, Un-1*COS(G/A), Vn-1
B $242B,1 #R$340F(get_mem_4): Un-1, Un-1*COS(G/A), Vn-1, SIN(G/A)
B $242C,1 #R$30CA: Un-1, Un-1*COS(G/A), Vn-1*SIN(G/A)
B $242D,1 #R$300F: Un-1, Un-1*COS(G/A)-Vn-1*SIN(G/A)=Un
B $242E,1 #R$342D(st_mem_1): (Un is copied to mem-1).
B $242F,1 #R$33A1: Un-1
B $2430,1 #R$340F(get_mem_4): Un-1, SIN(G/A)
B $2431,1 #R$30CA: Un-1*SIN(G/A)
B $2432,1 #R$340F(get_mem_2): Un-1*SIN(G/A), Vn-1
B $2433,1 #R$340F(get_mem_3): Un-1*SIN(G/A), Vn-1, COS(G/A)
B $2434,1 #R$30CA: Un-1*SIN(G/A), Vn-1*COS(G/A)
B $2435,1 #R$3014: Un-1*SIN(G/A)+Vn-1*COS(G/A)=Vn
B $2436,1 #R$342D(st_mem_2): (Vn is copied to mem-2).
B $2437,1 #R$33A1: (As noted in the text, the stack in fact holds X0+X, Y0+Y, Xn and Yn).
B $2438,1 #R$369B
@ $2439 label=ARC_START
  $2439 Save the arc-counter.
  $243A X0+X, Y0+y, Xn, Yn
B $243B,1 #R$342D(st_mem_0): (Yn is copied to mem-0).
B $243C,1 #R$33A1: X0+X, Y0+Y, Xn
B $243D,1 #R$340F(get_mem_1): X0+X, Y0+Y, Xn, Un
B $243E,1 #R$3014: X0+X, Y0+Y, Xn+Un=Xn+1
B $243F,1 #R$33C0: X0+X, Y0+Y, Xn+1, Xn+1
B $2440,1 #R$369B
  $2441 Next Xn', the approximate value of Xn reached by the line-drawing subroutine is copied to #REGa and hence to the stack.
  $2447 X0+X, Y0+Y, Xn+1, Xn'
B $2448,1 #R$300F: X0+X, Y0+Y, Xn+1, Xn+1, Xn'-Xn'=Un'
B $2449,1 #R$340F(get_mem_0): X0+X, Y0+Y, Xn+1, Un', Yn
B $244A,1 #R$340F(get_mem_2): X0+X, Y0+Y, Xn+1, Un', Yn, Vn
B $244B,1 #R$3014: X0+X, Y0+Y, Xn+1, Un', Yn+Vn=Yn+1
B $244C,1 #R$342D(st_mem_0): (Yn+1 is copied to mem-0).
B $244D,1 #R$343C: X0+X, Y0+Y, Xn+1, Yn+1, Un'
B $244E,1 #R$340F(get_mem_0): X0+X, Y0+Y, Xn+1, Yn+1, Un', Yn+1
B $244F,1 #R$369B
  $2450 Yn', approximate like Xn', is copied to #REGa and hence to the stack.
  $2456 X0+X, Y0+Y, Xn+1, Yn+1, Un', Yn+1, Yn'
B $2457,1 #R$300F: X0+X, Y0+Y, Xn+1, Yn+1, Un', Vn'
B $2458,1 #R$369B
  $2459 The next 'arc' is drawn.
  $245C The arc-counter is restored.
  $245D Jump if more arcs to draw.
@ $245F label=ARC_END
B $2460,2,1 #R$33A1: The co-ordinates of the end of the last arc that was drawn are now deleted from the stack.
B $2462,1 #R$343C: Y0+Y, X0+X
B $2463,1 #R$369B
  $2464,6 The X-co-ordinate of the end of the last arc that was drawn, say Xz', is copied to the stack.
B $246B,1 #R$300F: Y0+Y, X0+X-Xz'
B $246C,1 #R$343C: X0+X-Xz', Y0+Y
B $246D,1 #R$369B
  $246E The Y-co-ordinate is obtained.
  $2474 X0+X-Xz', Y0+Y, Yz'
B $2475,1 #R$300F: X0+X-Xz', Y0+Y-Yz'
B $2476,1 #R$369B
@ $2477 label=LINE_DRAW
  $2477 The final arc is drawn to reach X0+X, Y0+Y (or close the circle).
  $247A Exit, setting temporary colours.
@ $247D label=CD_PRMS1
c $247D THE 'INITIAL PARAMETERS' SUBROUTINE
D $247D This subroutine is called by both #R$2320 and #R$2382 to set their initial parameters. It is called by #R$2320 with X, Y and the radius Z on the top of the stack, reading upwards. It is called by #R$2382 with its own X, Y, SIN (G/2) and Z, as defined in #R$2382 i., on the top of the stack. In what follows the stack is only shown from Z upwards.
D $247D The subroutine returns in #REGb the arc-count A as explained in both #R$2320 and #R$2382, and in mem-0 to mem-5 the quantities G/A, SIN (G/2*A), 0, COS (G/A), SIN (G/A) and G. For a circle, G must be taken to be equal to 2#pi.
  $247D Z
B $247E,1 #R$33C0: Z, Z
B $247F,1 #R$384A: Z, SQR Z
B $2480,3,1,2 #R$33C6: Z, SQR Z, 2
B $2483,1 #R$343C: Z, 2, SQR Z
B $2484,1 #R$31AF: Z, 2/SQR Z
B $2485,1 #R$340F(get_mem_5): Z, 2/SQR Z, G
B $2486,1 #R$343C: Z, G, 2/SQR Z
B $2487,1 #R$31AF: Z, G*SQR Z/2
B $2488,1 #R$346A: Z, G'*SQR Z/2 (G'=mod G)
B $2489,1 #R$369B: Z, G'*SQR Z/2=A1, say
  $248A A1 to #REGa from the stack, if possible.
  $248D If A1 rounds to 256 or more, use 252.
  $248F 4*INT (A1/4) to #REGa.
  $2491 Add 4, giving the arc-count A.
  $2493 Jump if still under 256.
  $2495 Here, just use 252 decimal.
@ $2495 label=USE_252
  $2497 Now save the arc-count.
@ $2497 label=DRAW_SAVE
  $2498 Copy it to calculator stack too.
  $249B Z, A
B $249C,1 #R$340F(get_mem_5): Z, A, G
B $249D,1 #R$343C: Z, G, A
B $249E,1 #R$31AF: Z, G/A
B $249F,1 #R$33C0: Z, G/A, G/A
B $24A0,1 #R$37B5: Z, G/A, SIN (G/A)
B $24A1,1 #R$342D(st_mem_4): (SIN (G/A) is copied to mem-4)
B $24A2,1 #R$33A1: Z, G/A
B $24A3,1 #R$33C0: Z, G/A, G/A
B $24A4,1 #R$341B(stk_half): Z, G/A, G/A, 0.5
B $24A5,1 #R$30CA: Z, G/A, G/2*A
B $24A6,1 #R$37B5: Z, G/A, SIN (G/2*A)
B $24A7,1 #R$342D(st_mem_1): (SIN (G/2*A) is copied to mem-1)
B $24A8,1 #R$343C: Z, SIN (G/2*A), G/A
B $24A9,1 #R$342D(st_mem_0): (G/A is copied to mem-0)
B $24AA,1 #R$33A1: Z, SIN (G/2*A)=S
B $24AB,1 #R$33C0: Z, S, S
B $24AC,1 #R$30CA: Z, S*S
B $24AD,1 #R$33C0: Z, S*S, S*S
B $24AE,1 #R$3014: Z, 2*S*S
B $24AF,1 #R$341B(stk_one): Z, 2*S*S, 1
B $24B0,1 #R$300F: Z, 2*S*S-1
B $24B1,1 #R$346E: Z, 1-2*S*S=COS (G/A)
B $24B2,1 #R$342D(st_mem_3): (COS (G/A) is copied to mem-3)
B $24B3,1 #R$33A1: Z
B $24B4,1 #R$369B
  $24B5 Restore the arc-count to #REGb.
  $24B6 Finished.
@ $24B7 label=DRAW_LINE
c $24B7 THE 'LINE-DRAWING' SUBROUTINE
D $24B7 This subroutine is called by #R$2382 to draw an approximation to a straight line from the point X0, Y0 held in COORDS to the point X0+X, Y0+Y, where the increments X and Y are on the top of the calculator stack. The subroutine was originally intended for the ZX80 and ZX81 8K ROM, and it is described in a BASIC program on page 121 of the ZX81 manual.
D $24B7 The method is to intersperse as many horizontal or vertical steps as are needed among a basic set of diagonal steps, using an algorithm that spaces the horizontal or vertical steps as evenly as possible.
  $24B7 ABS Y to #REGb; ABS X to #REGc; SGN Y to #REGd; SGN X to #REGe.
  $24BA Jump if ABS X is greater than or equal to ABS Y, so that the smaller goes to #REGl, and the larger (later) goes to #REGh.
  $24BF Save diagonal step (+/-1,+/-1) in #REGde.
  $24C0 Insert a vertical step (+/-1,0) into #REGde (#REGd holds SGN Y).
  $24C2 Now jump to set #REGh.
@ $24C4 label=DL_X_GE_Y
  $24C4 Return if ABS X and ABS Y are both zero.
  $24C6 The smaller (ABS Y here) goes to #REGl.
  $24C7 ABS X to #REGb here, for #REGh.
  $24C8 Save the diagonal step here too.
  $24C9 Horizontal step (0,+/-1) to #REGde here.
@ $24CB label=DL_LARGER
  $24CB Larger of ABS X, ABS Y to #REGh now.
N $24CC The algorithm starts here. The larger of ABS X and ABS Y, say #REGh, is put into #REGa and reduced to INT (#REGh/2). The #REGh-#REGl horizontal or vertical steps and #REGl diagonal steps are taken (where #REGl is the smaller of ABS X and ABS Y) in this way: #REGl is added to #REGa; if #REGa now equals or exceeds #REGh, it is reduced by #REGh and a diagonal step is taken; otherwise a horizontal or vertical step is taken. This is repeated #REGh times (#REGb also holds #REGh). Note that meanwhile the exchange registers #REGh' and #REGl' are used to hold COORDS.
  $24CC #REGb to #REGa as well as to #REGh.
  $24CD #REGa starts at INT (#REGh/2).
@ $24CE label=D_L_LOOP
  $24CE #REGl is added to #REGa.
  $24CF If 256 or more, jump - diagonal step.
  $24D1 If #REGa is less than #REGh, jump for horizontal or vertical step.
@ $24D4 label=D_L_DIAG
  $24D4 Reduce #REGa by #REGh.
  $24D5 Restore it to #REGc.
  $24D6 Now use the exchange resisters.
  $24D7 Diagonal step to #REGbc'.
  $24D8 Save it too.
  $24D9 Jump to take the step.
@ $24DB label=D_L_HR_VT
  $24DB Save #REGa (unreduced) in #REGc.
  $24DC Step to stack briefly.
  $24DD Get exchange registers.
  $24DE Step to #REGbc' now.
@ $24DF label=D_L_STEP
  $24DF Now take the step: first, COORDS to #REGhl' as the start point.
  $24E2 Y-step from #REGb' to #REGa.
  $24E3 Add in #REGh'.
  $24E4 Result to #REGb'.
  $24E5 Now the X-step; it will be tested for range (Y will be tested in #R$22DC).
  $24E7 Add #REGl' to #REGc' in #REGa, jump on carry for further test.
  $24EA Zero after no carry denotes X-position -1, out of range.
@ $24EC label=D_L_PLOT
  $24EC Restore true value to #REGa.
  $24ED Value to #REGc' for plotting.
  $24EE Plot the step.
  $24F1 Restore main registers.
  $24F2 #REGc back to #REGa to continue algorithm.
  $24F3 Loop back for #REGb steps (i.e. #REGh steps).
  $24F5 Clear machine stack.
  $24F6 Finished.
@ $24F7 label=D_L_RANGE
  $24F7 Zero after carry denotes X-position 255, in range.
N $24F9 Report B - Integer out of range.
@ $24F9 label=REPORT_B_3
M $24F9,2 Call the error handling routine.
B $24FA,1
@ $24FB label=SCANNING
c $24FB THE 'SCANNING' SUBROUTINE
D $24FB This subroutine is used to produce an evaluation result of the 'next expression'.
D $24FB The result is returned as the 'last value' on the calculator stack. For a numerical result, the last value will be the actual floating point number. However, for a string result the last value will consist of a set of parameters. The first of the five bytes is unspecified, the second and third bytes hold the address of the start of the string and the fourth and fifth bytes hold the length of the string.
D $24FB Bit 6 of FLAGS is set for a numeric result and reset for a string result.
D $24FB When a next expression consists of only a single operand (e.g. 'A', 'RND', 'A$(4,3 TO 7)'), then the last value is simply the value that is obtained from evaluating the operand.
D $24FB However when the next expression contains a function and an operand (e.g. 'CHR$ A', 'NOT A', 'SIN 1'), the operation code of the function is stored on the machine stack until the last value of the operand has been calculated. This last value is then subjected to the appropriate operation to give a new last value.
D $24FB In the case of there being an arithmetic or logical operation to be performed (e.g. 'A+B', 'A*B', 'A=B'), then both the last value of the first argument and the operation code have to be kept until the last value of the second argument has been found. Indeed the calculation of the last value of the second argument may also involve the storing of last values and operation codes whilst the calculation is being performed.
D $24FB It can therefore be shown that as a complex expression is evaluated (e.g. 'CHR$ (T+A-26*INT ((T+A)/26)+65)'), a hierarchy of operations yet to be performed is built up until the point is reached from which it must be dismantled to produce the final last value.
D $24FB Each operation code has associated with it an appropriate priority code and operations of higher priority are always performed before those of lower priority.
D $24FB The subroutine begins with the #REGa register being set to hold the first character of the expression and a starting priority marker - zero - being put on the machine stack.
  $24FB The first character is fetched.
  $24FC The starting priority marker.
  $24FE It is stacked.
@ $24FF label=S_LOOP_1
  $24FF The main re-entry point.
  $2500 Index into the #R$2596(scanning function table) with the code in #REGc.
  $2506 Restore the code to #REGa.
  $2507 Jump if code not found in table.
  $250A Use the entry found in the table to build up the required address in #REGhl, and jump to it.
@ $250F label=S_QUOTE_S
c $250F THE 'SCANNING QUOTES' SUBROUTINE
D $250F This subroutine is used by #R$25B3 to check that every string quote is matched by another one.
  $250F Point to the next character.
  $2512 Increase the length count by one.
  $2513 Is it a carriage return?
  $2515 Report the error if so.
  $2518,c2 Is it another '"'?
  $251A Loop back if it is not.
  $251C Point to next character.
  $251F,c2 Set zero flag if it is another '"'.
  $2521 Finished.
@ $2522 label=S_2_COORD
c $2522 THE 'SCANNING TWO CO-ORDINATES' SUBROUTINE
D $2522 This subroutine is called by #R$2668, #R$2672 and #R$267B to make sure the required two co-ordinates are given in their proper form.
  $2522 Fetch the next character.
  $2523,c2 Is it a '('?
  $2525 Report the error if it is not.
  $2527 Co-ordinates to calculator stack.
  $252A Fetch the current character.
  $252B,c2 Is it a ')'?
@ $252D label=S_RPORT_C
  $252D Report the error if it is not.
@ $2530 label=SYNTAX_Z
c $2530 THE 'SYNTAX-Z' SUBROUTINE
D $2530 This subroutine is called 32 times, with a saving of just one byte each call. A simple test of bit 7 of FLAGS will give the zero flag reset during execution and set during syntax checking.
  $2530 Test bit 7 of FLAGS.
  $2534 Finished.
@ $2535 label=S_SCRN_S
c $2535 THE 'SCANNING SCREEN$' SUBROUTINE
D $2535 This subroutine is used to find the character that appears at line x, column y of the screen. It only searches the character set 'pointed to' by CHARS.
D $2535 Note: this is normally the characters +20 (space) to +7F (#CHR(169)) although the user can alter CHARS to match for other characters, including user-defined graphics.
@ $2535 label=S_SCRN_S
  $2535 x to #REGc, y to #REGb; 0<=x<=23 decimal; 0<=y<=31 decimal.
@ $253B keep
  $2538 CHARS plus 256 decimal gives #REGhl pointing to the character set.
  $253F x is copied to #REGa.
  $2540 The number 32*(x mod 8)+y is formed in #REGa and copied to #REGe. This is the low byte of the required screen address.
  $2547 x is copied to #REGa again.
  $2548 Now the number 64+8*INT (x/8) is inserted into #REGd. #REGde now holds the screen address.
  $254D #REGb counts the 96 characters.
@ $254F label=S_SCRN_LP
  $254F Save the count.
  $2550 And the screen pointer.
  $2551 And the character set pointer.
  $2552 Get first row of screen character.
  $2553 Match with row from character set.
  $2554 Jump if direct match found.
  $2556 Now test for match with inverse character (get +00 in #REGa from +FF).
  $2557 Jump if neither match found.
  $2559 Restore +FF to #REGa.
@ $255A label=S_SC_MTCH
  $255A Inverse status (+00 or +FF) to #REGc.
  $255B #REGb counts through the other 7 rows.
@ $255D label=S_SC_ROWS
  $255D Move #REGde to next row (add 256 dec.).
  $255E Move #REGhl to next row (i.e. next byte).
  $255F Get the screen row.
  $2560 Match with row from the ROM.
  $2561 Include the inverse status.
  $2562 Jump if row fails to match.
  $2564 Jump back till all rows done.
  $2566 Discard character set pointer.
  $2567 And screen pointer.
  $2568 Final count to #REGbc.
  $2569 Last character code in set plus one.
  $256B #REGa now holds required code.
@ $256C keep
  $256C One space is now needed in the work space.
  $256F Make the space.
  $2570 Put the character into it.
  $2571 Jump to stack the character.
@ $2573 label=S_SCR_NXT
  $2573 Restore character set pointer.
@ $2574 keep
  $2574 Move it on 8 bytes, to the next character in the set.
  $2578 Restore the screen pointer.
  $2579 And the counter.
  $257A Loop back for the 96 characters.
  $257C Stack the empty string (length zero).
@ $257D label=S_SCR_STO
  $257D Jump to stack the matching character, or the null string if no match is found.
E $2535 Note: this exit, via #R$2AB2, is a mistake as it leads to 'double storing' of the string result (see #R$25DB). The instruction line should be 'RET'.
@ $2580 label=S_ATTR_S
c $2580 THE 'SCANNING ATTRIBUTES' SUBROUTINE
  $2580 The last of these four subroutines is the 'scanning attributes subroutine'. It is called by S-ATTR to return the value of ATTR (x,y) which codes the attributes of line x, column y on the television screen.
  $2580 x to #REGc, y to #REGb. Again, 0<=x<=23 decimal; 0<=y<=31 decimal.
  $2583 x is copied to #REGa and the number 32*(x mod 8)+y is formed in #REGa. 32*(x mod 8)+INT (x/8) is also copied to #REGc.
  $258B #REGl holds low byte of attribute address.
  $258C 32*(x mod 8)+INT (x/8) is copied to #REGa.
  $258D 88+INT (x/8) is formed in #REGa.
  $2591 #REGh holds high byte of attribute address.
  $2592 The attribute byte is copied to #REGa.
  $2593 Exit, stacking the required byte.
@ $2596 label=SCANFUNC
b $2596 THE SCANNING FUNCTION TABLE
D $2596 This table contains 8 functions and 4 operators. It thus incorporates 5 new Spectrum functions and provides a neat way of accessing some functions and operators which already existed on the ZX81.
  $2596,2,T1:1 #R$25B3
  $2598,2,T1:1 #R$25E8
  $259A,2,T1:1 #R$268D
  $259C,2,T1:1 #R$25AF
  $259E #R$25F5
  $25A0 #R$25F8
  $25A2 #R$2627
  $25A4 #R$2634
  $25A6 #R$268D
  $25A8 #R$2668
  $25AA #R$2672
  $25AC #R$267B
  $25AE End marker.
@ $25AF label=S_U_PLUS
c $25AF THE 'SCANNING UNARY PLUS' ROUTINE
D $25AF The address of this routine is derived from an offset found in the #R$2596(scanning function table).
  $25AF For unary plus, simply move on to the next character and jump back to the main re-entry of #R$24FB.
@ $25B3 label=S_QUOTE
c $25B3 THE 'SCANNING QUOTE' ROUTINE
D $25B3 The address of this routine is derived from an offset found in the #R$2596(scanning function table).
D $25B3 This routine deals with string quotes, whether simple like "name" or more complex like "a ""white"" lie" or the seemingly redundant VAL$ """a""".
  $25B3 Fetch the current character.
  $25B4 Point to the start of the string.
  $25B5 Save the start address.
@ $25B6 keep
  $25B6 Set the length to zero.
  $25B9 Call the "matching" subroutine.
  $25BC Jump if zero reset - no more quotes.
@ $25BE label=S_Q_AGAIN
  $25BE Call it again for a third quote.
  $25C1 And again for the fifth, seventh etc.
  $25C3 If testing syntax, jump to reset bit 6 of FLAGS and to continue scanning.
  $25C8 Make space in the work space for the string and the terminating quote.
  $25C9 Get the pointer to the start.
  $25CA Save the pointer to the first space.
@ $25CB label=S_Q_COPY
  $25CB Get a character from the string.
  $25CC Point to the next one.
  $25CD Copy last one to work space.
  $25CE Point to the next space.
  $25CF,c2 Is last character a '"'?
  $25D1 If not, jump to copy next one.
  $25D3,6,2,c2,2 But if it was, do not copy next one; if next one is a '"', jump to copy the one after it; otherwise, finished with copying.
@ $25D9 label=S_Q_PRMS
  $25D9 Get true length to #REGbc.
N $25DA Note that the first quote was not counted into the length; the final quote was, and is discarded now. Inside the string, the first, third, fifth, etc., quotes were counted in but the second, fourth, etc., were not.
  $25DA Restore start of copied string.
@ $25DB label=S_STRING
  $25DB This is FLAGS; this entry point is used whenever bit 6 is to be reset and a string stacked if executing a line. This is done now.
  $25E5 Jump to continue scanning the line.
E $25B3 Note that in copying the string to the work space, every two pairs of string quotes inside the string ("") have been reduced to one pair of string quotes(").
@ $25E8 label=S_BRACKET
c $25E8 THE 'SCANNING BRACKET' ROUTINE
D $25E8 The address of this routine is derived from an offset found in the #R$2596(scanning function table).
  $25E8 This routine simply gets the character and calls #R$24FB recursively.
  $25EC,5,c2,3 Report the error if no matching bracket.
  $25F1 Continue scanning.
@ $25F5 label=S_FN
c $25F5 THE 'SCANNING FN' ROUTINE
D $25F5 The address of this routine is derived from an offset found in the #R$2596(scanning function table).
D $25F5 This routine, for user-defined functions, just jumps to the #R$27BD('scanning FN' subroutine).
@ $25F8 label=S_RND
c $25F8 THE 'SCANNING RND' ROUTINE
D $25F8 The address of this routine is derived from an offset found in the #R$2596(scanning function table).
  $25F8 Unless syntax is being checked, jump to calculate a random number.
  $25FD Fetch the current value of SEED.
  $2601 Put it on the calculator stack.
  $2604 Now use the calculator.
B $2605,1 #R$341B(stk_one)
B $2606,1 #R$3014: The 'last value' is now SEED+1.
B $2607,3,1,2 #R$33C6: Put the decimal number 75 on the calculator stack.
B $260A,1 #R$30CA: 'last value' (SEED+1)*75.
B $260B,6,1,5 #R$33C6: Put the decimal number 65537 on the calculator stack.
B $2611,1 #R$36A0: Divide (SEED+1)*75 by 65537 to give a 'remainder' and an 'answer'.
B $2612,1 #R$33A1: Discard the 'answer'.
B $2613,1 #R$341B(stk_one)
B $2614,1 #R$300F: The 'last value' is now 'remainder' - 1.
B $2615,1 #R$33C0: Make a copy of the 'last value'.
B $2616,1 #R$369B: The calculation is finished.
  $2617 Use the 'last value' to give the new value for SEED.
  $261E Fetch the exponent of 'last value'.
  $261F Jump forward if the exponent is zero.
  $2622 Reduce the exponent, i.e. divide 'last value' by 65536 to give the required 'last value'.
@ $2625 label=S_RND_END
  $2625 Jump past the #R$2627 routine.
@ $2627 label=S_PI
c $2627 THE 'SCANNING PI' ROUTINE
D $2627 The address of this routine is derived from an offset found in the #R$2596(scanning function table).
D $2627 Unless syntax is being checked the value of 'PI' is calculated and forms the 'last value' on the calculator stack.
  $2627 Test for syntax checking.
  $262A Jump if required.
  $262C Now use the calculator.
B $262D,1 #R$341B(stk_pi_2): The value of #pi/2 is put on the calculator stack as the 'last value'.
B $262E,1 #R$369B
  $262F The exponent is incremented thereby doubling the 'last value' giving #pi.
@ $2630 label=S_PI_END
  $2630 Move on to the next character.
  $2631 Jump forward.
@ $2634 keep
@ $2634 label=S_INKEY
c $2634 THE' SCANNING INKEY$' ROUTINE
D $2634 The address of this routine is derived from an offset found in the #R$2596(scanning function table).
  $2634 Priority +10 hex, operation code +5A for the 'read-in' subroutine.
  $2638,5,c2,3 If next char. is '#', jump. There will be a numerical argument.
  $263D This is FLAGS.
  $2640 Reset bit 6 for a string result.
  $2642 Test for syntax checking.
  $2644 Jump if required.
  $2646 Fetch a key-value in #REGde.
  $2649 Prepare empty string; stack it if too many keys pressed.
  $264D Test the key value; stack empty string if unsatisfactory.
  $2652 +FF to #REGd for 'L' mode (bit 3 set).
  $2653 Key-value to #REGe for decoding.
  $2654 Decode the key-value.
  $2657 Save the ASCII value briefly.
@ $2658 keep
  $2658 One space is needed in the work space.
  $265B Make it now.
  $265C Restore the ASCII value.
  $265D Prepare to stack it as a string.
  $265E Its length is one.
@ $2660 label=S_IK_STK
  $2660 Complete the length parameter.
  $2662 Stack the required string.
@ $2665 label=S_INK_EN
  $2665 Jump forward.
@ $2668 label=S_SCREEN
c $2668 THE 'SCANNING SCREEN$' ROUTINE
D $2668 The address of this routine is derived from an offset found in the #R$2596(scanning function table).
  $2668 Check that 2 co-ordinates are given.
  $266B Call the subroutine unless checking syntax.
  $266E Then get the next character and jump back.
@ $2672 label=S_ATTR
c $2672 THE 'SCANNING ATTR' ROUTINE
D $2672 The address of this routine is derived from an offset found in the #R$2596(scanning function table).
  $2672 Check that 2 co-ordinates are given.
  $2675 Call the subroutine unless checking syntax.
  $2678 Then get the next character and jump forward.
@ $267B label=S_POINT
c $267B THE 'SCANNING POINT' ROUTINE
D $267B The address of this routine is derived from an offset found in the #R$2596(scanning function table).
  $267B Check that 2 co-ordinates are given.
  $267E Call the subroutine unless checking syntax.
  $2681 Then get the next character and jump forward.
@ $2684 label=S_ALPHNUM
c $2684 THE 'SCANNING ALPHANUMERIC' ROUTINE
  $2684 Is the character alphanumeric?
  $2687 Jump if not a letter or a digit.
  $2689,4,c2,2 Now jump if it is a letter; otherwise continue on into #R$268D.
@ $268D label=S_DECIMAL
c $268D THE 'SCANNING DECIMAL' ROUTINE
D $268D The address of this routine is derived from an offset found in the #R$2596(scanning function table).
D $268D This routine deals with a decimal point or a number that starts with a digit. It also takes care of the expression 'BIN', which is dealt with in the 'decimal to floating-point' subroutine.
  $268D Jump forward if a line is being executed.
N $2692 The action taken is now very different for syntax checking and line execution. If syntax is being checked then the floating-point form has to be calculated and copied into the actual BASIC line. However when a line is being executed the floating-point form will always be available so it is copied to the calculator stack to form a 'last value'.
N $2692 During syntax checking:
  $2692 The floating-point form is found.
  $2695 Set #REGhl to point one past the last digit.
@ $2696 keep
  $2696 Six locations are required.
  $2699 Make the room in the BASIC line.
  $269C Point to the first free space.
  $269D Enter the number marker code.
  $269F Point to the second location.
  $26A0 This pointer is wanted in #REGde.
  $26A1 Fetch the 'old' STKEND.
  $26A4 There are 5 bytes to move.
  $26A6 Clear the carry flag.
  $26A7 The 'new' STKEND='old' STKEND minus 5.
  $26A9 Move the floating-point number from the calculator stack to the line.
  $26AE Put the line pointer in #REGhl.
  $26AF Point to the last byte added.
  $26B0 This sets CH-ADD.
  $26B3 Jump forward.
N $26B5 During line execution:
@ $26B5 label=S_STK_DEC
  $26B5 Get the current character.
@ $26B6 label=S_SD_SKIP
  $26B6 Now move on to the next character in turn until the number marker code (0E hex) is found.
  $26BC Point to the first byte of the number.
  $26BD Move the floating-point number.
  $26C0 Set CH-ADD.
N $26C3 A numeric result has now been identified, coming from RND, PI, ATTR, POINT or a decimal number, therefore bit 6 of FLAGS must be set.
@ $26C3 label=S_NUMERIC
  $26C3 Set the numeric marker flag.
  $26C7 Jump forward.
@ $26C9 label=S_LETTER
c $26C9 THE 'SCANNING VARIABLE' ROUTINE
D $26C9 When a variable name has been identified a call is made to #R$28B2 which looks through those variables that already exist in the variables area (or in the program area at DEF FN statements for a user-defined function FN). If an appropriate numeric value is found then it is copied to the calculator stack using #R$33B4. However a string or string array entry has to have the appropriate parameters passed to the calculator stack by #R$2996 (or in the case of a user-defined function, by #R$2951 as called from #R$28B2).
  $26C9 Look in the existing variables for the matching entry.
  $26CC An error is reported if there is no existing entry.
  $26CF Stack the parameters of the string entry/return numeric element base address.
  $26D2 Fetch FLAGS.
  $26D5 Test bits 6 and 7 together.
  $26D7 Jump if one or both bits are reset.
  $26D9 A numeric value is to be stacked.
  $26DA Move the number.
@ $26DD label=S_CONT_1
  $26DD Jump forward.
N $26DF The character is tested against the code for '-', thus identifying the 'unary minus' operation.
N $26DF Before the actual test the #REGb register is set to hold the priority +09 and the #REGc register the operation code +DB that are required for this operation.
@ $26DF keep
@ $26DF label=S_NEGATE
  $26DF Priority +09, operation code +DB.
  $26E2,c2 Is it a '-'?
  $26E4 Jump forward if it is 'unary minus'.
N $26E6 Next the character is tested against the code for 'VAL$', with priority 16 decimal and operation code 18 hex.
@ $26E6 keep
  $26E6 Priority 16 dec, operation code +18 hex.
  $26E9 Is it 'VAL$'?
  $26EB Jump forward if it is 'VAL$'.
N $26ED The present character must now represent one of the functions CODE to NOT, with codes +AF to +C3.
  $26ED The range of the functions is changed from +AF to +C3 to range +00 to +14 hex.
  $26EF Report an error if out of range.
N $26F2 The function 'NOT' is identified and dealt with separately from the others.
@ $26F2 keep
  $26F2 Priority +04, operation code +F0.
  $26F5 Is it the function 'NOT'?
  $26F7 Jump if it is so.
  $26F9 Check the range again.
N $26FC The remaining functions have priority 16 decimal. The operation codes for these functions are now calculated. Functions that operate on strings need bit 6 reset and functions that give string results need bit 7 reset in their operation codes.
  $26FC Priority 16 decimal.
  $26FE The function range is now +DC to +EF.
  $2700 Transfer the operation code.
  $2701 Separate CODE, VAL and LEN which operate on strings to give numerical results.
@ $2707 label=S_NO_TO_S
  $2707 Separate STR$ and CHR$ which operate on numbers to give string results.
  $270B Mark the operation codes. The other operation codes have bits 6 and 7 both set.
N $270D The priority code and the operation code for the function being considered are now pushed on to the machine stack. A hierarchy of operations is thereby built up.
@ $270D label=S_PUSH_PO
  $270D Stack the priority and operation codes before moving on to consider the next part of the expression.
N $2712 The scanning of the line now continues. The present argument may be followed by a '(', a binary operator or, if the end of the expression has been reached, then e.g. a carriage return character or a colon, a separator or a 'THEN'.
@ $2712 label=S_CONT_2
  $2712 Fetch the present character.
@ $2713 label=S_CONT_3
  $2713,4,c2,2 Jump forward if it is not a '(', which indicates a parenthesised expression.
N $2717 If the 'last value' is numeric then the parenthesised expression is a true sub-expression and must be evaluated by itself. However if the 'last value' is a string then the parenthesised expression represents an element of an array or a slice of a string. A call to #R$2A52 modifies the parameters of the string as required.
  $2717 Jump forward if dealing with a numeric parenthesised expression.
  $271D Modify the parameters of the 'last value'.
  $2720 Move on to consider the next character.
N $2723 If the present character is indeed a binary operator it will be given an operation code in the range +C3 to +CF hex, and the appropriate priority code.
@ $2723 label=S_OPERTR
  $2723 Original code to #REGbc to index into the #R$2795(table of operators).
  $2726 The pointer to the table.
  $2729 Index into the table.
  $272C Jump forward if no operation found.
  $272E Get required code from the table.
@ $272F nowarn
  $272F The pointer to the priority table (26ED+C3 gives #R$27B0 as the first address).
  $2732 Index into the table.
  $2733 Fetch the appropriate priority.
N $2734 The main loop of this subroutine is now entered. At this stage there are:
N $2734 #LIST { i. A 'last value' on the calculator stack. } { ii. The starting priority marker on the machine stack below a hierarchy, of unknown size, of function and binary operation codes. This hierarchy may be null. } { iii. The #REGbc register pair holding the 'present' operation and priority, which if the end of an expression has been reached will be priority zero. } LIST#
N $2734 Initially the 'last' operation and priority are taken off the machine stack and compared against the 'present' operation and priority.
@ $2734 label=S_LOOP
  $2734 he 'last' priority then an exit is made from the loop as the 'present' priority is considered to bind tighter than the 'last' priority.
  $2735 inding, then the operation specified as the 'last' operation is performed. The 'present' operation and priority go back on the machine stack to be carried round the loop again. In this manner the hierarchy of functions and binary operations that have been queued are dealt with in the correct order.
  $2734 Get the 'last' operation and priority.
  $2735 The priority goes to the #REGa register.
  $2736 Compare 'last' against 'present'.
  $2737 Exit to wait for the argument.
  $2739 Are both priorities zero?
  $273A Exit via #R$0018 thereby making 'last value' the required result.
N $273D Before the 'last' operation is performed, the 'USR' function is separated into 'USR number' and 'USR string' according as bit 6 of FLAGS was set or reset when the argument of the function was stacked as the 'last value'.
  $273D Stack the 'present' values.
  $273E This is FLAGS.
  $2741 The 'last' operation is compared with the code for USR, which will give 'USR number' unless modified; jump if not 'USR'.
  $2746 Test bit 6 of FLAGS.
  $2748 Jump if it is set ('USR number').
  $274A Modify the 'last' operation code: 'offset' 19, +80 for string input and numerical result ('USR string').
@ $274C label=S_STK_LST
  $274C Stack the 'last' values briefly.
  $274D Do not perform the actual operation if syntax is being checked.
  $2752 The 'last' operation code.
  $2753 Strip off bits 6 and 7 to convert the operation code to a calculator offset.
  $2756 Now use the calculator.
B $2757,1 #R$33A2: (perform the actual operation)
B $2758,1 #R$369B
  $2759 Jump forward.
N $275B An important part of syntax checking involves the testing of the operation to ensure that the nature of the 'last value' is of the correct type for the operation under consideration.
@ $275B label=S_SYNTEST
  $275B Get the 'last' operation code.
  $275C This tests the nature of the 'last value' against the requirement of the operation. They are to be the same for correct syntax.
@ $2761 label=S_RPORT_C_2
  $2761 Jump if syntax fails.
N $2764 Before jumping back to go round the loop again the nature of the 'last value' must be recorded in FLAGS.
@ $2764 label=S_RUNTEST
  $2764 Get the 'last' operation code.
  $2765 This is FLAGS.
  $2768 Assume result to be numeric.
  $276A Jump forward if the nature of 'last value' is numeric.
  $276E It is a string.
@ $2770 label=S_LOOPEND
  $2770 Get the 'present' values into #REGbc.
  $2771 Jump back.
N $2773 Whenever the 'present' operation binds tighter, the 'last' and the 'present' values go back on the machine stack. However if the 'present' operation requires a string as its operand then the operation code is modified to indicate this requirement.
@ $2773 label=S_TIGHTER
  $2773 The 'last' values go on the stack.
  $2774 Get the 'present' operation code.
  $2775 Do not modify the operation code if dealing with a numeric operand.
  $277B Clear bits 6 and 7.
  $277D Increase the code by +08 hex.
  $277F Return the code to the #REGc register.
  $2780 Is the operation 'AND'?
  $2782 Jump if it is not so.
  $2784 'AND' requires a numeric operand.
  $2786 Jump forward.
@ $2788 label=S_NOT_AND
  $2788 The operations -, *, /, #power and OR are not possible between strings.
  $278A Is the operation a '+'?
  $278C Jump if it is so.
  $278E The other operations yield a numeric result.
@ $2790 label=S_NEXT
  $2790 The 'present' values go on the machine stack.
  $2791 Consider the next character.
  $2792 Go around the loop again.
@ $2795 label=OPERATORS
b $2795 THE TABLE OF OPERATORS
  $2795,2,T1:1 +
  $2797,2,T1:1 -
  $2799,2,T1:1 *
  $279B,2,T1:1 /
  $279D,2 #power
  $279F,2,T1:1 =
  $27A1,2,T1:1 >
  $27A3,2,T1:1 <
  $27A5,2 <=
  $27A7,2 >=
  $27A9,2 <>
  $27AB,2 OR
  $27AD,2 AND
  $27AF,1 End marker.
b $27B0 THE TABLE OF PRIORITIES
  $27B0 -
  $27B1 *
  $27B2 /
  $27B3 #power
  $27B4 OR
  $27B5 AND
  $27B6 <=
  $27B7 >=
  $27B8 <>
  $27B9 >
  $27BA <
  $27BB =
  $27BC +
@ $27BD label=S_FN_SBRN
c $27BD THE 'SCANNING FUNCTION' SUBROUTINE
D $27BD This subroutine evaluates a user defined function which occurs in a BASIC line. The subroutine can be considered in four stages:
D $27BD #LIST { i. The syntax of the FN statement is checked during syntax checking. } { ii. During line execution, a search is made of the program area for a DEF FN statement, and the names of the functions are compared, until a match is found - or an error is reported. } { iii. The arguments of the FN are evaluated by calls to #R$24FB. } { iv. The function itself is evaluated by calling #R$24FB, which in turn calls #R$28B2 and so #R$2951. } LIST#
  $27BD Unless syntax is being checked, a jump is made to #R$27F7.
  $27C2 Get the first character of the name.
  $27C3 If it is not alphabetic, then report the error.
  $27C9 Get the next character.
  $27CA,c2 Is it a '$'?
  $27CC Save the zero flag on the stack.
  $27CD Jump if it was not a '$'.
  $27CF But get the next character if it was.
@ $27D0 label=SF_BRKT_1
  $27D0,4,c2,2 If the character is not a '(', then report the error.
  $27D4 Get the next character.
  $27D5,c2 Is it a ')'?
  $27D7 Jump if it is; there are no arguments.
@ $27D9 label=SF_ARGMTS
  $27D9 Within the loop, call #R$24FB to check the syntax of each argument and to insert floating-point numbers.
  $27DC,5,1,c2,2 Get the character which follows the argument; if it is not a ',' then jump - no more arguments.
  $27E1 Get the first character in the next argument.
  $27E2 Loop back to consider this argument.
@ $27E4 label=SF_BRKT_2
  $27E4,c2 Is the current character a ')'?
@ $27E6 label=SF_RPRT_C
  $27E6 Report the error if it is not.
@ $27E9 label=SF_FLAG_6
  $27E9 Point to the next character in the BASIC line.
  $27EA This is FLAGS; assume a string-valued function and reset bit 6 of FLAGS.
  $27EF Restore the zero flag, jump if the FN is indeed string-valued.
  $27F2 Otherwise, set bit 6 of FLAGS.
@ $27F4 label=SF_SYN_EN
  $27F4 Jump back to continue scanning the line.
N $27F7 ii. During line execution, a search must first be made for a DEF FN statement.
@ $27F7 label=SF_RUN
  $27F7 Get the first character of the name.
  $27F8 Reset bit 5 for upper case.
  $27FA Copy the name to #REGb.
  $27FB Get the next character.
  $27FC,c2 Subtract 24 hex, the code for '$'.
  $27FE Copy the result to #REGc (zero for a string, non-zero for a numerical function).
  $27FF Jump if non-zero: numerical function.
  $2801 Get the next character, the '('.
@ $2802 label=SF_ARGMT1
  $2802 Get 1st character of 1st argument.
  $2803 Save the pointer to it on the stack.
  $2804 Point to the start of the program.
  $2807 Go back one location.
@ $2808 keep
@ $2808 label=SF_FND_DF
  $2808 The search will be for 'DEF FN'.
  $280B Save the name and 'string status'.
  $280C Search the program now.
  $280F Restore the name and status.
  $2810 Jump if a DEF FN statement found.
N $2812 Report P - FN without DEF.
@ $2812 label=REPORT_P
M $2812,2 Call the error handling routine.
B $2813,1
N $2814 When a DEF FN statement is found, the name and status of the two functions are compared; if they do not match, the search is resumed.
@ $2814 label=SF_CP_DEF
  $2814 Save the pointer to the DEF FN character in case the search has to be resumed.
  $2815 Get the name of the DEF FN function.
  $2818 Reset bit 5 for upper case.
  $281A Does it match the FN name?
  $281B Jump if it does not match.
  $281D Get the next character in the DEF FN.
  $2820,c2 Subtract 24 hex, the code for '$'.
  $2822 Compare the status with that of FN.
  $2823 Jump if complete match now found.
@ $2825 label=SF_NOT_FD
  $2825 Restore the pointer to the 'DEF FN'.
  $2826 Step back one location.
@ $2827 keep
  $2827 Use the search routine to find the end of the DEF FN statement, preparing for the next search; save the name and status meanwhile.
  $282F Jump back for a further search.
N $2831 iii. The correct DEF FN statement has now been found. The arguments of the FN statement will be evaluated by repeated calls of #R$24FB, and their 5 byte values (or parameters, for strings) will be inserted into the DEF FN statement in the spaces made there at syntax checking. #REGhl will be used to point along the DEF FN statement (calling #R$28AB as needed) while CH-ADD points along the FN statement (calling #R$0020 as needed).
@ $2831 label=SF_VALUES
  $2831 If #REGhl is now pointing to a '$', move on to the '('.
  $2835 Discard the pointer to 'DEF FN'.
  $2836 Get the pointer to the first argument of FN, and copy it to CH-ADD.
  $283B Move past the '(' now.
  $283E Save this pointer on the stack.
  $283F,c2 Is it pointing to a ')'?
  $2841 If so, jump: FN has no arguments.
@ $2843 label=SF_ARG_LP
  $2843 Point to the next code.
  $2844 Put the code into #REGa.
  $2845 Is it the 'number marker' code, 0E hex?
  $2847 Set bit 6 of #REGd for a numerical argument.
  $2849 Jump on zero: numerical argument.
  $284B Now ensure that #REGhl is pointing to the '$' character (not e.g. to a control code).
  $284F #REGhl now points to the 'number marker'.
  $2850 Bit 6 of #REGd is reset: string argument.
@ $2852 label=SF_ARG_VL
  $2852 Point to the 1st of the 5 bytes in DEF FN.
  $2853 Save this pointer on the stack.
  $2854 Save the 'string status' of the argument.
  $2855 Now evaluate the argument.
  $2858 Get the no./string flag into #REGa.
  $2859 Test bit 6 of it against the result of #R$24FB.
  $285E Give report Q if they did not match.
  $2860 Get the pointer to the first of the 5 spaces in DEF FN into #REGde.
  $2862 Point #REGhl at STKEND.
@ $2865 keep
  $2865 #REGbc will count 5 bytes to be moved.
  $2868 First, decrease STKEND by 5, so deleting the 'last value' from the stack.
  $286D Copy the 5 bytes into the spaces in DEF FN.
  $286F Point #REGhl at the next code.
  $2870 Ensure that #REGhl points to the character after the 5 bytes.
  $2874,c2 Is it a ')'?
  $2876 Jump if it is: no more arguments in the DEF FN statement.
  $2878 It is a ',': save the pointer to it.
  $2879 Get the character after the last argument that was evaluated from FN.
  $287A,4,c2,2 If it is not a ',' jump: mismatched arguments of FN and DEF FN.
  $287E Point CH-ADD to the next argument of FN.
  $287F Point #REGhl to the ',' in DEF FN again.
  $2880 Move #REGhl on to the next argument in DEF FN.
  $2883 Jump back to consider this argument.
@ $2885 label=SF_R_BR_2
  $2885 Save the pointer to the ')' in DEF FN.
  $2886 Get the character after the last argument in FN.
  $2887,c2 Is it a ')'?
  $2889 If so, jump to evaluate the function; but if not, give report Q.
N $288B Report Q - Parameter error.
@ $288B label=REPORT_Q
M $288B,2 Call the error handling routine.
B $288C,1
N $288D iv. Finally, the function itself is evaluated by calling #R$24FB, after first setting DEFADD to hold the address of the arguments as they occur in the DEF FN statement. This ensures that #R$28B2, when called by #R$24FB, will first search these arguments for the required values, before making a search of the variables area.
@ $288D label=SF_VALUE
  $288D Restore pointer to ')' in DEF FN.
  $288E Get this pointer into #REGhl.
  $288F Insert it into CH-ADD.
  $2892 Get the old value of DEFADD.
  $2895 Stack it, and get the start address of the arguments area of DEF FN into DEFADD.
  $2899 Save address of ')' in FN.
  $289A Move CH-ADD on past ')' and '=' to the start of the expression for the function in DEF FN.
  $289C Now evaluate the function.
  $289F Restore the address of ')' in FN.
  $28A0 Store it in CH-ADD.
  $28A3 Restore original value of DEFADD.
  $28A4 Put it back into DEFADD.
  $28A7 Get the next character in the BASIC line.
  $28A8 Jump back to continue scanning.
@ $28AB label=FN_SKPOVR
c $28AB THE 'FUNCTION SKIPOVER' SUBROUTINE
D $28AB This subroutine is used by #R$27BD and by #R$2951 to move #REGhl along the DEF FN statement while leaving CH-ADD undisturbed, as it points along the FN statement.
  $28AB Point to the next code in the statement.
  $28AC Copy the code to #REGa.
  $28AD Jump back to skip over it if it is a control code or a space.
  $28B1 Finished.
@ $28B2 label=LOOK_VARS
c $28B2 THE 'LOOK-VARS' SUBROUTINE
D $28B2 This subroutine is called whenever a search of the variables area or of the arguments of a DEF FN statement is required. The subroutine is entered with the system variable CH-ADD pointing to the first letter of the name of the variable whose location is being sought. The name will be in the program area or the work space. The subroutine initially builds up a discriminator byte, in the #REGc register, that is based on the first letter of the variable's name. Bits 5 and 6 of this byte indicate the type of the variable that is being handled.
D $28B2 The #REGb register is used as a bit register to hold flags.
  $28B2 Presume a numeric variable.
  $28B6 Get the first character into #REGa.
  $28B7 Is it alphabetic?
  $28BA Give an error report if it is not so.
  $28BD Save the pointer to the first letter.
  $28BE Transfer bits 0 to 4 of the letter to the #REGc register; bits 5 and 7 are always reset.
  $28C1 Get the second character into #REGa.
  $28C2 Save this pointer also.
  $28C3,c2 Is the second character a '('?
  $28C5 Separate arrays of numbers.
  $28C7 Now set bit 6.
  $28C9,c2 Is the second character a '$'?
  $28CB Separate all the strings.
  $28CD Now set bit 5.
  $28CF If the variable's name has only one character then jump forward.
N $28D4 Now find the end character of a name that has more than one character.
@ $28D4 label=V_CHAR
  $28D4 Is the character alphanumeric?
  $28D7 Jump out of the loop when the end of the name is found.
  $28D9 Mark the discriminator byte.
  $28DB Get the next character.
  $28DC Go back to test it.
N $28DE Simple strings and arrays of strings require that bit 6 of FLAGS is reset.
@ $28DE label=V_STR_VAR
  $28DE Step CH-ADD past the '$'.
  $28DF Reset bit 6 to indicate a string.
N $28E3 If DEFADD-hi is non-zero, indicating that a 'function' (a 'FN') is being evaluated, and if in 'run-time', a search will be made of the arguments in the DEF FN statement.
@ $28E3 label=V_TEST_FN
  $28E3 Is DEFADD-hi zero?
  $28E7 If so, jump forward.
  $28E9 In 'run-time'?
  $28EC If so, jump forward to search the DEF FN statement.
N $28EF Otherwise (or if the variable was not found in the DEF FN statement) a search of variables area will be made, unless syntax is being checked.
@ $28EF label=V_RUN_SYN
  $28EF Copy the discriminator byte to the #REGb register.
  $28F0 Jump forward if in 'run-time'.
  $28F5 Move the discriminator to #REGa.
  $28F6 Drop the character code part.
  $28F8 Indicate syntax by setting bit 7.
  $28FA Restore the discriminator.
  $28FB Jump forward to continue.
N $28FD A BASIC line is being executed so make a search of the variables area.
@ $28FD label=V_RUN
  $28FD Pick up the VARS pointer.
N $2900 Now enter a loop to consider the names of the existing variables.
@ $2900 label=V_EACH
  $2900 The first letter of each existing variable.
  $2901 Match on bits 0 to 6.
  $2903 Jump when the '80-byte' is reached.
  $2905 The actual comparison.
  $2906 Jump forward if the first characters do not match.
  $2908 Rotate #REGa leftwards and then double it to test bits 5 and 6.
  $290A Strings and array variables.
  $290D Simple numeric and FOR-NEXT variables.
N $290F Long names are required to be matched fully.
  $290F Take a copy of the pointer to the second character.
  $2911 Save the first letter pointer.
@ $2912 label=V_MATCHES
  $2912 Consider the next character.
@ $2913 label=V_SPACES
  $2913 Fetch each character in turn.
  $2914 Point to the next character.
  $2915,c2 Is the character a 'space'?
  $2917 Ignore the spaces.
  $2919 Set bit 5 so as to match lower and upper case letters.
  $291B Make the comparison.
  $291C Back for another character if it does match.
  $291E Will it match with bit 7 set?
  $2920 Try it.
  $2921 Jump forward if the 'last characters' do not match.
  $2923 Check that the end of the name has been reached before jumping forward.
N $2929 In all cases where the names fail to match the #REGhl register pair has to be made to point to the next variable in the variables area.
@ $2929 label=V_GET_PTR
  $2929 Fetch the pointer.
@ $292A label=V_NEXT
  $292A Save #REGb and #REGc briefly.
  $292B #REGde is made to point to the next variable.
  $292E Switch the two pointers.
  $292F Get #REGb and #REGc back.
  $2930 Go around the loop again.
N $2932 Come here if no entry was found with the correct name.
@ $2932 label=V_80_BYTE
  $2932 Signal 'variable not found'.
N $2934 Come here if checking syntax.
@ $2934 label=V_SYNTAX
  $2934 Drop the pointer to the second character.
  $2935 Fetch the present character.
  $2936,c2 Is it a '('?
  $2938 Jump forward if so.
  $293A Indicate not dealing with an array and jump forward.
N $293E Come here when an entry with the correct name was found.
@ $293E label=V_FOUND_1
  $293E Drop the saved variable pointer.
@ $293F label=V_FOUND_2
  $293F Drop the second character pointer.
  $2940 Drop the first letter pointer.
  $2941 Save the 'last' letter pointer.
  $2942 Fetch the current character.
N $2943 If the matching variable name has more than a single letter then the other characters must be passed over.
N $2943 Note: this appears to have been done already at #R$28D4.
@ $2943 label=V_PASS
  $2943 Is it alphanumeric?
  $2946 Jump when the end of the name has been found.
  $2948 Fetch the next character.
  $2949 Go back and test it.
N $294B The exit-parameters are now set.
@ $294B label=V_END
  $294B #REGhl holds the pointer to the letter of a short name or the 'last' character of a long name.
  $294C Rotate the whole register.
  $294E Specify the state of bit 6.
  $2950 Finished.
E $28B2 The exit-parameters for the subroutine can be summarised as follows.
E $28B2 The system variable CH-ADD points to the first location after the name of the variable as it occurs in the BASIC line.
E $28B2 When 'variable not found':
E $28B2 #LIST { The carry flag is set. } { The zero flag is set only when the search was for an array variable. } { The #REGhl register pair points to the first letter of the name of the variable as it occurs in the BASIC line. } LIST#
E $28B2 When 'variable found':
E $28B2 #LIST { The carry flag is reset. } { The zero flag is set for both simple string variables and all array variables. } { The #REGhl register pair points to the letter of a 'short' name, or the last character of a 'long' name, of the existing entry that was found in the variables area. } LIST#
E $28B2 In all cases bits 5 and 6 of the #REGc register indicate the type of variable being handled. Bit 7 is the complement of the SYNTAX/RUN flag. But only when the subroutine is used in 'runtime' will bits 0 to 4 hold the code of the variable's letter.
E $28B2 In syntax time the return is always made with the carry flag reset. The zero flag is set for arrays and reset for all other variables, except that a simple string name incorrectly followed by a '$' sets the zero flag and, in the case of SAVE "name" DATA a$(), passes syntax as well.
@ $2951 label=STK_F_ARG
c $2951 THE 'STACK FUNCTION ARGUMENT' SUBROUTINE
D $2951 This subroutine is called by #R$28B2 when DEFADD-hi is non-zero, to make a search of the arguments area of a DEF FN statement, before searching in the variables area. If the variable is found in the DEF FN statement, then the parameters of a string variable are stacked and a signal is given that there is no need to call #R$2996. But it is left to #R$24FB to stack the value of a numerical variable at #R$26DA in the usual way.
  $2951 Point to the first character in the arguments area and put it into #REGa.
  $2955,c2 Is it a ')'?
  $2957 Jump to search the variables area.
@ $295A label=SFA_LOOP
  $295A Get the next argument in the loop.
  $295B Set bits 5 and 6, assuming a simple numeric variable; copy it to #REGb.
  $295E Point to the next code.
  $295F Put it into the #REGa register.
  $2960 Is it the 'number marker' code 0E hex?
  $2962 Jump if so: numeric variable.
  $2964 Ensure that #REGhl points to the character, not to a space or control code.
  $2968 #REGhl now points to the 'number marker'.
  $2969 Reset bit 5 of #REGb: string variable.
@ $296B label=SFA_CP_VR
  $296B Get the variable name into #REGa.
  $296C Is it the one we are looking for?
  $296D Jump if it matches.
  $296F Now pass over the 5 bytes of the floating-point number or string parameters to get to the next argument.
  $2974 Pass on to the next character.
  $2977,c2 Is it a ')'?
  $2979 If so, jump to search the variables area.
  $297C Point to the next argument.
  $297F Jump back to consider it.
N $2981 A match has been found. The parameters of a string variable are stacked, avoiding the need to call #R$2996.
@ $2981 label=SFA_MATCH
  $2981 Test for a numeric variable.
  $2983 Jump if the variable is numeric; #R$24FB will stack it.
  $2985 Point to the first of the 5 bytes to be stacked.
  $2986 Point #REGde to STKEND.
  $298A Stack the 5 bytes.
  $298D Point #REGhl to the new position of STKEND, and reset the system variable.
@ $2991 label=SFA_END
  $2991 Discard the #R$28B2 pointers (second and first character pointers).
  $2993 Return from the search with both the carry and zero flags reset - signalling that a call #R$2996 is not required.
  $2995 Finished.
@ $2996 label=STK_VAR
c $2996 THE 'STK-VAR' SUBROUTINE
D $2996 This subroutine is used either to find the parameters that define an existing string entry in the variables area, or to return in the #REGhl register pair the base address of a particular element or an array of numbers. When called from #R$2C02 the subroutine only checks the syntax of the BASIC statement.
D $2996 Note that the parameters that define a string may be altered by calling #R$2A52 if this should be specified.
D $2996 Initially the #REGa and the #REGb registers are cleared and bit 7 of the #REGc register is tested to determine whether syntax is being checked.
  $2996 Clear the array flag.
  $2997 Clear the #REGb register for later.
  $2998 Jump forward if syntax is being checked.
N $299C Next, simple strings are separated from array variables.
  $299C Jump forward if dealing with an array variable.
N $29A0 The parameters for a simple string are readily found.
  $29A0 Signal 'a simple string'.
@ $29A1 label=SV_SIMPLE
  $29A1 Move along the entry.
  $29A2 Pick up the low length counter.
  $29A3 Advance the pointer.
  $29A4 Pick up the high length pointer.
  $29A5 Advance the pointer.
  $29A6 Transfer the pointer to the actual string.
  $29A7 Pass these parameters to the calculator stack.
  $29AA Fetch the present character and jump forward to see if a 'slice' is required.
N $29AE The base address of an element in an array is now found. Initially the 'number of dimensions' is collected.
@ $29AE label=SV_ARRAYS
  $29AE Step past the length bytes.
  $29B1 Collect the 'number of dimensions'.
  $29B2 Jump forward if handling an array of numbers.
N $29B6 If an array of strings has its 'number of dimensions' equal to '1' then such an array can be handled as a simple string.
  $29B6 Decrease the 'number of dimensions' and jump if the number is now zero.
N $29B9 Next a check is made to ensure that in the BASIC line the variable is followed by a subscript.
  $29B9 Save the pointer in #REGde.
  $29BA Get the present character.
  $29BB,c2 Is it a '('?
  $29BD Report the error if it is not so.
  $29BF Restore the pointer.
N $29C0 For both numeric arrays and arrays of strings the variable pointer is transferred to the #REGde register pair before the subscript is evaluated.
@ $29C0 label=SV_PTR
  $29C0 Pass the pointer to #REGde.
  $29C1 Jump forward.
N $29C3 The following loop is used to find the parameters of a specified element within an array. The loop is entered at the mid-point - #R$29E7 - where the element count is set to zero.
N $29C3 The loop is accessed #REGb times, this being, for a numeric array, equal to the number of dimensions that are being used, but for an array of strings #REGb is one less than the number of dimensions in use as the last subscript is used to specify a 'slice' of the string.
@ $29C3 label=SV_COMMA
  $29C3 Save the counter.
  $29C4 Get the present character.
  $29C5 Restore the counter.
  $29C6,c2 Is the present character a ','?
  $29C8 Jump forward to consider another subscript.
  $29CA If a line is being executed then there is an error.
  $29CE Jump forward if dealing with an array of strings.
  $29D2,c2 Is the present character a ')'?
  $29D4 Report an error if not so.
  $29D6 Advance CH-ADD.
  $29D7 Return as the syntax is correct.
N $29D8 For an array of strings the present subscript may represent a 'slice', or the subscript for a 'slice' may yet be present in the BASIC line.
@ $29D8 label=SV_CLOSE
  $29D8,c2 Is the present character a ')'?
  $29DA Jump forward and check whether there is another subscript.
  $29DC Is the present character a 'TO'?
  $29DE It must not be otherwise.
@ $29E0 label=SV_CH_ADD
  $29E0 Get the present character.
  $29E1 Point to the preceding character and set CH-ADD.
  $29E5 Evaluate the 'slice'.
N $29E7 Enter the loop here.
@ $29E7 keep
@ $29E7 label=SV_COUNT
  $29E7 Set the counter to zero.
@ $29EA label=SV_LOOP
  $29EA Save the counter briefly.
  $29EB Advance CH-ADD.
  $29EC Restore the counter.
  $29ED Fetch the discriminator byte.
  $29EE Jump unless checking the syntax for an array of strings.
  $29F2 Get the present character.
  $29F3,c2 Is it a ')'?
  $29F5 Jump forward as finished counting elements.
  $29F7 Is to 'TO'?
  $29F9 Jump back if dealing with a 'slice'.
@ $29FB label=SV_MULT
  $29FB Save the dimension-number counter and the discriminator byte.
  $29FC Save the element-counter.
  $29FD Get a dimension-size into #REGde.
  $2A00 The counter moves to #REGhl and the variable pointer is stacked.
  $2A01 The counter moves to #REGde and the dimension-size to #REGhl.
  $2A02 Evaluate the next subscript.
  $2A05 Give an error if out of range.
  $2A07 The result of the evaluation is decremented as the counter is to count the elements occurring before the specified element.
  $2A08 Multiply the counter by the dimension-size.
  $2A0B Add the result of #R$2ACC to the present counter.
  $2A0C Fetch the variable pointer.
  $2A0D Fetch the dimension-number and the discriminator byte.
  $2A0E Keep going round the loop until #REGb equals zero.
N $2A10 The SYNTAX/RUN flag is checked before arrays of strings are separated from arrays of numbers.
  $2A10 Report an error if checking syntax at this point.
@ $2A12 label=SV_RPT_C
  $2A14 Save the counter.
  $2A15 Jump forward if handling an array of strings.
N $2A19 When dealing with an array of numbers the present character must be a ')'.
  $2A19 Transfer the variable pointer to the #REGbc register pair.
  $2A1B Fetch the present character.
  $2A1C,c2 Is it a ')'?
  $2A1E Jump past the error report unless it is needed.
N $2A20 Report 3 - Subscript out of range.
@ $2A20 label=REPORT_3
M $2A20,2 Call the error handling routine.
B $2A21,1
N $2A22 The address of the location before the actual floating-point form can now be calculated.
@ $2A22 label=SV_NUMBER
  $2A22 Advance CH-ADD.
  $2A23 Fetch the counter.
@ $2A24 keep
  $2A24 There are 5 bytes to each element in an array of numbers.
  $2A27 Compute the total number of bytes before the required element.
  $2A2A Make #REGhl point to the location before the required element.
  $2A2B Return with this address.
N $2A2C When dealing with an array of strings the length of an element is given by the last 'dimension-size'. The appropriate parameters are calculated and then passed to the calculator stack.
@ $2A2C label=SV_ELEM
  $2A2C Fetch the last dimension-size.
  $2A2F The variable pointer goes on the stack and the counter to #REGhl.
  $2A30 Multiply 'counter' by 'dimension-size'.
  $2A33 Fetch the variable pointer.
  $2A34 This gives #REGhl pointing to the location before the string.
  $2A35 So point to the actual 'start'.
  $2A36 Transfer the last dimension-size to #REGbc to form the 'length'.
  $2A38 Move the 'start' to #REGde.
  $2A39 Pass these parameters to the calculator stack. Note: the first parameter is zero indicating a string from an 'array of strings' and hence the existing entry is not to be reclaimed.
N $2A3C There are three possible forms of the last subscript:
N $2A3C #LIST { A$(2,4 TO 8) } { A$(2)(4 TO 8) } { A$(2) } LIST#
N $2A3C The last of these is the default form and indicates that the whole string is required.
  $2A3C Get the present character.
  $2A3D,c2 Is it a ')'?
  $2A3F Jump if it is so.
  $2A41,c2 Is it a ','?
  $2A43 Report the error if not so.
@ $2A45 label=SV_SLICE
  $2A45 Use #R$2A52 to modify the set of parameters.
@ $2A48 label=SV_DIM
  $2A48 Fetch the next character.
@ $2A49 label=SV_SLICE2
  $2A49,c2 Is It a '('?
  $2A4B Jump back if there is a 'slice' to be considered.
N $2A4D When finished considering the last subscript a return can be made.
  $2A4D Signal - string result.
  $2A51 Return with the parameters of the required string forming a 'last value' on the calculator stack.
@ $2A52 label=SLICING
c $2A52 THE 'SLICING' SUBROUTINE
D $2A52 The present string can be sliced using this subroutine. The subroutine is entered with the parameters of the string being present on the top of the calculator stack and in the registers #REGa, #REGb, #REGc, #REGd and #REGe. Initially the SYNTAX/RUN flag is tested and the parameters of the string are fetched only if a line is being executed.
  $2A52 Check the flag.
  $2A55 Take the parameters off the stack in 'run-time'.
N $2A58 The possibility of the 'slice' being '()' has to be considered.
  $2A58 Get the next character.
  $2A59,c2 Is it a ')'?
  $2A5B Jump forward if it is so.
N $2A5D Before proceeding the registers are manipulated as follows:
  $2A5D The 'start' goes on the machine stack.
  $2A5E The #REGa register is cleared and saved.
  $2A60 The 'length' is saved briefly.
@ $2A61 keep
  $2A61 Presume that the 'slice' is to begin with the first character.
  $2A64 Get the first character.
  $2A65 Pass the 'length' to #REGhl.
N $2A66 The first parameter of the 'slice' is now evaluated.
  $2A66 Is the present character a 'TO'?
  $2A68 The first parameter, by default, will be '1' if the jump is taken.
  $2A6A At this stage #REGa is zero.
  $2A6B #REGbc is made to hold the first parameter. #REGa will hold +FF if there has been an 'out of range' error.
  $2A6E Save the value anyway.
  $2A6F Transfer the first parameter to #REGde.
  $2A71 Save the 'length' briefly.
  $2A72 Get the present character.
  $2A73 Restore the 'length'.
  $2A74 Is the present character a 'TO'?
  $2A76,4,2,c2 Jump forward to consider the second parameter if it is so; otherwise show that there is a closing bracket.
@ $2A7A label=SL_RPT_C
N $2A7D At this point a 'slice' of a single character has been identified. e.g. A$(4).
  $2A7D The last character of the 'slice' is also the first character.
  $2A7F Jump forward.
N $2A81 The second parameter of a 'slice' is now evaluated.
@ $2A81 label=SL_SECOND
  $2A81 Save the 'length' briefly.
  $2A82 Get the next character.
  $2A83 Restore the 'length'.
  $2A84,c2 Is the present character a ')'?
  $2A86 Jump if there is not a second parameter.
  $2A88 If the first parameter was in range #REGa will hold zero, otherwise +FF.
  $2A89 Make #REGbc hold the second parameter.
  $2A8C Save the 'error register'.
  $2A8D Get the present character.
  $2A8E Pass the result obtained from #R$2ACD to the #REGhl register pair.
  $2A90,4,c2,2 Check that there is a closing bracket now.
N $2A94 The 'new' parameters are now defined.
@ $2A94 label=SL_DEFINE
  $2A94 Fetch the 'error register'.
  $2A95 The second parameter goes on the stack and the 'start' goes to #REGhl.
  $2A96 The first parameter is added to the 'start'.
  $2A97 Go back a location to get it correct.
  $2A98 The 'new start' goes on the stack and the second parameter goes to #REGhl.
  $2A99 Subtract the first parameters from the second to find the length of the 'slice'.
@ $2A9C keep
  $2A9C Initialise the 'new length'.
  $2A9F A negative 'slice' is a 'null string' rather than an error condition.
  $2AA1 Allow for the inclusive byte.
  $2AA2 Only now test the 'error register'.
  $2AA3 Jump if either parameter was out of range for the string.
  $2AA6 Transfer the 'new length' to #REGbc.
@ $2AA8 label=SL_OVER
  $2AA8 Get the 'new start'.
  $2AA9 Ensure that a string is still indicated.
@ $2AAD label=SL_STORE
  $2AAD Return at this point if checking syntax; otherwise continue into #R$2AB1.
@ $2AB1 label=STK_ST_0
c $2AB1 THE 'STK-STORE' SUBROUTINE
D $2AB1 This subroutine passes the values held in the #REGa, #REGb, #REGc, #REGd and #REGe registers to the calculator stack. The stack thereby grows in size by 5 bytes with every call to this subroutine.
D $2AB1 The subroutine is normally used to transfer the parameters of strings but it is also used by #R$2D2B and #R$2DC1 to transfer 'small integers' to the stack.
D $2AB1 Note that when storing the parameters of a string the first value stored (coming from the #REGa register) will be a zero if the string comes from an array of strings or is a 'slice' of a string. The value will be '1' for a complete simple string. This 'flag' is used in the #R$2AFF command routine when the '1' signals that the old copy of the string is to be 'reclaimed'.
  $2AB1 Signal - a string from an array of strings or a 'sliced' string.
@ $2AB2 label=STK_STO
  $2AB2 Ensure the flag indicates a string result.
@ $2AB6 label=STK_STORE
  $2AB6 Save #REGb and #REGc briefly.
  $2AB7 Is there room for 5 bytes? Do not return here unless there is room available.
  $2ABA Restore #REGb and #REGc.
  $2ABB Fetch the address of the first location above the present stack.
  $2ABE Transfer the first byte.
  $2ABF Step on.
  $2AC0 Transfer the second and third bytes; for a string these will be the 'start'.
  $2AC3 Step on.
  $2AC4 Transfer the fourth and fifth bytes; for a string these will be the 'length'.
  $2AC7 Step on so as to point to the location above the stack.
  $2AC8 Save this address in STKEND and return.
@ $2ACC label=INT_EXP1
c $2ACC THE 'INT-EXP' SUBROUTINE
D $2ACC This subroutine returns the result of evaluating the 'next expression' as an integer value held in the #REGbc register pair. The subroutine also tests this result against a limit-value supplied in the #REGhl register pair. The carry flag becomes set if there is an 'out of range' error.
D $2ACC The #REGa register is used as an 'error register' and holds +00 if there is no 'previous error' and +FF if there has been one.
  $2ACC Clear the 'error register'.
@ $2ACD label=INT_EXP2
  $2ACD Save both the #REGde and #REGhl register pairs throughout.
  $2ACF Save the 'error register' briefly.
  $2AD0 The 'next expression' is evaluated to give a 'last value' on the calculator stack.
  $2AD3 Restore the 'error register'.
  $2AD4 Jump forward if checking syntax.
  $2AD9 Save the error register again.
  $2ADA The 'last value' is compressed Into #REGbc.
  $2ADD Error register to #REGd.
  $2ADE A 'next expression' that gives zero is always in error so jump forward if it is so.
  $2AE3 Take a copy of the limit-value. This will be a 'dimension-size', a 'DIM-limit' or a 'string length'.
  $2AE5 Now compare the result of evaluating the expression against the limit.
N $2AE8 The state of the carry flag and the value held in the #REGd register are now manipulated so as to give the appropriate value for the 'error register'.
@ $2AE8 label=I_CARRY
  $2AE8 Fetch the 'old error value'.
  $2AE9 Form the 'new error value': +00 if no error at any time, +FF or less if an 'out of range' error on this pass or on previous ones.
N $2AEB Restore the registers before returning.
@ $2AEB label=I_RESTORE
  $2AEB Restore #REGhl and #REGde.
  $2AED Return; 'error register' is the #REGa register.
@ $2AEE label=DE_DE_1
c $2AEE THE 'DE,(DE+1)' SUBROUTINE
D $2AEE This subroutine performs the construction 'LD DE,(DE+1)' and returns #REGhl pointing to '#REGde+2'.
  $2AEE Use #REGhl for the construction.
  $2AEF Point to '#REGde+1'.
  $2AF0 In effect - LD E,(DE+1).
  $2AF1 Point to '#REGde+2'.
  $2AF2 In effect - LD D,(DE+2).
  $2AF3 Finished.
@ $2AF4 label=GET_HLxDE
c $2AF4 THE 'GET-HL*DE' SUBROUTINE
D $2AF4 Unless syntax is being checked this subroutine calls #R$30A9 which performs the implied construction.
D $2AF4 Overflow of the 16 bits available in the #REGhl register pair gives the report 'out of memory'. This is not exactly the true situation but it implies that the memory is not large enough for the task envisaged by the programmer.
  $2AF4 Return directly if syntax is being checked.
  $2AF8 Perform the multiplication.
  $2AFB Report 'Out of memory'.
  $2AFE Finished.
@ $2AFF label=LET
c $2AFF THE 'LET' COMMAND ROUTINE
D $2AFF This is the actual assignment routine for the LET, READ and INPUT commands.
D $2AFF When the destination variable is a 'newly declared variable' then DEST will point to the first letter of the variable's name as it occurs in the BASIC line. Bit 1 of FLAGX will be set.
D $2AFF However if the destination variable 'exists already' then bit 1 of FLAGX will be reset and DEST will point for a numeric variable to the location before the five bytes of the 'old number', and for a string variable to the first location of the 'old string'. The use of DEST in this manner applies to simple variables and to elements of arrays.
D $2AFF Bit 0 of FLAGX is set if the destination variable is a 'complete' simple string variable. (Signalling - delete the old copy.) Initially the current value of DEST is collected and bit 1 of FLAGS tested.
  $2AFF Fetch the present address in DEST.
  $2B02 Jump if handling a variable that 'exists already'.
N $2B08 A 'newly declared variable' is being used. So first the length of its name is found.
@ $2B08 keep
  $2B08 Presume dealing with a numeric variable - 5 bytes.
N $2B0B Enter a loop to deal with the characters of a long name. Any spaces or colour codes in the name are ignored.
@ $2B0B label=L_EACH_CH
  $2B0B Add '1' to the counter for each character of a name.
@ $2B0C label=L_NO_SP
  $2B0C Move along the variable's name.
  $2B0D Fetch the 'present code'.
  $2B0E,4,c2,2 Jump back if it is a 'space'; thereby Ignoring spaces.
  $2B12 Jump forward if the code is +21 to +FF.
  $2B14 Accept, as a final code, those in the range +00 to +0F.
  $2B18 Also accept the range +16 to +1F.
  $2B1C Step past the control code after any of INK to OVER.
  $2B1D Jump back as these control codes are treated as spaces.
N $2B1F Separate 'numeric' and 'string' names.
  $2B1F Is the code alphanumeric?
  $2B22 If It is so then accept it as a character of a 'long' name.
  $2B24,c2 Is the present code a '$'?
  $2B26 Jump forward as handling a 'newly declared' simple string.
N $2B29 The 'newly declared numeric variable' presently being handled will require #REGbc spaces in the variables area for its name and its value. The room is made available and the name of the variable is copied over with the characters being 'marked' as required.
@ $2B29 label=L_SPACES
  $2B29 Copy the 'length' to #REGa.
  $2B2A Make #REGhl point to the '80-byte' at the end of the variables area.
  $2B2E Now open up the variables area. Note: in effect #REGbc spaces are made before the displaced '80-byte'.
  $2B31 Point to the first 'new' byte.
  $2B32 Make #REGde point to the second 'new' byte.
  $2B34 Save this pointer.
  $2B35 Fetch the pointer to the start of the name.
  $2B38 Make #REGde point to the first 'new' byte.
  $2B39 Make #REGb hold the 'number of extra letters' that are found in a 'long name'.
  $2B3C Jump forward if dealing with a variable with a 'short name'.
N $2B3E The 'extra' codes of a long name are passed to the variables area.
@ $2B3E label=L_CHAR
  $2B3E Point to each 'extra' code.
  $2B3F Fetch the code.
  $2B40 Accept codes from +21 to +FF; ignore codes +00 to +20.
  $2B44 Set bit 5, as for lower case letters.
  $2B46 Transfer the codes in turn to the 2nd 'new' byte onwards.
  $2B48 Go round the loop for all the 'extra' codes.
N $2B4A The last code of a 'long' name has to be ORed with +80.
  $2B4A Mark the code as required and overwrite the last code.
N $2B4D The first letter of the name of the variable being handled is now considered.
  $2B4D Prepare to mark the letter of a 'long' name.
@ $2B4F label=L_SINGLE
  $2B4F Fetch the pointer to the letter.
  $2B52 #REGa holds +00 for a 'short' name and +C0 for a 'long' name.
  $2B53 Set bit 5, as for lower case letters.
  $2B55 Drop the pointer now.
N $2B56 The subroutine #R$2BEA is now called to enter the 'letter' into its appropriate location.
  $2B56 Enter the letter and return with #REGhl pointing to 'new 80-byte'.
N $2B59 The 'last value' can now be transferred to the variables area. Note that at this point #REGhl always points to the location after the five locations allotted to the number.
@ $2B59 label=L_NUMERIC
N $2B59 A 'RST 28' instruction is used to call the calculator and the 'last value' is deleted. However this value is not overwritten.
  $2B59 Save the 'destination' pointer.
  $2B5A Use the calculator to move STKEND back five bytes.
B $2B5B,1 #R$33A1
B $2B5C,1 #R$369B
  $2B5D Restore the pointer.
@ $2B5E keep
  $2B5E Give the number a 'length' of five bytes.
  $2B61 Make #REGhl point to the first of the five locations and jump forward to make the actual transfer.
N $2B66 Come here if considering a variable that 'exists already'. First bit 6 of FLAGS is tested so as to separate numeric variables from string or array of string variables.
@ $2B66 label=L_EXISTS
  $2B66 Jump forward if handling any kind of string variable.
N $2B6C For numeric variables the 'new' number overwrites the 'old' number. So first #REGhl has to be made to point to the location after the five bytes of the existing entry. At present #REGhl points to the location before the five bytes.
@ $2B6C keep
  $2B6C The five bytes of a number + 1.
  $2B6F #REGhl now points 'after'.
  $2B70 Jump back to make the actual transfer.
N $2B72 The parameters of the string variable are fetched and complete simple strings separated from 'sliced' strings and array strings.
@ $2B72 label=L_DELETE
  $2B72 Fetch the 'start'. Note: this line is redundant.
  $2B75 Fetch the 'length'.
  $2B79 Jump if dealing with a complete simple string; the old string will need to be 'deleted' in this case only.
N $2B7F When dealing with a 'slice' of an existing simple string, a 'slice' of a string from an array of strings or a complete string from an array of strings there are two distinct stages involved. The first is to build up the 'new' string in the work space, lengthening or shortening it as required. The second stage is then to copy the 'new' string to its allotted room in the variables area.
N $2B7F However do nothing if the string has no 'length'.
  $2B7F Return if the string is a null string.
N $2B82 Then make the required number of spaces available in the work space.
  $2B82 Save the 'start' (DEST).
  $2B83 Make the necessary amount of room in the work space.
  $2B84 Save the pointer to the first location.
  $2B85 Save the 'length' for use later on.
  $2B86 Make #REGde point to the last location.
  $2B88 Make #REGhl point 'one past' the new locations.
  $2B89,c2 Enter a 'space' character.
  $2B8B Copy this character into all the new locations. Finish with #REGhl pointing to the first new location.
N $2B8D The parameters of the string being handled are now fetched from the calculator stack.
  $2B8D Save the pointer briefly.
  $2B8E Fetch the 'new' parameters.
  $2B91 Restore the pointer.
N $2B92 Note: at this point the required amount of room has been made available in the work space for the 'variable in assignment'; e.g. for the statement 'LET A$(4 TO 8)="abcdefg"' five locations have been made.
N $2B92 The parameters fetched above as a 'last value' represent the string that is to be copied into the new locations with Procrustean lengthening or shortening as required.
N $2B92 The length of the 'new' string is compared to the length of the room made available for it.
  $2B92 'Length' of new area to #REGhl. 'Pointer' to new area to stack.
  $2B93 Compare the two 'lengths' and jump forward if the 'new' string will fit into the room, i.e. no shortening required.
  $2B99 However modify the 'new' length if it is too long.
@ $2B9B label=L_LENGTH
  $2B9B 'Length' of new area to stack. 'Pointer' to new area to #REGhl.
N $2B9C As long as the new string is not a 'null string' it is copied into the work space. Procrustean lengthening is achieved automatically if the 'new' string is shorter than the room available for it.
  $2B9C 'Start' of new string to #REGhl. 'Pointer' to new area to #REGde.
  $2B9D Jump forward if the 'new' string is a 'null' string.
  $2BA1 Otherwise move the 'new' string to the work space.
N $2BA3 The values that have been saved on the machine stack are restored.
@ $2BA3 label=L_IN_W_S
  $2BA3 'Length' of new area.
  $2BA4 'Pointer' to new area.
  $2BA5 The start - the pointer to the 'variable in assignment' which was originally in DEST. #R$2BA6 is now used to pass the 'new' string to the variables area.
@ $2BA6 label=L_ENTER
N $2BA6 The following short subroutine is used to pass either a numeric value from the calculator stack, or a string from the work space, to its appropriate position in the variables area.
N $2BA6 The subroutine is therefore used for all except 'newly declared' simple strings and 'complete and existing' simple strings.
  $2BA6 Change the pointers over.
  $2BA7 Check once again that the length is not zero.
  $2BAA Save the destination pointer.
  $2BAB Move the numeric value or the string.
  $2BAD Return with the #REGhl register pair pointing to the first byte of the numeric value or the string.
@ $2BAF label=L_ADD
N $2BAF When handling a 'complete and existing' simple string the new string is entered as if it were a 'newly declared' simple string before the existing version is 'reclaimed'.
  $2BAF Make #REGhl point to the letter of the variable's name, i.e. DEST-3.
  $2BB2 Pick up the letter.
  $2BB3 Save the pointer to the 'existing version'.
  $2BB4 Save the 'length' of the 'existing string'.
  $2BB5 Use #R$2BC6 to add the new string to the variables area.
  $2BB8 Restore the 'length'.
  $2BB9 Restore the pointer.
  $2BBA Allow one byte for the letter and two bytes for the length.
  $2BBD Exit by jumping to #R$19E8 which will reclaim the whole of the existing version.
N $2BC0 'Newly declared' simple strings are handled as follows:
@ $2BC0 label=L_NEW
  $2BC0 Prepare for the marking of the variable's letter.
  $2BC2 Fetch the pointer to the letter.
  $2BC5 Mark the letter as required. #R$2BC6 is now used to add the new string to the variables area.
@ $2BC6 label=L_STRING
N $2BC6 The parameters of the 'new' string are fetched, sufficient room is made available for it and the string is then transferred.
  $2BC6 Save the variable's letter.
  $2BC7 Fetch the 'start' and the 'length' of the 'new' string.
  $2BCA Move the 'start' to #REGhl.
  $2BCB Make #REGhl point one past the string.
  $2BCC Save the 'length'.
  $2BCD Make #REGhl point to the end of the string.
  $2BCE Save the pointer briefly.
  $2BD1 Allow one byte for the letter and two bytes for the length.
  $2BD4 Make #REGhl point to the '80-byte' at the end of the variables area.
  $2BD8 Now open up the variables area. Note: in effect #REGbc spaces are made before the displaced '80-byte'.
  $2BDB Restore the pointer to the end of the 'new' string.
  $2BDE Make a copy of the length of the 'new' string.
  $2BE0 Add one to the length in case the 'new' string is a 'null' string.
  $2BE1 Now copy the 'new' string + one byte.
  $2BE3 Make #REGhl point to the byte that is to hold the high-length.
  $2BE5 Fetch the 'length'.
  $2BE6 Enter the high-length.
  $2BE7 Back one.
  $2BE8 Enter the low-length.
  $2BE9 Fetch the variable's letter.
@ $2BEA label=L_FIRST
N $2BEA The following subroutine is entered with the letter of the variable, suitably marked, in the #REGa register. The letter overwrites the 'old 80-byte' in the variables area. The subroutine returns with the #REGhl register pair pointing to the 'new 80-byte'.
  $2BEA Make #REGhl point to the 'old 80-byte'.
  $2BEB It is overwritten with the letter of the variable.
  $2BEC Make #REGhl point to the 'new 80-byte'.
  $2BF0 Finished with all the 'newly declared variables'.
@ $2BF1 label=STK_FETCH
c $2BF1 THE 'STK-FETCH' SUBROUTINE
D $2BF1 This important subroutine collects the 'last value' from the calculator stack. The five bytes can be either a floating-point number, in 'short' or 'long' form, or set of parameters that define a string.
  $2BF1 Get STKEND.
  $2BF4 Back one.
  $2BF5 The fifth value.
  $2BF6 Back one.
  $2BF7 The fourth value.
  $2BF8 Back one.
  $2BF9 The third value.
  $2BFA Back one.
  $2BFB The second value.
  $2BFC Back one.
  $2BFD The first value.
  $2BFE Reset STKEND to its new position.
  $2C01 Finished.
@ $2C02 label=DIM
c $2C02 THE 'DIM' COMMAND ROUTINE
D $2C02 The address of this routine is found in the #R$1AA2(parameter table).
D $2C02 This routine establishes new arrays in the variables area. The routine starts by searching the existing variables area to determine whether there is an existing array with the same name. If such an array is found then it is 'reclaimed' before the new array is established.
D $2C02 A new array will have all its elements set to zero if it is a numeric array, or to 'spaces' if it is an array of strings.
  $2C02 Search the variables area.
@ $2C05 label=D_RPORT_C
  $2C05 Give report C as there has been an error.
  $2C08 Jump forward if in 'run time'.
  $2C0D Test the syntax for string arrays as if they were numeric.
  $2C0F Check the syntax of the parenthesised expression.
  $2C12 Move on to consider the next statement as the syntax was satisfactory.
N $2C15 An 'existing array' is reclaimed.
@ $2C15 label=D_RUN
  $2C15 Jump forward if there is no 'existing array'.
  $2C17 Save the discriminator byte.
  $2C18 Find the start of the next variable.
  $2C1B Reclaim the 'existing array'.
  $2C1E Restore the discriminator byte.
N $2C1F The initial parameters of the new array are found.
@ $2C1F label=D_LETTER
  $2C1F Set bit 7 in the discriminator byte.
  $2C21 Make the dimension counter zero.
  $2C23 Save the counter and the discriminator byte.
@ $2C24 keep
  $2C24 The #REGhl register pair is to hold the size of the elements in the array: '1' for a string array, '5' for a numeric array.
@ $2C2D label=D_SIZE
  $2C2D Element size to #REGde.
N $2C2E The following loop is accessed for each dimension that is specified in the parenthesised expression of the DIM statement. The total number of bytes required for the elements of the array is built up in the #REGde register pair.
@ $2C2E label=D_NO_LOOP
  $2C2E Advance CH-ADD on each pass.
  $2C2F Set a 'limit value'.
  $2C31 Evaluate a parameter.
  $2C34 Give an error if 'out of range'.
  $2C37 Fetch the dimension counter and the discriminator byte.
  $2C38 Save the parameter on each pass through the loop.
  $2C39 Increase the dimension counter on each pass also.
  $2C3A Restack the dimension counter and the discriminator byte.
  $2C3B The parameter is moved to the #REGhl register pair.
  $2C3D The byte total is built up in #REGhl and then transferred to #REGde.
  $2C41,5,1,c2,2 Get the present character and go around the loop again if there is another dimension.
N $2C46 At this point the #REGde register pair indicates the number of bytes required for the elements of the new array and the size of each dimension is stacked, on the machine stack.
N $2C46 Now check that there is indeed a closing bracket to the parenthesised expression.
  $2C46,c2 Is it a ')'?
  $2C48 Jump back if not so.
  $2C4A Advance CH-ADD past it.
N $2C4B Allowance is now made for the dimension sizes.
  $2C4B Fetch the dimension counter and the discriminator byte.
  $2C4C Pass the discriminator byte to the #REGa register for later.
  $2C4D Move the counter to #REGl.
  $2C4E Clear the #REGh register.
  $2C50 Increase the dimension counter by two and double the result and form the correct overall length for the variable by adding the element byte total.
  $2C54 Give the report 'Out of memory' if required.
  $2C57 Save the element byte total.
  $2C58 Save the dimension counter and the discriminator byte.
  $2C59 Save the overall length also.
  $2C5A Move the overall length to #REGbc.
N $2C5C The required amount of room is made available for the new array at the end of the variables area.
  $2C5C Make the #REGhl register pair point to the '80-byte'.
  $2C60 The room is made available.
  $2C63 #REGhl is made to point to the first new location.
N $2C64 The parameters are now entered.
  $2C64 The letter, suitably marked, is entered first.
  $2C65 The overall length is fetched and decreased by '3'.
  $2C69 Advance #REGhl.
  $2C6A Enter the low length.
  $2C6B Advance #REGhl.
  $2C6C Enter the high length.
  $2C6D Fetch the dimension counter.
  $2C6E Move it to the #REGa register.
  $2C6F Advance #REGhl.
  $2C70 Enter the dimension count.
N $2C71 The elements of the new array are now 'cleared'.
  $2C71 #REGhl is made to point to the last location of the array and #REGde to the location before that one.
  $2C74,8,6,c2 Enter a zero into the last location but overwrite it with 'space' if dealing with an array of strings.
@ $2C7C label=DIM_CLEAR
  $2C7C Fetch the element byte total.
  $2C7D Clear the array + one extra location.
N $2C7F The 'dimension sizes' are now entered.
@ $2C7F label=DIM_SIZES
  $2C7F Get a dimension size.
  $2C80 Enter the high byte.
  $2C81 Back one.
  $2C82 Enter the low byte.
  $2C83 Back one.
  $2C84 Decrease the dimension counter.
  $2C85 Repeat the operation until all the dimensions have been considered; then return.
@ $2C88 label=ALPHANUM
c $2C88 THE 'ALPHANUM' SUBROUTINE
D $2C88 This subroutine returns with the carry flag set if the present value of the #REGa register denotes a valid digit or letter.
  $2C88 Test for a digit; carry will be reset for a digit.
  $2C8B Complement the carry flag.
  $2C8C Return if a digit; otherwise continue on into #R$2C8D.
@ $2C8D label=ALPHA
c $2C8D THE 'ALPHA' SUBROUTINE
D $2C8D This subroutine returns with the carry flag set if the present value of the #REGa register denotes a valid letter of the alphabet.
  $2C8D,c2 Test against 41 hex, the code for 'A'.
  $2C8F Complement the carry flag.
  $2C90 Return if not a valid character code.
  $2C91 Test against 5B hex, 1 more than the code for 'Z'.
  $2C93 Return if an upper case letter.
  $2C94,c2 Test against 61 hex, the code for 'a'.
  $2C96 Complement the carry flag.
  $2C97 Return if not a valid character code.
  $2C98 Test against 7B hex, 1 more than the code for 'z'.
  $2C9A Finished.
@ $2C9B label=DEC_TO_FP
c $2C9B THE 'DECIMAL TO FLOATING POINT' SUBROUTINE
D $2C9B As part of syntax checking decimal numbers that occur in a BASIC line are converted to their floating-point forms. This subroutine reads the decimal number digit by digit and gives its result as a 'last value' on the calculator stack. But first it deals with the alternative notation BIN, which introduces a sequence of 0's and 1's giving the binary representation of the required number.
  $2C9B Is the character a 'BIN'?
  $2C9D Jump if it is not 'BIN'.
@ $2C9F keep
  $2C9F Initialise result to zero in #REGde.
@ $2CA2 label=BIN_DIGIT
  $2CA2 Get the next character.
  $2CA3,c2 Subtract the character code for '1'.
  $2CA5 0 now gives 0 with carry set; 1 gives 0 with carry reset.
  $2CA7 Any other character causes a jump to #R$2CB3 and will be checked for syntax during or after scanning.
  $2CA9 Result so far to #REGhl now.
  $2CAA Complement the carry flag.
  $2CAB Shift the result left, with the carry going to bit 0.
  $2CAD Report overflow if more than 65535.
  $2CB0 Return the result so far to #REGde.
  $2CB1 Jump back for next 0 or 1.
@ $2CB3 label=BIN_END
  $2CB3 Copy result to #REGbc for stacking.
  $2CB5 Jump forward to stack the result.
N $2CB8 For other numbers, first any integer part is converted; if the next character is a decimal, then the decimal fraction is considered.
@ $2CB8 label=NOT_BIN
  $2CB8,c2 Is the first character a '.'?
  $2CBA If so, jump forward.
  $2CBC Otherwise, form a 'last value' of the integer.
  $2CBF,c2 Is the next character a '.'?
  $2CC1 Jump forward to see if it is an 'E'.
  $2CC3 Get the next character.
  $2CC4 Is it a digit?
  $2CC7 Jump if not (e.g. 1.E4 is allowed).
  $2CC9 Jump forward to deal with the digits after the decimal point.
@ $2CCB label=DECIMAL
  $2CCB If the number started with a decimal, see if the next character is a digit.
  $2CCF Report the error if it is not.
@ $2CCF label=DEC_RPT_C
  $2CD2 Use the calculator to stack zero as the integer part of such numbers.
B $2CD3,1 #R$341B(stk_zero)
B $2CD4,1 #R$369B
@ $2CD5 label=DEC_STO_1
  $2CD5 Use the calculator to copy the number 1 to mem-0.
B $2CD6,1 #R$341B(stk_one)
B $2CD7,1 #R$342D(st_mem_0)
B $2CD8,1 #R$33A1
B $2CD9,1 #R$369B
N $2CDA For each passage of the following loop, the number (N) saved in the memory area mem-0 is fetched, divided by 10 and restored, i.e. N goes from 1 to .1 to .01 to .001 etc. The present digit (D) is multiplied by N/10 and added to the 'last value' (V), giving V+D*N/10.
@ $2CDA label=NXT_DGT_1
  $2CDA Get the present character.
  $2CDB If it is a digit (D) then stack it.
  $2CDE If not jump forward.
  $2CE0 Now use the calculator.
B $2CE1,1 #R$340F(get_mem_0): V, D, N
B $2CE2,1 #R$341B(stk_ten): V, D, N, 10
B $2CE3,1 #R$31AF: V, D, N/10
B $2CE4,1 #R$342D(st_mem_0): V, D, N/10 (N/10 is copied to mem-0)
B $2CE5,1 #R$30CA: V, D*N/10
B $2CE6,1 #R$3014: V+D*N/10
B $2CE7,1 #R$369B
  $2CE8 Get the next character.
  $2CE9 Jump back (one more byte than needed) to consider it.
N $2CEB Next consider any 'E notation', i.e. the form xEm or xem where m is a positive or negative integer.
@ $2CEB label=E_FORMAT
  $2CEB,c2 Is the present character an 'E'?
  $2CED Jump forward if it is.
  $2CEF,c2 Is it an 'e'?
  $2CF1 Finished unless it is so.
@ $2CF2 label=SIGN_FLAG
  $2CF2 Use #REGb as a sign flag, FF for '+'.
  $2CF4 Get the next character.
  $2CF5,c2 Is it a '+'?
  $2CF7 Jump forward.
  $2CF9,c2 Is it a '-'?
  $2CFB Jump if neither '+' nor '-'.
  $2CFD Change the sign of the flag.
@ $2CFE label=SIGN_DONE
  $2CFE Point to the first digit.
@ $2CFF label=ST_E_PART
  $2CFF Is it indeed a digit?
  $2D02 Report the error if not.
  $2D04 Save the flag in #REGb briefly.
  $2D05 Stack ABS m, where m is the exponent.
  $2D08 Transfer ABS m to #REGa.
  $2D0B Restore the sign flag to #REGb.
  $2D0C Report the overflow now if ABS m is greater than 255 or indeed greater than 127 (other values greater than about 39 will be detected later).
  $2D13 Test the sign flag in #REGb; '+' (i.e. +FF) will now set the zero flag.
  $2D14 Jump if sign of m is '+'.
  $2D16 Negate m if sign is '-'.
@ $2D18 label=E_FP_JUMP
  $2D18 Jump to assign to the 'last value' the result of x*10#powerm.
@ $2D1B label=NUMERIC
c $2D1B THE 'NUMERIC' SUBROUTINE
D $2D1B This subroutine returns with the carry flag reset if the present value of the #REGa register denotes a valid digit.
  $2D1B,c2 Test against 30 hex, the code for '0'.
  $2D1D Return if not a valid character code.
  $2D1E Test against the upper limit.
  $2D20 Complement the carry flag.
  $2D21 Finished.
@ $2D22 label=STK_DIGIT
c $2D22 THE 'STK-DIGIT' SUBROUTINE
D $2D22 This subroutine simply returns if the current value held in the #REGa register does not represent a digit but if it does then the floating-point form for the digit becomes the 'last value' on the calculator stack.
  $2D22 Is the character a digit?
  $2D25 Return if not.
  $2D26,c2 Replace the code by the actual digit.
@ $2D28 label=STACK_A
c $2D28 THE 'STACK-A' SUBROUTINE
D $2D28 This subroutine gives the floating-point form for the absolute binary value currently held in the #REGa register.
  $2D28 Transfer the value to the #REGc register.
  $2D29 Clear the #REGb register.
@ $2D2B label=STACK_BC
c $2D2B THE 'STACK-BC' SUBROUTINE
D $2D2B This subroutine gives the floating-point form for the absolute binary value currently held in the #REGbc register pair.
D $2D2B The form used in this and hence in the two previous subroutines as well is the one reserved in the Spectrum for small integers n, where -65535<=n<=65535. The first and fifth bytes are zero; the third and fourth bytes are the less significant and more significant bytes of the 16 bit integer n in two's complement form (if n is negative, these two bytes hold 65536+n); and the second byte is a sign byte, 00 for '+' and FF for '-'.
  $2D2B Re-initialise #REGiy to ERR-NR.
  $2D2F Clear the #REGa register.
  $2D30 And the #REGe register, to indicate '+'.
  $2D31 Copy the less significant byte to #REGd.
  $2D32 And the more significant byte to #REGc.
  $2D33 Clear the #REGb register.
  $2D34 Now stack the number.
  $2D37 Use the calculator to make #REGhl point to STKEND-5.
B $2D38,1 #R$369B
  $2D39 Clear the carry flag.
  $2D3A Finished.
@ $2D3B label=INT_TO_FP
c $2D3B THE 'INTEGER TO FLOATING-POINT' SUBROUTINE
D $2D3B This subroutine returns a 'last value' on the calculator stack that is the result of converting an integer in a BASIC line, i.e. the integer part of the decimal number or the line number, to its floating-point form.
D $2D3B Repeated calls to #R$0074 fetch each digit of the integer in turn. An exit is made when a code that does not represent a digit has been fetched.
  $2D3B Save the first digit - in #REGa.
  $2D3C Use the calculator.
B $2D3D,1 #R$341B(stk_zero): (the 'last value' is now zero)
B $2D3E,1 #R$369B
  $2D3F Restore the first digit.
N $2D40 Now a loop is set up. As long as the code represents a digit then the floating-point form is found and stacked under the 'last value' (V, initially zero). V is then multiplied by decimal 10 and added to the 'digit' to form a new 'last value' which is carried back to the start of the loop.
@ $2D40 label=NXT_DGT_2
  $2D40 If the code represents a digit (D) then stack the floating-point form; otherwise return.
  $2D44 Use the calculator.
B $2D45,1 #R$343C: D, V
B $2D46,1 #R$341B(stk_ten): D, V, 10
B $2D47,1 #R$30CA: D, 10*V
B $2D48,1 #R$3014: D+10*V
B $2D49,1 #R$369B: D+10*V (this is 'V' for the next pass through the loop)
  $2D4A The next code goes into #REGa.
  $2D4D Loop back with this code.
@ $2D4F label=E_TO_FP
c $2D4F THE 'E-FORMAT TO FLOATING-POINT' SUBROUTINE
D $2D4F This subroutine gives a 'last value' on the top of the calculator stack that is the result of converting a number given in the form xEm, where m is a positive or negative integer. The subroutine is entered with x at the top of the calculator stack and m in the #REGa register.
D $2D4F The method used is to find the absolute value of m, say p, and to multiply or divide x by 10#powerp according to whether m is positive or negative.
D $2D4F To achieve this, p is shifted right until it is zero, and x is multiplied or divided by 10#power(2#powern) for each set bit b(n) of p. Since p is never much more than decimal 39, bits 6 and 7 of p will not normally be set.
  $2D4F Test the sign of m by rotating bit 7 of #REGa into the carry without changing #REGa.
  $2D51 Jump if m is positive.
  $2D53 Negate m in #REGa without disturbing the carry flag.
@ $2D55 label=E_SAVE
  $2D55 Save m in #REGa briefly.
  $2D56 This is MEMBOT; a sign flag is now stored in the first byte of mem-0, i.e. 0 for '+' and 1 for '-'.
  $2D5C The stack holds x.
B $2D5D,1 #R$341B(stk_ten): x, 10 (decimal)
B $2D5E,1 #R$369B: x, 10
  $2D5F Restore m in #REGa.
@ $2D60 label=E_LOOP
  $2D60 In the loop, shift out the next bit of m, modifying the carry and zero flags appropriately; jump if carry reset.
  $2D64 Save the rest of m and the flags.
  $2D65 The stack holds x' and 10#power(2#powern), where x' is an interim stage in the multiplication of x by 10#powerm, and n=0, 1, 2, 3, 4 or 5.
B $2D66,1 #R$342D(st_mem_1): (10#power(2#powern) is copied to mem-1)
B $2D67,1 #R$340F(get_mem_0): x', 10#power(2#powern), (1/0)
B $2D68,2,1 #R$368F to #R$2D6D: x', 10#power(2#powern)
B $2D6A,1 #R$30CA: x'*10#power(2#powern)=x"
B $2D6B,2,1 #R$3686 to #R$2D6E: x''
@ $2D6D label=E_DIVSN
B $2D6D,1 #R$31AF: x/10#power(2#powern)=x'' (x'' is x'*10#power(2#powern) or x'/10#power(2#powern) according as m is '+' or '-')
@ $2D6E label=E_FETCH
B $2D6E,1 #R$340F(get_mem_1): x'', 10#power(2#powern)
B $2D6F,1 #R$369B: x'', 10#power(2#powern)
  $2D70 Restore the rest of m in #REGa, and the flags.
@ $2D71 label=E_TST_END
  $2D71 Jump if m has been reduced to zero.
  $2D73 Save the rest of m in #REGa.
  $2D74 x'', 10#power(2#powern)
B $2D75,1 #R$33C0: x'', 10#power(2#powern), 10#power(2#powern)
B $2D76,1 #R$30CA: x'', 10#power(2#power(n+1))
B $2D77,1 #R$369B: x'', 10#power(2#power(n+1))
  $2D78 Restore the rest of m in #REGa.
  $2D79 Jump back for all bits of m.
@ $2D7B label=E_END
  $2D7B Use the calculator to delete the final power of 10 reached leaving the 'last value' x*10#powerm on the stack.
B $2D7C,1 #R$33A1
B $2D7D,1 #R$369B
  $2D7E
@ $2D7F label=INT_FETCH
c $2D7F THE 'INT-FETCH' SUBROUTINE
D $2D7F This subroutine collects in #REGde a small integer n (-65535<=n<=65535) from the location addressed by #REGhl, i.e. n is normally the first (or second) number at the top of the calculator stack; but #REGhl can also access (by exchange with #REGde) a number which has been deleted from the stack.
D $2D7F The subroutine does not itself delete the number from the stack or from memory; it returns #REGhl pointing to the fourth byte of the number in its original position.
  $2D7F Point to the sign byte of the number.
  $2D80 Copy the sign byte to #REGc.
N $2D81 The following mechanism will two's complement the number if it is negative (#REGc is FF) but leave it unaltered if it is positive (#REGc is 00).
  $2D81 Point to the less significant byte.
  $2D82 Collect the byte in #REGa.
  $2D83 One's complement it if negative.
  $2D84 This adds 1 for negative numbers; it sets the carry unless the byte was 0.
  $2D85 Less significant byte to #REGe now.
  $2D86 Point to the more significant byte.
  $2D87 Collect it in #REGa.
  $2D88 Finish two's complementing in the case of a negative number; note that the carry is always left reset.
  $2D8A More significant byte to #REGd now.
  $2D8B Finished.
@ $2D8C label=P_INT_STO
c $2D8C THE 'INT-STORE' SUBROUTINE
D $2D8C This subroutine stores a small integer n (-65535<=n<=65535) in the location addressed by #REGhl and the four following locations, i.e. n replaces the first (or second) number at the top of the calculator stack. The subroutine returns #REGhl pointing to the first byte of n on the stack.
  $2D8C This entry point would store a number known to be positive.
@ $2D8E label=INT_STORE
  $2D8E The pointer to the first location is saved.
  $2D8F The first byte is set to zero.
  $2D91 Point to the second location.
  $2D92 Enter the second byte.
N $2D93 The same mechanism is now used as in #R$2D7F to two's complement negative numbers. This is needed e.g. before and after the multiplication of small integers. Addition is however performed without any further two's complementing before or afterwards.
  $2D93 Point to the third location.
  $2D94 Collect the less significant byte.
  $2D95 Two's complement it if the number is negative.
  $2D97 Store the byte.
  $2D98 Point to the fourth location.
  $2D99 Collect the more significant byte.
  $2D9A Two's complement it if the number is negative.
  $2D9C Store the byte.
  $2D9D Point to the fifth location.
  $2D9E The fifth byte is set to zero.
  $2DA0 Return with #REGhl pointing to the first byte of n on the stack.
@ $2DA2 label=FP_TO_BC
c $2DA2 THE 'FLOATING-POINT TO BC' SUBROUTINE
D $2DA2 This subroutine is used to compress the floating-point 'last value' on the calculator stack into the #REGbc register pair. If the result is too large, i.e. greater than 65536 decimal, then the subroutine returns with the carry flag set. If the 'last value' is negative then the zero flag is reset. The low byte of the result is also copied to the #REGa register.
  $2DA2 Use the calculator to make #REGhl point to STKEND-5.
B $2DA3,1 #R$369B
  $2DA4 Collect the exponent byte of the 'last value'; jump if it is zero, indicating a 'small integer'.
  $2DA8 Now use the calculator to round the 'last value' (V) to the nearest integer, which also changes it to 'small integer' form on the calculator stack if that is possible, i.e. if -65535.5<=V<65535.5.
B $2DA9,1 #R$341B(stk_half): V, 0.5
B $2DAA,1 #R$3014: V+0.5
B $2DAB,1 #R$36AF: INT (V+0.5)
B $2DAC,1 #R$369B
@ $2DAD label=FP_DELETE
  $2DAD Use the calculator to delete the integer from the stack; #REGde still points to it in memory (at STKEND).
B $2DAE,1 #R$33A1
B $2DAF,1 #R$369B
  $2DB0 Save both stack pointers.
  $2DB2 #REGhl now points to the number.
  $2DB3 Copy the first byte to #REGb.
  $2DB4 Copy bytes 2, 3 and 4 to #REGc, #REGe and #REGd.
  $2DB7 Clear the #REGa register.
  $2DB8 This sets the carry unless #REGb is zero.
  $2DB9 This sets the zero flag if the number is positive (NZ denotes negative).
  $2DBB Copy the high byte to #REGb.
  $2DBC And the low byte to #REGc.
  $2DBD Copy the low byte to #REGa too.
  $2DBE Restore the stack pointers.
  $2DC0 Finished.
@ $2DC1 label=LOG_2_A
c $2DC1 THE 'LOG(2#powerA)' SUBROUTINE
D $2DC1 This subroutine calculates the approximate number of digits before the decimal in x, the number to be printed, or, if there are no digits before the decimal, then the approximate number of leading zeros after the decimal. It is entered with the #REGa register containing e', the true exponent of x, or e'-2, and calculates z=log to the base 10 of (2#power#REGa). It then sets #REGa equal to ABS INT (z+0.5), as required, using #R$2DD5 for this purpose.
  $2DC1 The integer #REGa is stacked, either as 00 00 #REGa 00 00 (for positive #REGa) or as 00 FF #REGa FF 00 (for negative #REGa).
  $2DC4 These bytes are first loaded into #REGa, #REGe, #REGd, #REGc, #REGb and then #R$2AB6 is called to put the number on the calculator stack.
  $2DCB The calculator is used.
B $2DCC,6,1,5 #R$33C6: log 2 to the base 10 is now stacked
B $2DD2,1 #R$30CA: #REGa*log 2 i.e. log (2#power#REGa)
B $2DD3,1 #R$36AF: INT log (2#power#REGa)
B $2DD4,1 #R$369B
E $2DC1 The subroutine continues into #R$2DD5 to complete the calculation.
@ $2DD5 label=FP_TO_A
c $2DD5 THE 'FLOATING-POINT TO A' SUBROUTINE
D $2DD5 This short but vital subroutine is called at least 8 times for various purposes. It uses #R$2DA2 to get the 'last value' into the #REGa register where this is possible. It therefore tests whether the modulus of the number rounds to more than 255 and if it does the subroutine returns with the carry flag set. Otherwise it returns with the modulus of the number, rounded to the nearest integer, in the #REGa register, and the zero flag set to imply that the number was positive, or reset to imply that it was negative.
  $2DD5 Compress the 'last value' into #REGbc.
  $2DD8 Return if out of range already.
  $2DD9 Save the result and the flags.
  $2DDA Again it will be out of range if the #REGb register does not hold zero.
  $2DDC Jump if in range.
  $2DDE Fetch the result and the flags.
  $2DDF Signal the result is out of range.
  $2DE0 Finished - unsuccessful.
@ $2DE1 label=FP_A_END
  $2DE1 Fetch the result and the flags.
  $2DE2 Finished - successful.
@ $2DE3 label=PRINT_FP
c $2DE3 THE 'PRINT A FLOATING-POINT NUMBER' SUBROUTINE
D $2DE3 This subroutine prints x, the 'last value' on the calculator stack. The print format never occupies more than 14 spaces.
D $2DE3 The 8 most significant digits of x, correctly rounded, are stored in an ad hoc print buffer in mem-3 and mem-4. Small numbers, numerically less than 1, and large numbers, numerically greater than 2#power27, are dealt with separately. The former are multiplied by 10#powern, where n is the approximate number of leading zeros after the decimal, while the latter are divided by 10#power(n-7), where n is the approximate number of digits before the decimal. This brings all numbers into the middle range, and the number of digits required before the decimal is built up in the second byte of mem-5. Finally the printing is done, using E-format if there are more than 8 digits before the decimal or, for small numbers, more than 4 leading zeros after the decimal.
D $2DE3 The following program shows the range of print formats:
D $2DE3 10 FOR a=-11 TO 12: PRINT SGN a*9#powera,: NEXT a
D $2DE3 i. First the sign of x is taken care of:
D $2DE3 #LIST { If x is negative, the subroutine jumps to #R$2DF2, takes ABS x and prints the minus sign. } { If x is zero, x is deleted from the calculator stack, a '0' is printed and a return is made from the subroutine. } { If x is positive, the subroutine just continues. } LIST#
  $2DE3 Use the calculator.
B $2DE4,1 #R$33C0: x, x
B $2DE5,1 #R$3506: x, (1/0) Logical value of x.
B $2DE6,2 #R$368F to #R$2DF2: x
B $2DE8,1 #R$33C0: x, x
B $2DE9,1 #R$34F9: x, (1/0) Logical value of x.
B $2DEA,2 #R$368F to #R$2DF8: x Hereafter x'=ABS x.
B $2DEC,1 #R$33A1: -
B $2DED,1 #R$369B: -
  $2DEE,c2 Enter the character code for '0'.
  $2DF0 Print the '0'.
  $2DF1 Finished as the 'last value' is zero.
@ $2DF2 label=PF_NEGTVE
B $2DF2,1 #R$346A: x' x'=ABS x.
B $2DF3,1 #R$369B: x'
  $2DF4,c2 Enter the character code for '-'.
  $2DF6 Print the '-'.
  $2DF7 Use the calculator again.
@ $2DF8 label=PF_POSTVE
B $2DF8,4,1,3 #R$341B(stk_zero): The 15 bytes of mem-3, mem-4 and mem-5 are now initialised to zero to be used for a print buffer and two counters.
B $2DFC,1 #R$33A1: The stack is cleared, except for x'.
B $2DFD,1 #R$369B: x'
  $2DFE #REGhl', which is used to hold calculator offsets (e.g. for 'STR$'), is saved on the machine stack.
N $2E01 ii. This is the start of a loop which deals with large numbers. Every number x is first split into its integer part i and the fractional part f. If i is a small integer, i.e. if -65535<=i<=65535, it is stored in #REGde' for insertion into the print buffer.
@ $2E01 label=PF_LOOP
  $2E01 Use the calculator again.
B $2E02,1 #R$33C0: x', x'
B $2E03,1 #R$36AF: x', INT (x')=i
B $2E04,1 #R$342D(st_mem_2): (i is stored in mem-2).
B $2E05,1 #R$300F: x'-i=f
B $2E06,1 #R$340F(get_mem_2): f, i
B $2E07,1 #R$343C: i, f
B $2E08,1 #R$342D(st_mem_2): (f is stored in mem-2).
B $2E09,1 #R$33A1: i
B $2E0A,1 #R$369B: i
  $2E0B Is i a small integer (first byte zero) i.e. is ABS i<=65535?
  $2E0D Jump if it is not.
  $2E0F i is copied to #REGde (i, like x', >=0).
  $2E12 #REGb is set to count 16 bits.
  $2E14 #REGd is copied to #REGa for testing: is it zero?
  $2E16 Jump if it is not zero.
  $2E18 Now test #REGe.
  $2E19 Jump if #REGde is zero: x is a pure fraction.
  $2E1B Move #REGe to #REGd and set #REGb for 8 bits: #REGd was zero and #REGe was not.
@ $2E1E label=PF_SAVE
  $2E1E Transfer #REGde to #REGde', via the machine stack, to be moved into the print buffer at #R$2E7B.
  $2E22 Jump forward.
N $2E24 iii. Pure fractions are multiplied by 10#powern, where n is the approximate number of leading zeros after the decimal; and -n is added to the second byte of mem-5, which holds the number of digits needed before the decimal; a negative number here indicates leading zeros after the decimal.
@ $2E24 label=PF_SMALL
  $2E24 i (i=zero here)
B $2E25,1 #R$340F(get_mem_2): i, f
B $2E26,1 #R$369B: i, f
N $2E27 Note that the stack is now unbalanced. An extra byte 'DEFB +02, delete' is needed immediately after the RST 28. Now an expression like "2"+STR$ 0.5 is evaluated incorrectly as 0.5; the zero left on the stack displaces the "2" and is treated as a null string. Similarly all the string comparisons can yield incorrect values if the second string takes the form STR$ x where x is numerically less than 1; e.g. the expression "50"<STR$ 0.1 yields the logical value "true"; once again "" is used instead of "50".
  $2E27 The exponent byte e of f is copied to #REGa.
  $2E28 #REGa becomes e-126 dec i.e. e'+2, where e' is the true exponent of f.
  $2E2A The construction #REGa=ABS INT (LOG (2#power#REGa)) is performed (LOG is to base 10); i.e. #REGa=n, say: n is copied from #REGa to #REGd.
  $2E2E The current count is collected from the second byte of mem-5 and n is subtracted from it.
  $2E35 n is copied from #REGd to #REGa.
  $2E36 y=f*10#powern is formed and stacked.
  $2E39 i, y
B $2E3A,1 #R$33C0: i, y, y
B $2E3B,1 #R$36AF: i, y, INT (y)=i2
B $2E3C,1 #R$342D(st_mem_1): (i2 is copied to mem-1).
B $2E3D,1 #R$300F: i, y-i2
B $2E3E,1 #R$340F(get_mem_1): i, y-i2, i2
B $2E3F,1 #R$369B: i, f2, i2 (f2=y-i2)
  $2E40 i2 is transferred from the stack to #REGa.
  $2E43 The pointer to f2 is saved.
  $2E44 i2 is stored in the first byte of mem-3: a digit for printing.
  $2E47 i2 will not count as a digit for printing if it is zero; #REGa is manipulated so that zero will produce zero but a non-zero digit will produce 1.
  $2E4B The zero or one is inserted into the first byte of mem-5 (the number of digits for printing) and added to the second byte of mem-5 (the number of digits before the decimal).
  $2E52 The pointer to f2 is restored.
  $2E53 Jump to store f2 in buffer (#REGhl now points to f2, #REGde to i2).
N $2E56 iv. Numbers greater than 2#power27 are similarly multiplied by 2#power(-n+7), reducing the number of digits before the decimal to 8, and the loop is re-entered at #R$2E01.
@ $2E56 label=PF_LARGE
  $2E56 e-80 hex is e', the true exponent of i.
  $2E58 Is e' less than 28 decimal?
  $2E5A Jump if it is less.
  $2E5C n is formed in #REGa.
  $2E5F And reduced to n-7.
  $2E61 Then copied to #REGb.
  $2E62 n-7 is added in to the second byte of mem-5, the number of digits required before the decimal in x.
  $2E67 Then i is multiplied by 10#power(-n+7). This will bring it into medium range for printing.
  $2E6D Round the loop again to deal with the now medium-sized number.
N $2E6F v. The integer part of x is now stored in the print buffer in mem-3 and mem-4.
@ $2E6F label=PF_MEDIUM
  $2E6F #REGde now points to i, #REGhl to f.
  $2E70 The mantissa of i is now in #REGd', #REGe', #REGd, #REGe.
  $2E73 Get the exchange registers.
  $2E74 True numerical bit 7 to #REGd'.
  $2E76 Exponent byte e of i to #REGa.
  $2E77 Back to the main registers.
  $2E78 True exponent e'=e-80 hex to #REGa.
  $2E7A This gives the required bit count.
N $2E7B Note that the case where i is a small integer (less than 65536) re-enters here.
@ $2E7B label=PF_BITS
  $2E7B The mantissa of i is now rotated left and all the bits of i are thus shifted into mem-4 and each byte of mem-4 is decimal adjusted at each shift.
  $2E84 Back to the main registers.
  $2E85 Address of fifth byte of mem-4 to #REGhl; count of 5 bytes to #REGc.
@ $2E8A label=PF_BYTES
  $2E8A Get the byte of mem-4.
  $2E8B Shift it left, taking in the new bit.
  $2E8C Decimal adjust the byte.
  $2E8D Restore it to mem-4.
  $2E8E Point to next byte of mem-4.
  $2E8F Decrease the byte count by one.
  $2E90 Jump for each byte of mem-4.
  $2E92 Jump for each bit of INT (x).
N $2E94 Decimal adjusting each byte of mem-4 gave 2 decimal digits per byte, there being at most 9 digits. The digits will now be re-packed, one to a byte, in mem-3 and mem-4, using the instruction RLD.
  $2E94 #REGa is cleared to receive the digits.
  $2E95 Source address: first byte of mem-4.
  $2E98 Destination: first byte of mem-3.
  $2E9B There are at most 9 digits.
  $2E9D The left nibble of mem-4 is discarded.
  $2E9F FF in #REGc will signal a leading zero, 00 will signal a non-leading zero.
@ $2EA1 label=PF_DIGITS
  $2EA1 Left nibble of (#REGhl) to #REGa, right nibble of (#REGhl) to left.
  $2EA3 Jump if digit in #REGa is not zero.
  $2EA5 Test for a leading zero: it will now give zero reset.
  $2EA7 Jump if it was a leading zero.
@ $2EA9 label=PF_INSERT
  $2EA9 Insert the digit now.
  $2EAA Point to next destination.
  $2EAB One more digit for printing, and one more before the decimal.
  $2EB1 Change the flag from leading zero to other zero.
@ $2EB3 label=PF_TEST_2
  $2EB3 The source pointer needs to be incremented on every second passage through the loop, when #REGb is odd.
@ $2EB8 label=PF_ALL_9
  $2EB8 Jump back for all 9 digits.
  $2EBA Get counter: were there 9 digits excluding leading zeros?
  $2EBF If not, jump to get more digits.
  $2EC1 Prepare to round: reduce count to 8.
  $2EC4 Compare 9th digit, byte 4 of mem-4, with 4 to set carry for rounding up.
  $2EC9 Jump forward to round up.
@ $2ECB label=PF_MORE
  $2ECB Use the calculator again.
B $2ECC,1 - (i is now deleted).
B $2ECD,1 f
B $2ECE,1 f
B $2ECC,1 #R$33A1: - (i is now deleted).
B $2ECD,1 #R$340F(get_mem_2): f
B $2ECE,1 #R$369B: f
N $2ECF vi. The fractional part of x is now stored in the print buffer.
@ $2ECF label=PF_FRACTN
  $2ECF #REGde now points to f.
  $2ED0 The mantissa of f is now in #REGd', #REGe', #REGd, #REGe.
  $2ED3 Get the exchange registers.
  $2ED4 The exponent of f is reduced to zero, by shifting the bits of f 80 hex minus e places right, where #REGl' contained e.
  $2ED9 True numerical bit to bit 7 of #REGd'.
  $2EDB Restore the main registers.
  $2EDC Now make the shift.
  $2EDF Get the digit count.
  $2EE2 Are there already 8 digits?
  $2EE4 If not, jump forward.
  $2EE6 If 8 digits, just use f to round i up, rotating #REGd' left to set the carry.
  $2EE9 Restore main registers and jump forward to round up.
@ $2EEC keep
@ $2EEC label=PF_FR_DGT
  $2EEC Initial zero to #REGc, count of 2 to #REGb.
@ $2EEF label=PF_FR_EXX
  $2EEF #REGd'#REGe'#REGd#REGe is multiplied by 10 in 2 stages, first #REGde then #REGde', each byte by byte in 2 steps, and the integer part of the result is obtained in #REGc to be passed into the print buffer.
  $2EF9 The count and the result alternate between #REGbc and #REGbc'.
  $2EFC Loop back once through the exchange registers.
  $2EFE The start - 1st byte of mem-3.
  $2F01 Result to #REGa for storing.
  $2F02 Count of digits so far in number to #REGc.
  $2F05 Address the first empty byte.
  $2F06 Store the next digit.
  $2F07 Step up the count of digits.
  $2F0A Loop back until there are 8 digits.
N $2F0C vii. The digits stored in the print buffer are rounded to a maximum of 8 digits for printing.
@ $2F0C label=PF_ROUND
  $2F0C Save the carry flag for the rounding.
  $2F0D Base address of number: mem-3, byte 1.
  $2F10 Offset (number of digits in number) to #REGbc.
  $2F15 Address the last byte of the number.
  $2F16 Copy #REGc to #REGb as the counter.
  $2F17 Restore the carry flag.
@ $2F18 label=PF_RND_LP
  $2F18 This is the last byte of the number.
  $2F19 Get the byte into #REGa.
  $2F1A Add in the carry i.e. round up.
  $2F1C Store the rounded byte in the buffer.
  $2F1D If the byte is 0 or 10, #REGb will be decremented and the final zero (or the 10) will not be counted for printing.
  $2F22 Reset the carry for a valid digit.
  $2F23 Jump if carry reset.
@ $2F25 label=PF_R_BACK
  $2F25 Jump back for more rounding or more final zeros.
  $2F27 There is overflow to the left; an extra 1 is needed here.
  $2F2A It is also an extra digit before the decimal.
@ $2F2D label=PF_COUNT
  $2F2D #REGb now sets the count of the digits to be printed (final zeros will not be printed).
  $2F30 f is to be deleted.
B $2F31,1 #R$33A1: -
B $2F32,1 #R$369B: -
  $2F33 The calculator offset saved on the stack is restored to #REGhl'.
N $2F36 viii. The number can now be printed. First #REGc will be set to hold the number of digits to be printed, not counting final zeros, while #REGb will hold the number of digits required before the decimal.
  $2F36 The counters are set.
  $2F3A The start of the digits.
  $2F3D If more than 9, or fewer than minus 4, digits are required before the decimal, then E-format will be needed.
  $2F42 Fewer than 4 means more than 4 leading zeros after the decimal.
@ $2F46 label=PF_NOT_E
  $2F46 Are there no digits before the decimal? If so, print an initial zero.
N $2F4A The next entry point is also used to print the digits needed for E-format printing.
@ $2F4A label=PF_E_SBRN
  $2F4A Start by setting #REGa to zero.
  $2F4B Subtract #REGb: minus will mean there are digits before the decimal; jump forward to print them.
  $2F4F #REGa is now required as a counter.
  $2F50 Jump forward to print the decimal part.
@ $2F52 label=PF_OUT_LP
  $2F52 Copy the number of digits to be printed to #REGa. If #REGa is 0, there are still final zeros to print (#REGb is non-zero), so jump.
  $2F56 Get a digit from the print buffer.
  $2F57 Point to the next digit.
  $2F58 Decrease the count by one.
@ $2F59 label=PF_OUT_DT
  $2F59 Print the appropriate digit.
  $2F5C Loop back until #REGb is zero.
@ $2F5E label=PF_DC_OUT
  $2F5E It is time to print the decimal, unless #REGc is now zero; in that case, return - finished.
  $2F61 Add 1 to #REGb - include the decimal.
  $2F62,c2 Put the code for '.' into #REGa.
@ $2F64 label=PF_DEC_0S
  $2F64 Print the '.'.
  $2F65,c2 Enter the character code for '0'.
  $2F67 Loop back to print all needed zeros.
  $2F69 Set the count for all remaining digits.
  $2F6A Jump back to print them.
@ $2F6C label=PF_E_FRMT
  $2F6C The count of digits is copied to #REGd.
  $2F6D It is decremented to give the exponent.
  $2F6E One digit is required before the decimal in E-format.
  $2F70 All the part of the number before the 'E' is now printed.
  $2F73,c2 Enter the character code for 'E'.
  $2F75 Print the 'E'.
  $2F76 Exponent to #REGc now for printing.
  $2F77 And to #REGa for testing.
  $2F78 Its sign is tested.
  $2F79 Jump if it is positive.
  $2F7C Otherwise, negate it in #REGa.
  $2F7E Then copy it back to #REGc for printing.
  $2F7F,c2 Enter the character code for '-'.
  $2F81 Jump to print the sign.
@ $2F83 label=PF_E_POS
  $2F83,c2 Enter the character code for '+'.
@ $2F85 label=PF_E_SIGN
  $2F85 Now print the sign: '+' or '-'.
  $2F86 #REGbc holds the exponent for printing.
  $2F88 Jump back to print it and finish.
@ $2F8B label=CA_10A_C
c $2F8B THE 'CA=10*A+C' SUBROUTINE
D $2F8B This subroutine is called by #R$2DE3 to multiply each byte of #REGd'#REGe'#REGde by 10 and return the integer part of the result in the #REGc register. On entry, the #REGa register contains the byte to be multiplied by 10 and the #REGc register contains the carry over from the previous byte. On return, the #REGa register contains the resulting byte and the #REGc register the carry forward to the next byte.
  $2F8B Save whichever #REGde pair is in use.
  $2F8C Copy the multiplicand from #REGa to #REGhl.
  $2F8F Copy it to #REGde too.
  $2F91 Double #REGhl.
  $2F92 Double it again.
  $2F93 Add in #REGde to give #REGhl=5*#REGa.
  $2F94 Double again: now #REGhl=10*#REGa.
  $2F95 Copy #REGc to #REGde (#REGd is zero) for addition.
  $2F96 Now #REGhl=10*#REGa+#REGc.
  $2F97 #REGh is copied to #REGc.
  $2F98 #REGl is copied to #REGa, completing the task.
  $2F99 The #REGde register pair is restored.
  $2F9A Finished.
@ $2F9B label=PREP_ADD
c $2F9B THE 'PREPARE TO ADD' SUBROUTINE
D $2F9B This subroutine is the first of four subroutines that are used by the main arithmetic operation routines - #R$300F, #R$3014, #R$30CA and #R$31AF.
D $2F9B This particular subroutine prepares a floating-point number for addition, mainly by replacing the sign bit with a true numerical bit 1, and negating the number (two's complement) if it is negative. The exponent is returned in the #REGa register and the first byte is set to +00 for a positive number and +FF for a negative number.
  $2F9B Transfer the exponent to #REGa.
  $2F9C Presume a positive number.
  $2F9E If the number is zero then the preparation is already finished.
  $2FA0 Now point to the sign byte.
  $2FA1 Set the zero flag for positive number.
  $2FA3 Restore the true numeric bit.
  $2FA5 Point to the first byte again.
  $2FA6 Positive numbers have been prepared, but negative numbers need to be two's complemented.
  $2FA7 Save any earlier exponent.
@ $2FA8 keep
  $2FA8 There are 5 bytes to be handled.
  $2FAB Point one past the last byte.
  $2FAC Transfer the 5 to #REGb.
  $2FAD Save the exponent in #REGc.
  $2FAE Set carry flag for negation.
@ $2FAF label=NEG_BYTE
  $2FAF Point to each byte in turn.
  $2FB0 Get each byte.
  $2FB1 One's complement the byte.
  $2FB2 Add in carry for negation.
  $2FB4 Restore the byte.
  $2FB5 Loop 5 times.
  $2FB7 Restore the exponent to #REGa.
  $2FB8 Restore any earlier exponent.
  $2FB9 Finished.
@ $2FBA label=FETCH_TWO
c $2FBA THE 'FETCH TWO NUMBERS' SUBROUTINE
D $2FBA This subroutine is called by #R$3014, #R$30CA and #R$31AF to get two numbers from the calculator stack and put them into the registers, including the exchange registers.
D $2FBA On entry to the subroutine the #REGhl register pair points to the first byte of the first number and the #REGde register pair points to the first byte of the second number.
D $2FBA When the subroutine is called from #R$30CA or #R$31AF the sign of the result is saved in the second byte of the first number.
  $2FBA #REGhl is preserved.
  $2FBB #REGaf is preserved.
N $2FBC Call the five bytes of the first number M1, M2, M3, M4 and M5, and the five bytes of the second number N1, N2, N3, N4 and N5.
  $2FBC M1 to #REGc.
  $2FBD Next.
  $2FBE M2 to #REGb.
  $2FBF Copy the sign of the result to (#REGhl).
  $2FC0 Next.
  $2FC1 M1 to #REGa.
  $2FC2 M3 to #REGc.
  $2FC3 Save M2 and M3 on the machine stack.
  $2FC4 Next.
  $2FC5 M4 to #REGc.
  $2FC6 Next.
  $2FC7 M5 to #REGb.
  $2FC8 #REGhl now points to N1.
  $2FC9 M1 to #REGd.
  $2FCA N1 to #REGe.
  $2FCB Save M1 and N1 on the machine stack.
  $2FCC Next.
  $2FCD N2 to #REGd.
  $2FCE Next.
  $2FCF N3 to #REGe.
  $2FD0 Save N2 and N3 on the machine stack.
  $2FD1 Get the exchange registers.
  $2FD2 N2 to #REGd' and N3 to #REGe'.
  $2FD3 M1 to #REGh' and N1 to #REGl'.
  $2FD4 M2 to #REGb' and M3 to #REGc'.
  $2FD5 Get the original set of registers.
  $2FD6 Next.
  $2FD7 N4 to #REGd.
  $2FD8 Next.
  $2FD9 N5 to #REGe.
  $2FDA Restore the original #REGaf.
  $2FDB Restore the original #REGhl.
  $2FDC Finished.
E $2FBA Summary:
E $2FBA #LIST { M1 - M5 are in #REGh', #REGb', #REGc', #REGc, #REGb. } { N1 - N5 are in #REGl', #REGd', #REGe', #REGd, #REGe. } { #REGhl points to the first byte of the first number. } LIST#
@ $2FDD label=SHIFT_FP
c $2FDD THE 'SHIFT ADDEND' SUBROUTINE
D $2FDD This subroutine shifts a floating-point number up to 32 places right to line it up properly for addition. The number with the smaller exponent has been put in the addend position before this subroutine is called. Any overflow to the right, into the carry, is added back into the number. If the exponent difference is greater than 32 decimal, or the carry ripples right back to the beginning of the number then the number is set to zero so that the addition will not alter the other number (the augend).
  $2FDD If the exponent difference is zero, the subroutine returns at once.
  $2FDF If the difference is greater than +20, jump forward.
  $2FE3 Save #REGbc briefly.
  $2FE4 Transfer the exponent difference to #REGb to count the shifts right.
@ $2FE5 label=ONE_SHIFT
  $2FE5 Arithmetic shift right for #REGl', preserving the sign marker bits.
  $2FE8 Rotate right with carry #REGd', #REGe', #REGd and #REGe, thereby shifting the whole five bytes of the number to the right as many times as #REGb counts.
  $2FF1 Loop back until #REGb reaches zero.
  $2FF3 Restore the original #REGbc.
  $2FF4 Done if no carry to retrieve.
  $2FF5 Retrieve carry.
  $2FF8 Return unless the carry rippled right back. (In this case there is nothing to add.)
@ $2FF9 label=ADDEND_0
  $2FF9 Fetch #REGl', #REGd' and #REGe'.
  $2FFA Clear the #REGa register.
@ $2FFB label=ZEROS_4_5
  $2FFB Set the addend to zero in #REGd', #REGe', #REGd and #REGe, together with its marker byte (sign indicator) #REGl', which was +00 for a positive number and +FF for a negative number. This produces only 4 zero bytes when called for near underflow by #R$30CA.
@ $3000 keep
  $3003 Finished.
@ $3004 label=ADD_BACK
c $3004 THE 'ADD-BACK' SUBROUTINE
D $3004 This subroutine adds back into the number any carry which has overflowed to the right. In the extreme case, the carry ripples right back to the left of the number.
D $3004 When this subroutine is called during addition, this ripple means that a mantissa of 0.5 was shifted a full 32 places right, and the addend will now be set to zero; when called from #R$30CA, it means that the exponent must be incremented, and this may result in overflow.
  $3004 Add carry to rightmost byte.
  $3005 Return if no overflow to left.
  $3006 Continue to the next byte.
  $3007 Return if no overflow to left.
  $3008 Get the next byte.
  $3009 Increment it too.
  $300A Jump if no overflow.
  $300C Increment the last byte.
@ $300D label=ALL_ADDED
  $300D Restore the original registers.
  $300E Finished.
@ $300F label=SUBTRACT
c $300F THE 'SUBTRACTION' OPERATION
D $300F This subroutine simply changes the sign of the subtrahend and carries on into #R$3014.
D $300F Note that #REGhl points to the minuend and #REGde points to the subtrahend. (See #R$3014 for more details.)
  $300F Exchange the pointers.
  $3010 Change the sign of the subtrahend.
  $3013 Exchange the pointers back and continue into #R$3014.
@ $3014 label=addition
c $3014 THE 'ADDITION' OPERATION
D $3014 The first of three major arithmetical subroutines, this subroutine carries out the floating-point addition of two numbers, each with a 4-byte mantissa and a 1-byte exponent. In these three subroutines, the two numbers at the top of the calculator stack are added/multiplied/divided to give one number at the top of the calculator stack, a 'last value'.
D $3014 #REGhl points to the second number from the top, the augend/multiplier/dividend. #REGde points to the number at the top of the calculator stack, the addend/multiplicand/divisor. Afterwards #REGhl points to the resultant 'last value' whose address can also be considered to be STKEND-5.
D $3014 But the addition subroutine first tests whether the 2 numbers to be added are 'small integers'. If they are, it adds them quite simply in #REGhl and #REGbc, and puts the result directly on the stack. No two's complementing is needed before or after the addition, since such numbers are held on the stack in two's complement form, ready for addition.
  $3014 Test whether the first bytes of both numbers are zero.
  $3016 If not, jump for full addition.
  $3018 Save the pointer to the second number.
  $3019 Point to the second byte of the first number and save that pointer too.
  $301B Point to the less significant byte.
  $301C Fetch it in #REGe.
  $301D Point to the more significant byte.
  $301E Fetch it in #REGd.
  $301F Move on to the second byte of the second number.
  $3022 Fetch it in #REGa (this is the sign byte).
  $3023 Point to the less significant byte.
  $3024 Fetch it in #REGc.
  $3025 Point to the more significant byte.
  $3026 Fetch it in #REGb.
  $3027 Fetch the pointer to the sign byte of the first number; put it in #REGde, and the number in #REGhl.
  $3029 Perform the addition: result in #REGhl.
  $302A Result to #REGde, sign byte to #REGhl.
  $302B Add the sign bytes and the carry into #REGa; this will detect any overflow.
  $302D A non-zero #REGa now indicates overflow.
  $302F Jump to reset the pointers and to do full addition.
  $3031 Define the correct sign byte for the result.
  $3032 Store it on the stack.
  $3033 Point to the next location.
  $3034 Store the low byte of the result.
  $3035 Point to the next location.
  $3036 Store the high byte of the result.
  $3037 Move the pointer back to address the first byte of the result.
  $303A Restore STKEND to #REGde.
  $303B Finished.
N $303C Note that the number -65536 decimal can arise here in the form 00 FF 00 00 00 as the result of the addition of two smaller negative integers, e.g. -65000 and -536. It is simply stacked in this form. This is a mistake. The Spectrum system cannot handle this number.
@ $303C label=ADDN_OFLW
N $303C Most functions treat it as zero, and it is printed as -1E-38, obtained by treating is as 'minus zero' in an illegitimate format.
N $303C One possible remedy would be to test for this number at about byte #R$3032 and, if it is present, to make the second byte 80 hex and the first byte 91 hex, so producing the full five-byte floating-point form of the number, i.e. 91 80 00 00 00, which causes no problems. See also the #R$3225(remarks in 'truncate').
  $303C Restore the pointer to the first number.
  $303D Restore the pointer to the second number.
@ $303E label=FULL_ADDN
  $303E Re-stack both numbers in full five-byte floating-point form.
N $3041 The full addition subroutine first calls #R$2F9B for each number, then gets the two numbers from the calculator stack and puts the one with the smaller exponent into the addend position. It then calls #R$2FDD to shift the addend up to 32 decimal places right to line it up for addition. The actual addition is done in a few bytes, a single shift is made for carry (overflow to the left) if needed, the result is two's complemented if negative, and any arithmetic overflow is reported; otherwise the subroutine jumps to #R$3155 to normalise the result and return it to the stack with the correct sign bit inserted into the second byte.
  $3041 Exchange the registers.
  $3042 Save the next literal address.
  $3043 Exchange the registers.
  $3044 Save pointer to the addend.
  $3045 Save pointer to the augend.
  $3046 Prepare the augend.
  $3049 Save its exponent in #REGb.
  $304A Exchange the pointers.
  $304B Prepare the addend.
  $304E Save its exponent in #REGc.
  $304F If the first exponent is smaller, keep the first number in the addend position; otherwise change the exponents and the pointers back again.
@ $3055 label=SHIFT_LEN
  $3055 Save the larger exponent in #REGa.
  $3056 The difference between the exponents is the length of the shift right.
  $3057 Get the two numbers from the stack.
  $305A Shift the addend right.
  $305D Restore the larger exponent.
  $305E #REGhl is to point to the result.
  $305F Store the exponent of the result.
  $3060 Save the pointer again.
  $3061 M4 to #REGh and M5 to #REGl (see #R$2FBA).
  $3063 Add the two right bytes.
  $3064 N2 to #REGh' and N3 to #REGl' (see #R$2FBA).
  $3066 Add left bytes with carry.
  $3068 Result back in #REGd'#REGe'.
  $3069 Add #REGh', #REGl' and the carry; the resulting mechanisms will ensure that a single shift right is called if the sum of 2 positive numbers has overflowed left, or the sum of 2 negative numbers has not overflowed left.
  $306F The result is now in #REGd#REGe#REGd'#REGe'.
  $3070 Get the pointer to the exponent.
  $3071 The test for shift (#REGh', #REGl' were +00 for positive numbers and +FF for negative numbers).
  $3074 #REGa counts a single shift right.
  $3076 The shift is called.
  $3079 Add 1 to the exponent; this may lead to arithmetic overflow.
@ $307C label=TEST_NEG
  $307C Test for negative result: get sign bit of #REGl' into #REGa (this now correctly indicates the sign of the result).
  $3081 Store it in the second byte position of the result on the calculator stack.
  $3084 If it is zero, then do not two's complement the result.
  $3086 Get the first byte.
  $3087 Negate it.
  $3089 Complement the carry for continued negation, and store byte.
  $308B Get the next byte.
  $308C One's complement it.
  $308D Add in the carry for negation.
  $308F Store the byte.
  $3090 Proceed to get next byte into the #REGa register.
  $3092 One's complement it.
  $3093 Add in the carry for negation.
  $3095 Store the byte.
  $3096 Get the last byte.
  $3097 One's complement it.
  $3098 Add in the carry for negation.
  $309A Done if no carry.
  $309C Else, get .5 into mantissa and add 1 to the exponent; this will be needed when two negative numbers add to give an exact power of 2, and it may lead to arithmetic overflow.
@ $309F label=ADD_REP_6
  $309F Give the error if required.
@ $30A3 label=END_COMPL
  $30A3 Store the last byte.
@ $30A5 label=GO_NC_MLT
  $30A5 Clear the carry flag.
  $30A6 Exit via #R$3155.
@ $30A9 label=HL_HLxDE
c $30A9 THE 'HL=HL*DE' SUBROUTINE
D $30A9 This subroutine is called by #R$2AF4 and by #R$30CA to perform the 16-bit multiplication as stated.
D $30A9 Any overflow of the 16 bits available is dealt with on return from the subroutine.
  $30A9 #REGbc is saved.
  $30AA It is to be a 16-bit multiplication.
  $30AC #REGa holds the high byte.
  $30AD #REGc holds the low byte.
@ $30AE keep
  $30AE Initialise the result to zero.
@ $30B1 label=HL_LOOP
  $30B1 Double the result.
  $30B2 Jump if overflow.
  $30B4 Rotate bit 7 of #REGc into the carry.
  $30B6 Rotate the carry bit into bit 0 and bit 7 into the carry flag.
  $30B7 Jump if the carry flag is reset.
  $30B9 Otherwise add #REGde in once.
  $30BA Jump if overflow.
@ $30BC label=HL_AGAIN
  $30BC Repeat until 16 passes have been made.
@ $30BE label=HL_END
  $30BE Restore #REGbc.
  $30BF Finished.
@ $30C0 label=PREP_M_D
c $30C0 THE 'PREPARE TO MULTIPLY OR DIVIDE' SUBROUTINE
D $30C0 This subroutine prepares a floating-point number for multiplication or division, returning with carry set if the number is zero, getting the sign of the result into the #REGa register, and replacing the sign bit in the number by the true numeric bit, 1.
  $30C0 If the number is zero, return with the carry flag set.
  $30C4 Point to the sign byte.
  $30C5 Get sign for result into #REGa (like signs give plus, unlike give minus); also reset the carry flag.
  $30C6 Set the true numeric bit.
  $30C8 Point to the exponent again.
  $30C9 Return with carry flag reset.
@ $30CA label=multiply
c $30CA THE 'MULTIPLICATION' OPERATION
D $30CA This subroutine first tests whether the two numbers to be multiplied are 'small integers'. If they are, it uses #R$2D7F to get them from the stack, #R$30A9 to multiply them and #R$2D8E to return the result to the stack. Any overflow of this 'short multiplication' (i.e. if the result is not itself a 'small integer') causes a jump to multiplication in full five byte floating-point form (see below).
  $30CA Test whether the first bytes of both numbers are zero.
  $30CC If not, jump for 'long' multiplication.
  $30CE Save the pointers to the second number.
  $30CF And to the first number.
  $30D0 And to the second number yet again.
  $30D1 Fetch sign in #REGc, number in #REGde.
  $30D4 Number to #REGhl now.
  $30D5 Number to stack, second pointer to #REGhl.
  $30D6 Save first sign in #REGb.
  $30D7 Fetch second sign in #REGc, number in #REGde.
  $30DA Form sign of result in #REGa: like signs give plus (00), unlike give minus (FF).
  $30DC Store sign of result in #REGc.
  $30DD Restore the first number to #REGhl.
  $30DE Perform the actual multiplication.
  $30E1 Store the result in #REGde.
  $30E2 Restore the pointer to the first number.
  $30E3 Jump on overflow to 'full' multiplication.
  $30E5 These 5 bytes ensure that 00 FF 00 00 00 is replaced by zero; that they should not be needed if this number were excluded from the system is noted at #R$303C.
@ $30EA label=MULT_RSLT
  $30EA Now store the result on the stack.
  $30ED Restore STKEND to #REGde.
  $30EE Finished.
@ $30EF label=MULT_OFLW
  $30EF Restore the pointer to the second number.
@ $30F0 label=MULT_LONG
  $30F0 Re-stack both numbers in full five byte floating-point form.
N $30F3 The full multiplication subroutine prepares the first number for multiplication by calling #R$30C0, returning if it is zero; otherwise the second number is prepared by again calling #R$30C0, and if it is zero the subroutine goes to set the result to zero. Next it fetches the two numbers from the calculator stack and multiplies their mantissas in the usual way, rotating the first number (treated as the multiplier) right and adding in the second number (the multiplicand) to the result whenever the multiplier bit is set. The exponents are then added together and checks are made for overflow and for underflow (giving the result zero). Finally, the result is normalised and returned to the calculator stack with the correct sign bit in the second byte.
  $30F3 #REGa is set to zero so that the sign of the first number will go into #REGa.
  $30F4 Prepare the first number, and return if zero. (Result already zero.)
  $30F8 Exchange the registers.
  $30F9 Save the next literal address.
  $30FA Exchange the registers.
  $30FB Save the pointer to the multiplicand.
  $30FC Exchange the pointers.
  $30FD Prepare the 2nd number.
  $3100 Exchange the pointers again.
  $3101 Jump forward if 2nd number is zero.
  $3103 Save the pointer to the result.
  $3104 Get the two numbers from the stack.
  $3107 M5 to #REGa (see #R$2FBA).
  $3108 Prepare for a subtraction.
  $3109 Initialise #REGhl to zero for the result.
  $310B Exchange the registers.
  $310C Save M1 and N1 (see #R$2FBA).
  $310D Also initialise #REGhl' for the result.
  $310F Exchange the registers.
  $3110 #REGb counts thirty three shifts.
  $3112 Jump forward into the loop.
N $3114 Now enter the multiplier loop.
@ $3114 label=MLT_LOOP
  $3114 Jump forward to #R$311B if no carry, i.e. the multiplier bit was reset.
  $3116 Else, add the multiplicand in #REGd'#REGe'#REGde (see #R$2FBA) into the result being built up in #REGh'#REGl'#REGhl.
@ $311B label=NO_ADD
  $311B Whether multiplicand was added or not, shift result right in #REGh'#REGl'#REGhl; the shift is done by rotating each byte with carry, so that any bit that drops into the carry is picked up by the next byte, and the shift continued into #REGb'#REGc'#REGc#REGa.
@ $3125 label=STRT_MLT
  $3125 Shift right the multiplier in #REGb'#REGc'#REGc#REGa (see #R$2FBA and above).
  $3128 A final bit dropping into the carry will trigger another add of the multiplicand to the result.
  $312E Loop 33 times to get all the bits.
  $3130 Move the result from #REGh'#REGl'#REGhl to #REGd'#REGe'#REGde.
N $3134 Now add the exponents together.
  $3134 Restore the exponents - M1 and N1.
  $3135 Restore the pointer to the exponent byte.
  $3136 Get the sum of the two exponent bytes in #REGa, and the correct carry.
  $3138 If the sum equals zero then clear the carry; else leave it unchanged.
@ $313B label=MAKE_EXPT
  $313B Prepare to increase the exponent by +80.
N $313D The rest of the subroutine is common to both #R$30CA and #R$31AF.
@ $313D label=DIVN_EXPT
  $313D These few bytes very cleverly make the correct exponent byte. Rotating left then right gets the exponent byte (true exponent plus +80) into #REGa.
  $3140 If the sign flag is reset, no report of arithmetic overflow needed.
  $3143 Report the overflow if carry reset.
  $3145 Clear the carry now.
@ $3146 label=OFLW1_CLR
  $3146 The exponent byte is now complete; but if #REGa is zero a further check for overflow is needed.
  $314B If there is no carry set and the result is already in normal form (bit 7 of #REGd' set) then there is overflow to report; but if bit 7 of #REGd' is reset, the result in just in range, i.e. just under 2**127.
@ $3151 label=OFLW2_CLR
  $3151 Store the exponent byte, at last.
  $3152 Pass the fifth result byte to #REGa for the normalisation sequence, i.e. the overflow from #REGl into #REGb'.
N $3155 The remainder of the subroutine deals with normalisation and is common to all the arithmetic routines.
@ $3155 label=TEST_NORM
  $3155 If no carry then normalise now.
  $3157 Else, deal with underflow (zero result) or near underflow (result 2**-128): return exponent to #REGa, test if #REGa is zero (case 2**-128) and if so produce 2**-128 if number is normal; otherwise produce zero. The exponent must then be set to zero (for zero) or 1 (for 2**-128).
@ $3159 label=NEAR_ZERO
@ $315D label=ZERO_RSLT
@ $315E label=SKIP_ZERO
  $3164 Restore the exponent byte.
  $3165 Jump if case 2**-128.
  $3167 Otherwise, put zero into second byte of result on the calculator stack.
  $316A Jump forward to transfer the result.
N $316C The actual normalisation operation.
@ $316C label=NORMALISE
  $316C Normalise the result by up to 32 shifts left of #REGd'#REGe'#REGde (with #REGa adjoined) until bit 7 of #REGd' is set. #REGa holds zero after addition so no precision is gained or lost; #REGa holds the fifth byte from #REGb' after multiplication or division; but as only about 32 bits can be correct, no precision is lost. Note that #REGa is rotated circularly, with branch at carry...eventually a random process.
@ $316E label=SHIFT_ONE
  $317F The exponent is decremented on each shift.
  $3180 If the exponent becomes zero, then number from 2**-129 are rounded up to 2**-128.
  $3182 Loop back, up to 32 times.
  $3184 If bit 7 never became 1 then the whole result is to be zero.
N $3186 Finish the normalisation by considering the 'carry'.
@ $3186 label=NORML_NOW
  $3186 After normalisation add back any final carry that went into #REGa. Jump forward if the carry does not ripple right back.
  $318E If it should ripple right back then set mantissa to 0.5 and increment the exponent. This action may lead to arithmetic overflow (final case).
N $3195 The final part of the subroutine involves passing the result to the bytes reserved for it on the calculator stack and resetting the pointers.
@ $3195 label=OFLOW_CLR
  $3195 Save the result pointer.
  $3196 Point to the sign byte in the result.
  $3197 The result is moved from #REGd'#REGe'#REGde to #REGbc#REGde, and then to #REGa#REGc#REGde.
  $319C The sign bit is retrieved from its temporary store and transferred to its correct position of bit 7 of the first byte of the mantissa.
  $31A0 The first byte is stored.
  $31A1 Next.
  $31A2 The second byte is stored.
  $31A3 Next.
  $31A4 The third byte is stored.
  $31A5 Next.
  $31A6 The fourth byte is stored.
  $31A7 Restore the pointer to the result.
  $31A8 Restore the pointer to second number.
  $31A9 Exchange the register.
  $31AA Restore the next literal address.
  $31AB Exchange the registers.
  $31AC Finished.
N $31AD Report 6 - Arithmetic overflow.
@ $31AD label=REPORT_6
M $31AD,2 Call the error handling routine.
B $31AE,1
@ $31AF label=division
c $31AF THE 'DIVISION' OPERATION
D $31AF This subroutine first prepares the divisor by calling #R$30C0, reporting arithmetic overflow if it is zero; then it prepares the dividend again calling #R$30C0, returning if it is zero. Next it fetches the two numbers from the calculator stack and divides their mantissa by means of the usual restoring division, trial subtracting the divisor from the dividend and restoring if there is carry, otherwise adding 1 to the quotient. The maximum precision is obtained for a 4-byte division, and after subtracting the exponents the subroutine exits by joining the later part of #R$30CA.
  $31AF Use full floating-point forms.
  $31B2 Exchange the pointers.
  $31B3 #REGa is set to 0, so that the sign of the first number will go into #REGa.
  $31B4 Prepare the divisor and give the report for arithmetic overflow if it is zero.
  $31B9 Exchange the pointers.
  $31BA Prepare the dividend and return if it is zero (result already zero).
  $31BE Exchange the pointers.
  $31BF Save the next literal address.
  $31C0 Exchange the registers.
  $31C1 Save pointer to divisor.
  $31C2 Save pointer to dividend.
  $31C3 Get the two numbers from the stack.
  $31C6 Exchange the registers.
  $31C7 Save M1 and N1 (the exponent bytes) on the machine stack.
  $31C8 Copy the four bytes of the dividend from registers #REGb'#REGc'#REGc#REGb (i.e. M2, M3, M4 and M5; see #R$2FBA) to the registers #REGh'#REGl'#REGhl.
  $31CD Clear #REGa and reset the carry flag.
  $31CE #REGb will count upwards from -33 to -1 (+DF to +FF), looping on minus and will jump again on zero for extra precision.
  $31D0 Jump forward into the division loop for the first trial subtraction.
N $31D2 Now enter the division loop.
@ $31D2 label=DIV_LOOP
  $31D2 Shift the result left into #REGb'#REGc'#REGc#REGa, shifting out the bits already there, picking up 1 from the carry whenever it is set, and rotating left each byte with carry to achieve the 32-bit shift.
@ $31DB label=DIV_34TH
  $31DB Move what remains of the dividend left in #REGh'#REGl'#REGhl before the next trial subtraction; if a bit drops into the carry, force no restore and a bit for the quotient, thus retrieving the lost bit and allowing a full 32-bit divisor.
@ $31E2 label=DIV_START
  $31E2 Trial subtract divisor in #REGd'#REGe'#REGde from rest of dividend in #REGh'#REGl'#REGhl; there is no initial carry (see previous step).
  $31E8 Jump forward if there is no carry.
  $31EA Otherwise restore, i.e. add back the divisor. Then clear the carry so that there will be no bit for the quotient (the divisor 'did not go').
  $31F0 Jump forward to the counter.
@ $31F2 label=SUBN_ONLY
  $31F2 Just subtract with no restore and go on to set the carry flag because the lost bit of the dividend is to be retrieved and used for the quotient.
@ $31F9 label=NO_RSTORE
  $31F9 One for the quotient in #REGb'#REGc'#REGc#REGa.
@ $31FA label=COUNT_ONE
  $31FA Step the loop count up by one.
  $31FB Loop 32 times for all bits.
  $31FE Save any 33rd bit for extra precision (the present carry).
  $31FF Trial subtract yet again for any 34th bit; the PUSH AF above saves this bit too.
N $3201 Note: this jump is made to the wrong place. No 34th bit will ever be obtained without first shifting the dividend. Hence important results like 1/10 and 1/1000 are not rounded up as they should be. Rounding up never occurs when it depends on the 34th bit. The jump should have been to #R$31DB above, i.e. byte 3200 hex in the ROM should read DA hex (128 decimal) instead of E1 hex (225 decimal).
  $3201 Now move the four bytes that form the mantissa of the result from #REGb'#REGc'#REGc#REGa to #REGd'#REGe'#REGde.
  $3206 Then put the 34th and 33rd bits into #REGb' to be picked up on normalisation.
  $320D Restore the exponent bytes M1 and N1.
  $320E Restore the pointer to the result.
  $320F Get the difference between the two exponent bytes into #REGa and set the carry flag if required.
  $3211 Exit via #R$313D.
@ $3214 label=truncate
c $3214 THE 'INTEGER TRUNCATION TOWARDS ZERO' SUBROUTINE
D $3214 This subroutine (say I(x)) returns the result of integer truncation of x, the 'last value', towards zero. Thus I(2.4) is 2 and I(-2.4) is -2. The subroutine returns at once if x is in the form of a 'short integer'. It returns zero if the exponent byte of x is less than 81 hex (ABS x is less than 1). If I(x) is a 'short integer' the subroutine returns it in that form. It returns x if the exponent byte is A0 hex or greater (x has no significant non-integral part). Otherwise the correct number of bytes of x are set to zero and, if needed, one more byte is split with a mask.
  $3214 Get the exponent byte of x into #REGa.
  $3215 If #REGa is zero, return since x is already a small integer.
  $3217 Compare e, the exponent, to 81 hex.
  $3219 Jump if e is greater than 80 hex.
  $321B Else, set the exponent to zero; enter 32 decimal (20 hex) into #REGa and jump forward to #R$3272 to make all the bits of x be zero.
@ $3221 label=T_GR_ZERO
  $3221 Compare e to 91 hex, 145 decimal.
  $3223 Jump if e not 91 hex.
N $3225 The next 26 bytes seem designed to test whether x is in fact -65536 decimal, i.e. 91 80 00 00 00, and if it is, to set it to 00 FF 00 00 00. This is a mistake. As #R$303C(already stated), the Spectrum system cannot handle this number. The result here is simply to make INT (-65536) return the value -1. This is a pity, since the number would have been perfectly all right if left alone. The remedy would seem to be simply to omit the 28 bytes from 3223 above to 323E inclusive from the program.
  $3225 #REGhl is pointed at the fourth byte of x, where the 17 bits of the integer part of x end after the first bit.
  $3228 The first bit is obtained in #REGa, using 80 hex as a mask.
  $322B That bit and the previous 8 bits are tested together for zero.
  $322D #REGhl is pointed at the second byte of x.
  $322E If already non-zero, the test can end.
  $3230 Otherwise, the test for -65536 is now completed: 91 80 00 00 00 will leave the zero flag set now.
@ $3233 label=T_FIRST
  $3233 #REGhl is pointed at the first byte of x.
  $3234 If zero reset, the jump is made.
  $3236 The first byte is set to zero.
  $3237 #REGhl points to the second byte.
  $3238 The second byte is set to FF.
  $323A #REGhl again points to the first byte.
  $323B The last 24 bits are to be zero.
  $323D The jump to #R$3272 completes the number 00 FF 00 00 00.
N $323F If the exponent byte of x is between 81 and 90 hex (129 and 144 decimal) inclusive, I(x) is a 'small integer', and will be compressed into one or two bytes. But first a test is made to see whether x is, after all, large.
@ $323F label=T_SMALL
  $323F Jump with exponent byte 92 or more (it would be better to jump with 91 too).
  $3241 Save STKEND in #REGde.
  $3242 Range 129<=#REGa<=144 becomes 126>=#REGa>=111.
  $3243 Range is now 15>=#REGa>=0.
  $3245 Point #REGhl at second byte.
  $3246 Second byte to #REGd.
  $3247 Point #REGhl at third byte.
  $3248 Third byte to #REGe.
  $3249 Point #REGhl at first byte again.
  $324B Assume a positive number.
  $324D Now test for negative (bit 7 set).
  $324F Jump if positive after all.
  $3251 Change the sign.
@ $3252 label=T_NUMERIC
  $3252 Insert true numeric bit, 1, in #REGd.
  $3254 Now test whether #REGa>=8 (one byte only) or two bytes needed.
  $3257 Leave #REGa unchanged.
  $3258 Jump if two bytes needed.
  $325A Put the one byte into #REGe.
  $325B And set #REGd to zero.
  $325D Now 1<=#REGa<=7 to count the shifts needed.
@ $325E label=T_TEST
  $325E Jump if no shift needed.
  $3260 #REGb will count the shifts.
@ $3261 label=T_SHIFT
  $3261 Shift #REGd and #REGe right #REGb times to produce the correct number.
  $3265 Loop until #REGb is zero.
@ $3267 label=T_STORE
  $3267 Store the result on the stack.
  $326A Restore STKEND to #REGde.
  $326B Finished.
N $326C Large values of x remain to be considered.
@ $326C label=T_EXPNENT
  $326C Get the exponent byte of x into #REGa.
@ $326D label=X_LARGE
  $326D Subtract 160 decimal, A0 hex, from e.
  $326F Return on plus - x has no significant non-integral part. (If the true exponent were reduced to zero, the 'binary point' would come at or after the end of the four bytes of the mantissa.)
  $3270 Else, negate the remainder; this gives the number of bits to become zero (the number of bits after the 'binary point').
N $3272 Now the bits of the mantissa can be cleared.
@ $3272 label=NIL_BYTES
  $3272 Save the current value of #REGde (STKEND).
  $3273 Make #REGhl point one past the fifth byte.
  $3274 #REGhl now points to the fifth byte of x.
  $3275 Get the number of bits to be set to zero in #REGb and divide it by 8 to give the number of whole bytes implied.
  $327C Jump forward if the result is zero.
@ $327E label=BYTE_ZERO
  $327E Else, set the bytes to zero; #REGb counts them.
@ $3283 label=BITS_ZERO
  $3283 Get #REGa (mod 8); this is the number of bits still to be set to zero.
  $3285 Jump to the end if nothing more to do.
  $3287 #REGb will count the bits now.
  $3288 Prepare the mask.
@ $328A label=LESS_MASK
  $328A With each loop a zero enters the mask from the right and thereby a mask of the correct length is produced.
  $328E The unwanted bits of (#REGhl) are lost as the masking is performed.
@ $3290 label=IX_END
  $3290 Return the pointer to #REGhl.
  $3291 Return STKEND to #REGde.
  $3292 Finished.
@ $3293 label=RE_ST_TWO
c $3293 THE 'RE-STACK TWO' SUBROUTINE
D $3293 This subroutine is called to re-stack two 'small integers' in full five-byte floating-point form for the binary operations of addition, multiplication and division. It does so by calling the following subroutine twice.
  $3293 Call the subroutine and then continue into it for the second call.
@ $3296 label=RESTK_SUB
  $3296 Exchange the pointers at each call.
@ $3297 label=RE_STACK
c $3297 THE 'RE-STACK' SUBROUTINE
D $3297 This subroutine is called to re-stack one number (which could be a 'small integer') in full five byte floating-point form. It is used for a single number by #R$37E2 and also, through the calculator offset, by #R$36C4, #R$3713 and #R$3783.
  $3297 If the first byte is not zero, return - the number cannot be a 'small integer'.
  $329A Save the 'other' pointer in #REGde.
  $329B Fetch the sign in #REGc and the number in #REGde.
  $329E Clear the #REGa register.
  $329F Point to the fifth location.
  $32A0 Set the fifth byte to zero.
  $32A1 Point to the fourth location.
  $32A2 Set the fourth byte to zero; bytes 2 and 3 will hold the mantissa.
  $32A3 Set #REGb to 145 dec for the exponent, i.e. for up to 16 bits in the integer.
  $32A5 Test whether #REGd is zero so that at most 8 bits would be needed.
  $32A7 Jump if more than 8 bits needed.
  $32A9 Now test #REGe too.
  $32AA Save the zero in #REGb (it will give zero exponent if #REGe too is zero).
  $32AB Jump if #REGe is indeed zero.
  $32AD Move #REGe to #REGd (#REGd was zero, #REGe not).
  $32AE Set #REGe to zero now.
  $32AF Set #REGb to 137 dec for the exponent - no more than 8 bits now.
@ $32B1 label=RS_NRMLSE
  $32B1 Pointer to #REGde, number to #REGhl.
@ $32B2 label=RSTK_LOOP
  $32B2 Decrement the exponent on each shift.
  $32B3 Shift the number right one position.
  $32B4 Until the carry is set.
  $32B6 Sign bit to carry flag now.
  $32B8 Insert it in place as the number is shifted back one place normal now.
  $32BC Pointer to byte 4 back to #REGhl.
@ $32BD label=RS_STORE
  $32BD Point to the third location.
  $32BE Store the third byte.
  $32BF Point to the second location.
  $32C0 Store the second byte.
  $32C1 Point to the first location.
  $32C2 Store the exponent byte.
  $32C3 Restore the 'other' pointer to #REGde.
  $32C4 Finished.
@ $32C5 label=CONSTANTS
b $32C5 THE TABLE OF CONSTANTS
D $32C5 This table holds five useful and frequently needed numbers: zero, one, a half, a half of pi, and ten. The numbers are held in a condensed form which is expanded by the routine at #R$33C6 to give the required floating-point form.
  $32C5,3 zero (00 00 00 00 00)
@ $32C8 label=stk_one
  $32C8,4 one (00 00 01 00 00)
@ $32CC label=stk_half
  $32CC,2 a half (80 00 00 00 00)
@ $32CE label=stk_pi_2
  $32CE,5 a half of pi (81 49 0F DA A2)
@ $32D3 label=stk_ten
  $32D3,4 ten (00 00 0A 00 00)
@ $32D7 label=CALCADDR
w $32D7 THE TABLE OF ADDRESSES
D $32D7 This table is a look-up table of the addresses of the sixty-six operational subroutines of the calculator. The offsets used to index into the table are derived either from the operation codes used in the routine at #R$24FB (see #R$2734, etc.) or from the literals that follow a 'RST 28' instruction.
  $32D7 00
  $32D9 01
  $32DB 02
  $32DD 03
  $32DF 04
  $32E1 05
  $32E3 06
  $32E5 07
  $32E7 08
  $32E9 09
  $32EB 0A
  $32ED 0B
  $32EF 0C
  $32F1 0D
  $32F3 0E
  $32F5 0F
  $32F7 10
  $32F9 11
  $32FB 12
  $32FD 13
  $32FF 14
  $3301 15
  $3303 16
  $3305 17
  $3307 18
  $3309 19
  $330B 1A
  $330D 1B
  $330F 1C
  $3311 1D
  $3313 1E
  $3315 1F
  $3317 20
  $3319 21
  $331B 22
  $331D 23
  $331F 24
  $3321 25
  $3323 26
  $3325 27
  $3327 28
  $3329 29
  $332B 2A
  $332D 2B
  $332F 2C
  $3331 2D
  $3333 2E
  $3335 2F
  $3337 30
  $3339 31
  $333B 32
  $333D 33
  $333F 34
  $3341 35
  $3343 36
  $3345 37
  $3347 38
  $3349 39
  $334B 3A
  $334D 3B
  $334F 3C
  $3351 3D
  $3353 3E
  $3355 3F
  $3357 40
  $3359 41
E $32D7 Note: the last four subroutines are multi-purpose subroutines and are entered with a parameter that is a copy of the right hand five bits of the original literal. The full set follows:
E $32D7 #LIST { Offset 3E: series-06, series-08 and series-0C; literals 86, 88 and 8C. } { Offset 3F: stk-zero, stk-one, stk-half, stk-pi/2 and stk-ten; literals A0 to A4. } { Offset 40: st-mem-0, st-mem-1, st-mem-2, st-mem-3, st-mem-4 and st-mem-5; literals C0 to C5. } { Offset 41: get-mem-0, get-mem-1, get-mem-2, get-mem-3, get-mem-4 and get-mem-5; literals E0 to E5. } LIST#
@ $335B label=CALCULATE
c $335B THE 'CALCULATE' SUBROUTINE
D $335B This subroutine is used to perform floating-point calculations. These can be considered to be of three types:
D $335B #LIST { Binary operations, e.g. #R$3014, where two numbers in floating-point form are added together to give one 'last value'. } { Unary operations, e.g. #R$37B5, where the 'last value' is changed to give the appropriate function result as a new 'last value'. } { Manipulatory operations, e.g. #R$342D, where the 'last value' is copied to the first five bytes of the calculator's memory area. } LIST#
D $335B The operations to be performed are specified as a series of data-bytes, the literals, that follow an RST 28 instruction that calls this subroutine. The last literal in the list is always '38' which leads to an end to the whole operation.
D $335B In the case of a single operation needing to be performed, the operation offset can be passed to the calculator in the #REGb register, and operation '3B', the #R$33A2(single calculation operation), performed.
D $335B It is also possible to call this subroutine recursively, i.e. from within itself, and in such a case it is possible to use the system variable BREG as a counter that controls how many operations are performed before returning.
D $335B The first part of this subroutine is complicated but essentially it performs the two tasks of setting the registers to hold their required values, and to produce an offset, and possibly a parameter, from the literal that is currently being considered.
D $335B The offset is used to index into the calculator's #R$32D7(table of addresses) to find the required subroutine address.
D $335B The parameter is used when the multi-purpose subroutines are called.
D $335B Note: a floating-point number may in reality be a set of string parameters.
  $335B Presume a unary operation and therefore set #REGhl to point to the start of the 'last value' on the calculator stack and #REGde one past this floating-point number (STKEND).
@ $335E label=GEN_ENT_1
  $335E Either transfer a single operation offset to BREG temporarily, or, when using the subroutine recursively, pass the parameter to BREG to be used as a counter.
@ $3362 label=GEN_ENT_2
  $3362 The return address of the subroutine is stored in #REGhl'. This saves the pointer to the first literal. Entering the calculator here is done whenever BREG is in use as a counter and is not to be disturbed.
@ $3365 label=RE_ENTRY
  $3365 A loop is now entered to handle each literal in the list that follows the calling instruction; so first, always set to STKEND.
  $3369 Go to the alternate register set and fetch the literal for this loop.
  $336B Make #REGhl' point to the next literal.
@ $336C label=SCAN_ENT
  $336C This pointer is saved briefly on the machine stack. #R$336C is used by #R$33A2 to find the subroutine that is required.
  $336D Test the #REGa register.
  $336E Separate the simple literals from the multi-purpose literals. Jump with literals 00 to 3D.
  $3371 Save the literal in #REGd.
  $3372 Continue only with bits 5 and 6.
  $3374 Four right shifts make them now bits 1 and 2.
  $3378 The offsets required are 3E to 41, and #REGl will now hold double the required offset.
  $337B Now produce the parameter by taking bits 0, 1, 2, 3 and 4 of the literal; keep the parameter in #REGa.
  $337E Jump forward to find the address of the required subroutine.
@ $3380 label=FIRST_3D
  $3380 Jump forward if performing a unary operation.
  $3384 All of the subroutines that perform binary operations require that #REGhl points to the first operand and #REGde points to the second operand (the 'last value') as they appear on the calculator stack.
@ $338C label=DOUBLE_A
  $338C As each entry in the table of addresses takes up two bytes the offset produced is doubled.
@ $338E label=ENT_TABLE
  $338E The base address of the #R$32D7(table).
  $3391 The address of the required table entry is formed in #REGhl, and the required subroutine address is loaded into the #REGde register pair.
@ $3397 nowarn
  $3397 The address of #R$3365 is put on the machine stack underneath the subroutine address.
  $339C Return to the main set of registers.
  $339D The current value of BREG is transferred to the #REGb register thereby returning the single operation offset (see #R$353B).
@ $33A1 label=delete
  $33A1 An indirect jump to the required subroutine.
E $335B The #R$33A1 subroutine contains only the single RET instruction above. The literal '02' results in this subroutine being considered as a binary operation that is to be entered with a first number addressed by the #REGhl register pair and a second number addressed by the #REGde register pair, and the result produced again addressed by the #REGhl register pair.
E $335B The single RET instruction thereby leads to the first number being considered as the resulting 'last value' and the second number considered as being deleted. Of course the number has not been deleted from the memory but remains inactive and will probably soon be overwritten.
@ $33A2 label=fp_calc_2
c $33A2 THE 'SINGLE OPERATION' SUBROUTINE
D $33A2 This subroutine is only called from #R$2757 and is used to perform a single arithmetic operation. The offset that specifies which operation is to be performed is supplied to the calculator in the #REGb register and subsequently transferred to the system variable BREG.
D $33A2 The effect of calling this subroutine is essentially to make a jump to the appropriate subroutine for the single operation.
  $33A2 Discard the #R$3365 address.
  $33A3 Transfer the offset to #REGa.
  $33A6 Enter the alternate register set.
  $33A7 Jump back to find the required address; stack the #R$3365 address and jump to the subroutine for the operation.
@ $33A9 label=TEST_5_SP
c $33A9 THE 'TEST 5-SPACES' SUBROUTINE
D $33A9 This subroutine tests whether there is sufficient room in memory for another 5-byte floating-point number to be added to the calculator stack.
  $33A9 Save #REGde briefly.
  $33AA Save #REGhl briefly.
@ $33AB keep
  $33AB Specify the test is for 5 bytes.
  $33AE Make the test.
  $33B1 Restore #REGhl.
  $33B2 Restore #REGde.
  $33B3 Finished.
@ $33B4 label=STACK_NUM
c $33B4 THE 'STACK NUMBER' SUBROUTINE
D $33B4 This subroutine is called by #R$03F8, #R$25AF and #R$26C9 to copy STKEND to #REGde, move a floating-point number to the calculator stack, and reset STKEND from #REGde. It calls #R$33C0 to do the actual move.
  $33B4 Copy STKEND to #REGde as destination address.
  $33B8 Move the number.
  $33BB Reset STKEND from #REGde.
  $33BF Finished.
@ $33C0 label=MOVE_FP
c $33C0 THE 'MOVE A FLOATING-POINT NUMBER' SUBROUTINE
D $33C0 This subroutine moves a floating-point number to the top of the calculator stack (3 cases) or from the top of the stack to the calculator's memory area (1 case). It is also called through the calculator when it simply duplicates the number at the top of the calculator stack, the 'last value', thereby extending the stack by five bytes.
  $33C0 A test is made for room.
  $33C3 Move the five bytes involved.
  $33C5 Finished.
@ $33C6 label=STK_DATA
c $33C6 THE 'STACK LITERALS' SUBROUTINE
D $33C6 This subroutine places on the calculator stack, as a 'last value', the floating-point number supplied to it as 2, 3, 4 or 5 literals.
D $33C6 When called by using offset '34' the literals follow the '34' in the list of literals; when called by the #R$3449(series generator), the literals are supplied by the subroutine that called for a series to be generated; and when called by #R$33F7 and #R$341B the literals are obtained from the calculator's #R$32C5(table of constants).
D $33C6 In each case, the first literal supplied is divided by +40, and the integer quotient plus 1 determines whether 1, 2, 3 or 4 further literals will be taken from the source to form the mantissa of the number. Any unfilled bytes of the five bytes that go to form a 5-byte floating-point number are set to zero. The first literal is also used to determine the exponent, after reducing mod +40, unless the remainder is zero, in which case the second literal is used, as it stands, without reducing mod +40. In either case, +50 is added to the literal, giving the augmented exponent byte, e (the true exponent e' plus +80). The rest of the 5 bytes are stacked, including any zeros needed, and the subroutine returns.
  $33C6 This subroutine performs the manipulatory operation of adding a 'last value' to the calculator stack; hence #REGhl is set to point one past the present 'last value' and hence point to the result.
@ $33C8 label=STK_CONST
  $33C8 Now test that there is indeed room.
  $33CB Go to the alternate register set and stack the pointer to the next literal.
  $33CE Switch over the result pointer and the next literal pointer.
  $33CF Save #REGbc briefly.
  $33D0 The first literal is put into #REGa and divided by +40 to give the integer values 0, 1, 2 or 3.
  $33D5 The integer value is transferred to #REGc and incremented, thereby giving the range 1, 2, 3 or 4 for the number of literals that will be needed.
  $33D7 The literal is fetched anew, reduced mod +40 and discarded as inappropriate if the remainder if zero; in which case the next literal is fetched and used unreduced.
@ $33DE label=FORM_EXP
  $33DE The exponent, e, is formed by the addition of +50 and passed to the calculator stack as the first of the five bytes of the result.
  $33E1 The number of literals specified in #REGc are taken from the source and entered into the bytes of the result.
  $33EA Restore #REGbc.
  $33EB Return the result pointer to #REGhl and the next literal pointer to its usual position in #REGhl'.
  $33EF The number of zero bytes required at this stage is given by 5-#REGc-1, and this number of zeros is added to the result to make up the required five bytes.
@ $33F1 label=STK_ZEROS
@ $33F7 label=SKIP_CONS
c $33F7 THE 'SKIP CONSTANTS' SUBROUTINE
D $33F7 This subroutine is entered with the #REGhl register pair holding the base address of the calculator's #R$32C5(table of constants) and the #REGa register holding a parameter that shows which of the five constants is being requested.
D $33F7 The subroutine performs the null operations of loading the five bytes of each unwanted constant into the locations 0000, 0001, 0002, 0003 and 0004 at the beginning of the ROM until the requested constant is reached.
D $33F7 The subroutine returns with the #REGhl register pair holding the base address of the requested constant within the table of constants.
  $33F7 The subroutine returns if the parameter is zero, or when the requested constant has been reached.
@ $33F8 label=SKIP_NEXT
  $33F9 Save the parameter.
  $33FA Save the result pointer.
@ $33FB keep
  $33FB The dummy address.
  $33FE Perform imaginary stacking of an expanded constant.
  $3401 Restore the result pointer.
  $3402 Restore the parameter.
  $3403 Count the loops.
  $3404 Jump back to consider the value of the counter.
@ $3406 label=LOC_MEM
c $3406 THE 'MEMORY LOCATION' SUBROUTINE
D $3406 This subroutine finds the base address for each five-byte portion of the calculator's memory area to or from which a floating-point number is to be moved from or to the calculator stack. It does this operation by adding five times the parameter supplied to the base address for the area which is held in the #REGhl register pair.
D $3406 Note that when a FOR-NEXT variable is being handled then the pointers are changed so that the variable is treated as if it were the calculator's memory area.
  $3406 Copy the parameter to #REGc.
  $3407 Double the parameter.
  $3408 Double the result.
  $3409 Add the value of the parameter to give five times the original value.
  $340A This result is wanted in the #REGbc register pair.
  $340D Produce the new base address.
  $340E Finished.
@ $340F label=get_mem_0
c $340F THE 'GET FROM MEMORY AREA' SUBROUTINE
D $340F This subroutine is called using the literals E0 to E5 and the parameter derived from these literals is held in the #REGa register. The subroutine calls #R$3406 to put the required source address into the #REGhl register pair and #R$33C0 to copy the five bytes involved from the calculator's memory area to the top of the calculator stack to form a new 'last value'.
  $340F Save the result pointer.
  $3410 Fetch the pointer to the current memory area.
  $3413 The base address is found.
  $3416 The five bytes are moved.
  $3419 Set the result pointer.
  $341A Finished.
@ $341B label=stk_zero_2
c $341B THE 'STACK A CONSTANT' SUBROUTINE
D $341B This subroutine uses #R$33F7 to find the base address of the requested constants from the calculator's table of constants and then calls #R$33C8 to make the expanded form of the constant the 'last value' on the calculator stack.
  $341B Set #REGhl to hold the result pointer.
  $341D Go to the alternate register set and save the next literal pointer.
  $341F The base address of the calculator's table of constants.
  $3422 Back to the main set of registers.
  $3423 Find the requested base address.
  $3426 Expand the constant.
  $3429 Restore the next literal pointer.
  $342C Finished.
@ $342D label=st_mem_0
c $342D THE 'STORE IN MEMORY AREA' SUBROUTINE
D $342D This subroutine is called using the literals C0 to C5 and the parameter derived from these literals is held in the #REGa register. This subroutine is very similar to #R$340F but the source and destination pointers are exchanged.
  $342D Save the result pointer.
  $342E Source to #REGde briefly.
  $342F Fetch the pointer to the current memory area.
  $3432 The base address is found.
  $3435 Exchange source and destination pointers.
  $3436 The five bytes are moved.
  $3439 'Last value'+5, i.e. STKEND, to #REGde.
  $343A Result pointer to #REGhl.
  $343B Finished.
E $342D Note that the pointers #REGhl and #REGde remain as they were, pointing to STKEND-5 and STKEND respectively, so that the 'last value' remains on the calculator stack. If required it can be removed by using #R$33A1.
@ $343C label=EXCHANGE
c $343C THE 'EXCHANGE' SUBROUTINE
D $343C This binary operation 'exchanges' the first number with the second number, i.e. the topmost two numbers on the calculator stack are exchanged.
  $343C There are five bytes involved.
@ $343E label=SWAP_BYTE
  $343E Each byte of the second number.
  $343F Each byte of the first number.
  $3440 Switch source and destination.
  $3441 Now to the first number.
  $3442 Now to the second number.
  $3443 Move to consider the next pair of bytes.
  $3445 Exchange the five bytes.
  $3447 Get the pointers correct as 5 is an odd number.
  $3448 Finished.
@ $3449 label=series_06
c $3449 THE 'SERIES GENERATOR' SUBROUTINE
D $3449 This important subroutine generates the series of Chebyshev polynomials which are used to approximate to SIN, ATN, LN and EXP and hence to derive the other arithmetic functions which depend on these (COS, TAN, ASN, ACS, ** and SQR).
D $3449 #HTML[The polynomials are generated, for n=1, 2, etc. by the recurrence relation T<sub>n+1</sub>(z)=2zT<sub>n</sub>(z)-T<sub>n-1</sub>(z), where T<sub>n</sub>(z) is the nth Chebyshev polynomial in z.]
D $3449 #HTML[The series in fact generates T<sub>0</sub>, 2T<sub>1</sub>, 2T<sub>2</sub>, ..., 2T<sub>n-1</sub>, where n is 6 for SIN, 8 for EXP, and 12 decimal for LN and ATN.]
D $3449 #HTML[The coefficients of the powers of z in these polynomials may be found in the Handbook of Mathematical Functions by M. Abramowitz and I. A. Stegun (Dover 1965), page 795.]
D $3449 In simple terms this subroutine is called with the 'last value' on the calculator stack, say Z, being a number that bears a simple relationship to the argument, say X, when the task is to evaluate, for instance, SIN X. The calling subroutine also supplies the list of constants that are to be required (six constants for SIN). The #R$3449(series generator) then manipulates its data and returns to the calling routine a 'last value' that bears a simple relationship to the requested function, for instance, SIN X.
D $3449 This subroutine can be considered to have four major parts.
D $3449 i. The setting of the loop counter. The calling subroutine passes its parameters in the #REGa register for use as a counter. The calculator is entered at #R$335E so that the counter can be set.
  $3449 Move the parameter to #REGb.
  $344A In effect a RST 28 instruction but sets the counter.
N $344D ii. The handling of the 'last value', Z. The loop of the generator requires 2*Z to be placed in mem-0, zero to be placed in mem-2 and the 'last value' to be zero.
B $344D,1 #R$33C0: Z, Z
B $344E,1 #R$3014: 2*Z
B $344F,1 #R$342D: 2*Z (mem-0 holds 2*Z)
B $3450,1 #R$33A1: -
B $3451,1 #R$341B(stk_zero): 0
B $3452,1 #R$342D(st_mem_2): 0 (mem-2 holds 0)
@ $3453 label=G_LOOP
N $3453 iii. The main loop.
N $3453 The series is generated by looping, using BREG as a counter; the constants in the calling subroutine are stacked in turn by calling #R$33C6; the calculator is re-entered at #R$3362 so as not to disturb the value of BREG; and the series is built up in the form:
N $3453 B(R)=2*Z*B(R-1)-B(R-2)+A(R), for R=1, 2, ..., N, where A(1), A(2)...A(N) are the constants supplied by the calling subroutine (SIN, ATN, LN and EXP) and B(0)=0=B(-1).
N $3453 The (R+1)th loop starts with B(R) on the stack and with 2*Z, B(R-2) and B(R-1) in mem-0, mem-1 and mem-2 respectively.
B $3453,1 #R$33C0: B(R), B(R)
B $3454,1 #R$340F(get_mem_0): B(R), B(R), 2*Z
B $3455,1 #R$30CA: B(R), 2*B(R)*Z
B $3456,1 #R$340F(get_mem_2): B(R),2*B(R)*Z, B(R-1)
B $3457,1 #R$342D(st_mem_1): mem-1 holds B(R-1)
B $3458,1 #R$300F: B(R), 2*B(R)*Z-B(R-1)
B $3459,1 #R$369B
N $345A The next constant is placed on the calculator stack.
  $345A B(R), 2*B(R)*Z-B(R-1), A(R+1)
N $345D The calculator is re-entered without disturbing BREG.
B $3460,1 #R$3014: B(R), 2*B(R)*Z-B(R-1)+A(R+1)
B $3461,1 #R$343C: 2*B(R)*Z-B(R-1)+A(R+1), B(R)
B $3462,1 #R$342D(st_mem_2): mem-2 holds B(R)
B $3463,1 #R$33A1: 2*B(R)*Z-B(R-1)+A(R+1)=B(R+1)
B $3464,2,1 #R$367A to #R$3453: B(R+1)
N $3466 iv. The subtraction of B(N-2). The loop above leaves B(N) on the stack and the required result is given by B(N)-B(N-2).
B $3466,1 #R$340F(get_mem_1): B(N), B(N-2)
B $3467,1 #R$300F: B(N)-B(N-2)
B $3468,1 #R$369B
  $3469 Finished.
@ $346A label=abs
c $346A THE 'ABSOLUTE MAGNITUDE' FUNCTION
D $346A This subroutine performs its unary operation by ensuring that the sign bit of a floating-point number is reset.
D $346A 'Small integers' have to be treated separately. Most of the work is shared with the 'unary minus' operation.
  $346A #REGb is set to FF hex.
  $346C The jump is made into 'unary minus'.
@ $346E label=NEGATE
c $346E THE 'UNARY MINUS' OPERATION
D $346E This subroutine performs its unary operation by changing the sign of the 'last value' on the calculator stack.
D $346E Zero is simply returned unchanged. Full five byte floating-point numbers have their sign bit manipulated so that it ends up reset (for 'abs') or changed (for 'negate'). 'Small integers' have their sign byte set to zero (for 'abs') or changed (for 'negate').
  $346E If the number is zero, the subroutine returns leaving 00 00 00 00 00 unchanged.
  $3472 #REGb is set to +00 hex for 'negate'.
@ $3474 label=NEG_TEST
  $3474 If the first byte is zero, the jump is made to deal with a 'small integer'.
  $3478 Point to the second byte.
  $3479 Get +FF for 'abs', +00 for 'negate'.
  $347A Now +80 for 'abs', +00 for 'negate'.
  $347C This sets bit 7 for 'abs', but changes nothing for 'negate'.
  $347D Now bit 7 is changed, leading to bit 7 of byte 2 reset for 'abs', and simply changed for 'negate'.
  $3480 The new second byte is stored.
  $3481 #REGhl points to the first byte again.
  $3482 Finished.
N $3483 The 'integer case' does a similar operation with the sign byte.
@ $3483 label=INT_CASE
  $3483 Save STKEND in #REGde.
  $3484 Save pointer to the number in #REGhl.
  $3485 Fetch the sign in #REGc, the number in #REGde.
  $3488 Restore the pointer to the number in #REGhl.
  $3489 Get +FF for 'abs', +00 for 'negate'.
  $348A Now +FF for 'abs', no change for 'negate'.
  $348B Now +00 for 'abs', and a changed byte for 'negate'; store it in #REGc.
  $348D Store result on the stack.
  $3490,1 Return STKEND to #REGde.
@ $3492 label=sgn
c $3492 THE 'SIGNUM' FUNCTION
D $3492 This subroutine handles the function SGN X and therefore returns a 'last value' of 1 if X is positive, zero if X is zero and -1 if X is negative.
  $3492 If X is zero, just return with zero as the 'last value'.
  $3496 Save the pointer to STKEND.
@ $3497 keep
  $3497 Store 1 in #REGde.
  $349A Point to the second byte of X.
  $349B Rotate bit 7 into the carry flag.
  $349D Point to the destination again.
  $349E Set #REGc to zero for positive X and to +FF for negative X.
  $34A0 Stack 1 or -1 as required.
  $34A3 Restore the pointer to STKEND.
  $34A4 Finished.
@ $34A5 label=f_in
c $34A5 THE 'IN' FUNCTION
D $34A5 This subroutine handles the function IN X. It inputs at processor level from port X, loading #REGbc with X and performing the instruction IN A,(C).
  $34A5 The 'last value', X, is compressed into #REGbc.
  $34A8 The signal is received.
  $34AA Jump to stack the result.
@ $34AC label=peek
c $34AC THE 'PEEK' FUNCTION
D $34AC This subroutine handles the function PEEK X. The 'last value' is unstacked by calling #R$1E99 and replaced by the value of the contents of the required location.
  $34AC Evaluate the 'last value', rounded to the nearest integer; test that it is in range and return it in #REGbc.
  $34AF Fetch the required byte.
@ $34B0 label=IN_PK_STK
  $34B0 Exit by jumping to #R$2D28.
@ $34B3 label=usr_no
c $34B3 THE 'USR' FUNCTION
D $34B3 This subroutine ('USR number' as distinct from 'USR string') handles the function USR X, where X is a number. The value of X is obtained in #REGbc, a return address is stacked and the machine code is executed from location X.
  $34B3 Evaluate the 'last value', rounded to the nearest integer; test that it is in range and return it in #REGbc.
@ $34B6 nowarn
  $34B6 Make the return address be that of the subroutine #R$2D2B.
  $34BA Make an indirect jump to the required location.
E $34B3 Note: it is interesting that the #REGiy register pair is re-initialised when the return to #R$2D2B has been made, but the important #REGhl' that holds the next literal pointer is not restored should it have been disturbed. For a successful return to BASIC, #REGhl' must on exit from the machine code contain the address of the 'end-calc' instruction at #R$2758(2758) hex (10072 decimal).
@ $34BC label=usr
c $34BC THE 'USR STRING' FUNCTION
D $34BC This subroutine handles the function USR X$, where X$ is a string. The subroutine returns in #REGbc the address of the bit pattern for the user-defined graphic corresponding to X$. It reports error A if X$ is not a single letter between 'a' and 'u' or a user-defined graphic.
  $34BC Fetch the parameters of the string X$.
  $34BF Decrease the length by 1 to test it.
  $34C0 If the length was not 1, then jump to give error report A.
  $34C4 Fetch the single code of the string.
  $34C5 Does it denote a letter?
  $34C8 If so, jump to gets its address.
  $34CA Reduce range for actual user-defined graphics to 0-20 decimal.
  $34CC Give report A if out of range.
  $34CE Test the range again.
  $34D0 Give report A if out of range.
  $34D2 Make range of user-defined graphics 1 to 21 decimal, as for 'a' to 'u'.
@ $34D3 label=USR_RANGE
  $34D3 Now make the range 0 to 20 decimal in each case.
  $34D4 Multiply by 8 to get an offset for the address.
  $34D7 Test the range of the offset.
  $34D9 Give report A if out of range.
  $34DB Fetch the address of the first user-defined graphic in #REGbc.
  $34DF Add #REGc to the offset.
  $34E0 Store the result back in #REGc.
  $34E1 Jump if there is no carry.
  $34E3 Increment #REGb to complete the address.
@ $34E4 label=USR_STACK
  $34E4 Jump to stack the address.
N $34E7 Report A - Invalid argument.
@ $34E7 label=REPORT_A
M $34E7,2 Call the error handling routine.
B $34E8,1
@ $34E9 label=TEST_ZERO
c $34E9 THE 'TEST-ZERO' SUBROUTINE
D $34E9 This subroutine is called at least nine times to test whether a floating-point number is zero. This test requires that the first four bytes of the number should each be zero. The subroutine returns with the carry flag set if the number was in fact zero.
  $34E9 Save #REGhl on the stack.
  $34EA Save #REGbc on the stack.
  $34EB Save the value of #REGa in #REGb.
  $34EC Get the first byte.
  $34ED Point to the second byte.
  $34EE OR the first byte with the second.
  $34EF Point to the third byte.
  $34F0 OR the result with the third byte.
  $34F1 Point to the fourth byte.
  $34F2 OR the result with the fourth byte.
  $34F3 Restore the original value of #REGa.
  $34F4 And of #REGbc.
  $34F5 Restore the pointer to the number to #REGhl.
  $34F6 Return with carry reset if any of the four bytes was non-zero.
  $34F7 Set the carry flag to indicate that the number was zero, and return.
@ $34F9 label=GREATER_0
c $34F9 THE 'GREATER THAN ZERO' OPERATION
D $34F9 This subroutine returns a 'last value' of one if the present 'last value' is greater than zero and zero otherwise. It is also used by other subroutines to 'jump on plus'.
  $34F9 Is the 'last-value' zero?
  $34FC If so, return.
  $34FD Jump forward to #R$3506 but signal the opposite action is needed.
@ $3501 label=f_not
c $3501 THE 'NOT' FUNCTION
D $3501 This subroutine returns a 'last value' of one if the present 'last value' is zero and zero otherwise. It is also used by other subroutines to 'jump on zero'.
  $3501 The carry flag will be set only if the 'last value' is zero; this gives the correct result.
  $3504 Jump forward.
@ $3506 label=less_0
c $3506 THE 'LESS THAN ZERO' OPERATION
D $3506 This subroutine returns a 'last value' of one if the present 'last value' is less than zero and zero otherwise. It is also used by other subroutines to 'jump on minus'.
  $3506 Clear the #REGa register.
@ $3507 label=SIGN_TO_C
  $3507 Point to the sign byte.
  $3508 The carry is reset for a positive number and set for a negative number; when entered from #R$34F9 the opposite sign goes to the carry.
@ $350B label=FP_0_1
c $350B THE 'ZERO OR ONE' SUBROUTINE
D $350B This subroutine sets the 'last value' to zero if the carry flag is reset and to one if it is set. When called from #R$2D4F however it creates the zero or one not on the stack but in mem-0.
  $350B Save the result pointer.
  $350C Clear #REGa without disturbing the carry.
  $350E Set the first byte to zero.
  $350F Point to the second byte.
  $3510 Set the second byte to zero.
  $3511 Point to the third byte.
  $3512 Rotate the carry into #REGa, making #REGa one if the carry was set, but zero if the carry was reset.
  $3513 Set the third byte to one or zero.
  $3514 Ensure that #REGa is zero again.
  $3515 Point to the fourth byte.
  $3516 Set the fourth byte to zero.
  $3517 Point to the fifth byte.
  $3518 Set the fifth byte to zero.
  $3519,1 Restore the result pointer.
@ $351B label=OR_CMD
c $351B THE 'OR' OPERATION
D $351B This subroutine performs the binary operation 'X OR Y' and returns X if Y is zero and the value 1 otherwise.
  $351B Point #REGhl at Y, the second number.
  $351C Test whether Y is zero.
  $351F Restore the pointers.
  $3520 Return if Y was zero; X is now the 'last value'.
  $3521 Set the carry flag and jump back to set the 'last value' to 1.
@ $3524 label=no_and_no
c $3524 THE 'NUMBER AND NUMBER' OPERATION
D $3524 This subroutine performs the binary operation 'X AND Y' and returns X if Y is non-zero and the value zero otherwise.
  $3524 Point #REGhl at Y, #REGde at X.
  $3525 Test whether Y is zero.
  $3528 Swap the pointers back.
  $3529 Return with X as the 'last value' if Y was non-zero.
  $352A Reset the carry flag and jump back to set the 'last value' to zero.
@ $352D label=str_no
c $352D THE 'STRING AND NUMBER' OPERATION
D $352D This subroutine performs the binary operation 'X$ AND Y' and returns X$ if Y is non-zero and a null string otherwise.
  $352D Point #REGhl at Y, #REGde at X$.
  $352E Test whether Y is zero.
  $3531 Swap the pointers back.
  $3532 Return with X$ as the 'last value' if Y was non-zero.
  $3533 Save the pointer to the number.
  $3534 Point to the fifth byte of the string parameters, i.e. length-high.
  $3535 Clear the #REGa register.
  $3536 Length-high is now set to zero.
  $3537 Point to length-low.
  $3538 Length-low is now set to zero.
  $3539 Restore the pointer.
  $353A Return with the string parameters being the 'last value'.
@ $353B label=no_l_eql
c $353B THE 'COMPARISON' OPERATIONS
D $353B This subroutine is used to perform the twelve possible comparison operations (offsets 09 to 0E and 11 to 16: 'no-l-eql', 'no-gr-eq', 'nos-neql', 'no-grtr', 'no-less', 'nos-eql', 'str-l-eql', 'str-gr-eq', 'strs-neql', 'str-grtr', 'str-less' and 'strs-eql'). The single operation offset is present in the #REGb register at the start of the subroutine.
  $353B The single offset goes to the #REGa register.
  $353C The range is now 01-06 and 09-0E.
  $353E This range is changed to 00-02, 04-06, 08-0A and 0C-0E.
@ $3543 label=EX_OR_NOT
  $3543 Then reduced to 00-07 with carry set for 'greater than or equal to' and 'less than'; the operations with carry set are then treated as their complementary operation once their values have been exchanged.
@ $354E label=NU_OR_STR
  $354E The numerical comparisons are now separated from the string comparisons by testing bit 2.
  $3552 The numerical operations now have the range 00-01 with carry set for 'equal' and 'not equal'.
  $3553 Save the offset.
  $3554 The numbers are subtracted for the final tests.
@ $3559 label=STRINGS
  $3559 The string comparisons now have the range 02-03 with carry set for 'equal' and 'not equal'.
  $355A Save the offset.
  $355B The lengths and starting addresses of the strings are fetched from the calculator stack.
  $3563,1 The length of the second string.
@ $3564 label=BYTE_COMP
  $3568,2 Jump unless the second string is null.
@ $356B label=SECND_LOW
  $356B,1 Here the second string is either null or less than the first.
  $356F The carry is complemented to give the correct test results.
@ $3572 label=BOTH_NULL
  $3572,3 Here the carry is used as it stands.
@ $3575 label=SEC_PLUS
  $3576 The first string is now null, the second not.
  $3578 Neither string is null, so their next bytes are compared.
  $357A Jump if the first byte is less.
  $357C Jump if the second byte is less.
  $357E,7 The bytes are equal; so the lengths are decremented and a jump is made to #R$3564 to compare the next bytes of the reduced strings.
@ $3585 label=FRST_LESS
  $3587 The carry is cleared here for the correct test results.
@ $3588 label=STR_TEST
  $3588 For the string tests, a zero is put on to the calculator stack.
B $358A,1 #R$341B(stk_zero)
B $358B,1 #R$369B
@ $358C label=END_TESTS
  $358C These three tests, called as needed, give the correct results for all twelve comparisons. The initial carry is set for 'not equal' and 'equal', and the final carry is set for 'greater than', 'less than' and 'equal'.
  $359B Finished.
@ $359C label=strs_add
c $359C THE 'STRING CONCATENATION' OPERATION
D $359C This subroutine performs the binary operation 'A$+B$'. The parameters for these strings are fetched and the total length found. Sufficient room to hold both the strings is made available in the work space and the strings are copied over. The result of this subroutine is therefore to produce a temporary variable A$+B$ that resides in the work space.
  $359C The parameters of the second string are fetched and saved.
  $35A1 The parameters of the first string are fetched.
  $35A4 The lengths are now in #REGhl and #REGbc.
  $35A6 The parameters of the first string are saved.
  $35A8 The total length of the two strings is calculated and passed to #REGbc.
  $35AB Sufficient room is made available.
  $35AC The parameters of the new string are passed to the calculator stack.
  $35AF The parameters of the first string are retrieved and the string copied to the work space as long as it is not a null string.
@ $35B7 label=OTHER_STR
  $35B7 Exactly the same procedure is followed for the second string thereby giving 'A$+B$'.
@ $35BF label=STK_PNTRS
c $35BF THE 'STK-PNTRS' SUBROUTINE
D $35BF This subroutine resets the #REGhl register pair to point to the first byte of the 'last value', i.e. STKEND-5, and the #REGde register pair to point one past the 'last value', i.e. STKEND.
  $35BF Fetch the current value of STKEND.
  $35C2 Set #REGde to -5, two's complement.
  $35C5 Stack the value for STKEND.
  $35C6 Calculate STKEND-5.
  $35C7,1 #REGde now holds STKEND and #REGhl holds STKEND-5.
@ $35C9 label=chrs
c $35C9 THE 'CHR$' FUNCTION
D $35C9 This subroutine handles the function CHR$ X and creates a single character string in the work space.
  $35C9 The 'last value' is compressed into the #REGa register.
  $35CC Give the error report if X is greater than 255 decimal, or X is a negative number.
  $35D0 Save the compressed value of X.
@ $35D1 keep
  $35D1 Make one space available in the work space.
  $35D5 Fetch the value.
  $35D6 Copy the value to the work space.
  $35D7 Pass the parameters of the new string to the calculator stack.
  $35DA Reset the pointers.
  $35DB Finished.
N $35DC Report B - Integer out of range.
@ $35DC label=REPORT_B_4
M $35DC,2 Call the error handling routine.
B $35DD,1
@ $35DE label=val
c $35DE THE 'VAL' AND 'VAL$' FUNCTION
D $35DE This subroutine handles the functions VAL X$ and VAL$ X$. When handling VAL X$, it returns a 'last value' that is the result of evaluating the string (without its bounding quotes) as a numerical expression. when handling VAL$ X$, it evaluates X$ (without its bounding quotes) as a string expression, and returns the parameters of that string expression as a 'last value' on the calculator stack.
  $35DE The current value of CH-ADD is preserved on the machine stack.
  $35E2 The 'offset' for 'val' or 'val$' must be in the #REGb register; it is now copied to #REGa.
  $35E3 Produce +00 and carry set for 'val', +FB and carry reset for 'val$'.
  $35E5 Produce +FF (bit 6 therefore set) for 'val', but +00 (bit 6 reset) for 'val$'.
  $35E6 Save this 'flag' on the machine stack.
  $35E7 The parameters of the string are fetched; the starting address is saved; one byte is added to the length and room made available for the string (+1) in the work space.
  $35ED The starting address of the string goes to #REGhl as a source address.
  $35EE The pointer to the first new space goes to CH-ADD and to the machine stack.
  $35F3 The string is copied to the work space, together with an extra byte.
  $35F5 Switch the pointers.
  $35F6 The extra byte is replaced by a 'carriage return' character.
  $35F9 The syntax flag is reset and the string is scanned for correct syntax.
  $3600 The character after the string is fetched.
  $3601 A check is made that the end of the expression has been reached.
  $3603 If not, the error is reported.
  $3605 The starting address of the string is fetched.
  $3606 The 'flag' for 'val/val$' is fetched and bit 6 is compared with bit 6 of the result of the syntax scan.
@ $360C label=V_RPORT_C
  $360C Report the error if they do not match.
  $360F Start address to CH-ADD again.
  $3612 The flag is set for line execution.
  $3616 The string is treated as a 'next expression' and a 'last value' produced.
  $3619 The original value of CH-ADD is restored.
  $361D The subroutine exits via #R$35BF which resets the pointers.
@ $361F keep
@ $361F label=str
c $361F THE 'STR$' FUNCTION
D $361F This subroutine handles the function STR$ X and returns a 'last value' which is a set of parameters that define a string containing what would appear on the screen if X were displayed by a PRINT command.
  $361F One space is made in the work space and its address is copied to K-CUR, the address of the cursor.
  $3626 This address is saved on the stack too.
  $3627 The current channel address is saved on the machine stack.
  $362B Channel 'R' is opened, allowing the string to be 'printed' out into the work space.
  $3630 The 'last value', X, is now printed out in the work space and the work space is expanded with each character.
  $3633 Restore CURCHL to #REGhl and restore the flags that are appropriate to it.
  $3637 Restore the start address of the string.
  $3638 Now the cursor address is one past the end of the string and hence the difference is the length.
  $363E Transfer the length to #REGbc.
  $3640 Pass the parameters of the new string to the calculator stack.
  $3643 Reset the pointers.
  $3644 Finished.
E $361F Note: see #R$2DE3 for an explanation of the 'PRINT "A"+STR$ 0.1' error.
@ $3645 label=read_in
c $3645 THE 'READ-IN' SUBROUTINE
D $3645 This subroutine is called via the calculator offset (+5A) through the first line of #R$2634. It appears to provide for the reading in of data through different streams from those available on the standard Spectrum. Like #R$2634 the subroutine returns a string.
  $3645 The numerical parameter is compressed into the #REGa register.
  $3648 Is it smaller than 16 decimal?
  $364A If not, report the error.
  $364D The current channel address is saved on the machine stack.
  $3651 The channel specified by the parameter is opened.
  $3654 The signal is now accepted, like a 'key-value'.
@ $3657 keep
  $3657 The default length of the resulting string is zero.
  $365A Jump if there was no signal.
  $365C Set the length to 1 now.
  $365D Make a space in the work space.
  $365E Put the string into it.
@ $365F label=R_I_STORE
  $365F Pass the parameters of the string to the calculator stack.
  $3662 Restore CURCHL and the appropriate flags.
  $3666 Exit, setting the pointers.
@ $3669 label=code
c $3669 THE 'CODE' FUNCTION
D $3669 This subroutine handles the function CODE A$ and returns the Spectrum code of the first character in A$, or zero if A$ is null.
  $3669 The parameters of the string are fetched.
  $366C The length is tested and the #REGa register holding zero is carried forward if A$ is a null string.
  $3670 The code of the first character is put into #REGa otherwise.
@ $3671 label=STK_CODE
  $3671 The subroutine exits via #R$2D28 which gives the correct 'last value'.
@ $3674 label=len
c $3674 THE 'LEN' FUNCTION
D $3674 This subroutine handles the function LEN A$ and returns a 'last value' that is equal to the length of the string.
  $3674 The parameters of the string are fetched.
  $3677 The subroutine exits via #R$2D2B which gives the correct 'last value'.
@ $367A label=dec_jr_nz
c $367A THE 'DECREASE THE COUNTER' SUBROUTINE
D $367A This subroutine is only called by the #R$3449(series generator) and in effect is a 'DJNZ' operation but the counter is the system variable, BREG, rather than the #REGb register.
  $367A Go to the alternative register set and save the next literal pointer on the machine stack.
  $367C Make #REGhl point to BREG.
  $367F Decrease BREG.
  $3680 Restore the next literal pointer.
  $3681 The jump is made on non-zero.
  $3683 The next literal is passed over.
  $3684 Return to the main register set.
  $3685 Finished.
@ $3686 label=JUMP
c $3686 THE 'JUMP' SUBROUTINE
D $3686 This subroutine executes an unconditional jump when called by the literal '33'.
  $3686 Go to the next alternate register set.
@ $3687 label=JUMP_2
  $3687 The next literal (jump length) is put in the #REGe' register.
  $3688 The number +00 or +FF is formed in #REGa according as #REGe' is positive or negative, and is then copied to #REGd'.
  $368C #REGhl' now holds the next literal pointer.
  $368E Finished.
@ $368F label=jump_true
c $368F THE 'JUMP ON TRUE' SUBROUTINE
D $368F This subroutine executes a conditional jump if the 'last value' on the calculator stack, or more precisely the number addressed currently by the #REGde register pair, is true.
  $368F Point to the third byte, which is zero or one.
  $3691 Collect this byte in the #REGa register.
  $3692 Point to the first byte once again.
  $3694 Test the third byte: is it zero?
  $3695 Make the jump if the byte is non-zero, i.e. if the number is not-false.
  $3697 Go to the alternate register set.
  $3698 Pass over the jump length.
  $3699 Back to the main set of registers.
  $369A Finished.
@ $369B label=end_calc
c $369B THE 'END-CALC' SUBROUTINE
D $369B This subroutine ends a RST 28 operation.
  $369B The return address to the calculator (#R$3365) is discarded.
  $369C Instead, the address in #REGhl' is put on the machine stack and an indirect jump is made to it. #REGhl' will now hold any earlier address in the calculator chain of addresses.
  $369F Finished.
@ $36A0 label=n_mod_m
c $36A0 THE 'MODULUS' SUBROUTINE
D $36A0 This subroutine calculates N (mod M), where M is a positive integer held at the top of the calculator stack (the 'last value'), and N is the integer held on the stack beneath M.
D $36A0 The subroutine returns the integer quotient INT (N/M) at the top of the calculator stack (the 'last value'), and the remainder N-INT (N/M) in the second place on the stack.
D $36A0 This subroutine is called during the calculation of a random number to reduce N mod 65537 decimal.
  $36A0 N, M
B $36A1,1 #R$342D(st_mem_0): N, M (mem-0 holds M)
B $36A2,1 #R$33A1: N
B $36A3,1 #R$33C0: N, N
B $36A4,1 #R$340F(get_mem_0): N, N, M
B $36A5,1 #R$31AF: N, N/M
B $36A6,1 #R$36AF: N, INT (N/M)
B $36A7,1 #R$340F(get_mem_0): N, INT (N/M), M
B $36A8,1 #R$343C: N, M, INT (N/M)
B $36A9,1 #R$342D(st_mem_0): N, M, INT (N/M) (mem-0 holds INT (N/M))
B $36AA,1 #R$30CA: N, M*INT (N/M)
B $36AB,1 #R$300F: N-M*INT (N/M)
B $36AC,1 #R$340F(get_mem_0): N-M*INT (N/M), INT (N/M)
B $36AD,1 #R$369B
  $36AE Finished.
@ $36AF label=int
c $36AF THE 'INT' FUNCTION
D $36AF This subroutine handles the function INT X and returns a 'last value' that is the 'integer part' of the value supplied. Thus INT 2.4 gives 2 but as the subroutine always rounds the result down INT -2.4 gives -3.
D $36AF The subroutine uses #R$3214 to produce I(X) such that I(2.4)=2 and I(-2.4)=-2. Thus, INT X is given by I(X) when X>=0, and by I(X)-1 for negative values of X that are not already integers, when the result is, of course, I(X).
  $36AF X
B $36B0,1 #R$33C0: X, X
B $36B1,1 #R$3506: X, (1/0)
B $36B2,2,1 #R$368F to #R$36B7: X
N $36B4 For values of X that have been shown to be greater than or equal to zero there is no jump and I(X) is readily found.
B $36B4,1 #R$3214: I(X)
B $36B5,1 #R$369B
  $36B6 Finished.
N $36B7 When X is a negative integer I(X) is returned, otherwise I(X)-1 is returned.
@ $36B7 label=X_NEG
B $36B7,1 #R$33C0: X, X
B $36B8,1 #R$3214: X, I(X)
B $36B9,1 #R$342D(st_mem_0): X, I(X) (mem-0 holds I(X))
B $36BA,1 #R$300F: X-I(X)
B $36BB,1 #R$340F(get_mem_0): X-I(X), I(X)
B $36BC,1 #R$343C: I(X), X-I(X)
B $36BD,1 #R$3501: I(X), (1/0)
B $36BE,2,1 #R$368F to #R$36C2: I(X)
N $36C0 The jump is made for values of X that are negative integers, otherwise there is no jump and I(X)-1 is calculated.
B $36C0,1 #R$341B(stk_one): I(X), 1
B $36C1,1 #R$300F: I(X)-1
N $36C2 In either case the subroutine finishes with:
@ $36C2 label=EXIT
B $36C2,1 #R$369B: I(X) or I(X)-1
@ $36C4 label=EXP
c $36C4 THE 'EXPONENTIAL' FUNCTION
D $36C4 This subroutine handles the function EXP X and is the first of four routines that use the #R$3449(series generator) to produce Chebyshev polynomials.
D $36C4 The approximation to EXP X is found as follows:
D $36C4 #LIST { i. X is divided by LN 2 to give Y, so that 2**Y is now the required result. } { ii. The value N is found, such that N=INT Y. } { iii. The value W=Y-N is found; 0<=W<=1, as required for the series to converge. } { iv. The argument Z=2*W-1 is formed. } { v. The #R$3449(series generator) is used to return 2**W. } { vi. Finally N is added to the exponent, giving 2**(N+W), which is 2**Y and therefore the required answer. } LIST#
  $36C4 X
N $36C5 Perform step i.
B $36C5,1 #R$3297: X (in full floating-point form)
B $36C6,6,1,5 #R$33C6: X, 1/LN 2
B $36CC,1 #R$30CA: X/LN 2=Y
N $36CD Perform step ii.
B $36CD,1 #R$33C0
B $36CD,1 #R$33C0: Y, Y
B $36CE,1 #R$36AF: Y, INT Y=N
B $36CF,1 #R$342D(st_mem_3): Y, N (mem-3 holds N)
N $36D0 Perform step iii.
B $36D0,1 #R$300F
B $36D0,1 #R$300F: Y-N=W
N $36D1 Perform step iv.
B $36D1,1 #R$33C0
B $36D1,1 #R$33C0: W, W
B $36D2,1 #R$3014: 2*W
B $36D3,1 #R$341B(stk_one): 2*W, 1
B $36D4,1 #R$300F: 2*W-1=Z
N $36D5 Perform step v, passing to the #R$3449(series generator) the parameter '8' and the eight constants required.
B $36D5,1 #R$3449(series_08): Z
B $36D6,33,2,3,4,4,5
N $36F7 At the end of the last loop the 'last value' is 2**W.
N $36F7 Perform step vi.
B $36F7,1 #R$340F(get_mem_3): 2**W, N
B $36F8,1 #R$369B
  $36F9 The absolute value of N mod 256 decimal is put into the #REGa register.
  $36FC Jump forward if N was negative.
  $36FE Error if ABS N>255 dec.
  $3700 Now add ABS N to the exponent.
  $3701 Jump unless e>255 dec.
N $3703 Report 6 - Number too big.
@ $3703 label=REPORT_6_2
M $3703,2 Call the error handling routine.
B $3704,1
@ $3705 label=N_NEGTV
  $3705 The result is to be zero if N<-255 decimal.
  $3707 Subtract ABS N from the exponent as N was negative.
  $3708 Zero result if e less than zero.
  $370A Minus e is changed to e.
@ $370C label=RESULT_OK
  $370C The exponent, e, is entered.
  $370D Finished: 'last value' is EXP X.
@ $370E label=RSLT_ZERO
  $370E Use the calculator to make the 'last value' zero.
B $370F,1 #R$33A1 (the stack is now empty)
B $3710,1 #R$341B(stk_zero): 0
B $3711,1 #R$369B
  $3712 Finished, with EXP X=0.
@ $3713 label=ln
c $3713 THE 'NATURAL LOGARITHM' FUNCTION
D $3713 This subroutine handles the function LN X and is the second of the four routines that use the #R$3449(series generator) to produce Chebyshev polynomials.
D $3713 The approximation to LN X is found as follows:
D $3713 #LIST { i. X is tested and report A is given if X is not positive. } { ii. X is then split into its true exponent, e', and its mantissa X'=X/(2**e'), where 0.5<=X'<1. } { iii. The required value Y1 or Y2 is formed: if X'>0.8 then Y1=e'*LN 2, otherwise Y2=(e'-1)*LN 2. } { iv. If X'>0.8 then the quantity X'-1 is stacked; otherwise 2*X'-1 is stacked. } { v. Now the argument Z is formed, being 2.5*X'-3 if X'>0.8, otherwise 5*X'-3. In each case, -1<=Z<=1, as required for the series to converge. } { vi. The #R$3449(series generator) is used to produce the required function. } { vii. Finally a simple multiplication and addition leads to LN X being returned as the 'last value'. } LIST#
  $3713 X
N $3714 Perform step i.
B $3714,1 #R$3297: X (in full floating-point form)
B $3715,1 #R$33C0: X, X
B $3716,1 #R$34F9: X, (1/0)
B $3717,1 #R$368F to #R$371C: X
B $3718,1 #R$30CA: X
B $3719,1 #R$369B: X
@ $371A label=REPORT_A_2
N $371A Report A - Invalid argument.
M $371A,2 Call the error handling routine.
B $371B,1
N $371C Perform step ii.
@ $371C label=VALID
B $371C,1 #R$341B(stk_zero): X, 0 (the deleted 1 is overwritten with zero)
B $371D,1 #R$33A1: X
B $371E,1 #R$369B: X
  $371F The exponent, e, goes into #REGa.
  $3720 X is reduced to X'.
  $3722 The stack holds: X', e.
  $3725 X', e
B $3726,3,1,2 #R$33C6: X', e, 128 (decimal)
B $3729,1 #R$300F: X', e'
N $372A Perform step iii.
B $372A,1 #R$343C: e', X'
B $372B,1 #R$33C0: e', X', X'
B $372C,6,1,5 #R$33C6: e', X', X', 0.8 (decimal)
B $3732,1 #R$300F: e', X', X'-0.8
B $3733,1 #R$34F9: e', X', (1/0)
B $3734,2,1 #R$368F to #R$373D: e', X'
B $3736,1 #R$343C: X', e'
B $3737,1 #R$341B(stk_one): X', e', 1
B $3738,1 #R$300F: X', e'-1
B $3739,1 #R$343C: e'-1, X'
B $373A,1 #R$369B
  $373B Double X' to give 2*X'.
  $373C e'-1, 2*X'
@ $373D label=GRE_8
B $373D,1 #R$343C: X', e' (X'>0.8) or 2*X', e'-1 (X'<=0.8)
B $373E,6,1,5 #R$33C6: X', e', LN 2 or 2*X', e'-1, LN 2
B $3744,1 #R$30CA: X', e'*LN 2=Y1 or 2*X', (e'-1)*LN 2=Y2
N $3745 Perform step iv.
B $3745,1 #R$343C: Y1, X' (X'>0.8) or Y2, 2*X' (X'<=0.8)
B $3746,1 #R$341B(stk_half): Y1, X', .5 or Y2, 2*X', .5
B $3747,1 #R$300F: Y1, X'-.5 or Y2, 2*X'-.5
B $3748,1 #R$341B(stk_half): Y1, X'-.5, .5 or Y2, 2*X'-.5, .5
B $3749,1 #R$300F: Y1, X'-1 or Y2, 2*X'-1
N $374A Perform step v.
B $374A,1 #R$33C0: Y, X'-1, X'-1 or Y2, 2*X'-1, 2*X'-1
B $374B,3,1,2 #R$33C6: Y1, X'-1, X'-1, 2.5 (decimal) or Y2, 2*X'-1, 2*X'-1, 2.5
B $374E,1 #R$30CA: Y1, X'-1, 2.5*X'-2.5 or Y2, 2*X'-1, 5*X'-2.5
B $374F,1 #R$341B(stk_half): Y1, X'-1, 2.5*X'-2.5, .5 or Y2, 2*X'-1, 5*X'-2.5, .5
B $3750,1 #R$300F: Y1, X'-1, 2.5*X'-3=Z or Y2, 2*X'-1, 5*X'-3=Z
N $3751 Perform step vi, passing to the #R$3449(series generator) the parameter '12' decimal, and the twelve constants required.
B $3751,1 #R$3449(series_0C): Y1, X'-1, Z or Y2, 2*X'-1, Z
B $3752,45,2,2,3,3,3,4,4,4,5,5,5,5
N $377F At the end of the last loop the 'last value' is:
N $377F #LIST { LN X'/(X'-1) if X'>0.8 } { LN (2*X')/(2*X'-1) if X'<=0.8 } LIST#
N $377F Perform step vii.
B $377F,1 #R$30CA: Y1=LN (2**e'), LN X' or Y2=LN (2**(e'-1)), LN (2*X')
B $3780,1 #R$3014: LN (2**e')*X')=LN X or LN (2**(e'-1)*2*X')=LN X
B $3781,1 #R$369B: LN X
  $3782 Finished: 'last value' is LN X.
@ $3783 label=get_argt
c $3783 THE 'REDUCE ARGUMENT' SUBROUTINE
D $3783 This subroutine transforms the argument X of SIN X or COS X into a value V.
D $3783 The subroutine first finds the value Y=X/2#pi-INT(X/2#pi+0.5), where 0.5<=Y<0.5.
D $3783 The subroutine returns with:
D $3783 #LIST { V=4*Y if -1<=4*Y<=1 (case i) } { or V=2-4*Y if 1<4*Y<2 (case ii) } { or V=-4*Y-2 if -2<=4*Y<-1 (case iii) } LIST#
D $3783 In each case, -1<=V<=1 and SIN (#piV/2)=SIN X.
  $3783 X
B $3784,1 #R$3297: X (in full floating-point form)
B $3785,6,1,5 #R$33C6: X, 1/2#pi
B $378B,1 #R$30CA: X/2#pi
B $378C,1 #R$33C0: X/2#pi, X/2#pi
B $378D,1 #R$341B(stk_half): X/2#pi, X/2#pi, 0.5
B $378E,1 #R$3014: X/2#pi, X/2#pi+0.5
B $378F,1 #R$36AF: X/2#pi, INT (X/2#pi+0.5)
B $3790,1 #R$300F: X/2#pi-INT (X/2#pi+0.5)=Y
N $3791 Note: adding 0.5 and taking INT rounds the result to the nearest integer.
B $3791,1 #R$33C0: Y, Y
B $3792,1 #R$3014: 2*Y
B $3793,1 #R$33C0: 2*Y, 2*Y
B $3794,1 #R$3014: 4*Y
B $3795,1 #R$33C0: 4*Y, 4*Y
B $3796,1 #R$346A: 4*Y, ABS (4*Y)
B $3797,1 #R$341B(stk_one): 4*Y, ABS (4*Y), 1
B $3798,1 #R$300F: 4*Y, ABS (4*Y)-1=Z
B $3799,1 #R$33C0: 4*Y, Z, Z
B $379A,1 #R$34F9: 4*Y, Z, (1/0)
B $379B,1 #R$342D(st_mem_0): (mem-0 holds the result of the test)
B $379C,2,1 #R$368F to #R$37A1: 4*Y, Z
B $379E,1 #R$33A1: 4*Y
B $379F,1 #R$369B: 4*Y=V (case i)
  $37A0 Finished.
N $37A1 If the jump was made then continue.
@ $37A1 label=ZPLUS
B $37A1,1 #R$341B(stk_one): 4*Y, Z, 1
B $37A2,1 #R$300F: 4*Y, Z-1
B $37A3,1 #R$343C: Z-1, 4*Y
B $37A4,1 #R$3506: Z-1, (1/0)
B $37A5,2,1 #R$368F to #R$37A8: Z-1
B $37A7,1 #R$346E: 1-Z
B $37A8,1 #R$369B: 1-Z=V (case ii) or Z-1=V (case iii)
@ $37A8 label=YNEG
  $37A9 Finished.
@ $37AA label=cos
c $37AA THE 'COSINE' FUNCTION
D $37AA This subroutine handles the function COS X and returns a 'last value' 'that is an approximation to COS X.
D $37AA The subroutine uses the expression COS X=SIN (#piW/2), where -1<=W<=1.
D $37AA In deriving W for X the subroutine uses the test result obtained in the previous subroutine and stored for this purpose in mem-0. It then jumps to the #R$37B5 subroutine, entering at #R$37B7, to produce a 'last value' of COS X.
  $37AA X
B $37AB,1 #R$3783: V
B $37AC,1 #R$346A: ABS V
B $37AD,1 #R$341B(stk_one): ABS V, 1
B $37AE,1 #R$300F: ABS V-1
B $37AF,1 #R$340F(get_mem_0): ABS V-1, (1/0)
B $37B0,2,1 #R$368F to #R$37B7: ABS V-1=W
N $37B2 If the jump was not made then continue.
B $37B2,1 #R$346E: 1-ABS V
B $37B3,2,1 #R$3686 to #R$37B7: 1-ABS V=W
@ $37B5 label=sin
c $37B5 THE 'SINE' FUNCTION
D $37B5 This subroutine handles the function SIN X and is the third of the four routines that use the #R$3449(series generator) to produce Chebyshev polynomials.
D $37B5 The approximation to SIN X is found as follows:
D $37B5 #LIST { i. The argument X is reduced to W, such that SIN (#pi*W/2)=SIN X. Note that -1<=W<=1, as required for the series to converge. } { ii. The argument Z=2*W*W-1 is formed. } { iii. The #R$3449(series generator) is used to return (SIN (#pi*W/2))/W. } { iv. Finally a simple multiplication by W gives SIN X. } LIST#
  $37B5 X
N $37B6 Perform step i.
B $37B6,1 #R$3783: W
N $37B7 Perform step ii. The subroutine from now on is common to both the SINE and COSINE functions.
@ $37B7 label=C_ENT
B $37B7,1 #R$33C0: W, W
B $37B8,1 #R$33C0: W, W, W
B $37B9,1 #R$30CA: W, W*W
B $37BA,1 #R$33C0: W, W*W, W*W
B $37BB,1 #R$3014: W, 2*W*W
B $37BC,1 #R$341B(stk_one): W, 2*W*W, 1
B $37BD,1 #R$300F: W, 2*W*W-1=Z
N $37BE Perform step iii, passing to the #R$3449(series generator) the parameter '6' and the six constants required.
B $37BE,1 #R$3449(series_06): W, Z
B $37BF,24,2,3,4,5
N $37D7 At the end of the last loop the 'last value' is (SIN (#pi*W/2))/W.
N $37D7 Perform step iv.
B $37D7,1 #R$30CA: SIN (#pi*W/2)=SIN X (or COS X)
B $37D8,1 #R$369B
  $37D9 Finished: 'last value'=SIN X (or COS X).
@ $37DA label=tan
c $37DA THE 'TAN' FUNCTION
D $37DA This subroutine handles the function TAN X. It simply returns SIN X/COS X, with arithmetic overflow if COS X=0.
  $37DA X
B $37DB,1 #R$33C0: X, X
B $37DC,1 #R$37B5: X, SIN X
B $37DD,1 #R$343C: SIN X, X
B $37DE,1 #R$37AA: SIN X, COS X
B $37DF,1 #R$31AF: SIN X/COS X=TAN X (report arithmetic overflow if needed)
B $37E0,1 #R$369B: TAN X
  $37E1 Finished: 'last value'=TAN X.
@ $37E2 label=atn
c $37E2 THE 'ARCTAN' FUNCTION
D $37E2 This subroutine handles the function ATN X and is the last of the four routines that use the #R$3449(series generator) to produce Chebyshev polynomials. It returns a real number between -#pi/2 and #pi/2, which is equal to the value in radians of the angle whose tan is X.
D $37E2 The approximation to ATN X is found as follows:
D $37E2 i. The values W and Y are found for three cases of X, such that:
D $37E2 #LIST { if -1<X<1 then W=0, Y=X (case i) } { if 1<=X then W=#pi/2, Y=-1/X (case ii) } { if X<=-1 then W=-#pi/2, Y=-1/X (case iii) } LIST#
D $37E2 In each case, -1<=Y<=1, as required for the series to converge.
D $37E2 ii. The argument Z is formed, such that:
D $37E2 #LIST { if -1<X<1 then Z=2*Y*Y-1=2*X*X-1 (case i) } { otherwise Z=2*Y*Y-1=2/(X*X)-1 (cases ii and iii) } LIST#
D $37E2 iii. The #R$3449(series generator) is used to produce the required function.
D $37E2 iv. Finally a simple multiplication and addition give ATN X.
D $37E2 Perform step i.
  $37E2 Use the full floating-point form of X.
  $37E5 Fetch the exponent of X.
  $37E6 Jump forward for case i: Y=X.
  $37EA X
B $37EB,1 #R$341B(stk_one): X, 1
B $37EC,1 #R$346E: X, -1
B $37ED,1 #R$343C: -1, X
B $37EE,1 #R$31AF: -1/X
B $37EF,1 #R$33C0: -1/X, -1/X
B $37F0,1 #R$3506: -1/X, (1/0)
B $37F1,1 #R$341B(stk_pi_2): -1/X, (1/0), #pi/2
B $37F2,1 #R$343C: -1/X, #pi/2, (1/0)
B $37F3,2,1 #R$368F to #R$37FA for case ii: -1/X, #pi/2
B $37F5,1 #R$346E: -1/X, -#pi/2
B $37F6,2,1 #R$3686 to #R$37FA for case iii: -1/X, -#pi/2
@ $37F8 label=SMALL
B $37F9,1 #R$341B(stk_zero): Y, 0; continue for case i: W=0
N $37FA Perform step ii.
@ $37FA label=CASES
B $37FA,1 #R$343C: W, Y
B $37FB,1 #R$33C0: W, Y, Y
B $37FC,1 #R$33C0: W, Y, Y, Y
B $37FD,1 #R$30CA: W, Y, Y*Y
B $37FE,1 #R$33C0: W, Y, Y*Y, Y*Y
B $37FF,1 #R$3014: W, Y, 2*Y*Y
B $3800,1 #R$341B(stk_one): W, Y, 2*Y*Y, 1
B $3801,1 #R$300F: W, Y, 2*Y*Y-1=Z
N $3802 Perform step iii, passing to the #R$3449(series generator) the parameter '12' decimal, and the twelve constants required.
B $3802,1 #R$3449(series_0C): W, Y, Z
B $3803,44,2,2,3,3,3,4,4,3,5
N $382F At the end of the last loop the 'last value' is:
N $382F #LIST { ATN X/X (case i) } { ATN (-1/X)/(-1/X) (cases ii and iii) } LIST#
N $382F Perform step iv.
B $382F,1 #R$30CA: W, ATN X (case i) or W, ATN (-1/X) (cases ii and iii)
B $3830,1 #R$3014: ATN X (all cases now)
B $3831,1 #R$369B
  $3832 Finished: 'last value'=ATN X.
@ $3833 label=asn
c $3833 THE 'ARCSIN' FUNCTION
D $3833 This subroutine handles the function ASN X and returns a real real number from -#pi/2 to #pi/2 inclusive which is equal to the value in radians of the angle whose sine is X. Thereby if Y=ASN X then X=SIN Y.
D $3833 This subroutine uses the trigonometric identity TAN (Y/2)=SIN Y/1(1+COS Y) to obtain TAN (Y/2) and hence (using ATN) Y/2 and finally Y.
  $3833 X
B $3834,1 #R$33C0: X, X
B $3835,1 #R$33C0: X, X, X
B $3836,1 #R$30CA: X, X*X
B $3837,1 #R$341B(stk_one): X, X*X, 1
B $3838,1 #R$300F: X, X*X-1
B $3839,1 #R$346E: X, 1-X*X
B $383A,1 #R$384A: X, SQR (1-X*X)
B $383B,1 #R$341B(stk_one): X, SQR (1-X*X), 1
B $383C,1 #R$3014: X, 1+SQR (1-X*X)
B $383D,1 #R$31AF: X/(1+SQR (1-X*X))=TAN (Y/2)
B $383E,1 #R$37E2: Y/2
B $383F,1 #R$33C0: Y/2, Y/2
B $3840,1 #R$3014: Y=ASN X
B $3841,1 #R$369B
  $3842 Finished: 'last value'=ASN X.
@ $3843 label=acs
c $3843 THE 'ARCCOS' FUNCTION
D $3843 This subroutine handles the function ACS X and returns a real number from 0 to #pi inclusive which is equal to the value in radians of the angle whose cosine is X.
D $3843 This subroutine uses the relation ACS X=#pi/2-ASN X.
  $3843 X
B $3844,1 #R$3833: ASN X
B $3845,1 #R$341B(stk_pi_2): ASN X, #pi/2
B $3846,1 #R$300F: ASN X-#pi/2
B $3847,1 #R$346E: #pi/2-ASN X=ACS X
B $3848,1 #R$369B
  $3849 Finished: 'last value'=ACS X.
@ $384A label=sqr
c $384A THE 'SQUARE ROOT' FUNCTION
D $384A  This subroutine handles the function SQR X and returns the positive square root of the real number X if X is positive, and zero if X is zero. A negative value of X gives rise to report A - invalid argument (via #R$3851).
D $384A This subroutine treats the square root operation as being X**0.5 and therefore stacks the value 0.5 and proceeds directly into #R$3851.
  $384A X
B $384B,1 #R$33C0: X, X
B $384C,1 #R$3501: X, (1/0)
B $384D,2,1 #R$368F to #R$386C: X
N $384F The jump is made if X=0; otherwise continue with:
B $384F,1 #R$341B(stk_half): X, 0.5
B $3850,1 #R$369B
E $384A Continue into #R$3851 to find the result of X**0.5.
@ $3851 label=to_power
c $3851 THE 'EXPONENTIATION' OPERATION
D $3851 This subroutine performs the binary operation of raising the first number, X, to the power of the second number, Y.
D $3851 The subroutine treats the result X**Y as being equivalent to EXP (Y*LN X). It returns this value unless X is zero, in which case it returns 1 if Y is also zero (0**0=1), returns zero if Y is positive, and reports arithmetic overflow if Y is negative.
  $3851 X, Y
B $3852,1 #R$343C: Y, X
B $3853,1 #R$33C0: Y, X, X
B $3854,1 #R$3501: Y, X, (1/0)
B $3855,2,1 #R$368F to #R$385D: Y, X
N $3857 The jump is made if X=0, otherwise EXP (Y*LN X) is formed.
B $3857,1 #R$3713: Y, LN X
N $3858 Giving report A if X is negative.
B $3858,1 #R$30CA: Y*LN X
B $3859,1 #R$369B
  $385A Exit via #R$36C4 to form EXP (Y*LN X).
N $385D The value of X is zero so consider the three possible cases involved.
@ $385D label=XIS0
B $385D,1 #R$33A1: Y
B $385E,1 #R$33C0: Y, Y
B $385F,1 #R$3501: Y, (1/0)
B $3860,2,1 #R$368F to #R$386A: Y
N $3862 The jump is made if X=0 and Y=0, otherwise proceed.
B $3862,1 #R$341B(stk_zero): Y, 0
B $3863,1 #R$343C: 0, Y
B $3864,1 #R$34F9: 0, (1/0)
B $3865,2,1 #R$368F to #R$386C: 0
N $3867 The jump is made if X=0 and Y is positive, otherwise proceed.
B $3867,1 #R$341B(stk_one): 0, 1
B $3868,1 #R$343C: 1, 0
B $3869,1 #R$31AF: Exit via #R$31AF as dividing by zero gives 'arithmetic overflow'.
N $386A The result is to be 1 for the operation.
@ $386A label=ONE
B $386A,1 #R$33A1: -
B $386B,1 #R$341B(stk_one): 1
N $386C Now return with the 'last value' on the stack being 0**Y.
@ $386C label=LAST
B $386C,1 #R$369B: (1/0)
  $386D Finished: 'last value' is 0 or 1.
s $386E
  $386E,1170,1170:$FF These locations are 'spare'. They all hold +FF.
@ $3D00 label=CHARSET
b $3D00 Character set
D $3D00 These locations hold the 'character set'. There are 8-byte representations for all the characters with codes +20 (space) to +7F (#CHR169).
  $3D00,8,b1 #UDG$3D00
  $3D08,8,b1 #UDG$3D08
  $3D10,8,b1 #UDG$3D10
  $3D18,8,b1 #UDG$3D18
  $3D20,8,b1 #UDG$3D20
  $3D28,8,b1 #UDG$3D28
  $3D30,8,b1 #UDG$3D30
  $3D38,8,b1 #UDG$3D38
  $3D40,8,b1 #UDG$3D40
  $3D48,8,b1 #UDG$3D48
  $3D50,8,b1 #UDG$3D50
  $3D58,8,b1 #UDG$3D58
  $3D60,8,b1 #UDG$3D60
  $3D68,8,b1 #UDG$3D68
  $3D70,8,b1 #UDG$3D70
  $3D78,8,b1 #UDG$3D78
  $3D80,8,b1 #UDG$3D80
  $3D88,8,b1 #UDG$3D88
  $3D90,8,b1 #UDG$3D90
  $3D98,8,b1 #UDG$3D98
  $3DA0,8,b1 #UDG$3DA0
  $3DA8,8,b1 #UDG$3DA8
  $3DB0,8,b1 #UDG$3DB0
  $3DB8,8,b1 #UDG$3DB8
  $3DC0,8,b1 #UDG$3DC0
  $3DC8,8,b1 #UDG$3DC8
  $3DD0,8,b1 #UDG$3DD0
  $3DD8,8,b1 #UDG$3DD8
  $3DE0,8,b1 #UDG$3DE0
  $3DE8,8,b1 #UDG$3DE8
  $3DF0,8,b1 #UDG$3DF0
  $3DF8,8,b1 #UDG$3DF8
  $3E00,8,b1 #UDG$3E00
  $3E08,8,b1 #UDG$3E08
  $3E10,8,b1 #UDG$3E10
  $3E18,8,b1 #UDG$3E18
  $3E20,8,b1 #UDG$3E20
  $3E28,8,b1 #UDG$3E28
  $3E30,8,b1 #UDG$3E30
  $3E38,8,b1 #UDG$3E38
  $3E40,8,b1 #UDG$3E40
  $3E48,8,b1 #UDG$3E48
  $3E50,8,b1 #UDG$3E50
  $3E58,8,b1 #UDG$3E58
  $3E60,8,b1 #UDG$3E60
  $3E68,8,b1 #UDG$3E68
  $3E70,8,b1 #UDG$3E70
  $3E78,8,b1 #UDG$3E78
  $3E80,8,b1 #UDG$3E80
  $3E88,8,b1 #UDG$3E88
  $3E90,8,b1 #UDG$3E90
  $3E98,8,b1 #UDG$3E98
  $3EA0,8,b1 #UDG$3EA0
  $3EA8,8,b1 #UDG$3EA8
  $3EB0,8,b1 #UDG$3EB0
  $3EB8,8,b1 #UDG$3EB8
  $3EC0,8,b1 #UDG$3EC0
  $3EC8,8,b1 #UDG$3EC8
  $3ED0,8,b1 #UDG$3ED0
  $3ED8,8,b1 #UDG$3ED8
  $3EE0,8,b1 #UDG$3EE0
  $3EE8,8,b1 #UDG$3EE8
  $3EF0,8,b1 #UDG$3EF0
  $3EF8,8,b1 #UDG$3EF8
  $3F00,8,b1 #UDG$3F00
  $3F08,8,b1 #UDG$3F08
  $3F10,8,b1 #UDG$3F10
  $3F18,8,b1 #UDG$3F18
  $3F20,8,b1 #UDG$3F20
  $3F28,8,b1 #UDG$3F28
  $3F30,8,b1 #UDG$3F30
  $3F38,8,b1 #UDG$3F38
  $3F40,8,b1 #UDG$3F40
  $3F48,8,b1 #UDG$3F48
  $3F50,8,b1 #UDG$3F50
  $3F58,8,b1 #UDG$3F58
  $3F60,8,b1 #UDG$3F60
  $3F68,8,b1 #UDG$3F68
  $3F70,8,b1 #UDG$3F70
  $3F78,8,b1 #UDG$3F78
  $3F80,8,b1 #UDG$3F80
  $3F88,8,b1 #UDG$3F88
  $3F90,8,b1 #UDG$3F90
  $3F98,8,b1 #UDG$3F98
  $3FA0,8,b1 #UDG$3FA0
  $3FA8,8,b1 #UDG$3FA8
  $3FB0,8,b1 #UDG$3FB0
  $3FB8,8,b1 #UDG$3FB8
  $3FC0,8,b1 #UDG$3FC0
  $3FC8,8,b1 #UDG$3FC8
  $3FD0,8,b1 #UDG$3FD0
  $3FD8,8,b1 #UDG$3FD8
  $3FE0,8,b1 #UDG$3FE0
  $3FE8,8,b1 #UDG$3FE8
  $3FF0,8,b1 #UDG$3FF0
  $3FF8,8,b1 #UDG$3FF8
i $4000
