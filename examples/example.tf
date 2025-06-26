terraform {
  required_version = ">= 1.9.0"
}

module "tf-github-dependabot" {
  source = "github.com/bingamon-lab-tf-modules/tf-github-dependabot?ref=v1.0.0"
  #version = "~> 1.0"

  # TFVars go here

}
