composer create-project symfony/website-skeleton app

mv app/* .
mv app/.env .
mv app/.env.test .
mv app/.gitignore .

sed -i 's/# DATABASE_URL="mysql/DATABASE_URL="mysql/g' .env
sed -i 's/DATABASE_URL="postgresql/# DATABASE_URL="postgresql/g' .env
sed -i 's/mysql:\/\/db_user:db_password@127.0.0.1:3306\/db_name?serverVersion=5.7/mysql:\/\/root:secret@mysql_docker_symfony\/symfony_app?serverVersion=8.0/g' .env

cp .env .env.local

rm -R app
