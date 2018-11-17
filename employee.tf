resource "aws_iam_user" "instructor" {
  name = "instructor"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "instructor" {
  user    = "${aws_iam_user.instructor.name}"
  pgp_key = "${var.pgp}"
  password_reset_required = false
  password_length = 10
}

resource "aws_iam_group" "instructor" {
  name = "instructor"
  path = "/users/"
}

resource "aws_iam_group_policy_attachment" "c9admin" {
  group      = "${aws_iam_group.instructor.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCloud9Administrator"
}

resource "aws_iam_group_policy_attachment" "ec2admin" {
  group      = "${aws_iam_group.instructor.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_group_membership" "instructor" {
  name = "instructor"

  users = ["${aws_iam_user.instructor.name}"]
  group = "${aws_iam_group.instructor.name}"
}

output "instructor_pwd" {
  value = "${aws_iam_user_login_profile.instructor.encrypted_password}"
}

