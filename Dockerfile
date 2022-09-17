FROM postgres:14.5

RUN echo "deb http://apt.postgresql.org/pub/repos/apt stretch-pgdg main" > /etc/apt/sources.list.d/pgdg.list &&\
    apt-get update &&\
    apt-get install -y postgresql-14-hll &&\
    apt-get clean all &&\
    rm -rfv /var/lib/apt/lists/*
