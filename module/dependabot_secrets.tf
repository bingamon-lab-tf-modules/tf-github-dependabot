# Organization Secrets
resource "github_dependabot_organization_secret" "this" {
  for_each = local.dependabot_organization_secrets

  secret_name = each.value.name

  # Exactly one of these is non-null; the rest are omitted by OpenTofu so the
  # provider's ExactlyOneOf constraint sees a single value. See locals.tf.
  value           = each.value.value
  value_encrypted = each.value.value_encrypted
  key_id          = each.value.key_id
  encrypted_value = each.value.encrypted_value

  visibility = lookup(each.value, "visibility", "private")

  depends_on = [
    data.github_enterprise.this
  ]

}

# Repository allow list for organization secrets with "selected" visibility.
#
# selected_repository_ids on github_dependabot_organization_secret is deprecated
# in favour of this dedicated resource.
resource "github_dependabot_organization_secret_repositories" "this" {
  for_each = {
    for name, secret in local.dependabot_organization_secrets : name => secret
    if lookup(secret, "visibility", "private") == "selected" &&
    length(coalesce(lookup(secret, "allowed_repositories", []), [])) > 0
  }

  secret_name = github_dependabot_organization_secret.this[each.key].secret_name

  selected_repository_ids = [
    for repo in each.value.allowed_repositories :
    data.github_repository.this[repo].repo_id
    if can(data.github_repository.this[repo].repo_id)
  ]
}

# Repository Secrets
resource "github_dependabot_secret" "this" {
  for_each = local.dependabot_repository_secrets

  secret_name = each.value.name

  # Exactly one of these is non-null; the rest are omitted by OpenTofu so the
  # provider's ExactlyOneOf constraint sees a single value. See locals.tf.
  value           = each.value.value
  value_encrypted = each.value.value_encrypted
  key_id          = each.value.key_id
  encrypted_value = each.value.encrypted_value

  repository = each.value.repository

  depends_on = [
    data.github_enterprise.this,
    data.github_organization.this,
    data.github_repository.this
  ]
}
