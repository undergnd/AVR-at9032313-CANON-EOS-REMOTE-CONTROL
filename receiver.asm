.include "2313def.inc"

.equ PREAMBULA = $7E
.equ BALANS    = $08 ; WARTOSC PROGOWA 1/0
.equ FOTO_E    = $01 
.equ AF_E      = $02
.equ BULB_E    = $03
.equ OFF_D     = $04
.equ C_ON      = $05
.equ C_OFF     = $06
.equ LED_O     = $07
.equ LED_F     = $08
.equ CZAS_MG   = $01
.equ CZ_SER    = $02
.equ CZAS_ST   = $04
.equ BUFRU     = $01 ;02
.set rmem      = $60
.set smem      = $70

.def  BL1_1  =  R0 
.def  BM1_1  =  R1 
.def  BL2_1  =  R2 
.def  BM2_1  =  R3 
.def  BL3_1  =  R4 
.def  BM3_1  =  R5 
.def  BL4_1  =  R6 
.def  BM4_1  =  R7 
.def  BL5_1  =  R8 
.def  BM5_1  =  R9 
.def  BL6_1  =  R10 
.def  BM6_1  =  R11 

.def  BLS_1  =  R16 
.def  BLS_2  =  R17
.def  BLS_3  =  R18
.def  BLS_4  =  R19
.def  BLS_5  =  R20
.def  BLS_6  =  R21
.def  BLS_7  =  R22
.def  BLS_8  =  R23
.def  BLS_9  =  R24
.def  BLS_10 =  R25
.def  BLS_11 =  R26
.def  BLS_12 =  R27



.def  BUF    =  R12
.def  TC_1   =  R13 ; 
.def  TIM_1  =  R14 ; 
.def  SRG    =  R15


.def  ACC_1  =  R28
.def  FLAGS  =  R29
.def  FRE    =  R30
.def  FREE   =  R31


.equ  OK_FD =  0
.equ  I_HA  =  1
.equ  BIT_F =  2
.equ  B_TX  =  3
.equ  OK_S  =  4
.equ  B_B   =  5
.equ  S_1   =  6
.equ  S_2   =  7
  
.equ  OKV_FD=  1
.equ  I_HAV =  2
.equ  BIT_VF=  4
.equ  BI_TX =  8
.equ  OK_SC =  16
.equ  BB    =  32
.equ  S1    =  64
.equ  S2    =  128

;***********************************************************
.cseg
.org $000

     RJMP RES_1      ;00  
     RJMP INTER      ;01 INT0 
     RETI            ;02 INT1
     RETI            ;03 T1 CAPTURE EVENT
     RJMP T1_MATCH   ;04 T1 CAPTURE MATCH
     RETI            ;05 T1 OVERFLOW
     RJMP TIMER      ;06 T0 OVERFLOW
     RETI            ;07 UART RX COMPLETE
     RETI            ;08 UART DATA REGISTER EMPTY
     RETI            ;09 UART TX COMPLETE
     RETI            ;0A ANALOG COMPARATOR
;**********************************************************

TIMER:  
     PUSH SRG
     PUSH BUF
     IN   SRG   , SREG
;* * * * * * * * * * * * *
     IN   BUF   , TCNT0
     CPSE BUF   , TIM_1
     RJMP KKK 
KKK:
     OUT  TCNT0 , TC_1
;* * * * * * * * * * * * *   
     SBRC FLAGS , I_HA
     RJMP ODBIORNIK
     sbic portd , 4
     rjmp bez_prz
RELOR:
     IN   BUF , PIND
     ROR  BUF
     ROR  BUF
;* * * *
     BRCC B_1_INC
     INC  BLS_1
B_1_INC:
     ROR  BL1_1
;* * * *
     BRCC B_2_INC
     INC  BLS_2
     DEC  BLS_1
B_2_INC:
     ROR  BM1_1
;* * * *
     BRCC B_3_INC
     INC  BLS_3
     DEC  BLS_2
B_3_INC:
     ROR  BL2_1
;* * * *
     BRCC B_4_INC
     INC  BLS_4
     DEC  BLS_3
B_4_INC:
     ROR  BM2_1
;* * * *
     BRCC B_5_INC
     INC  BLS_5
     DEC  BLS_4
B_5_INC:
     ROR  BL3_1
;* * * *
     BRCC B_6_INC
     INC  BLS_6
     DEC  BLS_5
B_6_INC:
     ROR  BM3_1
;* * * *
     BRCC B_7_INC
     INC  BLS_7
     DEC  BLS_6
B_7_INC:
     ROR  BL4_1
;* * * *
     BRCC B_8_INC
     INC  BLS_8
     DEC  BLS_7
B_8_INC:
     ROR  BM4_1
;* * * *
     BRCC B_9_INC
     INC  BLS_9
     DEC  BLS_8
B_9_INC:
     ROR  BL5_1
;* * * *
     BRCC B_10_INC
     INC  BLS_10
     DEC  BLS_9
B_10_INC:
     ROR  BM5_1
;* * * *
     BRCC B_11_INC
     INC  BLS_11
     DEC  BLS_10
B_11_INC:
     ROR  BL6_1
;* * * *
     BRCC B_12_INC
     INC  BLS_12
     DEC  BLS_11
B_12_INC:
     ROR  BM6_1
     BRCC SKIP_DEC_BLS_8
     DEC  BLS_12


