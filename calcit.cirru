
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |hud-nav
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'hud-nav.main/main!) (:mode :js) (:reload-fn 'hud-nav.main/reload!)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |respo-ui.calcit/
      :type-slots $ {} $ :dispatch-op |hud-nav.schema/Op
  :files $ {}
    'hud-nav.comp $ %{} 'FileEntry
      :defs $ {}
        'comp-hud-nav $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-hud-nav (tab tabs)
            div
              {} $ :class-name style-nav
              list-> ({})
                -> tabs $ map $ fn (item)
                  let
                      t $ :id item
                    [] (turn-string t)
                      div
                        {}
                          :class-name $ str-spaced style-tab css/font-fancy!
                          :on-click $ fn (e d!)
                            d! $ :: Op :tab t
                          :style $ if (= tab t)
                            {} $ :color :white
                        <> $ :label item
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] 'hud-nav.schema/Tab $ :: 'List 'hud-nav.schema/TabItem
        'style-nav $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-nav
            {} $ |& $ {} (:position :absolute) (:top 12)
          :examples $ []
          :schema $ :: 'String
        'style-tab $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-tab
            {}
              |& $ {} (:line-height |1.4) (:margin-top 2) (:padding "|0 8px") (:width :fit-content)
                :color $ hsl 0 0 100 0.5
                :cursor :pointer
                :transition-duration |200ms
                :border-radius |4px
                :background-color $ hsl 0 0 0 0.2
              |&:hover $ {}
                :background-color $ hsl 0 0 0 0.5
                :color :white
          :examples $ []
          :schema $ :: 'String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns hud-nav.comp
          :require (respo-ui.css :as css)
            respo.css :refer $ defstyle
            respo.util.format :refer $ hsl
            respo.core :refer $ defcomp <> div list->
            hud-nav.schema :refer $ Op Tab TabItem
    'hud-nav.comp.container $ %{} 'FileEntry
      :defs $ {} $ 'comp-container
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-container (store)
            let
                tab $ :tab store
              div
                {} $ :class-name $ str-spaced css/global css/row
                comp-hud-nav tab schema/tabs
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] 'hud-nav.schema/Store
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns hud-nav.comp.container
          :require (respo-ui.css :as css)
            respo.core :refer $ defcomp div
            hud-nav.config :refer $ dev?
            hud-nav.schema :as schema
            hud-nav.schema :refer $ Store
            hud-nav.comp :refer $ comp-hud-nav
    'hud-nav.config $ %{} 'FileEntry
      :defs $ {}
        'dev? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def dev?
            = |dev $
              get-env |mode
              , .unwrap-or |release
          :examples $ []
          :schema $ :: 'Bool
        'site $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def site
            {} $ :storage-key |workflow
          :examples $ []
          :schema $ :: 'Map 'Tag 'String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns hud-nav.config
    'hud-nav.main $ %{} 'FileEntry
      :defs $ {}
        '*store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defatom *store schema/store
          :examples $ []
          :schema $ :: 'Ref 'hud-nav.schema/Store
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op)
            reset! *store $ updater @*store op
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'hud-nav.schema/Op
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! () (render-app!)
            add-watch *store :changes $ fn (s prev) (render-app!)
            println "|App started."
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! () (render-app!)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            let
                target $ js/document.querySelector |.app
              render! target (comp-container @*store) dispatch!
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns hud-nav.main
          :require
            respo.core :refer $ render!
            hud-nav.comp.container :refer $ comp-container
            hud-nav.updater :refer $ updater
            hud-nav.schema :as schema
    'hud-nav.schema $ %{} 'FileEntry
      :defs $ {}
        'Op $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum Op (:tab 'hud-nav.schema/Tab) (:hydrate-storage 'Dynamic)
          :examples $ []
          :schema $ :: 'Enum
        'Store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Store (:tab 'hud-nav.schema/Tab)
          :examples $ []
          :schema $ :: 'Enum
        'Tab $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum Tab :a :b :c
          :examples $ []
          :schema $ :: 'Enum
        'TabItem $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct TabItem (:id 'hud-nav.schema/Tab) (:label 'String)
          :examples $ []
          :schema $ :: 'Enum
        'store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def store
            %{} Store $ :tab :a
          :examples $ []
          :schema $ :: 'hud-nav.schema/Store
        'tabs $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def tabs
            []
              %{} TabItem (:id :a) (:label |A)
              %{} TabItem (:id :b) (:label |B)
              %{} TabItem (:id :c) (:label |C)
          :examples $ []
          :schema $ :: 'List 'hud-nav.schema/TabItem
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns hud-nav.schema
    'hud-nav.updater $ %{} 'FileEntry
      :defs $ {} $ 'updater
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defn updater (store op)
            match op
              (:tab t)
                do $ assoc store :tab t
              (:hydrate-storage data) (do data)
              _ $ do store
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'hud-nav.schema/Store)
            :args $ [] 'hud-nav.schema/Store 'hud-nav.schema/Op
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns hud-nav.updater
