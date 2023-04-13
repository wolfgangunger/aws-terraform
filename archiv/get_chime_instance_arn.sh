#!/usr/bin/env bash

set -ex 

environment=$1
mode=$2

if [ "$mode" == "instance" ];
then
    aws chime list-app-instances | jq -r '.AppInstances[] | select(.Name == "'$environment'")'
fi

if [ "$mode" == "user" ];
then
    instance_arn=$(aws chime list-app-instances | jq -r '.AppInstances[] | select(.Name == "'$environment'") | .AppInstanceArn')
    aws chime list-app-instance-users --app-instance-arn "$instance_arn" | jq -r '.AppInstanceUsers[] | select(.Name == "'$environment'-admin-user")'
fi
