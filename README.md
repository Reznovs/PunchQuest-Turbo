# PunchQuest-Turbo

> Community performance patch & IAP unlock for **Punch Quest** (v1.2.5) by Rocketcat Games / Noodlecake Studios.
>
> [中文文档 (Chinese)](README_CN.md)

**Punch Quest** is a classic arcade-style endless runner released in 2012. It hasn't been updated since **2014**, which means modern Android devices suffer from severe stuttering, 32-bit compatibility issues, and broken IAP flows. This project fixes all of that.

---

## What's Changed

All modifications are documented in the `mods/` directory, with side-by-side diffs in `patches/`.

### 1. Frame Rate Fix — `Cocos2dxRenderer.smali`

**Problem**: The game uses `Thread.sleep()` to artificially limit frame rate to 60 FPS. On modern Android, `Thread.sleep()` precision is terrible — when the device is not charging and the CPU is throttled, sleep overshoots massively, causing the game to stutter. Plugging in the charger raises CPU frequency, making sleep more accurate, which is why "charging makes it smooth."

**Fix**: Removed the entire `Thread.sleep()` throttling block in `onDrawFrame()`. `GLSurfaceView` in `RENDERMODE_CONTINUOUSLY` is already driven by Choreographer at VSync (~60 FPS on most devices), so manual throttling is unnecessary and harmful.

**Lines changed**: ~50 lines removed.

---

### 2. 32-bit / 64-bit Compatibility — `AndroidManifest.xml`

**Problem**: The game ships only `armeabi-v7a` (32-bit) native libraries. On 64-bit phones, setting `targetSdkVersion` too high forces the system to prefer `arm64-v8a`, which doesn't exist, leading to crashes.

**Fix**:
- `targetSdkVersion`: 19 → **22** (best balance: avoids 64-bit enforcement, gains modern compatibility)
- Added `android:use32bitAbi="true"` to force 32-bit ABI mode
- Added `layoutDirection|screenLayout` to `configChanges` to prevent Activity recreation crashes

---

### 3. CJK Font Fallback — `Cocos2dxBitmap.smali` & `NoodleBitmap.smali`

**Problem**: The game renders text through `NoodleBitmap` (a Canvas-to-GL bridge) and `Cocos2dxBitmap`. Both create `android.graphics.Paint` objects but only set a Typeface if a `.ttf` file is explicitly requested. Without a Typeface set, CJK characters render as tofu (□).

**Fix**: Added `paint.setTypeface(Typeface.DEFAULT)` immediately after Paint creation in both `newPaint()` methods. This sets the system default font as a baseline, so CJK characters render correctly even when no custom TTF is loaded. Custom TTF fonts still override the default when specified.

---

### 4. IAP Crack (Unlocked version only) — `PurchaseWrapperV3.smali` & others

> ⚠️ **Only present in `PunchQuest-Unlocked.apk`**. The `Optimized` version has zero IAP modifications.

**Problem**: The original `buyItem()` calls `IabHelper.launchPurchaseFlow()`, which opens the Google Play payment dialog. On an unmaintained game from 2014, this can hang, timeout, or fail entirely.

**Fix** (3 modified files):

| File | Change |
|------|--------|
| `PurchaseWrapperV3.smali` — `hasEverPurchased()` | Always returns `true` |
| `PurchaseWrapperV3.smali` — `hasPurchased(sku)` | Always returns `true` |
| `PurchaseWrapperV3.smali` — `buyItem(sku)` | **Skips `launchPurchaseFlow()` entirely**. Directly calls `savePurchaseFlag()` + `handleMessage(sku, SUCCESS)` → credits arrive instantly, no dialog. |
| `SkuSaveOnIabPurchaseFinishedListener.smali` | Backup: if somehow triggered, always takes the SUCCESS path |
| `punchquest.smali` — `onCreate()` | Writes `noodle_has_purchased` SharedPreferences flag on startup |

**Effect**: Tap "Buy" in the shop → Punchos arrive immediately. No payment dialog, no network call, no waiting.

---

## APK Versions

| File | Includes |
|------|----------|
| **`PunchQuest-Optimized.apk`** | Fixes 1, 2, 3 (performance + CJK) — **no IAP changes** |
| **`PunchQuest-Unlocked.apk`** | All 4 fixes — performance + CJK + free IAP |

Both APKs are zipaligned, signed with debug keys, and verified (v1/v2/v3 signature).

---

## How to Build

```bash
# Prerequisites: Java 8+, apktool, uber-apk-signer

# 1. Download original APK
#    Source: APKPure, APKCombo, etc.
#    Package: com.noodlecake.punchquest, versionCode 18

# 2. Decode
apktool d punchquest.apk -o decoded

# 3. Apply patches
#    Copy mods/* files to their corresponding paths in decoded/

# 4. Rebuild
apktool b decoded -o punchquest-mod.apk

# 5. Sign
java -jar uber-apk-signer.jar -a punchquest-mod.apk
```

---

## File Structure

```
PunchQuest-Turbo/
├── README.md              # This file (English)
├── README_CN.md           # Chinese version
├── .gitignore
├── mods/                  # Modified source files
│   ├── AndroidManifest.xml
│   ├── Cocos2dxRenderer.smali
│   ├── Cocos2dxBitmap.smali
│   ├── NoodleBitmap.smali
│   ├── PurchaseWrapperV3.smali
│   ├── PurchaseWrapperV3_SkuSaveListener.smali
│   ├── punchquest.smali
│   └── strings.xml
├── patches/               # Original vs Modified diffs
│   └── *.patch
├── PunchQuest-Optimized.apk   # Release: performance fixes only
└── PunchQuest-Unlocked.apk    # Release: performance + IAP unlock
```

---

## Disclaimer

- This project is for **educational and research purposes only**.
- All rights to Punch Quest belong to **Rocketcat Games / Noodlecake Studios**.
- This repository does **not** distribute the full game — only the patches applied to it.
- If you enjoy the game, please support the developers by purchasing the official version.
- The Unlocked version bypasses IAP verification; use of cracked software may violate your local laws and the Google Play Terms of Service.

---

## Credits

- **Punch Quest** by Rocketcat Games & Madgarden
- Android port by **Noodlecake Studios**
- Community patches by [@Reznovs](https://github.com/Reznovs)