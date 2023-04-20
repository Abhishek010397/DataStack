##ASG IAM
data "aws_iam_policy_document" "asg_instance_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "asg_instance_policy_document" {
  statement {
    sid     = "ECRPullPolicy"
    effect  = "Allow"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:DescribeImages",
      "ecr:ListImages" 
    ]
    resources = [
      "arn:aws:ecr:*:${var.aws_account_id}:repository/*"
    ]
  }
  statement {
    sid     = "GetAuthorisationToken"
    effect  = "Allow"
    actions = [
      "ecr:DescribePullThroughCacheRules",
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }
  statement {
    sid = "AccessS3BucketPolicy"

    actions = [
        "s3:GetObjectAcl",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:GetObjectVersion"
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}/*",
      "arn:aws:s3:::${var.s3_bucket_name}",
    ]
  }
  statement {
    sid     = "GetSecretValue"
    effect  = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = [
      var.secret_id
    ]
  }
  statement {
    sid     = "ListSecrets"
    effect  =   "Allow"
    actions = [
      "secretsmanager:ListSecrets"      
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "asg_instance_policy" {
  name        = var.asg_instance_policy_name
  description = "S3SecretsManagerPolicy"
  policy      = data.aws_iam_policy_document.asg_instance_policy_document.json
  tags        = var.tags
}

resource "aws_iam_role" "asg_instance_role" {
  name               = var.asg_instance_role_name
  assume_role_policy = data.aws_iam_policy_document.asg_instance_role_policy.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "asg_instance_ssm_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.asg_instance_role.name
}

resource "aws_iam_role_policy_attachment" "asg_instance_ssm_attach01" {
  role       = aws_iam_role.asg_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"
}

resource "aws_iam_role_policy_attachment" "asg_instance_ssm_attach02" {
  role       = aws_iam_role.asg_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_role_policy_attachment" "asg_instance_profile_role_attach" {
  role       = aws_iam_role.asg_instance_role.name
  policy_arn = aws_iam_policy.asg_instance_policy.arn
}

resource "aws_iam_instance_profile" "asg_instance_profile_role" {
  name = var.asg_instance_profile_role_name
  role = aws_iam_role.asg_instance_role.name
}

##LAMBDA IAM
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = var.lambda_role_name
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}


data "aws_iam_policy_document" "lambda_policy_document" {
  statement {
    sid     = "CLoudWatchPermissions"
    effect  = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:${var.region}:${var.aws_account_id}:*"]
  }
  statement {
    sid     = "S3Permissions"
    effect  = "Allow"
    actions = [
      "s3:GetObjectAcl",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:GetObjectVersion" 
    ]
    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}",
      "arn:aws:s3:::${var.s3_bucket_name}/*",
    ]
  }
  statement {
    sid     = "CreateNetworkInterface"
    effect  = "Allow"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeInstances"
    ]
    resources = ["*"]
  }
  statement {
    sid     = "RunSSMCommand"
    effect  = "Allow"
    actions = [
      "ssm:SendCommand"
    ]
    resources = ["*"]
  }
  statement {
    sid     = "ListSystemsManager"
    effect  = "Allow"
    actions =  [
      "ssm:Describe*",
      "ssm:List*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name        = var.lambda_policy_name
  description = "LambdaExecutionPolicy"
  policy      = data.aws_iam_policy_document.lambda_policy_document.json
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy_attach" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

##BATCH INSTANCE IAM
data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "s3_bucket_access_policy" {
  statement {
    sid = "AccessS3BucketPolicy"

    actions = [
        "s3:GetObjectAcl",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:GetObjectVersion"
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}/*",
      "arn:aws:s3:::${var.s3_bucket_name}",
    ]
  }
  statement {
    sid     = "GetSecretValue"
    effect  = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = [
      var.secret_id
    ]
  }
  statement {
    sid     = "ListSecrets"
    effect  =   "Allow"
    actions = [
      "secretsmanager:ListSecrets"      
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "instance_role" {
  name               = var.instance_role_name
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
  tags               = var.tags
}

resource "aws_iam_policy" "instance_policy" {
  name        = var.iam_policy_name
  description = "S3AccessPolicy"
  policy      = data.aws_iam_policy_document.s3_bucket_access_policy.json
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "instance_role_policy_attach" {
  role       = aws_iam_role.instance_role.name
  policy_arn = aws_iam_policy.instance_policy.arn
}

resource "aws_iam_role_policy_attachment" "instance_role_ssm_policy_attach" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "instance_role_ssm_policy_attach01" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_role_policy_attachment" "instance_role_ssm_policy_attach02" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"
}

resource "aws_iam_instance_profile" "instance_profile_role" {
  name = var.instance_profile_role_name
  role = aws_iam_role.instance_role.name
}
