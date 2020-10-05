#lang racket
(require lang/posn)

; distances in term of pixels
(define HEIGHT 200)
(define MIDDLE (quotient HEIGHT 2))
(define WIDTH 400)
(define CENTER (quotient WIDTH 2))

(define-struct game
    [left-player right-player ball])

(define game0
    (make-game MIDDLE MIDDLE (make-posn CENTER CENTER)))

; evaluate the following expressions
(game-ball game0)
; (game-ball (make-game MIDDLE MIDDLE (make-posn CENTER CENTER)))
; (make-posn CENTER CENTER)
; (200 200)

(posn? (game-ball game0))
; (posn? (game-ball (make-game MIDDLE MIDDLE (make-posn CENTER CENTER))))
; (posn? (make-posn CENTER CENTER))
; (#t)

(game-left-player game0)
; (game-left-player (make-game (MIDDLE MIDDLE (make-posn CENTER CENTER))))
; (MIDDLE)
; (100)