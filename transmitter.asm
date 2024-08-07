;2313 - 3.6864MHZ
.include "2313def.inc"

.equ PREAMBULA = $7E
.equ BALANS    = $08 ; WARTOSC PROGOWA 1/0
.equ P1        = $06
.equ P2        = $0
.equ P3        = $0
.equ SW_1      = $01
.equ SW_2      = $03
.equ SW_3      = $04
.equ TI        = $0A
.equ TA        = $03
.equ AF_C      = $0F
.equ FOTO_C    = $33
.equ PROG_C    = $99
.equ C_ON      = $77
.equ C_OFF     = $22
.equ LED_O     = $66
.equ LED_F     = $CC
.equ OFF       = $73

.equ bufor_adr = $90 ; bufor w sram na dane adresowe i pozycyjne pozyskane z eeprom
.equ cyfry_g   = 0x0064
.equ cyfry_d   = 0x0118
.equ dczasy    = 0x1F80 ; w eeprom adres zawierajacy pozycje kolejnych liczb na lcd
.equ menu_g    = 0x1FB0 ; w eeprom adres zawierajacy znaki AF, M, PRG (pozycje i adresy)
.equ liczniki  = 0x089E
.equ mems      = 0x08FE
.equ clear     = 0x0C3C
.equ ikonki    = 0x1F28

.equ ADR_1     = $00

.def  TIME_1 =  R1
.def  TIME_2 =  R2
.def  TIME_3 =  R3
.def  COUNT  =  R4
.def  TIMS_1 =  R5
.def  TIMS_2 =  R6
.def  TIMS_3 =  R7
.def  TIMC_1 =  R8
.def  TIMC_2 =  R9
.def  TIMC_3 =  R10

.def  CRC_L  =  R11 

.def  CNTT0  =  R12
.def  COMP   =  R13   
.def  MIN    =  R14
.def  SED    =  R15

.def  ACC_1  = 	R16
.def  ACC_2  =  R17
.def  ACC_3  =  R18
.def  ACC_4  =  R19
.def  ACC_5  = 	R20
.def  ACC_6  = 	R21
.def  numb_s = 	R22
.def  ACC_8  = 	R23

.def  temp1  = 	R24 ; 
.def  flags  = 	R25 ; REJESTR FLAG
.def  temp3  = 	R26
.def  temp4	 = 	R27
.def  temp5  = 	R28
.def  temp6  = 	R29

;.def  	ZL  	=  	R30
;.def  	ZH   	=  	R31

.equ      res_lcd = 0;
.equ      en_lcd  = 4;
.equ      dat_com = 3;
.equ      data    = 2;
.equ      sclk    = 1;

.equ  OK_FD =  0
.equ  I_HA  =  1
.equ  s_nd  =  2
.equ  on_poz=  3
.equ  OK_S  =  4
.equ  B_B   =  5
.equ  I_I   =  6
.equ  on_off=  7
  
.equ  OKV_FD=  1
.equ  I_HAV =  2
.equ  snd   =  4
.equ  onpoz =  8
.equ  OK_SC =  16
.equ  BB    =  32
.equ  II    =  64
.equ  onoff =  128

.equ  gmig_stan =  0
.equ  gser_stan =  1
.equ  mmig_stan =  2
.equ  mser_stan =  3
.equ  smig_stan =  4
.equ  sser_stan =  5
.equ  S_1   =  6
.equ  S_2   =  7

.equ  gmigstan =  1
.equ  gserstan =  2
.equ  mmigstan =  4
.equ  mserstan =  8
.equ  smigstan =  16
.equ  sserstan =  32
.equ  S1    =  64
.equ  S2    =  128

;***********************************************************
.cseg
.org $000

     RJMP pre_RESET  ;00	  
     RJMP INTER00    ;01 INT0 
     RETI            ;02 INT1
     RETI            ;03 T1 CAPTURE EVENT
     RJMP T1_MATCH   ;04 T1 CAPTURE MATCH
     RETI            ;05 T1 OVERFLOW
     RJMP TIMER      ;06 T0 OVERFLOW
     RETI            ;07 UART RX COMPLETE
     RETI            ;08 UART DATA REGISTER EMPTY
     RETI            ;09 UART TX COMPLETE
     RETI            ;0A ANALOG COMPARATOR
;***********************************************************
rjmpy_on:
		rjmp t_migawka_g_on
		rjmp t_migawka_m_on
		rjmp t_migawka_s_on
		rjmp t_seria_c_on
		rjmp t_seria_g_on
		rjmp t_seria_m_on
		rjmp t_seria_s_on
		rjmp t_wyzw_g_on
		rjmp t_wyzw_m_on
		rjmp t_wyzw_s_on
		rjmp menupr_g_l_on
		rjmp menupr_g_p_on
		rjmp menupr_d_l_on
		rjmp menupr_d_p_on
rjmpy_off:
		rjmp t_migawka_g_off
		rjmp t_migawka_m_off
		rjmp t_migawka_s_off
		rjmp t_seria_c_off
		rjmp t_seria_g_off
		rjmp t_seria_m_off
		rjmp t_seria_s_off
		rjmp t_wyzw_g_off
		rjmp t_wyzw_m_off
		rjmp t_wyzw_s_off
		rjmp menupr_d_l_off
		rjmp menupr_d_p_off
		rjmp menupr_g_l_off
		rjmp menupr_g_p_off
;**********************************************************************************
;**********************************************************************************
LED_OO:
        LDI   ACC_5  , 4 ;	znacznik zawartosci transmisji
        RJMP SENDING
;**********************************************************************************
LED_FF:
        LDI   ACC_5  , 5 ;	znacznik zawartosci transmisji
        RJMP SENDING
;**********************************************************************************
C_O:
       	LDI   ACC_5  , 6  ;	znacznik zawartosci transmisji
        RJMP SENDING
;**********************************************************************************
C_F:
        LDI   ACC_5  , 7 ;	znacznik zawartosci transmisji
        RJMP SENDING
;**********************************************************************************
OFF_DEV:
        LDI   ACC_5  , 8 ;	znacznik zawartosci transmisji
        RJMP SENDING
;**********************************************************************************
show:
		sbr  flags, onpoz
		rjmp show_ico
;**********************************************************************************
hide:
		cbr  flags, onpoz
		rjmp hide_ico
;**********************************************************************************
exit:
		rjmp menu_1
;**********************************************************************************
AF:     
        LDI   ACC_5  , 1 	;znacznik zawartosci transmisji
        RJMP SENDING
;**********************************************************************************
FOTO:
        LDI   ACC_5  , 2 	;znacznik zawartosci transmisji
        RJMP SENDING
;**********************************************************************************    
SEND_PROG:
        LDI   ACC_5  , 3 	;znacznik zawartosci transmisji
        RJMP SENDING
;**********************************************************************************

TIMER:
     PUSH temp3
     PUSH COMP
     IN   temp3 , SREG
;* * * * * * * * * * * * *
     IN   COMP , TCNT0
     ;CPSE COMP , temp6
     CPSE COMP , sed ; zastapilem powyzszy wiersz wolnym rejestrem "sed"
     RJMP KKK 
KKK:
     OUT  TCNT0 , CNTT0
;* * * * * * * * * * * * *  

     BRTC ZERUJ
     SBI  PORTD , 0
     RJMP BEZ_PRZ
ZERUJ:
     CBI  PORTD , 0


;********************************
;    NADAJNIK
;********************************

BEZ_PRZ:

     DEC  ACC_4
     BRNE OUT_T
     LDI  ACC_4  , 8 ;48
     SBRS flags  , OK_S
     RJMP SUBBIT_1
     
SUBBIT_0:
     CBR  flags  , OK_SC
     BRTS ZER_T
     SET
     RJMP OUT_T
