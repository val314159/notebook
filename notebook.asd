;;;; notebook.asd

(asdf:defsystem #:notebook
  :description "Describe notebook here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :depends-on (#:hunchensocket #:parenscript)
  :components
  ((:module "src"
	    :serial t
	    :components
	    ((:file "package")
	     (:file "macros")
	     (:file "notebook")))))
