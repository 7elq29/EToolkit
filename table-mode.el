(require 'cl)
(require 'mel-lib)
(defvar odd-line 't)
(defgroup table-view nil
  "Visual Popup User Interface"
  :group 'lisp
  :prefix "table-view-")
(defface table-view-face-strip1-col1
  '((t (:background "#303030")))
  "Face for odd number line.")
(defface table-view-face-strip2-col1
  '((t (:background "#272727")))
  "Face for even number line.")
(defface table-view-face-strip1-col2
  '((t (:background "#353535")))
  "Face for odd number line.")
(defface table-view-face-strip2-col2
  '((t (:background "#2B2B2B")))
  "Face for even number line.")

(defun table-add-row ()
  "Add a new line at the bottom of table.      
Background color is striped."
  (interactive)
  (let ((buffer-read-only nil)
        (cell-size (/ (window-width) columns)))
    (goto-char (line-beginning-position (point-max)))
    (setq start (point))
    (insert-string (make-string (window-width) ?\s))
    (newline)
    (setq end (point))
    (setq row (- (line-number-at-pos start) 1))
    (overlay-row row)
    (incf rows)))


(defun overlay-row (row)
  "Overlay the specified row."
  (interactive "n")
  (let ((buffer-read-only nil)
        (cell-size (/ (window-width) columns))
        (odd-line (= 1 (% row 2)))
        (odd-col nil)
        (index))
    (save-excursion
      (goto-line (+ row 1))
      (setq start (point))
      (remove-overlays start (+ start (window-width)))
      (dotimes (index columns)
        (setq overlay
              (make-overlay
               (+ start (* index cell-size))
               (if (= index (- columns 1))
                   (+ start (window-width))
                 (+ start (* (+ index 1) cell-size)))))
        (cond
         ((and odd-line odd-col)
          (setq strip-face 'table-view-face-strip1-col1)
          (setq odd-col nil))
         ((and odd-line (not odd-col))
          (setq strip-face 'table-view-face-strip1-col2)
          (setq odd-col 't))
         ((and (not odd-line) odd-col)
          (setq strip-face 'table-view-face-strip2-col1)
          (setq odd-col nil))
         ((and (not odd-line) (not odd-col))
          (setq strip-face 'table-view-face-strip2-col2)
          (setq odd-col 't)))
        (overlay-put overlay 'face strip-face)))))

(defun table-edit-cell (row col text)
  "Edit cell in the specified row num and column num.
The origin text in that cell will be replaced."
  (interactive "nRow No.: \nnColumn No.: \nsText: ")
  (let ((buffer-read-only nil)
        (cell-size (/ (window-width) columns)))
    (when (or (>= row rows)
              (>= col columns))
      (error "Cell out of table."))
    (if (> (length text) cell-size)
        (setq text (substring text 0 cell-size))
      (setq text
            (concat text
                    (make-string (- cell-size (length text)) ?\s))))
    (goto-line (+ 1 row))
    (move-to-column (* col cell-size))
    (insert-string text)
    (delete-char (length text))
  ))

(defun read-cell (row col)
  "Read text from specified cell."
  (interactive "nRow No.: \nnColumn No.:")
  (when (or (>= row rows)
            (>= col columns))
    (error "Cell out of table."))
  (let ((cell-size (/ (window-width) columns)))
    (save-excursion
      (goto-line (+ 1 row))
      (message (trim
       (buffer-substring-no-properties
        (+ (point) (* col cell-size))
        (+ (point) (* (+ 1 col) cell-size))))))))

(defun add-column ()
  "Add new empty column to the right."
  (interactive)
  (let ((cell-size (/ (window-width) columns))
        (new-cell-size (/ (window-width) (+ 1 columns)))
        (new-column (+ 1 columns))
        (buffer-read-only nil))
    (save-excursion
      (dotimes (r-index rows)
        (dotimes (c-index columns)
          (goto-line (+ 1 r-index))
          (setq text
                (trim
                 (buffer-substring-no-properties
                  (+ (point) (* c-index cell-size))
                  (+ (point) (* (+ 1 c-index) cell-size)))))
          (setq text
                (if (> (length text) new-cell-size)
                    (substring text 0 new-cell-size)
                  (concat text
                          (make-string (- new-cell-size (length text)) ?\s))))
          (move-to-column (* c-index new-cell-size))
          (insert-string text)
          (delete-char (length text))))
      (incf columns)
      (resize-overlay))))

(defun table-resize-window ()
  "Refill overlay and table when window resize is changed."
  (interactive)
  (save-excursion
    (let ((buffer-read-only nil)
          (cell-size)
          (new-cell-size)
          )
      (dotimes (r-index rows)
        (dotimes (c-index columns)
          (goto-line (+ 1 r-index))
          (setq new-cell-size
                (if (= c-index (- columns 1))
                    (- (window-width) (* (- columns 1) new-cell-size))
                  (/ (window-width) columns)))
          (setq cell-size
                (if (= c-index (- columns 1))
                    (- (- (line-end-position) (line-beginning-position)) (* (- columns 1) new-cell-size))
                  (/ (- (line-end-position) (line-beginning-position)) columns)))
          (setq text
                (trim
                 (buffer-substring-no-properties
                  (+ (point) (* c-index new-cell-size))
                  (+ (point) (+ (* c-index new-cell-size) cell-size)))))
          (setq text
                (if (> (length text) new-cell-size)
                    (substring text 0 new-cell-size)
                  (concat text
                          (make-string (- new-cell-size (length text)) ?\s))))
          (move-to-column (* c-index new-cell-size))
          (insert-string text)
          (delete-char cell-size)))
      (resize-overlay))))

(defun resize-overlay ()
  "Resize the overlay according to row and column number."
  (interactive)
  (let ((buffer-read-only nil))
    (dotimes (row rows)
      (overlay-row row))))

(defun table-mode ()
  ""
  (interactive)
  (read-only-mode)
  (set (make-local-variable 'rows) 0)    ; Number of rows
  (set (make-local-variable 'columns) 2) ;Number of Columns
  (local-set-key (kbd "a")  'table-add-row)
  (local-set-key (kbd "e")  'table-edit-cell)
  )

(provide 'table-mode)




















