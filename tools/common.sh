#!/bin/bash

## This script defines common functions used by other scripts

print_key_value()
{
	padlength=$3
	green=$(tput setaf 2)
	normal=$(tput sgr0)
	key="$1"
	value="$2"

	printf "${green}"
	pad=$(printf '%0.1s' "-"{1..100})
	if [ -z $padlength ]
	then
		padlength=60
	fi

	printf '\e[32m%s' "$key"
	printf '%*.*s' 0 $((padlength - ${#key} - ${#value} )) "$pad"
	printf '%s\n' "$value"
	printf "${normal}"
}

repeat_char()
{
	char=$1
	length=$2

	i=1
    while [ "$i" -le "$length" ]; do
      echo -n "-"
      i=$(($i + 1))
    done
}

# Pad a string with specified length
# $1:		The string to be pad
# $2:		The padding char
# $3:		Total length 
# $4:		Lenth of left padding
pad_string()
{
	target_string="$1"
	padding_char="$2"
	total_length=$3
	
	if [ "x$total_length" == "x" ]
	then
		total_length=100
	fi
	target_string_length=${#target_string}

	padding_left=$4
	if [ "x$padding_left" == "x" ]
	then
		padding_left=$((($total_length - ${target_string_length})/2))
	fi	
	padding_right=$(($total_length - ${target_string_length} - ${padding_left}))
	
	padding_left_string=$(repeat_char "${padding_char}" $padding_left)	
	padding_right_string=$(repeat_char "${padding_char}" $padding_right)	
	echo "${padding_left_string}${target_string}${padding_right_string}"

}

show_progress()
{
	length=$2
    if [ "x$length" == "x" ]
    then
        length=100
    fi
	print_key_value "INFO:" "$1" $length

}


show_progress()
{
	progress=$(pad_string "$1" "-" 100 2)
	echo -e "\e[32m${progress}\e[0m"
    sleep 2
}

debug()
{
	if [ "x${DEBUG}" == "xy" ]
	then
		echo "$1"
	fi
}

show_error()
{
	echo -e "\e[31m$1\e[0m"
    sleep 3
}

pushd()
{
	command pushd "$@" > /dev/null
}

popd()
{
	command popd "$@" > /dev/null
}

is_centos7()
{
	cat /etc/redhat-release | grep 7.*
	if [ $?=0 ]
	then
		return 1
	else
		return 0
	fi
}

# Extract major.minor.revison from a string
# $1:       A string which contains version info
# 
# Usage sample:
#   VERSION=get_version "$(cat /etc/redhat-release)"
#
# Note: this function only get the first major.minor.revision of the version
#       so the following call only returns 3.4.6
#		get_version "My software 3.4.5.6 with build 3.4.5.6-123"
get_version()
{
    local matches=$(echo "$1" | egrep -m 1 -o "[0-9]{1,2}\.[0-9]{1,2}(\.[0-9]{1,6}[^\.-]?)?")            	
	local match_arr=($(echo $matches))
	echo ${match_arr[0]}	
}

# Convert major.minor.revison to a integer number
# $1: 		string in major.minor.revison format, where revision is optional
#
# Usage sample: 
#	convert_version_to_number 3.4.5      -->returns 30405
#   convert_version_to_number 3.21.8     -->returns 32108
convert_version_to_number()
{	
	local arr=($(echo $1 | tr "." " "))
	local major=${arr[0]}
	local minor=${arr[1]}
	local revison=${arr[2]}
	
	
	if [ $minor -lt 10 ]
	then
		minor=$(echo "0$minor")
	fi
	
	if [ ! -z $revison ] && [ $revison -lt 10 ]
	then
		revison=$(echo "0$revison")
	fi
	
	echo "$major$minor$revison"
}

# Function to append folder to PATH vairable by appending the setting in ~/.bashrc
# $1:		path to be append
# Usage sample:
#   append_to_path() "/usr/local/nginx/sbin"
# this will append a line "export PATH=$PATH:/usr/local/nginx/sbin" to ~/.bashrc
append_to_path()
{
	if [[ ! "$PATH:" =~ "$2:" ]]
	then
		 echo "export PATH=\$PATH:$2" >> ~/.bashrc
	fi
}

# Function to append text to file if it does not exist in file yet
# $1: 		path of the file to be appended
# $2:		text to be appended
# Usage sample:
#   append_to_file_once() /etc/hosts "namenode.hadoop.local	192.168.0.10"
append_to_file_once()
{
	if [[ ! "$(cat $1)" =~ "$2" ]]
	then
		echo "$2" | sudo tee -a "$1" > /dev/null
	fi
}

# Setup /etc/hosts 
# S1:		the host setting line which contains ip to hostname mapping
# Usage sample:
#   setup_host 192.168.0.3	namenode.hadoop.local resourcemanager.hadoop.local 
setup_host()
{
	IP_ADDRESS=$1
	sudo sed -i "/${IP_ADDRESS}/d" /etc/hosts
	
	#IP_ADDRESS=$(echo "$1" | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')
	#HOST_NAME=${IP_HOST_MAPPING:${#IP_ADDRESS}}
	echo "--Setup host mapping for IP: $1 ${*:2}" 
	echo "${@}" | sudo tee -a /etc/hosts > /dev/null
}

# Function to get installation option(s) from user input, and set the value to the corresponding environment variable
# $1:            variable name to be configured
# $2:            valid option value seperated by "|"
# S3:            prompt message
# $4:            default value
# $5:            timeout 
# Usage sample:
#   get_install_option "IS_DEV_ENV" "yes|y|no|n" "Is this dev environment? (yes(y)|no(n))"
get_install_option()
{
	local option_name=$1
	local configured_value=`printenv $1`
    local timeout=90000
    local default_value=""
    local param_count=$#
    
    if [ ${param_count} -gt 3 ]
    then
        default_value=$4
    fi

    if [ ${param_count} -gt 4 ]
    then
        timeout=$5
    fi

	# if the value is configured, return directly
	if [ ! -z $configured_value ]
	then
		 return 0
	fi

	while :
	do
		echo -e $3

		read -t ${timeout} option_value
        if [[ "x${option_value}" == "x" ]]
        then
            echo "User does not provide value, use default ${default_value}"
            option_value="${default_value}"
        fi

		eval ${option_name}="${option_value}"
		export ${option_name}

		validate_variable $1 $2 "required"
		if [ $? = 0 ]
		then
			break
		fi
	done
}

# Check whether the specified environment variable is valid:
# $1: variable name
# $2: valid values seperated by "|"
# S3: "optional" or "required" which indicates whether the configure value is optional or required
#
# Usage example: 
#	 validate_option "IS_DEV_ENV" "yes|y|no|n" "required"
#	 If IS_DEV_ENV is not set or its value is one of yes|y|no|n, an error message is printed and a non 0 value is returned
validate_variable()
{
	local is_valid=
	local configured_value=`printenv $1`

	if [ -z $configured_value ]
	then
		if [[ $3 = "optional" ]]
		then
			return 0
		else
			show_error "Error: a value for $1 is required but not provided."
			return 1
		fi
	fi
	
	for valid_value in $(echo $2 | tr "|" "\n")
	do
		if [[ $valid_value = $configured_value ]]
		then
			is_valid=true
			break
		fi
	done

	if [ -z $is_valid ]
	then
		show_error "Error: $configured_value is not a valid value for $1"
		return 2
	fi
}
