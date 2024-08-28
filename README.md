# RamDisk-SL-Runner
Staus: Working.

### DESCRIPTION:
- This is for automatically mounting a ramdisk before executing a specified program in the same folder, then unmounting the image after, to free up the memory. This is intended for a separate ~8192MB "Viewer" ramdrive, as apposed to the, "System" or "Cameras", one. This project was part of my useful ramdisk scripts, but I decided it was too specialized, so it got its own section.

### PREVIEW:
- `Ramdisk-SL-Runner.Bat` - Auto-mount/unmount ramdrive, run application (Genesis and Firestorm, Viewer), with compitence...
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
- Windows (possibly 7-11), with Scripting Host Enabled.
- RamDisk software - [Free Single-Drive Ramdisk App](https://github.com/LTRData/ImDisk) or [Paid Multi-Drive Ramdisk App)](https://www.softperfect.com/products/ramdisk/), script is configured for Paid version's commands, but can be adapted for the single one, if thats all you want to use a ramdisk for.

### INSTALL AND USE:
1. Put in same dir as target Viewer.
2. Ensure the ramdisk is created, and able to be mounted. I advise a `8192` ramdisk.
2. Edit appropriate lines near the top of the script...
```
set "viewer_exe_label=GenesisViewer.exe"
set "viewer_ramdisk_letter=U"
set "ramdisk_software_path=C:\System Files\RamDisk\ramdisk.exe"
```
3. Run script, fireworks begin, see `PREVIEW` section.
4. Ensure that when the viewer is running for the first time, you set the `cache` folder to the ramdrive letter, and I advise the combined cache set to a total of `~8000MB`, then exit the viewer.
5. the script will then prompt to relog, so do that, and the cache will be in the randisk. 

### NOTATION:
- A recent addition is to auto close/open the explorer window(s) open, this negates issues with failure to dismount, its better than forced dismount.
- If you want way more textures to fit in the ramdisk, ensure to enable texture compression, additionally loading/running will be even faster.
- The idea is you leave the batch in the background, so that it catches the exit, and acts appropriately.
- When you reset/more the cache, ensure to visit a populated location, to cache the majority of the assets, the slow loaders are the bodies typically.

## DISCLAIMER
This software is subject to the terms in License.Txt, covering usage, distribution, and modifications. For full details on your rights and obligations, refer to License.Txt.
