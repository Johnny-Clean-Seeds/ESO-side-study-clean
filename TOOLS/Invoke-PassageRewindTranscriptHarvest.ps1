param(
    [string]$OutputRoot = ".\HALL_COOP_LEY\MEDIA\03_DROP_TARGET_FOLDERS\AUDIO_OR_TRANSCRIPTS\PASSAGE_REWIND_AMERICAS_ASSIGNMENT",
    [switch]$AllowYouTubeAutoCaptions
)

$ErrorActionPreference = "Stop"

# ESO wrapper for the house Transcript Puller pattern.
# Default mode preserves the user's boundary: do not harvest YouTube auto captions.
# It records metadata, caption availability, blocked status, and hashes. If manual
# captions exist, it pulls those only. Use -AllowYouTubeAutoCaptions only if the
# user explicitly overrides the no-auto boundary.

function Write-Utf8File {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][AllowEmptyString()][string]$Text
    )

    $parent = Split-Path -Parent $Path
    if ($parent) {
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
    }

    $utf8 = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $Text, $utf8)
}

function Sanitize-Name {
    param(
        [AllowEmptyString()][string]$Name,
        [int]$MaxLength = 100
    )

    if ([string]::IsNullOrWhiteSpace($Name)) { $Name = "UNKNOWN" }
    foreach ($c in [IO.Path]::GetInvalidFileNameChars()) {
        $Name = $Name.Replace($c, "_")
    }
    $Name = $Name -replace '[\r\n\t]+', ' '
    $Name = $Name -replace '\s+', ' '
    $Name = $Name.Trim().Trim(".")
    if ([string]::IsNullOrWhiteSpace($Name)) { $Name = "UNKNOWN" }
    if ($Name.Length -gt $MaxLength) {
        $Name = $Name.Substring(0, $MaxLength).Trim().Trim(".")
    }
    return $Name
}

function Find-YtDlp {
    $local = Join-Path ([Environment]::GetFolderPath("Desktop")) "Transcripts\_TOOLS\yt-dlp.exe"
    if (Test-Path -LiteralPath $local -PathType Leaf) { return $local }

    $cmd = Get-Command "yt-dlp.exe" -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }

    $cmd2 = Get-Command "yt-dlp" -ErrorAction SilentlyContinue
    if ($cmd2) { return $cmd2.Source }

    throw "yt-dlp was not found."
}

function Get-PropertyNames {
    param($Object)
    if ($null -eq $Object) { return @() }
    return @($Object.PSObject.Properties | ForEach-Object { $_.Name })
}

function Clean-CaptionLine {
    param([AllowEmptyString()][string]$Text)
    $x = [System.Net.WebUtility]::HtmlDecode($Text)
    $x = $x -replace '<[^>]+>', ''
    $x = $x -replace '\{\\an\d+\}', ''
    $x = $x -replace '\s+', ' '
    return $x.Trim()
}

