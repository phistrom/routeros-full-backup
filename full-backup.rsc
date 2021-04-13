# By Phillip Stromberg
# on 2021-04-13
# 
# Full Backup Script
# Makes a system backup as well as a configuration export
#
{
    # Define a password for your backups.
    # Starting with RouterOS v6.43, if no password is given, the backup 
    # will not be encrypted!
    :local BackupPasswd "password"

    # You can change what folder backups get placed in here.
    # Just put your desired export path in quotes.
    # Do NOT start OR end with slashes!
    # examples:
    # :local exportPath "disk1/exports"
    # :local exportPath "flash/exports"
    :local exportPath "exports"

    
    # The name of the backup file generated (omit the .backup part)
    # i.e. if this is "daily-backup", the file will be "daily-backup.backup".
    # It will be inside the $exportPath defined above
    :local backupFileName "daily-backup"

    # This creates a folder called "exports"
    # it tries to "download" a file called ".empty" from
    # the localhost on port 1 (which is never open and certainly isn't
    # a good HTTP port). This fails to download anything or create a 
    # file but that's fine, it created the folder we wanted!
    :do {
        # using an on-error block as well as specifiying "as-value" parameter
        # hides the "connection failed" message from the user
        /tool fetch dst-path="$exportPath/.empty" url=http://127.0.0.1:1 as-value
    } on-error={}

    /system backup save encryption=aes-sha256 name="$exportPath/daily-backup" password=$BackupPasswd
    /export compact file="$exportPath/compact"
    /export terse file="$exportPath/terse"
    /export verbose file="$exportPath/verbose"
}
