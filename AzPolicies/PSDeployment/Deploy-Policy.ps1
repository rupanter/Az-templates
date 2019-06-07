<#
> NOTE :
This script will work at the Subscription Scope unless you specify ResourceGroupName.
Please update values for $PolicyName and $AssignmentName
Please change the Input parameters if you are deploying some other Policy as this is specific to the Monitoring Policies.

> Example :
.\Deploy-Policy.ps1
.\Deploy-Policy.ps1 -SubscriptionID "f28f2c24-XXXX-XXXX-XXXX-0ef3r09c0578" -tagname "MMA" -WorkspaceName "BasictestingOMS" -WorkspaceID "c9098c5c-XXXX-XXXX-XXXX-fd99fyu6e134" -Policyfile "Demo/MMA-Installation-Windows-TagONLY-Policy.rules.JSON" -Parameterfile "Demo/MMA-Installation-Windows-TagONLY-Policy.parameters.JSON"
.\Deploy-Policy.ps1 -SubscriptionID "f28f2c24-XXXX-XXXX-XXXX-0ef3r09c0578" -ResourceGroupName "RGDemo" -tagname "MMA" -WorkspaceName "BasictestingOMS" -WorkspaceID "c9098c5c-XXXX-XXXX-XXXX-fd99fyu6e134" -Policyfile "Demo/MMA-Installation-Windows-TagONLY-Policy.rules.JSON" -Parameterfile "Demo/MMA-Installation-Windows-TagONLY-Policy.parameters.JSON"

Author :
Rupanter Chhabra
Rupanter.Chhabra@microsoft.com
Microsoft Corporation
#>
Param(
    [Parameter(Mandatory = $True)]
    [String]
    $SubscriptionID,
    [Parameter(Mandatory = $True)]
    [String]
    $WorkspaceName,
    [Parameter(Mandatory = $True)]
    [String]
    $workspaceID,
    [Parameter(Mandatory = $False)]
    [String]
    $location,
    [Parameter(Mandatory = $True)]
    [String]
    $Policyfile,
    [Parameter(Mandatory = $True)]
    [String]
    $Parameterfile,
    [Parameter(Mandatory = $False)]
    [String]
    $ResourceGroupName,
    [Parameter(Mandatory = $True)]
    [String]
    $tagname
)

Set-AzContext -Subscription $SubscriptionID

#variables that can be change/updated
$location = 'eastus'
$PolicyName = "AME-" + $SubscriptionID + "-Definition"
$assignmentName = "AME-" + $SubscriptionID + "-Assignment"

#defining the Policy
$definition = New-AzPolicyDefinition -Name $PolicyName -DisplayName "AME Policy" -description "AME Policy" -Policy $Policyfile -Parameter $Parameterfile -Mode All
$definition

#For Subscription level scope
if (!$ResourceGroupName) {
    $Subscription = "/subscriptions/" + $SubscriptionID
    $assignment = New-AzPolicyAssignment -Name $assignmentName -PolicyDefinition $Definition -Scope $Subscription -AssignIdentity -location $location -logAnalytics $WorkspaceName -workspaceID $workspaceID -tagname $tagname
    $assignment
}

#For Resource level scope
if ($ResourceGroupName) {
    $ResourceGroup = Get-AzResourceGroup -Name $ResourceGroupName
    $assignment = New-AzPolicyAssignment -Name $assignmentName -PolicyDefinition $Definition -Scope $ResourceGroup.ResourceId -logAnalytics $WorkspaceName -workspaceID $workspaceID -tagname $tagname
    $assignment
}
