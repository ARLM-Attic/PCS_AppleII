 LST OFF
*
* PCS - SWAPPING HANDLER
*
 ORG $1E00
 OBJ $8000
*
TEMP EQU $07
XTEMP EQU TEMP+1
YTEMP EQU XTEMP+1
*
* EXTERNALS
*
DIV7 EQU $1400
MOD7 EQU DIV7+$100
LO EQU MOD7+$100
HI EQU LO+$C0
SETMODE EQU HI+$10F
DRAWBITS EQU SETMODE+$25
XOFFDRAW EQU DRAWBITS+$3D
GETRECT EQU XOFFDRAW+$59
MASKS EQU GETRECT+$41
HLINE EQU MASKS+$F
VLINE EQU HLINE+$20
FRAMERECT EQU VLINE+$58
DRAWRECT EQU FRAMERECT+$28
INRECT EQU DRAWRECT+$10
GETBUTNS EQU INRECT+$2D
INITCRSR EQU GETBUTNS+$7
XDRAWCRSR EQU INITCRSR+$1B
UPDATECRSR EQU XDRAWCRSR+$7
DOCRSRX EQU UPDATECRSR+$1E
GETCURSORX EQU DOCRSRX+$45
DOCRSRY EQU GETCURSORX+$16
JSCTRL EQU DOCRSRY+$4D
CRSRINRECT EQU JSCTRL+$21
DOMENU EQU CRSRINRECT+$13
SELECT EQU DOMENU+$54
INIT EQU SELECT+$40
MOVEUP EQU INIT+$35
MOVEDOWN EQU MOVEUP+$3B
ADDIYX EQU MOVEDOWN+$39
ADDYX EQU ADDIYX+$E
SUBIYX EQU ADDYX+$10
SUBYX EQU SUBIYX+$12
CMPYX EQU SUBYX+$10
CHARTO EQU CMPYX+$F
PRCHAR EQU CHARTO+$A
PRINT EQU PRCHAR+$38
CHAR EQU PRINT+$19
*
VALIDBUF EQU $A500
FIRSTBOOT EQU $B700
READSECTORS EQU $B784
SECTORCOUNT EQU $B7C2
BOOTSLOT EQU $B7C3
SLOT EQU $B7E9
DRIVE EQU $B7EA
VOLUME EQU $B7EB
READBUFLO EQU $B7F0
*
SWAPEDIT LDX #0
 JSR SWAPSECTORS
 JMP $9500
*
SWAPWIRE LDX #1
 JSR SWAPPIECE
 JMP $9513
*
SWAPDISK LDX #2
 JSR SWAPPIECE
 JMP $9510
*
SWAPUSER LDX #3
 BNE SWAPSECTORS
*
RELOAD PHA
 LDX #1
 JSR SWAPSECTORS
 PLA
 TAX
 TXS
 LDA #0
 STA $82
 STA $83
 STA $84
 RTS
*
SWAPPIECE JSR SWAPSECTORS
 JSR $9500
 LDX #0
*
SWAPSECTORS STX XTEMP
 LDA BOOTSLOT
 STA SLOT
 LDA #1
 STA DRIVE
 LDA #0
 STA READBUFLO
 STA VOLUME
 JSR PCSINSERTED
*
 LDX XTEMP
 LDA COUNT,X
 STA SECTORCOUNT
 LDA SECTOR,X
 STA TEMP
 LDA TRACK,X
 LDY ADDRHI,X
 LDX TEMP
 JMP READSECTORS
*
COUNT HEX 390A080A
TRACK HEX 0B0C0D0E
SECTOR HEX 08090709
ADDRHI HEX A89E9C8E
*
PCSINSERTED LDA #0
 LDX #1
 STX SECTORCOUNT
 LDY #>VALIDBUF
 JSR READSECTORS
*
 LDY #$40
PCSIN2 LDA VALIDBUF,Y
 CMP FIRSTBOOT,Y
 BNE PCSIN3
 DEY
 BPL PCSIN2
 RTS
*
PCSIN3 LDY #1
 JSR SETMODE
 LDA #<DIALOGBITS
 LDX #>DIALOGBITS
 JSR DRAWBITS
 LDY #3
 JSR SETMODE
 LDA #<DIALOGBOX
 LDX #>DIALOGBOX
 JSR DRAWRECT
 LDY #2
 JSR SETMODE
 JSR FRAMERECT+3
*
 LDY #$59
 LDX #1
 LDA #0
 JSR CHARTO
 LDA #<INSERTMSG
 LDX #>INSERTMSG
 JSR PRINT
*
 STA $C010
WAIT1 LDA $C000
 BPL WAIT1
 STA $C010
*
 LDY #0
 JSR SETMODE
 LDA #<DIALOGBITS
 LDX #>DIALOGBITS
 JSR DRAWBITS
 LDY #2
 JSR SETMODE
*
 JMP PCSINSERTED
*
INSERTMSG HEX 12171C0E1B1D24190C1C240D121C94
*
DIALOGBITS DA $A000
 HEX 5700000B28
*
DIALOGBOX HEX 5700000A2705
*
