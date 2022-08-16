function New-AadAppRegistration {
    <#
.SYNOPSIS
    This script creates a new app registration with a certificate or secret.
.DESCRIPTION
    This script creates a new app registration with a certificate or secret.
.EXAMPLE
    To create an app registration with a secret that lasts 1 year, choose a name for $AppRegName, a name for $ClientSecretName and set $ClientSecretDuration to 1.
.INPUTS
    New-AppRegistration -AppRegName <String> -ClientSecretName <String> -EndDate <String> [-Append <Boolean>] [-CreateCert <Boolean>] [-CertName <String>] [-KeyVaultName <String>]
    [<CommonParameters>]

    New-AppRegistration -AppRegName <String> -ClientSecretName <String> -ClientSecretDuration <Int32> [-Append <Boolean>] [-CreateCert <Boolean>] [-CertName <String>] [-KeyVaultName
    <String>] [<CommonParameters>]
.OUTPUTS
    New app registration with credentials, and variables with the ID and secret.
.NOTES
#>
    [CmdletBinding(DefaultParameterSetName = 'ByDate')]
    param (
        # Name of the app registration
        [Parameter(Mandatory)]
        [string]
        $Name
    )
    Test-MgGraphConnection
    $ExistingApplication = Get-MgApplication | Where-Object { $_.DisplayName -eq $Name }

    if ($ExistingApplication) {
        Write-Error 'This Application already exists!'
        exit
    }
    else {
        $Application = New-MgApplication -DisplayName $Name

        ###Create an AAD service principal
        New-MgServicePrincipal -AppId $Application.AppId > $null
    }

    [PSCustomObject]@{
        AppId = $Application.AppId
        Id    = $Application.Id
    }
}