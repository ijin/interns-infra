variable "account_id"   {}
variable "num_accounts" {}
variable "auto_stop"    { default = 30 }
variable "keybase_id"   { default = "ijin" }

# IAM users
resource "aws_iam_user" "intern" {
  count = "${var.num_accounts}"
  name = "intern-${count.index}"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "intern" {
  count = "${var.num_accounts}"
  user    = "${element(aws_iam_user.intern.*.name, count.index)}"
  pgp_key = "keybase:${var.keybase_id}"
  password_reset_required = false
  password_length = 10
}

resource "aws_iam_group" "group" {
  name = "interns"
  path = "/users/"
}

resource "aws_iam_group_policy_attachment" "c9" {
  group      = "${aws_iam_group.group.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCloud9EnvironmentMember"
}

resource "aws_iam_group_membership" "group" {
  name = "interns"

  users = ["${aws_iam_user.intern.*.name}"]
  group = "${aws_iam_group.group.name}"
}


# Cloud 9
resource "aws_cloud9_environment_ec2" "intern" {
  count = "${var.num_accounts}"
  provider = "aws.west"
  instance_type = "t2.micro"
  name = "intern-env-${count.index}"
  description = "Interns environment (${count.index}))"
  automatic_stop_time_minutes = "${var.auto_stop}"
  owner_arn = "arn:aws:iam::${var.account_id}:user/intern-${count.index}"
  depends_on = ["aws_iam_user.intern"]
}

output "passwords" {
  value = "${join("\n",aws_iam_user_login_profile.intern.*.encrypted_password)}"
}

