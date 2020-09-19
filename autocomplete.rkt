;;
;; **************************************************************
;;    Raymond Li <racket@raymond.li>
;;    Code completion for Racket
;;    Last updated 2020-09-18
;;    Modified from complete-word from quickscript extras repo
;; **************************************************************
;;

#lang racket/base
(require racket/class
         racket/dict
         racket/list
         quickscript)

(script-help-string "Autocomplete by https://Raymond.Li")
;; Replaces the text abbreviation right before the caret with stuff

(define words
  '(
    ; custom:
    ("cx"  "(check-expect (" ") )")
    ("cw"  "(check-within (" ")  tolerance)")
    ("ce"  "(check-error (" ") )")
    ("df"  "(define (" ")\n  ())")
    ("d"  "(define " ")")
    ("t"   "true" "")
    ("f"   "false" "")

    ; custom design recipe:
    ("hdr"  ";;
;; ***************************************************
;;    Raymond Li (studentID)
;;    CS 135 Fall 2020
;;    Assignment " ", Problem 
;; ***************************************************
;;\n")
    ("cmt"  ";;\n;; " "\n;;")
    (";"  ";; " "")
    (";;"  ";;   " "")
    ("ppe"  ";; (" ") \n;; Examples:\n")
    ("ctr"  ";; " ":  -> \n")
    ("req"  ";; Requires: " "\n")
    ("tst"  ";; Tests:\n" "")
    
    #| Defaults from complete-word plugin of quickscript extras
    ("dsr"   "(define-syntax-rule (" ")\n  )")
    ("ds"    "(define-syntax " "\n  )")
    ("sr"    "(syntax-rules ()\n    [(_ " ")])")
    ("sc"    "(syntax-case stx ()\n    [(_ " ")])")
    ("dsm"   "(define-simple-macro (" ")\n  )")
    ("lbd"   "(λ (" ") ")
    ("param" "(parameterize ([current-" "])\n  )")
    ("wh"    "(with-handlers ([exn:" "])\n  )")
    ("wiff"  "(with-input-from-file " "\n  (λ _ ))")
    ("wotf"  "(with-output-to-file " " #:exists 'replace\n  (λ _ ))")
    
    ; slideshow:
    ("slide"    "(slide #:title \"" "\"\n       )")
    ("item"     "@item{" "}")
    ("subitem"  "@subitem{" "}")
    ("$"        "@${" "}")
    ("$$"       "@$${" "}")
    |#))

(define-script autocomplete
  #:label "Autocomplete"
  #:shortcut #\ 
  #:shortcut-prefix (ctl)
  (λ (s #:editor ed) 
    (define pos (send ed get-end-position)) 
    (define str
      (send ed get-text 
            (send ed get-backward-sexp pos) 
            pos))
    (define str-ext (dict-ref words str #f))
    (define left (if (list? str-ext) (first str-ext) str-ext))
    (define right (and (list? str-ext) (second str-ext)))
    (when str-ext
      (send ed begin-edit-sequence)
      (send ed select-backward-sexp)
      (send ed insert left)
      (when right
        (define ipos (send ed get-start-position))
        (send ed insert right)
        (send ed set-position ipos))
      (send ed end-edit-sequence))
    #f))
  
#;(
   item
   para
   wh
   $$
   )
