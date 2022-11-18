FROM ubuntu:focal
LABEL maintainer="@edelauna"

########################
### General Pre-reqs ###
########################
ENV TZ Etc/UTC
RUN apt-get update && apt-get upgrade -y --no-install-recommends && DEBIAN_FRONTEND=noninteractive \
	apt-get install -y --no-install-recommends \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
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

########################
### zsh plugins      ###
########################
RUN git clone https://github.com/zsh-users/zsh-autosuggestions.git /usr/local/share/zsh-autosuggestions &&\
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /usr/local/share/zsh-syntax-highlighting && \
    mkdir -p /usr/local/share/z && curl -fsSL https://raw.githubusercontent.com/rupa/z/master/z.sh \
    -o /usr/local/share/z/z.sh && chmod +x /usr/local/share/z/z.sh && \
    git clone https://github.com/zsh-users/zsh-history-substring-search.git /usr/local/share/zsh-history-substring-search


########################
### user setup       ###
########################
ENV HOME_DIR "/home/dev/" 

RUN useradd -ms /bin/zsh dev && \
    echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER dev
WORKDIR ${HOME_DIR}

COPY .zshrc .zshrc

ENV ZPROFILE="${HOME_DIR}.profile"
ENV ALIAS_FILE="${HOME_DIR}.alias"

########################
### go               ###
########################
ENV GO_DOWNLOAD_TARGET "go1.19.3.linux-amd64.tar.gz"
RUN sudo curl -L https://go.dev/dl/${GO_DOWNLOAD_TARGET} -o /opt/${GO_DOWNLOAD_TARGET}
RUN sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /opt/${GO_DOWNLOAD_TARGET}
RUN echo 'export PATH=$PATH:/usr/local/go/bin"' >> "${ZPROFILE}" && \
	echo 'export PATH="'"${HOME_DIR}"'go/bin:$PATH"' >> "${ZPROFILE}"

########################
### openvpn          ###
########################
ENV DISTRO "focal"
ENV OPENVPN_URL "https://swupdate.openvpn.net/community/openvpn3/repos/openvpn3-${DISTRO}.list"
RUN sudo wget https://swupdate.openvpn.net/repos/openvpn-repo-pkg-key.pub && \
sudo apt-key add openvpn-repo-pkg-key.pub && \
sudo wget -O /etc/apt/sources.list.d/openvpn3.list ${OPENVPN_URL}

########################
### mysql            ###
########################
RUN wget https://repo.mysql.com/mysql-apt-config_0.8.22-1_all.deb && \
	sudo dpkg -i mysql-apt-config_0.8.22-1_all.deb

########################
### fonts            ###
########################
RUN mkdir -p ".fonts" ".local/bin"

RUN curl -L "https://github.com/abertsch/Menlo-for-Powerline/raw/master/Menlo%20for%20Powerline.ttf" \
    -o ".fonts/Menlo for Powerline.ttf" && \
    fc-cache -vf .fonts

########################
### apps             ###
########################
RUN sudo apt-get update && sudo apt-get upgrade -y --no-install-recommends && \
	DEBIAN_FRONTEND=noninteractive sudo apt-get install -y --no-install-recommends \
    autoconf \
    bison \
    build-essential \
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
    nmap \
    openvpn3 \
	pkg-config \
	python3.10 \
    smbclient \
    snmp \
    snmp-mibs-downloader \
	tcpick \
	whois \
	yasm \
    zlib1g-dev  

########################
### rbenv            ###
########################
RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | /bin/zsh
RUN echo 'export PATH="'"${HOME_DIR}"'.rbenv/bin:$PATH"' >> "${ZPROFILE}" && \
    echo 'eval "$(rbenv init -)"' >> "${ZPROFILE}"

RUN git clone https://github.com/rbenv/ruby-build.git && \
    PREFIX=/usr/local sudo ./ruby-build/install.sh

########################
### nvm              ###
########################
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | PROFILE=${ZPROFILE} bash

########################
### Mibs Downloader  ###
########################
RUN sudo download-mibs

########################
### enum4linux       ###
########################
RUN sudo git clone https://github.com/CiscoCXSecurity/enum4linux.git /opt/enum4linux
RUN echo "#!/usr/bin/perl" | sudo tee /usr/local/bin/enum4linux &&	\
    echo "exec "/opt/enum4linux/enum4linux.pl @ARGV";" | sudo tee -a /usr/local/bin/enum4linux
RUN sudo chmod +x /usr/local/bin/enum4linux

########################
### gobuster         ###
########################
RUN /usr/local/go/bin/go install github.com/OJ/gobuster/v3@latest

########################
### seclists         ###
########################
RUN sudo git clone https://github.com/danielmiessler/SecLists.git /usr/share/SecLists

########################
### fuff             ###
########################
RUN /usr/local/go/bin/go install github.com/ffuf/ffuf@latest

########################
### sqlmap           ###
########################
RUN sudo git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git /opt/sqlmap-dev
RUN echo 'alias sqlmap="python3 /opt/sqlmap-dev/sqlmap.py"' >> "${ALIAS_FILE}" 

########################
### john the ripper  ###
########################
RUN sudo git clone https://github.com/openwall/john -b bleeding-jumbo /opt/john
RUN cd /opt/john/src && sudo ./configure && sudo make -s clean && sudo make -sj4
RUN echo 'alias sqlmap="john /opt/john/run/john"' >> "${ALIAS_FILE}" && \
	sudo echo 'alias sqlmap="zip2john /opt/john/run/zip2john"' >> "${ALIAS_FILE}"

########################
### searchsploit     ###
########################
RUN sudo git clone https://gitlab.com/exploit-database/exploitdb.git /opt/exploit-database
RUN ln -sf /opt/exploit-database/searchsploit "${HOME_DIR}".local/bin/searchsploit
RUN cp -n /opt/exploit-database/.searchsploit_rc "${HOME_DIR}"

########################
### chisel           ###
########################
RUN /usr/local/go/bin/go install github.com/jpillora/chisel@latest

########################
### metasploit       ###
########################
ENV METASPLOIT_DOWNLOAD_URL "https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb" 
RUN curl "${METASPLOIT_DOWNLOAD_URL}" > /tmp/msfinstall && chmod 755 /tmp/msfinstall && /tmp/msfinstall

# Specifyin a login shell since containers will be attached to.
CMD [ "/bin/zsh", "-l" ]