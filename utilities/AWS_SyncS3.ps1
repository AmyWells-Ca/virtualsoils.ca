##### Sync Targets for AWS S3 via CLI #####
# .build\release --> virtualsoils.ca      #
# .build\admin --> admin.virtualsoils.ca  #
# .build\dev --> dev.virtualsoils.ca      #
# .build\logs --> logs.virtualsoils.ca    #
#                                         #
###########################################

# Variables for Functionality
$no = @("n","N","no","No","NO")
$yes = @("y","Y","yes","Yes","YES")
$uploadSelect = @(0, 0, 0, 0)

<#
$config = Get-Content -Path "$PSScriptRoot\config.json" -Raw -Encoding UTF8 | ConvertFrom-Json

# Setup Checkbox GUI
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Checkbox Example"
$form.Size = New-Object System.Drawing.Size(300,200)

function New-CheckBox {   
    param (
        [parameter(Mandatory=$true)],
        [String]$boxText = "Check Box",
        [int]$boxPosX = 10,
        [int]$boxPosY = 10,
        [bool]$boxDefault = $false,
        [int]$syncTarget = 0
    )
    $global:newCheckBox = $boxName
    $newCheckBox = New-Object System.Windows.Forms.CheckBox
    $newCheckBox.text = $boxText
    $newCheckBox.location = New-Object System.Drawing.Point($boxPosX, $boxPosY)
    $newCheckBox.checked = $boxDefault
    
    $newCheckBox.Add_CheckStateChanged({
        if ($newCheckBox.Checked) {
            Write-Host "Sync Enabled"
            # $uploadSelect[$syncTarget] = 1
            # Write-Host $uploadSelect
        } else {
            Write-Host "Sync Disabled"
            # $uploadSelect[$syncTarget] = 0
            # Write-Host $uploadSelect
        }
    })

    $form.Controls.Add($newCheckBox)

    Write-Host $newCheckBox
}

New-CheckBox -boxName $checkBoxLive -boxText "Sync to Live?" -boxPosX 10 -boxPosY 10 -boxDefault $true -syncTarget 0
New-CheckBox -boxName $checkBoxDev -boxText "Sync to Dev?" -boxPosX 10 -boxPosY 30 -boxDefault $false -syncTarget 1
New-CheckBox -boxName checkBoxAdmin -boxText "Sync to Admin?" -boxPosX 10 -boxPosY 50 -boxDefault $false -syncTarget 2
New-CheckBox -boxName checkBoxLogs -boxText "Sync to Logs?" -boxPosX 10 -boxPosY 70 -boxDefault $false -syncTarget 3

    $form.ShowDialog() | Out-Null

Write-Host $config

Write-Host $config.release[0] " --> " $config.Release[1]

foreach ($key in $config.Keys) {
    Write-Output $key
}

#>

do {
    $answ = Read-Host "Sync?"
} until ($no -contains$answ -or $yes -contains$answ) 

if ($no -contains$answ) {
    Write-Host "Cancelled" -ForegroundColor Red
    [Console]::ReadKey($true) | Out-Null
    [System.Environment]::Exit(204)
} elseif ($yes -contains$answ) {
    Write-Host "Preparing to Build $domain"
    
    Write-Host "Updating virtualsoils" -ForegroundColor Yellow
    Write-Host ""
    aws s3 sync ".\..\build\dev" s3://dev.virtualsoils.ca/ --delete 
    # Write-Host ""
    # aws s3 sync ".\..\build\release" s3://virtualsoils.ca/ --delete 
    Write-Host ""
    Read-host -prompt "Uploads Completed!"
    [Console]::ReadKey($true) | Out-Null
    [System.Environment]::Exit(204)
}
