;;; sx-cache.el --- caching for stack-mode

;; Copyright (C) 2014  Sean Allred

;; Author: Sean Allred <code@seanallred.com>

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

(defcustom sx-cache-directory
  (expand-file-name ".stackmode" user-emacs-directory)
  "Directory containined cached files and precompiled filters.")

(defun sx-cache-get-file-name (filename)
  "Expands FILENAME in the context of `sx-cache-directory'."
  (expand-file-name filename sx-cache-directory))

(defun sx-cache-get (cache)
  "Return the data within CACHE.

As with `sx-cache-set', CACHE is a file name within the
context of `sx-cache-directory'."
  (unless (file-exists-p sx-cache-directory)
    (mkdir sx-cache-directory))
  (let ((file (sx-cache-get-file-name cache)))
    (when (file-exists-p file)
      (with-temp-buffer
        (insert-file-contents (sx-cache-get-file-name cache))
        (read (buffer-string))))))

(defun sx-cache-set (cache data)
  "Set the content of CACHE to DATA.

As with `sx-cache-get', CACHE is a file name within the
context of `sx-cache-directory'.

DATA will be written as returned by `prin1'."
  (unless (file-exists-p sx-cache-directory)
    (mkdir sx-cache-directory))
  (write-region (prin1-to-string data) nil
                (sx-cache-get-file-name cache))
  data)

(provide 'sx-cache)
;;; sx-cache.el ends here

;; Local Variables:
;; indent-tabs-mode: nil
;; End: