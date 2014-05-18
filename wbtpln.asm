;
;----------------------------------------------------------------------
; write to the bitplane defined with WColor()
;----------------------------------------------------------------------
;
;FORTRAN calling sequence
;       INTERFACE TO SUBROUTINE WBtPln(VGASeg,BtPlnD)
;       INTEGER*4  VGASeg [NEAR,VALUE]
;       INTEGER*1  BtPlnD(38400)   ! VGA
;       INTEGER*1  BtPlnD(28000)   ! EGA
;       END
;       ...
;       CALL WBtPln(VGASeg,BtPlnD)
;
        .286p
        .MODEL large,fortran
        .CODE

WBtPln  PROC    USES cx ds es si di, VGASeg: DWORD, BtPlnD: PTR BYTE

        les     di,VGASeg               ; ES = VGABase

        lds     si,BtPlnD               ; DS = SEGMENT(BtPlnD)
                                        ; SI = OFFSET(BtPlnD)
        cld                             ; clear direction flag
        mov     cx,38400/2              ; number of words in one
                                        ; VGA bitplane
;       mov     cx,28000/2              ; number of words in one
                                        ; EGA bitplane
        rep     movsw                   ; copy

        ret

WBtPln  ENDP
        END
