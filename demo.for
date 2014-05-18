      program demo
************************************************************************
*  fl -c demo.for
*  link @demo.lnk
************************************************************************
      pi = 4*atan(1.)
      call GrafIn                      ! enter graphic mode
      do 20 i=1,8
      call SetCol(i)                   ! set default color
      call seed(i)
      ixa = ipix(639)
      iya = ipix(479)
      do 10 k=1,10
      ixe = ipix(639)
      iye = ipix(479)
      call DrwLin(ixa,iya,ixe,iye)     ! draw a line using color i
      ixa = ixe
      iya = iye
10    continue
20    continue
      read(*,*)
      call GrafEx                      ! leave graphic mode
      end

      function ipix(npix)              ! random pixel value
      call random(val)
      ipix = nint(npix*val)
      end
