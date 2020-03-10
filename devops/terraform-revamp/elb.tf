# #
# # Network Load Balancer
# #
# resource "aws_lb" "demo" {
#   name               = "tf-demo"
#   load_balancer_type = "network"
#   internal           = false
#   subnets            = aws_subnet.private[*].id
# }

# resource "aws_lb_listener" "default" {
#   load_balancer_arn = aws_lb.demo.arn
#   port              = 80
#   protocol          = "tcp"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.demo.arn
#   }
# }

# resource "aws_lb_target_group" "demo" {
#   name        = "tf-demo"
#   port        = 8000
#   protocol    = "tcp"
#   target_type = "ip"
#   vpc_id      = aws_vpc.demo.id
# }

# resource "aws_autoscaling_attachment" "demo" {
#   autoscaling_group_name = aws_eks_node_group.demo.resources.name
#   elb                    = aws_lb.demo.id
# }