server {
    listen 80 default_server;
    listen [::]:80 default_server;
    
    server_name {{hostname}}{% if aliases %} {{aliases|join(' ')}}{% endif %};
    

    root {{www_root}}/{{nginx_public_folder}};

    # Add index.php to the list if you are using PHP
    index{% if php_installed is defined %} index.php{% endif %}{% if python_installed is defined %} index.py{% endif %} index.html index.htm index.nginx-debian.html;

    location / {
        # First attempt to serve request as file, then
        # as directory, then fall back to displaying a 404.
        #try_files $uri $uri/ =404;
        try_files $uri $uri/ /index.php?$args;
    }
    
    {% if php_installed is defined %}
    location ~ [^/]\.php(/|$) {
        include snippets/fastcgi-php.conf;
        
        if (!-f $document_root$fastcgi_script_name) {
            return 404;
        }

        # Mitigate https://httpoxy.org/ vulnerabilities
        fastcgi_param HTTP_PROXY "";

        fastcgi_pass unix:/run/php/php{{php_version}}-fpm.sock; 
    }
    {% endif %}

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    location ~ /\.ht {
        deny all;
    }
    
    {% if ssl_enabled is defined %}listen 443 ssl;
    listen [::]:443 ssl;
    
    ssl_certificate {{ssl_certs_cert_path}};
    ssl_certificate_key {{ssl_certs_privkey_path}};
    
    {% endif %}
    
}
