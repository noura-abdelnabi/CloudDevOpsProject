# Security Group of Jenkins
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8080  
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance of Jenkins 
resource "aws_instance" "jenkins_server" {
  ami           = var.ami_id
  instance_type = var.instance_type 
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  root_block_device {
    volume_size = 20     
    volume_type = "gp3"       
    delete_on_termination = true
  }  
  key_name      = "vockey"
  tags = { Name = "Jenkins-Server" }
}

# CloudWatch Monitoring 
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "high-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  dimensions = {
    InstanceId = aws_instance.jenkins_server.id
  }
}
