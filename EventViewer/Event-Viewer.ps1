<# Author: Sergio Morales
     Date: 9/24/13 Rev 1.26 "Added more aesthetics using more functions"
  Program: Customized remote event-viewer 

  .:Formatting styles:.
     - Can set to view as a table or export it all. Default is a list
	 - Use: 'EventViewer.ps1 -format table ...', 'EventViewer.ps1 -format list ...', 'EventViewer.ps1 -format csv ...', 'EventViewer.ps1 -format txt ...'
	 - Able to export event data using CSV format. All output is redirected, however.
#>

param ($format="list", $exppath="C:\", $expname="Results", $dtime=5)


#######################################
### Script functions for easier use ###
#######################################

# Get log name(s) from user
Function LogNames {

while($true) {
		# Grab an array of the input by splitting at commas
		[string[]]$names = (Read-Host 'Enter the log type(s): (Comma delimited)
Application-      1
Security-         2
Setup-            3
System-           4').split(",")
# Forwarded Events- 5 (Not a valid event log?)

		$done = $false;
		# Input validation and name changing
		for($i = 0; $i -lt $names.count; $i++) {
			# Grab the logname(s)
			switch ($names[$i]) {
				1 { $names[$i] = 'Application'; $done = $true }
				2 { $names[$i] = 'Security'; $done = $true }
				3 { $names[$i] = 'Setup';  $done = $true }
				4 { $names[$i] = 'System';  $done = $true }
				#5 { $names[$i] = 'Forwarded Events';  $done = $true } (Not a valid event log?)
				default { Write-Host "Select a valid input!"; $done = $false; break}
			}
		}

		# Loop breaker
		if($done -eq $true) { break;}
	}

	return $names
}

# Event level prompter
Function GetEventLevel {
	[int[]]$entypes = @()

	# Start loop that checks for validation and accepts multiple inputs
	while($true) {
		$entypes = (Read-Host 'Enter the event level(s): (Comma delimited)
Critical-         1
Error-            2
Warning-          3
Information       4
All/Verbose-      5').split(",")

		echo ""
		$done = $false
		for($i = 0; $i -lt $entypes.count; $i++) {
			if( ($entypes[$i] -gt 5) -or ($entypes[$i] -le 0)) { Write-Host "Enter a valid input!"; $done = $false; break}
			else { $done = $true }
		}

		if($done -eq $true) { break }
	}

	return $entypes
}

# Output final results
Function DisplayEvents([string]$compname, [string[]]$logname, [int[]]$entype, [string]$amount) {
	# Results are outputted/redirected based on selected format
	switch( $format ) {	
		"csv" {
			Get-WinEvent -ComputerName $compname -FilterHashtable @{LogName=$logname; Level = $entype} -MaxEvents ([int]$amount) | Export-CSV "$exppath\$expname`.csv "

			# Report success/failure on exporting
			if( $? -eq "True") { Write-Host "Successfully exported results to .csv!" -ForeGroundColor Yellow }
			else { Write-Host "Error writing to .csv!" -ForeGroundColor Red }
		}
		"txt" {
			Get-WinEvent -ComputerName $compname -FilterHashtable @{LogName=$logname; Level = $entype} -MaxEvents ([int]$amount) | format-list | out-file "$exppath\$expname`.txt"		

			# Report success/failure on exporting
			if( $? -eq "True") { Write-Host "Successfully exported results to .txt!" -ForeGroundColor Yellow }
			else { Write-Host "Error writing to .txt!" -ForeGroundColor Red }
		}
		"table" {
			Get-WinEvent -ComputerName $compname -FilterHashtable @{LogName=$logname; Level = $entype} -MaxEvents ([int]$amount) | format-table -wrap -auto }
		default {
			Get-WinEvent -ComputerName $compname -FilterHashtable @{LogName=$logname; Level = $entype} -MaxEvents ([int]$amount) | format-list }	
	}
}

##########################
### Script begins here ###
##########################

# Parse through config file to set modes
$config = Get-Content .\config.txt  # Grab config settings
$line = @()                         # Declare variable to hold config content

Write-Host "Grabbing config settings..."
foreach( $line in $config ) {
	if( $line.contains( ":Format:") ){ 
		$format = $line.split()[1] }
	if( $line.contains( ":ExportPath:") ){ 
		$exppath = $line.split()[1] }
	if( $line.contains( ":ExportName:") ){ 
		$expname = $line.split()[1] }
	if( $line.contains( ":DisplayTime:") ){ 
		$dtime = $line.split()[1] }

	if( $? -eq $false ){
		Write-Host $error; }
}
Write-Host "...done!"

# Display settings grabbed from config file
"Format: $format"
"Export path: $exppath"
"Export name: $expname"
"Display time: $dtime"

# Get PC name
[string]$compname = Read-Host 'Enter the name of the computer you wish to remotely view event logs'
echo ""

# Get the requested log names to display
[string[]]$logname = LogNames
echo ""

# Get the level(s) for the event
[int[]]$entypes = GetEventLevel
echo ""

# Get max events
$amount = Read-Host 'Enter amount of logs you wish to view (most recent)'

# Display/output results based on format
DisplayEvents $compname $logname $entypes $amount

# Wait time before ending script (Only useful if running 
Sleep -s $dtime
