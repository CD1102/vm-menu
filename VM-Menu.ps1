# Select Subscription
function SubscriptionSelection {
    write-output "`nListing available subscriptions..."
    write-output " "
    $subscriptions = Get-AzSubscription | Select-Object -ExpandProperty Name
    for ($i = 0; $i -lt $subscriptions.count; $i++) {
        Write-Output "$($i + 1): $($subscriptions[$i])"
    }
    $subchoice = read-host "`nSelect a Subscription (Choose a number 1 - $($subscriptions.count))"
    while ($subchoice -notmatch '^\d+$' -or [int]$subchoice -gt $subscriptions.count -or [int]$subchoice -lt 1){
        write-host "Invalid Option, please try again" -ForegroundColor Red
        $subchoice = read-host "`nSelect a Subscription (Choose a number 1 - $($subscriptions.count))"
    }
    Select-AzSubscription -SubscriptionName $subscriptions[$subchoice - 1] | Out-Null
    Write-Output "`nSwitched to subscription: $($subscriptions[$subchoice - 1])"
}

# Checks to connect to Azure
function Connect-Azure {
    $azcontext = Get-AzContext
    try {
        if ($null -eq $azcontext) {
            Write-Output "You must be connected to Azure to run this script. A login option will show up shortly...."
            Connect-AzAccount
        }
        else {
            Write-Output "`nAlready connected as:  $($azcontext.Account.id)"
            SubscriptionSelection

        }
    }
    catch {
        Write-Output "Error connecting to Azure: $_"
        exit
    }
}



Connect-Azure



# Continue variable used to loop the menu
$continue = "y"

function usercontinue {
    # Ask if the user wants to continue
    write-output ""
    $continue = read-host "Do you wish to continue with the script? (y/n)"
    if ($continue.tolower() -eq "y") {
        Clear-Host
    }
    else {
        write-output "Exiting the script..."
        start-sleep -seconds 3
        exit
    }    
}

#Function to get RG and VM names
try {
    function Get-RGAndVM {
        write-output " "
        # Lists RG's in subscription with a VM
        Write-output "--------- Resource Groups ---------"
        write-output " "
        write-output "Loading Resource Groups..."
        $vms = get-azvm
        $vmrg = $vms | Select-Object -ExpandProperty ResourceGroupName | Sort-Object -Unique
        for ($i = 0; $i -lt $vmrg.count; $i++) {
            Write-Output "$($i + 1): $($vmrg[$i])"
        }
        
        $rgchoice = read-host "`nSelect a Resource Group (Choose a number 1 - $($vmrg.count))"
        while ($rgchoice -notmatch '^\d+$' -or [int]$rgchoice -gt $vmrg.count -or [int]$rgchoice -lt 1){
            write-host "Invalid Option, please try again" -ForegroundColor Red
            $rgchoice = read-host "`nSelect a Resource Group (Choose a number 1 - $($vmrg.count))"
        }

        Write-output "`n--------- Virtual Machines ---------"
        $vmlist = @(get-azvm -resourcegroupname $($vmrg[$rgchoice - 1]) | Select-Object -ExpandProperty Name)
        for ($i = 0; $i -lt $vmlist.count; $i++) {
            Write-Output "$($i + 1): $($vmlist[$i])"
        }
        $vmchoice = read-host "`nSelect a Virtual Machine (Choose a number 1 - $($vmlist.count))"
        while ($vmchoice -notmatch '^\d+$' -or [int]$vmchoice -gt $vmlist.count -or [int]$vmchoice -lt 1){
            write-host "Invalid Option, please try again" -ForegroundColor Red
            $vmchoice = read-host "`nSelect a Virtual Machine (Choose a number 1 - $($vmlist.count))"
        }

        $global:vmname = $vmlist[$vmchoice - 1]
        $global:rgname = $vmrg[$rgchoice - 1]

    }
}
catch {
    Write-Host "Error retrieving Resource Groups or Virtual Machines: $_" -ForegroundColor Red
}
Get-RGAndVM

