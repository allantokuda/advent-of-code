; Import file data into collection of integers
(def filename (first *command-line-args*))
(def nums
  (map #(Integer/parseInt %)
    (with-open [rdr (clojure.java.io/reader filename)]
      (reduce conj [] (line-seq rdr)))))

; Day 1 problem 1
(defn diff [vals]
  (count
    (filter identity
      (map > (next vals) vals))))

; Print result
(println (diff nums))
