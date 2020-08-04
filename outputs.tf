output "alb_public_dns" {
  value = "${module.alb.alb_dns_name}"
}

output "public_dns_name" {
  value = "${var.public_dns_name}"
}

output "aws_ami_id" {
  value = module.ec2.aws_ami_id
}

output "aws_autoscaling_group_arn" {
  value = module.ec2.aws_autoscaling_group_arn
}
