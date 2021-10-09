param(
    [Parameter(Mandatory = $true)] [string] $ResourceGroupName,
    [Parameter(Mandatory = $true)] [string] $Namespace
)

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

$tagResList = Get-AzureRmResource -ResourceGroupName $ResourceGroupName -TagName "kubernetes.io-created-for-pvc-namespace" -TagValue $Namespace | ForEach-Object { Get-AzureRmResource -ResourceId $_.resourceid }

foreach($tagRes in $tagResList) {

    if($tagRes.ResourceId -match "Microsoft.Compute")

    {

        $diskInfo = Get-AzureRmDisk -ResourceGroupName $ResourceGroupName -Name $tagRes.ResourceId.Split("//")[8]

        #Set local variables
        $location = $diskInfo.Location
        $resourceGroupName = $diskInfo.ResourceGroupName
        $timestamp = Get-Date -f yyyy-MM-dd_HH_mm_ss

        #Snapshot name of OS data disk
        $snapshotName = $diskInfo.Name + "_" + $Namespace + "_" + $timestamp

        #Create snapshot configuration
        $snapshot = New-AzureRmSnapshotConfig -SourceUri $diskInfo.Id -Location $location -CreateOption copy

        #Take snapshot
        New-AzureRmSnapshot -Snapshot $snapshot -SnapshotName $snapshotName -ResourceGroupName $resourceGroupName

    } else { $tagRes.ResourceId + " is not a disk" }

}

$now = Get-Date

foreach($snap in Get-AzureRmSnapshot -ResourceGroupName $ResourceGroupName -TagName "kubernetes.io-created-for-pvc-namespace" -TagValue $Namespace) {

    $SnapAge = New-TimeSpan –Start $snap.TimeCreated –End $now

    if ($SnapAge -gt (New-TimeSpan -Days 7)) {

        Remove-AzureRmSnapshot -ResourceGroupName $ResourceGroupName -SnapshotName $snap.name -Force -AsJob

    }

}