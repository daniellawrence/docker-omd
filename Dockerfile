## -*- docker-image-name: omd" -*-

FROM ubuntu:14.04
RUN echo 'Acquire::http::Proxy "http://192.168.1.100:3142";' > /etc/apt/apt.conf.d/proxy 
RUN apt-get update || true

RUN apt-get install -y supervisor wget
RUN wget http://files.omdistro.org/releases/debian_ubuntu/omd-1.20.trusty.amd64.deb
RUN dpkg -i omd-1.20.trusty.amd64.deb || true
RUN apt-get install -y -f
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Install and enable the check-mk-agent
RUN apt-get install -y check-mk-agent
RUN sed -i 's/disable        = yes/disable = no/' /etc/xinetd.d/check_mk

# Create a site, the build fails as its trying to use tmpfs
RUN /usr/bin/omd create master || true
RUN /usr/bin/omd config master set APACHE_TCP_ADDR 0.0.0.0

# Add a custom check, just like this...
ADD example_custom_check.sh /usr/lib/check_mk_agent/local/filecount 
RUN chmod a+x /usr/lib/check_mk_agent/local/filecount

# Allow mk_livestatus queries from remote
ADD mk_livestatus_xinetd /etc/xinetd.d/mk_livestatus



EXPOSE 5000

CMD /usr/bin/supervisord
