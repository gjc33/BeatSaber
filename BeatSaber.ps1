$html = @'
<!DOCTYPE html>
<html>
    <title>BeatSaber Catalogue</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    <body>

    <div class="w3-container">
        <h2>BeatSaber Catalogue</h2>
        <p>Click one of the tabs below to change Artist.</p>

'@


$BeatSaberRoot = "C:\Program Files\Oculus\Software\Software\hyperbolic-magnetism-beat-saber\Beat Saber_Data\CustomLevels\"

$AlphaFolders = Get-ChildItem -Path $BeatSaberRoot -Directory | ? {$_.Name.Length -eq 1}
$BeatList = New-Object System.Collections.Generic.List[System.Object]

ForEach ($Alpha in $AlphaFolders){
    $Tracks = Get-ChildItem -Path $Alpha.Fullname -Directory

        ForEach ($Track In $Tracks){
            $Tmp = $Track.Name -Split("\s-\s")

            $Entry = New-Object PSObject -Property @{
                Alpha       = $Alpha.Name
                Artist    = $Tmp[0]
                SongTitle    = $Tmp[1]
                Code = $Tmp[2]
            }
            $BeatList.Add($Entry)
        }
}

$html += "`n<div class='w3-bar w3-black'>"

    ForEach ($Alpha in $AlphaFolders){
        If($Alpha.Name -eq "0"){$TabColour = " w3-red"} Else {$TabColour = ""}
        $Click = "openCity(event,`"$($Alpha.Name)`")"
        $html += "`n<button class='w3-bar-item w3-button tablink$($TabColour)' onclick='$($Click)'>$($Alpha.Name)</button>"
    }

$html += "`n</div>"

ForEach ($Alpha in $AlphaFolders){
    Switch ($Alpha.Name){
        "0" {$html += "`n<div id='$($Alpha.Name)' class='w3-container w3-border city'>"; break;}
        default {$html += "`n<div id='$($Alpha.Name)' class='w3-container w3-border city' style='display:none'>"}
    }

    $html += "`n<table border='1'>"
    $html += "`n<tr bgcolor='#9acd32'><th>Artist</th><th>SongTitle</th><th>Code</th><tr>"

    Foreach ($Track in $BeatList | ? {$_.Alpha -eq $Alpha.Name}){
        $html += "`n<tr><td>$($Track.Artist)</td><td>$($Track.SongTitle)</td><td>$($Track.Code)</td></tr>"
    }

    $html += "`n</table>"
    $html += "`n</div>`n"
}

$html += @'
    </div>
        <script>
        function openCity(evt, cityName) {
          var i, x, tablinks;
          x = document.getElementsByClassName("city");
          for (i = 0; i < x.length; i++) {
            x[i].style.display = "none";
          }
          tablinks = document.getElementsByClassName("tablink");
          for (i = 0; i < x.length; i++) {
            tablinks[i].className = tablinks[i].className.replace(" w3-red", "");
          }
          document.getElementById(cityName).style.display = "block";
          evt.currentTarget.className += " w3-red";
        }
        </script>

    </body>
</html>
'@

$FolderPath = "C:\Users\garyc\Documents\GitHub\BeatSaber\"
$html | Out-File $(Join-Path $FolderPath "index.html")