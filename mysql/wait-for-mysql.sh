#!/usr/bin/env bash
DATABASE_HOST=${DATABASE_HOST:-mysql}
DATABASE_PORT=${DATABASE_PORT:-3306}
DATABASE_NAME=${DATABASE_NAME:-maurodatamapper}

DATABASE_USERNAME=${DATABASE_USERNAME:-${DATASOURCE_USERNAME:-root}}
DATABASE_PASSWORD=${DATABASE_PASSWORD:-${DATASOURCE_PASSWORD:-${MYSQL_ROOT_PASSWORD:-*}}}

# Wait for MySQL database to be ready before starting the Java process

wait-for-it.sh "${DATABASE_HOST}:${DATABASE_PORT}" -t 0

>&2 echo "Verifying MySQL DB"
echo "mysql -u ${DATABASE_USERNAME} -p'${DATABASE_PASSWORD}' -h ${DATABASE_HOST} -P ${DATABASE_PORT} -D ${DATABASE_NAME} -e \"SHOW DATABASES;\""

until mysql -u ${DATABASE_USERNAME} -p'${DATABASE_PASSWORD}' -h ${DATABASE_HOST} -P ${DATABASE_PORT} -D ${DATABASE_NAME} -e "SHOW DATABASES;"; do
	sleep 1
done

echo "Starting Application"
exec "$@"