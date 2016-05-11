(require 'cl)
(defun find-left-paren (point) "Find the closing parenthesse of the block and return its point." (let ((str-buffer-size 10) (index 0) (rparen-pos nil) (paren-found nil) (buffer-size (buffer-size)) (lparen 0)) (while (and (not paren-found) (< point buffer-size)) (setq index 0) (let ((--dolist-tail-- (string-to-list (buffer-substring-no-properties point (if (< (+ str-buffer-size point) buffer-size) (+ str-buffer-size point) buffer-size)))) c) (while --dolist-tail-- (setq c (car --dolist-tail--)) c (cond (paren-found nil) ((equal c 40) (setq lparen (1+ lparen))) ((and (equal c 41) (= lparen 0)) (setq rparen-pos (+ point index)) (setq paren-found (quote t))) ((and (equal c 41) (not (equal lparen 0))) (setq lparen (1- lparen)))) (setq index (1+ index)) (setq --dolist-tail-- (cdr --dolist-tail--)))) (setq point (+ point str-buffer-size))) rparen-pos))

(defun move-paren-left (point)
  "Move the closing parenthesse of current block right such that the block will include the block after it."
  (interactive "d")
  (let
      ((str-buffer-size 10)
       (start-point point)
       (paren-found nil)
       (rparen-pos nil)
       (rparen 0)
       (buffer-size (buffer-size))
       (index 0))
    (setq rparen-pos (find-left-paren point))
    (setq point rparen-pos)
    (while
        (and
         (not paren-found)
         (> point start-point))
      (setq index 0)
      (setq reversed-list
            (reverse
             (string-to-list
              (buffer-substring-no-properties
               (if (> (- point str-buffer-size) start-point)
                   (- point str-buffer-size)
                 start-point) point))))
      (let
          ((--dolist-tail-- reversed-list) c)
        (while --dolist-tail--
          (setq c (car --dolist-tail--))
          (cond
           (paren-found (quote t))
           ((equal c 41) (setq rparen (1+ rparen)))
           ((and (equal c 40) (= rparen 0)) (setq paren-found (quote t)))
           ((and (equal c 40) (= rparen 1)) (setq paren-found (quote t)) (delete-region rparen-pos (+ 1 rparen-pos)) (goto-char (- point index 1)) (insert ") ") (goto-char start-point))
           ((and (equal c 40) (> rparen 1)) (setq rparen (1- rparen))))
          (setq index (+ index 1))
          (setq --dolist-tail-- (cdr --dolist-tail--))))
      (setq point (- point str-buffer-size)))))

(defun move-paren-right (point) "Move the closing parenthesse of current block right such that the block will include the block after it." (interactive "d") (let ((str-buffer-size 10) (start-point point) (paren-found nil) (rparen-pos nil) (lparen 0) (buffer-size (buffer-size)) (index 0)) (setq rparen-pos (find-left-paren point)) (setq point (+ rparen-pos 1)) (while (and (not paren-found) (< point buffer-size)) (setq index 0) (let ((--dolist-tail-- (string-to-list (buffer-substring-no-properties point (if (< (+ str-buffer-size point) buffer-size) (+ str-buffer-size point) buffer-size)))) c) (while --dolist-tail-- (setq c (car --dolist-tail--)) (cond (paren-found (quote t)) ((equal c 40) (setq lparen (1+ lparen))) ((and (equal c 41) (= lparen 0)) (setq paren-found (quote t))) ((and (equal c 41) (= lparen 1)) (setq paren-found (quote t)) (delete-region rparen-pos (+ 1 rparen-pos)) (goto-char (+ index point 1)) (insert ") ") (goto-char start-point)) ((and (equal c 41) (> lparen 1)) (setq lparen (1- lparen)))) (setq index (+ index 1)) (setq --dolist-tail-- (cdr --dolist-tail--)))) (setq point (+ point str-buffer-size)))))


(defun move-paren-keybind ()
  (local-set-key (kbd "C->") (quote move-paren-right))
  (local-set-key (kbd "C-<") (quote move-paren-left)))

(add-hook 'emacs-lisp-mode-hook 'move-paren-keybind)


(provide 'eelisp)
