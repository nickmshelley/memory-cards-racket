#lang racket

(define (today-minus num-days)
  (define seconds-in-day
    (* 60 60 24))
  (seconds->date
   (- (current-seconds)
      (* num-days seconds-in-day))))