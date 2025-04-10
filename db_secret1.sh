#!/bin/bash

# Variables
SECRET_NAME="rdsmysql100"
SECRET_VALUE='{"username":"Denis","password":"ThisislasttryoutforDenis"}'
AWS_REGION="us-east-2"

# Create the secret
aws secretsmanager create-secret \
    --name "$SECRET_NAME" \
    --secret-string "$SECRET_VALUE" \
    --region "$AWS_REGION"\
    --description "RDS MySQL password for Terraform"
echo "Secret '$SECRET_NAME' created successfully."

