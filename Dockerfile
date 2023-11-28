FROM bitnami/git:2.39.2-debian-11-r4

RUN apt update
RUN apt install bash zip -y

ADD push-gitrefs-to-github.sh .
RUN chmod ugo+x push-gitrefs-to-github.sh

CMD [ "/bin/bash", "-c", "/push-gitrefs-to-github.sh" ]
