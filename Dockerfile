FROM postgres:9

ENV POSTGRES_DB=ordering_products-database
ENV POSTGRES_USER=ordering_products-database
ENV POSTGRES_PASSWORD=ordering_products-database

RUN apt-get update -qq && \
    apt-get install -y apt-utils postgresql-contrib
