#lang racket

(require lang/posn)

; create examples for the following data
; definition:

; A Color is one of the:
; -- "white"
; -- "yellow"
; -- "orange"
; -- "green"
; -- "red"
; -- "blue"
; -- "black"

(define WHITE "white")
(define RED "red")
(define YELLOW "yellow")
(define ORANGE "orange")
(define GREEN "green")
(define BLUE "blue")
(define BLACK "black")


; H is a Number between 0 and 100.
; interpretation represents a happiness value
(define H-ZERO 0)
(define H-MAX 100)
(define H-MIDDLE 50)


(define-struct person [fstname lstname male?])
; Person is a structure:
; (make-person String String Boolean), where
; -- "fstname" is a String first name of a person
; -- "lstname" is a String last name of a person
; -- "male?" is a Boolean indicator if person is a male

(define JOHN (make-person "John" "Doe" #t))
(define JANE (make-person "Jane" "Doe" #f))


(define-struct dog [owner name age happiness])
; Dog is a structure:
; (make-dog String String PositiveInteger H)
; -- "owner" name of the dog owner
; -- "name" name of the dog
; -- "age" is age of the dog Interval [0, infinity]
; -- "happiness" dog happiness Interval [0, 100]

(define DOG-A
    (make-dog "John Doe" "Rex" 5 100))
(define DOG-B
    (make-dog "Jane Doe" "Pluto" 1 20))


; Weapon is one of:
; -- #false
; -- Posn
; interpretation: #false means the missile hasn't
; been fired yet; Posn means it's in flight

(define WEAPON-A (#f))
(define WEAPON-B (make-posn 0 1))
(define WEAPON-C (make-posn 1 0))
(define WEAPON-D (make-posn 2 16))