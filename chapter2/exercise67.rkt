#lang racket

(define SPEED 3)
(define-struct balld [location direction])
(define one (make-balld 10 "up"))
(balld-location one)
(balld-direction one)
(balld? one)

(define two (make-balld 20 "down"))
(balld-location two)
(balld-direction two)
(balld? two)