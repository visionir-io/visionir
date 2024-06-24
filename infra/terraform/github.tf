resource "github_repository" "visionir" {
  name        = "visionir"
  description = "All my code"
  visibility  = "public"
}

resource "github_actions_secret" "docker_token" {
  repository      = github_repository.visionir.name
  secret_name     = "DOCKER_TOKEN"
  plaintext_value = var.docker_token
}

resource "github_actions_secret" "docker_user" {
  repository      = github_repository.visionir.name
  secret_name     = "DOCKER_USER"
  plaintext_value = var.docker_token
}

resource "github_actions_secret" "pypi_token" {
  repository      = github_repository.visionir.name
  secret_name     = "PYPI_TOKEN"
  plaintext_value = var.docker_token
}
