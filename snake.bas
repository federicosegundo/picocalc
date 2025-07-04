' Picocalc Snake Game
' Federico Segundo
' July 2025
' 
' A simple snake game

' --- Initial game config ---
CONST SCREEN_WIDTH = 320  
CONST SCREEN_HEIGHT = 300 
CONST START_LENGTH = 5 ' Snake len
CONST DELAY_MS = 100

DIM SnakeX(200)  
DIM SnakeY(200)  
DIM SnakeLength  
DIM FoodX, FoodY 
DIM Direction ' Snake Dir (0=U, 1=R, 2=D, 3=L)
DIM Score
DIM GameOver
DIM K$

' --- Colors ---
CONST COLOR_BACKGROUND = RGB(0,0,0)   ' NBlac
CONST COLOR_SNAKE_HEAD = RGB(0,255,0) ' Green1
CONST COLOR_SNAKE_BODY = RGB(0,150,0) ' Green2
CONST COLOR_FOOD = RGB(255,0,0)       ' Red
CONST COLOR_TEXT = RGB(255,255,255)   ' White

' --- Game Initialization Subroutine ---
SUB InitGame
    CLS                               
    ' Set text colors  
    COLOR COLOR_FOOD, COLOR_BACKGROUND
    FONT 3
    TEXT 0, 1,  "Picocalc Snake!"
    COLOR COLOR_TEXT, COLOR_BACKGROUND
    font 1
    text 0, 36, "Use arrows to move"
    TEXT 0, 72, "press key to start"
    
    DO : LOOP WHILE INKEY$ = "" ' Espera tecla

    CLS
    
    SnakeLength = START_LENGTH
    Score = 0
    GameOver = 0

    ' snake head initial pos (screen center)
    SnakeX(1) = INT(SCREEN_WIDTH / 2)
    SnakeY(1) = INT(SCREEN_HEIGHT / 2)
    Direction = 1 'Starts moving to right

    ' rest of snake init
    FOR i = 2 TO SnakeLength
        ' Snake initially moves to right therefore
        ' Segments appear to the left
        SnakeX(i) = SnakeX(1) - (i-1)*8 
        SnakeY(i) = SnakeY(1)
    NEXT i
    
    PlaceFood ' Place first food
    
    ' Show Score
    COLOR COLOR_TEXT, COLOR_BACKGROUND
    text 10, 310, "Score: "+ str$(Score) 
END SUB

' ---  Subroutine to Place Food Randomly ---
SUB PlaceFood
    DO
        FoodX = INT((RND * (SCREEN_WIDTH/8)) + 1)*8
        FoodY = INT((RND * (SCREEN_HEIGHT/10)) + 1)*10
        ' Check that he food is 
        ' not placed over the snake
        FOR i = 1 TO SnakeLength
            IF FoodX = SnakeX(i) AND FoodY = SnakeY(i) THEN
                FoodX = 0 ' Regenerate
                EXIT FOR
            END IF
        NEXT i
    LOOP WHILE FoodX = 0
    
    COLOR COLOR_FOOD, COLOR_BACKGROUND
    TEXT FoodX, FoodY, "F" ' draws food
END SUB

' --- Subroutine to Move the Snake ---
SUB MoveSnake
    ' delete last segment of snake
    COLOR COLOR_BACKGROUND, COLOR_BACKGROUND
    TEXT SnakeX(SnakeLength), SnakeY(SnakeLength), " " 

    ' Move all the rest of the segment one place forward
    FOR i = SnakeLength TO 2 STEP -1
        SnakeX(i) = SnakeX(i - 1)
        SnakeY(i) = SnakeY(i - 1)
    NEXT i

    ' Move head depeding direction
    SELECT CASE Direction
        CASE 0 ' Up
            SnakeY(1) = SnakeY(1) - 10
        CASE 1 ' Right
            SnakeX(1) = SnakeX(1) + 8
        CASE 2 ' Down
            SnakeY(1) = SnakeY(1) + 10
        CASE 3 ' Left
            SnakeX(1) = SnakeX(1) - 8
    END SELECT
END SUB

' --- Subroutine to Draw the Snake ---
SUB DrawSnake
    ' Draw body
    COLOR COLOR_SNAKE_BODY, COLOR_BACKGROUND
    FOR i = 2 TO SnakeLength
        'text 100,310,str$(i)+"x="+str$(SnakeX(i))+" y="+str$(SnakeY(i))
        TEXT SnakeX(i), SnakeY(i), "#"
    NEXT i
    ' Draw head
    COLOR COLOR_SNAKE_HEAD, COLOR_BACKGROUND
    'text 100,310,str$(i)+"x="+str$(SnakeX(1))+" y="+str$(SnakeY(1))    
    TEXT SnakeX(1), SnakeY(1), "O" 
END SUB

' --- Subroutine to Check Collisions ---
SUB CheckCollision
    ' Border collision check
    IF ((SnakeX(1) < 1) OR (SnakeX(1) > SCREEN_WIDTH) OR (SnakeY(1) < 1) OR (SnakeY(1) > SCREEN_HEIGHT)) THEN
        GameOver = 1
        EXIT SUB
    END IF

    ' Body collision
    FOR i = 2 TO SnakeLength
        IF (SnakeX(1) = SnakeX(i)) AND (SnakeY(1) = SnakeY(i)) THEN
            GameOver = 1
            EXIT SUB
        END IF
    NEXT i

    ' Food collision
    IF (SnakeX(1) = FoodX) AND (SnakeY(1) = FoodY) THEN
        Score = Score + 10
        SnakeLength = SnakeLength + 1
        
        ' Show Score
        COLOR COLOR_TEXT, COLOR_BACKGROUND
        text 10, 310, "Score: "+ str$(Score)        
        
        'Play beep
        play tone 12000,12000, 50

        ' If the snake is too long, 
        ' limit it to prevent array overflow
        IF SnakeLength > 200 THEN SnakeLength = 200
        PlaceFood ' Place new food
    END IF
END SUB

' --- Subroutine for Handling User Input ---
SUB HandleInput
    K$ = INKEY$
    IF K$ <> "" THEN
        SELECT CASE UCASE$(K$)
            CASE CHR$(128) ' up arrow
                IF Direction <> 2 THEN Direction = 0
            CASE CHR$(131) ' right arrow
                IF Direction <> 3 THEN Direction = 1
            CASE CHR$(129) ' down arrow
                IF Direction <> 0 THEN Direction = 2
            CASE CHR$(130) ' left arrow
                IF Direction <> 1 THEN Direction = 3
            CASE "Q"' 'Q' to end game
                END
        END SELECT
    END IF
END SUB

' --- Main program loop ---

InitGame

DO WHILE GameOver = 0
    HandleInput
    MoveSnake
    CheckCollision
    DrawSnake
    PAUSE DELAY_MS
LOOP

' --- Game Over ---
CLS

PAUSE 1000
COLOR COLOR_TEXT, COLOR_BACKGROUND
font 3
TEXT INT(SCREEN_WIDTH/2)-len("GAME OVER!")*8, INT(SCREEN_HEIGHT/2) - 20, "GAME OVER!"

font 1
text INT(SCREEN_WIDTH/2)-len("Final Score: "+ str$(Score))*4, INT(SCREEN_HEIGHT/2)-40, "Final Score: "+ str$(Score)
text INT(SCREEN_WIDTH/2)-LEN("Press any key to restart")*4, INT(SCREEN_HEIGHT/2) + 20, "Press any key to restart"

DO : LOOP WHILE INKEY$ = "" ' Wait to restart

RUN ' Restart the program
