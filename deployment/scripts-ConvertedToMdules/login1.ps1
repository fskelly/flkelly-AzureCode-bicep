    az login
    
    if ($subscriptionName -eq $null -or $subscriptionName -eq "") {
        # get all subscriptions and save into variable
        $subscriptions = $(az account list --query "[].{Name:name,subscriptionId:id}" --output json) | ConvertFrom-Json
    
        # get a count of subscriptions for loop
        [int]$subscriptionCount = $subscriptions.count
        
        # starting value for array for loop
        $i = 0
        foreach ($subscription in $subscriptions) {
            # start of menu - value = 0
            $subValue = $i
        
            # print out all subscriptions
            Write-Host $subValue ":" $subscription.Name "("$subscription.SubscriptionId")"
        
            # increment value
            $i++
        }
    
        Do {
            # repeat loop until valid number is chosen
            [int]$subscriptionChoice = read-host -prompt "Select number & press enter"
        }
    
        # exit criteria for loop
        until ($subscriptionChoice -le $subscriptionCount)
    
        Write-Host "You selected" $subscriptions[$subscriptionChoice].Name
        $subscriptionName = $subscriptions[$subscriptionChoice].Name
    }
    
    
    az account set --subscription $subscriptionName
    
    Write-host "Getting Access Token to Login to Powershell"
    
    $accountShowResponse = $(az account show --output json) | ConvertFrom-Json
    $accountId = $accountShowResponse.id
    $accessTokenResponse = $(az account get-access-token --output json) | ConvertFrom-Json
    $accessToken = $accessTokenResponse.accessToken
    
    Write-host "Logging in to Az PowerShell"
    
    Connect-AzAccount -AccountId $accountId -AccessToken $accessToken
    
    Write-host "Setting Az PowerShell Subscription to $subscriptionName"
    
    Get-AzSubscription -SubscriptionName $subscriptionName | Set-AzContext

