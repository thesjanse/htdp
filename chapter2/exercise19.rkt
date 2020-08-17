#lang racket

(require rackunit)

(define (string-insert str index)
    (cond ((<= (string-length str) 0)
                (string-append "_"))
          ((= index 0)
                (string-append "_" (substring str (+ 1 index))))
          ((= index (- (string-length str) 1))
                (string-append (substring str 0 index) "_"))
          ((and (not (= index 0)) (not (= index (- (string-length str) 1))))
                (string-append (substring str 0 index) "_" (substring str (+ index 1)))
                )

    )
    
    
    )

(check-equal? (string-insert "Hello!" 0) "_ello!")
(check-equal? (string-insert "" 0) "_")
(check-equal? (string-insert "hey" 2) "he_")
(check-equal? (string-insert "hey" 1) "h_y")
