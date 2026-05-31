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

01  BALANCE-GET-ACC           PIC X(8).
01  BALANCE-GET-BAL           PIC S9(7)V99 VALUE 0.

01  COMMAND-INPUT    PIC X(20) VALUE SPACES.



PROCEDURE DIVISION.
MAIN-LOGIC.
    *> DISPLAY "Hello, world!".
    *> PERFORM SAY-HELLO.
    CALL "SYSTEM" USING "clear".
    *> This will now execute your intro-reading paragraph
    PERFORM DISPLAY-INTRO.
    
    *> PERFORM DISPLAY-TRANSACTIONS.
    
    DISPLAY ">  " WITH NO ADVANCING.
    ACCEPT COMMAND-INPUT.
    
    *> DISPLAY COMMAND-INPUT.
    
    PERFORM RUN-COMMAND.
    
    *> 1. Supply the INPUT variable
    MOVE "99887766" TO BALANCE-GET-ACC.
    
    *> 2. Call the paragraph
    PERFORM GET-ACCOUNT-BALANCE.
    
    *> 3. Use the OUTPUT variable
    DISPLAY "=======================================".
    DISPLAY "Final Balance for Account " BALANCE-GET-ACC ": $" BALANCE-GET-BAL.
    DISPLAY "=======================================".
    
    STOP RUN.

RUN-COMMAND.
	*> DISPLAY "RUNNING COMMAND"
	IF COMMAND-INPUT = "HELP"
		DISPLAY "ULTRA-BANKER-1000 V0.0.1"
		DISPLAY "COMMANDS:"
		DISPLAY "	HELP: Display this message"
	END-IF.
    


*> INPUTS:
*>	BALANCE-GET-ACC
*> OUTPUTS:
*>  BALANCE-GET-BAL
GET-ACCOUNT-BALANCE.
	
	MOVE "N" TO WS-EOF-TRANS.
    MOVE 0 TO BALANCE-GET-BAL.
    
    
    OPEN INPUT TRANS-FILE.
    
    PERFORM READ-NEXT.
    
    PERFORM UNTIL WS-EOF-TRANS = "Y"
        *> DISPLAY "--- Transaction Processed ---"
        *> DISPLAY "Source Account:      " TR-SRC-ACC
        *> DISPLAY "Destination Account: " TR-DST-ACC
        *> DISPLAY "Amount transferred:  $" TR-AMOUNT
        *> DISPLAY " "
        
        
        IF TR-SRC-ACC = BALANCE-GET-ACC
		     COMPUTE BALANCE-GET-BAL =  BALANCE-GET-BAL - FUNCTION NUMVAL(TR-AMOUNT)
		     *> DISPLAY "FOUND ACCOUNT"
		     *> DISPLAY "YAY"
		END-IF
		
		IF TR-DST-ACC = BALANCE-GET-ACC
		     COMPUTE BALANCE-GET-BAL =  BALANCE-GET-BAL + FUNCTION NUMVAL(TR-AMOUNT)
		     *> DISPLAY "FOUND ACCOUNT"
		     *> DISPLAY "YAY"
		END-IF
        
        PERFORM READ-NEXT
    END-PERFORM.
    
    CLOSE TRANS-FILE.    

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
    *> STOP RUN.

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