;* * * *
SKIP_DEC_BLS_8:
     CPI  BLS_1 , 3 ;2
     BRSH STO
     CPI  BLS_2 , 3 ;2
     BRSH STO
     CPI  BLS_3 , 6 ;7
     BRLO STO
     CPI  BLS_4 , 6 ;7
     BRLO STO
     CPI  BLS_5 , 3
     BRSH STO
     CPI  BLS_6 , 3
     BRSH STO
     CPI  BLS_7 , 6
     BRLO STO
     CPI  BLS_8 , 6
     BRLO STO
     CPI  BLS_9 , 3
     BRSH STO
     CPI  BLS_10, 3
     BRSH STO
     CPI  BLS_11, 6
     BRLO STO
     CPI  BLS_12, 6
     BRLO STO
     SBR  FLAGS , I_HAV
STO:
;* * * * * * * * * * * * * * * * * *
     SBRS FLAGS , I_HA
     RJMP BEZ_PRZ
     CLC  
  
     LDI  BLS_3 , 8
 
     CLR  BLS_1
     CLR  BLS_2
     CLR  BL1_1
     CLR  BM1_1
     CLR  BLS_8
     CBR  FLAGS , BB
     RJMP BEZ_PRZ
;********************************
;    ODBIORNIK
;********************************
ODBIORNIK:
     CLC
     SBIS PIND   , 1
     RJMP B_CZ1_INC
     SEC
     INC  BLS_1

B_CZ1_INC:
     ROR  BL1_1 
     BRCC B_CZ2_INC
     INC  BLS_2
     DEC  BLS_1

B_CZ2_INC:
     ROR  BM1_1
     BRCC B_END
     DEC  BLS_2
B_END:
;****************************
     DEC  BLS_3
     BRNE BEZ_PRZ
     LDI  BLS_3 , $08
     

 
     SBRS FLAGS , B_B
     RJMP SET_BEZ_PRZ
     CBR  FLAGS , BB

     SBR  FLAGS , BIT_VF
         
;* * * * 
     CPI  BLS_1 , $05
     BRLO ZER_S1
     SBR  FLAGS , S1
     RJMP PS_2
ZER_S1:
     CBR  FLAGS , S1
;* * * * 
PS_2:
     CPI  BLS_2 , $05
     BRLO ZER_S2
     SBR  FLAGS , S2
     RJMP SUM
ZER_S2:
     CBR  FLAGS , S2
SUM: 
     MOV  BLS_7 , FLAGS
     ROL  BLS_7
     EOR  BLS_7 , FLAGS

     SBR  FLAGS , BI_TX
     SBRS BLS_7 , 7
     CBR  FLAGS , BI_TX    
     
     RJMP BEZ_PRZ
      
SET_BEZ_PRZ:
     SBR  FLAGS , BB
BEZ_PRZ:
     OUT  SREG  , SRG
     POP  BUF
     POP  SRG
     RETI

;********************************************************************************
T1_MATCH:
         SBR    FLAGS  , OK_SC
; * * * *

; * * * *
         RETI
;********************************************************************************
inter:
         sbi   portd , 5
         cli
         RETI 
;********************************************************************************
res_1:
        
        
         LDI   ACC_1 , RAMEND
         OUT   SPL   , ACC_1
         
         cli
         
        
         rcall STOP_INTER_0
         rcall sleep_pd_off

;//////////////////////////////////////////////////////
dalll:
         sbis  portd , 5
         rjmp  reset
         cbi   portd , 5
         sei
         rcall led_on
pusc:         
         sbis  pind  , 2
         rjmp  pusc    
         RCALL SLEEP_ID_ON
         RCALL TIMER_1
         SLEEP
         RCALL SLEEP_ID_OFF
         RCALL STOP_TIMER_1
         rcall led_off
         cli

RESET:
        CLR   BUF  
;*******************************
        LDI   ACC_1 , RAMEND
        OUT   SPL   , ACC_1

        RCALL WD_RESET
        RCALL SLEEP_PD_OFF
        CLR   FLAGS
       

LOOP:
        RCALL I_OES
        RCALL TIMER_200MS
        RCALL CLRS
        RCALL CLEAR_PRG
        RCALL T0_EXTER
        RCALL SLEEP_ID_ON
        rcall inter_0
        SEI

KONIEC:
        SLEEP
        sbic  portd , 5
        rjmp  on_off
        SBRC  FLAGS , I_HA
        RJMP  REC_TRY
        SBRC  FLAGS , OK_S
        RJMP  WD_SET
        RJMP  KONIEC
REC_TRY:
        RCALL STOP_TIMER_1
        RCALL SLEEP_ID_OFF 
        RCALL RECEIVER
        RCALL T0_STOP
        
        SBRS  FLAGS  , OK_FD
        RJMP  SPR_PROG
        RCALL RX_OFF
;************************************************************
;sprawdzenie czy transmisja wlacz/wylacz szybka reakcje        
        LDI   FRE   , $85     ; SET "Z" LOW BYTE
        CLR   FREE            ; SET "Z" HIGH BYTE
        cpi   BLS_9  , C_ON
        BRNE  C_OFFF
        LDI   ACC_1 , $22
        RJMP  SET_C
C_OFFF:
        cpi   BLS_9  , C_OFF
        BRNE  IS_LCD
        LDI   ACC_1 , $33
