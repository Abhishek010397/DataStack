resource "aws_ecr_repository" "app_repo" {
  name = var.ecr_repo_name
}

data "aws_iam_policy_document" "public_pull_policy" {
  statement {
    sid    = "AllowPublicPull"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy"
    ]
  }
}

resource "aws_ecr_repository_policy" "foopolicy" {
  repository = aws_ecr_repository.app_repo.name
  policy     = data.aws_iam_policy_document.public_pull_policy.json
}

resource "aws_ecr_lifecycle_policy" "apprepo_policy" {
  repository = aws_ecr_repository.app_repo.name

  policy = jsonencode({
    rules = [
      {
        rulePriority      = 1
        description       = "Expire images older than 7 days"
        selection         = {
          tagStatus       = "untagged"
          countType       = "sinceImagePushed"
          countUnit       = "days"
          countNumber     = 7
        }
        action              = {
          type            = "expire"
        }
      }
    ]
  })
}

