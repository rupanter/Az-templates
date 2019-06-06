<#
> Example :
.\Deploy-RedirectionPolicy.ps1 -SubscriptionID "f28f2c24-XXXX-XXXX-XXXX-0ef3r09c0578" -WorkspaceName "BasictestingOMS" -WorkspaceID "c9098c5c-XXXX-XXXX-XXXX-fd99fyu6e134" -Policyfile "Demo/MMA-Installation-Windows-TagONLY-Policy.rules.JSON" -Parameterfile "Demo/MMA-Installation-Windows-TagONLY-Policy.parameters.JSON"

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
    $Parameterfile
)
$location = 'eastus'
#Update -Policy and -Parameter
$definition = New-AzPolicyDefinition -Name "Redirection-MMA-Windows" -DisplayName "Redirection-MMA-Windows-Definition" -description "This policy redirects the Microsoft Monitoring Agent to a specified Log Analytics Workspace." -Policy $Policyfile -Parameter $Parameterfile -Mode All
$definition
$Subscription = "/subscriptions/" + $SubscriptionID
$assignment = New-AzPolicyAssignment -Name "Redirection-MMA-Windows-Assignment" -PolicyDefinition $Definition -Scope $Subscription -AssignIdentity -location $location -logAnalytics $WorkspaceName -workspaceID $workspaceID
$assignment