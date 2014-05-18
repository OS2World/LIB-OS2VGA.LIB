      INTERFACE TO SUBROUTINE ClrScr [PASCAL] (VGASeg,Color)
      INTEGER*4  VGASeg [NEAR,VALUE]
      INTEGER*2  Color  [NEAR,VALUE]
      END
      INTERFACE TO SUBROUTINE PntSet [PASCAL] (VGASeg,Color,X,Y)
      INTEGER*4  VGASeg [NEAR,VALUE]
      INTEGER*2  Color  [NEAR,VALUE]
      INTEGER*2  X,Y    [NEAR,VALUE]
      END
      INTERFACE TO INTEGER*2 FUNCTION BeginThread(Rtn,Stk,Size,Arg)
      INTEGER*4 Rtn[VALUE]
      INTEGER*1 Stk(*)
      INTEGER*4 Size
      INTEGER*4 Arg
      END


      SUBROUTINE GrafIn
************************************************************************
*     enter graphics mode
************************************************************************
      INTEGER*1  Stack(1024)
      INTEGER*2  BeginThread, ReturnCode
      INTEGER*4  VGASeg
      EXTERNAL   SRScrn
      COMMON /SegCom/ VGASeg
      CALL ScrLck(.TRUE.)
      CALL GMode(.TRUE.)
      CALL VIOAddr(VGASeg)
      ReturnCode = BeginThread(LocFar(SRScrn),Stack,1024,VGASeg)
* --- suppress the flickering of the OAK-VGA
* --- the next two statements may be removed
      CALL ClrScr(VGASeg,INT2(0))
      CALL Wait(500)
      CALL ScrLck(.FALSE.)
      END



      SUBROUTINE GrafEx
************************************************************************
*     leave graphics mode
************************************************************************
      CALL GMode(.FALSE.)
      END



      SUBROUTINE SetCol(Color)
************************************************************************
*     set the color for the next pixels to be drawn
************************************************************************
      INTEGER*2  Color,Farbe
      COMMON /ColCom/ Farbe
      Farbe = Color+8
      END



      SUBROUTINE SetPxl(IX,IY)
************************************************************************
*     draw pixel at (IX,IY)
************************************************************************
      PARAMETER  ( MaxX=639, MaxY=479 )   ! VGA
c     PARAMETER  ( MaxX=639, MaxY=349 )   ! EGA
      INTEGER*2  IX,IY,JY,Farbe
      INTEGER*4  VGASeg
      COMMON /SegCom/ VGASeg
      COMMON /ColCom/ Farbe
      JY = MaxY - IY
      IF( IX.LT.0 .OR. IX.GT.MaxX )  RETURN
      IF( JY.LT.0 .OR. JY.GT.MaxY )  RETURN
      CALL ScrLck(.TRUE.)
      CALL PntSet(VGASeg,Farbe,IX,JY)
      CALL ScrLck(.FALSE.)
      END



      SUBROUTINE DrwLin(X1,Y1a,X2,Y2a)
************************************************************************
*     draw a line between the points (X1,Y1a) and (X2,Y2a) using
*     BRESENHAM'S algorithm
*     the points must lay in the range of the VGA, e.g.
*               -1 < X1 < 640 ,  -1 < Y1a < 480
*               -1 < X2 < 640 ,  -1 < Y2a < 480
*     the lower left corner is the origin!
************************************************************************
      PARAMETER  ( MaxX=639, MaxY=479 )   ! VGA
c     PARAMETER  ( MaxX=639, MaxY=349 )   ! EGA
      LOGICAL*2  Inv,XPos,YPos
      INTEGER*2  X1,X2,Y1,Y1a,Y2,Y2a,X,Y,DX,DY,I,E,DE1,DE2,DH, S1,S2
      INTEGER*2  Farbe
      INTEGER*4  VGASeg
      COMMON /SegCom/ VGASeg
      COMMON /ColCom/ Farbe
      CALL ScrLck(.TRUE.)
      Y1 = MaxY - Y1a
      Y2 = MaxY - Y2a
      IF( X1.LT.0 .OR. X1.GT.MaxX )  RETURN
      IF( X2.LT.0 .OR. X2.GT.MaxX )  RETURN
      IF( Y1.LT.0 .OR. Y1.GT.MaxY )  RETURN
      IF( Y2.LT.0 .OR. Y2.GT.MaxY )  RETURN
      S1 = X1
      S2 = X2
      DX = X2 - X1
      DY = Y2 - Y1
      XPos = DX .GT. 0
      YPos = DY .GT. 0
      DX = ABS(DX)
      DY = ABS(DY)
      IF( XPos )  THEN
         X = X1
      ELSE
         X =-X1
      END IF
      IF( YPos )  THEN
         Y = Y1
      ELSE
         Y =-Y1
      END IF
      Inv = DX .LT. DY
      IF( Inv )  THEN
         DH = DX
         DX = DY
         DY = DH
      END IF
      E = 2*DY - DX
      DE1 = E - DX
      DE2 = 2*DY
      DO 10 I=1,DX+1
      IF( XPos )  THEN
         IF( YPos )  THEN
            CALL PntSet(VGASeg,Farbe,X,Y)
         ELSE
            CALL PntSet(VGASeg,Farbe,X,-Y)
         END IF
      ELSE
         IF( YPos )  THEN
            CALL PntSet(VGASeg,Farbe,-X,Y)
         ELSE
            CALL PntSet(VGASeg,Farbe,-X,-Y)
         END IF
      END IF
      IF( Inv ) THEN
         Y = Y + 1
      ELSE
         X = X + 1
      END IF
      IF( E .GT. 0 )  THEN
         IF( Inv )  THEN
            X = X + 1
         ELSE
            Y = Y + 1
         END IF
         E = E + DE1
      ELSE
         E = E + DE2
      END IF
      X1 = X2
      Y1 = Y2
10    CONTINUE
      X1 = S1
      X2 = S2
      CALL ScrLck(.FALSE.)
      END