ZER_T:
     CLT
     RJMP OUT_T
SUBBIT_1:     
     SBR  flags  , OK_SC
     SBR  flags  , BB
     ROL  temp1
     BRCS CPL
     RJMP OUT_T
CPL:
     BRTS ZERO_T
     SET
     RJMP OUT_T
ZERO_T:
     CLT     
OUT_T:
     BLD  temp3 , 6
     OUT  SREG  , temp3
     POP  COMP
     POP  temp3
     RETI

;******************************************************************************************
;******************************************************************************************
T1_MATCH:
        sbr  flags , i_hav
        RETI
;******************************************************************************************
INTER00:
		push  acc_1
		push  acc_2
		sbrc  flags, I_I
		rjmp  end_int
		lds   acc_1, ramend
		lds   acc_2, ramend - 1
		sbis  pind, SW_2
		rjmp  roluj_prawo
		sbis  pind, SW_1
		rjmp  roluj_lewo
		sbis  pind, SW_3
		set
end_inter00:
		sts   ramend, acc_1
end_int:
		rcall stop_inter_0
		pop   acc_2
		pop   acc_1
		cbr   flags, II
		RETI
roluj_prawo:
		inc   acc_1
		cp    acc_2, acc_1
		brge  end_inter00
		ldi   acc_1, 0
		rjmp  end_inter00
roluj_lewo:
		dec   acc_1
		brge  end_inter00
set_acc_1:
		mov   acc_1, acc_2
		rjmp  end_inter00
;******************************************************************************************
menu_2:
        rcall read_prog
		rcall intpoint
menu_2_start_poz:
		ldi   acc_1, 0
men_poz_powr:
		sts   ramend, acc_1
men_powrot:
		ldi   acc_1, 13
		sts   ramend - 1, acc_1
		rcall menudl
		clt
petlka:	
		ldi   acc_2, 15
		rcall set_on_all
		rcall op
		brts  menu_2_1

rjmp_off_loop:
		ldi   zl, low(rjmpy_off)
		clr   zh
		lds   acc_1, ramend
		add   zl, acc_1
		icall 
		
		rcall inter_0_1_0
		rcall op_1_3

        rjmp petlka

;"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 
set_on_all:
		cli
		sbr   flags, onoff
		rjmp  next_set
set_off_all:
        cbr   flags, onoff
next_set:
		clr   acc_1
		push  acc_2
		push  acc_1
rjmp_on_loop:
        ldi   zl, low(rjmpy_off)
		sbrc  flags, on_off
		ldi   zl, low(rjmpy_on)
		clr   zh
		pop   acc_1
		add   zl, acc_1
		inc   acc_1
		pop   acc_2
		push  acc_2
		push  acc_1
		cp    acc_1, acc_2
		brsh  rjmp_on_dalej
		icall 
		rjmp  rjmp_on_loop
rjmp_on_dalej:
		pop   acc_1
		pop   acc_2
		sei
		ret
;"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 
; podmenu funkcji dodatkowych pilota
menu_2_1:
		lds   acc_1, ramend
		cpi   acc_1, 13
		brne  next_oper

		ldi   acc_1, 0
		sts   ramend, acc_1
		ldi   acc_1, 7
		sts   ramend - 1, acc_1

men_2_1_petla:
		clt
		ldi   temp5, 32
		rcall go_obraz
		rcall op_1_3
		rcall inter_0_1_0
		lds   acc_1, ramend
		ldi   zl, 80
dec_adr:
		adiw  zl, 4
		dec   acc_1
		brge  dec_adr

		mov   temp5, zl
		rcall go_obraz
		rcall op_1_3
		brts  akcja
		rjmp  men_2_1_petla
akcja:
		cbr   flags, snd
		clr   zh
		ldi   zl, low(led_oo) - 2
		lds   acc_1, ramend
pet_adr:
		adiw  zl, 2
		dec   acc_1
		brge  pet_adr
		icall
		rcall op_1s
		rjmp  men_2_1_petla
;"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 
; podmenu przejscia do ekranu glownego
next_oper:
		cpi   acc_1, 12
		brne  next_oper1
		rjmp  menu_1
;"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 
; podmenu ladowania zawartosci licznikow
next_oper1:
		push  acc_1
		cpi   acc_1, 11
		brne  next_oper2
		rcall menupr_d_l_off
		rcall pre_mem
mem_read_petla:
		rcall mem_petla
		lds   acc_1, ramend
		sts   ramend - 2, acc_1
		rcall read_prog
		ldi   acc_2, 11
		rcall set_on_all
		brts  ending_mem
		rjmp  mem_read_petla
pre_mem:
		lds   acc_1, ramend - 2
		sts   ramend, acc_1
		ldi   acc_1 , 10
		sts   ramend - 1, acc_1
		clt
		ret
;"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 
; podmenu zapisu ustawien do eeprom
next_oper2:
		cpi   acc_1, 10
		brne  next_oper3
		rcall menupr_d_p_off
		rcall pre_mem
mem_save_petla:
		rcall mem_petla
		brtc  mem_save_petla
end_mem:
		lds   acc_1, ramend
		cpi   acc_1, 10
		breq  ending_mem
		sts   ramend - 2, acc_1
SAVE_PROG:						; sprawdzona - ok
		rcall set_adr_prg
save_pr:
		ld   min    , z+		; laduje kolejna dana do min
        OUT  EEAR   , ACC_1		; laduje adres do eear
        OUT  EEDR   , MIN 		; laduje dana do eedr
        SBI  EECR   , EEMWE		; ustawiam eemwe
        SBI  EECR   , EEWE		; ustawiam eewe
save_pr1:
        SBIC EECR   , EEWE		; czekam az bit eewe jest rowny 0
        RJMP save_pr1
		inc  acc_1
		dec  acc_2
		brne save_pr
ending_mem:
		pop   acc_1
		rjmp  men_poz_powr
;"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 
mem_petla:
		rcall inter_0_1_0
		ldi   temp6, high(mems)
		ldi   temp5, low(mems) - 16
		lds   acc_1, ramend
pet_mem:
		adiw  temp5, 0x10
		dec   acc_1
		brge  pet_mem
no_inc_mem:
		ldi   ACC_6, 0x45 ; nr wiersza
		ldi	  ACC_8, 0x94 ; nr kolumny
		rjmp  wpisz_obraz
;"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 
; podmenu ustawiania wartosci licznikow
next_oper3:
		clr   zh
		inc   acc_1
		mov   zl, acc_1
		ld    acc_1, z
		sts   ramend, acc_1
		pop   acc_1
		push  acc_1
		ldi   temp6, high(liczniki)
		ldi   temp5, low(liczniki)
		add   temp5, acc_1
		rcall czytaj_eeprom
		sts   ramend - 1, temp3
		clt
		ldi   temp5, 12
		rcall go_obraz
stopik_1:
		pop	  acc_1
		push  acc_1
		inc   acc_1
		mov   zl, acc_1
		clr   zh
		lds   acc_2, ramend
		st    z, acc_2

		ldi   acc_2, 11
		rcall set_on_all

		sbic  pind, sw_1
		sbis  pind, sw_2
		rjmp  no_op1

		rcall inter_0_1_0
		rcall op_1_3

		ldi   zl, low(rjmpy_off)
		clr   zh
		pop   acc_1
		push  acc_1
		add   zl, acc_1
		icall
		rcall op
		rjmp  no_inter0
no_op1:
		rcall inter_0
no_inter0:
		brtc  stopik_1
		pop   acc_1
		sts   ramend, acc_1
		rjmp  men_powrot
