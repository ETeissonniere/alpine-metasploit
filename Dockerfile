FROM alpine:latest

MAINTAINER DeveloppSoft <developpsoft@gmail.com>

# Install deps
RUN apk --update add alpine-sdk postgresql postgresql-dev ruby ruby-dev ruby-bigdecimal ruby-irb ruby-rdoc ruby-bundler libpcap-dev git nasm nmap libffi-dev sqlite-dev ncurses-dev ncurses
RUN rm -f /var/cache/apk/*

ADD ./metasploit-framework /opt/metasploit
WORKDIR /opt/metasploit

# Install deps
RUN bundle install

# Add tools to $PATH
RUN for i in `ls /opt/metasploit/tools/*/*`; do ln -s $i /usr/local/bin/; done
RUN ln -s /opt/metasploit/msf* /usr/local/bin

# Install PosgreSQL
ADD ./scripts/db.sql /tmp/

WORKDIR /var/lib/postgresql/DB
RUN chown -R postgres:postgres /var/lib/postgresql

USER postgres

RUN pg_ctl -D ./ initdb
RUN pg_ctl -D ./ -w start && psql -f /tmp/db.sql && pg_ctl -D ./ -w stop

USER root
WORKDIR /opt/metasploit

# DB config
ADD ./conf/database.yml /opt/metasploit/config/

# settings and custom scripts folder
VOLUME /root/.msf4/
VOLUME /tmp/data/

ADD ./scripts/start.sh /start.sh
RUN chmod +x /start.sh

CMD /start.sh
