# PunchQuest-Turbo 中文文档

> Punch Quest (v1.2.5) 社区优化补丁 — 性能修复 + IAP 破解

**Punch Quest** 是一款由 Rocketcat Games 开发的经典像素风格横版格斗跑酷游戏，于 2012 年发布。最后一次更新停留在 **2014 年**（v1.2.5），距今已 12 年。

在新版 Android 手机上有几个严重问题：**卡顿**（不充电时帧率暴跌，充电时恢复正常）、**32 位兼容性**、**长屏黑边**和 IAP 流程失效。本项目通过直接修改 smali 字节码来解决这些问题，并提供两个版本——一个纯优化版，一个包含 IAP 破解版。

---

## 修改详情

所有修改文件在 `mods/` 目录中，原始对比在 `patches/` 目录中。

### 1. 帧率修复 — `Cocos2dxRenderer.smali`

**问题**：游戏使用 `Thread.sleep()` 来人工限制帧率到 60 FPS。在新 Android 上，`Thread.sleep()` 的精度极差——不充电时 CPU 降频，sleep 实际耗时远超预期，导致严重卡顿。充电时 CPU 不降频，sleep 更准时，所以"充电就不卡"。

**修复**：彻底移除 `onDrawFrame()` 中的 `Thread.sleep()` 节流逻辑。`GLSurfaceView` 在连续渲染模式下已经由 Choreographer 按 VSync 驱动（~60 FPS），根本不需要手动 sleep。

---

### 2. 32 位/64 位 + 长屏兼容 — `AndroidManifest.xml`

**问题**：游戏只包含 `armeabi-v7a`（32 位）的 .so 库。`targetSdkVersion` 设太高会导致 64 位手机优先寻找 `arm64-v8a` 目录（不存在）而崩溃。旧 target SDK 应用还会在现代长屏手机上被系统按默认约 1.86 宽高比加黑边，黑边区域不可触控。

**修复**：
- `targetSdkVersion`：19 → **22**（既不触发 64 位强制模式，又能获得新系统兼容性）
- 添加 `android:use32bitAbi="true"` 显式声明使用 32 位 ABI
- 添加 `android.max_aspect=2.4` 元数据，让 20:9/21:9 手机使用完整屏幕而不是系统默认黑边模式
- `configChanges` 增加 `layoutDirection|screenLayout` 防止配置变化导致崩溃

---

### 3. IAP 破解（仅 Unlocked 版本） — `PurchaseWrapperV3.smali` 等

> ⚠️ **仅 `PunchQuest-Unlocked.apk` 包含此改动**。Optimized 版本无任何 IAP 修改。

**问题**：`buyItem()` 调用 `IabHelper.launchPurchaseFlow()` 打开 Google Play 支付弹窗。2014 年的老游戏，支付接口经常挂起、超时或直接失败。

**修改**（涉及 3 个文件）：

| 文件 | 改动 |
|------|------|
| `PurchaseWrapperV3.smali` — `hasEverPurchased()` | 始终返回 `true` |
| `PurchaseWrapperV3.smali` — `hasPurchased(sku)` | 始终返回 `true` |
| `PurchaseWrapperV3.smali` — `buyItem(sku)` | **完全跳过 `launchPurchaseFlow()`**。直接调用 `savePurchaseFlag()` + `handleMessage(sku, SUCCESS)`，金币即时到账，无弹窗。 |
| `SkuSaveOnIabPurchaseFinishedListener.smali` | 备用：如果被触发，始终走 SUCCESS 路径 |
| `punchquest.smali` — `onCreate()` | 启动时写入 `noodle_has_purchased` SharedPreferences 标记 |

**效果**：点击商店里的"购买金币/翻倍器"按钮 → 金币立即到账，不弹支付框，不联网，不等。

---

## 两个版本对比

| APK | 包含 |
|-----|------|
| **`PunchQuest-Optimized.apk`** | 修改 1、2（性能 + 兼容性）— **无 IAP 改动** |
| **`PunchQuest-Unlocked.apk`** | 全部修改 — 性能 + 兼容性 + IAP 破解 |

两个 APK 均已完成 zipalign、debug 签名、v1/v2/v3 校验。

---

## 自行构建

```bash
# 环境：Java 8+, apktool, uber-apk-signer

# 1. 下载原始 APK
#    来源：APKPure, APKCombo 等
#    包名：com.noodlecake.punchquest, versionCode=18

# 2. 反编译
apktool d punchquest.apk -o decoded

# 3. 应用补丁
#    将 mods/* 文件复制到 decoded/ 对应路径

# 4. 重新打包
apktool b decoded -o punchquest-mod.apk

# 5. 签名
java -jar uber-apk-signer.jar -a punchquest-mod.apk
```

---

## 免责声明

- 本项目仅供**学习与研究**使用。
- Punch Quest 的所有权利归 **Rocketcat Games / Noodlecake Studios** 所有。
- 本仓库**不分发完整游戏**，仅包含修改补丁。
- 如果你喜欢这款游戏，请支持正版开发者。
- Unlocked 版本绕过了 IAP 验证，使用破解软件可能违反当地法律及 Google Play 服务条款。

---

## 致谢

- **Punch Quest** — Rocketcat Games & Madgarden
- Android 移植 — **Noodlecake Studios**
- 社区补丁 — [@Reznovs](https://github.com/Reznovs)