;""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
/*.def  TIME_1 =  R1
  .def  TIME_2 =  R2
  .def  TIME_3 =  R3
  .def  COUNT  =  R4
  .def  TIMS_1 =  R5
  .def  TIMS_2 =  R6
  .def  TIMS_3 =  R7
  .def  TIMC_1 =  R8
  .def  TIMC_2 =  R9
  .def  TIMC_3 =  R10*/
;""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

show_time:
		rcall read_prog
		rcall timer_1  ; 1/3 sekundy
        RCALL SLEEP_ID_ON
		rcall intpoint
		ldi   temp5, 0x74
		rcall go_obraz
		clt
sek_auto:
		ldi   acc_2, 11
		rcall timerek

		dec   TIMC_3
		brge  sek_auto
		ldi   acc_1, 59
		mov   TIMC_3, acc_1

		dec   TIMC_2
		brge  sek_auto
		ldi   acc_1, 59
		mov   TIMC_2, acc_1

		dec   TIMC_1
		brge  sek_auto
		
		dec   count
		brlt  only_migawka
		dec   count
		brlt  only_migawka
		inc   count

petla_show:	
		rcall cz_migawkaa
		rcall cz_seriaa
		lds   count, ramend - 3
		dec   count
		brne  petla_show
		rcall cz_migawkaa
koncz_show:
		ldi   acc_1, ramend - 5
		out   spl, acc_1
end_show:
		cbr   flags, i_hav
		rjmp  menu_1
;""""""""""""""""""""""""""""
only_migawka:
		inc   count
		rcall cz_migawkaa
		rjmp  end_show
;""""""""""""""""""""""""""""
timerek:
		brts  koncz_show
		rcall set_on_all
		rcall inter_0_1_0
		cbr   flags, i_hav
		sleep
		sbrs  flags, i_ha
		sleep
		ret
;""""""""""""""""""""""""""""
cz_migawkaa:
		sts   ramend - 3, count
		rcall read_prog
		lds   count, ramend - 3
		rjmp  cz_mig
cz_migawka:
		ldi   acc_2, 11
		rcall timerek
cz_mig:
		dec   TIME_3
		brge  cz_migawka
		ldi   acc_1, 59
		mov   TIME_3, acc_1

		dec   TIME_2
		brge  cz_migawka
		ldi   acc_1, 59
		mov   TIME_2, acc_1

		dec   TIME_1
		brge  cz_migawka
		ret

;""""""""""""""""""""""""""""
cz_seriaa:
		rcall read_prog
		lds   count, ramend - 3
		rjmp  cz_ser
cz_seria:
		ldi   acc_2, 11
		rcall timerek
cz_ser:
		dec   TIMS_3
		brge  cz_seria
		ldi   acc_1, 59
		mov   TIMS_3, acc_1

		dec   TIMS_2
		brge  cz_seria
		ldi   acc_1, 59
		mov   TIMS_2, acc_1

		dec   TIMS_1
		brge  cz_seria
		ret
;""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
pre_reset:

		clr   acc_1
		sts   ramend, acc_1
		sts   ramend - 1, acc_1
		sts   ramend - 2, acc_1		 
        CLR   flags ; REJESTR FLAG
RESET:

        LDI   ACC_1 , RAMEND - 5 ; bo w ramend - 4 siedzi acc_5 i koniec!!!
        OUT   SPL   , ACC_1
        CLI
        RCALL STOP_INTER_0
		andi  flags, 0b00001000
        ;CLR   flags ; REJESTR FLAG
		clr   numb_s
        LDI   temp6 , $0C
		mov   sed, temp6
        /*CBI  DDRD  , SW_1      ; SWITCH 1
        SBI  PORTD , SW_1 
        CBI  DDRD  , SW_2      ; SWITCH 2
        SBI  PORTD , SW_2 
        CBI  DDRD  , SW_3      ; SWITCH 3
        SBI  PORTD , SW_3
        CBI  DDRD  , 0    		; OUT
        CBI  PORTD , 0   		 ; jesli tranzystor to cbi
        cBI  DDRD  , 2
        sBI  PORTD , 2*/

		clr  acc_1
		out  ddrd, acc_1
		ldi  acc_1, 0b00011110
		out  portd, acc_1  

		/*sbi  ddrb, sclk
		sbi  ddrb, data
        sbi  ddrb, dat_com
        sbi  ddrb, en_lcd
        sbi  ddrb, res_lcd*/
		ldi  acc_1, 0b00011111
		out  ddrb, acc_1
;"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
; USTAWIENIE LCD W POWER DOWN
		cbi     portb, en_lcd  ; lcd chip enable
        cbi     portb, dat_com ; komenda
		ldi     ACC_2, 0x24 ;- lcd w power down  
		rcall   write_byte
RES:
		sbis  pind, 2
		rjmp  res
        SEI
		rcall op_1s
;***********************

		rcall power_down
menu_1:
		sei
		rcall init_lcd
menu_x:
		sbis  pind, 2
		rjmp  menu_x
		ldi   temp5, 4
		rcall go_obraz
		rcall op_1s
res_1:
        LDI   ACC_1 , RAMEND - 5 ; bo w ramend - 4 siedzi acc_5 i koniec!!!
        OUT   SPL   , ACC_1
		rcall power_down
		sbr   flags, snd
;***********************
; PROGRAMOWANIE PILOTA
;***********************
PROGRAM_PIL:
READ_PIN:
        SBIS  PIND  , SW_1
        RJMP  AF_OR_PROG
        SBIS  PIND  , SW_2
        RJMP  FOTO
        SBIS  PIND  , SW_3
        RJMP  SEND_PROG
        RJMP  RES_1
;*********************
AF_OR_PROG:
        cbr   flags , i_hav
        RCALL TIMER_1
        RCALL INTER_0_0_1
        RCALL SLEEP_ID_ON
        
        SLEEP
        CLI

        RCALL STOP_INTER_0
        RCALL STOP_TIMER_1
        RCALL SLEEP_ID_OFF
        SEI
        sbrs  flags , i_ha
        RJMP  AF
;* * * * 
PROG_or_exit:
		sbic  pind, sw_3
		rjmp  menu_2
		rjmp  reset ; wylaczenie nadajnika
;**********************************************************************************
power_down:
		cli
		sbr   flags, II
        RCALL SLEEP_PD_ON
        RCALL INTER_0
		sei
        SLEEP
        rjmp SLEEP_PD_OFF
;**********************************************************************************
SENDING:
		push  acc_5
		rcall read_prog				;  zawsze
		ldi   temp6, high(menu_g)   ; adres bazowy w eeprom
		ldi   temp5, low(menu_g) - 10
obl_adr:					; przesuniecie adresu eeprom o ilosc danych (10) razy acc_5
		adiw  temp5, 10
		dec   acc_5
		brne  obl_adr
noinc:
        ldi   acc_5, 11		; acc_5 musi byc wieksze o 1 od rzeczywistej ilosci bajtow
		rcall ikony			; pobiera z eeprom do ram dane adresu obrazu i jego pozycji na lcd
		rcall zaladuj_with_zl
		ldi   zl, bufor_adr + 8
		clr   zh
		ld    acc_5, z+ 	; pobiera z ram kod transmisji
		ld    acc_3, z		; pobiera z ram ilosc powtorzen
SENDING_1:
        RCALL USTAW_TIMER
        RCALL TIMER_100MS
        RCALL SEND_AF_FOTO
        RCALL OP1
        DEC   ACC_3
        BRNE  SENDING_1
		ldi   zl, bufor_adr + 4
		rcall zaladuj
		pop   acc_5
		sbrs  flags, s_nd
		ret
		sbrs  flags, on_poz
jmp_men:
		rjmp  res_1
		cpi   acc_5, 3
		brne  jmp_men
		rjmp  show_time		
