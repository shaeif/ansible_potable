# Portable Ansible Environment

This project provides a fully self-contained, portable Ansible environment designed for **air-gapped systems**. It includes:
- A local Python virtual environment with Ansible installed
- All required collections downloaded and stored locally
- A custom `ansible.cfg` ensuring portability
- Wrapper script for environment activation

---

## 📁 Directory Structure

ansible_portable/ ├── ansible_py/              # Python virtual environment with Ansible ├── collections/             # All Ansible collections (offline) ├── inventory/               # Inventory files (INI/YAML) ├── playbooks/               # Playbooks and roles │   └── roles/               # Custom roles for playbooks ├── facts_cache/             # Cached facts (optional) ├── ansible.cfg              # Customized Ansible configuration ├── activate_ansible.sh      # Wrapper script to activate the environment ├── requirements.yml         # Required Ansible collections └── README.md                # Documentation


---

## 🛠️ Setup Instructions

### 🔁 1. Activating the Environment

```bash
source activate_ansible.sh

This will:

Activate the Python virtual environment

Set required Ansible environment variables

Ensure Ansible uses only local collections and Python


✅ 2. Check Setup

Run:

ansible --version

You should see paths pointing to the ansible_py/ virtual environment and collections/.


---

📦 Installing Collections (Pre-export Step)

On an internet-connected machine:

ansible-galaxy collection install -r requirements.yml --collections-path ./collections

Then copy the entire ansible_portable/ folder to the air-gapped system.


---

⚙️ Configuration (ansible.cfg)

Key settings include:

Local collection and role paths

Interpreter set to the virtualenv Python

Logging and deprecation warnings disabled

Fact caching enabled (JSON file)



---

📁 Example Inventory

inventory/hosts:

[localhost]
127.0.0.1 ansible_connection=local ansible_python_interpreter=./ansible_py/bin/python3


---

🧪 Testing

Run a simple playbook like:

ansible-playbook playbooks/ping.yml

Where ping.yml contains:

- name: Test Connectivity
  hosts: all
  tasks:
    - name: Ping
      ansible.builtin.ping:


---

📤 Air-Gapped Transfer

Simply compress the ansible_portable/ folder:

tar -czf ansible_portable.tar.gz ansible_portable/

Then move it to the target system and extract it:

tar -xzf ansible_portable.tar.gz
cd ansible_portable
source activate_ansible.sh


---

🙋‍♂️ Maintainer

Shaeif Thajudheen
Custom portable automation setup for isolated systems.
