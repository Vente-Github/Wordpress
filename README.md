# Wordpress

Blog para gestores de Vente

## Instalación
Hacer la instalación en / y luego mover todo el contenido a la carpeta /blog. 
Una vez movido el contenido es necesario crear un fichero en / con nombre .htaccess con el siguiente contenido.

```
<IfModule mod_rewrite.c>
RewriteEngine on
RewriteCond %{HTTP_HOST} ^(www.)?vente-pre.tenerife.es$
RewriteCond %{REQUEST_URI} !^/blog/
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ /blog/$1
RewriteCond %{HTTP_HOST} ^(www.)?vente-pre.tenerife.es$
RewriteRule ^(/)?$ blog/index.php [L] 
</IfModule>

php_value upload_max_filesize 256M
```