;**********************************************************************************
;**********************************************************************************
;**********************************************************************************
op_1s:
		rcall timer_1
		rjmp  op1
OP_1_3:
		rcall TIMER_1_3
		rjmp  op1         
OP:
        RCALL TIMER_1_6
op1:
        RCALL SLEEP_ID_ON
        SLEEP
        RCALL SLEEP_ID_OFF
        rjmp  STOP_TIMER_1
;**********************************************************************************    
SEND_AF_FOTO:
        sbi   ddrd   , 0                            
        RCALL START_T0
        LDI   temp1   , $0      
        RCALL KONIEC_1
        LDI   temp1   , $0      
        RCALL KONIEC_1
        LDI   temp1   , $0      
        RCALL KONIEC_1        
        LDI   temp1   , $7E     
        RCALL KONIEC_1
        LDI   temp1   , $00     
        RCALL KONIEC_1
        LDI   temp1   , $00     
        RCALL KONIEC_1
        MOV   temp1   , ACC_5
        RCALL KONIEC_1
;* * * *
        CPI   ACC_5   , PROG_C
        BREQ  STOP_2
;* * * *
        LDI   temp1   , $F0      
        RCALL KONIEC_1       
        LDI   temp1   , $55      
        RCALL KONIEC_1       
        LDI   temp1   , $05      
        RCALL KONIEC_1
        LDI   temp1   , $05      
        RCALL KONIEC_1
        LDI   temp1   , $05      
        RCALL KONIEC_1
KON:
        SBRS  flags , B_B
        RJMP  KON
        CBR   flags , BB
KONI:
        SBRS  flags , B_B
        RJMP  KONI
        CBR   flags , BB
        RCALL STOP_T0
        cbi   ddrd  , 0
        CBI   PORTD , 0            ; jestli tranzystor to ma byc sbi
        SET
        RET
;***************************************************************************************        
; czyta rejestry r1 - r11 i wysyla je w eter
;***************************************************************************************        
STOP_2:                           ; CZAS MIGAWKI, ILO   I ODST P W SERII, CZAS STARTU PROGRAMU
		rcall crc
		ldi  acc_2, 11
		ldi  zh, 0
		ldi  zl, 1
seprog:
		ld   temp1, z+
		rcall koniec_1
		dec  acc_2
		brne seprog
		rjmp kon

/*        RCALL CRC
        MOV   temp1   , TIME_1      
        RCALL KONIEC_1
        MOV   temp1   , TIME_2      
        RCALL KONIEC_1
        MOV   temp1   , TIME_3      
        RCALL KONIEC_1
        MOV   temp1   , COUNT      
        RCALL KONIEC_1
        MOV   temp1   , TIMS_1      
        RCALL KONIEC_1
        MOV   temp1   , TIMS_2      
        RCALL KONIEC_1
        MOV   temp1   , TIMS_3      
        RCALL KONIEC_1
        MOV   temp1   , TIMC_1      
        RCALL KONIEC_1        
        MOV   temp1   , TIMC_2      
        RCALL KONIEC_1        
        MOV   temp1   , TIMC_3      
        RCALL KONIEC_1
        MOV   temp1   , CRC_L      
        RCALL KONIEC_1

        RJMP  KON   */
;*****************************************
KONIEC_1:
        LDI   ACC_8   , 128 ;$08 
        RCALL SLEEP_ID_ON
KONIEC:
        SLEEP
        DEC   ACC_8
        BRNE  KONIEC
        rjmp SLEEP_ID_OFF
;**************************************************************
;**************************************************************
USTAW_TIMER:
        LDI  ACC_4 , 8   	 ; LICZ
        LDI  ACC_1 , 125 ; 130
        COM  ACC_1
        MOV  CNTT0 , ACC_1
        OUT  TCNT0 , CNTT0

        LDI  ACC_1 , $02
        OUT  TIMSK , ACC_1
        in   acc_1 , tifr
        ori  acc_1 , 0b00000010
        out  tifr  , acc_1
        CLR  ACC_1
        RET
;**************************************************************
STOP_T0: 
        CLR  ACC_1
		RJMP t0_t0
;**************************************************************
START_T0: 
        LDI  ACC_1  , $01
t0_t0:
        OUT  TCCR0  , ACC_1
        RET         
;**************************************************************
;**************************************************************
CRC:
        CLR  CRC_L
        EOR  CRC_L , ACC_5
        EOR  CRC_L , TIME_1 
        EOR  CRC_L , TIME_2 
        EOR  CRC_L , TIME_3 
        EOR  CRC_L , TIMS_1 
        EOR  CRC_L , TIMS_2 
        EOR  CRC_L , TIMS_3
        EOR  CRC_L , COUNT 
        EOR  CRC_L , TIMC_1 
        EOR  CRC_L , TIMC_2 
        EOR  CRC_L , TIMC_3 
        RET
;**************************************************************
;**************************************************************
TIMER_1:
;1 SEKUNDA     
         LDI  ACC_1  , $0E ;07       
         LDI  ACC_2  , $10 ;08 
         RJMP SET_T1
TIMER_100MS:
;100 MS
         LDI  ACC_1  , $01        
         LDI  ACC_2  , $68  
         RJMP SET_T1
TIMER_1_3:         
;1/3 SEKUNDY
         LDI  ACC_1  , $04        
         LDI  ACC_2  , $B0 
         RJMP SET_T1
TIMER_1_6:         
;1/6 SEKUNDY
         LDI  ACC_1  , $02        
         LDI  ACC_2  , $50 
SET_T1:
         OUT  OCR1AH , ACC_1      ; SET MATCH REGISTER H
         OUT  OCR1AL , ACC_2      ; SET MATCH REGISTER L

         CLR  ACC_1
         OUT  TCNT1H , ACC_1
         OUT  TCNT1L , ACC_1
         
         LDI  ACC_1  , $0D
         OUT  TCCR1B , ACC_1      ; SET PRESCALER T1 = CK/1024, I ZALACZONY RESET MATCH
         
         IN   ACC_1  , TIFR
         ORI  ACC_1  , 0B01000000
         OUT  TIFR   , ACC_1      ; WYZERUJ FLAG  COMPARE MATCH
         
         IN   ACC_1  , TIMSK
         ORI  ACC_1  , 0B01000000 ; SET INTERRUPT T1 MATCH
         OUT  TIMSK  , ACC_1
         RET
;**************************************************************
;**************************************************************
STOP_TIMER_1:
         IN   ACC_1  , TIFR
         ORI  ACC_1  , 0B01000000
         OUT  TIFR   , ACC_1      ; WYZERUJ FLAG  COMPARE MATCH

         CLR  ACC_1
         OUT  TCCR1B , ACC_1
         RET         
;**************************************************************
;**************************************************************
INTER_0:
         IN   ACC_1  , MCUCR
         ANDI ACC_1  , 0B11111100  ; POZIOM LOW
		 RJMP ustaw_int_0
;**************************************************************
INTER_0_0_1:
         IN   ACC_1  , MCUCR
         ORI  ACC_1  , 0B00000011  ; ZBOCZE narastajace
		 RJMP ustaw_int_0
;**************************************************************
INTER_0_1_0:
         IN   ACC_1  , MCUCR
         ORI  ACC_1  , 0B00000010  ; ZBOCZE OPADAJACE
		 andi acc_1  , 0b11111110

ustaw_int_0:
         OUT  MCUCR  , ACC_1 
         IN   ACC_1  , GIFR
         ORI  ACC_1  , 0B01000000
         OUT  GIFR   , ACC_1 
         IN   ACC_1  , GIMSK
         ORI  ACC_1  , 0B01000000
         OUT  GIMSK  , ACC_1 
         RET
