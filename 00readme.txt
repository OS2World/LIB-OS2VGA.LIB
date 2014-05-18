OS2VGA.LIB is a library with some simple graphics functions for OS/2
protected mode not using the presentation manager.  The library can be
used with any Microsoft compiler (especially FORTRAN) and was developed
to port mainframe applications to the PC.  The usage of OS2VGA is
demonstrated with 'DEMO.FOR'.
A correct screen handling is guarenteed by OS2VGA.  This means, when a
user switches to another screen group, and this is allowed any time,
the graphic screen is saved and restored when switching back.  This task
is done by a separate thread and therefore the multithread library
(LLIBFMT.LIB) is used (see 'DEMO.LNK').
An other thing to point out is the necessity of a definition file (see
OS2VGA.DEF) when linking with OS2VGA because of the direct access to the
harware using the IOPL segment.  To allow a user program (ring 3) to
enter the IOPL segment (ring 2), the 'CONFIG.SYS' file must contain the
statement 'IOPL=YES'.

The routines are tested with
   - Microsoft OS/2 1.1 and 1.2
   - Microsoft FORTRAN Compiler 5.0
   - Microsoft Macro Assembler 5.1

This software can be used freely for private or educational purposes.
If you want to use it for commercial purposes, contact the author.

Author:   Martin Stroeer
          Saint Die Str. 25
          D-7990 Friedrichshafen
          Germany

E-Mail:   xdst001@convex.zdv.uni-tuebingen.de
