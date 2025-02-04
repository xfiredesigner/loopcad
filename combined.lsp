; *****************************************
; File: C:\LoopCAD\Lisp\block-definitions.lsp
; *****************************************
; DXF Code Reference Document
; https://images.autodesk.com/adsk/files/autocad_2012_pdf_dxf-reference_enu.pdf
; Head Label Properties
 
(setq head-label:tag-string "HEADNUMBER")
(setq head-label:prompt "Head number label")
(setq head-label:label-color color-blue)
(setq head-label:layer "HeadLabels")
(setq head-label:x-offset 3.0)
(setq head-label:y-offset 0.0)

; Tee Label Properties
(setq tee-label:tag-string "TEENUMBER")
(setq tee-label:prompt "Tee number label")
(setq tee-label:label-color color-green)
(setq tee-label:layer "TeeLabels")
(setq tee-label:x-offset 4.0)
(setq tee-label:y-offset 4.0)

; Riser Label Properties
(setq riser-label:tag-string "RISERNUMBER")
(setq riser-label:prompt "Riser number label")
(setq riser-label:layer "RiserLabels")
(setq riser-label:label-color color-green)

; Head Model Properties
; Insert Point: 9.132, 8.395 copied from old block so it looks the same
(setq head-block:model-x-offset 9.132)
(setq head-block:model-y-offset 8.395)

(defun define-labelsx ()
    (princ "\nDoing nothing\n")
)
(defun define-labels ()
    ; These two block definitions are not used by any functions but they are defined so that
    ; a user can use the "INSERT" command to insert them manually if they want.
    (define-label-block 
        "HeadLabel" 
        head-label:tag-string 
        head-label:prompt 
        "H.0" 
        head-label:label-color 
        head-label:layer
        head-block:model-x-offset    ; Label X Offset
        0                              ; Label Y Offset
    )
    (define-label-block 
        "TeeLabel" 
        tee-label:tag-string
        tee-label:prompt 
        "T.0" 
        tee-label:label-color
        tee-label:layer
        head-block:model-x-offset    ; Label X Offset
        0                              ; Label Y Offset
    )
    (define-label-block 
        "RiserLabel" 
        riser-label:tag-string
        riser-label:prompt 
        "R.0.X" 
        riser-label:label-color
        riser-label:layer
        head-block:model-x-offset    ; Label X Offset
        0                              ; Label Y Offset
    )
    ;;(define-head-coverage 12)
    ;;(define-head-coverage 14)
    ;;(define-head-coverage 16)
    ;;(define-head-coverage 18)
    ;;(define-head-coverage 20)
    ; (define-sw-head-coverage 12 "U") ; Sprays Up
    ; (define-sw-head-coverage 14 "U")
    ; (define-sw-head-coverage 16 "U")
    ; (define-sw-head-coverage 18 "U")
    ; (define-sw-head-coverage 20 "U")
    ; (define-sw-head-coverage 12 "D") ; Sprays Down
    ; (define-sw-head-coverage 14 "D")
    ; (define-sw-head-coverage 16 "D")
    ; (define-sw-head-coverage 18 "D")
    ; (define-sw-head-coverage 20 "D")
    ; (define-sw-head-coverage 12 "L") ; Sprays Left
    ; (define-sw-head-coverage 14 "L")
    ; (define-sw-head-coverage 16 "L")
    ; (define-sw-head-coverage 18 "L")
    ; (define-sw-head-coverage 20 "L")
    ; (define-sw-head-coverage 12 "R") ; Sprays Right
    ; (define-sw-head-coverage 14 "R")
    ; (define-sw-head-coverage 16 "R")
    ; (define-sw-head-coverage 18 "R")
    ; (define-sw-head-coverage 20 "R")    
    (define-floor-tag)
    (define-riser)
    (princ "\nLabels defined.\n")
    (princ)
)

(defun define-head-coverage (coverage)
    (define-head-block coverage "Head" "MODEL" "Head model" "MODEL" color-red "Heads")
)

(defun define-sw-head-coverage (coverage direction)
    (define-sw-head-block direction coverage "Head" "MODEL" "Head model" "MODEL" color-red "Heads")
)

(defun define-label-block (block-name tag-string prompt default label-color layer label-x-offset label-y-offset)
    (entmake 
        (list
            (cons 0 "BLOCK")
            (cons 2 block-name) ; Block name
        )
    )
    (entmake 
        (list
            (cons 0 "ATTDEF")
            (cons 10 (list label-x-offset label-y-offset 0))
            (cons 1 default)      ; Text value
            (cons 2 tag-string)   ; Tag string
            (cons 3 prompt)       ; Prompt string
            (cons 40 5.0)         ; Text height
            (cons 7 "ARIAL")      ; Text style
            (cons 62 color-yellow) ; Color
            (cons 8 layer)        ; Layer
        )
    )
    (entmake 
        (list
            (cons 0 "ENDBLK")
        )
    )
)

; Side-wall Head Block
(defun define-sw-head-block (direction coverage block-name tag-string prompt default label-color layer / span halfway quarter coverage-text t-left-x t-left-y t-right-x t-right-y t-top-x t-top-y t-vertical c-ll-x c-ll-y c-lr-x c-lr-y c-ur-x c-ur-y c-ul-x c-ul-y text-center-x text-center-y model-label-x model-label-y)
    (entmake 
        (list
            (cons 0 "BLOCK")
            (cons 2 (strcat "Sw" block-name (itoa coverage) direction)) ; Block name
        )
    )
    
    ; Head Model Number
    (setq model-label-x head-block:model-x-offset)
    (setq model-label-y head-block:model-y-offset)
    ;(cond ((= direction "D")
    ;        (setq model-label-y (- 0 model-label-y)))
    ;    ((= direction "L")
    ;        (setq model-label-x (- 0 model-label-x)))
    ;)
    (entmake 
        (list
            (cons 0 "ATTDEF")
            (cons 10 
                (list 
                    model-label-x
                    model-label-y
                    0.0
                )
            )
            (cons 1 default)      ; Text value
            (cons 2 tag-string)   ; Tag string
            (cons 3 prompt)       ; Prompt string
            (cons 40 5.0)         ; Text height
            (cons 7 "ARIAL")      ; Text style
            (cons 62 label-color) ; Color
            (cons 8 layer)        ; Layer
        )
    )
    
    ; Head
    ; Triangle
    ; Default direction "U" (not in the cond below)
    (setq t-left-x -6)
    (setq t-right-x 6)            
    (setq t-left-y 12)
    (setq t-right-y 12)        
    (cond ((= direction "D")
            (setq t-left-x 6)
            (setq t-right-x -6)
            (setq t-left-y -12)
            (setq t-right-y -12)                    
        )
        ((= direction "L")
            (setq t-left-x -12)
            (setq t-right-x -12)                    
            (setq t-left-y 6)
            (setq t-right-y -6)        
        )
        ((= direction "R")
            (setq t-left-x 12)
            (setq t-right-x 12)
            (setq t-left-y 6)
            (setq t-right-y -6)        
        )
    )
    (entmake
        (list
            (cons 0 "POLYLINE")
            (cons 10 (list 0 0 0))  ; Point is always zero
            (cons 70 1)             ; 1 = Closed Polyline
            (cons 62 color-red)  ; Color
            (cons 8 layer) ; Layer
        )
    )
    (entmake
        (list
            (cons 0 "VERTEX")
            (cons 10 (list t-left-x t-left-y 0)) ; Left
        )
    )
    (entmake
        (list
            (cons 0 "VERTEX")
            (cons 10 (list t-right-x t-right-y 0)) ; Right
        )
    )
    (entmake
        (list
            (cons 0 "VERTEX")
            (cons 10 (list 0 0 0))    ; Top
        )
    )
    (entmake
        (list
            (cons 0 "SEQEND")
        )
    )
    
    ; Head Coverage Box
    (setq span (feet->inches coverage))
    (setq -span (- 0 span))
    (setq halfway (/ span 2))
    (setq -halfway (- 0 halfway))
    (setq quarter (/ span 4))

    (setq c-ll-x -halfway)
    (setq c-ll-y 0)
    (setq c-lr-x halfway)
    (setq c-lr-y 0)
    (setq c-ur-x halfway)
    (setq c-ur-y span)
    (setq c-ul-x -halfway)
    (setq c-ul-y span)
    (setq text-center-x 0)
    (setq text-center-y halfway)
    
    (cond ((= direction "D")
            (setq c-ll-x -halfway)
            (setq c-ll-y -span)
            (setq c-lr-x halfway)
            (setq c-lr-y -span)
            (setq c-ur-x halfway)
            (setq c-ur-y 0)
            (setq c-ul-x -halfway)
            (setq c-ul-y 0)
            (setq text-center-x 0)
            (setq text-center-y -halfway))
        ((= direction "L")
            (setq c-ll-x -span)
            (setq c-ll-y -halfway)
            (setq c-lr-x 0)
            (setq c-lr-y -halfway)
            (setq c-ur-x 0)
            (setq c-ur-y halfway)
            (setq c-ul-x -span)
            (setq c-ul-y halfway)
            (setq text-center-x -halfway)
            (setq text-center-y 0))
        ((= direction "R")
            (setq c-ll-x 0)
            (setq c-ll-y -halfway)
            (setq c-lr-x span)
            (setq c-lr-y -halfway)
            (setq c-ur-x span)
            (setq c-ur-y halfway)
            (setq c-ul-x 0)
            (setq c-ul-y halfway)
            (setq text-center-x halfway)
            (setq text-center-y 0))
    )
    (entmake
        (list
            (cons 0 "POLYLINE")
            (cons 10 (list 0 0 0))  ; Point is always zero
            (cons 70 1)             ; 1 = Closed Polyline
            (cons 62 color-yellow)  ; Color
            (cons 8 "HeadCoverage") ; Layer
        )
    )
    (entmake
        (list
            (cons 0 "VERTEX")
            (cons 10 (list c-ll-x c-ll-y 0)) ; Lower Left
        )
    )
    (entmake
        (list
            (cons 0 "VERTEX")
            (cons 10 (list c-lr-x c-lr-y 0)) ; Lower Right
        )
    )
    (entmake
        (list
            (cons 0 "VERTEX")
            (cons 10 (list c-ur-x c-ur-y 0)) ; Upper Right
        )
    )
    (entmake
        (list
            (cons 0 "VERTEX")
            (cons 10 (list c-ul-x c-ul-y 0)) ; Upper Left
        )
    )
    (entmake
        (list
            (cons 0 "SEQEND")
        )
    )
    
    ; Coverage Text 
    ; Example: 12' x 12'
    (setq coverage-text 
        (strcat (itoa coverage) "'  X  " (itoa coverage) "'")
    )
    (entmake
        (list
            (cons 0 "TEXT")
            (cons 10 (list span span 0)) ; Upper left corner
            (cons 11 (list text-center-x text-center-y 0)) ; Second alignment point, center of text
            (cons 40 16.0)         ; Text height
            (cons 1 coverage-text) ; Text value
            (cons 72 1) ; Horizontal text justification: 1 = Center, 4 = Middle
            (cons 73 2) ; Vertical text justification: 2 = Middle
            (cons 62 color-yellow)  ; Color
            (cons 8 "HeadCoverage") ; Layer
        )
    )
    (entmake 
        (list
            (cons 0 "ENDBLK")
        )
    )
)

