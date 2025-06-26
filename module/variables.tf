variable "github_enterprise_slug" {
  type        = string
  description = <<EOT
  The slug of the GitHub Enterprise where resources will be created.

  This is needed by the GitHub Enterprise Terraform provider.

  This can be set via either;

  - TF_VAR_github_enterprise_slug environment variable.
  - github_enterprise_slug variable in the terraform.tfvars file.
  EOT
}

variable "github_organization_name" {
  type        = string
  description = "Required. The name of the GitHub organization to create the actions in."
}

variable "github_repository_data" {
  type = map(object({
    name                 = string
    vulnerability_alerts = bool
  }))
  description = "Map of repository configuration data keyed by repository name to validate vulnerability alerts"
  default     = {}
}

# Where is Dependabot enabled?
variable "github_dependabot_enabled_repositories" {
  type = list(object({
    name    = string
    enabled = optional(bool, true) # default: true
  }))

  default = []
}

# What secrets are used by Dependabot?
variable "github_dependabot_secrets" {
  type = list(object({
    name = string
    type = string

    encrypted_value = optional(string, null)
    plaintext_value = optional(string, null)

    visibility           = optional(string, "private") # default: "private"
    allowed_repositories = optional(list(string), [])  # default: []

    organization = optional(string)
    repository   = optional(string)
  }))

  default = []
}
