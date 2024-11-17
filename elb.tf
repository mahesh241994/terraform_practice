resource "aws_elb" "mahesh_s3" {
  name               = "Mahesh-terraform-elb"
  availability_zones = ["ap-south-1a", "ap-south-1b"]

  access_logs {
    bucket        = "s3_My_bucket"
    bucket_prefix = "Mahesh_s3_bucket"
    interval      = 60
  }

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 3
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  instances                   = [aws_instance.Mahesh-terraform-elb.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 300
  connection_draining         = true
  connection_draining_timeout = 300

  tags = {
    Name = "Mahesh-terraform-elb"
  }
}

