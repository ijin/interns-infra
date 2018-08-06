variable "account_id" {}
variable "num_accounts" { }

# IAM users
resource "aws_iam_user" "intern" {
  count = "${var.num_accounts}"
  name = "intern-${count.index}"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "intern" {
  count = "${var.num_accounts}"
  user    = "${element(aws_iam_user.intern.*.name, count.index)}"
  pgp_key = "keybase:ijin"
  password_reset_required = false
  password_length = 10
}

resource "aws_iam_group" "interns" {
  name = "interns"
  path = "/users/"
}

resource "aws_iam_group_policy_attachment" "interns-c9" {
  group      = "${aws_iam_group.interns.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCloud9EnvironmentMember"
}

resource "aws_iam_group_membership" "interns" {
  name = "interns"

  users = ["${aws_iam_user.intern.*.name}"]
  group = "${aws_iam_group.interns.name}"
}


# Cloud 9
resource "aws_cloud9_environment_ec2" "intern" {
  count = "${var.num_accounts}"
  provider = "aws.west"
  instance_type = "t2.micro"
  name = "intern-env-${count.index}"
  description = "Seattle Consulting intern environment (${count.index}))"
  owner_arn = "${element(aws_iam_user.intern.*.arn, count.index)}"
}

output "passwords" {
  value = "${join("\n",aws_iam_user_login_profile.intern.*.encrypted_password)}"
}

