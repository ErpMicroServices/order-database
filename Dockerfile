FROM postgres:10

ENV POSTGRES_DB=order_database
ENV POSTGRES_USER=order_database
ENV POSTGRES_PASSWORD=order_database

RUN apt-get update -qq && \
    apt-get install -y apt-utils postgresql-contrib

COPY build/database_up.sql /docker-entrypoint-initdb.d/
