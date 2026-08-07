# Collect all referenced organizations and repositories from configuration
locals {
  # Repositories
  all_referenced_repos = distinct(flatten([
    # Repositories from enabled_repositories
    [for repo in var.github_dependabot_enabled_repositories : repo.name],
    # Repositories from repository field (dependabot secrets)
    [for secret in var.github_dependabot_secrets : (
      can(secret.repository) && secret.repository != null ? [secret.repository] : []
    )],
    # Repositories from allowed_repositories, which need resolving to numeric
    # IDs for github_dependabot_organization_secret_repositories.
    [for secret in var.github_dependabot_secrets : (
      can(secret.allowed_repositories) && secret.allowed_repositories != null ? secret.allowed_repositories : []
    )]
  ]))

  # Repositories that have security updates enabled.
  dependabot_security_updates_enabled_repositories = [
    for repo in var.github_dependabot_enabled_repositories : repo.name
    if try(repo.enabled, true) && contains(keys(var.github_repository_data), repo.name)
  ]
}

# Normalise the secret value fields down to exactly one provider argument.
#
# The provider declares ExactlyOneOf across `value`, `value_encrypted`,
# `encrypted_value` and `plaintext_value`, so more than one - or none - is a hard
# plan error. Unused arguments are emitted as null, which OpenTofu omits from the
# request entirely, keeping them out of the ExactlyOneOf accounting.
#
# Precedence per secret:
#   1. `value` or `plaintext_value` set -> emit `value` only.
#   2. else an encrypted value          -> emit `value_encrypted`, plus `key_id`
#      when the caller supplied one.
#
# There is deliberately no third branch emitting the deprecated `encrypted_value`.
# An earlier version had one, on the reading that `value_encrypted` carries
# RequiredWith: ["key_id"]. The provider schema says the opposite - the constraint
# sits on `key_id`:
#
#   "key_id": { Optional, Computed, RequiredWith: ["value_encrypted"],
#               ConflictsWith: ["value", "plaintext_value"] }
#
# so `key_id` requires `value_encrypted`, not the reverse, and `key_id` is
# additionally Computed. When it is empty the provider resolves the public key
# itself (getDependabotOrganizationPublicKeyDetails /
# getDependabotPublicKeyDetails) - the identical code path the deprecated
# argument took. `value_encrypted` alone is therefore sufficient.
#
# var.github_dependabot_secrets is validated to carry exactly one value field, so
# a secret can never fall through all three branches.
locals {
  dependabot_secrets = [
    for secret in var.github_dependabot_secrets : merge(secret, {
      # Branch 1: a plaintext value always wins.
      value = secret.value != null ? secret.value : secret.plaintext_value

      # Branch 2: encrypted path. key_id is optional - the provider resolves the
      # public key itself when it is absent.
      value_encrypted = (
        secret.value == null && secret.plaintext_value == null
        ? (secret.value_encrypted != null ? secret.value_encrypted : secret.encrypted_value)
        : null
      )

      # key_id is only meaningful with value_encrypted, and the provider declares
      # it ConflictsWith ["value", "plaintext_value"], so drop it otherwise.
      key_id = (
        secret.value == null && secret.plaintext_value == null
        ? secret.key_id
        : null
      )
    })
  ]

  # Keyed by secret name, split by scope. Keeping the two maps separate preserves
  # the existing behaviour where an organization and a repository secret may
  # share a name.
  dependabot_organization_secrets = {
    for secret in local.dependabot_secrets : secret.name => secret
    if secret.type == "organization"
  }

  dependabot_repository_secrets = {
    for secret in local.dependabot_secrets : secret.name => secret
    if secret.type == "repository"
  }
}
