az login

$subscriptions=$(az account list --query "[].{Name:name,subscriptionId:id}" --output json)

[int]$subscriptionCount = ($subscriptions | ConvertFrom-Json).count
$subscriptions = ($subscriptions | ConvertFrom-Json)
Write-Host "Found" $subscriptionCount "Subscriptions"
$i = 0
foreach ($subscription in $subscriptions)
{
  $subValue = $i
  Write-Host $subValue ":" $subscription.Name "("$subscription.SubscriptionId")"
  $i++
}
Do 
{
  [int]$subscriptionChoice = read-host -prompt "Select number & press enter"
} 
until ($subscriptionChoice -le $subscriptionCount)

Write-Host "You selected" $subscriptions[$subscriptionChoice].Name
az account set --subscription $subscription.SubscriptionId
##Set-AzContext -SubscriptionId $subscriptions[$subscriptionChoice].SubscriptionId
