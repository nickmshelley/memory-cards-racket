#lang racket/gui

(define frame 
  (new frame%
       [label "Memory Cards"]
       [width 500]
       [height 500]))

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
       [font (send the-font-list find-or-create-font
                   20 'default 'normal 'bold)]))

(for ([name (list "Scriptures" "Another")])
  (new button%
       [parent categories-panel]
       [label name]))

(define category-panel
  (new vertical-panel%
       [parent main-panel]
       [style '(border auto-vscroll)]))

(send frame show #t)
