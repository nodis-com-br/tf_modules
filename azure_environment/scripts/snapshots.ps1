param([Parameter(Mandatory = $true)] [string] $ResourceGroupName)

$connectionName = "AzureRunAsConnection"

try {

    #Getting the service principal connection "AzureRunAsConnection"
    $servicePrincipalConnection = Get-AutomationConnection -name $connectionName
    "Logging into Azure..."
    Add-AzureRmAccount -ServicePrincipal -TenantID $servicePrincipalConnection.TenantID -ApplicationID $servicePrincipalConnection.ApplicationID -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint

} catch {

    if (!$servicePrincipalConnection) {

        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage

    } else {

        Write-Error -Message $_.Exception
        throw $_.Exception

    }

}

if ($err) { throw $err }

# Get VMs with snapshot tag

$tagResList = Get-AzureRmResource -ResourceGroupName $ResourceGroupName -TagName "Snapshot" -TagValue "true" | foreach { Get-AzureRmResource -ResourceId $_.resourceid }

foreach($tagRes in $tagResList) {

    if($tagRes.ResourceId -match "Microsoft.Compute")

    {

        $vmInfo = Get-AzureRmVM -ResourceGroupName $ResourceGroupName -Name $tagRes.ResourceId.Split("//")[8]

        Write-Output $vmInfo.Name

        #Set local variables
        $location = $vmInfo.Location
        $resourceGroupName = $vmInfo.ResourceGroupName
        $timestamp = Get-Date -f MM-dd-yyyy_HH_mm_ss

        #Snapshot name of OS data disk
        $snapshotName = $vmInfo.Name + $timestamp

        #Create snapshot configuration
        $snapshot = New-AzureRmSnapshotConfig -SourceUri $vmInfo.StorageProfile.OsDisk.ManagedDisk.Id -Location $location -CreateOption copy

        #Take snapshot
        New-AzureRmSnapshot -Snapshot $snapshot -SnapshotName $snapshotName -ResourceGroupName $resourceGroupName

        if ($vmInfo.StorageProfile.DataDisks.Count -ge 1) {

            #Condition with more than one data disks

            for ($i=0; $i -le $vmInfo.StorageProfile.DataDisks.Count - 1; $i++) {

                #Snapshot name of OS data disk
                $snapshotName = $vmInfo.StorageProfile.DataDisks[$i].Name + $timestamp

                #Create snapshot configuration
                $snapshot = New-AzureRmSnapshotConfig -SourceUri $vmInfo.StorageProfile.DataDisks[$i].ManagedDisk.Id -Location $location -CreateOption copy

                #Take snapshot
                New-AzureRmSnapshot -Snapshot $snapshot -SnapshotName $snapshotName -ResourceGroupName $resourceGroupName

            }

        } else { Write-Host $vmInfo.Name + " doesn't have any additional data disk." }

    } else { $tagRes.ResourceId + " is not a compute instance" }

}

$now = Get-Date

foreach($snap in Get-AzureRmSnapshot -ResourceGroupName $ResourceGroupName) {

    $SnapAge = New-TimeSpan –Start $snap.TimeCreated –End $now

    if ($SnapAge -gt (New-TimeSpan -Days 7)) {

        Remove-AzureRmSnapshot -ResourceGroupName $ResourceGroupName -SnapshotName $snap.name -Force -AsJob

    }

}