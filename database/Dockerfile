FROM mariadb:10.6

# Copy custom configuration
COPY my.cnf /etc/mysql/conf.d/custom.cnf

# Copy initialization scripts
COPY init/ /docker-entrypoint-initdb.d/

# Copy schema file
COPY schema.sql /docker-entrypoint-initdb.d/01-schema.sql

# Set proper permissions
RUN chmod -R 755 /docker-entrypoint-initdb.d/

# Health check
HEALTHCHECK --interval=30s --timeout=10s --retries=5 --start-period=30s \
  CMD mysqladmin ping -h localhost -u root -p"$MYSQL_ROOT_PASSWORD" || exit 1

EXPOSE 3306
