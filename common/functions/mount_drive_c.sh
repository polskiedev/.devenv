# Automount on WSL Startup
# sudo nano /etc/fstab
# c: /mnt/c drvfs defaults 0 0

# Define the drive letter and mount point
drive_letter="C:"
mount_point="/mnt/c"

# Check if the drive is already mounted
if grep -qs "$drive_letter" /proc/mounts; then
    echo "Drive $drive_letter is already mounted at $mount_point"
else
    echo "Drive $drive_letter is not mounted. Mounting at $mount_point..."
    sudo mount -t drvfs "$drive_letter" "$mount_point"
    echo "Drive $drive_letter mounted at $mount_point"
fi