SET_C:        
        CLR   BLS_9
        st    Z     , ACC_1
        RCALL TRZY_MIG
        RJMP  RESET
;************************************************************
;sprawdzenie czy transmisja wlacz/wylacz sygnalizacje
IS_LCD:
        LDI   FRE   , $89     ; SET "Z" LOW BYTE
        CLR   FREE            ; SET "Z" HIGH BYTE

        cpi   BLS_9  , LED_O
        BRNE  LCD_OFFF
        LDI   ACC_1 , $22
        RJMP  LOAD_LCD
LCD_OFFF:
        cpi   BLS_9  , LED_F
        BRNE  NXT_AF_FOTO       
        LDI   ACC_1 , $33
LOAD_LCD:
        CLR   BLS_9
        st    Z     , ACC_1
        RJMP  RESET       
;************************************************************          
        
NXT_AF_FOTO:        
        RCALL START_ACTION
        RCALL OP
        RCALL STOP_ACTION
        RCALL TIMER_100MS
        RCALL SLEEP_ID_ON   
        SLEEP
        RCALL STOP_TIMER_1
        RCALL SLEEP_ID_OFF   
        RJMP  LOOP
        
SPR_PROG:
        RCALL COPY_ST
        CLR   BUF                
        CLR   ACC_1
        LDI   BLS_4 , $03
        LDI   FRE   , rmem ;60
        CLR   FREE  
        RCALL PYTAJ
        CPI   ACC_1 , $00
        BREQ  CZY_SERIA
        LDI   ACC_1 , CZAS_MG 
        MOV   BUF   , ACC_1
                                  ;CZAS_MG   = $01
                                  ;CZ_SER    = $02
                                  ;CZAS_ST   = $04
CZY_SERIA:
        CLR   ACC_1
        LDI   BLS_4 , $04
        LDI   FRE   , rmem+3 ;63
        CLR   FREE  
        RCALL PYTAJ
        CPI   ACC_1 , $00
        BREQ  CZY_START
        LDI   ACC_1 , CZ_SER
        OR    BUF   , ACC_1
        
CZY_START:
        CLR   ACC_1
        LDI   BLS_4 , $03
        LDI   FRE   , rmem+7 ;67
        CLR   FREE  
        RCALL PYTAJ
        CPI   ACC_1 , $00
        BREQ  END_P
        LDI   ACC_1 , CZAS_ST
        OR    BUF   , ACC_1
END_P:
        MOV   ACC_1 , BUF
        CPI   ACC_1 , $00
        BRNE  WYKONAJ_PROGRAM
TO_LOOP:        
        RJMP  RESET
;***************************************************
PYTAJ:
        LD    BLS_8 , Z+
        OR    ACC_1 , BLS_8
        DEC   BLS_4
        BRNE  PYTAJ
        RET
;******************************************************************
TRZY_MIG:
		RCALL LED_ON
        RCALL TIMER_200MS
        RCALL SLEEP_ID_ON   
        SLEEP
        RCALL STOP_TIMER_1
        RCALL SLEEP_ID_OFF   
        RCALL LED_OFF
        RCALL TIMER_200MS
        RCALL SLEEP_ID_ON   
        SLEEP
        RCALL STOP_TIMER_1
        RCALL SLEEP_ID_OFF   
        RCALL LED_ON
        RCALL TIMER_200MS
        RCALL SLEEP_ID_ON   
        SLEEP
        RCALL STOP_TIMER_1
        RCALL SLEEP_ID_OFF   
        RCALL LED_OFF
        RCALL TIMER_200MS
        RCALL SLEEP_ID_ON   
        SLEEP
        RCALL STOP_TIMER_1
        RCALL SLEEP_ID_OFF   
        RCALL LED_ON
        RCALL TIMER_200MS
        RCALL SLEEP_ID_ON   
        SLEEP
        RCALL STOP_TIMER_1
        RCALL SLEEP_ID_OFF   
        RCALL LED_OFF
        RCALL TIMER_1
        RCALL SLEEP_ID_ON   
        SLEEP
        RCALL STOP_TIMER_1
        RCALL SLEEP_ID_OFF   
                
        RET
;******************************************************************
WYKONAJ_PROGRAM:             ; MAM: BUF, SRG, ACC_1, FRE, FREE, 
        sbi    portd , 4 ; zatrzymuje na 1 sekunde odbiornik
        RCALL  CLRS
        RCALL  TIMER_25MS     ; TIMER_1********************
        SBRS   BUF  , 2
        RJMP   MIG_STAR
        
        LDI    FRE  , rmem+7 ;67
        CLR    FREE
        RCALL  TIME_OP
MIG_STAR:
        SBRC   BUF  , 1
        RJMP   CZAS_SERIA
        SBRC   BUF  , 0
        RJMP   MIGAWKA

        RCALL  FOTO
        rcall  op
        rcall  op
        rcall  op

        RJMP   RESET
;*************************************
;*************************************
MIGAWKA:
        RCALL  CZAS_MIGA
        rcall  op
        rcall  op
        rcall  op

        RJMP   RESET
;*************************************
CZAS_MIGA:
        RCALL  OTWORZ_MIG
        LDI    FRE  , rmem ;60
        CLR    FREE
        RCALL  TIME_OP
        RCALL  ZAMKNIJ_MIG        
        RET
;*************************************       
CZAS_SERIA:        
        SBRS   BUF  , 0
        RJMP   SERIA_FOTO
        RJMP   SERIA_CZ_M
