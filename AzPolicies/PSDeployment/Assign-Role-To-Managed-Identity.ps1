Param(
    [Parameter(Mandatory = $True)]
    [String]
    $DefinitionName,
    [Parameter(Mandatory = $True)]
    [String]
    $AssignmentName
)
$definition = Get-AzPolicyDefinition -Name $DefinitionName
$assignment = Get-AzPolicyAssignment -Name $AssignmentName
$roleDefinitionIds = $definition.Properties.policyRule.then.details.roleDefinitionIds

if ($roleDefinitionIds.Count -gt 0) {
    $roleDefinitionIds | ForEach-Object {
        $roleDefId = $_.Split("/") | Select-Object -Last 1
        New-AzRoleAssignment -Scope $Subscription -ObjectId $assignment.Identity.PrincipalId -RoleDefinitionId $roleDefId
    }
}