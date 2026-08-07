# Enable Dependabot security updates for a repository
# Defaults to true, but can be disabled if required.
resource "github_repository_dependabot_security_updates" "this" {
  for_each = {
    for repository in var.github_dependabot_enabled_repositories : repository.name => repository
    # Only include repositories that actually exist in the repository data
    if contains(keys(var.github_repository_data), repository.name)
  }

  # NOTE: In order to enable this,
  # you need to have vulnerability_alerts enabled on the repository.
  enabled = lookup(each.value, "enabled", false)

  repository = each.value.name

  depends_on = [
    data.github_organization.this,
    data.github_repository.this
  ]
}
