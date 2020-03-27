# ---------------------------------------------------------------------------------------------------------------------
# AWS Security Groups - Control Access to ALB
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "alb_sg" {
  name        = "${var.name_preffix}-jenkins-master-alb-sg"
  description = "Control access to ALB"
  vpc_id      = var.vpc_id
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = flatten(var.web_whitelist)
  }
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = flatten(var.web_whitelist)
  }
  ingress {
    protocol    = "tcp"
    from_port   = 50000
    to_port     = 50000
    self = true
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.name_preffix}-jenkins-master-alb-sg"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS Security Groups - ECS Tasks, allow traffic only from Load Balancer, Jenkins Master and Slaves
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "ecs_tasks_sg" {
  name        = "${var.name_preffix}-jenkins-master-ecs-tasks-sg"
  description = "Allow inbound access from the ALB only"
  vpc_id      = var.vpc_id
  ingress {
    protocol        = "tcp"
    from_port       = local.jenkins_container_web_port
    to_port         = local.jenkins_container_web_port
    security_groups = [aws_security_group.alb_sg.id]
  }
  ingress {
    protocol        = "tcp"
    from_port       = local.jenkins_container_slave_port
    to_port         = local.jenkins_container_slave_port
    security_groups = [aws_security_group.alb_sg.id]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "jenkins_allow_all_self" {
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  self = true

  security_group_id = "${aws_security_group.ecs_tasks_sg.id}"
}

//resource "aws_security_group_rule" "jenkins_allow_jenkins_slave" {
//  type = "ingress"
//  from_port = 50000
//  to_port = 50000
//  protocol = "6"
//  source_security_group_id = "${aws_security_group.alb_sg.id}"
//
//  security_group_id = "${aws_security_group.ecs_tasks_sg.id}"
//}