;**************************************************************
;**************************************************************
STOP_INTER_0:
         /*IN   ACC_1  , GIMSK
         ANDI ACC_1  , 0B00111111
         OUT  GIMSK  , ACC_1 
         IN   ACC_1  , GIFR
         ORI  ACC_1  , 0B11000000
         OUT  GIFR   , ACC_1 */
         LDI  ACC_1  , 0B00111111
         OUT  GIMSK  , ACC_1 
         LDI  ACC_1  , 0B11000000
         OUT  GIFR   , ACC_1 
         RET
;**************************************************************
;**************************************************************
SLEEP_PD_ON:
         IN   ACC_1  , MCUCR
         ORI  ACC_1  , 0B00110000
         rjmp sleep_end
;**************************************************************
SLEEP_PD_OFF:
         IN   ACC_1  , MCUCR
         ANDI ACC_1  , 0B11001111
         rjmp sleep_end
;**************************************************************
SLEEP_ID_ON:
         IN   ACC_1  , MCUCR
         ORI  ACC_1  , 0B00100000
         rjmp sleep_end
;**************************************************************
SLEEP_ID_OFF:
         IN   ACC_1  , MCUCR
         ANDI ACC_1  , 0B11011111
sleep_end:
         OUT  MCUCR  , ACC_1 
         RET
;**************************************************************
; zapisuje rejestry r1 ... r10 do eeprom od adresu ADR_1
;**************************************************************
set_adr_prg:
		 clr   zl
		 lds   acc_2, ramend - 2
pet_eep:
		 adiw  zl, 10
		 dec   acc_2
	 	 brge  pet_eep
no_inc_eep:
		 mov   acc_1, zl
		 ldi   zl, 1
		 clr   zh
		 ldi   acc_2, 10
		 ret
;**************************************************************
; czyta wewnetrzny eeprom do rejestrow r1...r10 
;**************************************************************
READ_PROG:	; sprawdzona - ok
		 rcall set_adr_prg
read_pr:        
         OUT  EEAR  , ACC_1
         SBI  EECR  , EERE
		 nop
         IN   MIN   , EEDR
		 inc  acc_1
		 st   z+, min
		 dec  acc_2
		 brne read_pr
         RET
;******************************************************************************************
; funkcje obslugi wyswietlacza i pamieci szeregowej eeprom
;******************************************************************************************

;zawartosc eeprom:
; generalne zalozenie: wszystkie obrazy musza miec parzysta liczbe kolumn!!!!!!!!!!!!!!
;.include "wrzuty\hex_dec.txt"		; konwersja hex *0x0000 - 0x0063* 				(100 B)
;.include "wrzuty\cyfr8g12.txt"		; cyfry_g		*0x0064 - 0x0117* 8x12		pix (180B) 
;.include "wrzuty\cyfr8d12.txt"		; cyfry_d 		*0x0118 - 0x01CB* 8x12		pix (180B)
;.include "wrzuty\3xdwk1.txt"		; potr. dwokr.  *0x01CC - 0x01EB* 5x36		pix (32B)
;.include "wrzuty\intpoint.txt"		;				*0x01EC - 		* 84x32		pix (338B)
;.include "wrzuty\arrows.txt"	    ; strzalki 		*0x0426 - 0x048D* 12x12  	pix (104B)
;.include "wrzuty\menu0.txt"		; obrazek 		*0x048E - 0x0687* 84x48  	pix (506B)
;.include "wrzuty\af_black.txt"		; obrazek 		*0x0688 - 0x06C1* 24x16  	pix (58B)
;.include "wrzuty\m_black.txt"		; obrazek 		*0x06C2 - 0x06FB* 14x16  	pix (58B)
;.include "wrzuty\pr_black.txt"		; obrazek 		*0x06FC - 0x0735* 30x16  	pix (58B)
;.include "wrzuty\af_white.txt"		; obrazek 		*0x0736 - 0x076F* 24x16  	pix (58B)
;.include "wrzuty\m_white.txt"		; obrazek 		*0x0770 - 0x07A9* 14x16  	pix (58B)
;.include "wrzuty\pr_white.txt"		; obrazek 		*0x07AA - 0x07E3* 30x16  	pix (58B)
;.include "wrzuty\menudl.txt"		;				*0x07E4 - 0x0839* 84x08		pix (86B)
;.include "wrzuty\razy.txt"			;				*0x083A - 0x0841* 06x08		pix (08B)
;.include "wrzuty\pr_gor_l.txt"		;				*0x0842 - 0x0851* 08x14		pix (16B) 
;.include "wrzuty\pr_gor_p.txt"		;				*0x0852 - 0x0861* 08x14		pix (16B) 
;.include "wrzuty\pr_dol_l.txt"		;				*0x0862 - 0x087F* 16x14		pix (30B)  
;.include "wrzuty\pr_dol_p.txt"		;				*0x0880 - 0x089D* 16x14		pix (30B)  
;.db 9,59,59,99,9,59,59,9,59,59		; liczniki		*0x089E - 0x08A7*               (10B)
;.include "wrzuty\menplmin.txt"		;				*0x08A8 - 0x08FD* 84x08		pix (86B)
;.include "wrzuty\men_m0.txt"		;				*0x08FE - 0x090D* 14x08		pix (16B)
;.include "wrzuty\men_m1.txt"		;				*0x090E - 0x091D* 14x08		pix (16B)
;.include "wrzuty\men_m2.txt"		;				*0x091E - 0x092D* 14x08		pix (16B)
;.include "wrzuty\men_m3.txt"		;				*0x092E - 0x093D* 11x08		pix (16B)
;.include "wrzuty\men_m4.txt"		;				*0x093E - 0x094D* 14x08		pix (16B)
;.include "wrzuty\men_m5.txt"		;				*0x094E - 0x095D* 14x08		pix (16B)
;.include "wrzuty\men_m6.txt"		;				*0x095E - 0x096D* 14x08		pix (16B)
;.include "wrzuty\men_m7.txt"		;				*0x096E - 0x097D* 14x08		pix (16B)
;.include "wrzuty\men_m8.txt"		;				*0x097E - 0x098D* 14x08		pix (16B)
;.include "wrzuty\men_m9.txt"		;				*0x098E - 0x099D* 14x08		pix (16B)
;.include "wrzuty\men_me.txt"		;				*0x099E - 0x09AD* 14x08		pix (16B)
;.include "wrzuty\puste!!!!!!		;				*0x09AE - 0x0A95* 58x32		pix (232B)
;.include "wrzuty\siatka.txt"		;				*0x0A96 - 0x0C3B* 84x40		pix (422B)

;.include "wrzuty\clear.txt"		;				*0x0C3C - 0x0C61* 18x16		pix (38B)

;.include "wrzuty\led_on.txt"		;				*0x0C62 - 0x0C87* 18x16		pix (38B)
;.include "wrzuty\led_off.txt"		;				*0x0C88 - 0x0CAD* 18x16		pix (38B)
;.include "wrzuty\c_on.txt"			;				*0x0CAE - 0x0CD3* 18x16		pix (38B)
;.include "wrzuty\c_off.txt"		;				*0x0CD4 - 0x0CF9* 18x16		pix (38B)
;.include "wrzuty\off.txt"			;				*0x0CFA - 0x0D1F* 18x16		pix (38B)
;.include "wrzuty\tim_on.txt"		;				*0x0D20 - 0x0D45* 18x16		pix (38B)
;.include "wrzuty\tim_off.txt"		;				*0x0D46 - 0x0D6B* 18x16		pix (38B)
;.include "wrzuty\exit_3.txt"		;				*0x0D6C - 0x0D91* 18x16		pix (38B)

