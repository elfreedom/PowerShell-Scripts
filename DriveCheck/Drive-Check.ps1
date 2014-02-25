<# Author: Sergio Morales
     Date: 7/24/13 Rev 0.4
  Program: Tests if network drive or path has connectivity issues through periodic refresh. #>

[int]$refreshtime = [int]300  # Represents time to refresh after each loop. (seconds)
$duetime = Get-Date 18:00     # Represents amount of time you wish to end program
$colors = 'Black', 'Green', 'Blue'       # Specify message colors [0/1- BG/FG, 2- Finish FG]
$file = 'drive-results.txt'              # File to save results in (.\file.txt)

while( (Get-Date) -lt $duetime ) {

    [int]$timeelapsed = [int]($refreshtime/60)

    do {
        sleep -s $refreshtime               # Wait to refresh the directory

        $refreshmsg = "Refreshing Public drive...time elapsed (minutes): $timeelapsed"
		Write-Host  $refreshmsg -BackgroundColor $colors[0] -ForegroundColor $colors[1]
        
        $timeelapsed = $timeelapsed+[int]($refreshtime/60)      # Increment time elapsed as minutes
        echo "Testing drive availability" > \\ucx.ucr.edu\fs\private\DIT\check.test # Test drive connectivity

		# Loop as long as no errors exist and time has not elapsed due-time
    } while ( ($? -eq "True") -and ((Get-Date) -lt $duetime) ) 
 
	$timek = Get-Date                       # Gets current time
	Write-Host ""

	# If program has reached due time, end and report no errors
    if( ((Get-Date) -ge $duetime) ) {
		rm echo \\ucx.ucr.edu\fs\private\DIT\check.test         # Get rid of test file
        $done = "No errors found with network drives: $timek"
		Write-Host $done -BackgroundColor $colors[0] -ForegroundColor $colors[2]
        echo $done >> $file                 # Append to file
    }

	# Else, the program ended prematurely due to errors and reports time it failed.
    else {
        $done = "Invoke-Item failed to open Public drive! Failed on: $timek" 
        Write-Host $done -BackgroundColor Red
        echo $done >> $file                 # Append to file

		break                               # Break from loop when finished
    }
}
