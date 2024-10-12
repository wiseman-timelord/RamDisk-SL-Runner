# RamDisk-SL-Runner
Staus: Working.

### DESCRIPTION:
- This is for automatically mounting a ramdisk before executing a Second Life Viewer of choice, that are located in the same directory as the batch, after exiting the viewer, then the user will be in a loop, to, relog or go through processes of unmounting. This enables efficient management of memory. It is recommended, that the user utilizes a ~8192MB "Viewer" specific ramdrive. Its now for windows and linux, and the batch/bash is created to be adaptable for other programs, where there are "Globals" of sorts, clearly marked near the top.

### PREVIEW:
- The Video Demonstration on YouTube...
<br>[![Ramdisk-SL-Runner on YouTube](./media/wisetime_youtube.jpg)](https://www.youtube.com/watch?v=KZQ6rnFZA6Y)
- Heres what it does basically...
```
=============================================
              RamDisk-SL-Runner
=============================================

Script Initialized.

Mounting RAM Drive..
..RAM Drive Mounted.
Waiting 3 seconds..
..Grace Period Over.
Checking Viewer..
..Executing Viewer..
..Viewer Exited..
..Are You Relogging YN? n
Waiting 3 seconds..
..Grace Period Over.
Checking Explorer..
..Explorer Closed.
Unmounting RamDrive..
..RamDrive Unmounted..
Re-Opening Explorer..
..Explorer Opened.

Complete, Exiting...
```

# REQUIREMENTS:
- Windows (possibly 7-11) or Ubuntu (TBA, def Ubuntu 16-24), with Scripting Enabled.
- RamDisk software (Windows) - [Free Single-Drive Ramdisk App](https://github.com/LTRData/ImDisk) or [Paid Multi-Drive Ramdisk App](https://www.softperfect.com/products/ramdisk/), script is configured for Paid version's commands, but can be adapted for the single one, if thats all you want to use a ramdisk for. Its built-in for Ubuntu 24.
- Second Life Viewer - I recommend, `Kokua` for Linux and `Firestorm/Genesis` for Windows.

### INSTRUCTIONS (Windows):
1. Put in same dir as target Viewer.
2. Ensure the ramdisk is created, and able to be mounted, in your RamDisk Software of choice. I advise a `8192` ramdisk.
2. Edit appropriate lines near the top of the script...
```
set "viewer_exe_label=GenesisViewer.exe"
set "viewer_ramdisk_letter=U"
set "ramdisk_software_path=C:\System Files\RamDisk\ramdisk.exe"
set "ramdisk_arguement_mount=/mount:"
set "ramdisk_arguement_unmount=/unmount:"
```
3. Run script, fireworks begin, see `PREVIEW` section.
4. Ensure that when the viewer is running for the first time, you set, the Cache size the same as in the global (`8000` is safe default) and the `cache` folder to the ramdrive letter, then exit the viewer.
5. the script will then prompt to relog, so do that, and the new configuration is active, but it will first need download assets again. 

### INSTRUCTIONS (Linux):
- Basics (Install/Setup)...
1. Put in same dir as target Viewer.
2. Edit appropriate lines near the top of the script...
```
RAMDISK_DIR="/mnt/ramdisk_viewer"  # Unique mount point for RAM disk
KOKUA_PATH="./kokua"               # Path to Kokua executable, adjust if needed
RAMDISK_SIZE="8G"                  # Customize RAMDISK size (e.g., 512M, 1G)
```
3. Run script, fireworks begin, see `PREVIEW` section.
4. Ensure that when the viewer is running for the first time, you set, the Cache size the same as in the global (`8000` is safe default) and the `cache` folder to `/mnt/ramdisk_viewer`, then exit the viewer.
5. the script will then prompt to relog viewer, so do that, and the new configuration is active, but it will first need download assets again.

### NOTATION:
- A recent addition is to auto close/open the explorer window(s) open, this negates issues with failure to dismount, its better than forced dismount.
- If you want way more textures to fit in the ramdisk, ensure to enable texture compression, additionally loading/running will be even faster.
- The idea is you leave the batch in the background, so that it catches the exit, and acts appropriately.
- When you reset/more the cache, ensure to visit a populated location, to cache the majority of the assets, the slow loaders are the bodies typically.
- This project is personal for Wiseman-Timelord, as, when prims were fashionable and in a much simpler version, it was the first script produced by himself.

## DISCLAIMER
This software is subject to the terms in License.Txt, covering usage, distribution, and modifications. For full details on your rights and obligations, refer to License.Txt.
