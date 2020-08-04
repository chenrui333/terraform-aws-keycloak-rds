output "aws_ami_id" {
  value = data.aws_ami.stable_coreos.id
}

output "aws_autoscaling_group_arn" {
  value = aws_autoscaling_group.app.arn
}
