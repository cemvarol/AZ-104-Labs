Get-AzKeyVaultSecret -VaultName cvaz0221x2kv -Name cemo


$secret = Get-AzKeyVaultSecret -VaultName cvaz0221x2kv -Name cemo
$ssPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret.SecretValue)
try {
   $secretValueText = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ssPtr)
} finally {
   [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ssPtr)
}
Write-Output $secretValueText
