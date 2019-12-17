(load-shared-object "kilo.so")

(define BACKSPACE 127)
(define ARROW_LEFT 1000)
(define ARROW_RIGHT 1001)
(define ARROW_UP 1002)
(define ARROW_DOWN 1003)
(define DEL_KEY 1004)
(define HOME_KEY 1005)
(define END_KEY 1006)
(define PAGE_UP 1007)
(define PAGE_DOWN 1008)

(define enableRawMode
  (foreign-procedure "enableRawMode" () void))

(define disableRawMode
  (foreign-procedure "disableRawMode" () void))

(define initEditor
  (foreign-procedure "initEditor" () void))

(define editorRefreshScreen
  (foreign-procedure "editorRefreshScreen" () void))

(define editorClearScreen
  (foreign-procedure "editorClearScreen" () void))

(define editorSetStatusMessage
  (foreign-procedure "editorSetStatusMessage" (string) void))

(define editorGetSexp
  (foreign-procedure "editorGetSexp" () string))

(define editorReadKey
  (foreign-procedure "editorReadKey" () int))

(define (CTRL_KEY c)
  (logand #b00011111 (char->integer c)))

(define (ALT_KEY c)
  (+ 1100 (char->integer c)))

(define editorProcessKeypress
  (foreign-procedure "editorProcessKeypress" () void))

(define editorOpen
  (foreign-procedure "editorOpen" (string) void))

(define editorQuit
  (foreign-procedure "editorQuit" () void))

(define editorSave
  (foreign-procedure "editorSave" () void))

(define editorFind
  (foreign-procedure "editorFind" () void))

(define editorInsertNewline
  (foreign-procedure "editorInsertNewline" () void))

(define editorMoveCursor
  (foreign-procedure "editorMoveCursor" (int) void))

(define editorGetCursorCol
  (foreign-procedure "editorGetCursorCol" () int))

(define editorGetCursorRow
  (foreign-procedure "editorGetCursorRow" () int))

(define editorGetChar
  (foreign-procedure "editorGetChar" (int int) char))

(define editorGetMaxRow
  (foreign-procedure "editorGetMaxRow" () int))

(define editorGetMaxCol
  (foreign-procedure "editorGetMaxCol" () int))

(define editorInsertChar
  (foreign-procedure "editorInsertChar" (int) void))

(define editorDelChar
  (foreign-procedure "editorDelChar" () void))

(define editorScroll
  (foreign-procedure "editorScroll" () void))

(define editorScrollPage
  (foreign-procedure "editorScrollPage" (int) void))

(define editorMoveCursorBeginningOfLine
  (foreign-procedure "editorMoveCursorBeginningOfLine" () void))

(define editorMoveCursorEndOfLine
  (foreign-procedure "editorMoveCursorEndOfLine" () void))

;; (define is_seperator
;;   (foreign-procedure "is_seperator" (int) int))

(define editorDelRow
  (foreign-procedure "editorDelChar" (int) void))