SERIA_FOTO:
        RCALL  T0_STOP
        RCALL  OTWORZ_MIG
        RCALL  SLEEP_ID_ON
        SLEEP
        RCALL  SLEEP_ID_OFF
        RCALL  ZAMKNIJ_MIG
        RCALL  T0_EXTER
        RJMP   SERIA_T   
SERIA_CZ_M:
        RCALL  CZAS_MIGA       
        RJMP   SERIA_T

SERIA_T:
        LDI    FRE   , rmem+3 ;63
        CLR    FREE
        LD     ACC_1 , Z
        DEC    ACC_1
        ST     Z     , ACC_1
        CPI    ACC_1 , $00
        BREQ   END_PROO
        cpi    acc_1, 255
        breq   end_proo
        LDI    FRE  , rmem+4 ;64
        CLR    FREE
        RCALL  TIME_OP
        RJMP   CZAS_SERIA
END_PROO:
        rcall  op
        rcall  op
        rcall  op

        RJMP   RESET
        




;***************************************************
;***************************************************
;***************************************************
;***************************************************
;***************************************************
;***************************************************
;***************************************************
;***************************************************
;***************************************************
;***************************************************
;***************************************************
;***************************************************
;***************************************************



;***************************************************
RECEIVER:
        LDI   BLS_12 , $30
        CLR   BLS_8
        LDI   BLS_6  , $7E
        CBR   FLAGS  , OKV_FD
        RCALL SLEEP_ID_ON
        
STOP:
        SLEEP
        SBRS  FLAGS  , BIT_F
        RJMP  STOP
        CBR   FLAGS  , BIT_VF
        BST   FLAGS  , B_TX
        ROL   BLS_8        
        BLD   BLS_8  , 0
        CP    BLS_8  , BLS_6
        BREQ  DETECT
        DEC   BLS_12
        BRNE  STOP
        RCALL SLEEP_ID_OFF
        RET

DETECT: ;73,0F,33,99,66,CC,77
        RCALL SLEEP_ID_OFF
        
        RCALL READ
        CPI   BLS_8  , $00 ;adres1
        BRNE  NO_OK
        
        RCALL READ
        CPI   BLS_8  , $00 ; adres2
        BRNE  NO_OK 

                
        RCALL READ
                
        CPI   BLS_8  , $73
        BRNE  NEXT 
        LDI   BLS_9  , OFF_D
        RJMP  NEXT_BYTE
NEXT:
        CPI   BLS_8  , $0F
        BRNE  NEXT_0 
        LDI   BLS_9  , AF_E
        RJMP  NEXT_BYTE
NEXT_0:
        CPI   BLS_8  , $33
        BRNE  NEXT_1 
        LDI   BLS_9  , FOTO_E
        RJMP  NEXT_BYTE
NEXT_1:
        CPI   BLS_8  , $77
        BRNE  NEXT_2 
        LDI   BLS_9  , C_ON
        RJMP  NEXT_BYTE
NEXT_2:
        CPI   BLS_8  , $22
        BRNE  NEXT_3 
        LDI   BLS_9  , C_OFF
        RJMP  NEXT_BYTE     
NEXT_3:
        CPI   BLS_8  , $66
        BRNE  NEXT_4 
        LDI   BLS_9  , LED_O
        RJMP  NEXT_BYTE
NEXT_4:
        CPI   BLS_8  , $CC
        BRNE  NEXT_5 
        LDI   BLS_9  , LED_F
        RJMP  NEXT_BYTE      
NEXT_5:
        CPI   BLS_8  , $99
        BRNE  NO_OK 
        RJMP  REC_PROGRAM

NEXT_BYTE:
        LDI   BLS_6  , $F0
        RCALL READ        
        SBRS  FLAGS  , OK_FD
        RJMP  NO_OK 
        LDI   BLS_6  , $55
        RCALL READ        
        SBRS  FLAGS  , OK_FD
        RJMP  NO_OK 
        LDI   BLS_6  , $05
        RCALL READ        
        SBRS  FLAGS  , OK_FD
        RJMP  NO_OK 
        LDI   BLS_6  , $05
        RCALL READ        
        SBRS  FLAGS  , OK_FD
        RJMP  NO_OK 
        LDI   BLS_6  , $05
        RCALL READ        
        SBRS  FLAGS  , OK_FD
        RJMP  NO_OK 

        SBR   FLAGS  , OKV_FD
        
;********************************							; TEST        
;********************************							; TEST        
        RET
NO_OK:
        CBR   FLAGS  , OKV_FD
        RET        
;***************************
REC_PROGRAM:
        LDI   BLS_4 , $0A
        LDI   ACC_1 , $99
        LDI   FRE   , smem ;70     ; SET "Z" LOW BYTE
        CLR   FREE                 ; SET "Z" HIGH BYTE
READ_PROG:
        RCALL READ
        ST    Z+    , BLS_8
        EOR   ACC_1 , BLS_8
        DEC   BLS_4
        BRNE  READ_PROG
        RCALL READ
        CP    ACC_1 , BLS_8
        breq  kont
        rjmp  reset
kont:
        CBR   FLAGS  , OKV_FD
;********************************							; TEST        
;********************************							; TEST        
        RET   

