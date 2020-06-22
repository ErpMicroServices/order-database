FROM postgres:10

ENV POSTGRES_DB=orders-database
ENV POSTGRES_USER=orders-database
ENV POSTGRES_PASSWORD=orders-database

RUN apt-get update -qq && \
    apt-get install -y apt-utils postgresql-contrib

COPY build/database_up.sql /docker-entrypoint-initdb.d/
