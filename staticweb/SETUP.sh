domain=${1?param missing - domain.} 

ufw status
ufw allow 80
ufw allow 443

# INSTALL NGINX
echo "-------- INSTALL NGINX --------"
sudo apt-get update
sudo apt-get install nginx

echo "-------- RUN NGINX --------"
sudo systemctl enable nginx
sudo systemctl start nginx

# INSTALL LETSENCRYPT
echo "-------- INSTALL LETSENCRYPT --------"
sudo apt-get update
sudo apt-get install letsencrypt

echo "-------- SETUP SSL --------"
cp nginx-before-ssl.conf /etc/nginx/sites-enabled/default
sudo systemctl restart nginx

echo "-------- CREATE SSL CERTIFICATE --------"
sudo letsencrypt certonly -a webroot --webroot-path=/var/www/html -d $domain
sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
cp ssl-params.conf /etc/nginx/snippets/ssl-params.conf
cp nginx.conf /etc/nginx/sites-enabled/default
sed -i "s/__DOMAIN__/$domain/" /etc/nginx/sites-enabled/default
sudo systemctl restart nginx

echo "-------- SETUP PROJECT ---------"

# expand
#letsencrypt certonly --expand -a webroot --webroot-path=/var/www/html -d vn.mollector.com -d cb3.mollector.com
