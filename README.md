# HUD Nav

Respo 的标签导航组件，演示站：http://repo.tiye.me/Triadica/hud-nav/ 。

## 使用者需要注意

本分支准备 `0.0.10`，配对正式 Calcit / JavaScript runtime **0.32.1**、Respo **0.17.1**、UI **0.9.0** 与 JS FFI **0.2.9**；候选尚未发布，现有正式 tag 是 `0.0.9`（Calcit 0.31.0）。不要混用工具链或将候选版本当成已发布依赖。UI 自身固定的 Router 预发布传递依赖保留，不使用 main/hash。

`comp-hud-nav` 仍接收当前 Tag 和 `List<TabItem>`，点击派发具名 `Op :tab next`；`TabItem`、`Op`、`Store` 的布局和 hydration wire 格式不变。消费者继续把 entry 的 `dispatch-op` 槽绑定到 `hud-nav.schema/Op`，在 updater 匹配 `(:tab next)`。

Respo 0.17.1 的 renderer 回调已使用这个类型槽，Demo 因而直接传入 `dispatch!`，删除每次点击时多余的 Cirru EDN 格式化/解析。这里传递的是具名、已检查的内存事件，不把外部 Map、未知值或同名外部类型当成合法 Op。需要兼容旧 renderer 的消费者不要单独照搬这个简化。

`Op :hydrate-storage` 仍要求 `Store`。外部数据必须先完成受检解码，再构造事件；原附带测试继续验证正常 tab、带 Store 的 hydrate 和非法 payload 拒绝，不撤销外部数据边界。此变化不是对上游 [#2154](https://github.com/calcit-lang/calcit/issues/2154) 解码能力的通用修复。

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

需要 Node.js 24、Yarn 4.18.0、官方 Calcit 0.32.1 和 Caps 0.1.1：

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