; Head Block (Normal)
(defun define-head-block (coverage block-name tag-string prompt default label-color layer / span halfway quarter coverage-text)
    (setq acadObj (vlax-get-acad-object))
    (setq doc (vla-get-ActiveDocument acadObj))
    
    (setq 
        innerCircleRadius 2.275
        outerCircleRadius 6.653
    )
    ;; Define the Circle object that will be inserted into the block
    (setq centerPoint (vlax-3d-point 0 0 0)
          InsertPoint (vlax-3d-point 1 1 0)
          radius 0.5)
    
    ;; Create a new block to hold the Circle object
    (setq blocks (vla-get-Blocks doc))
    (setq newBlock (vla-Add blocks centerPoint (strcat "Head" (itoa coverage))))
    ;(vla-put-layer newBlock "Heads")
  
    ;; Add the Circle object to the new block object
    (setq innerCircle (vla-AddCircle newBlock centerPoint innerCircleRadius))
    (setq outerCircle (vla-AddCircle newBlock centerPoint outerCircleRadius))

    (vla-put-layer innerCircle "Heads")
    (vla-put-layer outerCircle "Heads")
  
    (vla-put-color innerCircle 1) ; 1 = Red
    (vla-put-color outerCircle 1) ; 1 = Red
    
    ; Head Coverage Box
    (setq span (feet->inches coverage))
    (setq -span (- 0 span))
    (setq halfway (/ span 2))
    (setq -halfway (- 0 halfway))
    (setq quarter (/ span 4))
        
      ;; Define the 2D polyline points
    (setq points (vlax-make-safearray vlax-vbDouble '(0 . 9)))
    (vlax-safearray-fill 
        points 
        (list 
          -halfway -halfway   ;  (cons 10 (list -halfway -halfway 0)) ; Lower Left
          halfway -halfway ;  (cons 10 (list halfway -halfway 0))    ; Lower Right
          halfway halfway ; (cons 10 (list halfway halfway 0))    ; Upper Right
          -halfway halfway ; (cons 10 (list -halfway halfway 0))    ; Upper Left
          -halfway -halfway
        )
    )
        
    ;; Create a lightweight Polyline object in model space
    (setq plineObj (vla-AddLightWeightPolyline newBlock points))
    (vla-put-layer plineObj "HeadCoverage")
    (vla-put-color plineObj 2) ; 2 = Yellow
  
    ;   ; Coverage Text 
    ;   ; Example: 12' x 12'
        (setq coverage-text 
           (strcat (itoa coverage) "'  X  " (itoa coverage) "'")
       )
  
    ;(setq modelSpace (vla-get-ModelSpace doc))
    (setq textObj (vla-AddText newBlock coverage-text  (vlax-3d-point -halfway halfway 0) 16.0))
    (vla-put-color textObj 2)
    (vla-put-layer textObj "HeadCoverage")
    
    (vla-addattribute 
      newBlock    ; Block
      9.0         ; Height
      acAttributeModeLockPosition  ; Mode
      ""; Prompt
      centerPoint ; Insertion Point
      "MODEL"     ; Tag
      "MOD-123"   ; Value
    )
  
)

; Head Block (Normal)
(defun define-head-block-old (coverage block-name tag-string prompt default label-color layer / span halfway quarter coverage-text)
    (entmake 
        (list
            (cons 0 "BLOCK")
            (cons 2 (strcat block-name (itoa coverage))) ; Block name
        )
    )
    
    ; Head Model Number
    (entmake 
        (list
            (cons 0 "ATTDEF")
            (cons 10 
                (list 
                    head-block:model-x-offset 
                    head-block:model-y-offset 
                    0.0
                )
            )
            (cons 1 default)      ; Text value
            (cons 2 tag-string)   ; Tag string
            (cons 3 prompt)       ; Prompt string
            (cons 40 5.0)         ; Text height
            (cons 7 "ARIAL")      ; Text style
            (cons 62 label-color) ; Color
            (cons 8 layer)        ; Layer
        )
    )
    
    ; Head
    ; Inner Circle
    (entmake
        (list
            (cons 0 "CIRCLE")     
            (cons 10 (list 0 0 0)) ; Center Point
            ; Radius: 2.278 copeid from old block so it looks the same
            (cons 40 2.278)        ; Radius
            (cons 62 color-red)    ; Color
            (cons 8 layer)         ; Layer
        )
    )
    ; Outer Circle
    (entmake
        (list
            (cons 0 "CIRCLE")      
            (cons 10 (list 0 0 0)) ; Center Point
            ; Radius: 6.653 copeid from old block so it looks the same
            (cons 40 6.653)        ; Radius
            (cons 62 color-red)    ; Color
            (cons 8 layer)         ; Layer
        )
    )
    
    ; Head Coverage Box
    (setq span (feet->inches coverage))
    (setq -span (- 0 span))
    (setq halfway (/ span 2))
    (setq -halfway (- 0 halfway))
    (setq quarter (/ span 4))
    (entmake
        (list
            (cons 0 "POLYLINE")
            (cons 10 (list 0 0 0))  ; Point is always zero
            (cons 70 1)             ; 1 = Closed Polyline
            (cons 62 color-yellow)  ; Color
            (cons 8 "HeadCoverage") ; Layer
        )
    )
    (entmake
        (list
            (cons 0 "VERTEX")
            (cons 10 (list -halfway -halfway 0)) ; Lower Left
        )
    )
    (entmake
        (list
            (cons 0 "VERTEX")
            (cons 10 (list halfway -halfway 0))    ; Lower Right
        )
    )
    (entmake
        (list
            (cons 0 "VERTEX")
            (cons 10 (list halfway halfway 0))    ; Upper Right
        )
    )
    (entmake
        (list
            (cons 0 "VERTEX")
            (cons 10 (list -halfway halfway 0))    ; Upper Left
        )
    )
    (entmake
        (list
            (cons 0 "SEQEND")
        )
    )
    
    ; Coverage Text 
    ; Example: 12' x 12'
    (setq coverage-text 
        (strcat (itoa coverage) "'  X  " (itoa coverage) "'")
    )
    (entmake
        (list
            (cons 0 "TEXT")
            (cons 10 (list span span 0)) ; Upper left corner
            (cons 11 (list 0 quarter 0)) ; Second alignment point, center of text
            (cons 40 16.0)         ; Text height
            (cons 1 coverage-text) ; Text value
            (cons 72 1) ; Horizontal text justification: 1 = Center, 4 = Middle
            (cons 73 2) ; Vertical text justification: 2 = Middle
            (cons 62 color-yellow)  ; Color
            (cons 8 "HeadCoverage") ; Layer
        )
    )
    (entmake 
        (list
            (cons 0 "ENDBLK")
        )
    )
)

; Floor Tag
(defun define-floor-tag ( / label-color layer )
   (defun *error* (message)
      (princ)
      (princ message)
      (princ)
    )
    (setq layer "FloorTags")
    (entmake 
        (list
            '(0 . "BLOCK")
            '(2 . "FloorTag") ; Block name
            (cons 8 layer)      ; Layer (recommended)
            '(10 0.0 0.0 0.0)         ; required
            '(70 . 2)                 ; required [NOTE 0 if no attributes]
            '(100 . "AcDbEntity")     ; recommended
            '(100 . "AcDbBlockBegin") ; recommended
        )
    )

    (entmake 
        '(
            (0 . "ATTDEF")
            (1 . "Main Floor")   ; Default value
            (2 . "NAME")         ; Tag name
            (3 . "Enter floor name")
            (8 . "FloorTag")     ; Layer
            (10 10.0 -10.0 0.0)  ; Coordinates
            (40 . 9.0)   ; Text Size (KEEP)
            (62 . 4)     ; Color (4 = Cyan)
            (70 . 0)     ; Attribute Flags (KEEP)
        )
    )
    
    (entmake 
        '(
            (0 . "ATTDEF")
            (1 . "100")         ; Default value
            (2 . "ELEVATION")   ; Tag name
            (3 . "Enter elevation in feet")
            (8 . "FloorTag")    ; Layer
            (10 10.0 -20.0 0.0) ; Coordinates
            (40 . 9.0)    ; Text Size (KEEP)
            (62 . 4)      ; Color (4 = Cyan)
            (70 . 0)      ; Attribute Flags (KEEP)
        )
    )
    
    ; Outer Circle
    (entmake
        (list
            '(0 . "CIRCLE")      
            '(10 0 0 0)       ; Center Point
            ; Radius: 7.71 copied from old block so it looks the same
            '(40 . 7.71)      ; Radius
            '(62 . 4)         ; Color (4 = Cyan)
            (cons 8 layer)    ; Layer
        )
    )
    
    ; Vertical Line
    (entmake
        (list
            '(0 . "POLYLINE")
            '(10 0 0 0)              ; Point is always zero
            '(70 . 1)                ; 1 = Closed Polyline
            (cons 62 color-cyan)     ; Color
            (cons 8 layer)           ; Layer
        )
    )
    (entmake
        '(
            (0 . "VERTEX")
            (10 7.71 0 0) ; Top
        )
    )
    (entmake
        '(
            (0 . "VERTEX")
            (10 -7.71 0 0)    ; Bottom
        )
    )
    (entmake
        '(
            (0 . "SEQEND")
        )
    )

    ; Horizontal Line
    (entmake
        '(
            (0 . "POLYLINE")
            (10 0 0 0)           ; Point is always zero
            (70 . 1)             ; 1 = Closed Polyline
            (62 . 4)             ; 4: color-cyan; Color
            (8 . "FloorTags")    ; Layer
        )
    )
    (entmake
        '(
            (0 . "VERTEX")
            (10 0 -7.71 0) ; Left
        )
    )
    (entmake
        '(
            (0 . "VERTEX")
            (10 0 7.71 0)    ; Right
        )
    )
    (entmake
        '(
            (0 . "SEQEND")
        )
    )

    (entmake 
        '(
            (0 . "ENDBLK")
            (100 . "AcDbBlockEnd") ; recommended
            (8 . "0")              ; recommended
        )
    )
)

; Convert feet to inches
(defun feet->inches (feet)
    (* feet 12)
)

