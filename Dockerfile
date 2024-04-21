# Use an Ubuntu base image
FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y curl git apt-transport-https ca-certificates curl software-properties-common

# Add Docker official GPG key
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Add Docker repository
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install Docker
RUN apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io

# Install any additional dependencies needed for your software

# Set up Docker-in-Docker
RUN mkdir -p /var/run/docker.sock

# Install Go
RUN curl -O https://dl.google.com/go/go1.22.2.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.22.2.linux-amd64.tar.gz && \
    rm go1.22.2.linux-amd64.tar.gz

# Set Go environment variables
ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH="/go"

# Check Go version
RUN go version
ENV GO111MODULE=on

# Download module dependencies
# RUN go mod download github.com/distribution/distribution@latest

# Install Python 3.10
RUN apt-get install -y python3.10 python3-pip && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1

# Install Conda
RUN curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /usr/local/miniconda && \
    rm Miniconda3-latest-Linux-x86_64.sh && \
    /usr/local/miniconda/bin/conda init && \
    /usr/local/miniconda/bin/conda install -y conda

# Set environment variables
ENV PATH="/usr/local/miniconda/bin:${PATH}"

# Verify Conda installation
RUN conda --version

# Set up the working directory
WORKDIR /workspace

# Copy files and folders to the container
COPY . .

# Make the script executable
RUN chmod +x scripts/*

# Install Sedge
RUN ./scripts/install-sedge.sh

# Install python libraries
RUN conda env create -f environment.yml

# Start Docker service
CMD systemctl start docker && /bin/bash

# Set conda on the start
CMD conda activate apitest

# Specify the run-sedge.sh as the start script
ENTRYPOINT ["./scripts/run-sedge.sh"]
