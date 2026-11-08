# How to Run

In `terraform.tfvars`, set the `full_path_ssh_public_key` variable.

```sh
cd terraform-ec2
aws login
aws sts get-caller-identity
export AWS_PROFILE=default
terraform init
terraform plan
terraform apply
```

`terraform apply` will output two public IP addresses. Add these IPs to `ansible/inventory.init`.

Before running Ansible, add the following line to your `~/.ssh/config`:

```sshconfig
StrictHostKeyChecking no
```

When connecting to a server for the first time, SSH normally prompts you to add the server's public host key to `~/.ssh/known_hosts`. This prompt causes Ansible to fail because it cannot be answered interactively. The configuration above disables this check.

```sh
cd ansible
source .venv/bin/activate
ansible-playbook site.yml --ask-become-pass --ask-vault-pass
```

Both servers will be accessible at:

- https://42blog.duckdns.org
- https://43blog.duckdns.org

phpMyAdmin is available at the `/phpmyadmin` path on both servers.

The login credentials for WordPress and phpMyAdmin are stored in `roles/wordpress/vars/main.yml`.