composer create-project symfony/website-skeleton app
mv app/* .
mv app/.env .
mv app/.env.test .
mv app/.gitignore .
cp .env .env.local
rm -R app
