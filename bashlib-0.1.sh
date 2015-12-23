#!/bin/bash
###########################
#
# Small Bash Lib
#
# Author: Cosimo Iaia  <cosimo.iaia@gmail.com>
# Date: 14/04/2013
#
# This file is distribuited under the terms of GNU General Public
# Copyright 2010 Cosimo Iaia
#
#
###########################







NAME=`basename ${0} .sh`
LOGFILE=~/${NAME}.log
TODAY=`date +%d_%m_%y`

#### MAIL CONF ####

mailto='cosimo.iaia@gmail.com'
sendmail=`which sendmail`
subject='[ERROR] ${NAME} on `hostname -f` FAILED!'

##### END MAIL CONF #####


######################### SUPPORT FUNCTIONS ####################################

LOG()
{
        echo -e "\e[33m$*\e[0m" 1>&2
        echo [LOG] [${TODAY}] $* &>>${LOGFILE}
}

ERR()
{
        echo -e "[\e[31mERROR\e[0m]" $* 1>&2
        echo [ERROR] [${TODAY}] $* >>${LOGFILE}
#	send_mail $*
        echo -e "\e[31mFAILED !!!\e[0m" 1>&2
        exit -1;
}

send_mail()
{
cat <<EOF | ${sendmail}
To: ${mailto}
Subject: ${subject}

$*
EOF
}

_varme()
{ 
        printf -v "$1" "%s" "$(cat)"; declare -p "$1";
}

run_safe_SIMPLE()
{
	LOG "[EXEC] $*"
        EXIT_MSG=$( $* 2>&1 )
        if [ $? != 0 ];
        then
                ERR \'${*}\' '--->' $EXIT_MSG
        fi
        echo $EXIT_MSG
}


run_safe()
{
	LOG "[EXEC] $@"
	eval "$( $@ 2> >(_varme ERR_MSG) > >(_varme STD_MSG); <<<"$?" _varme RETVAL; )"
        if [ $RETVAL != 0 ];
        then
                ERR \'${*}\' '--->' $ERR_MSG
        fi
        echo $STD_MSG
}


###################### END SUPPORT FUNCTIONS ####################

