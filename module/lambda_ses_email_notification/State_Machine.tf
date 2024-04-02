
locals {
    # definition = file("${path.module}/state_machine_json/SM_defination.json")
    definition = <<EOF
{
  "Comment": "Pet Cuddle-o-Tron - using Lambda for email.",
  "StartAt": "Timer",
  "States": {
    "Timer": {
      "Type": "Wait",
      "SecondsPath": "$.waitSeconds",
      "Next": "Email"
    },
    "Email": {
      "Type" : "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "Parameters": {
        "FunctionName": "${aws_lambda_function.lambda_ses.arn}",
        "Payload": {
          "Input.$": "$"
        }
      },
      "Next": "NextState"
    },
    "NextState": {
      "Type": "Pass",
      "End": true
    }
  }
}
EOF

}

resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = "sfn_state_machine"
  role_arn = aws_iam_role.state_machine_role.arn

  definition = local.definition
}
