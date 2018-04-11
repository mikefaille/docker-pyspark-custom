#!/bin/bash

# print commands to know where we here
set -x

# Generate host keys
ssh-keygen -A -t rsa
# Generate user keys
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys

# cat <<EOF >>~/.ssh/config
cat <<EOF >>/etc/ssh/ssh_config
host *
     StrictHostKeyChecking no
     UserKnownHostsFile=/dev/null
EOF
Pchmod 600 ~/.ssh/config

/usr/sbin/sshd -e &

# Format a new distributed filesystem:
hdfs namenode -format && \
    #Start the HDFS with the following command, run on the designated NameNode.\
    ${HADOOP_HOME}/sbin/start-dfs.sh && \
    # Start Map-Reduce cluster with the following command, run on the designated JobTracker:
    ${HADOOP_HOME}/sbin/start-yarn.sh && \
    # start jupiter notebook
    jupyter notebook --port=8888 --no-browser --ip=127.0.0.1

# The sbin/start-dfs.sh script also consults the ${HADOOP_CONF_DIR}/slaves file on the NameNode and starts the DataNode daemon on all the listed slaves. By default, HADOOP_CONF_DIR=HADOOP_HOME/etc.
#The sbin/start-yarn.sh script also consults the ${HADOOP_CONF_DIR}/slaves file on the JobTracker and starts the TaskTracker daemon on all the listed slaves.

# jps
# # Initiated by start-dfs.sh
# 5848 Jps
# 5795 SecondaryNameNode
# 5375 NameNode
# 5567 DataNode
# # Initiated by start-yarn.sh
# 5915 ResourceManager
# 6101 NodeManager
