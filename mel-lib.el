(defun trim (str)
  "Remove the white spaces at the end of string."
  (when (string-match "[ \t]*$" str)
    (replace-match "" nil nil str)))

(provide 'mel-lib)
