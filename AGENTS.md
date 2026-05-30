# Repository Instructions

## Scope
- This repo stores smali/XML patch sources for Punch Quest v1.2.5 (`com.noodlecake.punchquest`, versionCode 18), not a normal Android Studio/Gradle project.
- There is no package manager, Gradle wrapper, CI workflow, lint, or automated test suite in the repo.

## Source Layout
- `mods/` contains the modified files to copy into an `apktool d` decoded APK tree.
- `patches/` contains original-vs-modified reference diffs; keep these in sync when changing `mods/`.
- The tracked APK outputs are intentionally absent from git because `.gitignore` ignores `*.apk`.

## Decoded APK Paths
- `mods/AndroidManifest.xml` maps to `AndroidManifest.xml`.
- `mods/strings.xml` maps to `res/values/strings.xml`.
- `mods/Cocos2dxRenderer.smali` maps to `smali/org/cocos2dx/lib/Cocos2dxRenderer.smali`.
- `mods/Cocos2dxBitmap.smali` maps to `smali/org/cocos2dx/lib/Cocos2dxBitmap.smali`.
- `mods/NoodleBitmap.smali` maps to `smali/com/noodlecake/lib/font/NoodleBitmap.smali`.
- `mods/PurchaseWrapperV3.smali` maps to `smali/com/noodlecake/iapv3/PurchaseWrapperV3.smali`.
- `mods/PurchaseWrapperV3_SkuSaveListener.smali` maps to `smali/com/noodlecake/iapv3/PurchaseWrapperV3$SkuSaveOnIabPurchaseFinishedListener.smali`.
- `mods/punchquest.smali` maps to `smali/com/noodlecake/punchquest/punchquest.smali`.

## Build / Verification
- Prereqs documented by the repo: Java 8+, `apktool`, and `uber-apk-signer`.
- Manual rebuild flow from README:
  `apktool d punchquest.apk -o decoded`
  copy the relevant `mods/*` files into the decoded paths above
  `apktool b decoded -o punchquest-mod.apk`
  `java -jar uber-apk-signer.jar -a punchquest-mod.apk`
- If verifying an APK artifact, check that it is zipaligned/signed and supports v1/v2/v3 signatures as README claims for the release APKs.
- For focused review without rebuilding, compare each changed `mods/*` file against its paired `patches/*.patch` and confirm smali register/local counts still match edited instructions.

## Patch Intent
- Optimized build should include performance and compatibility fixes only; do not include IAP unlock behavior there.
- Unlocked build includes the IAP modifications in addition to performance and compatibility fixes.
- `Cocos2dxRenderer.smali` removes the `Thread.sleep()` frame limiter from `onDrawFrame()`; do not reintroduce manual sleep throttling.
- `AndroidManifest.xml` intentionally uses `targetSdkVersion="22"`, `android:use32bitAbi="true"`, and `android.max_aspect=2.4` for 32-bit native libraries and modern tall-screen devices.
- IAP unlock behavior depends on `PurchaseWrapperV3.smali`, `PurchaseWrapperV3_SkuSaveListener.smali`, and `punchquest.smali`; preserve the `noodle_has_purchased` SharedPreferences flag behavior when touching these files.

## Editing Notes
- Smali comments in `mods/` are currently Chinese; keep nearby explanatory comments concise and consistent.
- Avoid adding generated decode/build directories or APK outputs to git unless explicitly requested.
