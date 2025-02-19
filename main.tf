resource "aws_launch_template" "web_server_as" {
    name = "myproject"
    image_id           = "ami-09e6cc9a368c9cf4b"
    vpc_security_group_ids = [aws_security_group.web_server.id]
    instance_type = "t2.micro"
    key_name = "firstkeypair"
    tags = {
        Name = "DevOps"
    }
    
}
   


  resource "aws_elb" "web_server_lb"{
     name = "web-server-lb"
     security_groups = [aws_security_group.web_server.id]
     subnets = ["subnet-080c050ced06611e6", "subnet-09f84d0b8d423d6db"]
     listener {
      instance_port     = 8000
      instance_protocol = "http"
      lb_port           = 80
      lb_protocol       = "http"
    }
    tags = {
      Name = "terraform-elb"
    }
  }
resource "aws_autoscaling_group" "web_server_asg" {
    name                 = "web-server-asg"
    min_size             = 1
    max_size             = 3
    desired_capacity     = 2
    health_check_type    = "EC2"
    load_balancers       = [aws_elb.web_server_lb.name]
    availability_zones    = ["ap-south-2a", "ap-south-2b"] 
    launch_template {
        id      = aws_launch_template.web_server_as.id
        version = "$Latest"
      }
    
    
  }

