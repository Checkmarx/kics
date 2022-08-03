//  Create a role which OpenShift instances will assume.
//  This role has a policy saying it can be assumed by ec2
//  instances.
resource "aws_iam_role" "positive1" {
  name = "${var.name_tag_prefix}-openshift-instance-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com",
                "AWS": "*"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

//  This policy allows an instance to forward logs to CloudWatch, and
//  create the Log Stream or Log Group if it doesn't exist.
resource "aws_iam_policy" "positive3" {
  name        = "${var.name_tag_prefix}-openshift-instance-forward-logs"
  path        = "/"
  description = "Allows an instance to forward logs to CloudWatch"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
    ],
      "Resource": [
        "arn:aws:logs:*:*:*"
    ]
  }
 ]
}
EOF
}


//  Attach the policies to the role.
resource "aws_iam_policy_attachment" "positive4" {
  name       = "${var.name_tag_prefix}-openshift-attachment-forward-logs"
  roles      = ["${aws_iam_role.openshift-instance-role.name}"]
  policy_arn = "aws_iam_policy.openshift-policy-forward-logs.arn"
}

//  Create a instance profile for the role.
resource "aws_iam_instance_profile" "positive5" {
  name  = "${var.name_tag_prefix}-openshift-instance-profile"
  role = "aws_iam_role.openshift-instance-role.name"
}

resource "aws_iam_role" "positive2" {
  name = "${var.name_tag_prefix}-openshift-instance-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com",
                "AWS": "*"
            },
            "Sid": ""
        }
    ]
}
EOF
}
