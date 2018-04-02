FROM centos:7

ENV JAVA_MAJOR_VERSION=8 \
    SPARK_VERSION=2.3.0 \
    HADOOP_VERSION=2.7 \
    PYTHON_VERSION=36 \
    PYSPARK_PYTHON=python${PYTHON_VERSION}

ENV LC_ALL=en_CA.utf8 \
    LANG=en_CA.utf8

# /dev/urandom is used as random source, which is prefectly safe
# according to http://www.2uo.de/myths-about-urandom/
RUN rpm --import https://www.centos.org/keys/RPM-GPG-KEY-CentOS-7
RUN set -ex && \
    yum install -y --setopt=tsflags=nodocs \
        java-1.${JAVA_MAJOR_VERSION}.0-openjdk  \
        java-1.${JAVA_MAJOR_VERSION}.0-openjdk-devel \
        curl && \
    yum clean all && rm -rf /var/cache/yum \
    echo "securerandom.source=file:/dev/urandom" >> /usr/lib/jvm/java/jre/lib/security/java.security

ENV JAVA_HOME /etc/alternatives/jre

ADD https://github.com/krallin/tini/releases/download/v0.17.0/tini-amd64 /usr/bin/tini
RUN chmod +x /usr/bin/tini

RUN curl https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz > /opt/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz && \
    mkdir /opt/spark && \
    tar xvfp /opt/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz -C /opt/spark --strip-components=1 && \
    rm /opt/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz && \
    mkdir /opt/spark/work-dir

WORKDIR /opt/spark/work-dir

ENV SPARK_HOME /opt/spark

RUN yum -y install epel-release && \
    yum -y install python-pip && \
    yum install -y centos-release-scl-rh && \
    yum-config-manager --enable centos-sclo-rh-testing && \
    INSTALL_PKGS="rh-python${PYTHON_VERSION} rh-python${PYTHON_VERSION}-python-pip" && \
    yum install -y --setopt=tsflags=nodocs --enablerepo=centosplus $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && rm -rf /var/cache/yum

# Permanently enable python Software Collection
# vars taken from : source scl_source enable rh-python36
ENV PATH=$SPARK_HOME:/opt/rh/rh-python${PYTHON_VERSION}/root/usr/bin${PATH:+:${PATH}}
ENV LD_LIBRARY_PATH=/opt/rh/rh-python${PYTHON_VERSION}/root/usr/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
ENV MANPATH=/opt/rh/rh-python${PYTHON_VERSION}/root/usr/share/man:$MANPATH
ENV PKG_CONFIG_PATH=/opt/rh/rh-python${PYTHON_VERSION}/root/usr/lib64/pkgconfig${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}
ENV XDG_DATA_DIRS="/opt/rh/rh-python${PYTHON_VERSION}/root/usr/share:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"

# Configure pyspark
ENV PYTHONPATH=$SPARK_HOME/python:$PYTHONPATH
# Set jupyter path
ENV JUPYTER_DATA_DIR=/usr/local/share/jupyter

# requirements for pytrade and flayers
RUN yum install -y --setopt=tsflags=nodocs blas atlas gcc-gfortran swig gcc-c++ mercurial && \
    yum clean all && rm -rf /var/cache/yum

COPY requirements.txt /opt/spark/

# RUN # pip install --no-cache-dir pipenv && \
RUN  pip install --no-cache-dir -r /opt/spark/requirements.txt && \
     jupyter toree install --spark_home=${SPARK_HOME} --interpreters=Scala,PySpark,SQL

EXPOSE 8888

# https://jupyter-notebook.readthedocs.io/en/latest/public_server.html#docker-cmd
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0"]
