#lang racket
(require lang/posn)

(define-struct nested-ball [location velocity])
(define-struct velocity [deltax deltay])
(define nst-ball
    (make-nested-ball
        (make-posn 30 40)
        (make-velocity -10 5)))
(velocity-deltax (nested-ball-velocity nst-ball))
(posn-x (nested-ball-location nst-ball))

(define-struct flat-ball
    [location velocity deltax deltay])
(define flt-ball
    (make-flat-ball
        30 40 -10 5))
(flat-ball-location flt-ball)
(flat-ball-velocity flt-ball)
(flat-ball-deltax flt-ball)
(flat-ball-deltay flt-ball)
(flat-ball? flt-ball)
(nested-ball? flt-ball)