;******************************************
COPY_ST:
        LDI   BLS_4 , $0A        
        LDI   FRE   , rmem ;60     ; SET "Z" LOW BYTE
        CLR   FREE                  ; SET "Z" HIGH BYTE
        LDI   BLS_11, smem ;70     ; SET "X" LOW BYTE
        CLR   BLS_12                ; SET "X" HIGH BYTE
COP:
        LD    ACC_1 , X+
        ST    Z+    , ACC_1
        DEC   BLS_4 
        BRNE  COP
        
        RET   
;****************************        




;****************************       
READ:
        LDI   BLS_12 , 8
        CLR   BLS_8
        RCALL SLEEP_ID_ON
READ_B:
        SLEEP
        SBRS  FLAGS  , BIT_F
        RJMP  READ_B
        CBR   FLAGS  , BIT_VF

        BST   FLAGS  , B_TX
        ROL   BLS_8        
        BLD   BLS_8  , 0
        DEC   BLS_12
        BRNE  READ_B
        RCALL SLEEP_ID_OFF
        CP    BLS_8  , BLS_6
        BRNE  END_SIG
        SBR   FLAGS  , OKV_FD
        RET
END_SIG:
        CBR   FLAGS  , OKV_FD
        RET        

;***************************        
OP:
        RCALL SLEEP_ID_ON
        RCALL TIMER_150MS
        SLEEP
        SLEEP
        SLEEP
        SLEEP
        RCALL SLEEP_ID_OFF
        RCALL STOP_TIMER_1
        RET
;***************************
STOP_ACTION:
        CBI   DDRB  , 2
        CBI   PORTB , 2
        CBI   DDRB  , 3
        CBI   PORTB , 3
        RET
;***************************
START_ACTION:
        CPI   BLS_9 , $01
        BREQ  FOTO              ; FOTO KONCZY "RET"
        CPI   BLS_9 , $02
        BREQ  AF                ; AF KONCZY "RET"
        CPI   BLS_9 , $04       
        RJMP  ON_OFF            ; WYLACZ ODBIORNIK
        RET
;***************************
FOTO:
        SBI   DDRB  , 3
        CBI   PORTB , 3
;***
         rcall  led_on
;***
        RCALL OP
        RCALL OP
;***
         rcall led_off
;***
        SBI   DDRB  , 2
        CBI   PORTB , 2
        RCALL OP
        RCALL STOP_ACTION       
        RET
;***************
AF:
        SBI   DDRB  , 3
        CBI   PORTB , 3
        LDI   BLS_5 , $5   ; CZAS NA AF = OK 3 SEC.
SEC_U:
;***
         rcall  led_on
;***
        RCALL OP
        DEC   BLS_5        
        BRNE  SEC_U
;***
         rcall  led_off
;***
        RCALL STOP_ACTION
        RET
;***************

T0_EXTER:      ;USTAWIENIE TIMERA T0
        PUSH ACC_1
        CLC
        LDI  ACC_1 , 125
        MOV  TIM_1 , ACC_1
        COM  TIM_1
        MOV  TC_1   , TIM_1
        LDI  ACC_1 , $0C
        MOV  TIM_1 , ACC_1 

USTAW_TIMER:
        LDI  ACC_1 , $01
        OUT  TCCR0 , ACC_1
        OUT  TCNT0 , TC_1
        IN   ACC_1 , TIMSK
        ORI  ACC_1 , $02
        OUT  TIMSK , ACC_1
        CLR  ACC_1
        CLR  FLAGS
        POP  ACC_1
        RET
;*******************************************
T0_STOP:
        PUSH ACC_1
        CLR  ACC_1 
        OUT  TCCR0 , ACC_1
        POP  ACC_1
        RET        
;*******************************************
CLRS:    
        SER  ACC_1  
        MOV BL1_1 , ACC_1
        MOV BM1_1 , ACC_1
        MOV BL2_1 , ACC_1
        MOV BM2_1 , ACC_1
        MOV BL3_1 , ACC_1
        MOV BM3_1 , ACC_1
        MOV BL4_1 , ACC_1
        MOV BM4_1 , ACC_1
        MOV BL5_1 , ACC_1
        MOV BM5_1 , ACC_1
        MOV BL6_1 , ACC_1
        MOV BM6_1 , ACC_1
         
        
        CLR ACC_1

        LDI   BLS_1 , $8   
        LDI   BLS_2 , $8  
        LDI   BLS_3 , $8  
        LDI   BLS_4 , $8  
        LDI   BLS_5 , $8  
        LDI   BLS_6 , $8  
        LDI   BLS_7 , $8  
        LDI   BLS_8 , $8
        LDI   BLS_9 , $8  
        LDI   BLS_10, $8  
        LDI   BLS_11, $8  
        LDI   BLS_12, $8
        CLR   FLAGS
        RET
;******************************************
I_OES:

        CBI  DDRD  , $1
        CBI  PORTD , $1

        CBI  DDRB  , 2
        CBI  PORTB , 2
        CBI  DDRB  , 3
        CBI  PORTB , 3
        cbi  portd , 5
        SBI  DDRB  , 6
        SBI  PORTB , 6
        SBI  DDRB  , 7
        SBI  PORTB , 7
        RET
;*******       ********        *********       ***********
CLEAR_PRG:
        LDI   BLS_4 , $0F
        CLR   BLS_8
        LDI   FRE   , rmem ;60     ; SET "Z" LOW BYTE
        CLR   FREE                 ; SET "Z" HIGH BYTE
