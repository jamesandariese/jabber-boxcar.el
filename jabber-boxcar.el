;;; jabber-boxcar.el --- Boxcar integration for jabber.el

;; Copyright (C) 2013 James Andariese

;; Author: James Andariese <james@strudelline.net>
;; Version: 1.0
;; Package-Requires: ((boxcar "1.0"))
;; Keywords: boxcar pebble jabber

;;; Commentary:

;; This package provides Boxcar integration for jabber.el
;; To activate it, use the following line customize the jabber-alert-message-hooks variable
;; or (add-hook 'jabber-alert-message-hooks 'jabber-boxcar-message-hook)

;;; Code:

;;;###autoload
(defun jabber-boxcar-message-hook (from buf text proposed-alert)
  "Send incoming message to boxcar"
  (let ((sender (if jabber-boxcar-strip-hostname
		    (car (split-string from "@"))
		  from)))
    (boxcar-send (format jabber-boxcar-title-format sender) text)))

;;;###autoload
(defun jabber-boxcar-presence-hook (who oldstatus newstatus statustext proposed-alert)
  (message (format "BOXCAR: %s is %s" who (if (= (length newstatus) 0) "Online" newstatus)))
  (if (find who jabber-boxcar-presence-hook-buddies :test 'equal)
      (boxcar-send (format jabber-boxcar-title-format who) (format "%s: %s" (if (= (length newstatus) 0) "Online" newstatus) statustext))))

;;;###autoload
(defgroup jabber-boxcar nil
  "Jabber Boxcar integration options"
  :prefix '(jabber-boxcar)
  :group 'jabber)

;;;###autoload
(defcustom jabber-boxcar-strip-hostname
  t
  "Strip hostname (part after @) from sender's username when included in title"
  :type '(boolean)
  :group 'jabber-boxcar)

;;;###autoload
(defcustom jabber-boxcar-title-format
  "jabber.el\n%s"
  "Title format.  %s is replaced with the username of the sender"
  :type '(string)
  :group 'jabber-boxcar)

;;;###autoload
(defcustom jabber-boxcar-presence-hook-buddies
  '()
  "Buddies to report presence for to Boxcar"
  :type '(repeat string)
  :group 'jabber-boxcar)


;;;###autoload
(custom-add-frequent-value 'jabber-alert-message-hooks
			   'jabber-boxcar-message-hook)
;;; jabber-boxcar.el ends here
