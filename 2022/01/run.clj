; Usage: clojure -M run.clj test

(require '[clojure.string :as str])

; Import file data into collection of integers
(def filedata (slurp (first *command-line-args*)))

(defn group_and_sum [group]
  (reduce +
    (map #(Integer/parseInt %)
         (str/split group #"\n"))))

(def group_sums
  (map group_and_sum
    (str/split filedata #"\n\n")
  )
)

; Day 1 problem 1
(println (reduce max group_sums))

; Day 1 problem 2
(println (reduce + (take-last 3 (sort group_sums))))
