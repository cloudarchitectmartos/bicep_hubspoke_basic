# Step 1: Connects to your Azure:

#Connect-AzAccount # Connects via Web Browser or,
#Connect-AzAccount -UseDeviceAuthentication # You can specify the UseDeviceAuthentication parameter to use device code authentication instead of a browser control or,
#Connect-AzAccount -Tenant '00000000-0000-0000-0000-000000000000' # Targets a Tenant for Connection, or
#Connect-AzAccount `
#    -Tenant '00000000-0000-0000-0000-000000000000' `
#    -UseDeviceAuthentication

$tenantID = '<TENANT_ID>'
Connect-AzAccount `
    -Tenant  $tenantID `
    -UseDeviceAuthentication `
    -verbose


# Step 2: Sets a Target Subscription where to deploy all resources for the rest of this project    

# Set the default subscription for all of the Azure PowerShell commands that you run in this session.

# Get the subscription ID
# $subscriptionId = Get-AzSubscription -SubscriptionName '<Subscription_Name_Here>' # passes the subscription 
$subscriptionId = Get-AzSubscription -SubscriptionName '<Subscription_Name>'
Set-AzContext $subscriptionId # Set a default subscription where resoruces will be created.

#Checks for existing Resource Groups and displays on the screen
$ErrorActionPreference =  "Stop"  
try {
    $rgs =  Get-AzResourceGroup
    foreach  ($rg in $rgs.ResourceGroupName) {
        Write-Output  "Checking Resource Group: $rg"
        Get-AzResource  -ResourceGroupName $rg `
        | Select Name, ResourceGroupName, Type, Location `
        | Export-Csv  .\AzureResources.csv -Append  -Force  -NoTypeInformation
    }
}  
catch {
    Write-Host "$($_.Exception.Message)" -BackgroundColor  DarkRed
}

# Step 3: Creates Resource Groups for IaC Deployment

## Creates a new Resource Group
### Parameters to Control the target resource group creation:
#### $RGroupName = "<Add resource group name>"
#### $RGroupLocation = "<Add location name>"
$RGroupName = "<Add_RG_Name>"
$RGroupLocation = "<Add_location_name>"
### Add/Modify Tags of your Choice
$ResourceGroupTags = @{
    "Environment" = "TEST";
    "SystemCriticality" = "LOW";
    "BusinessOwner" = "GeeksforGeeks";
    "BusinessOwnerEmail" = "gfg@gfg.com";
    "CostCenter" = "XYZ";
    "SupportTeam" = "XYZ"
}

# Create Resource Group
New-AzResourceGroup \
    -Name $RGroupName \
    -Location $RGroupLocation \
    -Tag $ResourceGroupTags

# You can set the default resource group and omit the parameter from the rest of the Azure PowerShell commands in this exercise. Set this default to the resource group created for you in the sandbox environment.
## Defines the scope where resource group will exist.
### Set-AzDefault -ResourceGroupName $RGGroupName
Set-AzDefault -ResourceGroupName $RGGroupName
## Undo the action above to remove the default location where resource management actions should be executed.
### Clear-AzDefault -ResourceGroup 

# Now you can start your code and reuse the resource group variable in your code when needed.
New-AzResoruceGroupDeployment -TemplateFile main.bicep 

# Creates multiple resoruce groups:
for ($i =0; $i -lt 10; $i++){
    $i
    New-AzResoruceGroupDeployment -TemplateFile main.bicep  -name "modname$i"
}

Export-AzResourceGroup -ResourceGroupName $RGGroupName