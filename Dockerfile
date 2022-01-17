FROM ubuntu:20.04 as base
LABEL Name=ubuntu20thm Version=0.0.1
ARG username
ARG passwd
ARG http_proxy
ARG https_proxy
ARG no_proxy

ENV PYTHONDONTWRITEBYTECODE=1
ENV http_proxy ${http_proxy}
ENV https_proxy ${https_proxy}
ENV no_prxy ${no_proxy}
ENV DEBIAN_FRONTEND noninteractive
# ENV HOME /home/${username}

##################################### Caution #####################################
# Change line endings to LR in your editor if you modifying below file in Windows
COPY pkglist requirements.txt install-dependencies.sh configure-git-ssh-clone.sh ./
RUN chmod +x install-dependencies.sh && ./install-dependencies.sh

# Add password to root
RUN echo ${username}:${passwd} | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/\(^Port\)/#\1/' /etc/ssh/sshd_config && echo Port 8080 >> /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN mkdir /var/run/sshd

# configure git clone
RUN chmod +x configure-git-ssh-clone.sh && ./configure-git-ssh-clone.sh

# ENTRYPOINT [ "/usr/sbin/init" ]
CMD ["/usr/sbin/sshd", "-D"]