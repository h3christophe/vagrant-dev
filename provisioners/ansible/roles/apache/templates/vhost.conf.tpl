<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    
{% include "host-site.tpl" ignore missing %}

</VirtualHost>
    
{% if ssl_enabled is defined %} 
<VirtualHost *:443>
    ServerAdmin webmaster@localhost
    
    SSLEngine on
    SSLCertificateFile    {{ssl_certs_cert_path}}
    SSLCertificateKeyFile {{ssl_certs_privkey_path}}
    
{% include "host-site.tpl" ignore missing %}
    
</VirtualHost>
{% endif %}