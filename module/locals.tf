# Collect all referenced organizations and repositories from configuration
locals {
  # Repositories
  all_referenced_repos = distinct(flatten([
    # Repositories from enabled_repositories
    [for repo in var.github_dependabot_enabled_repositories : repo.name],
    # Repositories from repository field (dependabot secrets)
    [for secret in var.github_dependabot_secrets : (
      can(secret.repository) && secret.repository != null ? [secret.repository] : []
    )]
  ]))

  # Repositories that have security updates enabled.
  dependabot_security_updates_enabled_repositories = [
    for repo in var.github_dependabot_enabled_repositories : repo.name
    if try(repo.enabled, true) && contains(keys(var.github_repository_data), repo.name)
  ]
}
