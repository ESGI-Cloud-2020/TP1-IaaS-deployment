from ubuntu:focal

RUN apt-get update -y && \
  apt-get upgrade -y

# Required to avoid interactive prompt during groff install
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get install -y curl git groff jq unzip vim wget
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

# Terraform vars
ENV TERRAFORM_VERSION=0.13.3

# Terraform install
WORKDIR /usr/bin
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
unzip ./terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
rm -f ./terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Add Terraform autocompletion in BASH
RUN touch ~/.bashrc && \
terraform --install-autocomplete


# Packer vars
ENV PACKER_VERSION=1.6.3

# Packer install
WORKDIR /usr/bin
RUN wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip && \
    unzip ./packer_${PACKER_VERSION}_linux_amd64.zip && \
    rm -f ./packer_${PACKER_VERSION}_linux_amd64.zip

# Add Packer autocompletion in BASH
RUN touch ~/.bashrc && \
    packer -autocomplete-install

