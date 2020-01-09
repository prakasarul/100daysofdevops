Created New Role and attached policy with EC2 Full access,Cloudwatch full access

Created cloudwatch Event Rule (cron) runs everyday 2AM IST in AWS time will be GMT "cron(00 20 * * ? *)" and it triggers lambda function.
Created lambda python code to stop all running instance.