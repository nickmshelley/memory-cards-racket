#lang racket/gui
(require "../model/db.rkt"
         "common.rkt"
         (prefix-in category: "../model/category.rkt")
         (prefix-in card: "card.rkt"))

(provide init)

(define title-font (send the-font-list find-or-create-font
                         20 'default 'normal 'bold))
(define categories-panel #f)
(define category-panel #f)

(define (init parent)
  (set! categories-panel
        (new vertical-panel% 
             [parent parent]
             [style '(border auto-vscroll)]
             [alignment '(left top)]
             [stretchable-width #f]))
  (set! category-panel
        (new vertical-panel%
             [parent parent]
             [style '(border auto-vscroll)]))
  (define title-panel
    (new horizontal-panel%
         [parent categories-panel]
         [stretchable-height #f]))
  (new message%
       [parent title-panel]
       [label "Categories"]
       [font title-font])
  (new button%
       [parent title-panel]
       [label "+"]
       [callback (lambda (b e) (add-category))])
  (show-categories)
  (show-empty-category))

(define (show-empty-category)
  (send category-panel change-children
        (lambda (l)
          (list
           (new message%
                [parent category-panel]
                [label "Choose a category on the left"]
                [font title-font])))))

(define (show-categories)
  (send categories-panel change-children update-categories))

(define (update-categories children)
  (cons (first children)
        (for/list ([name (category:get-categories db-connection)])
          (new button%
               [parent categories-panel]
               [label name]
               [callback (lambda (b e) (show-category name))]))))

(define (show-category name)
  (send category-panel change-children 
        (lambda (l) (update-category l name))))

(define (update-category children name)
  (define title
    (new message%
         [parent category-panel]
         [label name]
         [font title-font]))
  (define button-panel
    (new horizontal-panel% [parent category-panel]
         [stretchable-height #f]))
  (new button% [parent button-panel] [label "Delete Category"]
       [callback (lambda (b e) (delete-category name))])
  (new button% [parent button-panel] [label "Add Card"]
       [callback (lambda (b e)
                   (card:add-card name)
                   (show-category name))])
  (new button% [parent button-panel] [label "Review"]
       [callback (lambda (b e) (review-category name))])
  (new button% [parent button-panel] [label "Review Reverse"]
       [callback (lambda (b e) (review-reverse name))])
  (list title button-panel))

;Handler functions

(define (add-category)
  (show-text-entry-dialog
   "Enter Category Name"
   "Name:"
   (lambda (name)
     (category:add-category db-connection name)))
  (show-categories))

(define (delete-category name)
  (show-ok-cancel-dialog (format "Delete ~a?" name)
                         "This will delete all cards in the category as well."
                         (lambda () 
                           (category:delete-category db-connection name)
                           (show-categories)
                           (show-empty-category))))

(define (review-category name)
  (void))

(define (review-reverse name)
  (void))






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