;.include "wrzuty\led_on_b.txt"		;				*0x0D92 - 0x0DB7* 18x16		pix (38B)
;.include "wrzuty\led_offb.txt"		;				*0x0DB8 - 0x0DDD* 18x16		pix (38B)
;.include "wrzuty\c_on_b.txt"		;				*0x0DDE - 0x0E03* 18x16		pix (38B)
;.include "wrzuty\c_off_b.txt"		;				*0x0E04 - 0x0E29* 18x16		pix (38B)
;.include "wrzuty\off_b.txt"		;				*0x0E2A - 0x0E4F* 18x16		pix (38B)
;.include "wrzuty\tim_onb.txt"		;				*0x0E50 - 0x0E75* 18x16		pix (38B)
;.include "wrzuty\tim_offb.txt"		;				*0x0E76 - 0x0E9B* 18x16		pix (38B)
;.include "wrzuty\exit_3_b.txt"		;				*0x0E9C - 0x0EC1* 18x16		pix (38B)


;				|	 adres		| pozycja |
;intpoint:		.db 0x01, 0xEC, 0x40, 0x80		;	*0x1F00 - 0x1F03*
;menu:			.db 0x04, 0x8E, 0x40, 0x80		;	*0x1F04 - 0x1F07*
;menudl:		.db 0x07, 0xE4, 0x45, 0x80		;	*0x1F08 - 0x1F0B*
;menplmin:		.db 0x08, 0xA8, 0x45, 0x80		;	*0x1F0C - 0x1F0F*
;menupr_g_l_on:	.db 0x08, 0x42, 0x42, 0xB6		;	*0x1F10 - 0x1F13*
;menupr_g_p_on:	.db 0x08, 0x52, 0x42, 0xC4		;	*0x1F14 - 0x1F17*
;menupr_d_l_on:	.db 0x08, 0x62, 0x43, 0xB6		;	*0x1F18 - 0x1F1B*
;menupr_d_p_on:	.db 0x08, 0x80, 0x43, 0xC4		;	*0x1F1C - 0x1F1F*
;siatka:		.db 0x0A, 0x96, 0x40, 0x80		;   *0x1F20 - 0x1F23*

;clear:			.db 0x0C, 0x3C, 0x42, 0x80		;	*0x1F24 - 0x1F27*

;led_on:		.db 0x0C, 0x62, 0x40, 0x84		;	*0x1F28 - 0x1F2B*		
;led_off:		.db 0x0C, 0x88, 0x40, 0x97		;	*0x1F2C - 0x1F2F*
;c_on:			.db 0x0C, 0xAE, 0x40, 0xAA		;	*0x1F30 - 0x1F33*
;c_off:			.db 0x0C, 0xD4, 0x40, 0xBD		;	*0x1F34 - 0x1F37*
;off:			.db 0x0C, 0xFA, 0x42, 0x84		;	*0x1F38 - 0x1F3B*
;tim_on:		.db 0x0D, 0x20, 0x42, 0x97		;	*0x1F3C - 0x1F3F*
;tim_off:		.db 0x0D, 0x46, 0x42, 0xAA		;	*0x1F40 - 0x1F43*
;exit_3:		.db 0x0D, 0x6C, 0x42, 0xBD		;	*0x1F44 - 0x1F47*

;tim_onb:		.db 0x0E, 0x50, 0x42, 0x97		;	*0x1F48 - 0x1F4B*
;tim_offb:		.db 0x0E, 0x76, 0x42, 0xAA		;	*0x1F4C - 0x1F4F*
;exit_3_b:		.db 0x0E, 0x9C, 0x42, 0xBD		;	*0x1F50 - 0x1F53*

;clear1:		.db 0x0C, 0x3C, 0x40, 0x84		;	*0x1F54 - 0x1F57*
;clear2:		.db 0x0C, 0x3C, 0x40, 0x97		;	*0x1F58 - 0x1F5B*
;clear3:		.db 0x0C, 0x3C, 0x40, 0xAA		;	*0x1F5C - 0x1F5F*
;clear4:		.db 0x0C, 0x3C, 0x40, 0xBD		;	*0x1F60 - 0x1F63*
;clear5:		.db 0x0C, 0x3C, 0x42, 0x84		;	*0x1F64 - 0x1F67*
;clear6:		.db 0x0C, 0x3C, 0x42, 0x97		;	*0x1F68 - 0x1F6B*
;clear7:		.db 0x0C, 0x3C, 0x42, 0xAA		;	*0x1F6C - 0x1F6F*
;clear8:		.db 0x0C, 0x3C, 0x42, 0xBD		;	*0x1F70 - 0x1F73*


;dwukropek:			;|adres|     |pozycja| 	   |adres|   |pozycja| 	  
;dwk: 			.db 0x01, 0xCC, 0x40, 0x88, 0x01, 0xCC, 0x40, 0x9D,0,0		;*0x1F80*
;czasy:   ;pozycje |godzina|     |    minuty     |       |   sekundy  |     ;*------*
;op_mig:	.db 0x40, 0x80, 0x40, 0x8D, 0x40, 0x95, 0x40, 0xA2, 0x40, 0xAA  ;**
;seria:  	.db 0x41, 0x80, 0x41, 0x8D, 0x41, 0x95, 0x41, 0xA2, 0x41, 0xAA  ;*------*
;timeop:	.db 0x43, 0x80, 0x43, 0x8D, 0x43, 0x95, 0x43, 0xA2, 0x43, 0xAA  ;**
;cnt:       .db 0x40, 0xBC, 0x40, 0xC4

;menu_g
;           |adres b | pozycja b|   adres w  |pozycja w  |  kod| liczba powtorzen
;af_eep: .db 0x06, 0x88, 0x44, 0x80, 0x07, 0x36, 0x44, 0x80, 0x0F, 14	;*0x1FB0*
;m_eep:  .db 0x06, 0xC2, 0x44, 0x9C, 0x07, 0x70, 0x44, 0x9C, 0x33, 14	;*------*
;pr_eep: .db 0x06, 0xFC, 0x44, 0xB8, 0x07, 0xAA, 0x44, 0xB8, 0x99, 14	;*------*
;lon_eep:.db 0x0D, 0x92, 0x40, 0x84, 0x0C, 0x62, 0x40, 0x84, 0x66, 14	;*------*
;lof_eep:.db 0x0D, 0xB8, 0x40, 0x97, 0x0C, 0x88, 0x40, 0x97, 0xCC, 14	;*------*
;con_eep:.db 0x0D, 0xDE, 0x40, 0xAA, 0x0C, 0xAE, 0x40, 0xAA, 0x77, 14	;*------*
;cof_eep:.db 0x0E, 0x04, 0x40, 0xBD, 0x0C, 0xD4, 0x40, 0xBD, 0x22, 14	;*------*
;off_eep:.db 0x0E, 0x2A, 0x42, 0x84, 0x0C, 0xFA, 0x42, 0x84, 0x73, 31	;*0x1FFF*

.equ	obrazki	= 0x1F00


intpoint:
		ldi     temp5, 0
		rjmp    go_obraz
;menu:
		;ldi     acc_5, 4
		;rjmp    go_obraz
menudl:
		ldi     temp5, 8
		rjmp    go_obraz
;menplmin:
;		ldi     temp5, 12
;		rjmp    go_obraz

menupr_g_l_off:
		sbr     numb_s, s1
menupr_g_l_on:
		ldi     temp5, 16
		rjmp    go_obraz

menupr_g_p_off:
		sbr     numb_s, s1
menupr_g_p_on:
		ldi     temp5, 20
		rjmp    go_obraz

menupr_d_l_off:
		sbr     numb_s, s1
menupr_d_l_on:
		ldi     temp5, 24
		rjmp    go_obraz

