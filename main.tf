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
    //autoscale = "true" //acts on data nodes and ml nodes. If you set autoscale = true, ml nodes are not created by terraform but spinned up only on demand, even if you define their topology
    topology {
      id = "hot_content"
      zone_count = var.elastic_replicas #set this for HA. If omitted default value for the deployment template is used (often 2)
    }
    topology {
      id = "ml"
      size = var.ml_size
    }
    
    //add this if you want to load indexes from another deployment snapshot. USED FOR SPECIFIC HANDS-ON
    //if var.snapshot_name and var.snapshot_source_cluster_id are not set in variables.tf this block is ignored
    snapshot_source {
      snapshot_name = var.snapshot_name
      source_elasticsearch_cluster_id = var.snapshot_source_cluster_id
    }
    
  }

  kibana {
    topology {
      size = var.kibana_size
    }
  }
  integrations_server {}
  enterprise_search {
    topology {
      size = var.enterprise_search_size
    }
  }

  #count of deployments to be created
  count = var.elastic_deployments_count 
}

#This script will set user config - found in script/user_settings.json - for Elasticsearch.
data "external" "es_set_config" {
  count = var.elastic_deployments_count
  query = {
    elastic_http_method = "PUT"
    elastic_endpoint    = ec_deployment.custom-deployment-id[count.index].elasticsearch[0].https_endpoint
    elastic_username    = ec_deployment.custom-deployment-id[count.index].elasticsearch_username
    elastic_password    = ec_deployment.custom-deployment-id[count.index].elasticsearch_password
    elastic_json_body   = file(var.lab_user_settings) //change path in variables.tf according to the specific lab used
  }
  program = ["sh", "./scripts/es_set_config.sh"]
  depends_on = [ec_deployment.custom-deployment-id]
}

output "es_set_config" {
  value = data.external.es_set_config[*].result.acknowledged
  depends_on = [data.external.es_set_config]
}

# -------------------------------------------------------------
# PATENT SEARCH SPECIFIC CONFIG 
# Use this when using this script for patent-search demo, otherwise comment. 
# -------------------------------------------------------------

#This will create the overview sample Kibana Dashboard
data "external" "elastic_upload_saved_objects" {
  count = var.elastic_deployments_count 
  query = {
	elastic_http_method = "POST"
    kibana_endpoint  = ec_deployment.custom-deployment-id[count.index].kibana[0].https_endpoint
    elastic_username  = ec_deployment.custom-deployment-id[count.index].elasticsearch_username
    elastic_password  = ec_deployment.custom-deployment-id[count.index].elasticsearch_password
    so_file      		= "./patent-search-resources/dashboards/patent_search_dashboard_overview.ndjson"
  }
  program = ["sh", "./patent-search-resources/scripts/kb_upload_saved_objects.sh" ]
  depends_on = [ec_deployment.custom-deployment-id]
}

output "elastic_upload_saved_objects" {
  value = data.external.elastic_upload_saved_objects[*].result
  depends_on = [data.external.elastic_upload_saved_objects]
}

# -------------------------------------------------------------
# COMMON OUTPUT
# -------------------------------------------------------------
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
