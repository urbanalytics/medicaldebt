# Code files

Both larger code files, and code files that are used by different
scripts


## case-annotate-mode.el

Emacs lisp annotator for addresses and cases

Usage:

Load new case with `(load-new-case)`

Keyboard shortcuts:
* `C-c c n`: mark-city-name
* `C-c c t`: mark-city-type
* `C-c o n`: mark-county-name
* `C-c o t`: mark-county-type
* `C-c k n`: mark-court-name
* `C-c k t`: mark-court-type
* `C-c h n`: mark-house-name
* `C-c h t`: mark-house-type
* `C-c d r`: mark-predirection
* `C-c d o`: mark-postdirection
* `C-c t n`: mark-state-name
* `C-c t t`: mark-state-type
* `C-c s n`: mark-street-name
* `C-c s t`: mark-street-type
* `C-c u n`: mark-unit-name
* `C-c u t`: mark-unit-type
* `C-c z`:   mark-zip
* `C-c .`:   clear-field
* `C-x C-s`: output marked entities to json, file _annotations.ant_.
  This will be automatically saved.
