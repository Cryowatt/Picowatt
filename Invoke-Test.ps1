pico8 -x .\test.p8
$testResults = Get-Content .\test.p8l | ConvertFrom-Csv | Group-Object -Property Result

$passing = $testResults | Where-Object Name -eq "pass"
$failing = $testResults | Where-Object Name -ne "pass"


Write-Host
Write-Host -ForegroundColor White "Passed $($passing.Count)"
$passing | Select-Object -ExpandProperty Group | ForEach-Object {
    Write-Host -ForegroundColor Green $_.'test-name'
}

Write-Host
Write-Host -ForegroundColor White "Failed $($failing.Count)"
$failing | Select-Object -ExpandProperty Group | ForEach-Object {
    Write-Host -ForegroundColor Red $_.'test-name'
}

Write-Host
Write-Host "Total $($passing.Count)/$($passing.Count + $failing.Count) passed"