FROM nginx

RUN apt-get update && apt-get install -y iputils-ping

WORKDIR /app

COPY ./app .

RUN chmod +x load_balance.sh

EXPOSE 80

ENTRYPOINT [ "/bin/sh", "load_balance.sh" ]