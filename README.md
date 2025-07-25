# Azure VM Automation Scripts

This repository contains scripts to manage Azure Virtual Machines:

## 📝 Scripts

### 1. `vm_cpu_report.sh`
A Bash script that:
- Generates a report of **daily maximum CPU usage** for all VMs
- Outputs to a CSV file

**Usage**:
```bash
bash vm_cpu_report.sh

Requires: az CLI, jq, access to Monitor Metrics

2. resize_vm.py
A Python script that:

Deallocates a VM

Changes its size (SKU)

Starts the VM again

Usage:

bash
pip install azure-identity azure-mgmt-compute
az login
python resize_vm.py
Requires: Azure CLI login and Contributor role

📂 Structure
bash
azure-vm-automation/
│
├── vm_cpu_report.sh   # Bash script for CPU utilization report
├── resize_vm.py       # Python script to resize VMs
└── README.md          # This file
🔐 Permissions
Make sure the identity you're using has proper access to:

Read VM metrics

Resize and start/stop VMs

4. Commit the changes to `README.md`

---

## ✅ Final Output

Now your repo has:
- `vm_cpu_report.sh` (Bash)
- `resize_vm.py` (Python)
- `README.md` (documentation)

---




