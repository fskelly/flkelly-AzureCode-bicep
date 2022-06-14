# Set Key File Variable:
New-Variable -Name Key -Value $privateKeyPath

# Remove Inheritance:
  Icacls $Key /c /t /Inheritance:d

# Set Ownership to Owner:
  # Key's within $env:UserProfile:
    Icacls $Key /c /t /Grant ${env:UserName}:F

   # Key's outside of $env:UserProfile:
     TakeOwn /F $Key
     Icacls $Key /c /t /Grant:r ${env:UserName}:F

# Remove All Users, except for Owner:
  Icacls $Key /c /t /Remove:g Administrator "Authenticated Users" BUILTIN\Administrators BUILTIN Everyone System Users

# Verify:
  Icacls $Key

# Remove Variable:
  Remove-Variable -Name Key

$destinationIP = "simplelinuxvm-zlrmqvwfpmqrw.eastus.cloudapp.azure.com"
get-content $pubKeyPath | ssh $username@$destinationIp "cat >> .ssh/authorized_keys"