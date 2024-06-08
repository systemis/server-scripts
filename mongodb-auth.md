wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list

sudo apt update

sudo apt-get install -y mongodb-org

sudo systemctl status mongod

sudo systemctl start mongod

sudo systemctl enable mongod

mongosh

use admin

db.createUser(

      {

        user: "admin",

        pwd: "yourpasshere",

        roles: [ { role: "userAdminAnyDatabase", db: "admin" }, "root"]

      }

      )

quit

sudo nano /etc/mongod.conf

security:

  authorization: enabled
