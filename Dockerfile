FROM docker.io/library/busybox@sha256:0000000000000000000000000000000000000000000000000000000000000000
COPY www/ /www/
USER 10001:10001
EXPOSE 8080
CMD ["/bin/busybox", "httpd", "-f", "-p", "8080", "-h", "/www"]
