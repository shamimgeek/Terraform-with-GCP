Terraform-with-GCP
=================

Requirement:
------------ 
- terrform version : v0.12.23
- Service-Account on gcp
- Projectid on gcp
- `service-account.json` file

How to use
----------
```
terraform init
terraform plan
terraform apply
```
SSH to VM:
----------
```
ssh -i /home/sakhtar/.ssh/id_rsa.pub `terraform output ip`
```
Test the application
--------------------
```
curl http://<IP of your VM>
Hello from Google Cloud !!!
```

Destroy:
--------
```
terraform destroy
```
