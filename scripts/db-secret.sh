aws secretsmanager create-secret \
    --name rdsmysql2 \
    --secret-string '{"username":"DBUser1";"password":"soktoll1723akldja;lebndaf"}' \
    --description "RDS MySQL password for Terraform"

#Verify the Secret:
aws secretsmanager get-secret-value --secret-id rdsmysql2


###################################
#!/bin/bash

# Variables
SECRET_NAME="rdsmysql2"
SECRET_VALUE='{"password":"soktoll1723akldja;lebndaf"}'
AWS_REGION="us-east-2"

# Create the secret
aws secretsmanager create-secret \
    --name "$SECRET_NAME" \
    --secret-string "$SECRET_VALUE" \
    --region "$AWS_REGION"

echo "Secret '$SECRET_NAME' created successfully."



### Save the file with the name create_secret.ps1
### On powershell...
# Variables
$SECRET_NAME = "rdsmysql2"
$SECRET_VALUE = '{"password":"=soktoll1723akldja;lebndaf"}'
$AWS_REGION = "us-east-2"

# Create the secret
aws secretsmanager create-secret `
    --name $SECRET_NAME `
    --secret-string $SECRET_VALUE `
    --region $AWS_REGION

Write-Host "Secret '$SECRET_NAME' created successfully."


Set-ExecutionPolicy Unrestricted -Scope Process
.\db_secret.ps1
aws secretsmanager list-secrets --region us-east-2
##############################################################
## Rotate the secret every 30 days
aws secretsmanager rotate-secret --secret-id MyDatabaseSecret `
    --rotation-lambda-arn arn:aws:lambda:us-east-2:123456789012:function:MySecretRotationFunction `
    --rotation-rules AutomaticallyAfterDays=30


# mysql -h <rds-endpoint> -P 3306 -u <master-username> -p

sudo dnf update -y
sudo dnf install -y https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
sudo dnf install -y mysql-community-client --nogpgcheck
mysql -h <rds-endpoint> -P 3306 -u <master-username> -p