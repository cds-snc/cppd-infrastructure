FROM mcr.microsoft.com/azure-cli:2.0.77

# --- Arguments ---
ARG TERRAFORM_VERSION="0.12.17"

# --- Re-usable environment variables ---
ENV TMP_DIR="/tmp"
ENV TERRAFORM_DIR="/opt/terraform"

# --- Install Terraform ---
WORKDIR ${TMP_DIR}
RUN wget -O terraform.zip https://releases.hashicorp.com/terraform/0.12.17/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN unzip terraform.zip
RUN mkdir ${TERRAFORM_DIR}
RUN mv terraform ${TERRAFORM_DIR}/.
RUN ln -s ${TERRAFORM_DIR}/terraform /usr/local/bin/terraform
RUN rm -rf ${TMP_DIR}/*
WORKDIR /

# Ready for run
CMD bash