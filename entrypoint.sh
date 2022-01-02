#!/bin/sh
if [ "$BACKUP_SCHEDULE" != "" ]; then
    echo "$BACKUP_SCHEDULE /app/duplicacy-autobackup.sh backup" > /var/spool/cron/crontabs/root
fi
if [ "$PRUNE_SCHEDULE" != "" ]; then
    echo "$PRUNE_SCHEDULE /app/duplicacy-autobackup.sh prune" >> /var/spool/cron/crontabs/root
fi

cd /wd

/app/duplicacy-autobackup.sh init

if [[ $BACKUP_IMMEDIATLY == "yes" ]] || [[ $BACKUP_IMMEDIATELY == "yes" ]]; then # two spellings for retro-compatibility
    echo "Running a backup right now"
    /app/make-symlinks.sh # Create symlinks in /wd/ to items in /data/
    /app/duplicacy-autobackup.sh backup
    /app/dispose-symlinks.sh
fi

crond -l 8 -f
