;
;----------------------------------------------------------------------
; set the read-map-register to the bitplane to be read (NBtPln=0,1,2,3)
;----------------------------------------------------------------------
;
;FORTRAN calling sequnce
;       INTERFACE TO SUBROUTINE RColor [PASCAL] (NBtPln)
;       INTEGER*2 NBtPln [NEAR,VALUE]
;       END
;       ...
;       CALL RColor(NBtPln)
;
        .286p
        .MODEL large,pascal
        .CODE

RColor  PROC    USES dx, NBtPln: WORD

        mov     dx,03ceh
        mov     ax,NBtPln
        mov     ah,al
        mov     al,4
        out     dx,ax

        ret

RColor  ENDP
        END
