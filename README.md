# RamDisk-SL-Runner
Staus: Working. Recently overhauled, much simpler now for customization of what is now 3 lines near top.

### DESCRIPTION:
- This is for automatically mounting a ramdisk before executing a specified program in the same folder, then unmounting the image after, to free up the memory. The script has been updated, you need to edit the 3 lines in the `:: Customize for your own preference`. This is intended for a separate ~8192MB `Viewer` ramdrive, as apposed to the, "System" or "Cameras`, one. 

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

### NOTATION:
- A recent addition is to auto close/open the explorer window(s) open, this negates issues with failure to dismount, its better than forced dismount; but I advise a `8192` ramdisk with the combined cache set to a total of `~8000MB`.

## REQUIREMENTS:
- Windows (possibly 7-11), with Scripting Host Enabled.
- RamDisk software - [Free (omni-drive)](https://github.com/LTRData/ImDisk) or [Paid (multi-drive)](https://www.softperfect.com/products/ramdisk/)

### INSTALL AND USE:
1. Put in same dir as target Viewer.
2. Edit appropriate lines in script...
```
set "viewer_exe_label=GenesisViewer.exe"
set "viewer_ramdisk_letter=U"
set "ramdisk_software_path=C:\System Files\RamDisk\ramdisk.exe"
```
3. Run script, fireworks begin, see `PREVIEW` section.

## DISCLAIMER
This software is subject to the terms in License.Txt, covering usage, distribution, and modifications. For full details on your rights and obligations, refer to License.Txt.
