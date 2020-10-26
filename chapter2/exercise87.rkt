#lang racket

; TODO finish render

(require rackunit 2htdp/image 2htdp/universe)

(define-struct editor [text pos] #:transparent)
; Editor is a structure
; (make-editor String Number)
; interpretation: (make-editor text pos)
; desribes the editor with text and
; cursor position (number of characters)
; between the first character and the cursor

(define E1 (make-editor "helloworld" 5))
(define E2 (make-editor "hello world" 6))
(define E3 (make-editor "helloworld" 0))
(define E4 (make-editor "helloworld" 10))
(define EMPTY (make-editor "" 0))
(define PRE-MAX-START
    (make-editor "Hey! This is a new text editor" 0))
(define PRE-MAX-END
    (make-editor "Hey! This is a new text editor" 30))
(define POST-MAX-START
    (make-editor "Hey! This is a new text editorr" 0))
(define POST-MAX-END
    (make-editor "Hey! This is a new text editorr" 31))

; physical constants
(define TEXT-SIZE 16)
(define TEXT-COLOR "black")
(define CUR-WIDTH 1)
(define CUR-HEIGHT 20)
(define CUR-COLOR "red")
(define WIDTH 200)
(define HEIGHT 20)

; graphical constants
(define BACKGROUND
    (empty-scene WIDTH HEIGHT))
(define CUR
    (rectangle CUR-WIDTH CUR-HEIGHT
               "solid" CUR-COLOR))


; String Number -> String
; get string prior to cursor
(define (get-prestring str pos)
    (substring str 0 pos))

(check-equal?
    (get-prestring
        (editor-text E1)
        (editor-pos E1))
    "hello")

(check-equal?
    (get-prestring
        (editor-text E2)
        (editor-pos E2))
    "hello ")


; String Number -> String
; get string after the cursor
(define (get-poststring str pos)
    (substring str pos (string-length str)))

(check-equal?
    (get-poststring
        (editor-text E1)
        (editor-pos E1))
    "world")

(check-equal?
    (get-poststring
        (editor-text E2)
        (editor-pos E2))
    "world")


; Editor -> Number
; convert cursor position to pixels
(define (pos-to-pixels ed)
    (image-width
        (text
            (get-prestring
                (editor-text ed)
                (editor-pos ed))
            TEXT-SIZE TEXT-COLOR)))

(check-equal? (pos-to-pixels E1)
    (image-width
        (text
            (get-prestring
                (editor-text E1)
                (editor-pos E1))
            TEXT-SIZE TEXT-COLOR)))

(check-equal? (pos-to-pixels E2)
    (image-width
        (text
            (get-prestring
                (editor-text E2)
                (editor-pos E2))
            TEXT-SIZE TEXT-COLOR)))


; Editor -> Image
; render the editor into text box
(define (render ed)
    (overlay/align/offset "left" "center"
        CUR (- (pos-to-pixels ed)) 0
        (overlay/align "left" "center"
            (text (editor-text ed) TEXT-SIZE TEXT-COLOR)
        BACKGROUND)))

(check-equal? (render E1)
    (overlay/align/offset "left" "center"
        CUR (- (pos-to-pixels E1)) 0
        (overlay/align "left" "center"
            (text (editor-text E1) TEXT-SIZE TEXT-COLOR)
        BACKGROUND)))

(check-equal? (render E2)
    (overlay/align/offset "left" "center"
        CUR (- (pos-to-pixels E2)) 0
        (overlay/align "left" "center"
            (text (editor-text E2) TEXT-SIZE TEXT-COLOR)
        BACKGROUND)))


; Editor 1String -> Editor
; append 1String to Editor after editor-pos
(define (write ed str)
    (make-editor
        (string-append
            (get-prestring (editor-text ed) (editor-pos ed))
            str
            (get-poststring (editor-text ed) (editor-pos ed)))
        (+ 1 (editor-pos ed))))

(check-equal? (write E1 "b")
    (make-editor
        (string-append
            (get-prestring (editor-text E1) (editor-pos E1))
            "b"
            (get-poststring (editor-text E1) (editor-pos E1)))
        (+ 1 (editor-pos E1))))
(check-equal? (write E1 "Z")
    (make-editor
        (string-append
            (get-prestring (editor-text E1) (editor-pos E1))
            "Z"
            (get-poststring (editor-text E1) (editor-pos E1)))
        (+ 1 (editor-pos E1))))
(check-equal? (write EMPTY "c")
    (make-editor
        (string-append
            (get-prestring (editor-text EMPTY) (editor-pos EMPTY))
            "c"
            (get-poststring (editor-text EMPTY) (editor-pos EMPTY)))
        (+ 1 (editor-pos EMPTY))))
(check-equal? (write EMPTY "Y")
    (make-editor
        (string-append
            (get-prestring (editor-text EMPTY) (editor-pos EMPTY))
            "Y"
            (get-poststring (editor-text EMPTY) (editor-pos EMPTY)))
        (+ 1 (editor-pos EMPTY))))


; Editor KeyEvent -> Editor
; handle KeyEvents and edit editor string accordingly
(define (edit ed ke)
    (cond
        [(equal? (string-length ke) 1) (write ed ke)]
        [else ed]))

(check-equal? (edit E1 "a") (make-editor "helloaworld" 6))
(check-equal? (edit E1 "Z") (make-editor "helloZworld" 6))
(check-equal? (edit EMPTY "k") (make-editor "k" 1))
(check-equal? (edit EMPTY "L") (make-editor "L" 1))
(check-equal? (edit PRE-MAX-START "a") PRE-MAX-START)
(check-equal? (edit PRE-MAX-END "A") PRE-MAX-END)
(check-equal? (edit POST-MAX-START "A") POST-MAX-START)
(check-equal? (edit POST-MAX-END "A") POST-MAX-END)



;;; (define (main ws)
;;;     (big-bang ws
;;;         [to-draw render]))

;;; (main E2)