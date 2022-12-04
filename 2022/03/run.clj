; Usage: clojure -M run.clj test

(use '[clojure.string :only [index-of split join]])
(use '[clojure.set :only [intersection]])

(def filedata (slurp (first *command-line-args*)))
(def sacks (map #(split % #"") (split filedata #"\n")))

; Priority definition
(def priority "_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
(defn priorityOf [letter] (index-of priority letter))

; Part 1
(defn bisect [sack] (partition (/ (count sack) 2) sack))
(defn sackLetter [sack] (first (reduce intersection (map set (bisect sack))))) ; overlap between compartments in same sack
(defn sackPriority [sack] (priorityOf (sackLetter sack)))
(println (reduce + (map sackPriority sacks)))

; Part 2
(defn groupLetter [group] (first (reduce intersection (map set group))))
(println (reduce + (map priorityOf (map groupLetter (partition 3 sacks)))))
