# https://github.com/hashicorp/terraform-provider-aws/issues/4570
resource "aws_launch_template" "t2s_template" {
  # name_prefix   = "t2_micro_template"
  name = "demo4"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name = aws_key_pair.example_keypair.key_name
  # vpc_security_group_ids = [aws_security_group.server_security_group.id]
  # subnet_id = aws_subnet.subnet_aza.id

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "web-server-"
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    # network_interface_id = aws_network_interface.asg_ec2_eni.id
    security_groups = [aws_security_group.server_security_group.id]
    subnet_id = aws_subnet.subnet_aza.id
  }
}

# resource "aws_network_interface" "asg_ec2_eni" {
#   subnet_id   = aws_subnet.subnet_aza.id
#   security_groups = [aws_security_group.server_security_group.id]
# }

resource "aws_autoscaling_group" "t2s_asg" {
  # availability_zones = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  desired_capacity   = 2
  max_size           = 3
  min_size           = 1
# subnets/azs?
  health_check_type = "ELB"
  vpc_zone_identifier = [aws_subnet.subnet_aza.id, aws_subnet.subnet_azb.id]

  launch_template {
    id      = aws_launch_template.t2s_template.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "asg_lb_attachment" {
  autoscaling_group_name = aws_autoscaling_group.t2s_asg.id
  lb_target_group_arn    = aws_lb_target_group.ec2_target_group.arn
}