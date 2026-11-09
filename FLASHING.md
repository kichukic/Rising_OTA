# Flashing Instructions for RisingOS 9 (Android 17)

**Device:** Xiaomi Mi 11X Pro / Redmi K40 Pro / Mi 11i (`haydn` / `haydnin`)  
**Maintainer:** Kishor TH ([@HI_JACK_U](https://t.me/HI_JACK_U))  
**Android Version:** 17 (SDK 37 / *elefthería*)  
**Signing Key:** Official LineageOS Private `releasekey`  

---

## Important Prerequisites & Requirements

1. **Unlocked Bootloader:** Ensure your device's bootloader is already unlocked.
2. **Backup:** Backup all important personal data before proceeding with a Clean Flash. Formatting data will erase everything on the device.
3. **Recommended Recovery:** 
   - TWRP for Android 14/15/17 (e.g. `twrp-v3.7.1_12_A17-by-Lucifer`) or OrangeFox.
4. **Firmware:**
   - Latest HyperOS or MIUI 14 Global/India/EEA firmware for `haydn` is recommended prior to installation.
5. **Computer Tools:**
   - Latest Android Platform Tools (`adb` and `fastboot`) installed on your PC.

---

## Clean Flash (Recommended for First-Time Install)

Follow these steps if you are coming from stock HyperOS/MIUI or any other custom ROM:

### Step 1: Boot to Fastboot Mode
1. Power off your phone completely.
2. Press and hold **Volume Down + Power** simultaneously until the Fastboot logo appears.
3. Connect your phone to your PC via USB.

### Step 2: Flash Recovery / Boot Image
Verify device connection:
```bash
fastboot devices
```
Flash the recovery or boot image:
```bash
fastboot flash boot boot.img
```
*(If using a dedicated recovery partition or booting recovery directly)*:
```bash
fastboot boot twrp.img
```

### Step 3: Format Data in Recovery
1. Once booted into Recovery, navigate to **Wipe** > **Format Data**.
2. Type `yes` and confirm.
3. Go to **Reboot** > **Recovery** to reboot recovery and ensure dynamic partitions remount cleanly.

### Step 4: Flash RisingOS ROM Package
#### Method A: ADB Sideload (Recommended)
1. In Recovery, go to **Advanced** > **ADB Sideload** and swipe to start sideload mode.
2. On your PC terminal, run:
```bash
adb sideload RisingOS-9-XXXXXXXX-XXXX-GAPPS-COMMUNITY-haydn-ota.zip
```
3. Wait for sideloading to complete (47% is normal in AOSP recovery when finishing).

#### Method B: USB-OTG or Internal Storage
1. Transfer the ROM `.zip` to USB-OTG or phone storage.
2. Go to **Install**, select the ROM zip, and swipe to flash.

### Step 5: (Optional) Root / SuperUser
- **Note:** The kernel already comes with **BakaSU 1.5.5 + SUSFS v2.0** built-in!
- The preinstalled root manager will automatically be granted root on first boot.
- You do **not** need to flash extra root zip files (Magisk or KSU).

### Step 6: Reboot to System
1. Go to **Reboot** > **System**.
2. Enjoy RisingOS 9 on your Xiaomi Mi 11X Pro / Redmi K40 Pro!

---

## Dirty Flash (Updating between RisingOS 9 Builds)

Follow these steps if you are updating from an earlier build of RisingOS 9:

### Method A: Built-in System OTA Updater
1. Go to **Settings** > **System** > **System Updates**.
2. Check for updates and download the latest build.
3. Tap **Install** and reboot when prompted.

### Method B: Manual Recovery Dirty Flash
1. Boot into Recovery (**Volume Up + Power**).
2. Go to **Wipe** > **Advanced Wipe** > Select **Dalvik / ART Cache** and **Cache** (DO NOT wipe Data/Internal Storage).
3. Swipe to wipe.
4. Flash the new update zip via **ADB Sideload** or **Install**.
5. Reboot to **System**.

---

## Play Integrity & Banking Apps Setup

RisingOS 9 includes native hardware TEE spoofing and cloaking:
- **Default Strong Keybox:** `Yurikey67` is integrated into `/product/etc/security/keybox.xml` and auto-seeded into TrickyStore.
- **Custom Keybox:** If you wish to use your own custom keybox XML, you can set or change it anytime in:
  - **Settings** > **System** > **AxSpoof / Spoofing** > **TrickyStore Keybox**.
- All banking apps (GPay, PhonePe, Paytm, HDFC, SBI) and Play Integrity work out of the box without needing extra modules.

---

## Support & Links

- **Telegram Support:** [@HI_JACK_U](https://t.me/HI_JACK_U)
- **OTA Updates Repository:** [kichukic/Rising_OTA](https://github.com/kichukic/Rising_OTA)
- **Downloads on SourceForge:** [rising-unofficial](https://downloads.sourceforge.net/project/rising-unofficial/)
