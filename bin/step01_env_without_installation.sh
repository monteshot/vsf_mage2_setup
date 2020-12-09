#!/usr/bin/env/bash
## ************************************************************************
#     Script to setup empty Exoscale Cloud host
#     (Linux Ubuntu 18.04 LTS 64-bit /4 GB, 2 x 2198 MHz, 10 GB disk/)
#     Upgrade OS, install required services and run it, clone application
#     sources.
## ************************************************************************
# shellcheck disable=SC1090
# root directory (set before or relative to the current shell script)
DIR_ROOT=${DIR_ROOT:=$(cd "$(dirname "$0")/../" && pwd)}
#  Exit immediately if a command exits with a non-zero status.
set -e -x

echo "========================================================================"
echo "Read local configuration."
echo "========================================================================"
. "${DIR_ROOT}/cfg.local.sh"
# check external vars used in this script (see cfg.[work|live].sh)
: "${REDIS_HOST:?}"
: "${REDIS_PORT:?}"
: "${VSF_API_SERVER_IP:?}"
: "${VSF_API_SERVER_PORT:?}"
: "${VSF_API_WEB_HOST:?}"
: "${VSF_FRONT_SERVER_IP:?}"
: "${VSF_FRONT_SERVER_PORT:?}"
: "${VSF_FRONT_WEB_HOST:?}"
: "${PROJECT_NAME:?}"
echo "UA
Sumy Region
Shostka
MonteShot
MonteShot
$1
monteshot@monteshot.com" | sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/${PROJECT_NAME}.key -out /etc/ssl/certs/${PROJECT_NAME}.crt
echo "UA
Sumy Region
Shostka
MonteShot
MonteShot
$1
monteshot@monteshot.com" | sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/${PROJECT_NAME}.key -out /etc/ssl/certs/${PROJECT_NAME}.crt
echo "========================================================================"
echo "Configure Apache."
echo "========================================================================"
echo "Add virtual hosts to local DNS."
echo "127.0.0.1 front.vsf.${PROJECT_NAME} api.vsf.${PROJECT_NAME}" | sudo tee -a /etc/hosts >/dev/null
echo "Add virtual host config for frontend server"
cat <<EOM | sudo tee /etc/apache2/sites-available/front.vsf.${PROJECT_NAME}.conf >/dev/null
<VirtualHost *:80>
    ServerName ${VSF_FRONT_WEB_HOST}
    ProxyPreserveHost On
    ProxyPass / https://${VSF_FRONT_SERVER_IP}:${VSF_FRONT_SERVER_PORT}/
    ProxyPassReverse / https://${VSF_FRONT_SERVER_IP}:${VSF_FRONT_SERVER_PORT}/
    LogLevel info
    CustomLog /home/${USER}/vue/front.vsf.${PROJECT_NAME}_access.log combined
    ErrorLog /home/${USER}/vue/front.vsf.${PROJECT_NAME}_error.log
</VirtualHost>
<IfModule mod_ssl.c>
    <VirtualHost *:443>
    ServerName ${VSF_FRONT_WEB_HOST}
    ProxyPreserveHost On
    ProxyPass / https://${VSF_FRONT_SERVER_IP}:${VSF_FRONT_SERVER_PORT}/
    ProxyPassReverse / https://${VSF_FRONT_SERVER_IP}:${VSF_FRONT_SERVER_PORT}/
    LogLevel info
    CustomLog /home/${USER}/vue/front.vsf.${PROJECT_NAME}_access.log combined
    ErrorLog /home/${USER}/vue/front.vsf.${PROJECT_NAME}_error.log
     SSLEngine on
        SSLCertificateFile	/etc/ssl/certs/${PROJECT_NAME}.crt
		SSLCertificateKeyFile /etc/ssl/private/${PROJECT_NAME}.key
		<FilesMatch "\.(cgi|shtml|phtml|php)$">
				SSLOptions +StdEnvVars
		</FilesMatch>
		<Directory /usr/lib/cgi-bin>
				SSLOptions +StdEnvVars
		</Directory>
    </VirtualHost>
</IfModule>
EOM
echo "Add virtual host config for API server"
cat <<EOM | sudo tee /etc/apache2/sites-available/api.vsf.${PROJECT_NAME}.conf >/dev/null
<VirtualHost *:80>
    ServerName ${VSF_API_WEB_HOST}
    ProxyPreserveHost On
    ProxyPass / https://${VSF_API_SERVER_IP}:${VSF_API_SERVER_PORT}/
    ProxyPassReverse / https://${VSF_API_SERVER_IP}:${VSF_API_SERVER_PORT}/
    LogLevel info
    CustomLog /home/${USER}/vue/api.vsf.${PROJECT_NAME}_access.log combined
    ErrorLog /home/${USER}/vue/api.vsf.${PROJECT_NAME}_error.log
</VirtualHost>
<IfModule mod_ssl.c>
    <VirtualHost *:443>
     ServerName ${VSF_API_WEB_HOST}
    ProxyPreserveHost On
    ProxyPass / https://${VSF_API_SERVER_IP}:${VSF_API_SERVER_PORT}/
    ProxyPassReverse / https://${VSF_API_SERVER_IP}:${VSF_API_SERVER_PORT}/
    LogLevel info
    CustomLog /home/${USER}/vue/api.vsf.${PROJECT_NAME}_access.log combined
    ErrorLog /home/${USER}/vue/api.vsf.${PROJECT_NAME}_error.log
       SSLEngine on
        SSLCertificateFile	/etc/ssl/certs/${PROJECT_NAME}.crt
		SSLCertificateKeyFile /etc/ssl/private/${PROJECT_NAME}.key
		<FilesMatch "\.(cgi|shtml|phtml|php)$">
				SSLOptions +StdEnvVars
		</FilesMatch>
		<Directory /usr/lib/cgi-bin>
				SSLOptions +StdEnvVars
		</Directory>
    </VirtualHost>
</IfModule>
EOM
sudo a2ensite api.vsf.${PROJECT_NAME}
sudo a2ensite front.vsf.${PROJECT_NAME}
sudo service apache2 restart
echo "========================================================================"
echo "Env setting process is completed."
echo "========================================================================"
bash ${DIR_ROOT}"/bin/step02_vsf_front.sh"
