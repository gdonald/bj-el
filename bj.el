;;; bj.el --- The game of Blackjack

;; Copyright (C) 2022 Greg Donald

;; Author: Greg Donald <gdonald@gmail.com>
;; Version: 1.0
;; Package-Requires: ()
;; Keywords: games
;; URL: https://https://github.com/gdonald/bj-el

;;; Commentary:
;;; This package lets you play Blackjack in Emacs.

;;; Code:
(defun bj ()
  "The game of Blackjack."
  (interactive)
  (let ((buffer-name "bj"))
    (get-buffer-create buffer-name)
    (switch-to-buffer buffer-name)
    (with-current-buffer buffer-name
      (let ((bj-game (bj-create-game)))
        (bj-deal-hand bj-game)
        (bj-draw bj-game)))))

(defun bj-create-game ()
  "Create initial game state."
  (interactive)
  '(
    ;;(shoe . nil)
    (dealer-hand . (cards . nil))
    (player-hands . nil)
    (num-decks . 1)
    (money . 10000)
    (current-bet . 500)))

(defun bj-draw (game)
  "GAME top level draw function."
  ;; (erase-buffer)
  (insert "\n  Dealer:")
  (insert "\n\n  Player:\n\n")
  (insert "  ")

  (let ((map (make-sparse-keymap)))
    (define-key map [mouse-1] 'blackjack-deal-hand)
    (insert (propertize "[Deal Hand]" 'keymap map 'mouse-face 'highlight 'help-echo "Deal Hand") "  "))

  (let ((map (make-sparse-keymap)))
    (define-key map [mouse-1] 'blackjack-quit)
    (insert (propertize "[Quit]" 'keymap map 'mouse-face 'highlight 'help-echo "Quit") "  ")))

(defun bj-need-to-shuffle (game)
  "GAME are we almost out of cards?"
  t)

(defun bj-shuffle (game)
  "GAME re-shuffle the shoe."
  (let ((cards nil)
        (x 0))
    (dotimes (suit 4)
      (dotimes (value 13)
        (push `(,x . (,value . ,suit)) cards)
        (setf x (1+ x))))
    ;;(setf cards (bj-shuffle-cards cards))
    (setf game (cons `(shoe . ,cards) game)))
  game)

(defun bj-deal-hand (game)
  "GAME deal a new hand."
  ;; (if (bj-need-to-shuffle game)
  ;;     (bj-shuffle game))
  (bj-shuffle game)

  (dolist (card (assq 'shoe game))
    (insert card))

  )

(defun bj-quit (game)
  "GAME quit.")

(defun bj-shuffle-cards (cards)
  "CARDS shuffle."
  (dotimes (* 7 (number (length cards)))
    (setf cards (bj-swap cards)))
  cards)

(defun bj-swap (cards)
  "CARDS swap."
  (let* ((rand (random (length cards)))
         (item (assq rand cards))
         (cards (delq (assq rand cards) cards))
         (cards (cons item cards))))
  cards)

(defun bj-p (x)
  "X prints x."
  (move-end-of-line 0)
  (insert (format "\n%s" x)))

(provide 'bj)
;;; bj.el ends here