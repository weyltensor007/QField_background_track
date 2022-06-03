$xml_path = ".\base\AndroidManifest.xml"

$FileContent = 
    Get-ChildItem $xml_path |
        Get-Content


<#
this is the first line
this is the second line
this is the third line
this is the fourth line
#>

$NewFileContent = @()

for ($i = 0; $i -lt $FileContent.Length; $i++) {
    if ($i -eq 4) {
        # insert your line before this line
        $NewFileContent += '    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>'
    }

    $NewFileContent += $FileContent[$i]
}

$NewFileContent |
    Out-File $xml_path -encoding ASCII

