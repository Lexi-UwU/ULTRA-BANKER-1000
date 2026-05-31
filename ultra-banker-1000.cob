*> Sample COBOL PROGRAM
IDENTIFICATION DIVISION.
PROGRAM-ID. ultra-banker-1000.



ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT INTRO-TEXT-FILE ASSIGN TO "intro.txt"
        ORGANIZATION IS LINE SEQUENTIAL.
    
	SELECT TRANS-FILE ASSIGN TO "transactions.txt"
        ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD  INTRO-TEXT-FILE.
01  FILE-RECORD.
    05  TEXT-LINE       PIC X(120).

FD  TRANS-FILE.
01  TRANS-RECORD.
    05  TR-INDEX      PIC X(4).
    05  FILLER        PIC X(5). *> Catches " ACC "
    05  TR-SRC-ACC    PIC X(8). *> Catches "99887766"
    05  FILLER        PIC X(5). *> Catches " DST "
    05  TR-DST-ACC    PIC X(8). *> Catches "11223344"
    05  FILLER        PIC X(5). *> Catches " AMT "
    05  TR-AMOUNT     PIC 9(5)V99. *> Catches "20.00" (Maps to a number)


WORKING-STORAGE SECTION.
01  WS-EOF-INTRO              PIC X(1) VALUE "N".
01  WS-EOF-TRANS              PIC X(1) VALUE "N".




PROCEDURE DIVISION.
MAIN-LOGIC.
    *> DISPLAY "Hello, world!".
    *> PERFORM SAY-HELLO.
    
    *> This will now execute your intro-reading paragraph
    PERFORM DISPLAY-INTRO.
    
    PERFORM DISPLAY-TRANSACTIONS
    
    STOP RUN.
    

DISPLAY-TRANSACTIONS.
    OPEN INPUT TRANS-FILE.
    
    PERFORM READ-NEXT.
    
    PERFORM UNTIL WS-EOF-TRANS = "Y"
        DISPLAY "--- Transaction Processed ---"
        DISPLAY "Source Account:      " TR-SRC-ACC
        DISPLAY "Destination Account: " TR-DST-ACC
        DISPLAY "Amount transferred:  $" TR-AMOUNT
        DISPLAY " "
        
        PERFORM READ-NEXT
    END-PERFORM.
    
    CLOSE TRANS-FILE.
    STOP RUN.

READ-NEXT.
    READ TRANS-FILE
        AT END MOVE "Y" TO WS-EOF-TRANS
    END-READ.
    
*> This is your "function"
SAY-HELLO.
    DISPLAY "Hello from inside a paragraph!".
    *> Logic flows back to the main logic automatically at the end of the paragraph.

DISPLAY-INTRO.
    OPEN INPUT INTRO-TEXT-FILE
    READ INTRO-TEXT-FILE
        AT END MOVE "Y" TO WS-EOF-INTRO
    END-READ
    PERFORM UNTIL WS-EOF-INTRO = "Y"
        DISPLAY FUNCTION TRIM(TEXT-LINE)
        READ INTRO-TEXT-FILE
            AT END MOVE "Y" TO WS-EOF-INTRO
        END-READ
    END-PERFORM
    CLOSE INTRO-TEXT-FILE.
