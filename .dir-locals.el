;;; .dir-locals.el --- Configuración local para Emacs en el proyecto registro-io

;; Para más información sobre archivos .dir-locals.el en Emacs:
;; Info node `(emacs) Directory Variables'

((nil . ((indent-tabs-mode . nil)
         (fill-column . 100)
         (coding . utf-8)
         ;; Configuración de proyectos para project.el (mantiene los submódulos integrados)
         (project-vc-merge-submodules . nil)))

 ;; =========================================================================
 ;; Submódulo public_html: Proyecto Symfony 7.4 + PHP + Composer
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

     (nil
      . ((compile-command . "cd public_html && symfony server:start")
         ;; Soporte para Projectile
         (projectile-project-name . "registro-io-public_html")
         (projectile-project-type . symfony)
         (projectile-project-run-cmd . "symfony server:start")
         (projectile-project-compilation-cmd . "cd public_html && php bin/console")))))

 ;; =========================================================================
 ;; Submódulo data_wrangling: Scripts de Python / Procesamiento de datos
 ;; =========================================================================
 ("data_wrangling/"
  . ((python-mode
      . ((python-indent-offset . 4)
         (indent-tabs-mode . nil)))

     (python-ts-mode
      . ((python-indent-offset . 4)
         (indent-tabs-mode . nil)))

     (nil
      . ((projectile-project-name . "registro-io-data_wrangling")
         (projectile-project-type . python))))))
