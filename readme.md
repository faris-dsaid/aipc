# Automating Infrastructure & Provisioning Course

## [Terraform](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs)

```
terraform init
terraform plan
terraform apply
terraform destroy
```

## [Ansible](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/)

```
sudo ansible-playbook -i inventory.yaml playbook.yaml
```

## [Packer](https://www.packer.io/plugins)

```
packer init config.pkr.hcl
packer build -var-file=variables.pkrvars.hcl images.pkr.hcl
```