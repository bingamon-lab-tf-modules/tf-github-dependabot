####################################################
# Validation: Dependabot Secrets
####################################################

# Check and validate dependabot enabled repositories
# - Name is required
# - Enabled is optional as it defaults to true
check "dependabot_enabled_repositories" {
  assert {
    condition = alltrue([
      for idx, repository in var.github_dependabot_enabled_repositories :
      can(repository.name) &&
      repository.name != null
    ])
    error_message = join("\n", [
      for idx, repository in var.github_dependabot_enabled_repositories :
      (!can(repository.name) || repository.name == null) ?
      format("Invalid dependabot enabled repository: %s%s",
        can(repository.name) ? repository.name : format("(index %d)", idx),
        (!can(repository.name) || repository.name == null ? " [missing name]" : "")
      )
      : null
      if(!can(repository.name) || repository.name == null)
    ])
  }
}

# Check and validate dependabot secrets
# - Name is required
# - Type is required
check "dependabot_secrets" {
  assert {
    condition = alltrue([
      for idx, secret in var.github_dependabot_secrets :
      can(secret.name) &&
      secret.name != null &&
      can(secret.type) &&
      secret.type != null
    ])
    error_message = join("\n", [
      for idx, secret in var.github_dependabot_secrets :
      (!can(secret.name) || secret.name == null || !can(secret.type) || secret.type == null) ?
      format("Invalid actions secret: %s%s%s",
        can(secret.name) ? secret.name : format("(index %d)", idx),
        (!can(secret.name) || secret.name == null ? " [missing name]" : ""),
        (!can(secret.type) || secret.type == null ? " [missing type]" : "")
      )
      : null
      if(!can(secret.name) || secret.name == null || !can(secret.type) || secret.type == null)
    ])
  }
}

# Check and validate actions secrets value requirements
# - Either plaintext_value or encrypted_value is required, but never both at the same time
check "actions_secrets_value" {
  assert {
    condition = alltrue([
      for idx, secret in var.github_dependabot_secrets :
      # Must have exactly one of plaintext_value or encrypted_value (not both, not neither)
      (
        (can(secret.plaintext_value) && secret.plaintext_value != null && secret.plaintext_value != "") &&
        (!(can(secret.encrypted_value) && secret.encrypted_value != null && secret.encrypted_value != ""))
        ) || (
        (can(secret.encrypted_value) && secret.encrypted_value != null && secret.encrypted_value != "") &&
        (!(can(secret.plaintext_value) && secret.plaintext_value != null && secret.plaintext_value != ""))
      )
    ])
    error_message = join("\n", [
      for idx, secret in var.github_dependabot_secrets :
      !(
        (
          (can(secret.plaintext_value) && secret.plaintext_value != null && secret.plaintext_value != "") &&
          (!(can(secret.encrypted_value) && secret.encrypted_value != null && secret.encrypted_value != ""))
          ) || (
          (can(secret.encrypted_value) && secret.encrypted_value != null && secret.encrypted_value != "") &&
          (!(can(secret.plaintext_value) && secret.plaintext_value != null && secret.plaintext_value != ""))
        )
      ) ?
      format(
        "Invalid actions secret '%s': %s",
        can(secret.name) ? secret.name : format("(index %d)", idx),
        (
          (can(secret.plaintext_value) && secret.plaintext_value != null && secret.plaintext_value != "") &&
          (can(secret.encrypted_value) && secret.encrypted_value != null && secret.encrypted_value != "")
        ) ? "cannot have both plaintext_value and encrypted_value" : "must have either plaintext_value or encrypted_value"
      )
      : null
      if !(
        (
          (can(secret.plaintext_value) && secret.plaintext_value != null && secret.plaintext_value != "") &&
          (!(can(secret.encrypted_value) && secret.encrypted_value != null && secret.encrypted_value != ""))
          ) || (
          (can(secret.encrypted_value) && secret.encrypted_value != null && secret.encrypted_value != "") &&
          (!(can(secret.plaintext_value) && secret.plaintext_value != null && secret.plaintext_value != ""))
        )
      )
    ])
  }
}

# Check and validate actions secrets conditional fields
# - If type is organization, organization is required
# - If type is repository, organization and repository are required
check "actions_secrets_conditional_fields" {
  assert {
    condition = alltrue([
      for idx, secret in var.github_dependabot_secrets :
      (can(secret.type) && secret.type != null) ? (
        (secret.type == "organization") ? (
          can(secret.organization) && secret.organization != null && secret.organization != ""
          ) : (secret.type == "repository") ? (
          can(secret.organization) && secret.organization != null && secret.organization != "" &&
          can(secret.repository) && secret.repository != null && secret.repository != ""
        ) : true
      ) : true
    ])
    error_message = join("\n", [
      for idx, secret in var.github_dependabot_secrets :
      ((can(secret.type) && secret.type != null) && (
        (secret.type == "organization" && (!can(secret.organization) || secret.organization == null || secret.organization == "")) ||
        (secret.type == "repository" && (
          (!can(secret.organization) || secret.organization == null || secret.organization == "") ||
          (!can(secret.repository) || secret.repository == null || secret.repository == "")
        ))
        )) ? (
        format(
          "Invalid actions secret '%s':%s%s%s",
          can(secret.name) ? secret.name : format("(index %d)", idx),
          (secret.type == "organization" && (!can(secret.organization) || secret.organization == null || secret.organization == "")) ? " [type 'organization' requires organization field]" : "",
          (secret.type == "repository" && ((!can(secret.organization) || secret.organization == null || secret.organization == "") || (!can(secret.repository) || secret.repository == null || secret.repository == ""))) ? " [type 'repository' requires organization and repository fields]" : "",
        )
      ) : null
      if((can(secret.type) && secret.type != null) && (
        (secret.type == "organization" && (!can(secret.organization) || secret.organization == null || secret.organization == "")) ||
        (secret.type == "repository" && (
          (!can(secret.organization) || secret.organization == null || secret.organization == "") ||
          (!can(secret.repository) || secret.repository == null || secret.repository == "")
        ))
      ))
    ])
  }
}
