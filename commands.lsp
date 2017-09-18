(defun C:SET-HEAD-DATA () (set-head-data))
(defun C:SET-HEAD-MODEL () (set-head-model))
(defun C:SET-HEAD-COVERAGE () (set-head-coverage))
(defun C:SET-HEAD-SLOPE () (set-head-slope))
(defun C:SET-HEAD-TEMP () (set-head-temperature))
(defun C:HEAD () (insert-head-user))
(defun C:HEAD-12 () (insert-head-coverage "12")) 
(defun C:HEAD-14 () (insert-head-coverage "14"))
(defun C:HEAD-16 () (insert-head-coverage "16"))
(defun C:HEAD-18 () (insert-head-coverage "18"))
(defun C:HEAD-20 () (insert-head-coverage "20")) 
(defun C:PIPE () (pipe-draw (get-string "Enter Pipe Size: ")))
(defun C:PIPE-12 () (pipe-draw "1/2"))
(defun C:PIPE-34 () (pipe-draw "3/4"))
(defun C:PIPE-1 () (pipe-draw "1"))
(defun C:PIPE-114 () (pipe-draw "1-1/4"))
(defun C:ELEVATION-BOX () (vl-vbarun "Controller.ElevationBox"))

