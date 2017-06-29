<IfModule mod_fastcgi.c>
    
    {% for version in php_versions %}AddHandler php{{version}}-fcgi .php
    Action php{{version}}-fcgi /php{{version}}-fcgi
    Alias /php{{version}}-fcgi /usr/lib/cgi-bin/php{{version}}-fcgi
    FastCgiExternalServer /usr/lib/cgi-bin/php{{version}}-fcgi -socket /var/run/php/php{{version}}-fpm.sock -pass-header Authorization
    {% endfor %}
    
</IfModule>