menupr_d_p_off:
		sbr     numb_s, s1
menupr_d_p_on:
		ldi     temp5, 28
		rjmp    go_obraz

;siatka:
;		ldi     temp5, 32
;		rjmp    go_obraz

show_ico:
		ldi     temp5, 72
		rjmp    go_obraz

hide_ico:
		ldi     temp5, 76
		;rjmp    go_obraz

go_obraz:
		ldi     temp6, high(obrazki)   ; adres bazowy w eeprom
		adiw    temp5, low(obrazki)

        ldi     acc_5, 5		; acc_5 musi byc wieksze o 1 od rzeczywistej ilosci bajtow
		rcall   ikony			; pobiera z eeprom do ram dane adresu obrazu i jego pozycji na lcd
		rcall   zaladuj_with_zl
		cbr     numb_s, s1
		ret
;***************************************************************************
; inicjalizacja LCD - 37 ms
;***************************************************************************
init_lcd:
		cbi     portb, en_lcd  ; lcd chip enable
		cbi		portb, res_lcd ; reset lcd
		rcall   op			   ; opoznienie
		sbi     portb, res_lcd ; koniec resetu

        cbi     portb, dat_com ; komenda
		ldi     ACC_2, 0x21 ;- prze  czenie w tryb rozszerzony komend  
		rcall   write_byte
		ldi     ACC_2, 0xCD ;- kontrast (Vop) 0x80 - 0xff
		rcall   write_byte
		ldi     ACC_2, 0x06 ;- wsp czynnik temperaturowy 
		rcall   write_byte
		ldi     ACC_2, 0x11 ;- multipleksowanie (Bias) 10-17 
		rcall   write_byte
		ldi     ACC_2, 0x20 ;- prze  czenie na tryb standardowy komend, adresowanie poziome  
		rcall   write_byte
		ldi     ACC_2, 0x08 ;- czyszczenie ekranu  
		rcall   write_byte
		ldi     ACC_2, 0x0C ;- tryb standardowy 0C (mo e oczywi cie by  tak jak masz negatywowy -0x0D)
		rjmp    write_byte
;***************************************************************************
; funkcja czytajaca eeprom
;***************************************************************************
;***************************************************************************
; funkcja start i stop
;***************************************************************************
start_ep:
		sbi portb, en_lcd
		sbi portb, data
		sbi portb, sclk
		rcall small_del
		cbi portb, data ; warunek start
		rcall small_del
		rjmp  end_ep
;***************************************************************************
; funkcja wpisujaca bajt danych
;***************************************************************************
write_ep:
		rcall   write_byte
        cbi     portb, data	; ack
		rcall 	takt
		ret
write_byte:       
		ldi		ACC_1, 0x08
		sbi     ddrb , data
send_bit:
        sbi     portb, data
		sbrs    ACC_2, 7 
		cbi     portb, data
		rcall 	takt
        lsl     ACC_2  
		dec     ACC_1
		brne    send_bit
		ret
;***************************************************************************
; funkcja czytaj bajt danych
;***************************************************************************
read_byte:       
		ldi		ACC_1, 0x08
		cbi     ddrb , data
read_bit:
        lsl     ACC_2
		sbr     ACC_2, 1
		sbis    pinb , data     
        cbr     ACC_2, 1
		rcall 	takt
		dec     ACC_1
		brne    read_bit
		ret
no_ack:
        sbi     portb, data ; jak wyzej
end_ack:
		sbi     ddrb, data	; wyslanie bitu ack
		rcall 	takt
		ret
;***************************************************************************
; takt sclk
;***************************************************************************
takt:
		sbi     portb, sclk
		rcall	small_del
		cbi     portb, sclk
		ret

;***************************************************************************
; wpisuje zadany fragment eeprom do ramu
;***************************************************************************
eeprom_to_ram:
		ldi   ZL, 0x60		; adres zerowy sram
x_eeprom_to_ram: ; zapisuje dane z eeprom do adresu w ram wskazanego w ZL
		clr   ZH
		dec	  acc_5 ; ilosc danych do zapisania znajduje sie w acc_5
		rcall start_ep
		ldi   ACC_2, 0xA1
		rcall write_ep ; dane z eeprom pobierane sa z biezacego adresu okreslonego wczesniej
to_ram:
		rcall read_byte
        cbi   portb, data ; ack
		rcall end_ack
		rcall changes
		dec   ACC_5
		brne  to_ram
		lds   acc_5, ramend - 4
		rcall read_byte
		rcall no_ack
		rcall changes
end_etr:	
		rjmp stop_ep
changes:
		sbrc  numb_s, s_1 ; jesli ustawiona flaga s1 - wpisuj bajt zerowy
		clr   ACC_2
		ld    temp4, Z
		sbrc  numb_s, s_2 ; jesli ustawiona flaga s_2 - eoruj (polacz) czesci cyfr
		eor   acc_2, temp4
		st	  Z+, ACC_2
		ret
;***************************************************************************
; wpisuje fragment ramu do lcd
;***************************************************************************
ram_to_lcd:
		ldi   ZL, 0x60		; adres zerowy sram
x_ram_to_lcd: ; zapisuje dane z ram wskazane w ZL do lcd
		clr   ZH
to_lcd:
		ld	  ACC_2, Z+
		rcall write_byte ; dane wyswietlane sa w biezacej pozycji lcd okreslonej wczesniej
		dec   ACC_5 ; ilosc danych do wyswietlebnia znajduje sie w acc_5
		brne  to_lcd
		ret
;***************************************************************************
; pobiera z eeprom dane dot: adresu obrazu w eeprom i pozycji, na ktorej ma byc 
; wyswietlony na lcd - dane te zapisuje w sram od adresu bufor_adr
;***************************************************************************
ikony:
		push  zl
		push  numb_s
		cbr   numb_s, s1 + s2
		rcall start_ep
		ldi   ACC_2, 0xA0
		rcall write_ep
		mov   ACC_2, temp6
		rcall write_ep
		mov   ACC_2, temp5
		rcall write_ep
		ldi   zl, bufor_adr
		rcall x_eeprom_to_ram
		pop   numb_s
		pop   zl
		ret
;**********************************************************************************
; laduje z sram dane: pozycje obrazu na lcd i adres obrazu w eeprom
;**********************************************************************************
laduj_dane:
		clr   zh
		ld    temp6, z+
		ld    temp5, z+
read_poz:
		clr   zh
		ld    ACC_6, z+
		ld    ACC_8, z
		ret
;**********************************************************************************
zaladuj_with_zl:
		ldi   zl, bufor_adr
zaladuj:
		rcall laduj_dane	; pobiera z ram dane adresu obrazu i jego pozycji i wyswietla
doit:
		rjmp  wpisz_obraz
;**********************************************************************************
;czasy:   ;pozycje |godzina|     |    minuty     |       |   sekundy  |     ;*------*
;op_mig:	.db 0x40, 0x80, 0x40, 0x8D, 0x40, 0x95, 0x40, 0xA2, 0x40, 0xAA  ;**
;seria:  	.db 0x41, 0x80, 0x41, 0x8D, 0x41, 0x95, 0x41, 0xA2, 0x41, 0xAA  ;*------*
;timeop:	.db 0x43, 0x80, 0x43, 0x8D, 0x43, 0x95, 0x43, 0xA2, 0x43, 0xAA  ;**
;cnt:       .db 0x41, 0xB8, 0x41, 0xC0
;**********************************************************************************
;**********************************************************************************
;**********************************************************************************
;**********************************************************************************
t_migawka_g_off:
		sbr	  numb_s, gmigstan
		rjmp  mig_g
t_migawka_g_on:
		cbr	  numb_s, gmigstan
