########################
###     BUILDERS     ###
########################

########################
### go               ###
########################
FROM --platform=$BUILDPLATFORM ubuntu as go_builder
RUN apt-get update && apt-get upgrade -y --no-install-recommends && DEBIAN_FRONTEND=noninteractive \
	apt-get install -y --no-install-recommends \
    ca-certificates \
    wget

ARG BUILDPLATFORM
ENV GO_DOWNLOAD_TARGET "go1.19.3.${BUILDPLATFORM}.tar.gz"
RUN echo ${GO_DOWNLOAD_TARGET} | tr / - > /tmp/go_download_target
RUN wget -L -q https://go.dev/dl/$(cat /tmp/go_download_target) -O /opt/$(cat /tmp/go_download_target) \
    --tries=10 --retry-connrefused -c
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf /opt/$(cat /tmp/go_download_target)

### gobuster         ###
########################
RUN /usr/local/go/bin/go install github.com/OJ/gobuster/v3@latest

### fuff             ###
########################
RUN /usr/local/go/bin/go install github.com/ffuf/ffuf@latest

### chisel           ###
########################
RUN /usr/local/go/bin/go install github.com/jpillora/chisel@latest

########################
### from git         ###
########################
FROM ubuntu as git_builder
RUN apt-get update && apt-get upgrade -y --no-install-recommends && DEBIAN_FRONTEND=noninteractive \
	apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    git \
    libbz2-dev \
    libgmp-dev \
    libpcap-dev \
    libssl-dev \
    pkg-config \
    make \
    zlib1g-dev \ 
    yasm 

### john the ripper  ###
########################
RUN git clone https://github.com/openwall/john -b bleeding-jumbo /opt/john
RUN cd /opt/john/src && ./configure && make -s clean && make -sj4

### seclists         ###
########################
RUN git clone --depth 1 https://github.com/danielmiessler/SecLists.git /usr/share/SecLists

### sqlmap           ###
########################
RUN git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git /opt/sqlmap-dev

### searchsploit     ###
########################
RUN git clone https://gitlab.com/exploit-database/exploitdb.git /opt/exploit-database

########################
###     RUNNER       ###
########################
FROM ubuntu:focal
LABEL maintainer="@edelauna"

### General Pre-reqs ###
########################
ENV TZ Etc/UTC
RUN apt-get update && apt-get upgrade -y --no-install-recommends && DEBIAN_FRONTEND=noninteractive \
	apt-get install -y --no-install-recommends \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
    dbus \
    dnsutils \
    file \
    fontconfig \
    git \
    gnupg \
    less \
    lsb-release \
    postgresql-client \
    ssh \
    sshfs \
    sudo \
    tzdata \
    wget \
    vim \
    zsh

### zsh plugins      ###
########################
RUN git clone https://github.com/zsh-users/zsh-autosuggestions.git /usr/local/share/zsh-autosuggestions &&\
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /usr/local/share/zsh-syntax-highlighting && \
    mkdir -p /usr/local/share/z && curl -fsSL https://raw.githubusercontent.com/rupa/z/master/z.sh \
    -o /usr/local/share/z/z.sh && chmod +x /usr/local/share/z/z.sh && \
    git clone https://github.com/zsh-users/zsh-history-substring-search.git /usr/local/share/zsh-history-substring-search


### user setup       ###
########################
ENV HOME_DIR "/home/dev/"

RUN useradd -ms /bin/zsh dev && \
    echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER dev
WORKDIR ${HOME_DIR}

ENV ZPROFILE="${HOME_DIR}.profile"
ENV ALIAS_FILE="${HOME_DIR}.alias"

### go               ###
########################
COPY --from=go_builder /usr/local/go /usr/local/go
COPY --from=go_builder /root/go/bin "$HOME_DIR/go/bin"
RUN echo 'export PATH="$PATH:/usr/local/go/bin"' >> "${ZPROFILE}" && \
	echo 'export PATH="'"${HOME_DIR}"'go/bin:$PATH" ' >> "${ZPROFILE}"

### openvpn          ###
########################
ENV DISTRO "focal"
ENV OPENVPN_URL "https://swupdate.openvpn.net/community/openvpn3/repos/openvpn3-${DISTRO}.list"
RUN sudo wget https://swupdate.openvpn.net/repos/openvpn-repo-pkg-key.pub -O /tmp/openvpn-repo-pkg-key.pub && \
sudo apt-key add /tmp/openvpn-repo-pkg-key.pub && \
sudo wget -O /etc/apt/sources.list.d/openvpn3.list ${OPENVPN_URL}

### mysql            ###
########################
RUN wget https://repo.mysql.com/mysql-apt-config_0.8.22-1_all.deb -O /tmp/mysql-apt-config_0.8.22-1_all.deb && \
	sudo dpkg -i /tmp/mysql-apt-config_0.8.22-1_all.deb

### fonts            ###
########################
RUN mkdir -p ".fonts" ".local/bin"

RUN curl -L "https://github.com/abertsch/Menlo-for-Powerline/raw/master/Menlo%20for%20Powerline.ttf" \
    -o ".fonts/Menlo for Powerline.ttf" && \
    fc-cache -vf .fonts

