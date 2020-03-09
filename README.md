## Spwan EKS in AWS with terraform

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
# install kubectl: https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html

# install aws-iam-authenticator: https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html

export AWS_ACCESS_KEY_ID=xxx
export AWS_SECRET_ACCESS_KEY=xxx

terraform output kubeconfig > ~/.kube/eks.config
export KUBECONFIG=~/.kube/eks.config

kubectl get nodes
```