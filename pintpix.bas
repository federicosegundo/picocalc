/*
 * pintpix.bas
 * fsr 2025
 */

x=100
y=160
Const t=8
fg=RGB(yellow)
bg=RGB(black)

Do
    Color fg
    Pause 50
    a$=Inkey$
    d=Asc(a$)

    Select Case d
        Case 113: Exit
        Case 130: x=x-t
        Case 131: x=x+t
        Case 128: y=y-t
        Case 129: y=y+t
        Case 32
            savedc=fg
            fg=bg
            bg=savedc
    End Select

    Box x,y,t,t,t
    Pause 50
    Color bg
    Box x,y,t,t,t
Loop
