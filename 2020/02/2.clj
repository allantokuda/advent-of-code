;(with-open [rdr (clojure.java.io/reader "pw")] (reduce conj [] (line-seq rdr)))
(require '[clojure.string :as str])

(print
  (with-open [rdr (clojure.java.io/reader "pw")]
    (map
      #(str/split % #" ")
      (line-seq rdr)
    )
  )
)