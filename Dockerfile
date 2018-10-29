FROM ubuntu:16.04
LABEL authors="Yogit Thakral (yogitnet05@gmail.com)"

#================================================
# Customize sources for apt-get
#================================================
RUN  echo "deb http://archive.ubuntu.com/ubuntu xenial main universe\n" > /etc/apt/sources.list \
  && echo "deb http://archive.ubuntu.com/ubuntu xenial-updates main universe\n" >> /etc/apt/sources.list \
  && echo "deb http://security.ubuntu.com/ubuntu xenial-security main universe\n" >> /etc/apt/sources.list

RUN apt-get -qqy update \
  && apt-get -qqy --no-install-recommends install \
    bzip2 \
    ca-certificates \
    tzdata \
    sudo \
    unzip \
    wget   


#========================================
# Add normal user with passwordless sudo
#========================================
RUN useradd supersquid \
         --shell /bin/bash  \
         --create-home \
  && usermod -a -G sudo supersquid \
  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
  && echo 'supersquid:secret' | chpasswd

USER supersquid


EXPOSE 3128

#COPY entry_point.sh \
#    /opt/bin/

RUN sudo apt-get update && sudo apt-get install squid -y 
RUN sudo sed -i 's/http_access deny all/http_access allow all/g' /etc/squid/squid.conf
RUN sudo service squid restart

ENTRYPOINT [ "/bin/bash", "-c", "sudo service squid restart && tail -f /dev/null" ]
