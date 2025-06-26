####################################################
# Checks: Common Configuration Issues
####################################################

# Check organization name follows expected patterns
check "organization_name" {
  assert {
    condition = can(regex("^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$", var.github_organization_name)) && length(var.github_organization_name) <= 39
    error_message = format(
      "Invalid organization name: '%s'\n  ✗ Organization names must be 1-39 characters, alphanumeric and hyphens only\n  ✗ Must start and end with alphanumeric characters\n  → Please check the organization name and ensure it follows GitHub naming conventions",
      var.github_organization_name
    )
  }
}

# Check repository names follow expected patterns
check "repository_names" {
  assert {
    condition = alltrue([
      for repo in local.all_referenced_repos :
      can(regex("^[a-zA-Z0-9._-]+$", repo)) && length(repo) <= 100
    ])
    error_message = join("\n", [
      for repo in local.all_referenced_repos :
      (!can(regex("^[a-zA-Z0-9._-]+$", repo)) || length(repo) > 100) ?
      format(
        "Invalid repository name: '%s'\n  ✗ Repository names must be 1-100 characters, alphanumeric, dots, underscores, and hyphens only\n  → Please check the repository name and ensure it follows GitHub naming conventions",
        repo
      ) : null
      if(!can(regex("^[a-zA-Z0-9._-]+$", repo)) || length(repo) > 100)
    ])
  }
}

# Check if vulnerability_alerts is enabled on the repository.
check "dependabot_security_updates_requires_vulnerability_alerts" {
  assert {
    # Only run this check if there is repository data
    # This is to skip on first run when repos don't exist yet during a plan.
    condition = length(var.github_repository_data) == 0 ? true : alltrue([
      for repo in local.dependabot_security_updates_enabled_repositories :
      try(var.github_repository_data[repo].vulnerability_alerts, false)
    ])
    error_message = length(var.github_repository_data) == 0 ? "Skipping vulnerability_alerts check - repositories not created yet (first run)" : join("\n", [
      for repo in local.dependabot_security_updates_enabled_repositories :
      !try(var.github_repository_data[repo].vulnerability_alerts, false) ?
      format("Repository '%s' must have vulnerability_alerts enabled to use dependabot security updates.", repo)
      : null
      if !try(var.github_repository_data[repo].vulnerability_alerts, false)
    ])
  }
}