CLR_PROG:         
        ST    Z+    , BLS_8
        DEC   BLS_4
        BRNE  CLR_PROG
        
        LDI   BLS_4 , $0F
        CLR   BLS_8
        LDI   FRE   , smem ;70     ; SET "Z" LOW BYTE
        CLR   FREE                 ; SET "Z" HIGH BYTE
CLER_PROG:        
        ST    Z+    , BLS_8
        DEC   BLS_4
        BRNE  CLER_PROG
        RET
;**************************************************************
TIMER_1:
;1 SEKUNDA     
         PUSH ACC_1
         LDI  ACC_1  , $0E ;07       
         OUT  OCR1AH , ACC_1      ; SET MATCH REGISTER H
         LDI  ACC_1  , $10 ;08 
         OUT  OCR1AL , ACC_1      ; SET MATCH REGISTER L
         RJMP SET_T1
TIMER_25MS:
;25 MS
         PUSH ACC_1
         LDI  ACC_1  , $00        
         OUT  OCR1AH , ACC_1      ; SET MATCH REGISTER H
         LDI  ACC_1  , $5A  
         OUT  OCR1AL , ACC_1      ; SET MATCH REGISTER L
         RJMP SET_T1
TIMER_100MS:
;100 MS
         PUSH ACC_1
         LDI  ACC_1  , $01        
         OUT  OCR1AH , ACC_1      ; SET MATCH REGISTER H
         LDI  ACC_1  , $68  
         OUT  OCR1AL , ACC_1      ; SET MATCH REGISTER L
         RJMP SET_T1
TIMER_150MS:         
         PUSH ACC_1
         LDI  ACC_1  , $02        
         OUT  OCR1AH , ACC_1      ; SET MATCH REGISTER H
         LDI  ACC_1  , $1C  
         OUT  OCR1AL , ACC_1      ; SET MATCH REGISTER L
         RJMP SET_T1
TIMER_200MS:         
         PUSH ACC_1
         LDI  ACC_1  , $02        
         OUT  OCR1AH , ACC_1      ; SET MATCH REGISTER H
         LDI  ACC_1  , $D0  
         OUT  OCR1AL , ACC_1      ; SET MATCH REGISTER L
         RJMP SET_T1
SET_T1:
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
         POP  ACC_1
         RET
;**************************************************************
;**************************************************************
STOP_TIMER_1:
         PUSH ACC_1
         IN   ACC_1  , TIFR
         ORI  ACC_1  , 0B01000000
         OUT  TIFR   , ACC_1      ; WYZERUJ FLAG  COMPARE MATCH

         CLR  ACC_1
         OUT  TCCR1B , ACC_1
         POP  ACC_1               
         RET         
;**************************************************************
TIME_OP:
         CBR   FLAGS  , I_HAV
         MOV   SRG    , FRE
         LD    ACC_1  , Z
         CPI   ACC_1  , $00
         BREQ  OP_MIN
         RCALL OP_G
OP_MIN:
         MOV   FRE    , SRG
         INC   FRE
         MOV   SRG    , FRE
         CLR   FREE                  
         LD    ACC_1  , Z
         CPI   ACC_1  , $00
         BREQ  OP_SEC
         RCALL OP_M   
OP_SEC:                  
         MOV   FRE    , SRG
         INC   FRE
         CLR   FREE                  
         LD    ACC_1  , Z
         CPI   ACC_1  , $00
         BREQ  END_OP
         RCALL OP_S   
END_OP:
         RET         
;******************************
OP_G:
         LDI   FREE   , 60
         LDI   FRE    , 60
OPG:         
         RCALL SEKUND
         DEC   FREE
         BRNE  OPG
         LDI   FREE   , 60
         DEC   FRE
         BRNE  OPG
         LDI   FRE    , 60
         DEC   ACC_1
         BRNE  OPG
         RET
;******************************
OP_M:
         LDI   FRE    , 60
OPM:         
         RCALL SEKUND
         DEC   FRE
         BRNE  OPM
         LDI   FRE    , 60
         DEC   ACC_1
         BRNE  OPM
         RET
;*******************************
OP_S:
         RCALL SEKUND
         DEC   ACC_1
         BRNE  OP_S
         RET
;*******************************
SEKUND:
         push  acc_1
         LDI   ACC_1  , $00        
         OUT   OCR1AH , ACC_1      ; SET MATCH REGISTER H
         LDI   ACC_1  , $5A  
         OUT   OCR1AL , ACC_1      ; SET MATCH REGISTER L
         
         ldi   acc_1 , 7
;***
         RCALL SLEEP_ID_ON
         rcall led_on
;***
SEK_25:
         sleep
         rcall  led_off
         dec   acc_1
         brne  SEK_25

         sbis  ddrb  , 3
         rjmp  end_25
         rcall led_on
end_25:              
         sleep
         rcall  led_off
         pop   acc_1
         RCALL SLEEP_ID_OFF

         PUSH  ACC_1
         
         LDI   ACC_1  , $02        
         OUT   OCR1AH , ACC_1      ; SET MATCH REGISTER H
         LDI   ACC_1  , $D0  
         OUT   OCR1AL , ACC_1      ; SET MATCH REGISTER L
         
         LDI   ACC_1  , $04
         RCALL SLEEP_ID_ON
         RCALL T0_EXTER
         RCALL RX_ON
         rcall inter_0         
