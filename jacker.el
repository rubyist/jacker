; TODO - a jacker mode that keeps the jacker status in the status bar
; would be a nice thing.

(defun jacker-start (doing)
  "Start jacking"
  (interactive "MWhat are you doing? ")
  (call-process "jacker" nil 0 nil "start" doing))

(defun jacker-stop ()
  "Stop jacking"
  (interactive)
  (call-process "jacker" nil 0 nil "stop"))
