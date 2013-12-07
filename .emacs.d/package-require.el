;; from http://qiita.com/k_ui/items/3e6fb470e6f80bae046e
(defun package-require (feature &optional filename packagename noerror)
  (unless package--initialized (package-initialize))
  (unless package-archive-contents (package-refresh-contents))
  (let ((pname (or packagename feature)))
    (if (assq pname package-archive-contents)
        (let nil
          (unless (package-installed-p pname)
            (unless package-archive-contents (package-refresh-contents))
            (package-install pname))
          (or (require feature filename t)
              (if noerror nil
                (error "Package `%s' does not provide the feature `%s'"
                       (symbol-name pname) (symbol-name feature)))))
      (if noerror nil
        (error "Package `%s' is not available for installation"
               (symbol-name feature))))))

(provide 'package-require)
