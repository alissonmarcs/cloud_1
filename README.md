## How to Run

Dependencies: Vagrant and VirtualBox

### Start the Debian VM

```bash
vagrant up
```

The VM has a `vagrant` user. Vagrant forwards its SSH service to `127.0.0.1:2222` and creates a private key in `.vagrant/`. The Ansible inventory uses this endpoint. This works from Windows and WSL without direct access to the VirtualBox-only address.

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

### Run the Playbook from WSL

```bash
source .venv/bin/activate
cd ansible
ansible-playbook site.yml
```

- `ansible.cfg` loads `inventory.init` automatically.
- The inventory connects through Vagrant's forwarded SSH endpoint and private key.
- The playbook needs no `--ask-pass` option.

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
