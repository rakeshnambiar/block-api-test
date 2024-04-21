# Use an Ubuntu base image
FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y curl git

# Install Go
RUN curl -O https://dl.google.com/go/go1.16.12.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.16.12.linux-amd64.tar.gz && \
    rm go1.16.12.linux-amd64.tar.gz

# Set Go environment variables
ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH="/go"
RUN go version
RUN go mod download github.com/distribution/distribution/v3

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

# Specify the run-sedge.sh as the start script
ENTRYPOINT ["./scripts/run-sedge.sh"]
