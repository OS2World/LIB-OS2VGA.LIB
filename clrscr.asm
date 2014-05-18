;
;----------------------------------------------------------------------
; L”schen des Grafikbildschirms mit der Hintergrundfarbe 'Color'
;----------------------------------------------------------------------
;
;FORTRAN Aufruf:
;       INTERFACE TO SUBROUTINE ClrScr [PASCAL] (VGASeg,Color)
;       INTEGER*4  VGASeg [NEAR,VALUE]
;       INTEGER*2  Color  [NEAR,VALUE]
;       END
;       ...
;       CALL ClrScr(VGASeg,Color)
;
        .286p
        .MODEL large,pascal
        .CODE

ClrScr  PROC    USES es di dx cx, VGASeg: DWORD, Color: WORD

        les     di,VGASeg               ; ES = VGABase
        mov     dx,3c4h
        mov     ax,0f02h
        out     dx,ax                   ; map mask register = 1111b
        xor     al,al
        mov     cx,Color
        mov     ah,cl
        mov     dx,3ceh
        out     dx,ax                   ; set/reset register = color
        mov     ax,0f01h
        out     dx,ax                   ; enable set/reset register = 1111b

        mov     ax,0
        mov     cx,38400/2              ; VGA
;       mov     cx,28000/2              ; EGA
        cld
        rep     stosw

        mov     ax,0001h
        out     dx,ax                   ; enable set/reset register = 0

        ret

ClrScr  ENDP
        END
