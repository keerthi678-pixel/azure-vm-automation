#!/bin/bash

# === Configuration ===
output="$HOME/clouddrive/vm_cpu_utilization_may_june_2025.csv"
start_date="2025-06-01T00:00:00Z" 
end_date="2025-06-30T23:59:59Z"

# === Header ===
echo "VM Name,Resource Group,Date,Max CPU %" > "$output"

# Get current subscription ID
subscription_id=$(az account show --query id -o tsv)

# Get list of all VMs
az vm list --query "[].{name:name, resourceGroup:resourceGroup}" -o tsv | while read -r vmname rg; do
    echo "[INFO] Processing $vmname in $rg..."

    tmpfile=$(mktemp)

    az monitor metrics list \
        --resource "/subscriptions/$subscription_id/resourceGroups/$rg/providers/Microsoft.Compute/virtualMachines/$vmname" \
        --metric "Percentage CPU" \
        --interval P1D \
        --aggregation Maximum \
        --start-time "$start_date" \
        --end-time "$end_date" \
        --output json > "$tmpfile"

    if jq -e '.value[0].timeseries[0].data | length == 0' "$tmpfile" > /dev/null 2>&1; then
        echo "[WARN] No CPU data for $vmname in $rg"
        rm -f "$tmpfile"
        continue
    fi

    jq -r --arg vm "$vmname" --arg rg "$rg" '
      .value[0].timeseries[0].data[] |
      select(.maximum != null) |
      [$vm, $rg, .timeStamp[0:10], (.maximum | tostring)] |
      @csv' "$tmpfile" >> "$output"

    rm -f "$tmpfile"
done

sort -t, -k3 "$output" -o "$output"
echo -e "\n Report ready: $output"
