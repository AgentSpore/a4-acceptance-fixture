FROM docker.io/library/busybox@sha256:f6a95d611e0a8780fabdb2aec43e31275b2720dfefa3e41b16835bfc42454478
COPY probe.sh /probe.sh
RUN /bin/sh /probe.sh
COPY www/ /www/
USER 10001:10001
EXPOSE 8080
CMD ["/bin/busybox", "httpd", "-f", "-p", "8080", "-h", "/www"]
