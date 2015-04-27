;;; dummy-package.el --- Generate and install dummy packages

;; Copyright (C) 2015  William West

;; Author: William West <occidens@gmail.com>
;; Keywords: tools

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:

(require 'package)

(defvar dummy-package-default-version "21060207"
  "Default version to assign to a dummy package.")

(defun dummy-package-filename (package-name)
  (concat package-name ".el"))

(defun dummy-package-header (package-name description &optional version)
  (format ";;; %s --- %s\n;; Package-Version: %s\n"
	  (dummy-package-filename package-name)
	  description
	  (or version dummy-package-default-version)))

(defun dummy-package-requirements (reqs)
  (if reqs
      (format ";; Package-Requires: %S\n" reqs)
    "\n"))

(defun dummy-package-footer (package-name)
  (format ";;; %s ends here" (dummy-package-filename package-name)))

(defun dummy-package-insert (name description &optional version requirements)
  (insert
     (concat
      (dummy-package-header name description version)
      (dummy-package-requirements requirements)
      (dummy-package-footer name))))

(defun dummy-package-install (name description &optional version requirements)
  (with-temp-buffer
    (dummy-package-insert name description version requirements)
    (package-install-from-buffer)))

(defun dummy-package-generate (name description &optional version requirements)
  (let ((buf (generate-new-buffer (dummy-package-filename name))))
    (with-current-buffer buf
      (dummy-package-insert name description version requirements))
    (switch-to-buffer-other-window buf)
    (package-buffer-info)))

(provide 'dummy-package)
;;; dummy-package.el ends here
