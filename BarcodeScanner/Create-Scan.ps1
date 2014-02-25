while($true) {
	[string[]]$scan = Read-Host "Scan item: ".split(",")
	if($scan.count -eq 1) {
		Write-Host "Error scanning item!"
		continue
	}

	Write-Host "Item scanned: $scan "
	echo $scan >> scanlist.txt

}
