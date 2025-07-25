from azure.identity import DefaultAzureCredential
from azure.mgmt.compute import ComputeManagementClient

# Replace with your values
subscription_id = '12612e19-5a84-4ffb-a689-b8692a31eeee'
resource_group = 'PEARLWEBSITE-RG'
vm_name = 'scalingtestvm'
new_vm_size = 'Standard_B2ms'  # Desired size (you can change it)

credential = DefaultAzureCredential()
compute_client = ComputeManagementClient(credential, subscription_id)

print(f"Deallocating VM '{vm_name}'...")
deallocate_poller = compute_client.virtual_machines.begin_deallocate(resource_group, vm_name)
deallocate_poller.result()
print("VM deallocated.")

print(f"Updating VM size to '{new_vm_size}'...")
vm = compute_client.virtual_machines.get(resource_group, vm_name)
vm.hardware_profile.vm_size = new_vm_size
update_poller = compute_client.virtual_machines.begin_create_or_update(resource_group, vm_name, vm)
update_poller.result()
print("VM size updated.")

print("Starting VM...")
start_poller = compute_client.virtual_machines.begin_start(resource_group, vm_name)
start_poller.result()
print("VM started successfully.")
