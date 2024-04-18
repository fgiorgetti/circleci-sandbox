FROM registry.access.redhat.com/ubi9-minimal

RUN microdnf -y install iptables \
&& microdnf clean all

WORKDIR /app
COPY ./rules.sh /app

CMD ["/app/rules.sh"]
