FROM centos:7
MAINTAINER charles.walker.37@gmail.com

#RUN yum -y install https://centos7.iuscommunity.org/ius-release.rpm
RUN yum -y update
RUN yum -y install yum-utils
RUN yum -y groupinstall development
RUN yum -y install https://centos7.iuscommunity.org/ius-release.rpm
RUN yum -y install python36u
RUN yum -y install python36u-pip
RUN yum -y install python36u-devel

#GCP python module
RUN python3.6 -m pip install google-api-python-client google-auth google-auth-httplib2
#AWS python module
RUN python3.6 -m pip install boto3
#Flask for web server (REST API)
RUN python3.6 -m pip install flask
#for unit test
RUN python3.6 -m pip install mock
#OTHER
RUN python3.6 -m pip install jsonpickle requests
#Test YAML
RUN python3.6 -m pip install pyyaml

################################################################
#install gcloud
RUN yum -y install curl which
RUN curl -sSL https://sdk.cloud.google.com | bash
ENV PATH $PATH:/root/google-cloud-sdk/bin
#install kube
RUN gcloud components install kubectl --quiet
################################################################

ADD main.py /code/main.py

EXPOSE 8077

WORKDIR /code
ENTRYPOINT [ "python3.6", "main.py" ]