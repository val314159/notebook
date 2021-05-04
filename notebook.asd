;;;; notebook.asd

(asdf:defsystem #:notebook
  :description "Describe notebook here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:hunchensocket #:parenscript)
  :components ((:file "package")
               (:file "notebook")))
