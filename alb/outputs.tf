output "alb_dns_name" {
  value = "${aws_lb.main.dns_name}"
}

# output "alb_public_ip" {
#   value = "${aws_lb.main.public_ip}"
# }

output "alb_id" {
  value = "${aws_lb.main.id}"
}

output "alb_arn" {
  value = "${aws_lb.main.arn}"
}

output "alb_zone" {
  value = "${aws_lb.main.zone_id}"
}

output "alb_target_group_arn" {
  value = "${aws_lb_target_group.main.id}"
}

output "alb_listener_front_end_tls" {
  value = "${aws_lb_listener.front_end_tls.id}"
}
