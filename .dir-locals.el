;;; Directory Local Variables            -*- no-byte-compile: t -*-
;;; For more information see (info "(emacs) Directory Variables")

((nil . ((project-vc-merge-submodules . nil)))
 (nil . ((compile-command . "./install.sh")))
 ("public_html/"
  . ((php-mode
      . ((php-project-root . "public_html/")
	 (tab-width . 4)
         (indent-tabs-mode . nil)))

     (php-ts-mode
      . ((php-project-root . "public_html/")
	 (tab-width . 4)
         (indent-tabs-mode . nil)))

     (web-mode
      . ((web-mode-engines-alist . (("twig" . "\\.twig\\'")))
         (indent-tabs-mode . nil)))

     (css-mode
      . ((indent-tabs-mode . nil)))

     (css-ts-mode
      . ((indent-tabs-mode . nil)))

     (yaml-mode
      . ((yaml-indent-offset . 2)
	 (indent-tabs-mode . nil)))

     (yaml-ts-mode
      . ((yaml-indent-offset . 2)
	 (indent-tabs-mode . nil)))

     (json-mode
      . ((indent-tabs-mode . nil)))

     (json-ts-mode
      . ((indent-tabs-mode . nil)))

     (nil
      . ((compile-command . "symfony --allow-all-ip server:start")))))
 ("data_wrangling/"
  . ((org-mode
      . ((org-adapt-indentation . t)
         (org-edit-src-content-indentation . 0)))

     (python-mode
      . ((indent-tabs-mode . nil)))

     (python-ts-mode
      . ((indent-tabs-mode . nil)))))
 )
