resource "aws_launch_template" "this" {
  name_prefix            = "ltmpt_ubuntu"
  image_id               = "ami-0ceb90f64febd1843"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key.key_name
  user_data              = base64encode(file("./userdata/userdata.sh"))
  vpc_security_group_ids = [data.terraform_remote_state.modulo-vpc.outputs.sg_srv.id]
  update_default_version = true
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }



  # network_interfaces {
  #   associate_public_ip_address = aws_lb_target_group.this
  #   device_index                = 0
  # }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name      = "srv-website"
      ManagedBy = "terraform"
    }
  }
}

resource "aws_key_pair" "key" {
  key_name   = "aws-key-tf"
  public_key = file("./aws-key-tf.pub")
}

resource "aws_autoscaling_group" "this" {
  name                      = "asg_website"
  max_size                  = 2
  min_size                  = 2
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  vpc_zone_identifier = [data.terraform_remote_state.modulo-vpc.outputs.subnet-priv1,
  data.terraform_remote_state.modulo-vpc.outputs.subnet-priv2]
  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  instance_maintenance_policy {
    min_healthy_percentage = 90
    max_healthy_percentage = 120
  }
}

# data "aws_ami" "this" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-*-x86_64-gp2"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "this" {
  autoscaling_group_name = aws_autoscaling_group.this.id
  lb_target_group_arn    = aws_lb_target_group.this.arn
}

resource "aws_lb" "website" {
  name               = "elb-website"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.terraform_remote_state.modulo-vpc.outputs.sg_elb.id]
  subnets = [data.terraform_remote_state.modulo-vpc.outputs.subnet-pub1,
    data.terraform_remote_state.modulo-vpc.outputs.subnet-pub2,
    data.terraform_remote_state.modulo-vpc.outputs.subnet-priv1,
  data.terraform_remote_state.modulo-vpc.outputs.subnet-priv2]

  enable_deletion_protection = false

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.id
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

resource "aws_lb_target_group" "this" {
  name     = "tg-website"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.modulo-vpc.outputs.aws_vpc
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.website.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
