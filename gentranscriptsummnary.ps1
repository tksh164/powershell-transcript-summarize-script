param (
    [Parameter(Mandatory = $true)]
    [string] $FolderPath,

    [Parameter(Mandatory = $false)]
    [string] $FileNameFilter = 'PowerShell_transcript.*.txt'
)

function Get-DateTimeText
{
    param (
        [Parameter(Mandatory = $true)]
        [string] $TimestampLine
    )

    $timestampPart = $TimestampLine.Substring($TimestampLine.LastIndexOf(' ') + 1)
    return [datetime]::ParseExact($timestampPart, 'yyyyMMddHHmmss', $null).ToString('yyyy-MM-dd HH:mm:ss')
}

Get-ChildItem -LiteralPath $FolderPath -Filter $FileNameFilter | ForEach-Object -Process {
    $result = [PSCustomObject] @{
        FileName  = $_.Name
        StartTime = ''
        EndTime   = ''
    }

    Get-Content -LiteralPath $_.FullName | ForEach-Object -Process {
        if ($_.StartsWith('Start time:')) {
            $result.StartTime = Get-DateTimeText -TimestampLine $_
        }
        elseif ($_.StartsWith('End time:')) {
            $result.EndTime = Get-DateTimeText -TimestampLine $_
        }
    }

    $result
}
