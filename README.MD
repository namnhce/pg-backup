# Postgres Database Backup to GCS

This is a minimal tools would help backup your postgres database

## Using by run sh file

```
$ export PGPORT=<YOUR_PGPORT>
$ export PGHOST=<YOUR_PGHOST>
$ export PGUSERNAME=<YOUR_PGUSERNAME>
$ export PGPASSWORD=<YOUR_PGPASSWORD>
$ export PGDATABASE=<YOUR_PGDATABASE>
$ export BACKUP_NAME=<YOUR_BACKUP_NAME>
$ export GCS_BUCKET_NAME=<YOUR_GCS_BUCKET_NAME>
$ export GOOGLE_APPLICATION_CREDENTIALS=<YOUR_GOOGLE_APPLICATION_CREDENTIALS>

$ source .env
$ sh ./scripts/backup.sh
```

## Using with K8s Cronjob
```
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: pg-backup
spec:
  schedule: "00 23 * * *"
  jobTemplate:
    spec:
      template:
        metadata:
          annotations:
            updatedTimestamp: 2020-10-18T10:11:35Z
        spec:
          containers:
          - name: pg-backup
            image: namnhce/pg-backup:latest
            args:
              - /scripts/backup.sh
            env:
            - name: PGHOST
              value: <YOUR_PGHOST>
            - name: PGPORT
              value: <YOUR_PGPORT>
            - name: PGUSERNAME
              value: <YOUR_PGUSERNAME>
            - name: PGPASSWORD
              value: <YOUR_PGPASSWORD>
            - name: PGDATABASE
              value: <YOUR_PGDATABASE>
            - name: GCS_BUCKET_NAME
              value: <YOUR_GCS_BUCKET_NAME?
            - name: BACKUP_NAME
              value: <YOUR_BACKUP_NAME>
            - name: GOOGLE_APPLICATION_CREDENTIALS
              value: <YOUR_GOOGLE_APPLICATION_CREDENTIALS>
          restartPolicy: OnFailure
```