# DataStack


GitHub workflows can be used to trigger the Infra Deployment in AWS account.
Modularisation of Terraform code is made for the below reasons:-

Reusability
Organization
Collaboration
Testing/Isolation
Versioning

It contains a bash script called "batch_script.sh" which downloads the files from s3 and then intiates the psql command for data ingestion.

Include are two .tpl files which are basiaclly the userdata which is needed to load up which the VM boots up.

Made use of the Lambda function and integrated it with the s3 for achieving the event invokation inorder to trigger the batch job running int the ec2. The
data(rates.sql) ingestion to the PostgreSQL is achieved using the batch_script.sh running in the EC2. SSM SendCommands are being send by lambda function whenever a new object lands to the s3 bucket, due the event notification trigger the lambda function gets trigger and proceeds with ssm:SendCommand to the EC2 instance, the instance is picked up from the ENVIRONMENT section of lambda. Note:- Can make use of ASG also to do this job instead of a single EC2 instance.

Made use of secrets manager to retrieve DB secrets and other paramaters required, can enable a secret rotation as a security best practice.

Made use of ECR to store images.

Tools used here are terraform,Github Actions for Infra deployment And CICD process.

Made use of GitHub-OIDC for authentication in AWS.


Note to run terraform locally

1. Need the AWS Secret and Access Keys or use an iam role and assume that role.
2. run terraform init --> make use one updates the backend.tf with appropriate s3 bucket name present in their account.
3. terraform plan --var-file=sandbox.tfvars
4. terraform apply --var-file=sandbox.tfvars -auto-approve --> Only if plan seems OK

Below is the curl command result when against the NLB(Network LoadBalancer)

![alt-text](https://github.com/Abhishek010397/DataStack/blob/master/NLB-OP.jpg)
