FROM centos:7
LABEL Description="Kubernetes Operations (kops) w/ Kubectl & AWS CLI"

ENV GOPATH	/go
ENV PATH	$PATH:$GOPATH/bin

RUN	yum install -y epel-release && \
	yum install -y \
		git \
		go \
		make \
		python2-pip && \
	go get -d k8s.io/kops && \
	cd ${GOPATH}/src/k8s.io/kops/ && \
	git checkout release && \
	make && \
	cd /usr/local/bin && \
	curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
	chmod +x ./kubectl && \
	pip install --upgrade pip && \
	pip install awscli boto3 && \
	ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa -N '' && \
	rm -rf ${GOPATH}/src ${GOPATH}/pkg

CMD ["/bin/bash"]
