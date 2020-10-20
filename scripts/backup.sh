set -eu

CURRENT_DATE=$(date -u +"%Y-%m-%dT%H%M%SZ")
FILENAME="$BACKUP_NAME-$CURRENT_DATE.dump"
LOG_UTILS="./scripts/log.sh"
source "${LOG_UTILS}"

echo "============================ Postgres Backup ==========================================="
echo "           Beginning backup database $PGDATABASE from $PGHOST"
echo "         to bucket named $GCS_BUCKET_NAME at Google Cloud Storage"
echo "========================================================================================"
echo ""
if [ -z $PGHOST ] ; then
    log "You must specify a PGHOST env var"
    exit 1
fi
if [ -z $PGPORT ] ; then
    log "You must specify a PGPORT env var"
    exit 1
fi
if [ -z $PGPASSWORD ] ; then
    log "You must specify a PGPASSWORD env var"
    exit 1
fi
if [ -z $PGUSERNAME ] ; then
    log "You must specify a PGUSERNAME env var"
    exit 1
fi
if [ -z $PGDATABASE ] ; then
    log "You must specify a PGDATABASE env var"
    exit 1
fi

if [ -z $GCS_BUCKET_NAME ]; then
    log "You must specify a google cloud storage GCS_BUCKET_NAME address such as 'database'"
    exit 1
fi

if [ -z $BACKUP_NAME ]; then
    BACKUP_NAME=postgres_backup
fi

log "Activating google credentials before beginning"
echo $GOOGLE_APPLICATION_CREDENTIALS | base64 --decode > google_service_account.json
gcloud auth activate-service-account --key-file google_service_account.json
rm google_service_account.json

if [ $? -ne 0 ] ; then
    log "Credentials failed; no way to copy to google."
fi
echo ""
log "Dumping database named $PGDATABASE from $PGHOST"
PGPASSWORD=$PGPASSWORD pg_dump --no-owner --format=custom -h ${PGHOST} -p ${PGPORT} -U ${PGUSERNAME} ${PGDATABASE} > /data/$FILENAME
echo "Database backup successfully with size:"
du -hs /data/$FILENAME
echo ""
log "Pushing /data/$FILENAME to $GCS_BUCKET_NAME"
gsutil cp /data/$FILENAME $GCS_BUCKET_NAME
echo ""

exit $?