SEKK:    
         sbic  portd  , 5
         rjmp  on_off
         SBRS  FLAGS  , I_HA
         RJMP  SEKU
         RCALL SLEEP_ID_OFF
         CBR   FLAGS  , OKV_FD
         PUSH  FRE
         PUSH  FREE
         PUSH  ACC_1
         
         RCALL RECEIVER
         SBRS  FLAGS  , OK_FD
         RJMP  SEKI
;************************************************************
;sprawdzenie czy transmisja wlacz/wylacz sygnalizacje
IS_LCDA:
        LDI   FRE   , $89     ; SET "Z" LOW BYTE
        CLR   FREE            ; SET "Z" HIGH BYTE

        cpi   BLS_9  , LED_O
        BRNE  LCD_OFFFA
        LDI   ACC_1 , $22
        RJMP  LOAD
LCD_OFFFA:
        cpi   BLS_9  , LED_F
        BRNE  IS_OF
        LDI   ACC_1 , $33
LOAD:
        CLR   BLS_9
        st    Z     , ACC_1
        RJMP  SEKI       
;************************************************************        
IS_OF:
         cpi   BLS_9  , AF_E
         BRNE  SEKI
         POP   ACC_1
         POP   FREE
         POP   FRE
         CLI
         RCALL T0_STOP
         RCALL RX_OFF         
         RCALL STOP_TIMER_1
;***     
         RCALL  SLEEP_ID_OFF
         RCALL  TIMER_1
         SEI    
         RCALL SLEEP_ID_ON
         SLEEP
         SLEEP
         RCALL SLEEP_ID_OFF
         CLI         
;***
         RCALL STOP_TIMER_1
         RCALL ZAMKNIJ_MIG
         RJMP  RESET
SEKI:
         CLI
         RCALL T0_STOP
         RCALL CLRS
         CBR   FLAGS  , I_HAV
         RCALL T0_EXTER
         POP   ACC_1
         POP   FREE
         POP   FRE
         SEI
SEKU:
         SLEEP
         SBRS  FLAGS  , OK_S
         RJMP  SEKK
         CBR   FLAGS  , OK_SC
         RCALL T0_STOP
         RCALL RX_OFF
         DEC   ACC_1
         BREQ  NEXT_END
         RJMP  SEKK
NEXT_END:
         RCALL SLEEP_ID_OFF
         POP   ACC_1
         cbi   portd  , 4
         RET
;*******************************
OTWORZ_MIG:
;***
        rcall  led_on
;***
        SBI   DDRB  , 3         
        CBI   PORTB , 3
        SBI   DDRB  , 2
        CBI   PORTB , 2
        RET
;*******************************
ZAMKNIJ_MIG:
;***
        rcall  led_off
;***
        CBI   DDRB  , 3
        CBI   PORTB , 3
        CBI   DDRB  , 2
        CBI   PORTB , 2
        RET
;*******************************
;**************************************************************
SLEEP_ID_ON:
         PUSH ACC_1
         IN   ACC_1  , MCUCR
         ORI  ACC_1  , 0B00100000
         OUT  MCUCR  , ACC_1 
         POP  ACC_1
         RET
;**************************************************************
SLEEP_ID_OFF:
         PUSH ACC_1
         IN   ACC_1  , MCUCR
         ANDI ACC_1  , 0B11011111
         OUT  MCUCR  , ACC_1
         POP  ACC_1 
         RET
;**************************************************************
;**************************************************************
SLEEP_PD_ON:
         PUSH ACC_1
         IN   ACC_1  , MCUCR
         ORI  ACC_1  , 0B00110000
         OUT  MCUCR  , ACC_1
         POP  ACC_1 
         RET
;**************************************************************
SLEEP_PD_OFF:
         PUSH ACC_1
         IN   ACC_1  , MCUCR
         ANDI ACC_1  , 0B11001111
         OUT  MCUCR  , ACC_1
         POP  ACC_1 
         RET
;**************************************************************

WD_SET:
         LDI   FRE   , $85     ; SET "Z" LOW BYTE
         CLR   FREE            ; SET "Z" HIGH BYTE
         LD    ACC_1 , Z
         cpi   acc_1 , $22
         brne  nxt
         ;//////////////////////////////////
         LDI   FRE   , $87     ; SET "Z" LOW BYTE
         CLR   FREE            ; SET "Z" HIGH BYTE
         ld    acc_1 , z
         cpi   acc_1 , 25
         brlo  no_light
         clr   acc_1
         st    Z     , ACC_1
         rcall led_on
         rjmp  reset
no_light:
         inc   acc_1
         st    z     , acc_1                
	  	 rcall led_off        
         ;///////////////////////////////////
         rjmp  reset
nxt:
         CLI
;////////////////////////////////////////////////////////////        
         RCALL T0_STOP
         LDI   FRE   , $9A     ; SET "Z" LOW BYTE
         CLR   FREE            ; SET "Z" HIGH BYTE
         LD    ACC_1 , Z
         inc   acc_1
         st    z     , acc_1
         cpi   acc_1 , $05
         brlo  noact
         ldi   acc_1 , $0
         st    z     , acc_1
         rcall led_on
         SBI   DDRB  , 6
         SBI   DDRB  , 7
         CBI   PORTB , 6
         CBI   PORTB , 7
         CLR   ACC_1
         RCALL SLEEP_PD_ON
         rcall rx_off
         LDI   ACC_1 , 0B00011000
         OUT   WDTCR , ACC_1
         SLEEP
