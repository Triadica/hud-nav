
Hud Nav component
----

### 当前已发布版本

以下是现有正式 tag 的依赖声明，不包含下文待发布的 Calcit 0.29 接口。

```cirru
{}
  :dependencies $ {}
    |Triadica/hud-nav |0.0.4
```

### 待发布的 Calcit 0.29 接口（0.0.5）

以下示例仅对应本次迁移后的源码，**不能与上面的 `0.0.4` 搭配使用**。
下游请等待包含本次迁移的正式版本发布后再采用，不使用 main 或提交 hash。

```cirru
hud-nav.comp :refer $ comp-hud-nav
hud-nav.schema :refer $ TabItem Op
```

```cirru
comp-hud-nav tab tabs
```

```cirru
def tabs $ []
  TabItem :id :a :label |A
  TabItem :id :b :label |B
```

`comp-hud-nav` 接收当前 Tag 和 `List<TabItem>`，点击会发送 `Op :tab next` 事件；不再接收第三个回调参数。消费项目将 `dispatch-op` 类型槽绑定到 `hud-nav.schema/Op`，在 updater 中匹配 `(:tab next)`。

`Op :hydrate-storage` 接收 `Store`，而不是任意 Dynamic。外部持久化 Map 需先用 `decode-map-as data hud-nav.schema/Store` 检查，再构造该事件。

当前已发布版本是 `0.0.4`；源码中的 `0.0.5` 是待发布版本。需要升级的下游应等待正式 tag 发布，不引用 main 或提交 hash。

### Workflow

使用 Calcit 0.29.0、Caps 0.1.1、Node.js 24、Yarn 4.18.0：

```sh
caps --strict --ci
corepack yarn install --immutable
caps verify --toolchain
corepack yarn dev
```

持续编译可另开终端执行 `corepack yarn watch`。`corepack yarn build` 生成演示站，`release` 只是构建别名，不执行模块发布。只维护 `calcit.cirru` / `deps.cirru`；`js-out/` 不提交。

CI 通过 `VITE_BASE_URL=https://cos-sh.tiye.me/Triadica/hud-nav/` 指定前端 CDN，COS action v1.2.0 的 `public-base-url` 启用内置校验，不额外添加验证脚本。需要 `COS_BUCKET`、`COS_SECRET_ID`、`COS_SECRET_KEY` 和原有 `rsync_private_key`。

PR 只检查与构建，取消过期 PR 检查。COS 仅上传 `dist/assets`，页面继续同步到原服务器目录。生产任务串行完成，不中途取消 rsync；资产上传前和页面发布前分别核对 main HEAD，不承诺检查与部署时刻的原子同步。Respo/UI/js-ffi 均使用正式发布版本。

### License

MIT
