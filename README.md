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

Made use of the Lambda function and integrated it with the s3 for achieving the event invokation inorder to trigger the batch job running int the ec2.

Made use of secrets manager to retrieve DB secrets and other paramaters required, can enable a secret rotation as a security best practice.

Made use of ECR to store images.

Tools used here are terraform,Github Actions for Infra deployment And CICD process.

Made use of GitHub-OIDC for authentication in AWS.
