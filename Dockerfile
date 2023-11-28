FROM bitnami/git:2.39.2-debian-11-r4

RUN apt update
RUN apt install bash zip -y

ADD pump.sh .
RUN chmod ugo+x pump.sh

CMD [ "/bin/bash", "-c", "/pump.sh" ]
