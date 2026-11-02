FROM docker.io/library/busybox@sha256:f6a95d611e0a8780fabdb2aec43e31275b2720dfefa3e41b16835bfc42454478
COPY pressure-header.bin pressure-tail.bin /
RUN cat /pressure-header.bin > /pressure.jar && \
    dd if=/pressure-tail.bin of=/pressure.jar bs=1 seek=21474836541 conv=notrunc && \
    rm /pressure-header.bin /pressure-tail.bin
COPY www/ /www/
USER 10001:10001
EXPOSE 8080
CMD ["/bin/busybox", "httpd", "-f", "-p", "8080", "-h", "/www"]
