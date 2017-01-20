Get-WmiObject Win32_DiskDrive | % {
  $disk = $_
  $partitions = "ASSOCIATORS OF " +
                "{Win32_DiskDrive.DeviceID='$($disk.DeviceID)'} " +
                "WHERE AssocClass = Win32_DiskDriveToDiskPartition"
  Get-WmiObject -Query $partitions | % {
    $partition = $_
    $drives = "ASSOCIATORS OF " +
              "{Win32_DiskPartition.DeviceID='$($partition.DeviceID)'} " +
              "WHERE AssocClass = Win32_LogicalDiskToPartition"
    Get-WmiObject -Query $drives | % {
      New-Object -Type PSCustomObject -Property @{
        Disk        = $disk.DeviceID
        DiskSize    = $disk.Size / 1GB
        DiskModel   = $disk.Model
        Partition   = $partition.Name
        RawSize     = $partition.Size / 1GB
        DriveLetter = $_.DeviceID
        VolumeName  = $_.VolumeName
        Size        = $_.Size / 1GB
        FreeSpace   = $_.FreeSpace / 1GB
      }
    }
  }
 }
