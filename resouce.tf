resource "aws_iam_role" "dynamodb_read_role" {
 name = "${local.name_prefix}-dynamodb-read-role"


 assume_role_policy = jsonencode({
   Version = "2012-10-17"
   Statement = [
     {
       Action = "sts:AssumeRole"
       Effect = "Allow"
       Sid    = ""
       Principal = {
         Service = "ec2.amazonaws.com"
       }
     },
   ]
 })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role = aws_iam_role.dynamodb_read_role.name
  policy_arn = aws_iam_policy.dynamodb_read_policy.arn
}

resource "aws_iam_instance_profile" "ec2-profile" {
  name = "${local.name_prefix}-ec2-profile"
  role = aws_iam_role.dynamodb_read_role.name
}



data "aws_iam_policy_document" "policy_example" {
 statement {
   effect    = "Allow"
   actions   = ["ec2:Describe*"]
   resources = ["*"]
 }
 statement {
   effect    = "Allow"
   actions   = ["s3:ListBucket"]
   resources = ["*"]
 }
}


resource "aws_iam_policy" "dynamodb_read_policy" {
  name        = "${local.name_prefix}-dynamodb-read"
  description = "Read only access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "VisualEditor0"
        Effect = "Allow"
        Action = [
          "dynamodb:Describe*",
          "dynamodb:Scan",
          "dynamodb:List*",
          "dynamodb:Query"
        ]
        Resource = "arn:aws:dynamodb:ap-southeast-1:259954542255:table/hanna-bookinventory"
      }
    ]
  })
}


