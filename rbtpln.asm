;
;----------------------------------------------------------------------
; read the bitplane defined with RColor()
;----------------------------------------------------------------------
;
;FORTRAN calling sequence
;       INTERFACE TO SUBROUTINE RBtPln(VGASeg,BtPlnD)
;       INTEGER*4  VGASeg [NEAR,VALUE]
;       INTEGER*1  BtPlnD(38400)   ! VGA
;       INTEGER*1  BtPlnD(28000)   ! EGA
;       END
;       ...
;       CALL RbtPln(VGASeg,BtPlnD)
;
        .286p
        .MODEL large,fortran
        .CODE

RbtPln  PROC    USES cx ds es si di, VGASeg: DWORD, BtPlnD: PTR BYTE

        lds     si,VGASeg               ; DS = VGABase

        les     di,BtPlnD               ; ES = SEGMENT(BtPlnD)
                                        ; DI = OFFSET(BtPlnD)
        cld                             ; clear direction flag
        mov     cx,38400/2              ; number of words in one
                                        ; VGA bitplane
;       mov     cx,28000/2              ; number of words in one
                                        ; EGA bitplane
        rep     movsw                   ; copy

        ret

RbtPln  ENDP
        END
