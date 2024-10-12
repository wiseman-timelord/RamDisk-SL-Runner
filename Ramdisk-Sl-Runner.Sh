#!/bin/bash

# =============================================
#               RamDisk-Sl-Runner
# =============================================

# Customize these variables
RAMDISK_DIR="/mnt/ramdisk_viewer"  # Unique mount point for RAM disk
KOKUA_PATH="./kokua"               # Path to Kokua executable, adjust if needed
RAMDISK_SIZE="8G"                  # Customize RAMDISK size (e.g., 512M, 1G)

# Function to unmount the RAM disk safely
function unmount_ramdisk {
    echo "Unmounting RAM Disk..."
    if mountpoint -q "$RAMDISK_DIR"; then
        sudo umount "$RAMDISK_DIR"
        if [ $? -eq 0 ]; then
            echo "..RAM Disk Unmounted."
        else
            echo "..Failed to Unmount RAM Disk!"
            exit 1
        fi
    else
        echo "..RAM Disk not mounted, skipping unmount."
    fi
}

# Trap to ensure RAM disk is unmounted if the script is interrupted
trap unmount_ramdisk EXIT

# Initialization
echo "Script Initialized."
sleep 2

# Mount RAM Disk
echo "Mounting RAM Disk..."
if ! mountpoint -q "$RAMDISK_DIR"; then
    sudo mkdir -p "$RAMDISK_DIR"
    sudo mount -t tmpfs -o size=$RAMDISK_SIZE tmpfs "$RAMDISK_DIR"
    if [ $? -eq 0 ]; then
        echo "..RAM Disk Mounted at $RAMDISK_DIR"
    else
        echo "..Failed to Mount RAM Disk!"
        exit 1
    fi
else
    echo "..RAM Disk is already mounted at $RAMDISK_DIR!"
fi

# Grace period
echo "Waiting 3 seconds..."
sleep 3
echo "..Grace Period Over."

# Launch Kokua Viewer loop
while true; do
    echo "Checking for Kokua executable..."
    if [ -x "$KOKUA_PATH" ]; then
        echo "..Executing Kokua Viewer..."
        "$KOKUA_PATH"
        KOKUA_EXIT_STATUS=$?
        echo "..Kokua Viewer Exited with status $KOKUA_EXIT_STATUS."
    else
        echo "..Kokua executable missing or not executable at $KOKUA_PATH!"
        sleep 3
        break
    fi

    # Check if Kokua exited cleanly
    if [ $KOKUA_EXIT_STATUS -ne 0 ]; then
        echo "Kokua encountered an issue (Exit status: $KOKUA_EXIT_STATUS)."
    fi

    # Prompt user to relog or exit
    read -p "..Are you relogging? (y/N): " relog
    if [[ "$relog" =~ ^[Yy]$ ]]; then
        echo "..Relogging Viewer..."
        continue
    else
        echo "..Not relogging."
        break
    fi
done

# Grace period before unmount
echo "Waiting 3 seconds..."
sleep 3
echo "..Grace Period Over."

# Unmount RAM Disk (triggered via trap or normal exit)
unmount_ramdisk

echo "Complete. Exiting..."
sleep 2
exit 0
