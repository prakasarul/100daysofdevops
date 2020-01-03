Problems faced & Referenced links

Insufficient Data due to instance_type not mentioned
https://stackoverflow.com/questions/57003571/cwagent-metric-alarms-created-using-terraform-doesnt-get-data-points-collected

http://aws-cloud.guru/terraform-sns-topic-email-list/


SNS subpscription will not happen 

These are unsupported because the endpoint needs to be authorized and does not generate an ARN until the target email address has been validated. This breaks the Terraform model and as a result are not currently supported.


Handling Insufficient data due to missing data points on metrics 

https://medium.com/@martatatiana/insufficient-data-cloudwatch-alarm-based-on-custom-metric-filter-4e41c1f82050

https://marbot.io/blog/cloudwatch-tips-and-tricks-monitoring-error-metric.html