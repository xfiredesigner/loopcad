; Node Labeler
; First get all entities on a layer Tees, Heads DXF=8
; List
; defun heads-all
; defun entities-List*
; defun blocks-all
; defun on-layer

; get all entity types of "INSERT" DXF=0 ?
; Make a List
; Extract insertion points, (10 123.456 233.351 0) DXF=10, into a List
; defun points-from (blocks)
; insert blocks, TeeLabel.dwg at each points
; defun tee/head-label-insert-at (point-list)
; defun block-insert (name point-list)  ; Ignores scale and rotation
; set attribute of each block, NUMBER to a T.1...T.n sequential NUMBER
; Check to see if a TeeLabel is already there
; Version 2?
; Check the T.number of existing tees & nodes

(defun nodes-label ( / block blocks point points props p proplist)
    (setq blocks 
        (blocks-on-layer 
            (list "Heads" "Tees") 
            (list "Head12" "Head14" "Head16" "Head18" "Head20" "Tee")
        )
    )
    (foreach block blocks
        (progn
            (setq point (assoc 10 block))
            (setq points (append points (list point)))
        )
    )
    (foreach p points
        (progn
            ;(setq props '((0 . "CIRCLE") (40 . 50.0) (62 . 5) (8 . "Heads")))
            (setq props 
                '(
                    (0 . "INSERT") 
                    (2 . "HeadLabel") 
                    (8 . "HeadLabels")
                    (40 . 50.0) 
                    (41 . 1)
                    (42 . 1) 
                    (43 . 1) 
                    (44 . 0) 
                    (45 . 0)
                    (50 . 0) 
                    (62 . 5) 
                    (66 . 1) 
                    (67 . 0)
                    (70 . 1)
                    (71 . 1) 
                    (210 0 0 1)
                )
            )
            ; followed by attributes ATTRIB
            ; followed by a SEQEND
            (setq proplist (append props (list p)))
            ;(setq make-result (entmake proplist))
            (command "-INSERT" "HeadLabel" "(146 146)" "1" "1" "1" "0")
            (princ "\nInserted:")
            (princ proplist)
            (if make-result
                (princ "\nWorked.")
                (princ "\nNope.")
            )
        )
    )
    points
)

;Command: ((-1 . <Entity name: 21c75650>) (0 . "INSERT")
; (5 . "246") (330 . <Entity name: b2884e0>) (100 . "AcDbEntity") 
;(67 . 0) (410 . "Model") (8 . "Heads") (100 . "AcDbBlockReference") 
;(66 . 1) (2 . "Head16") (10 -3.3056 147.1697 0) (41 . 1) (42 . 1) 
;(43 . 1) (50 . 0) (70 . 1) (71 . 1) (44 . 0) (45 . 0) (210 0 0 1))