;////////////////////////////////////////////////////////////
noact:
         SBI   DDRB  , 6
         SBI   DDRB  , 7
         CBI   PORTB , 6
         CBI   PORTB , 7
         CLR   ACC_1
         RCALL SLEEP_PD_ON
         rcall rx_off
         LDI   ACC_1 , 0B00011100
         OUT   WDTCR , ACC_1
         SLEEP
         
;**************************************************************
WD_RESET:
         LDI   ACC_1 , 0B00011100
         OUT   WDTCR , ACC_1
         LDI   ACC_1 , 0B00010100
         OUT   WDTCR , ACC_1
         RET         
;**************************************************************
RX_OFF:
         SBI   DDRB  , 6
         SBI   DDRB  , 7
         CBI   PORTB , 6
         CBI   PORTB , 7
         RET
;**************************************************************
RX_ON:
         SBI   DDRB  , 6
         SBI   DDRB  , 7
         SBI   PORTB , 6
         SBI   PORTB , 7
         RET
;**************************************************************
INTER_0:
         push acc_1
         sbi  DDRD  , 2
         sbi  PORTD , 2
         IN   ACC_1  , MCUCR
         ANDI ACC_1  , 0B11111100  ; POZIOM LOW
         OUT  MCUCR  , ACC_1 
         IN   ACC_1  , GIFR
         ORI  ACC_1  , 0B01000000
         OUT  GIFR   , ACC_1 
         IN   ACC_1  , GIMSK
         ORI  ACC_1  , 0B01000000
         OUT  GIMSK  , ACC_1
         pop  acc_1 
         RET
;**************************************************************
INTER_0_1_0:
         push acc_1
         sbi  DDRD  , 2
         sbi  PORTD , 2
         IN   ACC_1  , MCUCR
         ORI  ACC_1  , 0B00000010  ; ZBOCZE OPADAJACE
         OUT  MCUCR  , ACC_1 
         IN   ACC_1  , GIFR
         ORI  ACC_1  , 0B01000000
         OUT  GIFR   , ACC_1 
         IN   ACC_1  , GIMSK
         ORI  ACC_1  , 0B01000000
         OUT  GIMSK  , ACC_1
         pop  acc_1 
         RET
;**************************************************************
;**************************************************************
STOP_INTER_0:
         push acc_1
         IN   ACC_1  , GIMSK
         ANDI ACC_1  , 0B10111111
         OUT  GIMSK  , ACC_1 
         IN   ACC_1  , GIFR
         ORI  ACC_1  , 0B01000000
         OUT  GIFR   , ACC_1
         pop  acc_1 
         RET
;**************************************************************
LED_ON:
         push  acc_1
         push  free
         push  fre
         LDI   FRE   , $89     ; SET "Z" LOW BYTE
         CLR   FREE            ; SET "Z" HIGH BYTE
         LD    ACC_1 , Z
         cpi   acc_1 , $33  ; czy off?
         brne  next_led          
         pop   fre
         pop   free
         pop   acc_1
         ret
next_led:
         LDI   FRE   , $85     ; SET "Z" LOW BYTE
         CLR   FREE            ; SET "Z" HIGH BYTE
         LD    ACC_1 , Z
         cpi   acc_1 , $22  ; czy on?
         brne  zielona
czerwona:
         sbi   ddrb  , 0
         sbi   portb , 0
         sbi   ddrd  , 6
         cbi   portd , 6
         pop   fre
         pop   free
         pop   acc_1
         ret
zielona:
         sbi   ddrd  , 6
         sbi   portd , 6
         sbi   ddrb  , 0
         cbi   portb , 0
         pop   fre
         pop   free
         pop   acc_1
         RET

LED_OFF:
         cbi   portd , 6
         cbi   ddrd  , 6
         cbi   portb , 0
         cbi   ddrb  , 0 
         RET
;/////////////////////////////////////////////
on_off:
         cli
         rcall ZAMKNIJ_MIG
         rcall stop_inter_0
         sei
         rcall t0_stop   
         RCALL LED_ON
         RCALL SLEEP_ID_ON
         RCALL TIMER_1
         SLEEP
         RCALL SLEEP_ID_OFF
         RCALL STOP_TIMER_1
         RCALL LED_OFF
         RCALL SLEEP_ID_ON
         RCALL TIMER_1
         SLEEP
         RCALL SLEEP_ID_OFF
         RCALL STOP_TIMER_1
         RCALL LED_ON
         RCALL SLEEP_ID_ON
         RCALL TIMER_1
         SLEEP
         RCALL SLEEP_ID_OFF
         RCALL STOP_TIMER_1

         LDI   FRE   , $9A     ; SET "Z" LOW BYTE
         CLR   FREE            ; SET "Z" HIGH BYTE
         ldi   acc_1 , $0
         st    Z     , acc_1
         
         LDI   FRE   , $85     ; SET "Z" LOW BYTE
         CLR   FREE            ; SET "Z" HIGH BYTE
         LDI   ACC_1 , $33
         st    Z     , ACC_1 

         RCALL LED_OFF
         rcall rx_off
         RCALL SLEEP_PD_ON
         rcall inter_0
         sleep
         rjmp  reset
;////////////////////////////////////////////////////////         
