# Assignment 2.16 Monitoring, Logging, and Cost Optimization
  Given the Lambda function and metric filters created in the activity, use terraform to create the alarm.

# --- Terraform Code for CloudWatch Alarm

    ```resource "aws_cloudwatch_log_metric_filter" "lambda_error_filter" {
      name           = "info-count"
      log_group_name = aws_cloudwatch_log_group.http_api.name

      pattern = "[INFO]"

      metric_transformation {
        name      = "info-count"
        namespace = "/moviedb-api/aalimsee-ce9"
        value     = "1"
      }
    }

    resource "aws_cloudwatch_metric_alarm" "lambda_error_alarm" {
      alarm_name          = "aalimsee-ce9-info-count-breach"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 1
      threshold           = 10
      period              = 60 # min 60 secs (1 min)
      statistic           = "Sum"
      metric_name = aws_cloudwatch_log_metric_filter.lambda_error_filter.metric_transformation[0].name
      namespace   = aws_cloudwatch_log_metric_filter.lambda_error_filter.metric_transformation[0].namespace

      alarm_description  = "Triggers when Lambda function logs an error"
      alarm_actions      = [aws_sns_topic.lambda_alerts.arn]
    }

    resource "aws_sns_topic" "lambda_alerts" {
      name = "aalimsee-lambda-alerts"
    }

    resource "aws_sns_topic_subscription" "email_alert" {
      topic_arn = aws_sns_topic.lambda_alerts.arn
      protocol  = "email"
      endpoint  = "xxxx@example.com"
    }
```




# Commands to invoke api

```bash
# Add movie
INVOKE_URL=https://xxxxxxx.amazonaws.com
curl \
  -X PUT \
  -H "Content-Type: application/json" \
  -d '{"year": "2013", "title": "The Amazing Spider"}' \
  ${INVOKE_URL}/topmovies

# Get movie for a particular year
curl ${INVOKE_URL}/topmovies/2013

# Get listing
curl ${INVOKE_URL}/topmovies

# Delete movie for a particular year
curl -X DELETE ${INVOKE_URL}/topmovies/2013
```
