## Spawn EKS in AWS with terraform

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
curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl

# install aws-iam-authenticator: https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.15.10/2020-02-22/bin/linux/amd64/aws-iam-authenticator


export AWS_ACCESS_KEY_ID=xxx
export AWS_SECRET_ACCESS_KEY=xxx

terraform output kubeconfig > ~/.kube/eks.config

export KUBECONFIG=~/.kube/eks.config


# only needed for self-created autoscaling group
terraform output config-map-aws-auth > ../k8s/config-map-aws-auth.yml
kubectl apply -f ../k8s/config-map-aws-auth.yml

kubectl get nodes
```
