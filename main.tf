terraform {
  required_version = ">= 1.0.0"

  required_providers {
    ec = {
      source  = "elastic/ec"
      version = "0.5.0"
    }
  }
}

provider "ec" {
  # an apikey must be provided, 
  # either by an override.tf file
  # or EC_API_KEY env var
  # or provide it here (uncomment and edit the following line)
  #apikey = "...my-api-key..."
}

resource "ec_deployment" "custom-deployment-id" {

  name                   = "gcp-lab-${format("%02d", count.index + 1)}"

  region                 = "gcp-us-west1"
  version                = "8.5.1"
  deployment_template_id = "gcp-general-purpose-v3"

  elasticsearch {
    autoscale = "true"
  }

  kibana {}
  integrations_server {}

  count = 3
}

output "deployment_names" {
  value = [ec_deployment.custom-deployment-id[*].name]
}

output "elasticsearch_endpoints" {
  value = [ec_deployment.custom-deployment-id[*].elasticsearch[0].https_endpoint]
}

output "elasticsearch_cloud_ids" {
  value = [ec_deployment.custom-deployment-id[*].elasticsearch[0].cloud_id]
}

output "elasticsearch_usernames" {
  value = [ec_deployment.custom-deployment-id[*].elasticsearch_username]
}

output "elasticsearch_passwords" {
  value = [ec_deployment.custom-deployment-id[*].elasticsearch_password]
  sensitive = true
}

output "kibana_endpoints" {
  value = [ec_deployment.custom-deployment-id[*].kibana[0].https_endpoint]
}
