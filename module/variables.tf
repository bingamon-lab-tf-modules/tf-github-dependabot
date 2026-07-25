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
#
# Exactly one value field must be set per secret. The provider declares
# ExactlyOneOf across `value`, `value_encrypted`, `encrypted_value` and
# `plaintext_value`, so supplying none - or more than one - is a hard error.
variable "github_dependabot_secrets" {
  type = list(object({
    name = string
    type = string

    # Preferred value fields.
    # `value` is the plaintext secret, encrypted by the provider on your behalf.
    # `value_encrypted` is a Base64 value you encrypted yourself, and requires
    # the matching `key_id` of the public key used to encrypt it.
    value           = optional(string, null)
    value_encrypted = optional(string, null)
    key_id          = optional(string, null)

    # Deprecated aliases, still accepted for backwards compatibility.
    # `plaintext_value` is superseded by `value`.
    # `encrypted_value` is superseded by `value_encrypted` + `key_id`.
    encrypted_value = optional(string, null)
    plaintext_value = optional(string, null)

    visibility           = optional(string, "private") # default: "private"
    allowed_repositories = optional(list(string), [])  # default: []

    organization = optional(string)
    repository   = optional(string)
  }))

  default = []

  # A validation block fails the plan. The equivalent check block only warns,
  # which is not enough to keep a null out of the provider's ExactlyOneOf set.
  validation {
    condition = alltrue([
      for secret in var.github_dependabot_secrets :
      length(compact([
        try(secret.value, null),
        try(secret.value_encrypted, null),
        try(secret.plaintext_value, null),
        try(secret.encrypted_value, null),
      ])) == 1
    ])
    error_message = format(
      "Each dependabot secret must set exactly one of: value, value_encrypted, plaintext_value, encrypted_value. Offending secrets: %s",
      join(", ", [
        for idx, secret in var.github_dependabot_secrets :
        try(secret.name, format("(index %d)", idx))
        if length(compact([
          try(secret.value, null),
          try(secret.value_encrypted, null),
          try(secret.plaintext_value, null),
          try(secret.encrypted_value, null),
        ])) != 1
      ])
    )
  }
}
