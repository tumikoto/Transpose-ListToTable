param (
	[Parameter(Mandatory=$true,Position=1)][string]$InputFile,
	[Parameter(Mandatory=$true,Position=2)][string]$OutputFile
)

If (!( Test-Path $InputFile) -and ($OutputFile)) {
	Write-Host Usage:
	Write-Host  powershell.exe Transpose-ListToTable.ps1 -InputFile <format-list input file> -OutputFile <CSV output file> -ObjectDelimiter <string indicating obj boundary in input file>
	Write-Host " "
	Write-Host Example:
	Write-Host  powershell.exe Transpose-ListToTable.ps1 -InputFile .\format-list-output.txt -OutputFile .\format-table-output.csv -ObjectDelimiter "----------------------------"
	Exit
}


$content = get-content $InputFile
$global:objects = @()
$global:object = New-Object -TypeName PSObject

foreach ($line in ($content -split "\r\n")) {
	Write-Host Processing line:
	Write-Host "===================="
	$line
	Write-Host "===================="
	
	if ($line -match $ObjectDelimiter) {
		$global:objects += $global:object
		$global:object = New-Object -TypeName PSObject
	} else {
		$property = ($line -split ": ")[0].Trim()
		$value = ($line -split ": ")[1].Trim()
		Add-Member -InputObject $global:object -MemberType Noteproperty -Name $property -Value $value
	}
}

$global:objects  | Export-CSV -NoTypeInformation -Encoding UTF8 -Path $OutputFile


