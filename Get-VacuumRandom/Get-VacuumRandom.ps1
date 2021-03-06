<#   
.SYNOPSIS   
	Script that gets quantum random numbers from Australian National University 
    
.DESCRIPTION 
	Script automatically grabs the output from the http site 
	
.PARAMETER Seed 
	A switch, when entered the script returns 7 converted hexadecimal characters as INT[32] which can be used as a
	seed for the built-in Get-Random command.

.PARAMETER Hexchars
    This parameters can be an integer between 1 and 15, this specifies the amount of hexadecimal characters the
	script will grab from the generator and return.
	
.PARAMETER Decimal
	A switch that specifies whether the output should be decimal, only works in conjunction with Hexchars parameter.

.NOTES   
    Name: Get-VacuumRandom.ps1
    Author: Jaap Brasser
    DateCreated: 17-04-2012
	Website: http://www.jaapbrasser.com
	Blogpost: http://www.jaapbrasser.com/?p=79

.EXAMPLE   
	.\Get-VacuumRandom.ps1 -Seed

	Description 
	-----------     
	The script will contact the website of the Australian National Univerity grabbing the first 7 hexadecimal
	characters generated by the number generator. This seed could be used to seed the Get-Random PowerShell command
	as shown in the next example
	
.EXAMPLE   
	get-random -maximum 100 -minimum 50 -SetSeed (.\Get-VacuumRandom.ps1 -Seed)

	Description 
	-----------     
	By running the script in this fashion the seed provided by the quantum numbers is used as a seed for the random
	number generated by the Get-Random Cmdlet.
	
.EXAMPLE   
	.\Get-VacuumRandom.ps1 -Hexchars 15
	
	Description 
	-----------     
	Returns 15 randomly generated hexadecimal characters
	
.EXAMPLE   
	.\Get-VacuumRandom.ps1 -Hexchars 8 -Decimal
	
	Description 
	-----------     
	Returns 8 Hexadecimal characters which will be converted to an INT64(Long) integer which ranges from 989680 to
	4294967295 or 00000000
	
#>
param (
	[switch]$seed,
	[ValidateRange(1,15)]
		[int]$hexchars,
	[switch]$decimal
)

if (-not $seed -and $hexchars -eq $null) {
	Write-Warning "Either Seed or Hexchars parameter should be specified"
	return
}

if ($seed) {
	# Gather 7 random hexadecimal characters from the 
	$HexRandom = (invoke-webrequest http://150.203.48.55/RawHex.php | select -expandproperty content |
	Foreach-Object {$_.substring($_.IndexOf('<td>'))})[5..11] -join ""
	([Convert]::ToInt32($HexRandom, 16))
	return
}

$HexRandom = (invoke-webrequest http://150.203.48.55/RawHex.php | select -expandproperty content |
Foreach-Object {$_.substring($_.IndexOf('<td>'))})[5..($hexchars+4)] -join ""

if ($decimal) {
	([Convert]::ToInt64($HexRandom, 16))
	return
}

else {
	$HexRandom.ToUpper()
}