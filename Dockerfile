FROM postgres:latest

ENV POSTGRES_DB=order
ENV POSTGRES_USER=order
ENV POSTGRES_PASSWORD=order

# Copy all migration files to init directory
# PostgreSQL will execute these in alphabetical order on first run
COPY sql/V_orde*.sql /docker-entrypoint-initdb.d/

# Ensure the container uses UTF-8 encoding
ENV LANG=en_US.utf8
