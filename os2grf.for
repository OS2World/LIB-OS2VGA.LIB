$NOTRUNCATE
$DEFINE  INCL_VIO
$DEFINE  INCL_DOSPROCESS

      INCLUDE 'BSESUB.FI'
      INCLUDE 'BSEDOS.FI'

      INTERFACE TO SUBROUTINE RColor [PASCAL] (NBtPln)
      INTEGER*2 NBtPln [NEAR,VALUE]
      END
      INTERFACE TO SUBROUTINE WColor [PASCAL] (NBtPln)
      INTEGER*2 NBtPln [NEAR,VALUE]
      END
      INTERFACE TO SUBROUTINE RBtPln(VGASeg,BtPlnD)
      INTEGER*4  VGASeg [NEAR,VALUE]
      INTEGER*1  BtPlnD(38400)   ! VGA
C     INTEGER*1  BtPlnD(28000)   ! EGA
      END
      INTERFACE TO SUBROUTINE WBtPln(VGASeg,BtPlnD)
      INTEGER*4  VGASeg [NEAR,VALUE]
      INTEGER*1  BtPlnD(38400)   ! VGA
C     INTEGER*1  BtPlnD(28000)   ! EGA
      END



      SUBROUTINE GMode(SetMode)
************************************************************************
*     set dispaly mode to SetMode
************************************************************************

      INCLUDE 'BSESUB.FD'

      LOGICAL              SetMode, First / .TRUE. /
      INTEGER*2            SaveMode, ReturnCode
      RECORD /VIOMODEINFO/ NewMode, OldMode

      IF( SetMode )  THEN
* --- enter grafics mode
         IF( First )  THEN
* --- save old video mode
            OldMode.cb  =  12
            SaveMode    = VioGetMode( OldMode, 0 )
            First       = .False.
         END IF
         NewMode.cb     =  12
         NewMode.fbType =   3
         NewMode.color  =   4
         NewMode.col    =  80
         NewMode.row    =  25
         NewMode.hres   = 640
         NewMode.vres   = 480   ! VGA
C        NewMode.vres   = 350   ! EGA
         ReturnCode     = VioSetMode( NewMode, 0 )
         IF( ReturnCode .NE. 0 )  THEN
            WRITE(*,'(A,I6.5)') ' %%% VioSetMode ERROR:',ReturnCode
            STOP
         END IF
      ELSE
*     restore old video-mode
         ReturnCode     = VioSetMode( OldMode, 0 )
         IF( ReturnCode .NE. 0 )  THEN
            WRITE(*,'(A,I6.5)') ' %%% VioSetMode ERROR:',ReturnCode
            STOP
         END IF
         CALL Wait( 500 )
      END IF

      END



      SUBROUTINE Wait( MilliSeconds )

      INCLUDE 'BSEDOS.FD'

      INTEGER*2  ReturnCode
      INTEGER*4  MilliSeconds

      ReturnCode = DosSleep( MilliSeconds )

      END



      SUBROUTINE VioAddr(VioMemAddr)
************************************************************************
*     retrieves the address of the physical video buffer
************************************************************************

      INCLUDE 'BSESUB.FD'

      INTEGER*2            ReturnCode
      INTEGER*4            VioMemAddr
      RECORD /VIOPHYSBUF/  Phys

      Phys.pBuf  = 10 * 2**16
      Phys.cb    = 480 * 640 / 8   ! VGA
*     Phys.cb    = 350 * 640 / 8   ! EGA
      ReturnCode = VioGetPhysBuf(Phys,0)
      IF( ReturnCode .NE. 0 )  THEN
         WRITE(*,'(A,I6.5)') ' %%% VioGetPhysBuf ERROR:',ReturnCode
         STOP
      END IF
* --- create a far pointer
      VioMemAddr = JFIX(Phys.asel(1)) * 2**16

      END



      SUBROUTINE ScrLck(Flag)
************************************************************************
*     locks (Flag=.TRUE.) and unlocks (Flag=.FALSE.) the screen
************************************************************************

      INCLUDE 'BSESUB.FD'

      LOGICAL    FLAG
      INTEGER*2  ReturnCode, WaitFlag, Status, VioHandle
      DATA       WaitFlag /1/ ,  VioHandle /0/

      IF( Flag )  THEN
* --- wait until the physical screen is available
* --- then lock the screen, that graphics output is possible
         ReturnCode = VioScrLock(WaitFlag, Status, VioHandle)
         IF( ReturnCode .NE. 0 )  THEN
            WRITE(*,'(A,I6.5)') ' %%% VioScrLock ERROR:',ReturnCode
            STOP
         END IF
      ELSE
* --- unlocks the physical screen
         ReturnCode = VioScrUnlock(VioHandle)
         IF( ReturnCode .NE. 0 )  THEN
            WRITE(*,'(A,I6.5)') ' %%% VioScrUnlock ERROR:',ReturnCode
            STOP
         END IF
      END IF

      END



      SUBROUTINE SRScrn(VGASeg)
************************************************************************
*     save and restore screen when the task is switch between
*     foreground and background
*     VGASeg is the address of the physical video buffer
*     this subroutine is normally started in a separate thread
************************************************************************

      INCLUDE 'BSESUB.FD'

      INTEGER*4  VGASeg
      INTEGER*2  ReturnCode, Indicator, Notify, Handle
      INTEGER*1  Plane0(38400), Plane1(38400), Plane2(38400),   ! VGA
     &           Plane3(38400)
*     INTEGER*1  Plane0(28000), Plane1(28000), Plane2(28000),   ! EGA
*    &           Plane3(28000)

      DATA  Indicator / 0 / ,  Handle / 0 /

1000  C O N T I N U E
      ReturnCode = VioSavRedrawWait( Indicator, Notify, Handle )
      IF( ReturnCode .NE. 0 )  THEN
         WRITE(*,'(A,I6.5)') ' %%% VioSavRedrawWait ERROR:',ReturnCode
         STOP
      END IF

      IF( Notify .EQ. 0 )  THEN
* --- save screen
         CALL RColor(0)
         CALL RBtPln(VGASeg,Plane0)
         CALL RColor(1)
         CALL RBtPln(VGASeg,Plane1)
         CALL RColor(2)
         CALL RBtPln(VGASeg,Plane2)
         CALL RColor(3)
         CALL RBtPln(VGASeg,Plane3)
      ELSE
* --- restore screen
         CALL GMode(.TRUE.)
         CALL WColor(0)
         CALL WBtPln(VGASeg,Plane0)
         CALL WColor(1)
         CALL WBtPln(VGASeg,Plane1)
         CALL WColor(2)
         CALL WBtPln(VGASeg,Plane2)
         CALL WColor(3)
         CALL WBtPln(VGASeg,Plane3)
      END IF
      GO TO 1000

      END
