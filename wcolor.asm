;
;----------------------------------------------------------------------
; Setzen des Set/Reset- und des Set/Reset-Registers auf die zu
; schreibende Bit-Plane (NBtPln=0,1,2,3)
;----------------------------------------------------------------------
;
;FORTRAN Aufruf:
;       INTERFACE TO SUBROUTINE WColor [PASCAL] (NBtPln)
;       INTEGER*2 NBtPln [NEAR,VALUE]
;       END
;       ...
;       CALL WColor(NBtPln)
;
        .286p
        .MODEL large,pascal
        .CODE

WColor  PROC    USES cx dx, NBtPln: WORD

        mov     dx,03c4h
        mov     cx,NBtPln
        mov     ah,1
        shl     ah,cl                   ; AH = 2^NBtPln
        mov     al,2
        out     dx,ax                   ; Map Mask Register = 2^NBtPln
        mov     dx,03ceh
        mov     ax,0001h
        out     dx,ax                   ; Enable Set/Reset Register = 0
        mov     ax,0ff08h
        out     dx,ax                   ; Bit Mask Register = FF

        ret

WColor  ENDP
        END
