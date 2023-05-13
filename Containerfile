FROM    registry.fedoraproject.org/fedora-toolbox:38 

LABEL   com.github.containers.toolbox="true" \
        usage="This image is meant to be used with the toolbox or distrobox command" \
        summary="A cloud-native terminal experience" \
        maintainer="JMcDade42@gmail.com"

COPY    ./repos.d/* ./packages.d/* /tmp

RUN     dnf update -y && \
        mkdir -p /etc/packages.d && \
        mv /tmp/*.pkgs /etc/packages.d; \
        mv /tmp/*.repo /etc/yum.repos.d/; \
        for file in $(ls /etc/packages.d); \
                do sudo dnf install -y $(cat /etc/packages.d/$file); \
        done && \
        dnf clean all && \
        ln -s /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \
        ln -s /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
        ln -s /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
        ln -s /usr/bin/distrobox-host-exec /usr/local/bin/distrobox && \
        ln -s /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree