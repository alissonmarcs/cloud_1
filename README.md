## How to Run

Dependencies: Vagrant and VirtualBox

### Start the Debian VM

```bash
vagrant up
```

The VM has a user named `vagrant` with the password `vagrant`. Ansible will use these credentials to establish an SSH connection.

### Install Ansible on Your Host Machine (Control Node)

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install ansible
```

Also, install the community collections and roles required for Ansible to work with Docker:

```bash
(.venv) $ ansible-galaxy collection install community.docker
(.venv) $ ansible-galaxy role install geerlingguy.docker
```

### Install Docker on the VM Using Ansible

```bash
(.venv) $ ansible-playbook -i inventory.init install_docker_playbook.yml --ask-pass
```

- `-i inventory.init` tells Ansible which IP address and username to use for the SSH connection.
- `--ask-pass` prompts you for the password used to establish the SSH connection.
- `install_docker_playbook.yml` defines the operations required to install Docker and specifies the remote hosts on which to execute them, as listed in `inventory.init`.

### Start the WordPress Containers Using Ansible

```bash
(.venv) $ ansible-playbook -i inventory.init start_wordpress_playbook.yml --ask-pass
```

WordPress is accessible from your host machine at `http://192.168.56.110:8080`.

To access the WordPress admin panel, open http://192.168.56.110:8080/wp-admin/ in your browser and use `wp_cli` as both the username and password.

### Vagrant VM Lifecycle Commands

Start the VM:

```bash
vagrant up
```

Open a Bash shell in the VM:

```bash
vagrant ssh
```

Stop the VM:

```bash
vagrant halt
```

Delete the VM:

```bash
vagrant destroy -f
```