;(defun add-default-layers ( x / headLayer layers )
    (setq acadObj (vlax-get-acad-object))
    (setq temp:doc (vla-get-ActiveDocument acadObj))
    (setq temp:layers (vla-get-layers temp:doc))
    (setq headLayer (vla-Add temp:layers "Heads"))
    (setq headCoverageLayer (vla-Add temp:layers "HeadCoverage"))  
    (setq headPairsLayer (vla-Add temp:layers "HeadPairs"))  
    (setq pipesLayer (vla-Add temp:layers "Pipes"))  
    (setq pipesLayer (vla-Add temp:layers "Tees"))  

    (command "-LAYER" "COLOR" "White" "Pipes" "")
    (command "-LAYER" "COLOR" "Yellow" "HeadPairs" "")
    (command "-LAYER" "COLOR" "White" "Tee" "")
;)
; *****************************************
; File: C:\LoopCAD\Lisp\break-pipes.lsp
; *****************************************
; Functions called by the BREAK-PIPES command.
(defun break-pipes-delete-old ( / old-pipes)
    (setq old-pipes (get-all-pipes))
    (foreach pipe (break-all-pipes)
        (make-pipe (car pipe) (cdr pipe))
    )
    ; Delete all old pipes
    (foreach pipe old-pipes (entdel (cdr (assoc -1 pipe))))
)
    
