<#
This script is designed to remove specific Computers from a VBR Protection Group utilizing Individual Computers.

The computer names should be listed in the array of items to remove.

The Protection Group to be checked should also be listed in the correct variable.

A new list of Computers will be created of all computers in the group minus those in the remove array.

The Protection Group will be updated with the new list of PCs to keep and then a rescan will commense to remove the computers.

#>


# Protection Group in which to remove servers
$ProtectionGroupToRemoveFrom = "Protection Group 1"

# This list is comma separated. Each name or IP between double quotes and with a comma after all but the last.
$ComputersToRemove = @(
    "server1",
    "192.168.20.97",
    "server2.my.domain"

)

$group = Get-VBRProtectionGroup -Name $ProtectionGroupToRemoveFrom
$comp = $group.Container.CustomCredentials

$newGroup = @()

foreach($c in $comp){
    if($c.HostName -notin $ComputersToRemove){
        $newGroup += $c
    }


}

$newComp = Set-VBRIndividualComputerContainer -Container $group.Container -CustomCredentials $newGroup
Set-VBRProtectionGroup -ProtectionGroup $group -Container $newComp
Rescan-VBREntity -Entity $group