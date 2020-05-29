terraform {
  required_version = ">= 0.11"
}

provider "aws" {
  region = "eu-west-2"
}

module "webcluster" {
  source = "../../Modules/webcluster"

  cluster_name           = "webservers-prod"
  db_remote_state_bucket = "${var.db_remote_state_bucket}"
  db_remote_state_key    = "${var.db_remote_state_key}"

  instance_type = "m4.large"
  min_size      = 2
  max_size      = 10
  key_name      = "new-keypair"
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name = "scale-out-during-business-hours"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 10
  recurrence            = "0 9 * * *"

  autoscaling_group_name = "${module.webcluster.asg_name}"
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name = "scale-in-at-night"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 2
  recurrence            = "0 17 * * *"

  autoscaling_group_name = "${module.webcluster.asg_name}"
}