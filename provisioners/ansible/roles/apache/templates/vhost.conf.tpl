<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    
    ServerName {{hostname}}
    {% if aliases %}ServerAlias {{aliases|join(' ')}} {% endif %}
   
    DocumentRoot {{www_root}}/{{apache_public_folder}}
    AllowEncodedSlashes On

    <Directory {{www_root}}/{{apache_public_folder}}>
        Options -Indexes +FollowSymLinks
        DirectoryIndex index.php index.html
        Order allow,deny
        Allow from all
        AllowOverride All
    </Directory>
        
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
    
</VirtualHost>
{% if ssl_enabled is defined %} 
<VirtualHost *:443>
    ServerAdmin webmaster@localhost
    
    ServerName {{hostname}}
    {% if aliases %}ServerAlias {{aliases|join(' ')}} {% endif %}
   
    DocumentRoot {{www_root}}/{{apache_public_folder}}
    AllowEncodedSlashes On

    <Directory {{www_root}}/{{apache_public_folder}}>
        Options -Indexes +FollowSymLinks
        DirectoryIndex index.php index.html
        Order allow,deny
        Allow from all
        AllowOverride All
    </Directory>
        
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
    
    SSLEngine on
    SSLCertificateFile    {{ssl_certs_cert_path}}
    SSLCertificateKeyFile {{ssl_certs_privkey_path}}
</VirtualHost>
{% endif %}