(defun break-all-pipes ( / size node-point all-nodes seg new-vertices new-pipes old-pipes pt start end vertex i vertices)
    (setq new-pipes '())
    (setq old-pipes (get-all-pipes))
    (setq all-nodes (get-all-nodes))
    (foreach pipe old-pipes
        (setq i 0)
        (setq size (get-pipe-size pipe))                    
        (setq vertices (get-vertices pipe))
        (setq new-vertices '())
        (while (< i (length vertices))
            (setq vertex (nth i vertices))            
            (setq new-vertices (cons vertex new-vertices))
            (setq seg (segment i vertices))
            (if (and (> i 0) (< i (1- (length vertices)))) ; not the first or last vertex index
                (foreach node all-nodes
                    (setq node-point (get-ins-point node))
                    (setq dist (distance vertex node-point))
                    (if (< dist near-line-margin)
                        (progn 
                            (if (> (length new-vertices) 0)
                                (progn
                                    (setq new-vertices (cons size new-vertices))
                                    (setq new-pipes (cons new-vertices new-pipes))
                                )
                            )                            

                            (setq new-vertices '())
                            (setq new-vertices (cons vertex new-vertices))
                        )
                    )
                )
            )
            (setq i (1+ i))
        )
        (if (> (length new-vertices) 0)
            (progn
                (setq new-vertices (cons size new-vertices))
                (setq new-pipes (cons new-vertices new-pipes))
            )
        )
    )
    new-pipes
)

; Should return five points 
(defun test-remove-repeated-points ()
    (remove-repeated-points 
        '(
            (1.0 1.0 0.0)
            
            (1.0 2.0 0.0)
            
            (2.0 3.0 0.0)
            (2.0 3.0 0.0)
            (2.0 3.0 0.0)
            
            (3.0 3.0 0.0)
            (3.0 3.0 0.0)
            
            (3.0 4.0 0.0)
        )
    )
)

(defun remove-repeated-points (points / last-pt output)
    (setq output '())
    (foreach point points
        (if (not (are-same-point last-pt point))
            (progn
                (setq output (cons point output))
                (setq last-pt point)
            )
            (progn
            
                (setq last-pt point)
            )
        )
    )
    (reverse output)
)


(defun test-segments ( / pipe)
    (foreach pipe (get-all-pipes)
        (princ "\nPipe\n")
        (princ (segments pipe))
    )
)

(defun segments (polyline / i next last-i seg vertices output)
    (setq output '())
    (setq vertices (get-vertices polyline))
    (setq last-i (- (length vertices) 2)) ; grabbing pairs, so don't grab the last one
    (setq i 0)
    (while (<= i last-i)
        (setq seg (segment i vertices))
        (setq output (cons seg output))
        (setq i (1+ i))
    )
    (reverse output)
)

(defun segment (index vertices / next output)
    (setq output '())
    (setq next (1+ index))                
    (setq output (cons (nth next vertices) output))
    (setq output (cons (nth index vertices) output))
)

; Manual test, click the ends of the line, then click points near
; the line. Small red circles appear if they are not near the line
; and green circles appear that are near the line.
(defun test-near-line ( / a b p)
    (setq a (getpoint))
    (setq b (getpoint))

    (print-point "a" a)
    (print-point "b" b)
    (while T
        (setq p (getpoint))
        (print-point "p" p)

        (if (near-line p a b)
            (command "-COLOR" "green")
            (command "-COLOR" "red")
        )
        (command "-CIRCLE" p 1.0)
    )
)

; How close a point has to be to a line to be considered near it.
(setq near-line-margin 5.0)

; *** This function not called from anywhere anymore ***
; *** I might keep it around because it could be handy ***

; Is 'p' near or on the line segment between 'a' and 'b'?
(defun near-line (p a b / int pp)
    ; Draw an imaginary line from p perpendicular to a-b
    (setq pp (perp-point (list a b) p))
    (if (in-box p a b)
        (progn
            ; Find the intersection between the imaginary perpendicular
            ; line and a-b.
            (setq int (inters a b pp p nil))
            (if int
                (if (< (distance p int) near-line-margin)
                    T ; near the line
                    nil
                )
                (if (are-same-point p pp) 
                    T ; on the line
                    nil
                )
            )
        )
        nil
    )
)


; Compares only x and y but not z of 'a' and 'b' coordinates
(defun are-same-point (a b)
    (and (= (getx a) (getx b)) (= (gety a) (gety b)))
)

; Auto test 'in-box' function
(defun test-auto-in-box ( / a b)
    (princ "\ntest-auto-in-box: ")
    (setq a (list -500 -400 0) )
    (setq b (list 1000 2000 0))
    (if (and
            (not (in-box (list 1001 0 0) a b))
            (not (in-box (list -501 0 0) a b))
            (not (in-box (list 0 -401 0) a b))
            (not (in-box (list 0 2001 0) a b))
            (in-box (list 0 0 0) a b) ; This one should be in the box
        )
        (princ "PASS\n")
        (princ "FAIL\n")
    )
    (princ)
)

; Is point 'p' in the box between the corners defined by 'a' and 'b'
(defun in-box (p a b / x y maxx maxy minx miny)
    (setq maxx (max (getx a) (getx b)))
    (setq maxy (max (gety a) (gety b)))
    (setq minx (min (getx a) (getx b)))
    (setq miny (min (gety a) (gety b)))
    (setq x (getx p))
    (setq y (gety p))
    (if (and (< x maxx)
            (< y maxy)
            (> x minx)
            (> y miny)
        )
        T    ; p is in the box
        nil  ; p is not in the box
    )
)

; Should return '(1000 100)
(defun test-perp-point ( / )
    (perp-point (list (list 100 100 0) (list 2000 100 0)) (list 1000 1000 0))
)

; Perpendicular line from 'point' through 'line'
; If the line has a zero or infinite slope return 'point'
(defun perp-point (line point / x y s perp-slope)
    (setq s (slope (car line) (cadr line)))
    (cond ((= 0 s) ; Zero slope                
            (list (getx point) (gety point))
        )
        ((= "Infinity" s) ; Infinite slope            
            (list (getx point) (gety point))
        )
        (T ; Normal slope
            (list  
                (+ 100 (getx point)) 
                (+ (* 100 (negative-reciprocal s)) (gety point))
            )
        )
    )
)

(defun get-all-pipes ( / en ent pipes layer) 
    (setq pipes '())
    (setq en (entnext))
    (while en
        (setq ent (entget en))
        (if (and (or (strstartswith "PIPES." (get-layer en))
                    (strstartswith "PIPE." (get-layer en))
                    (str= "PIPE" (get-layer en))
                    (str= "PIPES" (get-layer en))
                )
                (or (str= "LWPOLYLINE"(get-etype en))
                    (str= "POLYLINE" (get-etype en))
                )
            )
            (setq pipes (cons ent pipes))
        )
        (setq en (entnext en))
    )
    pipes
)

; *****************************************
; File: C:\LoopCAD\Lisp\commands.lsp
; *****************************************
(defun C:SET-HEAD-DATA () (head-data-set))
(defun C:SET-HEAD-MODEL () (head-model-set))
(defun C:SET-HEAD-COVERAGE () (head-coverage-set))
(defun C:SET-HEAD-SLOPE () (head-slope-set))
(defun C:SET-HEAD-TEMP () (head-temperature-set))
(defun C:HEAD () (head-insert-select-coverage))
(defun C:HEAD-12 () (head-insert-coverage "12"))
(defun C:HEAD-14 () (head-insert-coverage "14"))
(defun C:HEAD-16 () (head-insert-coverage "16"))
(defun C:HEAD-18 () (head-insert-coverage "18"))
(defun C:HEAD-20 () (head-insert-coverage "20"))
(defun C:SWHEAD () (swhead-insert-user))
(defun C:PIPE () (pipe-draw "?"))
(defun C:PIPE-12 () (pipe-draw "1/2"))
(defun C:PIPE-34 () (pipe-draw "3/4"))
(defun C:PIPE-75 () (pipe-draw "3/4"))
(defun C:PIPE-1 () (pipe-draw "1"))
(defun C:PIPE-112 () (pipe-draw "1-1/2"))
(defun C:PIPE-15 () (pipe-draw "1-1/2"))
(defun C:ELEVATION-BOX () (elevation-box-draw))
(defun C:TEE () (tee-insert))
(defun C:DTEE () (domestic-tee-insert))
(defun C:LABEL-NODES () (label-all-nodes))
(defun C:LABEL-PIPES () (label-all-pipes))
(defun C:BREAK-PIPES () (break-pipes-delete-old))
(defun C:PAIR () (head-pair))
(defun C:RISER () (riser-insert))
(defun C:FLOOR-TAG () (floor-tag-insert))
(defun C:JOB () (job-data-dialog))

(princ) ; exit quietly
; *****************************************
; File: C:\LoopCAD\Lisp\contains.lsp
; *****************************************
(defun contains (target list / output result)
    (setq result nil)
    (foreach item list
        (if (eq (strcase item) (strcase target))
            (setq result T)
        )
    )
    result
)
; *****************************************
; File: C:\LoopCAD\Lisp\data-change-default.lsp
; *****************************************
(defun data-change-default (key message / value old-value)
    (setq old-value (data-request key))
    (setq value (getstring (strcat "\n" message " <" old-value "> :")))
    (if (not (= value ""))
        (data-submit key value)
    )
)

(defun data-request (key)
   (getcfg (strcat "AppData/LoopCAD/" key))
)

(defun data-submit (key value)
    (setcfg (strcat "AppData/LoopCAD/" key) value)
)
; *****************************************
; File: C:\LoopCAD\Lisp\elevation-box.lsp
; *****************************************
(defun elevation-box-draw (/ a b p1 p2 p3 p4 top bottom left right points)
    (setq old-osmode (getvar "OSMODE"))
    (setq temperror *error*)
    (defun *error* (message)
        (princ)
        (princ "Error")
        (princ message)
        (princ)
        (setvar "OSMODE" old-osmode)
        (command-s "-COLOR" "BYLAYER")
        (command-s "-LAYER" "SET" "0" "")
        (setq *error* temperror)
    )
    (setvar "OSMODE" 0)
    (setq a (getpoint "\nElevation box first corner:"))
    (setq b (getcorner a))
        (if (null elevation) 
        (setq elevation 100)
        (princ (strcat "Default elevation set to " (itoa elevation)))
    )
    (setq elevation (getint (strcat "\nEnter elevation (ft): <" (itoa elevation) ">")))
    
    (setq right (greatest (car a) (car b)))
    (setq top  (greatest (cadr a) (cadr b)))
    (setq left (least (car a) (car b)))
    (setq bottom (least (cadr a) (cadr b)))
    ; (setq p1 (list left top))
    ; (setq p2 (list right top))
    ; (setq p3 (list right bottom))
    ; (setq p4 (list left bottom))
 
    (command "-COLOR" "BYLAYER" "")
    (command "-LINETYPE" "SET" "Continuous" "")
    (command "-LAYER" "NEW" "ElevationBox" "")
    (command "-LAYER" "COLOR" "Magenta" "ElevationBox" "")
    (command "-LAYER" "SET" "ElevationBox" "")
    ;(command "-PLINE" p1 p2 p3 p4 p1 "")
    ;(command "-MTEXT" p1 p3 (strcat "Elevation " (itoa elevation)) "") 
    
    ;; Creates a lightweight polyline in model space.
    (setq acadObj (vlax-get-acad-object))
    (setq doc (vla-get-ActiveDocument acadObj))

    ;; Define the 2D polyline points
    (setq points (vlax-make-safearray vlax-vbDouble '(0 . 9)))
    (vlax-safearray-fill 
        points 
        (list 
          left top
          right top
          right bottom
          left bottom
          left top
        )
    )
        
    ;; Create a lightweight Polyline object in model space
    (setq modelSpace (vla-get-ModelSpace doc))
    (setq plineObj (vla-AddLightWeightPolyline modelSpace points))
    (vla-put-layer plineObj "ElevationBox")
   
    ;; Define the mtext object
    (setq corner (vlax-3d-point a)
          width (abs (- right left))
          text (strcat "Elevation " (itoa elevation))
    )

    ;; Creates the mtext object
    (setq modelSpace (vla-get-ModelSpace doc))
    (setq MTextObj (vla-AddMText modelSpace corner width text))
    (vla-put-height MTextObj 10.0)
    (vla-put-layer MTextObj "ElevationBox")

    ; Set things back
    (command "-COLOR" "BYLAYER")
    (command "-LAYER" "SET" "0" "")
    (setvar "OSMODE" old-osmode)
    (setq *error* temperror)
    (princ)
)

(defun get-elevation-boxes ( / en ent boxes layer) 
    (setq boxes '())
    (setq en (entnext))
    (while en
        (setq ent (entget en))
        (if (and (or (str= "ElevationBox" (get-layer en))
                    (str= "ElevationBoxes" (get-layer en))
                    (str= "Elevation Box" (get-layer en))
                    (str= "Elevation Boxes" (get-layer en))
                )
                (or (str= "LWPOLYLINE"(get-etype en))
                    (str= "POLYLINE" (get-etype en))
                )
            )
            (setq boxes (cons ent boxes))
        )
        (setq en (entnext en))
    )
    boxes
)

(defun get-elevation-text ( / en ent boxes layer) 
    (setq boxes '())
    (setq en (entnext))
    (while en
        (setq ent (entget en))
        (if (and (or (str= "ElevationBox" (get-layer en))
                    (str= "ElevationBoxes" (get-layer en))
                    (str= "Elevation Box" (get-layer en))
                    (str= "Elevation Boxes" (get-layer en))
                )
                (or (str= "MTEXT"(get-etype en))
                    (str= "TEXT" (get-etype en))
                )
            )
            (setq boxes (cons ent boxes))
        )
        (setq en (entnext en))
    )
    boxes
)

(defun get-polyline-vertices ( ent / en vertex vertices) 
    (setq vertices '())
    (princ "\nGetting entity name...\n")
    (setq en (get-ename ent))
    (princ (strcat "\n Entity Name: " en))
    (setq en (entnext en))
   (princ (strcat "\n Next Entity Name: " en))
    (setq ent (entget en))
    (while en
        (cond ((str= "VERTEX" (get-etype ent))
                (setq ent (entget en))
                (setq vertex (get-ins-point ent))
                (setq vertices (cons vertex vertices))
                (setq en (entnext en))
                (setq ent (entget en))
            )
            (T (setq en nil))
        )
    )
    vertices
)

(defun test-get-elevation ( / )
    ;(princ "\nTesting: test-ebox\n")
    ; TODO: Add some elevation boxes, 2 at least
    (princ "\nShould return 102: ")
    (princ (get-elevation (list 4342.29 1633.89 0.000000)))
    (princ "\nShould return 109: ")
    (princ (get-elevation (list 4224.10 1672.70 0.000000)))
    (princ "\n")
)

; Find the smallets elevation box point 'p' is in, 
; return the elevation.
(defun get-elevation ( p / box boxes a b i ar in-areas all-areas m vertex vertices text-box text-boxes smallest-box elevation)
    (setq elevation "0")
    (setq in-areas '())

    ; Get a list of all boxes that the point p is in
    (setq boxes (get-elevation-boxes))
    (foreach box boxes
        (progn 
            (setq a (car (corners box)))
            (setq b (cadr (corners box)))
            (setq ar (area a b))
            (setq all-areas (append all-areas (list ar)))    
            (if (in-ebox p box)
                (setq in-areas (append in-areas (list ar)))
            )
        )
    )

    ; Find the smallest box, which should be the inner-most box
    (setq m (apply 'min in-areas))
    (setq i (index-of m all-areas))
    (setq smallest-box (nth i boxes))
    

    (if (not (null smallest-box))
        (progn
            ; Match the smallest (elevation) box to it's MText containing the elevation text
            (setq vertices (get-vertices smallest-box))
            (setq text-boxes (get-elevation-text))
            (foreach vertex vertices
                (foreach text-box text-boxes                    
                  (setq insPoint (get-ins-point text-box))
                  (setq insPoint2D (list (nth 0 insPoint) (nth 1 insPoint)))
                  (if (< (distance vertex insPoint) near-line-margin)
                      ; This text-box belongs to this elevation box
                      (setq elevation (elevation-from text-box))                                     
                  )
                )
            )
        )
    )
    ; Return the elevation of the inner-most elevation box
    (atoi elevation)
)

; Get numeric elevation value from MText entity
(defun elevation-from ( text-box / )
    ; Input Example: "Elevation 999"
    ; Digits start at position 11
    (substr (text-from text-box) 11)
)

; TODO: Try vla-get-text
; Get text from MText entity
(defun text-from ( text-box / )
    (cdr (assoc 1 text-box))                    
)

; Is the point 'p' inside the polyline 'box'
(defun in-ebox ( p box / a b vertices )
    (setq a (car (corners box))) ; First corner
    (setq b (cadr (corners box))) ; Opposite corner
    (in-box p a b)
)

; Returns opposite corners of a box made of a four point polyline
(defun corners ( rectangle / a b vertices )
    (setq vertices (get-vertices rectangle))
    (setq a (nth 0 vertices)) ; First corner
    (setq b (nth 2 vertices)) ; Opposite corner    
    (list a b )
)
; *****************************************
; File: C:\LoopCAD\Lisp\entities.lsp
; *****************************************

(defun get-blocks ( layers / en ent blocks) 
    (setq blocks '())
    (setq en (entnext))
    (while en
        (setq ent (entget en))
        (if (and (list-contains (get-layer en) layers)
                (str= (get-etype en) "INSERT")
            )
            (setq blocks (cons ent blocks))
        )
        (setq en (entnext en))
    )
    blocks
)

; Returns a list of entity names that are owned by 'ename'
(defun get-attributes (ename / en attributes layer) 
    (setq attributes '())
    (setq en (entnext))
    (while en
        (if (and (= "ATTRIB" (get-etype en)) (= ename (get-owner-name en)))
            (progn
                (setq attributes (cons en attributes))
            )
        )
        (setq en (entnext en))
    )
    attributes
)

; Returns entity name of attribute entity owned by 'ename'
(defun get-attribute (ename tag-string / att att-tag-string att-value output)
    (foreach att (get-attributes ename)
        ; Find by tag name: (2 . "TAG NAME")
        (progn
            (setq att-tag-string (cdr (assoc 2 (entget att))))
            ;(setq att-value (cdr (assoc 1 (entget att))))
            (if (str= tag-string att-tag-string) 
                (setq output att)
            )
        )
    )
    output
)

(defun set-attribute (ename tag-string val / en ent)
    (setq en (get-attribute ename tag-string))
    (if (null val) (setq val "")) ; Value cannot be nil
    (if en
        (progn
            (setq ent (entget en))
            (setq ent 
                (subst 
                    (cons 1 val)  ; New replacement value
                    (assoc 1 ent) ; Old value
                    ent           ; Entity list
                )
            )     
            (entmod ent)
        )
        nil
    )
)

(defun get-attribute-value (ename tag-string / attr-entity)
    (setq attr-entity (entget (get-attribute ename tag-string)))
    ; Return attribute value from: (1 . "VALUE HERE")
    (cdr (assoc 1 attr-entity))
)
; *****************************************
; File: C:\LoopCAD\Lisp\entity-creators.lsp
; *****************************************
; Quick ways to create entities without using commands

(defun make-circle (center radius color layer)
    (entmakex 
        (list 
            (cons 0 "CIRCLE")
            (cons 10 center)
            (cons 40 radius)
            (cons 8 layer) ; Layer 
            (cons 62 color) ; Color
        )
    )
)


(defun make-polyline (vertices color layer)
    (entmakex 
        (list 
            (cons 0 "POLYLINE")
            (cons 8 layer) ; Layer 
            (cons 62 color) ; Color
            (cons 40 pipe-width) ; Starting width
            (cons 41 pipe-width) ; Ending width
            (cons 10 '(0 0 0)) ; Always zero 'Dummy pont'
        )
    )
    (mapcar 
        'make-vertex 
        vertices
    )
    (entmakex (list (cons 0 "SEQEND")))
)

(defun make-text (point text height color layer)
    (entmakex 
        (list 
            (cons 0 "TEXT")
            (cons 10 point)
            (cons 1 text)
            (cons 40 height)
            (cons 62 color)
            (cons 8 layer) ; Layer     
        )
    )
)
                 
(defun make-mtext (pt text)
    (entmakex 
        (list 
            (cons 0 "MTEXT")         
            (cons 100 "AcDbEntity")
            (cons 100 "AcDbMText")
            (cons 10 pt)
            (cons 1 text)
        )
    )
)

(defun make-block-insert (point block-name layer)
    (entmake ; Removed x
        (list 
            (cons 0 "INSERT")
            (cons 10 point)
            (cons 2 block-name)
            (cons 8 layer)
            (cons 66 1)
        )
    )
    (entlast)
)
; *****************************************
; File: C:\LoopCAD\Lisp\floors.lsp
; *****************************************

(defun floor-tag-insert ( / p old-osmode elevation floor-name)
    (setq old-osmode (getvar "OSMODE"))
    (defun *error* (message)
        (princ)
        (princ message)
        (princ)
        (setvar "OSMODE" old-osmode)
        (setvar "LWDISPLAY" 1)
    )
    
    (setvar "INSUNITS" 1) ; 0 = not set, 1 = inches, 2 = feet
    (setvar "OSMODE" osmode-snap-ins-pts)
    (command "-LAYER" "NEW" "Floor Tags" "")
    (command "-LAYER" "COLOR" "Cyan" "Floor Tags" "")
    (setvar "LWDISPLAY" 0)
    (command "-LAYER" "SET" "Floor Tags" "")
    (setq p (getpoint "Click insertion point for floor tag"))
    (setq floor-name (getstring T "Enter floor name")) ; getstring with T allows spaces
    (setq elevation (get-elevation p))
    (princ (strcat "Elevation: " (itoa elevation)))
  
    (setq acadObj (vlax-get-acad-object))
    (setq doc (vla-get-ActiveDocument acadObj))
    
    ; Insert the block
    (setq insertionPoint (vlax-3d-point p))
    (setq modelSpace (vla-get-ModelSpace doc))
    (setq block (vla-InsertBlock modelSpace insertionPoint "FloorTag" 1 1 1 0))
  
    ; get the block attributes
    (setq attributes (vlax-safearray->list (vlax-variant-value (vla-getAttributes block))))
    
    ; Set attribute values by the attribute position
    (vla-put-TextString (nth 0 attributes) floor-name)
    (vla-put-TextString (nth 1 attributes) elevation)
)

(defun riser-insert ( / p w old-osmode tag tags tag-elevation p-elevation offset tag-offset)
    (setq old-osmode (getvar "OSMODE"))
    (defun *error* (message)
        (princ)
        (princ message)
        (princ)
        (setvar "OSMODE" old-osmode)
        (setvar "LWDISPLAY" 1)
    )
    (setvar "INSUNITS" 1) ; 0 = not defined 1 = inches 2 = feet
    (setvar "OSMODE" osmode-snap-ins-pts)
    (command "-LAYER" "NEW" "Risers" "")
    (command "-LAYER" "COLOR" "White" "Risers" "")
    (setvar "LWDISPLAY" 0)
    (command "-LAYER" "SET" "Risers" "")
    (command "-INSERT" "FloorConnector" pause 1.0 1.0 0)
    
    (setq p (cdr (assoc 10 (entget (entlast))))) ; Get insertion point
    (setq p-elevation (get-elevation p))
    (setq tags (get-floor-tags))
    
    (setq offset (floor-tag-elevation-offset p p-elevation tags))
    
    (insert-risers offset p-elevation tags)
    (princ "\nInsert Riser: Done\n")
    (princ)
)

; Insert corresponding risers (floor connectors)
(defun insert-risers ( offset p-elevation tags / tag-elevation tag-offset )
    (foreach tag tags
        (progn
            (setq tag-elevation (get-elevation (get-ins-point tag)))
            (if (not (= p-elevation tag-elevation))
                (progn 
                    (setq tag-offset 
                        (add-point-offset (get-ins-point tag) (- 0 (getx offset)) (- 0 (gety offset)))
                    )
                    (command "-INSERT" "Riser" tag-offset 1.0 1.0 0)
                )
            )
        )
    )
)

(defun invert-coordinates ( point )
    (list (- 0 (getx point)) (- 0 (gety point)))
)

(defun test-riser-tag-offset ( )
    (riser-tag-offset '(3906.95 1290.41 0.000000) (get-floor-tags))
)

(defun riser-labels-create ( last-i / offsets riser-groups r riser risers  riser-entity i leter letters )
    (princ "\nScanning risers and creating labels...\n")
    (setq letters (get-alphabet))
    (setq risers (get-all-risers))
    (setq offsets (riser-offsets))
    (setq riser-groups (group-by offsets))
    (setq i 0)
    (setq r 0)
    (while (< i (length riser-groups))
        (setq letter (nth i letters))
        (setq riser-group (nth i riser-groups))
        (foreach riser (cdr riser-group)
            (setq riser-entity (entget riser))
            (insert-riser-label 
                (get-ins-point riser-entity)
                (strcat "R." (itoa (+ r last-i)) "." letter)
            )
            (setq r (1+ r))
        )
        (setq i (1+ i))
    )
    (+ r last-i)
)

(defun get-alphabet ( / i letters)
    (setq letters '())
    (setq i 65)
    (while (<= i 90)
        (setq letters (append letters (list (chr i))))
        (setq i (1+ i))
    )
    letters
)


; Group, using the lists-approx function, by the first item in a list of lists
(defun group-by ( items / item output offset offsets isinlist group)
    (setq offsets '())
    (foreach item items
        (progn 
            (setq isinlist (assoc-approx (car item) offsets 1.0))
            (if (not isinlist)
                (setq offsets (cons (list (car item)) offsets))
            )    
        )
    )
    (setq output '())
    (foreach offset offsets
        (setq group offset)
        (foreach item items    
            (if (lists-approx (car offset) (car item) 1.0)
                (setq group (append group (cdr item)))
            )
        )
        (setq output (cons group output))
    )
    output
)

; Riser offsets: Associative list with offsets of riser to floor tag 
; assocated with an entity name
; Example Output: (
;   ((-0.9906 56.8205 0) <Entity name: 354c6f30>) 
;   ((-2.3058 -56.2903 0) <Entity name: 354c70c0>)
;   ((-2.3058 -56.2903 0) <Entity name: 354c70e8>)
; )
(defun riser-offsets ( / tags riser-offset riser-name riser risers group groups)
    (setq groups '())
    (setq tags (get-floor-tags))    
    (setq risers (get-all-risers))    
    (foreach riser risers
        (progn
            (setq riser-point (get-ins-point riser))
            (setq riser-offset (floor-tags-offset riser-point tags))
            (setq group '())
            (setq group (append group (list riser-offset)))
            (setq riser-name (cdr (assoc -1 riser)))
            (setq group (append group (list riser-name)))
            (setq groups (cons group groups))
        )
    )
    groups
)

; Find x,y offset of riser from it's floor tag
; TODO: Optimize: Store these in a list?
(defun floor-tags-offset (riser-point tags / tag tag-offset tag-point riser-elevation)
    (setq riser-elevation (get-elevation riser-point))
    (foreach tag tags
        (setq tag-point (get-ins-point tag))
        ; TODO: Optimize: get tag elevations and store them in a list?        
        (if (= riser-elevation (get-elevation tag-point)) ; Riser belongs to tag
            (setq tag-offset (get-point-offset riser-point tag-point))
        )
    )
    tag-offset
)

; Get the x,y coordinates offset to the nearest floor tag, 
; the tag in the same elevation box.
; Almost the same as floor-tags-offset, but elevation is input
(defun floor-tag-elevation-offset ( p p-elevation tags / tag tag-point tag-elevation offset )
    (foreach tag tags
        (progn
            (setq tag-point (get-ins-point tag))
            (setq tag-elevation (get-elevation (get-ins-point tag)))
            (if (= p-elevation tag-elevation)
                (setq offset (get-point-offset tag-point p))        
            )
        )
    )
    offset
)

(defun get-floor-tags ( / en ent tags layer) 
    (setq tags '())
    (setq en (entnext))
    (while en
        (setq ent (entget en))
        (if (and (or (str= "FloorTags" (get-layer en))
                    (str= "Floor Tags" (get-layer en))
                )
                (str= "INSERT" (get-etype en))
                (str= "FloorTag" (get-block-name en))
            )
            (setq tags (cons ent tags))
        )
        (setq en (entnext en))
    )
    tags
)
; *****************************************
; File: C:\LoopCAD\Lisp\head-data-set.lsp
; *****************************************
(defun head-model-set () 
    (data-change-default "DefaultHeadModel" "Enter Default Head Model: ")
    (princ)
)
(defun head-coverage-set () 
    (data-change-default "DefaultHeadCoverage" "Enter Default Head Coverage: ")
    (princ)
)
(defun head-slope-set () 
    (data-change-default "DefaultHeadSlope" "Enter Default Head Slope: ")
    (princ)
)
(defun head-temperature-set () 
    (data-change-default "DefaultHeadTemperature" "Enter Default Head Temperature: ")
    (princ)
)
(defun head-data-set () 
    (head-model-set)
    (head-coverage-set)
    (head-slope-set)
    (head-temperature-set)
)
; *****************************************
; File: C:\LoopCAD\Lisp\head-pair.lsp
; *****************************************
(defun head-pair ( / old-osmode old-orthomode)
    (setq old-osmode (getvar "OSMODE"))
    (setq old-orthomode (getvar "ORTHOMODE"))
    (*push-error-using-command*)
    (defun *error* (message)
        (princ)
        (princ message)
        (princ)
        (setvar "OSMODE" old-osmode)
        (setvar "ORTHOMODE" old-orthomode)
        (command-s "-COLOR" "BYLAYER")
        (command-s "-LAYER" "SET" "0" "")
    )
    (setvar "INSUNITS" 1) ;This line prevents inserted block refs from having 
    ; a different scale, being 12 time bigger than they should be
    (setvar "OSMODE" 0)
    (command-s "-LAYER" "ON" "HeadPairs" "")
    (setvar "LWDISPLAY" 0)
    (command-s "-LAYER" "SET" "HeadPairs" "")
    (setvar "OSMODE" 64) ; 64 = Snap to insertion points
    (setvar "ORTHOMODE" 0)
    (command-s "-COLOR" "BYLAYER")
    (prompt "\nDraw a line between each head pair.\n")
    (command-s "_LINE" pause)
    
    (prompt "Press the [ENTER] key or right click model space to repeat")
  
    (setvar "OSMODE" old-osmode)
    (command-s "-LAYER" "OFF" "HeadCoverage" "")
    (command-s "-LAYER" "SET" "0" "")
    (setvar "LWDISPLAY" 1)
)
; *****************************************
; File: C:\LoopCAD\Lisp\heads.lsp
; *****************************************
(if (not (data-request "DefaultHeadModel"))
    (data-submit "DefaultHeadModel" "RFC67")
)
(if (not (data-request "DefaultHeadSlope"))
    (data-submit "DefaultHeadSlope" "1")
)
(if (not (data-request "DefaultHeadTemperature"))
    (data-submit "DefaultHeadTemperature" "166")
)

; TODO: Maybe have two parameters: model-code and filename, use a separate function to determine them.
(defun head-insert (coverage / model-code pt)
    (setq old-osmode (getvar "OSMODE"))
    (setq temperror *error*)
    (defun *error* (message)
        (princ)
        (princ message)
        (princ)
      (setvar "OSMODE" old-osmode)
      (command-s "-LAYER" "OFF" "HeadCoverage" "")
      (setvar "LWDISPLAY" 1)
      (setq *error* temperror)
    )
    (setvar "INSUNITS" 1) ; 0 = not set, 1 = inches, 2 = feet
                          ; This line prevents inserted block refs from having a
                          ; different scale, being 12 times bigger than they should be.
    (setvar "OSMODE" osmode-snap-ins-pts)
    (command-s "-LAYER" "ON" "HeadCoverage" "")
    (setvar "LWDISPLAY" 0)
    (command-s "-LAYER" "SET" "Heads" "")
    (setvar "ATTREQ" 0)
    (setq model-default (load-job-data "head_model_default" "RFC43"))
    (setq model-code (strcat model-default "-" coverage))
  
    (command-s "-INSERT" (strcat "Head" coverage) pause 1.0 1.0 0 "")
  
    (setq block (vlax-ename->vla-object (entlast)))
    ; get the block attributes
    (setq attributes (vlax-safearray->list (vlax-variant-value (vla-getAttributes block))))
  
    ; Set attribute values by the attribute position
    (vla-put-TextString (nth 0 attributes) model-code)
  
    (prompt "Press the [ENTER] key or right click model space to repeat")
  
    (setvar "OSMODE" old-osmode)
    (command "-LAYER" "OFF" "HeadCoverage" "")
    (setvar "LWDISPLAY" 1)
)

(defun swhead-insert (direction model temperature / model-code pt tmp)
    (princ "\nSWHEAD-INSERT dir: ")
    (princ direction)
    (princ " model: ")
    (princ mode)
    (princ " temp: ")
    (princ temperature)
    (princ "\n")
  (setq old-osmode (getvar "OSMODE"))
  (setq temperror *error*)
  (defun *error* (message)
      (princ)
      (princ message)
      (princ)
    (setvar "OSMODE" old-osmode)
    (command "-LAYER" "OFF" "HeadCoverage" "")
    (setvar "LWDISPLAY" 1)
    (setq *error* temperror)
  )
  (setvar "INSUNITS" 1) ; This line prevents inserted block refs from having a
                        ; different scale, being 12 times bigger than they should be.
  (setvar "OSMODE" osmode-snap-ins-pts)
  (command "-LAYER" "NEW" "Heads" "")
  (command "-LAYER" "NEW" "HeadCoverage" "")
  (command "-LAYER" "COLOR" "Red" "Heads" "")
  (command "-LAYER" "COLOR" "Yellow" "HeadCoverage" "")
  (command "-LAYER" "ON" "HeadCoverage" "")
  (setvar "LWDISPLAY" 0)
  (command "-LAYER" "SET" "Heads" "")
  (while T
    (setq model-code "HEAD-X")
    (princ "\nHEAD-X happening now...")
    (command 
        "-INSERT" ; Command
        (strcat "SwHead12-20" global:head-spray-direction ".dwg") ; Block name
        pause ; Get insertion point
        1.0 ; X scale
        1.0 ; Y scale
        0 ; TODO: pause here for Rotation 
        model-code ; Model Code
    )
    (setq pt (cdr (assoc 10 (entget (entlast)))))
    (if (null global:head-coverage)
        (setq global:head-coverage "16")
    )
    (initget "12 14 16 18 20")
    (if (setq tmp (getkword (strcat "\nHead Coverage [12/14/16/18/20] <" global:head-coverage ">: ")))
        (setq global:head-coverage tmp)
    )
    (entdel (entlast))
    (setq model-code (model-code-from model global:head-coverage "" temperature))
    (prompt (strcat "\nInserting Head Model Code: " model-code "\n"))
    (prompt "\nPress Esc to quit inserting heads.\n")
    (command "-INSERT" (strcat "SwHead" global:head-coverage global:head-spray-direction) pt 1.0 1.0 0 model-code)
  )
)

(defun model-code-from (model coverage slope temperature)
    (cond
        (
            (and 
                ;(and model coverage slope temperature) 
                (> (strlen model) 0)
                (> (strlen coverage) 0)
                (> (strlen slope) 0)
                (> (strlen temperature) 0)
            )
            (strcat model "-" coverage "-" slope "-" temperature)
        )
        (
            (and 
                (> (strlen model) 0)
                (> (strlen coverage) 0)
                (> (strlen slope) 0)
            )
            (strcat model "-" coverage "-" slope)
        )
        (            
            (and 
                (> (strlen model) 0)
                (> (strlen coverage) 0)
            )
            (strcat model "-" coverage)
        )
        (
            (> (strlen model) 0)
            (strcat model)
        )
    )
)

(defun head-insert-select-coverage ( / coverage) 
    (initget "12 14 16 18 20")
    (setq coverage (getkword (strcat "\nCoverage [12/14/16/18/20]: ")))
    (head-insert coverage)
)

; Insert a side wall head, prompt user for specs
(defun swhead-insert-user ( / tmp) 
    (if (null global:head-spray-direction)
        (setq global:head-spray-direction "U")
    )
    ;(if (setq tmp (getstring (strcat "\nHead Spray Direction <" global:head-spray-direction ">: ")))
    ;    (setq global:head-spray-direction tmp)
    ;)
    (initget "U D L R")
    (setq 
        global:head-spray-direction
        (getkword 
            (strcat 
                "\nHead Spray Direction [U/D/L/R] <" 
                global:head-spray-direction
                ">: "
            )
        )
    )
    ;(setq global:head-spray-direction tmp)
    
    (if (null global:head-model)
        (setq global:head-model "RFC43")
    )
    (if (setq tmp (getstring (strcat "\nSidewall Head Model <" global:head-model ">: ")))
        (setq global:head-model tmp)
    )
    (if (null global:head-temperature)
        (setq global:head-temperature "")
    )
    (if (setq tmp (getstring (strcat "\nHead Temperature <" global:head-temperature ">: ")))
        (setq global:head-temperature tmp)
    )
    (swhead-insert
        global:head-spray-direction
        global:head-model
        ;"20" ; global:head-coverage
        ; No slope for side wall heads
        global:head-temperature
    )
)


(defun head-insert-coverage (coverage) 
    (head-insert 
       ; (data-request "DefaultHeadModel")
        coverage
       ; (data-request "DefaultHeadSlope")
       ; (data-request "DefaultHeadTemperature")
    )
)
; *****************************************
; File: C:\LoopCAD\Lisp\job-data.lsp
; *****************************************
(defun test-job-data-dialog ()
    (setq id (load_dialog "job_data.dcl"))
    (princ (strcat "\nJob Data CDL ID:" (itoa id)))
    (if (not (new_dialog "job_data" id))
        (princ "\nError loading job_data.dcl\n")
        (exit)
    )
    (unload_dialog id)
)

(defun job-data-dialog ( / id result key value block-name new-block-name )
    (setq id (load_dialog "job_data.dcl"))
    (new_dialog "job_data" id)
  
    ; Set tiles values from job_data values saved to the DWG file
    (foreach key job_data:keys 
        (progn
            (setq value (load-job-data key ""))
            (if (not (null value))
                (set_tile key value)
                (set_tile key "") ; set_tile does not accept nil as a value
            )
        )
    )
    
    (setq result (start_dialog))
    (if (= result 1) ; 1 = User clicked 'OK'
        (foreach key job_data:keys 
            (progn
                (princ "\n\nSaving job data after loading form...")
                (save-job-data key (get-dict-data "job_data_temp" key))
            )
        )
        (princ "\nUser clicked cancel. Job data not set.\n")
    )
    (unload_dialog id)
)

(setq job_data:keys 
    ; Each of these keys is a key in the job_data.dcl dialog file.
    ; They must match exactly.
    (list 
        "job_number"
        "job_name"
        "job_site_address"
        "calculated_by_company"
        "sprinkler_pipe_type"
        "sprinkler_fitting_type"
        "supply_static_pressure"
        "supply_residual_pressure"
        "supply_available_flow"
        "supply_elevation"
        "supply_pipe_type"
        "supply_pipe_size"
        "supply_pipe_internal_diameter"
        "supply_pipe_c_factor"
        "supply_pipe_length"
        "supply_name"
        "domestic_flow_added"
        "water_flow_switch_make_model"
        "water_flow_switch_pressure_loss"
        "supply_pipe_fittings_summary"
        "supply_pipe_fittings_equiv_length"
        "supply_pipe_add_pressure_loss"
        "head_model_default"
        "head_coverage_default"
    )
)

; JOB-DATA functions, called only by job_data dialog.
(defun set-job-data ( key value )
    (set-dict-data "job_data_temp" key value)
)

; Data saved to the file
; Both dictionaries are actually saved, but job_data_temp is ignored
; There's no reason to delete it
(defun load-job-data ( key default / a b)
    ; First try getting it from the "job_data" dictionary entry
    (setq a (get-dict-data "job_data" key))
    ; Next try getting it from the config in the Windows registry
    (setq b (getcfg (strcat "AppData/LoopCAD/" key)))
    ; Last, if it's in none of the above locations: return the default
    (if a a (if b b default))
)

(defun save-job-data ( key value )
    (if (= value nil)
        (set-dict-data "job_data" key "")
        (set-dict-data "job_data" key value)
    )
    nil
)

(defun get-supply-pipe-types  ()
  (list "one" "two too" "three twa")
)

; Generic DICT-DATA functions
; ****************************************************************
; Get a text value from the named dictionary
(defun get-dict-data (dict-name key / value)
    (setq value (cdr (assoc 1 (dictsearch (get-data-dict dict-name) key))))
    (if (= value nill)
        (setq value "")
    )
    value
)

; Set a text value in the named dictionary
(defun set-dict-data (dict-name key value / data-dict xrecord)
    (if (= value nil)
        (setq value "") ; We must convert any nil values to empty strings
                        ; so we don't break the DCL form which can't use
                        ; nill in a text box
    )
    (setq data-dict (get-data-dict dict-name))
    ; Check to see if the XRecord exists
    (if (setq xrecord (dictsearch data-dict key))
        (progn ; It does exist, remove it, and re-create it
            (dictremove (get-data-dict dict-name) key)
            (setq xrecord (entmakex 
                (list 
                  '(0 . "XRECORD")
                  '(100 . "AcDbXrecord")
                  (cons 1 value) ; Text value
                ))
            )
            ; Add it to the dictionary
            (if xrecord (setq xrecord (dictadd data-dict key xrecord)))
        )
        (progn ; It does not exist so create the XRecord
            (setq xrecord (entmakex 
                (list 
                  '(0 . "XRECORD")
                  '(100 . "AcDbXrecord")
                  (cons 1 value) ; Text value
                ))
            )
            ; Add it to the dictionary
            (if xrecord (setq xrecord (dictadd data-dict key xrecord)))
        )
    )
)

; Get the named dictionary, create it first if needed
(defun get-data-dict (dict-name / data-dict)
    ; If "data-dict" is already present in the main dictionary
    (if (not (setq data-dict (dictsearch (namedobjdict) dict-name)))
        ; Create the "data-dict" dictionary set the main dictionary as owner
        (progn
            (setq data-dict (entmakex '((0 . "DICTIONARY")(100 . "AcDbDictionary"))))
            ; if succesfully created, add it to the main dictionary
            (if data-dict (setq data-dict (dictadd (namedobjdict) dict-name data-dict)))
        )
        ; If "data-dict" exists then return its entity name
        (setq data-dict (cdr (assoc -1 data-dict)))
    )
)
; *****************************************
; File: C:\LoopCAD\Lisp\labels.lsp
; *****************************************
(defun label-all-pipes ( / p )
    (princ "\nLabeling pipes...\n")
    (delete-all-pipe-labels)
    (setq p (make-pipe-labels))
    (princ (strcat "\n" (itoa p) " pipes were labeled.\n"))
    (princ)
)

(defun label-all-nodes ( / n node label)
    (princ "\nLabeling nodes...\n")
    (setq n 1)
    (delete-blockrefs (get-all-head-labels))
    (foreach node (get-all-heads)
        (progn    
            (insert-head-label 
                (get-ins-point node) 
                (strcat "H." (itoa n))
            )
            (setq n (1+ n))
        )
    )
    (delete-blockrefs (get-all-tee-labels))
    (foreach node (get-all-tees)
        (progn        
            (insert-tee-label 
                (get-ins-point node) 
                (strcat "T." (itoa n))
            )
            (setq n (1+ n))
        )
    )
    ; Domestic tees are already deleted with Tees above
    (foreach node (get-all-domestic-tees)
        (progn        
            (insert-domestic-tee-label 
                (get-ins-point node) 
                (strcat "D.T." (itoa n))
            )
            (setq n (1+ n))
        )
    )
    (delete-blockrefs (get-all-riser-labels)) 
    (setq n (riser-labels-create n))
    (princ (strcat "\n" (itoa (- n 1)) " nodes were labeled.\n"))
    (princ)
)

(defun delete-blockrefs (blockrefs)
    (foreach blockref blockrefs
        (entdel (cdr (assoc -1 blockref)))
    )
)

(defun insert-head-label (point text)
    (insert-node-label 
        point 
        text 
        "HeadLabel"            ; block-name
        head-label:layer       ; layer
        head-label:tag-string  ; tag-string
        head-label:label-color ; label-color
        head-label:x-offset
        head-label:y-offset
    )
)

(defun insert-tee-label (point text)
    (insert-node-label 
        point 
        text 
        "TeeLabel"             ; block-name
        tee-label:layer        ; layer
        tee-label:tag-string   ; tag-string
        tee-label:label-color  ; label-color
        tee-label:x-offset
        tee-label:y-offset
    )
)

(defun insert-domestic-tee-label (point text)
    (insert-node-label 
        point 
        text 
        "TeeLabel"            ; block-name
        tee-label:layer       ; layer
        tee-label:tag-string  ; tag-string
        tee-label:label-color ; label-color
        tee-label:x-offset
        tee-label:y-offset
    )
)

(defun insert-riser-label (point text)
    (insert-node-label 
        point 
        text 
        "RiserLabel"  ; block-name
        riser-label:layer       ; layer
        riser-label:tag-string  ; tag-string
        riser-label:label-color ; label-color
        tee-label:x-offset
        tee-label:y-offset
    )
)

(defun insert-node-label (point text block-name layer-name tag-string label-color label-x-offset label-y-offset / e p)
    (entmake
        (list 
            (cons 0 "INSERT")
            (cons 10 point) ; Insertion point
            (cons 2 block-name) ; Block name
            (cons 8 layer-name) ; Layer
            (cons 66 1) ; Attributes follow
        )
    )
    (setq e (entlast))
    (entmake
        (list 
            (cons 0 "ATTRIB") ; Entity type
            (cons 10 (add-point-offset point label-x-offset label-y-offset)) ; Label insertion point
            (cons 1 text)          ; Text value
            (cons 2 tag-string)    ; Tag string
            (cons 3 "Node number:")        ; Prompt string
            (cons 40 5.0)          ; Text height
            (cons 7 "ARIAL")       ; Text style
            (cons 62 label-color)  ; Color
            (cons 8 layer-name)    ; Layer
        )
    )
    (entmake
        (list 
            (cons 0 "SEQEND") 
            (cons -2 e)
        )
    )
    (entupd e)
    (princ)
)

(defun make-pipe-labels ( / seg p v vertices label)    
    (setq p 0)    
    (foreach pipe  (reverse (get-all-pipes))
        (setq v 0)                
        (setq vertices (get-vertices pipe))
        (while (< v (length vertices))
            (setq seg (segment v vertices))
            (if (< v (1- (length vertices))) ; not the last vertex index
                (progn
                    (setq label (strcat "P" (itoa (1+ p))))
                    (insert-pipe-label (midpoint (car seg) (cadr seg)) label)
                )
            )
            (setq v (1+ v))
        )
        (setq p (1+ p))
    )
    p ; Return number of pipes labled
)

(defun insert-pipe-label (point text)
    (make-text point text 4.0 color-blue "Pipe Labels")
)

(defun get-all-pipe-labels ( / en ent labels layer) 
    (setq labels '())
    (setq en (entnext))
    (while en
        ;(setq ent (entget en))
        (if (and (str= "Pipe Labels" (get-layer en))
                (str= (get-etype en) "TEXT")
            )
            ;(setq labels (cons ent labels))
            (setq labels (cons en labels))
        )
        (setq en (entnext en))
    )
    labels
)

(defun delete-all-pipe-labels ( / label)
    (foreach label (get-all-pipe-labels)
        (entdel label)
    )
)

(defun get-all-head-labels ()
    (get-blocks (list "HeadLabels" "Head Labels"))
)

(defun get-all-tee-labels ()
    (get-blocks (list "TeeLabels" "Tee Labels"))
)

(defun get-all-riser-labels ()
    (get-blocks (list "RiserLabels" "Riser Labels"))
)
; *****************************************
; File: C:\LoopCAD\Lisp\load-safely.lsp
; *****************************************
(defun load-safely (file-name)
    (prompt (strcat "\nLoading module: \"" file-name "\"\n"))
    (setq file-was-found (findfile file-name))
    (if file-was-found
        (load file-name)
        (progn 
            (setq *failed-to-load* (1+ *failed-to-load*))
            (prompt (strcat "\nERROR: LoopCAD LISP module file failed to load: \"" file-name "\"\n"))
        )
    )
)

; Show error if any modules failed to load
(defun load-safely-check ( / message)
    (if (> *failed-to-load* 0)
        (progn
            (setq message (strcat "ERROR: " (itoa *failed-to-load*) " LoopCAD LISP module files failed to load! Check command box for the names of the specific files."))
            (alert message)
            (prompt "\n**** ERROR ****\n")
            (prompt (strcat "\n" message "\n"))
        )
        (progn
            (prompt "\n*****************************************************************\n")
            (prompt "\n**** All LoopCAD LISP module files were loaded successfully. ****\n")
            (prompt "\n*****************************************************************\n")
        )
    )
)
; *****************************************
; File: C:\LoopCAD\Lisp\math.lsp
; *****************************************
;(vl-registry-read "HKEY_CURRENT_USER\\Software\\LoopCalc\\ProgeCAD" "Test")

(defun greatest (a b)
  (if (> a b) a b)
)

(defun least (a b)
  (if (< a b) a b)
)

(defun average (a b)
    (/ (+ a b) 2)
)

(defun ents ( / en all all-lists)
    ;(princ "\n\nEntity: ")
    ;(princ (entget en))
    (setq all '())
    (setq en (entnext))
    (while en
        (setq all (cons en all))
        (setq en (entnext en))
    )
    (setq all-lists '())
    (foreach en all
        (setq all-lists (cons (entget en) all-lists))
    )
    all-lists
)

; Manual eyeball test
(defun test-midpoint ()
    (make-circle (midpoint (getpoint) (getpoint)) 10.0 color-green "Pipes")
)

(defun midpoint (a b)
    (list (average (getx a) (getx b)) (average (gety a) (gety b)) 0.0)
)

; Print the coordinates of the point.  For debugging.
(defun print-point (label point)
    (princ (strcat "\n" label ": "))
    (princ (car point))
    (princ ", ")
    (princ (cadr point))
    (princ)
)

; Get X coordinate from a point
(defun getx (point)
    (car point)
)

; Get Y coordinate from a point
(defun gety (point)
    (car (cdr point))
)

; Linear slope y/x of a line between points 'a' and 'b'
(defun slope (a b / xdiff ydiff)
    (setq xdiff (- (getx a) (getx b)))
    (setq ydiff (- (gety a) (gety b)))
    (if (= xdiff 0)
        "Infinity"
        (if (= ydiff 0)
            0
            (/ ydiff xdiff)
        )
    )
)

; Area of a rectangle, input opposite corners a and b
(defun area (a b / xdiff ydiff)
    (setq xdiff (- (getx a) (getx b)))
    (setq ydiff (- (gety a) (gety b)))
    (* xdiff ydiff)
)

; Index of a member of a list
(defun index-of (item  lst / )
    (member item lst)
    (- (length lst) (length (member item lst)))
)

; Negative reciprocal, used with slope to find perpendicular slope
(defun negative-reciprocal (x) (- 0 (/ 1 x)))

(setq dxf-point 10)

; Test with:
; (command "-PLINE" (get-vertices (car (get-all-pipes))) "")
(defun get-vertices (polyline / vertex remaining)
    (setq vertices '())
    (cond 
        ((str= "LWPOLYLINE" (cdr (assoc 0 polyline)))
            (foreach property polyline
                (if (= 10 (car property)) 
                    (setq vertices (cons (cdr property) vertices))
                )
            )
        )
        ((str= "POLYLINE" (cdr (assoc 0 polyline)))
            (princ "\nNOT an LW Polyline box\n")
            (princ (entget (cdr (assoc -1 polyline))))
            (princ (entget (entnext (cdr (assoc -1 polyline)))))
            ; TODO: Get the rest of the vertices
        )
    )
    (remove-repeated-points vertices)
)



(defun get-layer (entity-name)
    (cdr (assoc 8 (entget entity-name)))
)

(defun get-etype (entity-name)
    (cdr (assoc 0 (entget entity-name)))
)

(defun get-owner-name (entity-name)
    (cdr (assoc 330 (entget entity-name)))
)

(defun get-ins-point (entity)
    (if (= (type entity) "ENAME") 
        (setq entity (entget entity))
    )
    (cdr (assoc 10 entity))
)

(defun get-ename (entity)
    (cdr (assoc -1 entity))
)

(defun ent-name (entity)
    (cdr (assoc -1 entity))
)

(defun get-x-scale (entity-name)
    (cdr (assoc 41 (entget entity-name)))
)

(defun get-x-scale (entity-name)
    (cdr (assoc 42 (entget entity-name)))
)

(defun get-z-scale (entity-name)
    (cdr (assoc 43 (entget entity-name)))
)

(defun get-block-name (entity-name)
    (cdr (assoc 2 (entget entity-name)))
)

(defun get-rotation-angle (entity-name)
    (cdr (assoc 50 (entget entity-name)))
)

(defun get-color (entity-name)
    (cdr (assoc 62 (entget entity-name)))
)

(defun ent-color (entity)
    (cdr (assoc 62 entity))
)

(defun str= (left right)
   (= (strcase left) (strcase right))
)

(defun strindexof (substring string)
   (vl-string-search (strcase substring) (strcase string))
)

(defun strcontains (substring string)
   (strindexof substring string)
)

(defun strstartswith (substring string)
   (= 0(strindexof substring string))
)

; Returns if 'items' contains 'item' works for strings only
; Uses case insenstive str= function.
(defun list-contains (item items / result)
    (setq result nil)
    (foreach i items 
        (if (str= i item)
            (setq result T)
        )
    )
    result
)

; Finds if two numbers are almost the same, within the margin
(defun approx (a b margin / )
    (< (abs (- a b)) margin)
)

; Are all items in both lists almost the same, within the margin
; Uses the approx function
(defun lists-approx (a-list b-list margin / a b i a-length different)
    (setq a-length (length a-list))
    (setq i 0)
    (if (not (= a-length (length b-list)))
        (setq different T) ; List are of different lengths
        (while (< i a-length)
            (if (not (approx (nth i a-list) (nth i b-list) margin))
                (setq different T)
            )
            (setq i (1+ i))
        )    
    )
    (not different)
)

(defun test-assoc-approx ( / )
    (princ "\ntest-assoc-approx: ")
    (if (= 
            (list (list 25 33.4 4) 66 77) ; Expected Output
            (assoc-approx                   ; Function Under Test
                (list 25.5 33.0 4.0) 
                (list 
                    (list (list 55 22 2.30) 55 66) 
                    (list (list 25.00 33.4 4.0) 66.0 77.0) 
                    (list (list 1.0 2.0) 11 22)
                ) 
                1.0
            )
        )
        (princ "PASS\n")
        (princ "FAIL\n")
    )
    (princ)
)

; Same as the assoc function, but uses lists-approx and approx instead of =
(defun assoc-approx (target items margin / item found)
    (foreach item items
        (if (lists-approx (car item) target margin)
            (setq found item)
        )
    )
    found
)
; *****************************************
; File: C:\LoopCAD\Lisp\nodes.lsp
; *****************************************
(defun get-all-heads ()
    (get-blocks (list "Heads"))
)

(defun get-all-tees ()
    (get-blocks (list "Tees"))
)

(defun get-all-domestic-tees ()
    (get-blocks (list "DomesticTees"))
)

(defun get-all-risers ()
    (get-blocks (list "Floor Connectors" "FloorConnectors" "Risers"))
)
; *****************************************
; File: C:\LoopCAD\Lisp\pipes.lsp
; *****************************************
; (pipe-draw) and (pipe-make) methods, a little different from each other.
; (pipe-draw) is the PIPE-DRAW command called by the user, 
;      by clicking a button, to pipe a system.
; (pipe-make) is used by the BREAK-PIPES command to re-draw the pipes.

(defun pipe-draw (size / old-osmode old-orthomode old-autosnap line-width)
    (setq old-osmode (getvar "OSMODE"))
    (setq old-orthomode (getvar "ORTHOMODE"))
    (setq old-autosnap (getvar "AUTOSNAP"))
    (defun *error* (message)
      (princ)
      (princ message)
      (princ)
      (setvar "OSMODE" old-osmode)
      (setvar "ORTHOMODE" old-orthomode)
      (setvar "AUTOSNAP" old-autosnap)
      (command "-COLOR" "BYLAYER")
      (command "-LAYER" "SET" "0" "")
    )
    (progn
        (if (null global:pipe-size)
            (setq global:pipe-size "05")
        )
        (initget "05 075 1 15")
        (if (setq tmp (getkword (strcat "\nPipe Size [05/075/1/15] <" global:pipe-size ">: ")))
            (setq global:pipe-size tmp)
        )
    )
    
    (setq line-width (/ 1.0 12.0))
    (command "-LAYER" "SET" layer-pipe "")
    (command "-COLOR" (pipe-size-color global:pipe-size))
    (setvar "OSMODE" osmode-snap-ins-pts)
    (setvar "AUTOSNAP" 16) ; Turn object snap AutoSnap features on
    (setvar "ORTHOMODE" 1)
    ;(command "-LAYER" "NEW" layer-pipe "")
    ;(command "-LAYER" "COLOR" "White" layer-pipe "")
    
    
    
    (prompt (strcat "\nPipe Size: " global:pipe-size "\n"))
    (prompt "\nDraw pipe to each head.\n")
    (command "PLINE" pause "Width" line-width line-width pause)
  
    (setvar "OSMODE" old-osmode)
    (setvar "ORTHOMODE" old-orthomode)
    (setvar "AUTOSNAP" old-autosnap)
    (command-s "-LAYER" "SET" "0" "")
    (setvar "LWDISPLAY" 1)
)

; 64 = OSMODE: Snap to insertion points
; 1 = End Points
(setq osmode-snap-ins-pts 65)
; Layer for pipes is "Pipes" not "Pipe"
(setq layer-pipe "Pipes")

(setq pipe-width 2.0)

; Visual test, look at the output.
(defun test-make-pipe ()
    (make-pipe "1-1/4" 
        (list
            '(10410.5 15273.4 0.000000) 
            '(10386.9 15294.1 0.000000)
            '(10797.7 15181.8 0.000000)
            '(10856.8 15409.3 0.000000)
        )
    )
)

; Returns the pipe size, ex: "3/4" from a color input of 1 (which is red)
(defun get-pipe-size (polyline / vertex remaining)
    ;(pipe-color-size (cdr (assoc 62 polyline)))
    (pipe-color-size (ent-color polyline))
)

(defun make-pipe (size vertices)
    (make-polyline vertices  (pipe-size-color size) "Pipes")
)

; Make a vertices for a polyline
; Also needs an 'SEQEND' entry
(defun make-vertex (p)
    (entmake 
        (list 
            (cons 0 "VERTEX") 
            (cons 10 p)
        )
    )            
)

; Name colors
(setq color-red 1)
(setq color-yellow 2)
(setq color-green 3)
(setq color-cyan 4)
(setq color-blue 5)
(setq color-magenta 6)
(setq color-black-white 7)
(setq color-dark-gray 8)
(setq color-light-gray 9)
(setq color-orange 30)

(setq size-color-list 
    (list 
        (cons "1/2" color-green) ; Domestic pipe
        (cons "3/4" color-red)
        (cons "1" 150) ; Since this is listed first it is the default 1 inch color
        (cons "1" color-blue)
        (cons "1" color-orange) ; Copper pipe
        (cons "1-1/2" color-magenta)
        (cons "05" color-green)
        (cons "075" color-red)
        (cons "15" color-magenta)
    )
)

(defun pipe-color-size (color / size)
    (assoc-cdr color size-color-list)
)

(defun pipe-size-color (size)
    (cdr (assoc size size-color-list))
)

; Return the first element from a list of dotted pairs by matching
; the second element.
; Like assoc but find the value by the second (cadr) value 
; insead of the first (car)
(defun assoc-cdr (val items / key)
    (foreach item items
        (if (= val (cdr item))
            (setq key (car item))
        )
    )
    key
)
; *****************************************
; File: C:\LoopCAD\Lisp\points.lsp
; *****************************************

(defun add-point-offset (point x y)
    (list (+ x (getx point)) (+ y (gety point)) 0)
)
 
(defun get-point-offset (a b)
    (list (- (getx a) (getx b)) (- (gety a) (gety b)) 0)
)
; *****************************************
; File: C:\LoopCAD\Lisp\strings.lsp
; *****************************************
; Splits a string at all occurences of the delim into a list
; Example: (string-split "My,name,is,Marc") = (list "My" "name" "is" "Marc")
(defun string-split ( str delim / pos )
    (if (setq pos (vl-string-search delim str))
      (cons (substr str 1 pos) (string-split (substr str (+ pos 1 (strlen delim))) delim))
      (list str)
    )
)
; *****************************************
; File: C:\LoopCAD\Lisp\tees.lsp
; *****************************************
(defun tee-insert ( / old-osmode)
    (setq old-osmode (getvar "OSMODE"))
    (defun *error* (message)
        (princ)
        (princ message)
        (princ)
        (setvar "OSMODE" old-osmode)
        (setvar "LWDISPLAY" 1)
        (command "-COLOR" "BYLAYER")
        (command "-LAYER" "SET" "0" "")
    )
    
    (setvar "INSUNITS" 1) ; 0 = not set, 1 = inches, 2 = feet
    (setvar "OSMODE" osmode-snap-ins-pts)
    (setvar "LWDISPLAY" 0)
    (command "-LAYER" "SET" "Tees" "")
    (command "-INSERT" "Tee.dwg" pause 1.0 1.0 0)  
    
    (setvar "OSMODE" old-osmode)
    (command-s "-LAYER" "SET" "0" "")
    (setvar "LWDISPLAY" 1)
)

(defun domestic-tee-insert ( / old-osmode)
    (setq old-osmode (getvar "OSMODE"))
    (defun *error* (message)
        (princ)
        (princ message)
        (princ)
        (setvar "OSMODE" old-osmode)
        (setvar "LWDISPLAY" 1)
        (command "-COLOR" "BYLAYER")
        (command "-LAYER" "SET" "0" "")
    )
    (setvar "INSUNITS" 1) ; 0 = not set, 1 = inches, 2 = feet
    (setvar "OSMODE" osmode-snap-ins-pts)
    (command "-LAYER" "NEW" "DomesticTees" "")
    (command "-LAYER" "COLOR" "White" "Tee" "")
    (setvar "LWDISPLAY" 0)
    (command "-LAYER" "SET" "DomesticTees" "")
    (command "-INSERT" "DomesticTee.dwg" pause 1.0 1.0 0)  
)
; *****************************************
; File: LoopCAD.lsp
; *****************************************
(command "NETLOAD" "/LoopCAD/LoopCAD.dll")
(princ "\nLoaded LoopCAD.dll .NET Module\n")

;(prompt "\nLoading LoopCAD LISP modules...\n")
; Global Variables
;(setq *failed-to-load* 0)

; Load LoopCAD LISP module files (*.lsp)
;(setq loop-cad-folder (vl-filename-directory (findfile "LoopCAD.lsp")))
;(setq loop-cad-lisp-folder (strcat loop-cad-folder "/Lisp"))
;(load (strcat loop-cad-lisp-folder "/load-safely.lsp"))

;(foreach f (cdr (cdr (vl-directory-files loop-cad-lisp-folder)))
;    (if (= (strcase (vl-filename-extension f)) (strcase ".lsp"))
;        (load-safely (strcat loop-cad-lisp-folder "/" f))
;    )
;)
;(princ "\n")

; Check if files all loaded
;(load-safely-check)

(define-labels)

(princ "\nLoaded LoopCAD LISP files\n")

(princ) ; exit quietly
