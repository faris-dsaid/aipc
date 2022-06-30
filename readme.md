# aipc
Automating Infrastructure Course
Pre-Course Submission


# Ansible Notes
```
sudo ansible-playbook -i inventory.yaml playbook.yaml
```
# Packer Notes
```
packer init config.pkr.hcl
packer build -var-file=variables.pkrvars.hcl images.pkr.hcl
```