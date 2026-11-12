# HUD Nav

Respo 的标签导航组件，演示站：http://repo.tiye.me/Triadica/hud-nav/ 。

## 使用者需要注意

当前源码配对正式 Calcit / JavaScript runtime **0.42.1**、Respo **0.19.5**、UI **0.15.2** 与 JS FFI **0.2.13**。消费者升级时需要统一依赖并重新生成 JS。源码声明为候选 `0.0.11`，选用已发布依赖时请核对 Git tag。

`comp-hud-nav` 仍接收当前 Tag 和 `List<TabItem>`。点击派发具名 `Op :tab next`，消费者继续把 entry 的 `dispatch-op` 槽绑定到 `hud-nav.schema/Op`。组件内部使用 Respo 的 `ChildPair` 渲染有键子项，并通过 `Option` 表达未选中标签没有内联颜色。标签顺序、字符串键和选中颜色保持原样。

`Op :hydrate-storage` 仍携带 `Store`，原附带测试继续覆盖切换标签、恢复 Store 和拒绝非法 payload。

## 组件用法

下面展示组件接口，依赖应按项目使用的 Calcit 版本选择已发布 tag。文档片段只做静态检查，不在 native runner 执行浏览器 CSS 宿主。

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

## 开发与验证

需要 Node.js 24、Yarn 4.18.0、官方 Calcit 0.42.1 和 Caps 0.1.1：

```sh
caps --strict --ci
corepack yarn install --immutable
caps verify --toolchain
corepack yarn dev
```

`yarn watch` 可在另一终端持续编译；`yarn build` / `yarn release` 只构建演示站，不发布模块。只维护 `calcit.cirru` / `deps.cirru`，`js-out/` 和 `dist/` 不入库。包龄使用已授权的一小时策略，无单包豁免。

CI 保留 canonical、全部定义、公开组件/schema、完整 strict、原事件边界测试和 README 静态检查，不放宽类型门禁或增加测试 runner。实际浏览器交互与原 Linux CI 的结果以 PR 描述为准。

## 前端部署

PR 只检查、构建并保存相对资源路径的 artifact，不上传 COS 或部署生产。main 的原流程仅上传 `dist/assets` 到 `https://cos-sh.tiye.me/Triadica/hud-nav/assets/`，使用 COS Action 1.2.0 内置公开 URL 校验，再按原路径同步页面；不额外复制校验脚本，不涉及后端。

需要原 `COS_BUCKET`、`COS_SECRET_ID`、`COS_SECRET_KEY` 和 `rsync_private_key`。生产上传与页面发布前分别核对 main HEAD，队列不取消执行中的生产任务；这些检查不承诺原子部署。Actions 按维护者授权使用精确正式 tag，接受 tag 可移动风险，原触发条件、权限和部署路径保持。

## License

MIT
