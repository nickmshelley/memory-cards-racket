#lang racket/gui
(require rackunit
         "common.rkt"
         (prefix-in category: "category.rkt"))

(define frame 
    (new frame%
         [label "Memory Cards"]
         [width 800]
         [height 500]))

(set-frame! frame)

(define (main)
  
  (define main-panel
    (new horizontal-panel%
         [parent frame]))
  
  (category:init main-panel)
  
  (send frame show #t))

(main)