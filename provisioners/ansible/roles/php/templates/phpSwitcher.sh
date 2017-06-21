#!/usr/bin/env bash

VERSION=$1
PHPVERSION="php$VERSION"

# Check That this module exist

if [ -f /etc/apache2/mods-available/$PHPVERSION.conf ]; then

    echo "Enabling $PHPVERSION"

    # - CURRENT Enabled MODULE
    # /etc/apache2/mods-enabled/php7.0.conf
    FILEPATH=( $(find /etc/apache2/mods-enabled -name "php*\.conf" -print0 | xargs -0 ls) )
    [[ $FILEPATH =~ (php[0-9\.]+)\.conf ]]
    MODULE_ENABLED=${BASH_REMATCH[1]}
    
    # Disabled This Module
    if [ $MODULE_ENABLED ]; then
        # Disable Module
        sudo a2dismod $MODULE_ENABLED
    fi    

    # Enable New module 
    sudo a2enmod $PHPVERSION

    sudo update-alternatives --set php /usr/bin/php$VERSION
    sudo update-alternatives --set phar /usr/bin/phar$VERSION
    sudo update-alternatives --set phar.phar /usr/bin/phar.phar$VERSION 

    # Restart
    sudo service apache2 graceful
 
else
    echo "Cannot find module for php version: $VERSION ($PHPVERSION)"
fi