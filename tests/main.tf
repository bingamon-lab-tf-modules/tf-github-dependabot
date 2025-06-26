module "test" {
  source = "../module"

  providers = {
    github = github.organization
  }

  github_enterprise_slug   = "acme-corp"
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
    {
      name            = "acme-engineering/acme-service"
      type            = "organization"
      encrypted_value = "c2VjcmV0X3ZhbHVl"
      visibility      = "all"
    }
  ]

}