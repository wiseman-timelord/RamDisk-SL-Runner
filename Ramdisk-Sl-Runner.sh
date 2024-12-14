#!/bin/bash

# Customize these variables
RAMDISK_DIR="/mnt/ramdisk_viewer"  # Unique mount point for RAM disk
KOKUA_PATH="./kokua"               # Path to Kokua executable, adjust if needed
RAMDISK_SIZE="8192M"               # RAM disk size (8 GiB = 8192 MiB)
CACHE_DIR="./ramdisk_cache"        # Directory to store cache files
DEBUG_MODE=false                   # Default: Disable debug output
THREADS=4                          # Number of parallel threads for copying

# banner
echo "============================================="
echo "              RamDisk-SL-Runner"
echo "============================================="
echo ""

# Function to check if running as root
check_sudo() {
    if [[ $EUID -ne 0 ]]; then
        echo "Error: Sudo Authorization Required!"
        sleep 3
        exit 1
    else
        echo "Sudo authorization confirmed."
        sleep 1
    fi
}

# Multi-threaded copy function without progress indicators
copy_files_parallel() {
    local source="$1"
    local dest="$2"

    echo "Starting copy from '$source' to '$dest', please wait..."
    sleep 1

    find "$source" -type f -print0 | \
    xargs -0 -I{} -P "$THREADS" bash -c '
        file="$1"
        source_dir="$2"
        dest_dir="$3"
        rel_path="${file#$source_dir/}"
        dest_file="$dest_dir/$rel_path"

        mkdir -p "$(dirname "$dest_file")"
        if ! cp -f "$file" "$dest_file"; then
            echo "Error copying file: $file" >&2
        fi
    ' _ {} "$source" "$dest"

    echo "Copy from '$source' to '$dest' completed."
    sleep 1
}

# Clear directory (no progress)
clear_directory() {
    local dir="$1"
    echo "Starting to clear directory '$dir'..."
    sleep 1

    find "$dir" -type f -print0 | xargs -0 -P "$THREADS" rm -f

    echo "Clearing of directory '$dir' completed."
}

# Function to unmount the RAM disk safely
unmount_ramdisk() {
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

# Check for sudo privileges
check_sudo

# Parse command line arguments
for arg in "$@"; do
    case $arg in
        --debug)
            DEBUG_MODE=true
            shift
            ;;
    esac
done

echo "Script Initialized."
sleep 2

# Get the directory of the script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$SCRIPT_DIR" || exit 1

mkdir -p "$CACHE_DIR"
echo "Cache directory ensured at $CACHE_DIR"

echo "Mounting RAM Disk..."
if ! mountpoint -q "$RAMDISK_DIR"; then
    sudo mkdir -p "$RAMDISK_DIR"
    sudo mount -t tmpfs -o size="$RAMDISK_SIZE" tmpfs "$RAMDISK_DIR"
    if [ $? -eq 0 ]; then
        echo "..RAM Disk Mounted at $RAMDISK_DIR"
    else
        echo "..Failed to Mount RAM Disk!"
        exit 1
    fi
else
    echo "..RAM Disk is already mounted at $RAMDISK_DIR!"
fi

echo "Clearing RAM Disk..."
if [ "$(ls -A "$RAMDISK_DIR")" ]; then
    clear_directory "$RAMDISK_DIR"
    echo "..RAM Disk cleared."
else
    echo "..RAM Disk is already empty."
fi

echo "Copying cached contents to RAM disk..."
if [ "$(ls -A "$CACHE_DIR")" ]; then
    copy_files_parallel "$CACHE_DIR" "$RAMDISK_DIR"
    echo "..Cached contents copied to RAM disk."
else
    echo "..Cache directory is empty. Skipping copy."
fi

echo "Waiting 3 seconds..."
sleep 3
echo "..Grace Period Over."

while true; do
    echo "Checking for Kokua executable..."
    if [ -x "$KOKUA_PATH" ]; then
        echo "..Executing Kokua Viewer..."
        
        if [ "$DEBUG_MODE" = true ]; then
            "$KOKUA_PATH"
        else
            "$KOKUA_PATH" >/dev/null 2>&1
        fi

        KOKUA_EXIT_STATUS=$?
        echo "..Kokua Viewer Exited with status $KOKUA_EXIT_STATUS."
    else
        echo "..Kokua executable missing or not executable at $KOKUA_PATH!"
        sleep 3
        break
    fi

    if [ "$KOKUA_EXIT_STATUS" -ne 0 ]; then
        echo "Kokua encountered an issue (Exit status: $KOKUA_EXIT_STATUS)."
    fi

    read -p "..Are you relogging? (y/N): " relog
    if [[ "$relog" =~ ^[Yy]$ ]]; then
        echo "..Relogging Viewer..."
        continue
    else
        echo "..Not relogging."

        echo "Clearing cache directory..."
        if [ "$(ls -A "$CACHE_DIR")" ]; then
            clear_directory "$CACHE_DIR"
            echo "..Cache directory cleared."
        else
            echo "..Cache directory is already empty."
        fi

        echo "Copying RAM disk contents to cache..."
        if [ "$(ls -A "$RAMDISK_DIR")" ]; then
            copy_files_parallel "$RAMDISK_DIR" "$CACHE_DIR"
            echo "..RAM disk contents copied to cache."
        else
            echo "..RAM disk is empty. Skipping copy."
        fi

        break
    fi
done

echo "Waiting 3 seconds..."
sleep 3
echo "..Grace Period Over."

unmount_ramdisk

echo "Complete. Exiting..."
sleep 2
exit 0

