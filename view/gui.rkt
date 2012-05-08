#lang racket/gui
(require rackunit
         "db.rkt"
         "category.rkt")

(define (today-minus num-days)
  (define seconds-in-day
    (* 60 60 24))
  (seconds->date
   (- (current-seconds)
       (* num-days seconds-in-day))))

(define frame 
  (new frame%
       [label "Memory Cards"]
       [width 500]
       [height 500]))

(define title-font (send the-font-list find-or-create-font
                         20 'default 'normal 'bold))

(define main-panel
  (new horizontal-panel%
       [parent frame]))

(define categories-panel
  (new vertical-panel% 
       [parent main-panel]
       [style '(border auto-vscroll)]
       [alignment '(left top)]
       [stretchable-width #f]))

(define categories-title
  (new message%
       [parent categories-panel]
       [label "Categories"]
       [font title-font]))

(define no-category-panel
  (new horizontal-panel%
       [parent main-panel]
       [style '(border)]
       [alignment '(center center)]))

(for ([name (get-categories db-connection)])
  (new button%
       [parent categories-panel]
       [label name]))

(define no-category-title
  (new message%
       [parent no-category-panel]
       [label "Choose a category on the left"]
       [font title-font]))

#;(define (display-category cat)
  (define pan
    (new vertical-panel%
         [parent main-panel]
         [style '(border auto-vscroll)]))
  (new message%
       [parent pan]
       [label (category-name cat)]
       [font title-font])
  (display-stats cat pan)
  pan)

#;(define (display-stats cat parent)
  (define pan (new vertical-panel%
                   [parent parent]
                   [alignment '(left top)]))
  (define levels (review-levels (category-cards cat)))
  (new message%
       [parent pan]
       [label "Review Level\t\tTotal\tNeeds Review\tFuture Review"])
  (for ([i (in-range (add1 (apply max levels)))])
    (define num (count (lambda (v)
                         (= v i))
                       levels))
    (new message%
         [parent pan]
         [label (format "~a:\t\t~a" i num)])))

#;(define (review-levels cards)
  (map card-review-level cards))
       

(send frame show #t)
