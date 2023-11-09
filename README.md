
Hud Nav component
----

```cirru
{}
  :dependencies $ {}
    |Triadica/hud-nav |main
```

```cirru
hud-nav.comp :refer $ comp-hud-nav
```

```cirru
comp-hud-nav tab tabs $ fn (next d!)
    d! $ :: :tab next
```

```cirru
def tabs $ []
  :: :a |A :light
  :: :b |B :dark
```

### Workflow

https://github.com/calcit-lang/respo-calcit-workflow

### License

MIT
