FROM alpine:3

# Arguments
ARG TERRAFORM_VERSION="0.12.17"

# Re-usable environment variables 
ENV TMP_DIR="/tmp"
ENV TERRAFORM_DIR="/opt/terraform"

WORKDIR ${TMP_DIR}

# Install Terraform
RUN wget -O terraform.zip https://releases.hashicorp.com/terraform/0.12.17/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN unzip terraform.zip
RUN mkdir ${TERRAFORM_DIR}
RUN cp terraform ${TERRAFORM_DIR}/.

# Ready for run
WORKDIR /
CMD sh