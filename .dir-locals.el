;;; .dir-locals.el --- Configuración local para Emacs 30 (project.el) en el proyecto registro-io

((nil . ((indent-tabs-mode . nil)
         (fill-column . 100)
         (coding . utf-8)
         ;; Configuración de project.el para Emacs 30
         (project-vc-merge-submodules . nil)))

 ;; =========================================================================
 ;; Submódulo public_html: Proyecto Symfony 7.4 + PHP + Composer + Twig
 ;; =========================================================================
 ("public_html/"
  . ((php-mode
      . ((php-project-root . "public_html/")
         (c-basic-offset . 4)
         (tab-width . 4)
         (indent-tabs-mode . nil)))

     (php-ts-mode
      . ((php-project-root . "public_html/")
         (c-basic-offset . 4)
         (tab-width . 4)
         (indent-tabs-mode . nil)))

     (web-mode
      . ((web-mode-markup-indent-offset . 2)
         (web-mode-css-indent-offset . 2)
         (web-mode-code-indent-offset . 4)
         (web-mode-engines-alist . (("twig" . "\\.twig\\'")))
         (indent-tabs-mode . nil)))

     (css-mode
      . ((css-indent-offset . 2)
         (indent-tabs-mode . nil)))

     (css-ts-mode
      . ((css-indent-offset . 2)
         (indent-tabs-mode . nil)))

     (yaml-mode
      . ((yaml-indent-offset . 2)
         (indent-tabs-mode . nil)))

     (yaml-ts-mode
      . ((yaml-indent-offset . 2)
         (indent-tabs-mode . nil)))

     (json-mode
      . ((js-indent-level . 2)
         (indent-tabs-mode . nil)))

     (json-ts-mode
      . ((json-ts-mode-indent-offset . 2)
         (indent-tabs-mode . nil)))

     (nil
      . ((compile-command . "cd public_html && symfony server:start")))))

 ;; =========================================================================
 ;; Submódulo data_wrangling: Scripts en Python, Org-mode y CSVs
 ;; =========================================================================
 ("data_wrangling/"
  . ((org-mode
      . ((org-adapt-indentation . t)
         (org-edit-src-content-indentation . 2)))

     (python-mode
      . ((python-indent-offset . 4)
         (indent-tabs-mode . nil)))

     (python-ts-mode
      . ((python-indent-offset . 4)
         (indent-tabs-mode . nil)))

     (csv-mode
      . ((csv-separators . (",")))))))
