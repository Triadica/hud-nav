
Hud Nav component
----

```cirru
{}
  :dependencies $ {}
    |Triadica/hud-nav |0.0.5
```

```cirru
hud-nav.comp :refer $ comp-hud-nav
hud-nav.schema :refer $ TabItem Op
```

```cirru
comp-hud-nav tab tabs
```

```cirru
def tabs $ []
  %{} TabItem (:id :a) (:label |A)
  %{} TabItem (:id :b) (:label |B)
```

`comp-hud-nav` 接收当前 Tag 和 `List<TabItem>`，点击会发送 `%:: Op :tab next` 事件；不再接收第三个回调参数。消费项目将 `dispatch-op` 类型槽绑定到 `hud-nav.schema/Op`，在 updater 中匹配 `(:tab next)`。

上面的 `0.0.5` 是当前已发布版本，本次 Calcit 0.27 迁移尚未另行发布。需要升级的下游应等待兼容正式版本，不引用 main 或提交 hash。

### Workflow

使用 Calcit 0.27.0、Caps 0.1.1、Node.js 24、Yarn 4.18.0：

```sh
caps --strict --ci
corepack yarn install --immutable
caps verify --toolchain
corepack yarn dev
```

持续编译可另开终端执行 `corepack yarn watch`。`corepack yarn build` 生成演示站，`release` 只是构建别名，不执行模块发布。只维护 `calcit.cirru` / `deps.cirru`；`js-out/` 不提交。

CI 通过 `VITE_BASE_URL=https://cos-sh.tiye.me/Triadica/hud-nav/` 指定前端 CDN，COS action v1.2.0 的 `public-base-url` 启用内置校验，不额外添加验证脚本。需要 `COS_BUCKET`、`COS_SECRET_ID`、`COS_SECRET_KEY` 和原有 `rsync_private_key`。

PR 只检查与构建；main 当前提交才上传生产资源。保留原服务器目录，排队中的部署不取消。Respo/UI/js-ffi 使用已发布兼容版本，后续优先替换为兼容正式版。

### License

MIT
