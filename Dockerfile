FROM local:utopic
MAINTAINER Pradipta Kumar Banerjee <pradipta.banerjee@gmail.com>
RUN apt-get update
RUN apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-client \
mysql-server apache2 libapache2-mod-php5 pwgen python-setuptools vim-tiny \
php5-mysql php5-ldap openssh-server apt-utils

#User config
RUN echo 'root:root123' | chpasswd
RUN adduser vagrant
RUN echo 'vagrant:vagrant' | chpasswd

#SSH configuration
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' \
    /etc/ssh/sshd_config
ADD key/vagrant.pub /home/vagrant/.ssh/authorized_keys
RUN chown -R vagrant:vagrant /home/vagrant/
RUN chmod 700 /home/vagrant/.ssh/
RUN chmod 600 /home/vagrant/.ssh/authorized_keys
RUN mkdir -p /var/run/sshd

RUN easy_install supervisor
ADD ./scripts/start.sh /start.sh
ADD ./scripts/foreground.sh /etc/apache2/foreground.sh
ADD ./configs/supervisord.conf /etc/supervisord.conf
ADD ./configs/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN rm -rf /var/www/
ADD http://wordpress.org/latest.tar.gz /wordpress.tar.gz
RUN tar xvzf /wordpress.tar.gz
RUN mv /wordpress /var/www/
RUN chown -R www-data:www-data /var/www/
RUN chmod 755 /start.sh
RUN chmod 755 /etc/apache2/foreground.sh
RUN mkdir -p /var/log/supervisor/
EXPOSE 80 22
CMD ["/bin/bash", "/start.sh"]
