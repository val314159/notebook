(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload :hunchensocket))

(defpackage :demo2 (:use :cl :hunchentoot :hunchensocket)
	    (:import-from :uiop #:read-file-string))
(in-package :demo2)

(defclass websocket-easy-acceptor (websocket-acceptor easy-acceptor) ()
  (:documentation "Special WebSocket easy acceptor"))

(defclass chat-room (websocket-resource)
  ((name :initarg :name :initform (error "Name this room!") :reader name))
  (:default-initargs :client-class 'user))

(defclass user (websocket-client)
  ((name :initarg :user-agent :reader name :initform (error "Name this user!"))))

(defvar *chat-rooms* (list (make-instance 'chat-room :name "/bongo")
                           (make-instance 'chat-room :name "/fury")))

(defun find-room (request)
  (find (script-name request) *chat-rooms* :test #'string= :key #'name))

(pushnew 'find-room *websocket-dispatch-table*)

(defun broadcast (room message &rest args)
  (loop for peer in (clients room)
        do (send-text-message peer (apply #'format nil message args))))

(defmethod client-connected ((room chat-room) user)
  (broadcast room "~a has joined ~a" (name user) (name room)))

(defmethod client-disconnected ((room chat-room) user)
  (broadcast room "~a has left ~a" (name user) (name room)))

(defmethod text-message-received ((room chat-room) user message)
  (broadcast room "~a says ~a" (name user) message))  

(define-easy-handler (-/ :uri "/") ()
  (concatenate 'string "<!doctype html><html>"
	       "<style>"  (read-file-string "www/style.css")  "</style>"
	       "<script>" (read-file-string "www/app.js")     "</script>"
	       "<!--x-->" (read-file-string "www/index.html") "</html>"))

(define-easy-handler (-/yo :uri "/yo") (name)
  (setf (content-type*) "text/plain")
  (format nil "Hey~@[ ~A~]!" name))

(defvar *server* (make-instance 'websocket-easy-acceptor
				:document-root "www/"
				:port 12345))

(defun main () (start *server*) (loop (sleep 15)))
