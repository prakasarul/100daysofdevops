provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.profile}"
}


data "archive_file" "stop_ec2" {
  type        = "zip"
  source_file = "stopec2.py"
  output_path = "stopec2.zip"
}


resource "aws_iam_role" "stopec2role" {
  name = "stopec2role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ec2fullaccess" {
  name        = "ec2fullambda"
  description = "A test policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "cloudwatch:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": [
                        "autoscaling.amazonaws.com",
                        "ec2scheduled.amazonaws.com",
                        "elasticloadbalancing.amazonaws.com",
                        "spot.amazonaws.com",
                        "spotfleet.amazonaws.com",
                        "transitgateway.amazonaws.com"
                    ]
                }
            }
        },
        {
            "Action": [
                "autoscaling:Describe*",
                "cloudwatch:*",
                "logs:*",
                "sns:*",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:GetRole"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "arn:aws:iam::*:role/aws-service-role/events.amazonaws.com/AWSServiceRoleForCloudWatchEvents*",
            "Condition": {
                "StringLike": {
                    "iam:AWSServiceName": "events.amazonaws.com"
                }
            }
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "test_policy" {
  role       = "${aws_iam_role.stopec2role.name}"
  policy_arn = "${aws_iam_policy.ec2fullaccess.arn}"
}



resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.test_lambda.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.every_two_am_rule.arn}"
}

resource "aws_lambda_function" "test_lambda" {
  filename         = "stopec2.zip"
  function_name    = "lambda_stopec2"
  role             = "${aws_iam_role.stopec2role.arn}"
  handler          = "stopec2.lambda_handler"
  source_code_hash = "${data.archive_file.stop_ec2.output_base64sha256}"
  runtime          = "python3.8"

  environment {
    variables = {
      name = "value"
    }
  }
}

resource "aws_cloudwatch_event_rule" "every_two_am_rule" {
  name                = "lambda_schedular_rule"
  description         = "schedule events in lambda to stopec2 everyday 2AM IST mentioned cron time is GMT"
  schedule_expression = "cron(00 20 * * ? *)"
}

resource "aws_cloudwatch_event_target" "lambda_schedular_target" {
  rule = "${aws_cloudwatch_event_rule.every_two_am_rule.name}"
  arn  = "${aws_lambda_function.test_lambda.arn}"
}