function Convert-VttToTranscript {
    param(
        [Parameter(Mandatory = $true)][string]$CaptionPath,
        [Parameter(Mandatory = $true)][string]$TimedPath,
        [Parameter(Mandatory = $true)][string]$CleanPath,
        [Parameter(Mandatory = $true)][hashtable]$Header
    )

    $lines = [System.IO.File]::ReadAllLines($CaptionPath)
    $timed = New-Object System.Collections.Generic.List[string]
    $clean = New-Object System.Collections.Generic.List[string]
    $cue = New-Object System.Collections.Generic.List[string]
    $start = $null
    $end = $null
    $last = ""

    function Flush-Cue {
        if (-not $script:start -or -not $script:end) { return }
        $parts = New-Object System.Collections.Generic.List[string]
        foreach ($line in $script:cue) {
            $c = Clean-CaptionLine $line
            if ([string]::IsNullOrWhiteSpace($c)) { continue }
            if ($parts.Count -gt 0 -and $parts[$parts.Count - 1] -eq $c) { continue }
            $parts.Add($c) | Out-Null
        }
        if ($parts.Count -eq 0) { return }
        $text = $parts[$parts.Count - 1]
        if ($text -eq $script:last) { return }
        $script:last = $text
        $script:timed.Add(("[{0} --> {1}] {2}" -f $script:start, $script:end, $text)) | Out-Null
        $script:clean.Add($text) | Out-Null
    }

    $script:timed = $timed
    $script:clean = $clean
    $script:cue = $cue
    $script:start = $start
    $script:end = $end
    $script:last = $last

    foreach ($line in $lines) {
        $raw = "$line".Trim()
        if ([string]::IsNullOrWhiteSpace($raw)) { continue }
        if ($raw -eq "WEBVTT") { continue }
        if ($raw -match '^Kind:') { continue }
        if ($raw -match '^Language:') { continue }
        if ($raw -match '^NOTE') { continue }
        if ($raw -match '^\d+$') { continue }

        if ($raw -match '^([0-9:\.]+)\s+-->\s+([0-9:\.]+)') {
            Flush-Cue
            $script:start = $Matches[1]
            $script:end = $Matches[2]
            $script:cue = New-Object System.Collections.Generic.List[string]
            continue
        }

        if ($script:start -and $script:end) {
            $script:cue.Add($raw) | Out-Null
        }
    }
    Flush-Cue

    $commonHeader = @"
Title: $($Header.Title)
Video ID: $($Header.VideoId)
URL: $($Header.Url)
Playlist/source position: $($Header.Position)
Caption source: $($Header.CaptionSource)
Extraction method/tool: $($Header.Method)
Source caption file: $CaptionPath
Extracted: $($Header.ExtractedAt)

"@

    Write-Utf8File -Path $TimedPath -Text ($commonHeader + @"
================================================================================
TIMED TRANSCRIPT
================================================================================

"@ + (($timed.ToArray()) -join [Environment]::NewLine))

    Write-Utf8File -Path $CleanPath -Text ($commonHeader + @"
================================================================================
CLEAN TRANSCRIPT
================================================================================

"@ + (($clean.ToArray()) -join [Environment]::NewLine))
}

$items = @(
    @{ Group = "SERIES"; Position = "01/13"; VideoId = "mBGp2SJdwb0"; Url = "https://www.youtube.com/watch?v=mBGp2SJdwb0"; TitleHint = "Passage Rewind: America's Assignment Part 1"; Notes = "Mercy Hunter original series" },
    @{ Group = "SERIES"; Position = "02/13"; VideoId = "a_mkJI0aJ20"; Url = "https://www.youtube.com/watch?v=a_mkJI0aJ20"; TitleHint = "Passage Rewind: Americas Assignment Part 2"; Notes = "Mercy Hunter original series" },
    @{ Group = "SERIES"; Position = "03/13"; VideoId = "beRNhUkt_mU"; Url = "https://www.youtube.com/watch?v=beRNhUkt_mU"; TitleHint = "Passage Rewind: America's Assignment Part 3"; Notes = "Mercy Hunter original series" },
    @{ Group = "SERIES"; Position = "04/13"; VideoId = "7_4w8gyOdzk"; Url = "https://www.youtube.com/watch?v=7_4w8gyOdzk"; TitleHint = "Passage Rewind: America's Assignment Part 4"; Notes = "Mercy Hunter original series" },
    @{ Group = "SERIES"; Position = "05/13"; VideoId = "Od99GKlcEB4"; Url = "https://www.youtube.com/watch?v=Od99GKlcEB4"; TitleHint = "Passage Rewind: America's Assignment Part 5"; Notes = "Mercy Hunter original series" },
    @{ Group = "SERIES"; Position = "06/13"; VideoId = "cA0b3f2Ne28"; Url = "https://www.youtube.com/watch?v=cA0b3f2Ne28"; TitleHint = "Passage Rewind: America's Assignment Part 6"; Notes = "Mercy Hunter original series" },
    @{ Group = "SERIES"; Position = "07/13"; VideoId = "II2dKoOFeb4"; Url = "https://www.youtube.com/watch?v=II2dKoOFeb4"; TitleHint = "Passage Rewind: America's Assignment Part 7"; Notes = "Mercy Hunter original series" },
    @{ Group = "SERIES"; Position = "08/13"; VideoId = "rNxm5Xtp6qI"; Url = "https://www.youtube.com/watch?v=rNxm5Xtp6qI"; TitleHint = "Passage Rewind: America's Assignment Part 8"; Notes = "Mercy Hunter original series" },
    @{ Group = "SERIES"; Position = "09/13"; VideoId = "kJeOC3wBrkE"; Url = "https://www.youtube.com/watch?v=kJeOC3wBrkE"; TitleHint = "Passage Rewind: America's Assignment Part 9"; Notes = "Mercy Hunter original series" },
    @{ Group = "SERIES"; Position = "10/13"; VideoId = "zfsYvyzg8T4"; Url = "https://www.youtube.com/watch?v=zfsYvyzg8T4"; TitleHint = "Passage Rewind: America's Assignment Part 10"; Notes = "Mercy Hunter original series" },
    @{ Group = "SERIES"; Position = "11/13"; VideoId = "3a-QJu1J2Ms"; Url = "https://www.youtube.com/watch?v=3a-QJu1J2Ms"; TitleHint = "Passage Rewind: America's Assignment Part 11"; Notes = "Mercy Hunter original series" },
    @{ Group = "SERIES"; Position = "12/13"; VideoId = "Gq4RroXvZgk"; Url = "https://www.youtube.com/watch?v=Gq4RroXvZgk"; TitleHint = "Passage Rewind: America's Assignment Part 12"; Notes = "Mercy Hunter original series" },
    @{ Group = "SERIES"; Position = "13/13"; VideoId = "wWuFC-HT8bA"; Url = "https://www.youtube.com/watch?v=wWuFC-HT8bA"; TitleHint = "Passage Rewind: America's Assignment Part 13"; Notes = "Mercy Hunter original series" },
    @{ Group = "REPOST"; Position = "Bill Cooper Today 2 channel videos pos 4"; VideoId = "DEppNfkNHIY"; Url = "https://www.youtube.com/watch?v=DEppNfkNHIY"; TitleHint = "Passage Rewind: America's Assignment - Bill Cooper (A Mercy Hunter Presentation)"; Notes = "User-supplied channel route / repost or compiled surface" },
    @{ Group = "EXTRA"; Position = "Mercy Hunter related"; VideoId = "FimkiTQKH-k"; Url = "https://www.youtube.com/watch?v=FimkiTQKH-k"; TitleHint = "All In the Name of World Heritage?"; Notes = "America's Assignment related place/source follow-up" },
    @{ Group = "EXTRA"; Position = "Mercy Hunter related"; VideoId = "TapNP687Qeo"; Url = "https://www.youtube.com/watch?v=TapNP687Qeo"; TitleHint = "Who's the Plumed Serpent?"; Notes = "Feathered/plumed serpent adjacent lane" },
    @{ Group = "EXTRA"; Position = "Mercy Hunter related"; VideoId = "sa-G1aQJh2s"; Url = "https://www.youtube.com/watch?v=sa-G1aQJh2s"; TitleHint = "Land of the Plumed Serpent?"; Notes = "Feathered/plumed serpent adjacent lane" },
    @{ Group = "EXTRA"; Position = "Mercy Hunter related"; VideoId = "UOS8hvMv8r8"; Url = "https://www.youtube.com/watch?v=UOS8hvMv8r8"; TitleHint = "The Peabody Museum"; Notes = "Museum/source trail adjacent lane" },
    @{ Group = "EXTRA"; Position = "Mercy Hunter related"; VideoId = "mmU__lMogCA"; Url = "https://www.youtube.com/watch?v=mmU__lMogCA"; TitleHint = "Some Theories About the Mounds in America"; Notes = "Mound lane adjacent surface" },
    @{ Group = "EXTRA"; Position = "Mercy Hunter related"; VideoId = "64ey0jGRDVY"; Url = "https://www.youtube.com/watch?v=64ey0jGRDVY"; TitleHint = "Old Articles on the Mounds (1811 -1830's)"; Notes = "Mound/source article lane" },
    @{ Group = "EXTRA"; Position = "Mercy Hunter related"; VideoId = "YBYL2Ssy6SA"; Url = "https://www.youtube.com/watch?v=YBYL2Ssy6SA"; TitleHint = "More Old Articles on the Mounds (1860's 1870's)"; Notes = "Mound/source article lane" },
    @{ Group = "EXTRA"; Position = "Mercy Hunter related"; VideoId = "fS6AklkrPbw"; Url = "https://www.youtube.com/watch?v=fS6AklkrPbw"; TitleHint = "Little Egypt on the Mississippi"; Notes = "Mound/Mississippi adjacent lane" },
    @{ Group = "EXTRA"; Position = "Mercy Hunter related"; VideoId = "eVMTKbmmqjo"; Url = "https://www.youtube.com/watch?v=eVMTKbmmqjo"; TitleHint = "More Speculations on the Mounds"; Notes = "Mound adjacent lane" }
)

$ytDlp = Find-YtDlp
$ytDlpVersion = (& $ytDlp --version).Trim()
$resolvedOutputRoot = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputRoot)
New-Item -ItemType Directory -Force -Path $resolvedOutputRoot | Out-Null

$extractedAt = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"
$mode = if ($AllowYouTubeAutoCaptions) { "AUTO_CAPTIONS_ALLOWED_BY_SWITCH" } else { "NO_AUTO_CAPTIONS" }
$method = "House Transcript Puller V2 Fixed custody pattern; yt-dlp $ytDlpVersion; mode $mode"

$rows = New-Object System.Collections.Generic.List[object]
$errors = New-Object System.Collections.Generic.List[string]

foreach ($item in $items) {
    $videoId = $item.VideoId
    $prefix = if ($item.Group -eq "SERIES") { "PART_$($item.Position.Replace('/','_'))" } else { "$($item.Group)_$videoId" }
    $safeTitle = Sanitize-Name $item.TitleHint 80
    $videoDir = Join-Path $resolvedOutputRoot ("{0}__{1}__{2}" -f $prefix, $videoId, $safeTitle)
    New-Item -ItemType Directory -Force -Path $videoDir | Out-Null

    $title = $item.TitleHint
    $uploader = ""
    $channel = ""
    $channelId = ""
    $duration = ""
    $uploadDate = ""
    $manualLangs = @()
    $autoLangs = @()
    $captionSource = "UNINSPECTED"
    $status = "PENDING"
    $errorText = ""
    $captionFile = ""
    $timedPath = Join-Path $videoDir "TRANSCRIPT_TIMED.txt"
    $cleanPath = Join-Path $videoDir "TRANSCRIPT_CLEAN.txt"

    try {
        Write-Host "Inspecting $($item.Group) $($item.Position): $videoId"
        $jsonRaw = & $ytDlp --skip-download --no-warnings --dump-json $item.Url
        if ([string]::IsNullOrWhiteSpace($jsonRaw)) { throw "yt-dlp returned empty metadata." }
        $meta = $jsonRaw | ConvertFrom-Json

        $title = "$($meta.title)"
        $uploader = "$($meta.uploader)"
        $channel = "$($meta.channel)"
        $channelId = "$($meta.channel_id)"
        $duration = "$($meta.duration)"
        $uploadDate = "$($meta.upload_date)"
        $manualLangs = @(Get-PropertyNames $meta.subtitles)
        $autoLangs = @(Get-PropertyNames $meta.automatic_captions)

        $infoJson = [ordered]@{
            video_title = $title
            video_id = $videoId
            url = $item.Url
            group = $item.Group
            playlist_position = $item.Position
            title_hint = $item.TitleHint
            notes = $item.Notes
            uploader = $uploader
            channel = $channel
            channel_id = $channelId
            duration_seconds = $duration
            upload_date = $uploadDate
            manual_caption_languages = ($manualLangs -join ", ")
            automatic_caption_languages = ($autoLangs -join ", ")
            extraction_method_tool = $method
            extracted_at = $extractedAt
        }
        Write-Utf8File -Path (Join-Path $videoDir "INFO.json") -Text ($infoJson | ConvertTo-Json -Depth 6)

        if ($manualLangs.Count -gt 0) {
            $captionSource = "Manual/user-provided YouTube subtitles available: $($manualLangs -join ', ')"
            $outTemplate = Join-Path $videoDir "%(id)s.%(ext)s"
            & $ytDlp `
                --skip-download `
                --write-subs `
                --sub-langs "en.*,en" `
                --sub-format "vtt/srt/best" `
                --no-warnings `
                --ignore-errors `
                --output $outTemplate `
                $item.Url | Out-Null

            $captionFiles = @(Get-ChildItem -LiteralPath $videoDir -File -ErrorAction SilentlyContinue |
                Where-Object { $_.Extension -match '^\.(vtt|srt)$' } |
                Sort-Object LastWriteTime -Descending)

            if ($captionFiles.Count -gt 0) {
                $captionFile = $captionFiles[0].FullName
                $header = @{
                    Title = $title
                    VideoId = $videoId
                    Url = $item.Url
                    Position = $item.Position
                    CaptionSource = $captionSource
                    Method = $method
                    ExtractedAt = $extractedAt
                }
                if ($captionFiles[0].Extension -eq ".vtt") {
                    Convert-VttToTranscript -CaptionPath $captionFile -TimedPath $timedPath -CleanPath $cleanPath -Header $header
                    $status = "CAPTURED_MANUAL_CAPTIONS"
                } else {
                    $status = "MANUAL_CAPTION_SRT_SAVED_NOT_CONVERTED"
                }
            } else {
                $status = "MANUAL_CAPTIONS_LISTED_BUT_NOT_SAVED"
                $errorText = "Manual subtitles were listed by metadata, but yt-dlp did not save an English VTT/SRT file."
                $errors.Add("$videoId`t$status`t$errorText") | Out-Null
            }
        } elseif ($autoLangs.Count -gt 0 -and -not $AllowYouTubeAutoCaptions) {
            $status = "BLOCKED_AUTO_CAPTIONS_ONLY"
            $captionSource = "YouTube automatic captions present only; not harvested per user no-auto boundary."
            $errorText = "No manual subtitles exposed. Automatic captions available but blocked."
            $errors.Add("$videoId`t$status`t$errorText") | Out-Null
        } elseif ($autoLangs.Count -gt 0 -and $AllowYouTubeAutoCaptions) {
            $captionSource = "YouTube automatic captions harvested by explicit -AllowYouTubeAutoCaptions switch."
            $outTemplate = Join-Path $videoDir "%(id)s.%(ext)s"
            & $ytDlp `
                --skip-download `
                --write-auto-subs `
                --sub-langs "en-orig,en" `
                --sub-format "vtt" `
                --no-warnings `
                --ignore-errors `
                --output $outTemplate `
                $item.Url | Out-Null

            $captionFiles = @(Get-ChildItem -LiteralPath $videoDir -File -Filter "*.vtt" -ErrorAction SilentlyContinue |
                Sort-Object LastWriteTime -Descending)
            if ($captionFiles.Count -gt 0) {
                $captionFile = $captionFiles[0].FullName
                $header = @{
                    Title = $title
                    VideoId = $videoId
                    Url = $item.Url
                    Position = $item.Position
                    CaptionSource = $captionSource
                    Method = $method
                    ExtractedAt = $extractedAt
                }
                Convert-VttToTranscript -CaptionPath $captionFile -TimedPath $timedPath -CleanPath $cleanPath -Header $header
                $status = "CAPTURED_AUTO_CAPTIONS"
            } else {
                $status = "AUTO_CAPTIONS_LISTED_BUT_NOT_SAVED"
                $errorText = "Automatic captions were listed by metadata, but yt-dlp did not save a VTT file."
                $errors.Add("$videoId`t$status`t$errorText") | Out-Null
            }
        } else {
            $status = "NO_CAPTIONS_EXPOSED"
            $captionSource = "No manual or automatic captions exposed by yt-dlp metadata."
            $errorText = "No caption surface available."
            $errors.Add("$videoId`t$status`t$errorText") | Out-Null
        }

        $infoText = @"
Title: $title
Video ID: $videoId
URL: $($item.Url)
Group: $($item.Group)
Playlist/source position: $($item.Position)
Uploader: $uploader
Channel: $channel
Channel ID: $channelId
Duration seconds: $duration
Upload date: $uploadDate
Manual caption languages: $($manualLangs -join ', ')
Automatic caption languages: $($autoLangs -join ', ')
Caption source: $captionSource
Status: $status
Extraction method/tool: $method
Notes: $($item.Notes)
Folder: $videoDir
Extracted: $extractedAt
Error/block note: $errorText
"@
        Write-Utf8File -Path (Join-Path $videoDir "INFO.txt") -Text $infoText
        if ($errorText) { Write-Utf8File -Path (Join-Path $videoDir "ERROR_OR_BLOCKED.txt") -Text $errorText }
    } catch {
        $status = "ERROR"
        $errorText = $_.Exception.Message
        $captionSource = "ERROR_BEFORE_CAPTION_SOURCE_LOCK"
        Write-Utf8File -Path (Join-Path $videoDir "ERROR_OR_BLOCKED.txt") -Text $errorText
        $errors.Add("$videoId`t$status`t$errorText") | Out-Null
    }

    $rows.Add([pscustomobject]@{
        Group = $item.Group
        Position = $item.Position
        VideoId = $videoId
        Title = $title
        Url = $item.Url
        Uploader = $uploader
        Channel = $channel
        DurationSeconds = $duration
        UploadDate = $uploadDate
        ManualCaptionLanguages = ($manualLangs -join ";")
        AutomaticCaptionLanguages = ($autoLangs -join ";")
        CaptionSource = $captionSource
        Status = $status
        CaptionFile = $captionFile
        TimedTranscript = if (Test-Path -LiteralPath $timedPath) { $timedPath } else { "" }
        CleanTranscript = if (Test-Path -LiteralPath $cleanPath) { $cleanPath } else { "" }
        Folder = $videoDir
        Error = $errorText
    }) | Out-Null
}

$csvLines = New-Object System.Collections.Generic.List[string]
$csvLines.Add('"Group","Position","VideoId","Title","Url","Uploader","Channel","DurationSeconds","UploadDate","ManualCaptionLanguages","AutomaticCaptionLanguages","CaptionSource","Status","CaptionFile","TimedTranscript","CleanTranscript","Folder","Error"') | Out-Null
foreach ($row in $rows) {
    $vals = @(
        $row.Group, $row.Position, $row.VideoId, $row.Title, $row.Url, $row.Uploader, $row.Channel,
        $row.DurationSeconds, $row.UploadDate, $row.ManualCaptionLanguages, $row.AutomaticCaptionLanguages,
        $row.CaptionSource, $row.Status, $row.CaptionFile, $row.TimedTranscript, $row.CleanTranscript,
        $row.Folder, $row.Error
    ) | ForEach-Object { '"' + (($_ -as [string]) -replace '"','""') + '"' }
    $csvLines.Add(($vals -join ",")) | Out-Null
}
Write-Utf8File -Path (Join-Path $resolvedOutputRoot "INDEX.csv") -Text (($csvLines.ToArray()) -join [Environment]::NewLine)

$md = New-Object System.Collections.Generic.List[string]
$md.Add("# Passage Rewind America's Assignment Transcript Custody Index") | Out-Null
$md.Add("") | Out-Null
$md.Add("Status: RAW_CUSTODY_INDEX / HOUSE_TRANSCRIPT_PULLER_PATTERN / $mode") | Out-Null
$md.Add("") | Out-Null
$md.Add("Extracted: $extractedAt") | Out-Null
$md.Add("") | Out-Null
$md.Add("Method/tool: $method") | Out-Null
$md.Add("") | Out-Null
$md.Add("Boundary: YouTube automatic captions are not harvested unless the switch -AllowYouTubeAutoCaptions is explicitly used. In default mode, auto-only videos are marked blocked.") | Out-Null
$md.Add("") | Out-Null
$md.Add("## Series") | Out-Null
$md.Add("") | Out-Null
$md.Add("| Pos | Title | Video ID | Status | Caption source | Transcript |") | Out-Null
$md.Add("| --- | --- | --- | --- | --- | --- |") | Out-Null
foreach ($row in ($rows | Where-Object { $_.Group -eq "SERIES" })) {
    $relTranscript = if ($row.TimedTranscript) { $row.TimedTranscript.Replace($resolvedOutputRoot + "\", "") } else { "" }
    $link = if ($relTranscript) { "[timed]($($relTranscript -replace '\\','/'))" } else { "" }
    $md.Add("| $($row.Position) | [$($row.Title)]($($row.Url)) | $($row.VideoId) | $($row.Status) | $($row.CaptionSource) | $link |") | Out-Null
}
$md.Add("") | Out-Null
$md.Add("## Repost Route") | Out-Null
$md.Add("") | Out-Null
$md.Add("| Position | Title | Video ID | Status | Caption source | Transcript |") | Out-Null
$md.Add("| --- | --- | --- | --- | --- | --- |") | Out-Null
foreach ($row in ($rows | Where-Object { $_.Group -eq "REPOST" })) {
    $relTranscript = if ($row.TimedTranscript) { $row.TimedTranscript.Replace($resolvedOutputRoot + "\", "") } else { "" }
    $link = if ($relTranscript) { "[timed]($($relTranscript -replace '\\','/'))" } else { "" }
    $md.Add("| $($row.Position) | [$($row.Title)]($($row.Url)) | $($row.VideoId) | $($row.Status) | $($row.CaptionSource) | $link |") | Out-Null
}
$md.Add("") | Out-Null
$md.Add("## Extras") | Out-Null
$md.Add("") | Out-Null
$md.Add("| Title | Video ID | Status | Caption source | Transcript |") | Out-Null
$md.Add("| --- | --- | --- | --- | --- |") | Out-Null
foreach ($row in ($rows | Where-Object { $_.Group -eq "EXTRA" })) {
    $relTranscript = if ($row.TimedTranscript) { $row.TimedTranscript.Replace($resolvedOutputRoot + "\", "") } else { "" }
    $link = if ($relTranscript) { "[timed]($($relTranscript -replace '\\','/'))" } else { "" }
    $md.Add("| [$($row.Title)]($($row.Url)) | $($row.VideoId) | $($row.Status) | $($row.CaptionSource) | $link |") | Out-Null
}
$md.Add("") | Out-Null
$md.Add("## Errors / Blocked") | Out-Null
$md.Add("") | Out-Null
if ($errors.Count -eq 0) {
    $md.Add("No errors or blocked items recorded.") | Out-Null
} else {
    foreach ($err in $errors) { $md.Add("- $err") | Out-Null }
}
Write-Utf8File -Path (Join-Path $resolvedOutputRoot "INDEX.md") -Text (($md.ToArray()) -join [Environment]::NewLine)

$errorTextOut = "video_id`tstatus`terror"
if ($errors.Count -gt 0) {
    $errorTextOut += [Environment]::NewLine + (($errors.ToArray()) -join [Environment]::NewLine)
}
Write-Utf8File -Path (Join-Path $resolvedOutputRoot "ERRORS.tsv") -Text $errorTextOut

$manifestPath = Join-Path $resolvedOutputRoot "MANIFEST_SHA256.txt"
$files = Get-ChildItem -LiteralPath $resolvedOutputRoot -Recurse -File |
    Where-Object { $_.FullName -ne $manifestPath } |
    Sort-Object FullName
$hashLines = New-Object System.Collections.Generic.List[string]
foreach ($file in $files) {
    $hash = Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256
    $rel = $file.FullName.Replace($resolvedOutputRoot + "\", "")
    $hashLines.Add("$($hash.Hash)  $rel") | Out-Null
}
Write-Utf8File -Path $manifestPath -Text (($hashLines.ToArray()) -join [Environment]::NewLine)

$receipt = @"
# Passage Rewind Transcript Harvest Receipt

Status: COMPLETE / RAW_CUSTODY_INDEX / $mode

Extracted: $extractedAt

Output root:

$resolvedOutputRoot

Method/tool:

$method

Saved surfaces:

- per-video INFO.txt
- per-video INFO.json
- per-video ERROR_OR_BLOCKED.txt where blocked or failed
- INDEX.md
- INDEX.csv
- ERRORS.tsv
- MANIFEST_SHA256.txt

Count:

- total videos attempted: $($rows.Count)
- captured manual captions: $(($rows | Where-Object { $_.Status -eq "CAPTURED_MANUAL_CAPTIONS" }).Count)
- captured auto captions by explicit switch: $(($rows | Where-Object { $_.Status -eq "CAPTURED_AUTO_CAPTIONS" }).Count)
- blocked/errors/no captions: $(($rows | Where-Object { $_.Status -ne "CAPTURED_MANUAL_CAPTIONS" -and $_.Status -ne "CAPTURED_AUTO_CAPTIONS" }).Count)

Interpretive boundary:

No Hall/Cooper/Mercy alignment judgment was made here. This is transcript and caption-source custody only.
"@
Write-Utf8File -Path (Join-Path $resolvedOutputRoot "HARVEST_RECEIPT.md") -Text $receipt

Write-Host ""
Write-Host "Harvest complete:"
Write-Host "  $resolvedOutputRoot"
Write-Host "  Index: $(Join-Path $resolvedOutputRoot "INDEX.md")"
