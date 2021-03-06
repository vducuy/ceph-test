#!/bin/bash

#	Usage:
#		./iperf_test.sh <server host> <window size>

SERVER_NODE=$1
MTU=$2

NBYTES=2G # Number of bytes
OSEC=5 #Omit 5 first sconds

#MIN_MSS=$(sysctl net.ipv4.route.min_adv_mss | awk '{print $3}')
#echo "MIN_MSS=${MIN_MSS}"
#if [ "$MSS" = "" ] ; then
#	MSS=$MTU
#fi
#

WSIZE=4M

#if [ "$WSIZE" = "" ] ; then
#	WSIZE=4M
#fi

TCP_IP_HDR=52
#MSS =( MTU - 20 -20 - 12)

MSS=$(echo "${MTU} - ${TCP_IP_HDR}" | bc)

echo "MTU=${MTU} , MSS=${MSS}"

rm -rf result/iperf

NOW=`date +%y%m%d-%H%M%S`                                                                                                         SESSION_LOG="${NOW}" 

LOG_DIR=result/iperf/${SESSION_LOG}

mkdir -p ${LOG_DIR}

#Get iperf Default setting
#log_file=${LOG_DIR}/iperf-${SERVER_NODE}-Mdefault-wdefault-n${NBYTES}.log
#echo $log_file
#iperf3 -c ${SERVER_NODE} -f k  -n ${NBYTES} > ${log_file}


#MTU	MACFrame	MSS	
#512	530		460	
#1024	1042		972	
#1500	1518		1448	
#3000	3018		2948	
#6000	6018		5948	
#9000	9018		8948	


# Get data by MSS
#for mss in ${MIN_MSS} 460 972 1448 2948 5948  
#do
	log_file=${LOG_DIR}/iperf-${SERVER_NODE}-M${MSS}-w${WSIZE}-n${NBYTES}.log
	echo $log_file
	echo "iperf3 -c ${SERVER_NODE} -f k -O ${OSEC} -M ${MSS} -w ${WSIZE} -n ${NBYTES} > ${log_file}"
	iperf3 -c ${SERVER_NODE} -f k -O ${OSEC} -M ${MSS} -w ${WSIZE} -n ${NBYTES} > ${log_file}
	sleep 5
#done

# Get data by Windows Size
#for wsize in 512 1M 2M 4M 
#do
	#echo "iperf3 -c ${SERVER_NODE} -f m -w $wsize -n ${NBYTES}"	
#	log_file=${LOG_DIR}/iperf-${SERVER_NODE}-Mdefault-w$wsize-n${NBYTES}.log
#	echo $log_file
#	iperf3 -c ${SERVER_NODE} -f k -O ${OSEC} -w $wsize -n ${NBYTES} > ${log_file} 
#	sleep 5
#done

# Get data by
#for mss in ${MIN_MSS} 1460 2960 8960 
#do
#	echo "iperf3 -c ${SERVER_NODE} -f m -M $mss -w ${WSIZE} -n ${NBYTES}"
#	iperf3 -c ${SERVER_NODE} -f m -M $mss -w ${WSIZE} -n ${NBYTES} > ${LOG_DIR}/iperf-${SERVER_NODE}-${mss}-w${WSIZE}-n${NBYTES}.log
#	sleep 5
#done

#-------------------------------
tar cvzf iperf-${SERVER_NODE}-${SESSION_LOG}.tar.gz ${LOG_DIR}
