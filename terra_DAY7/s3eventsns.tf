provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.profile}"
}


resource "aws_sns_topic" "s3eventmail" {
  name            = "s3eventmail"
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

  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": {"AWS":"*"},
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:*:*:s3eventmail",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.s3eventbuck.arn}"}
        }
    }]
}
POLICY

  provisioner "local-exec" {
    command = "aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.alarms_email} --profile divdevops"
  }

}


resource "aws_s3_bucket" "s3eventbuck" {
  bucket = "s3eventbuck-arvel123"
}

resource "aws_s3_bucket_notification" "s3eventbuck_notification" {
  bucket = "${aws_s3_bucket.s3eventbuck.id}"

  topic {
    topic_arn = "${aws_sns_topic.s3eventmail.arn}"
    events    = ["s3:ObjectRemoved:*"]
  }
}