mig_g:
		sbr   numb_s, s1
		sbrs  numb_s, gmig_stan
		cbr   numb_s, s1
		mov   min, TIME_1
		ldi   temp5, 10
		rcall cbr_s1
		sbr   numb_s, s1 + s2
		sbrs  numb_s, gser_stan
		cbr   numb_s, s1
		mov   min, TIMS_1
		ldi   temp5, 20
		rjmp  cbr_s1
;**********************************************************************************
t_seria_g_off:
		sbr   numb_s, gserstan
		rjmp  mig_g
t_seria_g_on:
		cbr   numb_s, gserstan
		rjmp  mig_g
;**********************************************************************************
t_migawka_m_off:
		sbr   numb_s, mmigstan
		rjmp  mig_m
t_migawka_m_on:
		cbr   numb_s, mmigstan
mig_m:
		rcall por_mm
		ldi   temp5, 12
		rcall cbr_s2
		sbr   numb_s, s2
		rcall por_sm
		ldi   temp5, 22
		rcall cbr_s2
		rcall por_mm
		ldi   temp5, 14
		rcall cbr_s1
		sbr   numb_s, s2
		rcall por_sm
		ldi   temp5, 24
		rjmp  cbr_s1
por_mm:		
		sbr   numb_s, s1
		sbrs  numb_s, mmig_stan
		cbr   numb_s, s1
		mov   min, TIME_2
		ret
;**********************************************************************************
t_seria_m_off:
		sbr   numb_s, mserstan
		rjmp  mig_m
t_seria_m_on:
		cbr   numb_s, mserstan
		rjmp  mig_m
por_sm:
		sbr   numb_s, s1
		sbrs  numb_s, mser_stan
		cbr   numb_s, s1
		mov   min, TIMS_2
		ret
;**********************************************************************************
t_migawka_s_off:
		sbr   numb_s, smigstan
		rjmp  mig_s
t_migawka_s_on:
		cbr   numb_s, smigstan
mig_s:
		rcall por_ms
		ldi   temp5, 16
		rcall cbr_s2
		sbr   numb_s, s2
		rcall por_ss
		ldi   temp5, 26
		rcall cbr_s2
		rcall por_ms
		ldi   temp5, 18
		rcall cbr_s1
		sbr   numb_s, s2
		rcall por_ss
		ldi   temp5, 28
		rjmp  cbr_s1
por_ms:
		sbr   numb_s, s1
		sbrs  numb_s, smig_stan
		cbr   numb_s, s1
		mov   min, TIME_3
		ret
;**********************************************************************************
;**********************************************************************************
t_seria_s_off:
		sbr   numb_s, sserstan
		rjmp  mig_s
t_seria_s_on:
		cbr   numb_s, sserstan
		rjmp  mig_s
por_ss:
		sbr   numb_s, s1
		sbrs  numb_s, sser_stan
		cbr   numb_s, s1
		mov   min, TIMS_3
		ret
;**********************************************************************************

t_seria_c_off:
		sbr   numb_s, s1
t_seria_c_on:
		mov   min, COUNT
		ldi   temp5, 40
		rcall skrot
		ldi   temp5, 42
		rjmp  cbr_s1
;**********************************************************************************
t_wyzw_g_off:
		sbr   numb_s, s1
t_wyzw_g_on:
		mov   min, TIMC_1
		ldi   temp5, 30
		rjmp  cbr_s1
;**********************************************************************************
t_wyzw_m_off:
		sbr   numb_s, s1
t_wyzw_m_on:
		mov   min, TIMC_2
		ldi   temp5, 32
		rcall skrot
		ldi   temp5, 34
		rjmp  cbr_s1
;**********************************************************************************
t_wyzw_s_off:
		sbr   numb_s, s1
t_wyzw_s_on:
		mov   min, TIMC_3
		ldi   temp5, 36
		rcall skrot
		ldi   temp5, 38
cbr_s1:
		rcall wstawka
cbrs:
		rcall wstawka_1
cbr_s12:
		cbr   numb_s, s1 + s2
		ret
cbr_s2:
		rcall wstawka
		swap  temp3
		rjmp  cbrs
;**********************************************************************************
;**********************************************************************************
;**********************************************************************************
wstawka:
		ldi  zl, bufor_adr
		mov  acc_5, temp5
		ldi  temp6, high(dczasy)
		ldi  temp5, low(dczasy)
		add  temp5, acc_5
cd_wstawka:
        ldi   acc_5, 3 	; acc_5 musi byc wieksze o 1 od rzeczywistej ilosci bajtow
		rcall ikony			; pobiera z eeprom do ram dane adresu obrazu i jego pozycji na lcd
		rcall read_poz
		clr   temp6
		mov   temp5, min
czytaj_eeprom:
		rcall start_ep
		ldi ACC_2, 0xA0
		rcall write_ep
		mov ACC_2, temp6
		rcall write_ep
		mov ACC_2, temp5
		rcall write_ep
czytaj_eeprom_current:
		rcall start_ep
		ldi ACC_2, 0xA1
		rcall write_ep
		rcall read_byte
		rcall no_ack
		mov temp3, ACC_2
stop_ep:
		sbi portb, sclk
		rcall small_del
		sbi portb, data
		rcall small_del
end_ep:
		cbi portb, sclk
small_del:
		ret
;**********************************************************************************
wstawka_2:
		ldi   temp6, high(cyfry_d - 18)   ; adres bazowy w eeprom
		ldi   temp5, low(cyfry_d - 18)
		rjmp  obl_adr_cyfr
;**********************************************************************************
skrot:
		rcall wstawka
		swap  temp3
wstawka_1:
		sbrc  numb_s, s_2
		rjmp  wstawka_2
		ldi   temp6, high(cyfry_g - 18)   ; adres bazowy w eeprom
		ldi   temp5, low(cyfry_g -18)
obl_adr_cyfr:
		andi  temp3, 0x0F
		inc   temp3
obl_adr_l_g:					; przesuniecie adresu eeprom o ilosc danych (10) razy acc_5
		adiw  temp5, 18
		dec   temp3
		brne  obl_adr_l_g
wpisz_obraz:
		push    acc_4
		rcall   czytaj_eeprom
		mov     ACC_4 , temp3
		rcall   czytaj_eeprom_current
		sts		ramend - 4, temp3
stu:
		lds	    acc_5, ramend - 4
		rcall	eeprom_to_ram

		cbi     portb, en_lcd

		cbi     portb, dat_com
		mov     ACC_2, ACC_6 ;- zerowanie licznika wierszy
		rcall   write_byte
		mov     ACC_2, ACC_8 ;- zerowanie licznika kolumn 
		rcall   write_byte
		sbi     portb, dat_com

		lds	    acc_5, ramend - 4
		cbr     numb_s, s2
		rcall	ram_to_lcd
		inc     ACC_6			; zwieksz licznik wiersza
		dec     ACC_4
		brne    stu
end_write:
		pop     acc_4
		ret
;********************************************************************************** 

.eseg
.db 0,0,0,0,0,0,0,0,0,0 ; - pierwszy bajt eepromu programuje sie z problemami dlatego zostaje wolny
.db 1,20,10,75,4,0,0,1,30,0
.db 1,15,0,20,1,40,0,0,0,20
.db 0,1,30,5,0,0,30,0,2,0
.db 9,59,59,99,9,59,59,9,59,59
.db 6,0,0,4,0,30,0,1,0,0
.db 0,15,0,10,0,0,20,0,5,0
.db 0,0,15,10,0,0,10,0,0,30
.db 0,0,2,10,0,0,10,0,0,30
.db 0,5,0,6,0,2,0,0,0,20
.db 0,0,30,4,0,0,10,0,0,20
.db 0,0,0,0,0,0,0,0,0,0
