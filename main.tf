terraform {
  required_version = ">= 1.0.0"

  required_providers {
    ec = {
      source  = "elastic/ec"
      version = "0.5.1" #always check if newer version is available
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

  region                 = var.elastic_region
  version                = var.elastic_version #check the ESS version you want to use!
  deployment_template_id = var.elastic_deployment_template_id #check this from the ESS API creation snippet
  

  elasticsearch {
    autoscale = "true"
    topology {
      id = "hot_content"
      zone_count = var.elastic_replicas #set this for HA. If omitted default value for the deployment template is used (often 2)
    }
  }

  kibana {}
  integrations_server {}

  #count of deployments to be created
  count = var.elastic_deployments_count 
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
