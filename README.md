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
Deployment: sf-hackathon-test-01
  kibanaEndpoint  = "https://<id-01>.us-west1.gcp.cloud.es.io:9243"
  adminUsername   = "elastic"
  adminPassword   = "<password-01>"
  elasticEndpoint = "https://<id-01>.us-west1.gcp.cloud.es.io:443"
  cloudId         = "sf-hackathon-test-01:<data-01>"

Deployment: sf-hackathon-test-02
  kibanaEndpoint  = "https://<id-02>.us-west1.gcp.cloud.es.io:9243"
  adminUsername   = "elastic"
  adminPassword   = "<password-02>"
  elasticEndpoint = "https://<id-02>.us-west1.gcp.cloud.es.io:443"
  cloudId         = "sf-hackathon-test-02:<data-02>"

  ...
```
The same command will also generate a "created_deployments_summary.txt" file with the same output for easy sharing.

6. After the hands-on event, destroy the instances

```bash
terraform destroy
```

## References:

* [Generating an API Key](https://registry.terraform.io/providers/elastic/ec/latest/docs#api-key-authentication-recommended)
