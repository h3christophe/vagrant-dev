    ServerName {{hostname}}
    {% if aliases %}ServerAlias {{aliases|join(' ')}} {% endif %}
   
    DocumentRoot {{www_root}}/{{apache_public_folder}}
    AllowEncodedSlashes On
    
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
    
    <Directory {{www_root}}/{{apache_public_folder}}>
        Options -Indexes +FollowSymLinks
        DirectoryIndex {% if php_installed is defined %}index.php{% endif %}{% if python_installed is defined %} index.py{% endif %} index.html
        Order allow,deny
        Allow from all
        AllowOverride All
    </Directory>
    
    {% if php_installed is defined and php_mode == 'fastcgi' %}  
    <IfModule mod_fastcgi.c>
        <FilesMatch ".+\.ph(p[345]?|t|tml)$">
            SetHandler php{{php_version}}-fcgi
        </FilesMatch>
        <Directory "/usr/lib/cgi-bin">
            Require all granted
        </Directory>
        SetEnvIf Authorization "(.*)" HTTP_AUTHORIZATION=$1
    </IfModule>
    {% endif %}
    
    {% if python_installed is defined %}
    AddHandler cgi-script .py
    <Directory {{www_root}}/{{apache_public_folder}}>
        Options +ExecCGI
    </Directory>
    {% endif %}