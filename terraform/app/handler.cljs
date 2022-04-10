(ns handler
  (:require ["got$default" :as got]
            [promesa.core :as p]))


(defn handler [event _ctx]
  (js/console.log "Hey there.")
  (p/let [result  (-> got
                      (.post "https://httpbin.org/anything" (clj->js {:json event}))
                      .json)]
    (clj->js {:statusCode 200
              :body (js/JSON.stringify result)})))

#js {:handler handler}
