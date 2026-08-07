module "test" {
  source = "../module"

  providers = {
    github = github.organization
  }
  github_organization_name = "acme-engineering"

  github_repository_data = {
    "acme-engineering/acme-service" = {
      name                 = "acme-service"
      vulnerability_alerts = true
    }
  }

  github_dependabot_enabled_repositories = [
    {
      name    = "acme-engineering/acme-service"
      enabled = true
    }
  ]

  github_dependabot_secrets = [
    # Legacy encrypted path. No key_id is available, so the module emits the
    # deprecated encrypted_value argument.
    {
      name            = "ACME_LEGACY_ENCRYPTED"
      type            = "organization"
      organization    = "acme-engineering"
      encrypted_value = "c2VjcmV0X3ZhbHVl"
      visibility      = "all"
    },
    # Preferred encrypted path. key_id is supplied, so the module emits
    # value_encrypted + key_id.
    {
      name            = "ACME_ENCRYPTED"
      type            = "organization"
      organization    = "acme-engineering"
      value_encrypted = "c2VjcmV0X3ZhbHVl"
      key_id          = "111111111111111111"
      visibility      = "all"
    },
    # Preferred plaintext path, scoped to selected repositories. Exercises
    # github_dependabot_organization_secret_repositories.
    {
      name                 = "ACME_SELECTED"
      type                 = "organization"
      organization         = "acme-engineering"
      value                = "secret_value"
      visibility           = "selected"
      allowed_repositories = ["acme-engineering/acme-service"]
    },
    # Repository-scoped secret using the preferred value field.
    {
      name         = "ACME_REPOSITORY"
      type         = "repository"
      organization = "acme-engineering"
      repository   = "acme-engineering/acme-service"
      value        = "secret_value"
    },
    # Legacy plaintext alias, still accepted.
    {
      name            = "ACME_LEGACY_PLAINTEXT"
      type            = "repository"
      organization    = "acme-engineering"
      repository      = "acme-engineering/acme-service"
      plaintext_value = "secret_value"
    },
    # NEGATIVE TEST - kept commented so the committed fixture validates.
    # Uncommenting this entry makes `tofu validate` fail with:
    #   Error: Invalid value for variable
    #   Each dependabot secret must set exactly one of: value, value_encrypted,
    #   plaintext_value, encrypted_value. Offending secrets: ACME_NO_VALUE
    # {
    #   name         = "ACME_NO_VALUE"
    #   type         = "organization"
    #   organization = "acme-engineering"
    #   visibility   = "all"
    # },
  ]

}
