HADOOP_NN_IP="192.168.0.141"
HADOOP_NN_HOST="nn.hadoop.dev"

HADOOP_RM_IP="192.168.0.142"
HADOOP_RM_HOST="rm.hadoop.dev"

#HADOOP_JHS_IP="192.168.0.141"
HADOOP_JHS_HOST="jh.hadoop.dev"

# There could be multiple data nodes 
HADOOP_DN1_IP="192.168.0.143"
HADOOP_DN1_HOST="dn1.hadoop.dev"

# Add all data nodes to file "slaves"
HADOOP_HOST_LIST_SCRIPT_FOLDER=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )
> "${HADOOP_HOST_LIST_SCRIPT_FOLDER}/conf/slaves"
echo ${HADOOP_DN1_HOST} >> "${HADOOP_HOST_LIST_SCRIPT_FOLDER}/conf/slaves"
