param(
    [Parameter(Mandatory=$True)]
    [String]
    $SubscriptionID,
    [Parameter(Mandatory=$True)]
    [String]
    $LogAnalytics,
    [Parameter(Mandatory=$True)]
    [String]
    $workspaceID,
    [Parameter(Mandatory=$False)]
    [String]
    $location
)
$location = 'eastus'
$definition = New-AzPolicyDefinition -Name "Redirection-MMA-Windows" -DisplayName "Redirection-MMA-Windows-Definition" -description "This policy redirects the Microsoft Monitoring Agent to a specified Log Analytics Workspace." -Policy 'https://msazure.visualstudio.com/One/_git/AzureCXP-AME-LoadTest?path=%2FDemo%2FMMA-Redirection-Windows-Policy.rules.JSON&version=GBruchh' -Parameter 'https://msazure.visualstudio.com/One/_git/AzureCXP-AME-LoadTest?path=%2FDemo%2FMMA-Redirection-Windows-Policy.parameters.JSON&version=GBruchh' -Mode All
$definition
$Subscription = "/subscriptions/" + $SubscriptionID
$assignment = New-AzPolicyAssignment -Name "Redirection-MMA-Windows-Assignment" -PolicyDefinition $Definition -Scope $Subscription -AssignIdentity -location $location -logAnalytics $loganalytics -workspaceID $workspaceID
$assignment