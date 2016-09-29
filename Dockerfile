FROM centos:centos7

MAINTAINER Diego Castro <diego.castro@getupcloud.com>

ENV HOME=/opt/app-root/src \
  PATH=/opt/app-root/src/bin:/opt/app-root/bin:$PATH \
  RUBY_VERSION=2.0 \
  FLUENTD_VERSION=0.12.23 \
  GEM_HOME=/opt/app-root/src

LABEL io.k8s.description="Fluentd container for collecting haproxy router logs" \
  io.k8s.display-name="Fluentd ${FLUENTD_VERSION}" \
  io.openshift.expose-services="5140:udp" \
  io.openshift.tags="logging,fluentd"

RUN rpmkeys --import file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && \
    yum install -y --setopt=tsflags=nodocs \
    gcc-c++ \
    ruby \
    ruby-devel \
    iproute \
    rsyslog \
    gettext \
    libcurl-devel \
    zlib-devel \
    make && \
    yum clean all

RUN mkdir -p ${HOME} && \
    gem install --no-rdoc --no-ri \
      --conservative --minimal-deps \
      fluentd:${FLUENTD_VERSION} \
      fluent-plugin-azurestorage

RUN rm -f /etc/rsyslog.d/listen.conf

ADD fluent.template /etc/fluent/
ADD rsyslog.conf /etc/
ADD run.sh ${HOME}/

WORKDIR ${HOME}
USER 0
CMD ["sh", "run.sh"]