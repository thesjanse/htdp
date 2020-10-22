#lang racket

(require rackunit 2htdp/image 2htdp/universe)

(define-struct editor [pre post] #:transparent)
; An Editor is a structure:
; (make-editor String String)
; interpretation: (make-editor s t) describes
; an editor whose visible text is (string-append s t)
; with the cursor displayed between s and t

(define E1 (make-editor "hello" "world"))
(define E2 (make-editor "hello " "world"))
(define E3 (make-editor "" "helloworld"))
(define E4 (make-editor "helloworld" ""))
(define EMPTY (make-editor "" ""))
(define MAX-PRE
    (make-editor "Hey! This is a new text editor" ""))
(define MAX-POST
    (make-editor "" "Hey! This is a new text editorr"))

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


; Editor -> Image
; render the text field
(define (render ed)
    (overlay/align "left" "center"
        (beside (text (editor-pre ed) TEXT-SIZE TEXT-COLOR) CUR
                (text (editor-post ed) TEXT-SIZE TEXT-COLOR))
     BACKGROUND))

(check-equal? (render E1)
    (overlay/align "left" "center"
        (beside (text (editor-pre E1) TEXT-SIZE TEXT-COLOR) CUR
                (text (editor-post E1) TEXT-SIZE TEXT-COLOR))
     BACKGROUND))

(check-equal? (render E2)
    (overlay/align "left" "center"
        (beside (text (editor-pre E2) TEXT-SIZE TEXT-COLOR) CUR
                (text (editor-post E2) TEXT-SIZE TEXT-COLOR))
     BACKGROUND))

; Editor -> Number
; get the width of rendered editor
(define (get-width ed)
    (image-width
        (beside (text (editor-pre ed) TEXT-SIZE TEXT-COLOR) CUR
                (text (editor-post ed) TEXT-SIZE TEXT-COLOR))))

(check-equal? (get-width MAX-PRE) 199)
(check-equal? (get-width MAX-POST) 204)


; Editor 1String -> Editor
; append 1String to editor-pre
(define (writer ed str)
    (define new-ed
        (make-editor
            (string-append
                (editor-pre ed) str)
                (editor-post ed)))
    (cond
        [(> (get-width new-ed) (- WIDTH 2)) ed]
        [else new-ed]))

(check-equal? (writer E1 "a")
    (make-editor "helloa" "world"))
(check-equal? (writer E1 " ")
    (make-editor "hello " "world"))
(check-equal? (writer E1 "Z")
    (make-editor "helloZ" "world"))
(check-equal? (writer MAX-PRE "a") MAX-PRE)
(check-equal? (writer MAX-POST "Z") MAX-POST)


; String -> String
; remove last character from string
(define (remove-last str)
    (define length (string-length str))
    (cond
        [(< length 1) str]
        [else (substring str 0 (- length 1))]))

(check-equal? (remove-last "hello") "hell")
(check-equal? (remove-last "h") "")
(check-equal? (remove-last "") "")


; String -> String
; remove first character from string
(define (remove-first str)
    (define length (string-length str))
    (cond
        [(< length 1) str]
        [else (substring str 1)]))

(check-equal? (remove-first "hello") "ello")
(check-equal? (remove-first "h") "")
(check-equal? (remove-first "") "")


; Editor -> Editor
; remove last character from editor-pre
(define (remove ed)
    (make-editor (remove-last (editor-pre ed))
                 (editor-post ed)))

(check-equal? (remove E1) (make-editor "hell" "world"))
(check-equal? (remove E2) (make-editor "hello" "world"))
(check-equal? (remove E3) (make-editor "" "helloworld"))
(check-equal? (remove E4) (make-editor "helloworl" ""))
(check-equal? (remove EMPTY) EMPTY)


; String -> 1String
; get the last character of string
(define (get-last str)
    (define length (string-length str))
    (cond
        [(<= 0 length 1) str]
        [else (substring str (- length 1) length)]))

(check-equal? (get-last "hello") "o")
(check-equal? (get-last "h") "h")
(check-equal? (get-last "") "")


; String -> String
; get the first character of string
(define (get-first str)
    (define length (string-length str))
    (cond
        [(<= 0 length 1) str]
        [else (substring str 0 1)]))

(check-equal? (get-first "ello") "e")
(check-equal? (get-first "h") "h")
(check-equal? (get-first "") "")


; Editor -> Editor
; move last editor-pre character to editor-post
(define (move-left ed)
    (make-editor (remove-last (editor-pre ed))
                 (string-append (get-last (editor-pre ed))
                                          (editor-post ed))))

(check-equal? (move-left E1) (make-editor "hell" "oworld"))
(check-equal? (move-left E2) (make-editor "hello" " world"))
(check-equal? (move-left E3) E3)
(check-equal? (move-left E4) (make-editor "helloworl" "d"))
(check-equal? (move-left EMPTY) EMPTY)


; Editor -> Editor
; move first editor-post character to editor-pre
(define (move-right ed)
    (make-editor (string-append (editor-pre ed)
                                (get-first (editor-post ed)))
                 (remove-first (editor-post ed))))

(check-equal? (move-right E1) (make-editor "hellow" "orld"))
(check-equal? (move-right E2) (make-editor "hello w" "orld"))
(check-equal? (move-right E3) (make-editor "h" "elloworld"))
(check-equal? (move-right E4) E4)
(check-equal? (move-right EMPTY) EMPTY)


; Editor KeyEvent -> Editor
; handle keyboard input of the editor
; KeyEvent is one of the following:
; -- [A, Z] and [a, z] 1Strings: add character to editor-pre
; -- " ": add space to editor-pre
; -- "\b": remove character from editor-pre
; -- "left": move one character to the left
; -- "right": move one character to the right
(define (edit ed ke)
    (cond
        [(and (equal? (string-length ke) 1)
              (not (or (string=? ke "\b")
                       (string=? ke "\t")
                       (string=? ke "\r")))) (writer ed ke)]
        [(string=? ke "\b") (remove ed)]
        [(string=? ke "left") (move-left ed)]
        [(string=? ke "right") (move-right ed)]
        [else ed]))

(check-equal? (edit E1 "a") (make-editor "helloa" "world"))
(check-equal? (edit E1 "Z") (make-editor "helloZ" "world"))
(check-equal? (edit EMPTY "k") (make-editor "k" ""))
(check-equal? (edit EMPTY "L") (make-editor "L" ""))
(check-equal? (edit MAX-PRE "a") MAX-PRE)
(check-equal? (edit MAX-PRE "A") MAX-PRE)
(check-equal? (edit MAX-POST "A") MAX-POST)
(check-equal? (edit MAX-POST "A") MAX-POST)

(check-equal? (edit E1 " ") (make-editor "hello " "world"))
(check-equal? (edit E3 " ") (make-editor " " "helloworld"))
(check-equal? (edit E4 " ") (make-editor "helloworld " ""))
(check-equal? (edit EMPTY " ") (make-editor " " ""))
(check-equal? (edit MAX-PRE " ") MAX-PRE)
(check-equal? (edit MAX-POST " ") MAX-POST)

(check-equal? (edit E1 "\b") (make-editor "hell" "world"))
(check-equal? (edit E2 "\b") (make-editor "hello" "world"))
(check-equal? (edit E3 "\b") (make-editor "" "helloworld"))
(check-equal? (edit E4 "\b") (make-editor "helloworl" ""))
(check-equal? (edit EMPTY "\b") EMPTY)
(check-equal? (edit MAX-PRE "\b")
    (make-editor "Hey! This is a new text edito" ""))
(check-equal? (edit MAX-POST "\b") MAX-POST)

(check-equal? (edit E1 "\t") E1)
(check-equal? (edit EMPTY "\t") EMPTY)
(check-equal? (edit MAX-POST "\t") MAX-POST)
(check-equal? (edit MAX-POST "\t") MAX-POST)

(check-equal? (edit E1 "\r") E1)
(check-equal? (edit EMPTY "\r") EMPTY)
(check-equal? (edit MAX-PRE "\r") MAX-PRE)
(check-equal? (edit MAX-PRE "\r") MAX-PRE)

(check-equal? (edit E1 "left") (make-editor "hell" "oworld"))
(check-equal? (edit E2 "left") (make-editor "hello" " world"))
(check-equal? (edit E3 "left") E3)
(check-equal? (edit E4 "left") (make-editor "helloworl" "d"))
(check-equal? (edit EMPTY "left") EMPTY)
(check-equal? (edit MAX-PRE "left")
    (make-editor "Hey! This is a new text edito" "r"))
(check-equal? (edit MAX-POST "left") MAX-POST)

(check-equal? (edit E1 "right") (make-editor "hellow" "orld"))
(check-equal? (edit E2 "right") (make-editor "hello w" "orld"))
(check-equal? (edit E3 "right") (make-editor "h" "elloworld"))
(check-equal? (edit E4 "right") E4)
(check-equal? (edit EMPTY "right") EMPTY)
(check-equal? (edit MAX-PRE "right") MAX-PRE)
(check-equal? (edit MAX-POST "right")
    (make-editor "H" "ey! This is a new text editorr"))


(define (main ws)
    (big-bang ws
        [to-draw render]
        [on-key edit]))

(main E2)