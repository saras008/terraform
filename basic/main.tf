resource "aws_instance" "basic" {
  //create ECS
  ami           = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"
  user_data     = <<-EOF
  #!/bin/bash
  echo "Hello, World" > index.html
  nohup busybox httpd -f -p 8080 &
  EOF

  /* The user_data_replace_on_change parameter is set to true,
 so that when you change the user_data parameter and run apply, 
Terraform will terminate the original instance and launch a totally new one.
*/
  user_data_replace_on_change = true

  tags = {
    "Name" = "terraform basic"
  }
}

//create security group for basic instance

resource "aws_security_group" "basic-sg" {
  name = "terraform basic security group"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

output "PublicIP" {
  value = aws_instance.basic.public_ip
  description = "This is public IP of the basic EC2 instance"
}