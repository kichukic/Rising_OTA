# RisingOS OTA Updates for Xiaomi Mi 11X Pro / Redmi K40 Pro / Mi 11i (haydn)

Official RisingOS 9 (Android 17 / SDK 37) OTA Update Repository.

- **Maintainer:** Kishor TH ([@HI_JACK_U](https://t.me/HI_JACK_U))
- **Device:** Xiaomi Mi 11X Pro / Redmi K40 Pro / Mi 11i (`haydn` / `haydnin`)
- **Platform:** Qualcomm Snapdragon 888 SM8350 (Lahaina)
- **Security/Keys:** Official Release-Keys Signed (`user` variant)

---

## 📦 Latest Release Information

| Item | Details |
| :--- | :--- |
| **Filename** | `RisingOS-9-261105-0908-GAPPS-COMMUNITY-haydn-ota.zip` |
| **Build Date** | 2026-11-05 |
| **Build Type** | Authentic `user` build (`ro.debuggable=0`, release-keys) |
| **Android Version** | 17 (SDK 37) / LineageOS 24.0 base |
| **Size** | 3.36 GB (3,612,691,311 bytes) |
| **MD5** | `0579d8b972215df33f5493d85df2b412` |
| **SHA256** | `51c1132d05fa1219fde43d9180c565011ab14ac92e367b5ca0b7693a7d2a9fcb` |
| **Download** | [SourceForge Release](https://downloads.sourceforge.net/project/rising-unofficial/RisingOS-9-261105-0908-GAPPS-COMMUNITY-haydn-ota.zip) |

---

## 📝 Changelog (2026-11-05)

- **Android 17 / SDK 37 (LineageOS 24.0 base)**
- **Production User Build:**
  - Switched from `userdebug` to authentic production `user` build variant
  - `ro.debuggable=0`, JDWP debugging interfaces removed
  - Maximum AOT/PGO runtime performance, reduced idle power consumption
  - Clean out-of-the-box passing for banking, financial, and enterprise apps
- **Google BBR TCP Congestion Control:**
  - Enabled `CONFIG_TCP_CONG_BBR=y` and set default TCP congestion algorithm to BBR
  - Runtime enforcement in `init.qcom.rc` and `system.prop` (`net.ipv4.tcp_congestion_control=bbr`)
  - Replaces legacy Cubic; dynamically tracks bottleneck bandwidth & RTT
  - Lower in-game ping & reduced bufferbloat, faster video streaming on fluctuating 5G/Wi-Fi
- **ZSTD ZRAM Compression Engine:**
  - Upgraded ZRAM compression backend to modern Zstandard (`zstd`) in post-boot scripts
  - Delivers ~3.2x compression ratio, effectively providing ~12GB+ of multitasking memory headroom
  - Zero CPU hashing overhead (ZRAM deduplication `use_dedup=0` preserved)
  - Upgraded Dalvik VM heap profile to 8GB/12GB (`384MB` growth limit)
- **Anti-Reboot Kernel Stability Hardening:**
  - Disabled kernel panic-on-oops (`CONFIG_PANIC_ON_OOPS=n`)
  - Disabled Qualcomm watchdog bite on panic (`CONFIG_QCOM_FORCE_WDOG_BITE_ON_PANIC=n`)
  - Disabled SSR notification timeout panic (`CONFIG_PANIC_ON_SSR_NOTIF_TIMEOUT=n`)
  - Set panic timeout to 0 (`CONFIG_PANIC_TIMEOUT=0`)
  - Enforced `panic_on_oops=0` and `panic=0` at early-boot in `init.qcom.rc`
  - Non-critical driver hiccups and subsystem timeouts recover silently without phone crashes or random reboots
- **Critical Stability Fix:**
  - Resolved SystemUI broadcast receiver accumulation leak in `SignalIconLoader`
  - Fixed crash and spontaneous reboot occurring on incoming notifications
- **Motorola Dolby Atmos (MotoDolbyDax3) Integration:**
  - Full working Master On/Off switch that cleanly toggles DSP audio effects
  - Quick Settings tile, Dynamic/Movie/Music/Voice presets, and 10-band equalizer
  - `DSPVolumeSynchronizer` included for volume sync
- **HyperOS Gallery & MediaEditor:**
  - Patched HyperOSEditor smali to completely bypass Xiaomi account login check
  - Photo adjustment tools, filters, and editor features work 100% offline without signing in
  - Fixed `ColorStateList` resource lookup crash on launch
  - Native 64-bit uncompressed JNI libraries & 4K page size alignment
- **Native Play Integrity & Strong Keybox Integration:**
  - Yurikey67 embedded as default system keybox in `/product/etc/security/keybox.xml`
  - `AxSpoofManager` auto-seeds default keybox into TrickyStore on initial setup
  - Full user override preserved: users can import any custom keybox in Settings anytime
  - Hardware TEE `bootHash` matched to `ro.boot.vbmeta.digest` and zero-key spoofed
  - Auto-spoofing enabled by default for all user-installed applications
  - ADB & Developer Options hidden (returns '0' to third-party detector apps)
  - Root and hooking manager packages (Magisk, KernelSU, LSPosed) hidden from package queries
- **Leica MIUI Camera 5.0** natively integrated with all photo/video modes
- **Integrated hijackCUT** 4K Video Editor
- **Kernel 5.4.302-qgki** with BakaSU 1.5.5 & SUSFS hooks (preinstalled manager hook 35257 enabled)
- **UFS 3.1 I/O Performance & Kyber Scheduler:**
  - Enabled `CONFIG_MQ_IOSCHED_KYBER=y` and `CONFIG_MQ_IOSCHED_DEADLINE=y` in kernel
  - Automated block device queue tuning for all UFS 3.1 LUNs (`/sys/block/sd*`)
  - Tuned read-ahead buffer to optimal 128KB for peak 4K random read throughput
  - Disabled storage write entropy contribution (`add_random=0`) to eliminate CPU spinlocks
  - Disabled redundant I/O statistics accounting (`iostats=0`) to reduce interrupt latency
  - Streamlined queue depth to 64 requests
- **ART Bytecode Compiler & 120Hz Smoothness:**
  - Profile-guided AOT compilation (`speed-profile`) enabled for app installation and background dexopt
  - Scaled parallel dex2oat compilation threads to 6 (and 8 for boot) across Kryo 680 cores
  - Fast boot after OTA updates (`pm.dexopt.boot-after-ota=verify`)
  - SurfaceFlinger frame pacing optimized for 120Hz refresh rate (`set_touch_timer_ms=200`, `latch_unsignaled=1`)
  - Increased Home Launcher RAM pinning to 25MB (`config_pinnerHomePinBytes=26214400`) to eliminate redraws
- **Hi-Fi Audio & 3-Level Haptics:**
  - Enabled 24-bit / 192kHz Hi-Fi audio output pipeline (`vendor.audio.feature.hifi_audio.enable=true`)
  - Doubled audio offload buffer size to 64KB (`vendor.audio.offload.buffer.size.kb=64`) to cut CPU wakeups in half
  - Enabled 3-level granular vibration intensity slider (Low, Medium, High) in Settings
- **Bluetooth Audio Bitrate & Codec Boost:**
  - Uncapped AAC Bluetooth streaming bitrate and enabled VBR frame control
  - Set default LDAC high-resolution streaming bitrate to 990 kbps (`persist.bluetooth.ldac.rate=990`)
  - Decoupled Bluetooth absolute volume (`persist.bluetooth.disableabsvol=true`) for independent headphone amplifier gain
  - Disabled Bluetooth snoop logging daemon to eliminate background CPU overhead
- **Hyper-Fluid UI Animation Physics:**
  - Defaulted window, transition, and animator scales to 0.8x spring physics for silky-smooth 120Hz gesture response
  - Calibrated framework activity and window animation timings for instant responsiveness
- **Official Release-Keys Signed Build**

---

## 📖 Documentation & Links
- **Flashing Guide:** [`FLASHING.md`](FLASHING.md)
- **Raw Changelog:** [`changelogs/haydn.txt`](changelogs/haydn.txt)
- **OTA Metadata:** [`haydn.json`](haydn.json)
- **Downloads:** [SourceForge Releases](https://sourceforge.net/project/rising-unofficial/)
- **Support Group:** [@HI_JACK_U](https://t.me/HI_JACK_U)