# Main loop for the menu
while ($continue.ToLower() -eq "y") {
    # Menu options
    Write-output " "
    Write-output "--------- VM Menu for: $($global:vmname) ---------"
    write-output " "
    write-output "1: Start the VM"
    write-output "2: Stop the VM"
    write-output "3: Restart the VM"
    write-output "4: Get VM Information and Status"
    write-output "5: Change Resource Group or VM"
    write-output "6: Change Azure Subscription"
    write-output "7: Exit"
    write-output " "

    # User input
    $number = Read-Host "Select an option (1-7)"

    # VM Operations
    switch ($number) {
        1 { 
            Write-Output "Option 1 selected."
            Write-Output "Starting the VM..."
            try {
                Start-AzVM -Name $global:vmname -ResourceGroupName $global:rgname -ErrorAction Stop
                Write-Output "VM started."
            }
            catch {
                Write-Output "Error starting the VM: $_"
                usercontinue
            }
        }
        2 {
            Write-Output "Option 2 selected."
            Write-Output "Stopping the VM..."
            try {
                Stop-AzVM -Name $global:vmname -ResourceGroupName $global:rgname -Force -ErrorAction Stop
                Write-Output "VM stopped."
            }
            catch {
                Write-Output "Error stopping the VM: $_"
                usercontinue
            }
        }
        3 {
            Write-Output "Option 3 selected."
            Write-Output "Restarting the VM..."
            try {
                Restart-AzVM -Name $global:vmname -ResourceGroupName $global:rgname -ErrorAction Stop
                Write-Output "VM restarted."
            }
            catch {
                Write-Output "Error restarting the VM: $_"
                usercontinue
            }
        }
        4 {
            Write-Output "Option 4 selected."
            Write-Output "Getting VM Status..."
            try {
                $vm = Get-AzVM -Name $global:vmname -ResourceGroupName $global:rgname
                $vmStatus = Get-AzVM -Name $global:vmname -ResourceGroupName $global:rgname -Status
                $disk = Get-AzDisk -ResourceGroupName $vm.ResourceGroupName -DiskName $vm.StorageProfile.OsDisk.Name
                Write-Host "VM Name: $($vm.Name)" -ForegroundColor Yellow
                Write-Host "VM Resource Group: $($vm.ResourceGroupName)" -ForegroundColor Yellow
                Write-Host "VM Subscription: $((Get-AzContext).Subscription.Name)" -ForegroundColor Yellow
                Write-Host "VM Status: $($vmStatus.Statuses[1].DisplayStatus)" -ForegroundColor Yellow
                Write-Host "VM Location: $($vm.Location)" -ForegroundColor Yellow
                Write-Host "VM OS: $($vm.StorageProfile.OsDisk.OsType)" -ForegroundColor Yellow
                Write-Host "VM Date Creation: $($disk.TimeCreated)" -ForegroundColor Yellow
                Write-Host "VM Tags:" -ForegroundColor Yellow
                $vm.Tags | Format-Table -AutoSize
                start-sleep -seconds 3
            }
            catch {
                Write-Output "Error getting VM status: $_"
                usercontinue
            }
        }
        5 {
            try {
                Write-output "Option 5 selected."
                start-sleep -seconds 2
                Clear-Host
                Get-RGAndVM
            }
            catch {
                Write-Output "Error changing Resource Group or VM: $_"
                usercontinue
            }
        }
        6 {
            try {
                write-output "Option 6 selected."
                SubscriptionSelection
                start-sleep -seconds 3
                Clear-Host
                Get-RGAndVM
            }
            catch {
                Write-Output "Error changing Azure subscription: $_"
                usercontinue
            }
        }
        7 {
            try {
                Write-Output "Option 7 selected."
                Write-Output "Exiting the menu."
                start-sleep -seconds 5
                exit
            }
            catch {
                Write-Output "Error exiting the script: $_"
                usercontinue
            }
        }
        default {
            Write-Output "Invalid option. Please select a number between 1 and 7."
        }
    }


}