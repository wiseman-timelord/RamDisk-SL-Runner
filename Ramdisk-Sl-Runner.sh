#!/bin/bash

# =============================================
#               RamDisk-Sl-Runner
# =============================================

# Customize these variables
RAMDISK_DIR="/mnt/ramdisk_viewer"  # Unique mount point for RAM disk
VIEWER_PATH="./singularity"               # Path to Viewer executable, adjust if needed
RAMDISK_SIZE="8192M"               # RAM disk size (8 GiB = 8192 MiB)
CACHE_DIR="./ramdisk_cache"        # Directory to store cache files
DEBUG_MODE=false                   # Default: Disable debug output

# Request sudo authorization upfront
sudo -v  # Prompt for sudo password once

# Function to display progress
show_progress() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local completed=$((width * current / total))
    printf "\r[%-${width}s] %d%%" "$(printf '#%.0s' $(seq 1 $completed))" "$percentage"
}

# Function to copy with progress
copy_with_progress() {
    local source=$1
    local dest=$2
    local total_size=$(du -sb "$source" | cut -f1)
    local copied_size=0

    # Find all files and copy them while showing progress
    find "$source" -type f -print0 | while IFS= read -r -d '' file; do
        local rel_path="${file#$source/}"
        local dest_file="$dest/$rel_path"
        
        mkdir -p "$(dirname "$dest_file")"  # Ensure destination directories are created
        
        # Attempt to copy the file and check for success
        if cp "$file" "$dest_file"; then
            # Update progress if copy succeeds
            copied_size=$((copied_size + $(stat -c %s "$file")))
            show_progress $copied_size $total_size
        else
            echo "Error copying file: $file" >&2  # Output error to stderr if copy fails
        fi
    done
    echo # New line after progress bar
}

# Function to clear directory with progress
clear_directory_with_progress() {
    local dir=$1
    local total_files=$(find "$dir" -type f | wc -l)
    local current_file=0

    find "$dir" -type f -print0 | while IFS= read -r -d '' file; do
        rm "$file"
        ((current_file++))
        show_progress $current_file $total_files
    done
    echo # New line after progress bar
}

# Function to unmount the RAM disk safely
function unmount_ramdisk {
    echo "Unmounting RAM Disk..."
    if mountpoint -q "$RAMDISK_DIR"; then
        sudo umount "$RAMDISK_DIR"  # Use sudo to unmount the RAM disk
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

# Parse command line arguments
for arg in "$@"; do
    case $arg in
        --debug)
        DEBUG_MODE=true
        shift
        ;;
    esac
done

# Initialization
echo "Script Initialized."
sleep 2

# Get the directory of the script (equivalent to %~dp0 in Windows batch scripts)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Change to the script directory
cd "$SCRIPT_DIR" || exit 1

# Create cache directory if it doesn't exist
mkdir -p "$CACHE_DIR"
echo "Cache directory ensured at $CACHE_DIR"

# Mount RAM Disk
echo "Mounting RAM Disk..."
if ! mountpoint -q "$RAMDISK_DIR"; then
    sudo mkdir -p "$RAMDISK_DIR"  # Ensure sudo is used for creating the directory
    sudo mount -t tmpfs -o size=$RAMDISK_SIZE tmpfs "$RAMDISK_DIR"  # Use sudo for mounting
    if [ $? -eq 0 ]; then
        echo "..RAM Disk Mounted at $RAMDISK_DIR"
    else
        echo "..Failed to Mount RAM Disk!"
        exit 1
    fi
else
    echo "..RAM Disk is already mounted at $RAMDISK_DIR!"
fi

# Clear RAM Disk
echo "Clearing RAM Disk..."
if [ "$(ls -A $RAMDISK_DIR)" ]; then
    clear_directory_with_progress "$RAMDISK_DIR"
    echo "..RAM Disk cleared."
else
    echo "..RAM Disk is already empty."
fi

# Copy contents from cache to RAM disk
echo "Copying cached contents to RAM disk..."
if [ "$(ls -A $CACHE_DIR)" ]; then
    copy_with_progress "$CACHE_DIR" "$RAMDISK_DIR"
    echo "..Cached contents copied to RAM disk."
else
    echo "..Cache directory is empty. Skipping copy."
fi

# Grace period
echo "Waiting 3 seconds..."
sleep 3
echo "..Grace Period Over."

# Launch Viewer loop
while true; do
    echo "Checking for Viewer executable..."
    if [ -x "$VIEWER_PATH" ]; then
        echo "..Executing Viewer..."
        
        if [ "$DEBUG_MODE" = true ]; then
            # In debug mode, show full output
            "$VIEWER_PATH"
        else
            # Suppress Viewer's terminal output (but allow the GUI to appear)
            "$VIEWER_PATH" >/dev/null 2>&1
        fi

        VIEWER_EXIT_STATUS=$?
        echo "..Viewer Exited with status $VIEWER_EXIT_STATUS."
    else
        echo "..Viewer executable missing or not executable at $VIEWER_PATH!"
        sleep 3
        break
    fi

    # Check if Viewer exited cleanly
    if [ $VIEWER_EXIT_STATUS -ne 0 ]; then
        echo "Viewer encountered an issue (Exit status: $VIEWER_EXIT_STATUS)."
    fi

    # Prompt user to relog or exit
    read -p "..Are you relogging? (y/N): " relog
    if [[ "$relog" =~ ^[Yy]$ ]]; then
        echo "..Relogging Viewer..."
        continue
    else
        echo "..Not relogging."
        
        # Clear cache directory
        echo "Clearing cache directory..."
        if [ "$(ls -A $CACHE_DIR)" ]; then
            clear_directory_with_progress "$CACHE_DIR"
            echo "..Cache directory cleared."
        else
            echo "..Cache directory is already empty."
        fi
        
        # Copy contents from RAM disk to cache
        echo "Copying RAM disk contents to cache..."
        copy_with_progress "$RAMDISK_DIR" "$CACHE_DIR"
        echo "..RAM disk contents copied to cache."
        
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

