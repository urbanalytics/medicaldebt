;;; Emacs minor mode plus some more functionality to annotate texts
;;;
;;; Usage:
;;;
;;; Keyboard shortcuts:
;;; C-c c n: mark-city-name
;;; C-c c t: mark-city-type
;;; C-c o n: mark-county-name
;;; C-c o t: mark-county-type
;;; C-c k n: mark-court-name
;;; C-c k t: mark-court-type
;;; C-c h n: mark-house-name
;;; C-c h t: mark-house-type
;;; C-c d r: mark-predirection
;;; C-c d o: mark-postdirection
;;; C-c t n: mark-state-name
;;; C-c t t: mark-state-type
;;; C-c s n: mark-street-name
;;; C-c s t: mark-street-type
;;; C-c u n: mark-unit-name
;;; C-c u t: mark-unit-type
;;; C-c z:   mark-zip
;;; C-c .:   clear-field
;;; C-x C-s  output-entities


;;; -------------------- highlighting text --------------------
;; palette from http://hclwizard.org:3000/hclwizard/
;; light version: hue1: 0, hue2: 360; chroma 35, lum: 90
;; dark version hue1: 0, hue2: 360; chroma 35, lum: 50
(setq address-light-colors '("#FFD4DE" "#FFDAC3" "#EAE4B5" "#C9ECBF" "#ADF0D8" "#ABEEF4" "#C6E6FF" "#EBDBFF" "#FFD4F9"))
(setq address-dark-colors '("#9F6873" "#956F55" "#7E7846" "#5D8051" "#36846D" "#2D8288" "#577B9A" "#806F9C" "#99678D"))
;; Use the colors as following
;; 1-light: city name
(setq city-name-face (list ':background (nth 0 address-light-colors)
			   ':foreground "black"))
(setq city-type-face (list ':background (nth 0 address-dark-colors)
			   ':foreground "white"))
(setq court-name-face (list ':background (nth 1 address-light-colors)
			    ':foreground "black"))
(setq court-type-face (list ':background (nth 1 address-dark-colors)
			    ':foreground "white"))
(setq house-name-face (list ':background (nth 2 address-light-colors)
			    ':foreground "black"))
(setq house-type-face (list ':background (nth 2 address-dark-colors)
			    ':foreground "white"))
(setq predirection-face (list ':background (nth 3 address-light-colors)
			    ':foreground "black"))
(setq postdirection-face (list ':background (nth 3 address-dark-colors)
			    ':foreground "white"))
(setq state-name-face (list ':background (nth 4 address-light-colors)
			    ':foreground "black"))
(setq state-type-face (list ':background (nth 4 address-dark-colors)
			    ':foreground "white"))
(setq street-name-face (list ':background (nth 5 address-light-colors)
			    ':foreground "black"))
(setq street-type-face (list ':background (nth 5 address-dark-colors)
			    ':foreground "white"))
(setq unit-name-face (list ':background (nth 6 address-light-colors)
			    ':foreground "black"))
(setq unit-type-face (list ':background (nth 6 address-dark-colors)
			    ':foreground "white"))
(setq zip-type-face (list ':background (nth 7 address-light-colors)
			    ':foreground "black"))
(setq county-name-face (list ':background (nth 8 address-light-colors)
			    ':foreground "black"))
(setq county-type-face (list ':background (nth 8 address-dark-colors)
			    ':foreground "white"))

(defun clear-field ()
  "Clear the current address field definition"
  (interactive)
  (let ((buffer-read-only nil))
    (set-text-properties (point) (mark) nil)
    )
  )

(defun get-entity (position)
  "Find the entity name and position in the current buffer
Return:
 (list name start end) if entity found, nil if no entity at position
  'name': entity name
  'start', 'end': start and end buffer positions of the field
Arguments:
 position: the buffer position to get entity from
"
  (setq entity-name (get-text-property position
				       'field))
    ;; text to returned and be put into the file
    ;; initialize to empty in case entity-name is nil
    (setq entity-text "")
    (if entity-name
	(progn
	  ;; we have an entity: return it's data
	  (setq entity-start (field-beginning
			       (1+ position))
		)
	  (setq entity-end (field-end
			    (1+ position))
		)
	  (list entity-name entity-start entity-end)
	  )
      ;; no entity here: return nil
      nil
      )
    )

(defun mark-city-name (beg end)
  "Mark the buffer content from 'beg' to 'end' as CITY-NAME
beg, end are buffer positions"
  (interactive "r")
  (save-excursion
    (let ((buffer-read-only nil))
      (set-text-properties beg end nil)  ; clear properties
      (add-face-text-property beg end city-name-face)
      (put-text-property beg end 'field "city-name")
      )
    )
  )

(defun mark-city-type (beg end)
  "Mark the buffer content from 'beg' to 'end' as CITY-TYPE
beg, end are buffer positions"
  (interactive "r")
  (save-excursion
    (let ((buffer-read-only nil))
      (set-text-properties beg end nil)  ; clear properties
      (add-face-text-property beg end city-type-face)
      (put-text-property beg end 'field "city-type")
      )
    )
  )

(defun mark-county-name (beg end)
  "Mark the current word as COUNTY-NAME"
  (interactive "r")
  (save-excursion
    (let ((buffer-read-only nil))
      (set-text-properties beg end nil)  ; clear properties
      (add-face-text-property beg end county-name-face)
      (put-text-property beg end 'field "county-name")
      )
    )
  )

(defun mark-county-type (beg end)
  "Mark the current word as COUNTY-TYPE"
  (interactive "r")
  (save-excursion
    (let ((buffer-read-only nil))
      (set-text-properties beg end nil)  ; clear properties
      (add-face-text-property beg end county-type-face)
      (put-text-property beg end 'field "county-type")
      )
    )
  )

(defun mark-court-name (beg end)
  "Mark the current word as COURT-NAME"
  (interactive "r")
  (save-excursion
    (let ((buffer-read-only nil))
      (set-text-properties beg end nil)  ; clear properties
      (add-face-text-property beg end court-name-face)
      (put-text-property beg end 'field "court-name")
      )
    )
  )

(defun mark-court-type (beg end)
  "Mark the current word as COURT-TYPE"
  (interactive "r")
  (save-excursion
    (let ((buffer-read-only nil))
      (set-text-properties beg end nil)  ; clear properties
      (add-face-text-property beg end court-type-face)
      (put-text-property beg end 'field "court-type")
      )
    )
  )

(defun mark-house-name (beg end)
  "Mark the buffer content from 'beg' to 'end' as HOUSE-NAME
beg, end are buffer positions"
  (interactive "r")
  (save-excursion
    (let ((buffer-read-only nil))
      (set-text-properties beg end nil)  ; clear properties
      (add-face-text-property beg end house-name-face)
      (put-text-property beg end 'field "house-name")
      )
    )
  )

(defun mark-house-type (beg end)
  "Mark the current word as HOUSE-TYPE"
  (interactive "r")
  (save-excursion
    (let ((buffer-read-only nil))
      (set-text-properties beg end nil)  ; clear properties
      (add-face-text-property beg end house-type-face)
      (put-text-property beg end 'field "house-type")
      )
    )
  )

(defun mark-postdirection (beg end)
  "Mark the current region as POSTDIRECTION"
  (interactive "r")
  (save-excursion
    (let ((buffer-read-only nil))
      (set-text-properties beg end nil)  ; clear properties
      (add-face-text-property beg end postdirection-face)
      (put-text-property beg end 'field "postdirection")
      )
    )
  )

(defun mark-predirection (beg end)
  "Mark the current region as PREDIRECTION"
  (interactive "r")
  (save-excursion
    (let ((buffer-read-only nil))
      (set-text-properties beg end nil)  ; clear properties
      (add-face-text-property beg end predirection-face)
      (put-text-property beg end 'field "predirection")
      )
    )
  )

(defun mark-state-name (beg end)
  "Mark the current word as STATE-NAME"
  (interactive "r")
  (save-excursion
    (let ((buffer-read-only nil))
      (set-text-properties beg end nil)  ; clear properties
      (add-face-text-property beg end state-name-face)
      (put-text-property beg end 'field "state-name")
      )
    )
  )

(defun mark-state-type (beg end)
  "Mark the current word as STATE-TYPE"
  (interactive "r")
  (save-excursion
    (let ((buffer-read-only nil))
      (set-text-properties beg end nil)  ; clear properties
      (add-face-text-property beg end state-type-face)
      (put-text-property beg end 'field "state-type")
      )
    )
  )

(defun mark-street-name (beg end)
  "Mark the buffer content from 'beg' to 'end' as STREET-NAME
beg, end are buffer positions"
  (interactive "r")
  (save-excursion
    (let ((buffer-read-only nil))
      (set-text-properties beg end nil)  ; clear properties
      (add-face-text-property beg end street-name-face)
      (put-text-property beg end 'field "street-name")
      )
    )
  )

(defun mark-street-type (beg end)
  "Mark the current word as STREET-TYPE"
  (interactive "r")
  (save-excursion
    (let ((buffer-read-only nil))
      (set-text-properties beg end nil)  ; clear properties
      (add-face-text-property beg end street-type-face)
      (put-text-property beg end 'field "street-type")
      )
    )
  )

(defun mark-unit-name (beg end)
  "Mark the current word as UNIT-NAME"
  (interactive "r")
  (save-excursion
    (let ((buffer-read-only nil))
      (set-text-properties beg end nil)  ; clear properties
      (add-face-text-property beg end unit-name-face)
      (put-text-property beg end 'field "unit-name")
      )
    )
  )

(defun mark-unit-type (beg end)
  "Mark the current word as UNIT-TYPE"
  (interactive "r")
  (save-excursion
    (let ((buffer-read-only nil))
      (set-text-properties beg end nil)  ; clear properties
      (add-face-text-property beg end unit-type-face)
      (put-text-property beg end 'field "unit-type")
      )
    )
  )

(defun mark-zip (beg end)
  "Mark the buffer content from 'beg' to 'end' as ZIP-CODE
beg, end are buffer positions"
  (interactive "r")
  (save-excursion
    (let ((buffer-read-only nil))
      (set-text-properties beg end nil)  ; clear properties
      (add-face-text-property beg end zip-type-face)
      (put-text-property beg end 'field "zip")
      )
    )
  )

;;; -------------------- loading/saving documents --------------------

;; Constants
(defconst CASE-LIST-FILE "~/tyyq/andmebaasiq/medical-collections/case-list.csv.bz2/"
  "name of the file that contains a list of all cases")
(defconst CASE-PDF-PATH "~/tyyq/andmebaasiq/medical-collections/casefiles/"
  "name of the folder that contains pdf data")
(defconst CASE-TXT-PATH "~/tyyq/andmebaasiq/medical-collections/txt/"
  "name of the folder that contains OCR-d text")
(defconst SUMMONS-PROBABILITY 0.7
  "the probability to pick summons, compared to a random file,
from the list of all case files")
;; file that contains already annotated texts
(setq case-annotations-file
      "~/tyyq/social/medical-collections/staging/case-annotations.ant")
(setq case-annotations-buffer
      (find-file-noselect case-annotations-file)
      )

;; load caselist into a buffer
(with-current-buffer
    (setq case-list-buffer (get-buffer-create "case-list-buffer"))
  (insert-file-contents "case-list.csv.bz2")
  )


(defun convert-entities-to-json ()
  "Output all annotated entities in the current buffer in the form
   state county year case fName entities
   Washington King 2013 13-2-00744 [(0,3,'house-name'),(4,9,'street-name'),(10,16,'street-type'),(18,23,'unit-type'),(24,27,'unit-name'),(28,35,'city-name'),(37,47,'state-name'),(48,53,'zip')]
  "
  (interactive)
  (setq legal-document-buffer (current-buffer))
  (setq position (point-min))
  (setq last-pos (point-max))
  (setq json-of-entities "")  ; all defined entities in json
  (save-mark-and-excursion  ; do not screw up the user's position in file
    (switch-to-buffer legal-document-buffer)
    (goto-char (point-min))
    (while (< position (point-max))
      (setq entity-data (get-entity position))
					; (list name beg end)
      ;; output entity if non-empty
      (if entity-data
	  ;; there was an entity at this position
	  (progn
	    (setq entity-name (first entity-data))
	    (setq entity-beginning (- (second entity-data) (line-beginning-position)))
	    (setq entity-end (- (third entity-data) (line-beginning-position)))
	    (setq json-of-entities
		  (concat json-of-entities
			  ;; include comma b/w parenthesis if this is not the first entity
			  (if (string= json-of-entities "") "" ",")
			  ;; make json out of the current entity
			  "("
			  (number-to-string entity-beginning)
			  ","
			  (number-to-string entity-end)
			  ",\""
			  entity-name
			  "\")"
			  )
		  )
	    (setq position
		  ;; position to look for next entity
		  (1+ (nth 2 entity-data))
		  )
	    )
	;; no entity at that pos: find field end
	(setq position (field-end
					; it reports the end too far by one, but we just want to increment
			(1+ position))
	      )
	)
      )
    (with-current-buffer case-annotations-buffer
      ;; insert a) the case; b) the file name; c) entities into the buffer
      (goto-char (point-max))
      (insert
       (concat
	(replace-regexp-in-string "/" "\t" current-case)
	"\t" current-file
	"\t" json-of-entities "\n"))
      (save-buffer)
      (set-buffer-modified-p nil)
      (setq json-of-entities "")  ; all defined entities in json
      )
    )
  (message "Entities saved in %s" case-annotations-file)
  (kill-buffer)  ; do not keep the case file buffers hanging around
  (kill-buffer case-pdf-buffer)
  (load-new-case)
  )

(defun get-case-pdf (casename filename)
  "download the pdf from the server for given case,
corresponding to the text file.  For instance, if the file is
'summons-000.txt', it downloads 'summons.pdf'
Returns the buffer object
"
  ;; pdf or tif?  get extension from the first
  ;; file that is there at the data folder
  (setq first-file (car (get-filelist casename "pdf")))
  (setq extension
	(substring first-file -4)
	)
  ;;
  (setq pdf-file-name
	(replace-regexp-in-string
	 "-[[:digit:]]\\{3\\}\\.txt" extension filename))
  (message "extension %s, pdf file %s" extension pdf-file-name)
  (setq folder-name (concat CASE-PDF-PATH casename "/" pdf-file-name))
			    ;; (shell-quote-argument casename)
			    ;; "/"
			    ;; (shell-quote-argument pdf-file-name)))
  (setq case-pdf-buffer
	(find-file-other-window
	 (concat "/ssh:" DATA-SERVER-NAME ":" folder-name)
	 )
	)
  case-pdf-buffer
  )


;; get file from a given case
;; display it in a dedicated buffer
;; return the buffer name
(defun get-case-file (casename filename)
  (setq folder-name (concat CASE-TXT-PATH
			    (shell-quote-argument casename)
			    "/"
			    (shell-quote-argument filename)))
  (setq case-file-buffer (get-buffer-create
			  (concat casename "/" filename)))
  (set-buffer case-file-buffer)
  (setq cmd (concat "ssh " DATA-SERVER-NAME
		    " cat " (shell-quote-argument
					; needs double quoting--here too
			     folder-name)))
  (call-process-shell-command cmd nil t)
  case-file-buffer
  )


(defun get-filelist (casename &optional pdf)
  "
Return a list of all files for given case (for text) as a list
The files are listed on nori
pdf: if non-nil, then look for actual pdf (or tif) casefiles,
     otherwise take ocr-d text files
  "
  (with-temp-buffer
    (setq path (if pdf
		   CASE-PDF-PATH
		 CASE-TXT-PATH))
    (message "casename: %s, pdf: %s, folder path: %s" casename pdf path)
    (setq folder-name
	  (concat path
	   (shell-quote-argument casename)))
    (call-process-shell-command
     (concat "ssh nori ls " folder-name)
     nil t)
    (goto-char (point-min))
    (setq files nil)
    (while (not (eobp))
	   (setq file
		 (buffer-substring-no-properties
		  (line-beginning-position)
		  (line-end-position)
		  ))
	   (setq files (cons file files))
	   (forward-line 1)
	   )
    )
  files
  )


(defun load-new-case ()
  "Load new case from nori and start annotation:
   a) pick a random case;
   b) pick a random file from that case;
   c) open it in the annotate window
"
  (interactive)
  ;; 'current-case': current case key as path: 'state/county/year/id'
  (setq current-case (random-case))
  (message "Pick %s" current-case)
  ;; get a file out of all possible for the current case
  (setq case-files (get-filelist current-case))
  (setq current-file
	(select-file case-files))
  (message "File %s" current-file)
  ;; download the file for the current case
  (setq case-file-buffer
	(get-case-file current-case current-file))
  ;; switch to annotation buffer
  (switch-to-buffer case-file-buffer)
  (goto-char (point-min))
  (setq buffer-read-only t)
  (annotate-mode)
  (setq case-file-window (get-buffer-window))
  ;; download the pdf and show in the other window
  (get-case-pdf current-case current-file)
  ;; get back to annotation buffer
  (select-window case-file-window)
  )


;; pick a random case name from buffer
(defun random-case ()
  "return a random case from case-list.csv"
  (with-current-buffer
      (set-buffer case-list-buffer)
    (setq n-cases (line-number-at-pos (point-max)))
    (setq n (random n-cases))
    (goto-char (point-min))
    (forward-line n)
    (buffer-substring-no-properties
     (line-beginning-position)
     (line-end-position)
     )
    )
  )

(defun select-file (file-list)
  "
Select a file from list of files.  If there exist something like
'summons-000.txt' then pick this, otherwise pick a random one
  "
  (setq file-list-copy file-list)
  (setq selected-file nil)
  ;; pick summons or a random case
  (if
      (< 
       (/ (float (abs (random))) most-positive-fixnum)
       SUMMONS-PROBABILITY)
      (progn
	;; pic summons--
	;; is there something like summons-000.txt ?
	(catch 'found-file
	  (while (and file-list-copy (not selected-file))
	    (setq file (pop file-list-copy))
	    (when
		(string-match ".*summons.*-000\\.txt"
			      (downcase file)
			      )
	      (setq selected-file file)
	      (throw 'found-file file)
	      )
	    )
	  )
	;; no summons found--pick a random file
	(if (not selected-file)
	    (setq selected-file
		  (nth (random (length file-list)) file-list)
		  )
	  )
	)
    ;; just pick a random file
    (message "select random file")
    (setq selected-file
	  (nth (random (length file-list)) file-list)
	  )
    )
  selected-file
)
;;; -------------------- keymap and mode --------------------
(setq annotate-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c c n") 'mark-city-name)
    (define-key map (kbd "C-c c t") 'mark-city-type)
    (define-key map (kbd "C-c o n") 'mark-county-name)
    (define-key map (kbd "C-c o t") 'mark-county-type)
    (define-key map (kbd "C-c k n") 'mark-court-name)
    (define-key map (kbd "C-c k t") 'mark-court-type)
    (define-key map (kbd "C-c h n") 'mark-house-name)
    (define-key map (kbd "C-c h t") 'mark-house-type)
    (define-key map (kbd "C-c d r") 'mark-predirection)
    (define-key map (kbd "C-c d o") 'mark-postdirection)
    (define-key map (kbd "C-c t n") 'mark-state-name)
    (define-key map (kbd "C-c t t") 'mark-state-type)
    (define-key map (kbd "C-c s n") 'mark-street-name)
    (define-key map (kbd "C-c s t") 'mark-street-type)
    (define-key map (kbd "C-c u n") 'mark-unit-name)
    (define-key map (kbd "C-c u t") 'mark-unit-type)
    (define-key map (kbd "C-c z") 'mark-zip)
    (define-key map (kbd "C-c C-z") 'mark-zip)
    (define-key map (kbd "C-c .") 'clear-field)  ; clear property
    (define-key map (kbd "C-c #") 'convert-entities-to-json)
    map)
  )

(define-minor-mode annotate-mode
  "Annotate address lines for parsing the parts."
  :lighter " Ant"
  (setq inhibit-field-text-motion t)  ; motion/line end does not care about fields
  )
