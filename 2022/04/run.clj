; Usage: clojure -M run.clj test

(use '[clojure.string :only [index-of split join]])
(use '[clojure.set :only [difference intersection]])

; Generic tooling for readability
(defn split_map [delim coll fn] (map fn (split coll delim)))
(defn inclusive_range [range_bounds] (let [[start end] range_bounds] (range start (inc end))))

; Data intake and structuring
(def filedata (slurp (first *command-line-args*)))
(def pairs (split_map #"\n" filedata
             (fn [line] (sort-by count (split_map #"," line
               (fn [range_str] (set (inclusive_range (split_map #"-" range_str
                 #(Integer/parseInt %))))))))))

; Part 1
(defn full_overlap [pair] (if (empty? (apply difference pair)) 1 0))
(println (reduce + (map full_overlap pairs)))

; Part 2
(defn any_overlap [pair] (if (empty? (apply intersection pair)) 0 1))
(println (reduce + (map any_overlap pairs)))
