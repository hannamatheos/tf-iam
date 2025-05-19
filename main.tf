
locals {
  name_prefix = "hanna"
}

resource "aws_dynamodb_table" "bookinventory" {
  name         = "${local.name_prefix}-bookinventory"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ISBN"
  range_key = "Genre"

  attribute {
    name = "ISBN"
    type = "S"
  }

  attribute {
    name = "Genre"
    type = "S"
  }

    tags = {
    Name        = "Book Inventory"
 
  }
}

data "aws_dynamodb_table" "bookinventory" {
  name = aws_dynamodb_table.bookinventory.name
}


resource "aws_instance" "dynamo_ec2" {
  ami                         = "ami-0e8ebb0ab254bb563" # find the AMI ID of Amazon Linux 2023  
  instance_type               = "t2.micro"
  #subnet_id                   = "subnet-0a61b179394ae66c8"  #Public Subnet ID, e.g. subnet-xxxxxxxxxxx
  associate_public_ip_address = true
  #key_name                    = "hanna-key-pair" #Change to your keyname, e.g. jazeel-key-pair
 # vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  iam_instance_profile = aws_iam_instance_profile.ec2-profile.name 

  tags = {
    Name = "${local.name_prefix}-ec2-dynamodb"    #Prefix your own name, e.g. jazeel-ec2
  }
}




