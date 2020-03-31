# ---------------------------------------------------------------------------------------------------------------------
# AWS ECS Task Execution Role
# ---------------------------------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "jenkins_ecs_secrets_manager" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:ListSecrets",
      "kms:Decrypt"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "jenkins_secrets_policy" {
  name       = "${var.name_preffix}-jenkins-ecs-task-secredts-manager-role"
  description = "Allows Jenknis ECS task to read secrets manager for dynamic credentials store."
  policy      = data.aws_iam_policy_document.jenkins_ecs_secrets_manager.json
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.name_preffix}-jenkins-ecs-task-execution-role"
  assume_role_policy = file("${path.module}/files/iam/ecs_task_execution_iam_role.json")
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "jenkins_secrets_role_policy_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.jenkins_secrets_policy.arn
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS ECS Auto Scale Role
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "ecs_autoscale_role" {
  name               = "${var.name_preffix}-jenkins-ecs-autoscale-role"
  assume_role_policy = file("${path.module}/files/iam/ecs_autoscale_iam_role.json")
}

resource "aws_iam_role_policy" "ecs_autoscale_role_policy" {
  name = "${var.name_preffix}-jenkins-ecs-autoscale-role-policy"
  role = aws_iam_role.ecs_autoscale_role.id
  policy = file(
    "${path.module}/files/iam/ecs_autoscale_iam_role_policy.json",
  )
}

#
# Jenkins Terraforming Role
#
resource "aws_iam_role" "jenkins_local_admin_role" {
  name               = "Jenkins-Local-Admin"
  assume_role_policy = "${data.aws_iam_policy_document.forrole.json}"
}
resource "aws_iam_policy" "local_admin" {
  name        = "JenkinsAdmin"
  description = "Role which provides most of the access to one given AWS account"

  policy = "${data.aws_iam_policy_document.local_admin.json}"
}
