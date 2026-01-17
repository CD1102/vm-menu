# Set parameters

param(
    [Parameter(Mandatory = $true)]
    [string]$VMName,

    [Parameter(Mandatory = $true)]
    [string]$RGName,

    [Parameter(Mandatory = $true)]
    [ValidateSet("Start", "Stop", "Restart", "Status")]
    [string]$Action
)

# Checks to connect to Azure

try {
    $connected = Read-Host "Are you connected to Azure? (yes/no)"
    if ($connected.ToLower() -ne "yes") {
        Write-Output "You must be connected to Azure to run this script. A login option will show up shortly...."
        Connect-AzAccount 

    }
}
catch {
    Write-Output "Error connecting to Azure: $_"
    exit
}

# VM Operations
switch ($Action) {
    "Start" {
        try {
            Write-Output "Starting the VM..."
            Start-AzVM -Name $VMName -ResourceGroupName $RGName
            Write-Output "VM started."
        }
        catch {
            write-output(" ")
            Write-Output "Error starting the VM: $($_.Exception.Message)"
            start-sleep -seconds 2
        }
    }
    "Stop" {
        try {
            Write-Output "Stopping the VM..."
            Stop-AzVM -Name $VMName -ResourceGroupName $RGName -Force
            Write-Output "VM stopped."
        }
        catch {
            write-output(" ")
            Write-Output "Error stopping the VM: $($_.Exception.Message)"
            start-sleep -seconds 2
        }
    }
    "Restart" {
        try {
    
            Write-Output "Restarting the VM..."
            Restart-AzVM -Name $VMName -ResourceGroupName $RGName -ErrorAction Stop
            Write-Output "VM restarted."
        }
        catch {
            write-output(" ")
            Write-Output "Error restarting the VM: $($_.Exception.Message)"
            start-sleep -seconds 2
        }
    }
    "Status" {
        try {
            Write-Output "Getting VM Status..."
            $vm = Get-AzVM -Name $VMName -ResourceGroupName $RGName -Status
            $vmStatus = $vm.Statuses[1].DisplayStatus
            Write-Output "VM Status: $vmStatus"
        }
        catch {
            write-output(" ")
            Write-Output "Error getting VM status: $($_.Exception.Message)"
            start-sleep -seconds 2
        }
    }
            
    default {
        Write-Output "Invalid option."
    }
            
    }
   


