#!/bin/bash

# Help                                                                         #
################################################################################
Help()
{
   # Display Help
   echo "This script performs a sanity-check on your environment before deploying the Aqua platform on Amazon EKS clusters."
   echo
   echo "Syntax: scriptTemplate [-h|t|c]"
   echo "options:"
   echo "h     Print this Help menu"
   echo "t     Sanity check to verify pre-requisites. The script will install missing items"
   echo "c     Configure AWS CLI using your AWS account"
}

is_kubectl_installed()
{
    #echo "kubectl called"
    echo "Checking for kubectl binary"
    output=$(kubectl version --short --client)
    status=$?
    if [ $status -eq 0 ];
    then
     printf "\xE2\x9C\x94 kubectl already setup\n" 
    else
        echo "Installing kubectl"
        curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/kubectl
        mkdir -p $HOME/bin && export PATH=$PATH:$HOME/bin
        chmod +x ./kubectl
        cp ./kubectl $HOME/bin/kubectl
        output=$(kubectl version --short --client)
        status=$?
        printf "\xE2\x9C\x94 kubectl installed\n"
    fi
    return $status
}

is_awsiam_installed()
{
    #echo "aws-iam-authenticator called"
    echo "Checking for aws-iam-authenticator"
    output=$(aws-iam-authenticator version)
    status=$?
    if [ $status -eq 0 ];
    then
     printf "\xE2\x9C\x94 aws-iam-authenticator already setup\n" 
    else
        echo "Installing aws-iam-authenticator"
        curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/aws-iam-authenticator
        mkdir -p $HOME/bin && export PATH=$PATH:$HOME/bin
        chmod +x ./aws-iam-authenticator
        cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator
        output=$(aws-iam-authenticator version)
        status=$?
        printf "\xE2\x9C\x94 aws-iam-authenticator installed\n"
    fi
    return $status
}

is_awscli_installed()
{
    #echo "awscli called"
    echo "Checking for aws CLI"
    output=$(aws help)
    status=$?
    if [ $status -eq 0 ];
    then
     printf "\xE2\x9C\x94 aws CLI already setup\n" 
    else
        echo "Installing aws CLI"
        pip install awscli --upgrade --user
        sudo pip install --upgrade pip
        output=$(aws help)
        status=$?
        printf "\xE2\x9C\x94 aws CLI installed\n"
    fi
    return $status
}

is_eksctl_installed()
{
    #echo "eksctl called"
    echo "Checking for eksctl binary"
    output=$(eksctl version)
    status=$?
    if [ $status -eq 0 ];
    then
     printf "\xE2\x9C\x94 eksctl already setup\n" 
    else
        echo "Installing eksctl"
        curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
        mkdir -p $HOME/bin && export PATH=$PATH:$HOME/bin
        mv /tmp/eksctl $HOME/bin
        output=$(eksctl version)
        status=$?
        printf "\xE2\x9C\x94 eksctl installed\n"
    fi
    return $status
}

is_helm_installed()
{
    #echo "helm called"
    echo "Checking for helm"
    output=$(helm version)
    status=$?
    if [ $status -eq 0 ];
    then
        printf "\xE2\x9C\x94 helm already setup\n" 
    else
        echo "Installing helm"
        curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
        chmod 700 get_helm.sh
        ./get_helm.sh
        output=$(helm version)
        status=$?
        printf "\xE2\x9C\x94 helm installed\n"
    fi
    return $status
}

Test()
{
    #echo "Test function called"
    is_kubectl_installed
    is_awscli_installed
    is_awsiam_installed
    is_eksctl_installed
    is_helm_installed
}

Configure()
{
    output=$(stat $HOME/.aws/config)
    status=$?
    if [ $status -eq 0 ];
    then
        printf "\xE2\x9C\x94 AWS account already setup\n"
        echo -n "Do you want to configure a new account?(Y/n) "
        read response
    fi
    if [[ $status -ne 0 || $response == 'Y' ]];
    then
        aws configure
    else
        echo "You are all set!!"
    fi
}

################################################################################
################################################################################
# Main program                                                                 #
################################################################################
################################################################################
################################################################################
# Process the input options. Add options as needed.                            #
################################################################################
# Get the options
while getopts ":htc" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      t)
         Test
         exit;;
      c)
         Configure
         exit;;
     \?) # incorrect option
         echo "Error: Invalid option"
         exit;;
   esac
done

echo "Hello world!"