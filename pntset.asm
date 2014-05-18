;
;----------------------------------------------------------------------
; set pixel at (X,Y) with Color
;----------------------------------------------------------------------
;
;FORTRAN calling sequence
;       INTERFACE TO SUBROUTINE PntSet [PASCAL] (VGASeg,Color,X,Y)
;       INTEGER*4  VGASeg [NEAR,VALUE]
;       INTEGER*2  Color  [NEAR,VALUE]
;       INTEGER*2  X,Y    [NEAR,VALUE]
;       END
;       ...
;       CALL PntSet(VGASeg,Color,X,Y)
;
        .286p
        .MODEL large,pascal
        .CODE

PntSet  PROC    USES ds dx cx, VGASeg: DWORD, Color: WORD, X: WORD, Y: WORD


; calculate byte address and bitmask
        lds     bx,VGASeg               ; DS = VGABase
        mov     ax,Y                    ; AX = Y
        mov     dx,80
        mul     dx                      ; AX = 80*Y
        mov     bx,x                    ; BX = x
        mov     cx,bx                   ; CX = x
        shr     bx,1
        shr     bx,1
        shr     bx,1                    ; BX = x/8
        add     bx,ax                   ; BX = 80*y + x/8   (offset)
        and     cl,7                    ; CL = (x mod 8)
        xor     cl,7                    ; CL = 7 - (x mod 8)
        mov     ah,1
        shl     ah,cl                   ; AH = 2^( 7-(x mod 8) )  (bit mask)
; set bit mask register
        mov     al,8
        mov     dx,3ceh
        out     dx,ax
; set bitplane register
        mov     dx,color
        mov     ah,dl
        mov     al,2
        mov     dx,3c4h
        out     dx,ax
        mov     al,[bx]                 ; load latch register
        mov     al,0ffh
        mov     [bx],al                 ; write bits
; restore default parameters
        mov     ax,0f02h
        out     dx,ax
        mov     ax,0ff08h
        mov     dx,3ceh
        out     dx,ax

        ret

PntSet  ENDP
        END
