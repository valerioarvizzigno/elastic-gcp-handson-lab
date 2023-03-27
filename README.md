# Elastic Hands-on Labs + GCP Scenarios
Terraform scripts for provisioning multiple identical elastic cloud deployments for partners/customer hands on lab.
All created environments' endpoints and credentials are outputed in a text file to be easily shared to partecipants.

You can also enable specific Google Cloud scenarios following dedicated sections below.

Credits to original repos on which this is inspired: 

https://github.com/eric-lowry/sf-hackathon-tf (Eric Lowry)

https://github.com/MarxDimitri/solution-accelerators (Dimitri Marx)

## Base deployment - Instructions

1. Clone this repo
2. Create an override.tf with your apikey
3. Create your own variables.tf and fill it with the requirements for your deployment. A complete example is provided.
4. Editing main.tf file is only needed if you want to change your deployment's name convention.
5. Run terraform

```bash
terraform init
terraform plan
terraform apply
```

5. List deployments details

```bash
terrform output -json | ./list-deployments.js
```

This will generate a report that looks like this:

```
Deployment: gcp-lab-01
  kibanaEndpoint  = "https://<id-01>.us-west1.gcp.cloud.es.io:9243"
  adminUsername   = "elastic"
  adminPassword   = "<password-01>"
  elasticEndpoint = "https://<id-01>.us-west1.gcp.cloud.es.io:443"
  cloudId         = "gcp-lab-01:<data-01>"

Deployment: gcp-lab-02
  kibanaEndpoint  = "https://<id-02>.us-west1.gcp.cloud.es.io:9243"
  adminUsername   = "elastic"
  adminPassword   = "<password-02>"
  elasticEndpoint = "https://<id-02>.us-west1.gcp.cloud.es.io:443"
  cloudId         = "gcp-lab-02:<data-02>"

  ...
```
The same command will also generate a "created_deployments_summary.txt" file with the same output for easy sharing.

6. After the hands-on event, destroy the instances

```bash
terraform destroy
```

## Patent Search - BigQuery/Dataflow/Elastic

This hands-on lab is made for showing the integrations between Google data services (BigQuery, Dataflow) and Elastic search capabilities.
All resources related to this specific use-case can be found in "patent-search-resources" folder.

If this specific scenario is activated (uncommenting the specific lines in terraform main.tf) the Elastic deployments created in "Base Deployment" step will also be automatically enriched with:

1. Patent Overview Kibana Dashboard 
2. Specific elastic cluster user settings (see patent-searc-resources/config/user_settings.json)
3. Snapshot recover for patent data (Optional - use this if you don't want to run Dataflow job but create clusters with data already in)
4. BigQuery + Dataflow job automatic configuration and run (Optional - if you want the dataflow job to run automatically when launching terraform)

Depending on the play you want to show to your attendees you can choose to leverage step 4 or 5 of the previous list.
For instance, if attendeed have not a GCP environment to use for the lab, you can use Step 3 (Snapshot restore) to provide Elastic deployments already filled with data and just show Dataflow job manual creation on GCP without running it.

...more info and configuration tips on this scenario coming soon...


## References:

* [Generating an API Key](https://registry.terraform.io/providers/elastic/ec/latest/docs#api-key-authentication-recommended)
