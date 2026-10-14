
Hud Nav component
----

### 当前已发布版本

使用者影响：候选 `0.0.7` 同步正式 Calcit `0.29.3` 与正式 UI/Respo/JS-FFI 依赖图。`TabItem`、`Op`、`Store` 和 `comp-hud-nav` 两参数接口不变；demo 在 renderer 的开放回调处检查真实 `Op` 后才调用原有具名 dispatcher，不把 dispatcher 放宽成 Dynamic。候选尚未发布，消费者先固定下方现有正式 tag。

以下是现有正式 tag 的依赖声明，包含下文 Calcit 0.29 接口。

```cirru
{}
  :dependencies $ {}
    |Triadica/hud-nav |0.0.6
```

### Calcit 0.29 接口（自 0.0.5 起）

以下示例对应已发布的 `0.0.5` 接口，不能与旧 `0.0.4` 搭配使用。
本分支的候选 `0.0.7` 对齐 Calcit 0.29.3、Respo 0.16.120、UI 0.7.39 和 JS-FFI 0.2.3；
发布前不要把候选视为已发布依赖，不使用 main 或提交 hash。

组件示例面向 JavaScript/浏览器；文档检查只静态验证，不在 native 文档 runner 中执行浏览器 CSS 宿主逻辑。

```cirru.no-run
ns app.main $ :require
  hud-nav.comp :refer $ comp-hud-nav
  hud-nav.schema :refer $ TabItem

let
    tabs $ []
      TabItem :id :a :label |A
      TabItem :id :b :label |B
  comp-hud-nav :a tabs
```

`comp-hud-nav` 接收当前 Tag 和 `List<TabItem>`，点击会发送 `Op :tab next` 事件；不再接收第三个回调参数。消费项目将 `dispatch-op` 类型槽绑定到 `hud-nav.schema/Op`，在 updater 中匹配 `(:tab next)`。

`Op :hydrate-storage` 接收 `Store`，而不是任意 Dynamic。外部持久化 Map 需先用 `decode-map-as data hud-nav.schema/Store` 检查，再构造该事件。

当前已发布版本是 `0.0.6`；源码中的 `0.0.7` 是待发布版本。需要新的依赖组合时应等待正式 tag 发布，不引用 main 或提交 hash。

开放 renderer 边界通过现有 Cirru EDN formatter/typed parser 检查两个变体及嵌套 Store，增加每次事件一次序列化/解析成本。它保留 `Op :tab` 和 `Op :hydrate-storage` 两条路径，不把检查成功当成 Respo 整条事件链已经完成静态类型贯通；没有新增改写规则或验证脚本。

### Workflow

使用 Calcit 0.29.3、Caps 0.1.1、Node.js 24、Yarn 4.18.0：

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
