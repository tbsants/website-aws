resource "aws_iam_role" "EC2RoleForSSM" {
  name = "EC2RoleForSSM"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    tag-key = "EC2RoleForSSM"
  }
}

resource "aws_iam_role_policy_attachment" "EC2RoleForSSMPolicy" {
  role       = aws_iam_role.EC2RoleForSSM.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "example_profile" {
  name = "EC2RoleForSSM_profile"
  path = "/" # optional, for organization
  role = aws_iam_role.EC2RoleForSSM.name
}