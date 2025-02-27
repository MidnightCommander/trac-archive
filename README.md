# Trac archive

Archive of Trac related content, mainly attachments.

## Provenance

### Sync from Trac server

```shell
rsync -av --delete \
  midnight-commander.org:/var/www/trac/attachments/ \
  attachments

python unquote-filenames.py

find attachments -type f | \
  sort > attachments-fs.csv
```

### Compare with the state of the database

```sql
SELECT COUNT(*)
FROM attachment;

SELECT CONCAT('attachments/', type, '/', id, '/', filename)
FROM attachment;
```
