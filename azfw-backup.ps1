# ENABLE FOR LOCAL DEVELOPMENT

#$azureAccountName = $env:APP_ID
#$azurePassword = ConvertTo-SecureString $env:SECRET -AsPlainText -Force

#$psCred = New-Object System.Management.Automation.PSCredential($azureAccountName, $azurePassword)

#Connect-AzAccount -ServicePrincipal -Credential $psCred -Tenant $env:TENANT_ID

# Get all subscriptions in the current tenant
$subscriptions = (Get-AzSubscription).id

foreach ($sub in $subscriptions) {
  # set subscription to loop through
  Select-AzSubscription -SubscriptionId $sub

  # get the azure firewalls in the subscription
  $fws = Get-AzFirewall

  foreach ($fw in $fws) {
    #get resource group and resource id of each firewall in the subscription and set export filename
    $rg = $fw.ResourceGroupName
    $fwbackupfile = "{0}.json" -f $fw.name
    $fwbackuppath = Join-Path $pwd $fwbackupfile
    $id = $fw.id

    # export template to file
    Export-AzResourceGroup -ResourceGroupName $rg -Resource $id -SkipAllParameterization -Path $fwbackuppath -force

    # get the policy associated with each firewall and set export filename
    $policybackupfile = "{0}-policy.json" -f $fw.name
    $policybackuppath = Join-Path $pwd $policybackupfile
    $policyid = $fw.FirewallPolicy.id
    
    # export template to file
    Export-AzResourceGroup -ResourceGroupName $rg -Resource $policyid -SkipAllParameterization -Path $policybackuppath -force
  }
}