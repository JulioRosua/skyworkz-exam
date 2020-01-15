param(
	[Parameter(Mandatory=$True)][string] $resourceGroupName,
	[Parameter(Mandatory=$True)][string] $templateFilePath
 )


$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue

if(!$resourceGroup)
{
    Write-Host "Resource group '$resourceGroupName' does not exist. To create a new resource group, please enter a location.";
    Write-Host "Creating resource group '$resourceGroupName' in location westEurope";
    New-AzureRmResourceGroup -Name $resourceGroupName -Location westEurope
}
else{
    Write-Host "Using existing resource group '$resourceGroupName'";
}

Write-Host "Starting deployment...";
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath;
