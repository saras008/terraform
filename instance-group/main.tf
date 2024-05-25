resource "aws_launch_configuration" "basic" {
  image_id = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.instance.id]

  user_data = <<-EOF

              #!/bin/bash
              echo "hello world" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

}

resource "aws_autoscaling_group" "basic" {
    launch_configuration = aws_launch_configuration.basic.name
    min_size = 2
    max_size = 10
    tag {
      key = "Name"
      value = "Terraform-asg-basic"
      propagate_at_launch = true
    }

# If don't set lifecycle to true, the ECS will replace it, delete the EC2 first(Downtime) & create EC2 on again
# Required when using a launch configuration with an auto scaling group.
lifecycle {
  create_before_destroy = true
}
  
}