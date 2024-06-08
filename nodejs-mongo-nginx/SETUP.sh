domain=${1?param missing - domain.} 

# INSTALL NODEJS
echo "-------- INSTALL NODEJS --------"
curl -sL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt-get install -y build-essential

# INSTALL MONGODB
echo "-------- INSTALL MONGODB --------"
wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org

echo "-------- RUN MONGODB --------"
mkdir /data
mkdir /data/db
sudo systemctl daemon-reload
sudo systemctl enable mongod
sudo systemctl start mongod

# INSTALL PM2
echo "-------- INSTALL PM2 --------"
sudo npm install -g pm2

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
