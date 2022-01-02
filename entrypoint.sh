#!/bin/sh
if [ -n "${BACKUP_SCHEDULE+1}" ]; then
    echo "$BACKUP_SCHEDULE /app/duplicacy-autobackup.sh backup" > /var/spool/cron/crontabs/root
fi
if [ -n "${PRUNE_SCHEDULE+1}" ]; then
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

if [ -n "${BACKUP_SCHEDULE+1}" ] || [ -n "${PRUNE_SCHEDULE+1}" ]; then
    crond -l 8 -f
fi
