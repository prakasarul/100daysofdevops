resource "aws_key_pair" "terra_login" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_security_group" "terra_sg" {
  name        = "terra_sg"
  description = "used for access public instance"

  #SSH
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

resource "aws_instance" "terra_server" {
  instance_type = "${var.instance_type}"
  ami           = "${var.ami_id}"
  tags = {
    Name = "terra_server"
  }
  vpc_security_group_ids = ["${aws_security_group.terra_sg.id}"]
  key_name               = "${aws_key_pair.terra_login.id}"
}

resource "aws_sns_topic" "terra_sns" {
  name = "terra_sns"
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF

provisioner "local-exec" {
    command = "aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.alarms_email} --profile divdevops"
}

}


resource "aws_cloudwatch_metric_alarm" "terra_cloudwatch" {
  alarm_name          = "terra_cpu_check"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Create CPU metric with alarm and notify to sns"
  alarm_actions       = ["${aws_sns_topic.terra_sns.arn}"]

  dimensions = {
    InstanceId = "${aws_instance.terra_server.id}"
     ImageId = "${var.ami_id}"
    InstanceType = "${var.instance_type}"
  }


}

