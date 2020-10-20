FROM postgres:11
RUN apt-get update && apt-get install -y curl python2.7
RUN curl -sSL https://sdk.cloud.google.com | bash
ENV PATH $PATH:/root/google-cloud-sdk/bin

RUN mkdir /data
ADD /scripts/log.sh /scripts/log.sh
ADD /scripts/backup.sh /scripts/backup.sh
RUN chmod +x /scripts/backup.sh

CMD ["/scripts/backup.sh"]