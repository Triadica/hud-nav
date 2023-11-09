
{} (:package |hud-nav)
  :configs $ {} (:init-fn |hud-nav.main/main!) (:reload-fn |hud-nav.main/reload!) (:version |0.0.1)
    :modules $ [] |respo.calcit/ |lilac/ |memof/ |respo-ui.calcit/ |reel.calcit/
  :entries $ {}
  :files $ {}
    |hud-nav.comp $ %{} :FileEntry
      :defs $ {}
        |comp-hud-nav $ %{} :CodeEntry (:doc |)
          :code $ quote
            defcomp comp-hud-nav (tab tabs on-change)
              div
                {} $ :class-name style-nav
                list-> ({})
                  -> tabs $ map
                    fn (pair)
                      let
                          t $ nth pair 0
                          name $ nth pair 1
                        [] t $ div
                          {}
                            :class-name $ str-spaced style-tab css/font-fancy!
                            :on-click $ fn (e d!)
                              d! $ :: :tab t (nth pair 2)
                            :style $ if (= tab t)
                              {} $ :color :white
                          <> name
        |style-nav $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle style-nav $ {}
              "\"&" $ {} (:position :absolute) (:top 12)
        |style-tab $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle style-tab $ {}
              "\"&" $ {} (:line-height "\"1.4") (:margin-top 2) (:padding "\"0 8px") (:width :fit-content)
                :color $ hsl 0 0 100 0.5
                :cursor :pointer
                :transition-duration "\"200ms"
                :border-radius "\"4px"
                :background-color $ hsl 0 0 0 0.2
              "\"&:hover" $ {}
                :background-color $ hsl 0 0 0 0.5
                :color :white
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns hud-nav.comp $ :require (respo-ui.css :as css)
            respo.css :refer $ defstyle
            respo.util.format :refer $ hsl
            respo.core :refer $ defcomp defeffect <> >> div button textarea span input list->
            respo.comp.space :refer $ =<
    |hud-nav.comp.container $ %{} :FileEntry
      :defs $ {}
        |comp-container $ %{} :CodeEntry (:doc |)
          :code $ quote
            defcomp comp-container (reel)
              let
                  store $ :store reel
                  states $ :states store
                  cursor $ or (:cursor states) ([])
                  state $ or (:data states)
                    {} $ :content "\""
                  tab $ :tab store
                div
                  {} $ :class-name (str-spaced css/global css/row)
                  comp-hud-nav
                    or tab $ nth (nth tabs 0) 0
                    , tabs $ fn (next d!)
                      d! $ :: :tab next
                  when dev? $ comp-reel (>> states :reel) reel ({})
        |tabs $ %{} :CodeEntry (:doc |)
          :code $ quote
            def tabs $ [] (:: :a |A :light) (:: :b |B :light) (:: :c |C :light)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns hud-nav.comp.container $ :require (respo-ui.css :as css)
            respo.css :refer $ defstyle
            respo.core :refer $ defcomp defeffect <> >> div button textarea span input
            respo.comp.space :refer $ =<
            reel.comp.reel :refer $ comp-reel
            hud-nav.config :refer $ dev?
            hud-nav.comp :refer $ comp-hud-nav
    |hud-nav.config $ %{} :FileEntry
      :defs $ {}
        |dev? $ %{} :CodeEntry (:doc |)
          :code $ quote
            def dev? $ = "\"dev" (get-env "\"mode" "\"release")
        |site $ %{} :CodeEntry (:doc |)
          :code $ quote
            def site $ {} (:storage-key "\"workflow")
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote (ns hud-nav.config)
    |hud-nav.main $ %{} :FileEntry
      :defs $ {}
        |*reel $ %{} :CodeEntry (:doc |)
          :code $ quote
            defatom *reel $ -> reel-schema/reel (assoc :base schema/store) (assoc :store schema/store)
        |dispatch! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn dispatch! (op)
              when
                and config/dev? $ not= op :states
                js/console.log "\"Dispatch:" op
              reset! *reel $ reel-updater updater @*reel op
        |main! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn main! ()
              println "\"Running mode:" $ if config/dev? "\"dev" "\"release"
              if config/dev? $ load-console-formatter!
              render-app!
              add-watch *reel :changes $ fn (reel prev) (render-app!)
              listen-devtools! |k dispatch!
              js/window.addEventListener |beforeunload $ fn (event) (persist-storage!)
              js/window.addEventListener |visibilitychange $ fn (event)
                if (= "\"hidden" js/document.visibilityState) (persist-storage!)
              flipped js/setInterval 60000 persist-storage!
              let
                  raw $ js/localStorage.getItem (:storage-key config/site)
                when (some? raw)
                  dispatch! $ :: :hydrate-storage (parse-cirru-edn raw)
              println "|App started."
        |mount-target $ %{} :CodeEntry (:doc |)
          :code $ quote
            def mount-target $ js/document.querySelector |.app
        |persist-storage! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn persist-storage! ()
              println "\"Saved at" $ .!toISOString (new js/Date)
              js/localStorage.setItem (:storage-key config/site)
                format-cirru-edn $ :store @*reel
        |reload! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn reload! () $ if (nil? build-errors)
              do (remove-watch *reel :changes) (clear-cache!)
                add-watch *reel :changes $ fn (reel prev) (render-app!)
                reset! *reel $ refresh-reel @*reel schema/store updater
                hud! "\"ok~" "\"Ok"
              hud! "\"error" build-errors
        |render-app! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn render-app! () $ render! mount-target (comp-container @*reel) dispatch!
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns hud-nav.main $ :require
            respo.core :refer $ render! clear-cache!
            hud-nav.comp.container :refer $ comp-container
            hud-nav.updater :refer $ updater
            hud-nav.schema :as schema
            reel.util :refer $ listen-devtools!
            reel.core :refer $ reel-updater refresh-reel
            reel.schema :as reel-schema
            hud-nav.config :as config
            "\"./calcit.build-errors" :default build-errors
            "\"bottom-tip" :default hud!
    |hud-nav.schema $ %{} :FileEntry
      :defs $ {}
        |store $ %{} :CodeEntry (:doc |)
          :code $ quote
            def store $ {} (:tab nil)
              :states $ {}
                :cursor $ []
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote (ns hud-nav.schema)
    |hud-nav.updater $ %{} :FileEntry
      :defs $ {}
        |updater $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn updater (store op op-id op-time)
              tag-match op
                  :states cursor s
                  update-states store cursor s
                (:tab t) (assoc store :tab t)
                (:hydrate-storage data) data
                _ $ do (eprintln "\"unknown op:" op) store
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns hud-nav.updater $ :require
            respo.cursor :refer $ update-states
