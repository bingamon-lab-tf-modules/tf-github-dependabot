# tf-github-dependabot

## Table of Contents

- [tf-github-dependabot](#tf-github-dependabot)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Documentation](#documentation)

## Overview

This module configures GitHub Dependabot.

## Documentation

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | 6.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | 6.6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_dependabot_organization_secret.this](https://registry.terraform.io/providers/integrations/github/6.6.0/docs/resources/dependabot_organization_secret) | resource |
| [github_dependabot_secret.this](https://registry.terraform.io/providers/integrations/github/6.6.0/docs/resources/dependabot_secret) | resource |
| [github_repository_dependabot_security_updates.this](https://registry.terraform.io/providers/integrations/github/6.6.0/docs/resources/repository_dependabot_security_updates) | resource |
| [github_enterprise.this](https://registry.terraform.io/providers/integrations/github/6.6.0/docs/data-sources/enterprise) | data source |
| [github_organization.this](https://registry.terraform.io/providers/integrations/github/6.6.0/docs/data-sources/organization) | data source |
| [github_repository.this](https://registry.terraform.io/providers/integrations/github/6.6.0/docs/data-sources/repository) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_dependabot_enabled_repositories"></a> [github\_dependabot\_enabled\_repositories](#input\_github\_dependabot\_enabled\_repositories) | Where is Dependabot enabled? | <pre>list(object({<br/>    name    = string<br/>    enabled = optional(bool, true) # default: true<br/>  }))</pre> | `[]` | no |
| <a name="input_github_dependabot_secrets"></a> [github\_dependabot\_secrets](#input\_github\_dependabot\_secrets) | What secrets are used by Dependabot? | <pre>list(object({<br/>    name = string<br/>    type = string<br/><br/>    encrypted_value = optional(string, null)<br/>    plaintext_value = optional(string, null)<br/><br/>    visibility           = optional(string, "private") # default: "private"<br/>    allowed_repositories = optional(list(string), [])  # default: []<br/><br/>    organization = optional(string)<br/>    repository   = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_github_enterprise_slug"></a> [github\_enterprise\_slug](#input\_github\_enterprise\_slug) | The slug of the GitHub Enterprise where resources will be created.<br/><br/>  This is needed by the GitHub Enterprise Terraform provider.<br/><br/>  This can be set via either;<br/><br/>  - TF\_VAR\_github\_enterprise\_slug environment variable.<br/>  - github\_enterprise\_slug variable in the terraform.tfvars file. | `string` | n/a | yes |
| <a name="input_github_organization_name"></a> [github\_organization\_name](#input\_github\_organization\_name) | Required. The name of the GitHub organization to create the actions in. | `string` | n/a | yes |
| <a name="input_github_repository_data"></a> [github\_repository\_data](#input\_github\_repository\_data) | Map of repository configuration data keyed by repository name to validate vulnerability alerts | <pre>map(object({<br/>    name                 = string<br/>    vulnerability_alerts = bool<br/>  }))</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
