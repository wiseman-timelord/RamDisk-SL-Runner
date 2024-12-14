# RamDisk-SL-Runner
Staus: Working.

### DESCRIPTION:
- This is for automatically mounting a ramdisk before executing a Second Life Viewer of choice, that are located in the same directory as the batch, after exiting the viewer, then the user will be in a loop, to, relog or go through processes of unmounting. This enables efficient management of memory. It is recommended, that the user utilizes a ~8192MB "Viewer" specific ramdrive. Its now for windows and linux, and the batch/bash is created to be adaptable for other programs, where there are "Globals" of sorts, clearly marked near the top. 

### PREVIEW:
- The Video Demonstration on YouTube...
<br>[![Ramdisk-SL-Runner on YouTube](./media/wisetime_youtube.jpg)](https://www.youtube.com/watch?v=KZQ6rnFZA6Y)
- Windows version...
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
- Linux version...
```
Script Initialized.
Cache directory ensured at ./ramdisk_cache
Mounting RAM Disk...
..RAM Disk Mounted at /mnt/ramdisk_viewer
Clearing RAM Disk...
..RAM Disk is already empty.
Copying cached contents to RAM disk...
Starting copy from './ramdisk_cache' to '/mnt/ramdisk_viewer', please wait...
Copy from './ramdisk_cache' to '/mnt/ramdisk_viewer' completed.
..Cached contents copied to RAM disk.
Waiting 3 seconds...
..Grace Period Over.
Checking for Kokua executable...
..Executing Kokua Viewer...
..Kokua Viewer Exited with status 0.
..Are you relogging? (y/N): n
..Not relogging.
Clearing cache directory...
Starting to clear directory './ramdisk_cache'...
Clearing of directory './ramdisk_cache' completed.
..Cache directory cleared.
Copying RAM disk contents to cache...
Starting copy from '/mnt/ramdisk_viewer' to './ramdisk_cache', please wait...
Copy from '/mnt/ramdisk_viewer' to './ramdisk_cache' completed.
..RAM disk contents copied to cache.
Waiting 3 seconds...
..Grace Period Over.
Unmounting RAM Disk...
..RAM Disk Unmounted.
Complete. Exiting...
Unmounting RAM Disk...
..RAM Disk not mounted, skipping unmount.

```


# REQUIREMENTS:
- Windows (possibly 7-11) or Ubuntu (TBA, def Ubuntu 16-24), with Scripting Enabled.
- RamDisk software (Windows) - [Free Single-Drive Ramdisk App](https://github.com/LTRData/ImDisk) or [Paid Multi-Drive Ramdisk App](https://www.softperfect.com/products/ramdisk/), script is configured for Paid version's commands, but can be adapted for the single one, if thats all you want to use a ramdisk for. Its built-in for Ubuntu 24.
- Second Life Viewer - I recommend, `Kokua` for Linux and `Firestorm/Genesis` for Windows.

### INSTRUCTIONS (Windows):
1. Put in same dir as target Viewer.
2. Ensure the ramdisk is created, and able to be mounted, in your RamDisk Software of choice. I advise a `8192` ramdisk.
3. Edit appropriate lines near the top of the script...
```
set "viewer_exe_label=GenesisViewer.exe"
set "viewer_ramdisk_letter=U"
set "ramdisk_software_path=C:\System Files\RamDisk\ramdisk.exe"
set "ramdisk_arguement_mount=/mount:"
set "ramdisk_arguement_unmount=/unmount:"
```
4. Run script, fireworks begin, see `PREVIEW` section.
5. Ensure that when the viewer is running for the first time, you set, the Cache size the same as in the global (`8000` is safe default) and the `cache` folder to the ramdrive letter, then exit the viewer.
6. the script will then prompt to relog, so do that, and the new configuration is active, but it will first need download assets again. 

### INSTRUCTIONS (Linux):
- Basics (Install/Setup)...
1. Put in same dir as target Viewer.
2. Edit appropriate lines near the top of the script...
```
RAMDISK_DIR="/mnt/ramdisk_viewer"  # Unique mount point for RAM disk
VIEWER_PATH="./singularity"               # Path to Viewer executable, adjust if needed
RAMDISK_SIZE="8192M"               # RAM disk size (8 GiB = 8192 MiB)
CACHE_DIR="./ramdisk_cache"        # Directory to store cache files
DEBUG_MODE=false                   # Default: Disable debug output
```
3. Run script, fireworks begin, see `PREVIEW` section.
4. Ensure that when the viewer is running for the first time, you set, the Cache size the same as in the global (`8000` is safe default) and the `cache` folder to `/mnt/ramdisk_viewer`, then exit the viewer.
5. the script will then prompt to relog viewer, so do that, and the new configuration is active, but it will first need download assets again.

### NOTATION:
- The windows version auto close/open the explorer window(s), this negates issues with failure to dismount, its better than a forced dismount.
- The Linux version is best as it uses a built-in ramdisk, so we can have things like progress bar for copying from/to persistent storage.
- If you want way more textures to fit in the ramdisk, ensure to enable texture compression, additionally loading/running will be even faster.
- The idea is you leave the script running in the background, so that it catches the exit, and acts appropriately to shutdown.
- When you reset/more the cache, ensure to visit a populated location, to cache the majority of the assets, then relog, solves most cache issues.
- This project is personal for Wiseman-Timelord, as when prims were fashionable, it was the first script produced by himself.

## DEVELOPMENT
- Likely further development will be restricted to the linux version, for now, and it will not happen until, Claude_Sonnet or GPT, premium account.
- The next phase would be multi-threaded file copying, however, the free versions of, claude_sonnet and gpt, as well as, deepseek2.5, were unable to correctly produce the multi-threaded version of the script in bash, despite my prompting being A1 with regrds to too many, cups of coffe and cigarettes, to be healthy.

## DISCLAIMER
This software is subject to the terms in License.Txt, covering usage, distribution, and modifications. For full details on your rights and obligations, refer to License.Txt.
