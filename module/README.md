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
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 6.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | 6.13.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_dependabot_organization_secret.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/dependabot_organization_secret) | resource |
| [github_dependabot_secret.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/dependabot_secret) | resource |
| [github_repository_dependabot_security_updates.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_dependabot_security_updates) | resource |
| [github_enterprise.this](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/enterprise) | data source |
| [github_organization.this](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/organization) | data source |
| [github_repository.this](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/repository) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_dependabot_enabled_repositories"></a> [github\_dependabot\_enabled\_repositories](#input\_github\_dependabot\_enabled\_repositories) | Where is Dependabot enabled? | <pre>list(object({<br/>    name    = string<br/>    enabled = optional(bool, true) # default: true<br/>  }))</pre> | `[]` | no |
| <a name="input_github_dependabot_secrets"></a> [github\_dependabot\_secrets](#input\_github\_dependabot\_secrets) | What secrets are used by Dependabot?  Exactly one value field must be set per secret. The provider declares ExactlyOneOf across `value`, `value_encrypted`, `encrypted_value` and `plaintext_value`, so supplying none - or more than one - is a hard error. | <pre>list(object({<br/>    name = string<br/>    type = string<br/><br/>    # Preferred value fields.<br/>    # `value` is the plaintext secret, encrypted by the provider on your behalf.<br/>    # `value_encrypted` is a Base64 value you encrypted yourself, and requires<br/>    # the matching `key_id` of the public key used to encrypt it.<br/>    value           = optional(string, null)<br/>    value_encrypted = optional(string, null)<br/>    key_id          = optional(string, null)<br/><br/>    # Deprecated aliases, still accepted for backwards compatibility.<br/>    # `plaintext_value` is superseded by `value`.<br/>    # `encrypted_value` is superseded by `value_encrypted` + `key_id`.<br/>    encrypted_value = optional(string, null)<br/>    plaintext_value = optional(string, null)<br/><br/>    visibility           = optional(string, "private") # default: "private"<br/>    allowed_repositories = optional(list(string), [])  # default: []<br/><br/>    organization = optional(string)<br/>    repository   = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_github_enterprise_slug"></a> [github\_enterprise\_slug](#input\_github\_enterprise\_slug) | The slug of the GitHub Enterprise where resources will be created.<br/><br/>  This is needed by the GitHub Enterprise Terraform provider.<br/><br/>  This can be set via either;<br/><br/>  - TF\_VAR\_github\_enterprise\_slug environment variable.<br/>  - github\_enterprise\_slug variable in the terraform.tfvars file. | `string` | n/a | yes |
| <a name="input_github_organization_name"></a> [github\_organization\_name](#input\_github\_organization\_name) | Required. The name of the GitHub organization to create the actions in. | `string` | n/a | yes |
| <a name="input_github_repository_data"></a> [github\_repository\_data](#input\_github\_repository\_data) | Map of repository configuration data keyed by repository name to validate vulnerability alerts | <pre>map(object({<br/>    name                 = string<br/>    vulnerability_alerts = bool<br/>  }))</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
