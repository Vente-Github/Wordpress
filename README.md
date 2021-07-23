# Wordpress

Blog para gestores de Vente

## Instalación
Hacer la instalación en / y luego mover todo el contenido a la carpeta /blog. 
Una vez movido el contenido es necesario crear un fichero en / con nombre .htaccess con el siguiente contenido.

```
<IfModule mod_rewrite.c>
RewriteEngine on
RewriteCond %{HTTP_HOST} ^(www.)?vente.tenerife.es$
RewriteCond %{REQUEST_URI} !^/blog/
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ /blog/$1
RewriteCond %{HTTP_HOST} ^(www.)?vente.tenerife.es$
RewriteRule ^(/)?$ blog/index.php [L] 
</IfModule>

php_value upload_max_filesize 256M
```

## Backup

Conectarse al minio.

```bash
mc alias set minio https://minio.vente.tenerife.int
```

Creación del usuario.

```bash
mc admin user add minio wp-backup-user
mc admin group add minio wp-backup-group wp-backup-user
```

Crear política de acceso al bucket.

```bash
mc admin policy add minio wp-backup-policy --insecure <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketLocation",
                "s3:ListBucket",
                "s3:ListBucketMultipartUploads"
            ],
            "Resource": [
                "arn:aws:s3:::wp-backups"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:AbortMultipartUpload",
                "s3:DeleteObject",
                "s3:DeleteObjectVersion",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::wp-backups/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets"
            ],
            "Resource": [
                "arn:aws:s3:::*"
            ]
        }
    ]
}
EOF
```

Se aplican las políticas al grupo.

```bash
mc admin policy set minio wp-backup-policy group=wp-backup-group
```

Se crea el bucket.

```bash
mc mb minio/wp-backups --insecure
```

Aplica política de retención de backups 2 días.

```bash
mc ilm import minio/wp-backups --insecure <<EOF
{
  "Rules": [
   {
    "Expiration": {
     "Days": 2
    },
    "ID": "deleteOldBackups",
    "Status": "Enabled"
   }
  ]
}
EOF
```