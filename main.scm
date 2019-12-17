(load "ffi.scm")
(load "lib.scm")
(load "keymap.scm")

(define current-keymap global-keymap)
(define current-edit-file #f)
(define init-file "~/.semacs.d/init.scm")
(define old-cont #f)

(define (get-file-name command)
  (cadr command))

(define (main-loop)
  (editorRefreshScreen)
  (try (call/cc (lambda (return)
                  (set! old-cont return)
                  (lookup-keymap (editorReadKey) current-keymap)))
  (catch (begin
           (editorSetStatusMessage "ERROR")
           (main-loop))))
  (main-loop))

(define (interrupt-handler num)
  (old-cont "Back to old continuation"))

(define (setup-interrupt-handler signal-list signal-handle-func)
  (unless (null? signal-list)
    (register-signal-handler (car signal-list) signal-handle-func)
    (setup-interrupt-handler (cdr signal-list) signal-handle-func)))

(define (main)
  (enableRawMode)
  (initEditor)
  (setup-interrupt-handler '(2 3 20) interrupt-handler)
  (set! current-edit-file (get-file-name (command-line)))
  
  (create-file-if-not-exist current-edit-file)
  
  (when (file-exists? init-file)
    (load init-file))
  
  (editorOpen current-edit-file)
  (editorSetStatusMessage "HELP: C-x C-s = save | C-x C-c = quit | C-s = find")
  (main-loop))

(main)
