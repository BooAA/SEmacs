(load "ffi.scm")

(define (point)
  (cons (editorGetCursorRow)
        (editorGetCursorCol)))

(define (char-at-point p)
  (editorGetChar (car p)
                 (cdr p)))

(define (char-after)
  (char-at-point (point)))

(define (char-before)
  (let ((c #\nul))
    (backward-char)
    (set! c (char-after))
    (forward-char)
    c))

(define (forward-char)
  (editorMoveCursor 1001))

(define (backward-char)
  (editorMoveCursor 1000))

(define (forward-word)
  (forward-char)
  (when (and (not (char=? (char-after) #\space))
             (not (equal? (car (point)) (editorGetMaxRow))))
    (forward-word)))

(define (backward-word)
  (backward-char)
  (when (and (not (char=? (char-after) #\space))
             (not (equal? (point) '(0 . 0))))
    (backward-word)))

(define (previous-line)
  (editorMoveCursor 1002))

(define (next-line)
  (editorMoveCursor 1003))

(define (move-beginning-of-line)
  (editorMoveCursorBeginningOfLine))

(define (move-end-of-line)
  (editorMoveCursorEndOfLine))

(define (forward-sexp)
  (define meet-first-open-paren #f)
  (define (forward--sexp n)
    (when (or (> n 0) (not meet-first-open-paren))
      (cond ((char=? (char-after) #\()
             (forward-char)
             (unless meet-first-open-paren (set! meet-first-open-paren #t))
             (forward--sexp (1+ n)))
            ((char=? (char-after) #\))
             (forward-char)
             (forward--sexp (1- n)))
            (else
             (forward-char)
             (forward--sexp n)))))
  (forward--sexp 0))

(define (backward-sexp)
  (define meet-first-close-paren #f)
  (define (backward--sexp n)
    (when (or (> n 0) (not meet-first-close-paren))
      (cond ((char=? (char-after) #\()
             (backward-char)
             (backward--sexp (1- n)))
            ((char=? (char-after) #\))
             (backward-char)
             (unless meet-first-close-paren (set! meet-first-close-paren #t))
             (backward--sexp (1+ n)))
            (else
             (backward-char)
             (backward--sexp n)))))
  (backward-char)
  (backward--sexp 0))

(define (self-insert-command c)
  (cond ((char? c) (editorInsertChar (char->integer c)))
        ((integer? c) (editorInsertChar c))))

(define (newline)
  (editorInsertNewline))

(define (open-line)
  (previous-line)
  (move-end-of-line)
  (newline))

(define (delete-char)
  (forward-char)
  (editorDelChar))

(define (backward-delete-char)
  (editorDelChar))

(define (kill-line)
  (if (char=? (char-after) #\nul)
      (delete-char)
      (begin
        (delete-char)
        (kill-line))))

(define (scroll-up-command)
  (editorScrollPage PAGE_UP))

(define (scroll-down-command)
  (editorScrollPage PAGE_DOWN))

(define (find)
  (editorFind))

(define (save-file)
  (editorSave))

(define (quit)
  (editorQuit))

(define (seperator? c)
  (not (zero? (is_seperator (char->integer c)))))

(define (string->expr str) 
  (read (open-string-input-port str)))

(define (execute-command)
  (let ((return-value (eval (string->expr (editorGetSexp)))))
    (editorSetStatusMessage (format "~a" return-value))))

(define (collect-string start end)
  (let ((result ""))
    (define (collect--string start end)
      (unless (equal? start end)
        (let ((c (char-at-point start)))
          (unless (char=? c #\nul)
            (set! result (string-append result (string c))))
          (if (char=? c #\nul)
              (collect--string (cons (1+ (car start)) 0)
                               end)
              (collect--string (cons (car start) (1+ (cdr start)))
                               end)))))
    (collect--string start end)
    result))

(define (eval-last-sexp)
  (set! end (point))
  (backward-sexp)
  (set! start (point))
  (forward-sexp)
  (eval (string->expr (collect-string start end)))
  (editorSetStatusMessage "eval success"))

(define-syntax try
  (syntax-rules (catch)
    ((_ body (catch catcher))
     (call-with-current-continuation
      (lambda (exit)
        (with-exception-handler
         (lambda (condition)
           catcher
           (exit condition))
         (lambda () body)))))))

(define (create-file-if-not-exist filename)
  (unless (file-exists? filename)
    (system (string-append "touch " filename))))

(define (find-file filename)
  (save-file)
  (initEditor)
  (editorClearScreen)
  (create-file-if-not-exist filename)
  (set! current-edit-file filename)
  (editorOpen filename))
