## Spwan EKS in AWS with terraform

based on https://learn.hashicorp.com/terraform/aws/eks-intro

### Prerequisite

- Terraform >= v0.12
- Ansible >= 2.6

### Run

```
cd devops/terraform-revamp

terraform init

terraform plan

terraform apply

```

### Connecting to k8s

```
export AWS_ACCESS_KEY_ID=xxx
export AWS_SECRET_ACCESS_KEY=xxx

terraform output kubeconfig > ~/.kube/wcl.aws.config
export KUBECONFIG=~/.kube/wcl.aws.config

# terraform output config-map-aws-auth > ../k8s/config-map-aws-auth.yml

# kubectl apply -f ../k8s/config-map-aws-auth.yml

watch "kubectl get nodes"
```