### pktriot          ###
########################
RUN wget -qO - https://download.packetriot.com/linux/debian/pubkey.gpg | sudo apt-key add -

RUN echo "\
deb [arch=amd64] https://download.packetriot.com/linux/debian/buster/stable/non-free/binary-amd64 / \n\
deb [arch=i386]  https://download.packetriot.com/linux/debian/buster/stable/non-free/binary-i386  / \n\
deb [arch=armhf] https://download.packetriot.com/linux/debian/buster/stable/non-free/binary-armhf / \n\
deb [arch=arm64] https://download.packetriot.com/linux/debian/buster/stable/non-free/binary-arm64 / \n\
" | sudo tee /etc/apt/sources.list.d/packetriot.list

### apps             ###
########################
RUN sudo apt-get update && sudo apt-get upgrade -y --no-install-recommends && \
	DEBIAN_FRONTEND=noninteractive sudo apt-get install -y --no-install-recommends \
    autoconf \
    bison \
    build-essential \
    iputils-ping \
    libbz2-dev \
    libffi-dev \
    libgdbm-dev \
    libgmp-dev \
    libncurses5-dev \
    libpcap-dev \
    libpq-dev \
    libreadline-dev \
    libssl-dev \
    libyaml-dev \
    manpages-dev \
    mysql-server \
    netcat \
    net-tools \
    nmap \
    openvpn3 \
    pkg-config \
    pktriot \
    python3.10 \
    python3-distutils \
    shellcheck \
    smbclient \
    snmp \
    snmp-mibs-downloader \
    sqlite \
    socat \
    steghide \
    tcpick \
    unzip \
    whois \
    yasm \
    zlib1g-dev

### rbenv            ###
########################
RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | /bin/zsh
RUN echo 'export PATH="'"${HOME_DIR}"'.rbenv/bin:$PATH"' >> "${ZPROFILE}" && \
    echo 'eval "$(rbenv init -)"' >> "${ZPROFILE}"
RUN git clone https://github.com/rbenv/ruby-build.git && \
    PREFIX=/usr/local sudo ./ruby-build/install.sh
RUN /home/dev/.rbenv/bin/rbenv install 3.1.2 && \
    /home/dev/.rbenv/bin/rbenv global 3.1.2

### nvm              ###
########################
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | PROFILE=${ZPROFILE} bash
RUN . /home/dev/.profile && nvm install --lts && nvm use --lts

### mibs downloader  ###
########################
RUN sudo download-mibs

### enum4linux       ###
########################
RUN sudo git clone https://github.com/CiscoCXSecurity/enum4linux.git /opt/enum4linux
RUN echo "#!/usr/bin/perl" | sudo tee /usr/local/bin/enum4linux &&	\
    echo "exec "/opt/enum4linux/enum4linux.pl @ARGV";" | sudo tee -a /usr/local/bin/enum4linux
RUN sudo chmod +x /usr/local/bin/enum4linux

### metasploit       ###
########################
ENV METASPLOIT_DOWNLOAD_URL "https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb"
RUN curl "${METASPLOIT_DOWNLOAD_URL}" > /tmp/msfinstall && chmod 755 /tmp/msfinstall && /tmp/msfinstall

### zsteg            ###
########################
RUN . ${ZPROFILE} && gem install zsteg

### unminimize       ###
########################
RUN yes | sudo unminimize

### pip              ###
########################
RUN curl -L https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py && \
  python3 /tmp/get-pip.py

### hashid           ###
########################
RUN pip install hashid

########################
### COPY             ###
########################

### seclists         ###
########################
COPY --from=git_builder /usr/share/SecLists /usr/share/SecLists

### sqlmap           ###
########################
COPY --from=git_builder /opt/sqlmap-dev /opt/sqlmap-dev
RUN echo 'alias sqlmap="python3 /opt/sqlmap-dev/sqlmap.py"' >> "${ALIAS_FILE}"

### john the ripper  ###
########################
COPY --from=git_builder /opt/john/ /opt/john/
RUN echo 'alias john="/opt/john/run/john"' >> "${ALIAS_FILE}" && \
	sudo echo 'alias zip2john="/opt/john/run/zip2john"' >> "${ALIAS_FILE}"

### searchsploit     ###
########################
COPY --from=git_builder /opt/exploit-database /opt/exploit-database
RUN ln -sf /opt/exploit-database/searchsploit "${HOME_DIR}".local/bin/searchsploit
RUN cp -n /opt/exploit-database/.searchsploit_rc "${HOME_DIR}"

### misc             ###
########################
COPY .zshrc .zshrc
COPY --chmod=0755 bin/docker-entrypoint.sh /home/dev/.local/bin/docker-entrypoint.sh

RUN sudo chown -R dev:dev $HOME_DIR

ENTRYPOINT [ "/bin/zsh", "/home/dev/.local/bin/docker-entrypoint.sh" ]

# Specifyin a login shell since containers will be attached to.
CMD [ "/bin/zsh", "-l" ]
