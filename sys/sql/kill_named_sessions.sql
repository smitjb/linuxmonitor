;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.


select 'alter system kill session '''||sid||','||serial#||''';' from v$session where usernameaupper=('&&USERNAME');
