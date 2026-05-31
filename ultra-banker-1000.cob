*> Sample COBOL PROGRAM
IDENTIFICATION DIVISION.
PROGRAM-ID. ultra-banker-1000.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT MY-TEXT-FILE ASSIGN TO "intro.txt"
        ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD  MY-TEXT-FILE.
01  FILE-RECORD.
    05  TEXT-LINE       PIC X(120).

WORKING-STORAGE SECTION.
01  WS-EOF              PIC X(1) VALUE "N".

PROCEDURE DIVISION.
MAIN-LOGIC.
    DISPLAY "Hello, world!".
    PERFORM SAY-HELLO.
    
    *> This will now execute your intro-reading paragraph
    PERFORM DISPLAY-INTRO.
    
    STOP RUN.
    
*> This is your "function"
SAY-HELLO.
    DISPLAY "Hello from inside a paragraph!".
    *> Logic flows back to the main logic automatically at the end of the paragraph.

DISPLAY-INTRO.
    OPEN INPUT MY-TEXT-FILE
    READ MY-TEXT-FILE
        AT END MOVE "Y" TO WS-EOF
    END-READ
    PERFORM UNTIL WS-EOF = "Y"
        DISPLAY FUNCTION TRIM(TEXT-LINE)
        READ MY-TEXT-FILE
            AT END MOVE "Y" TO WS-EOF
        END-READ
    END-PERFORM
    CLOSE MY-TEXT-FILE.
