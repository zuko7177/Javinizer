function Get-FindDataObject {
    [CmdletBinding()]
    param(
        [string]$Find,
        [object]$Settings,
        [switch]$Aggregated,
        [switch]$Dmm,
        [switch]$Javlibrary,
        [switch]$JavlibraryZh,
        [switch]$JavlibraryJa,
        [switch]$Javbus,
        [switch]$JavbusJa,
        [switch]$Jav321,
        [switch]$R18,
        [switch]$R18Zh
    )

    begin {
        Write-Debug "[$(Get-TimeStamp)][$($MyInvocation.MyCommand.Name)] Function started"
        $urlList = @()

        if (-not ($PSBoundParameters.ContainsKey('r18')) -and `
        (-not ($PSBoundParameters.ContainsKey('dmm')) -and `
        (-not ($PSBoundParameters.ContainsKey('javlibrary')) -and `
        (-not ($PSBoundParameters.ContainsKey('javlibraryzh')) -and `
        (-not ($PSBoundParameters.ContainsKey('javlibraryja')) -and `
        (-not ($PSBoundParameters.ContainsKey('r18zh')) -and `
        (-not ($PSBoundParameters.ContainsKey('javbus')) -and `
        (-not ($PSBoundParameters.ContainsKey('javbusja')) -and `
        (-not ($PSBoundParameters.ContainsKey('jav321'))))))))))) {
            if ($settings.Main.'scrape-r18' -eq 'true') {
                $R18 = $true
            }
            if ($settings.Main.'scrape-dmm' -eq 'true') {
                $Dmm = $true
            }
            if ($settings.Main.'scrape-javlibrary' -eq 'true') {
                $Javlibrary = $true
            }
            if ($settings.Main.'scrape-javlibraryzh' -eq 'true') {
                $JavlibraryZh = $true
            }
            if ($settings.Main.'scrape-javlibraryja' -eq 'true') {
                $JavlibraryJa = $true
            }
            if ($settings.Main.'scrape-r18zh' -eq 'true') {
                $R18Zh = $true
            }
            if ($settings.Main.'scrape-javbus' -eq 'true') {
                $Javbus = $true
            }
            if ($settings.Main.'scrape-javbusja' -eq 'true') {
                $javbusJa = $true
            }

            if ($settings.Main.'scrape-jav321' -eq 'true') {
                $jav321 = $true
            }
        }
    }

    process {
        if (Test-Path -Path $Find) {
            $getItem = Get-Item $Find
        }

        if ($Find -match 'http:\/\/' -or $Find -match 'https:\/\/') {
            $urlList = Convert-CommaDelimitedString -String $Find
            $urlLocation = Test-UrlLocation -Url $urlList
            if ($Aggregated.IsPresent) {
                $aggregatedDataObject = Get-AggregatedDataObject -UrlLocation $urlLocation -Settings $Settings -ScriptRoot $ScriptRoot -ErrorAction 'SilentlyContinue'
                Write-Output $aggregatedDataObject | Select-Object Search, Id, Title, AlternateTitle, Description, ReleaseDate, ReleaseYear, Runtime, Director, Maker, Label, Series, Rating, RatingCount, Actress, Genre, ActressThumbUrl, CoverUrl, ScreenshotUrl, TrailerUrl, DisplayName, FolderName, FileName
            } else {
                if ($urlLocation.Result -eq 'r18') {
                    $r18Data = Get-R18DataObject -Url $Find -ErrorAction 'SilentlyContinue'
                    Write-Output $r18Data | Select-Object Url, Id, ContentId, Title, Description, Date, Year, Runtime, Director, Maker, Label, Series, Actress, Genre, ActressThumbUrl, CoverUrl, ScreenshotUrl, TrailerUrl
                }

                if ($urlLocation.Result -eq 'r18zh') {
                    $r18Data = Get-R18DataObject -Url $Find -Zh -ErrorAction 'SilentlyContinue'
                    Write-Output $r18Data | Select-Object Url, Id, ContentId, Title, Description, Date, Year, Runtime, Director, Maker, Label, Series, Actress, Genre, ActressThumbUrl, CoverUrl, ScreenshotUrl, TrailerUrl
                }

                if ($urlLocation.Result -eq 'dmm') {
                    $dmmData = Get-DmmDataObject -Url $Find -ErrorAction 'SilentlyContinue'
                    Write-Output $dmmData | Select-Object Url, Id, ContentId, Title, Description, Date, Year, Runtime, Director, Maker, Label, Series, Rating, RatingCount, Actress, Genre, CoverUrl, ScreenshotUrl
                }

                if ($urlLocation.Result -eq 'javlibrary') {
                    $javlibraryData = Get-JavlibraryDataObject -Url $Find -ScriptRoot $ScriptRoot -ErrorAction 'SilentlyContinue'
                    Write-Output $javlibraryData | Select-Object Url, Id, Title, Date, Year, Runtime, Director, Maker, Label, Series, Rating, Actress, Genre, CoverUrl, ScreenshotUrl
                }

                if ($urlLocation.Result -eq 'javlibraryzh') {
                    $javlibraryData = Get-JavLibraryDataObject -Url $Find -Zh -ScriptRoot $ScriptRoot -ErrorAction 'SilentlyContinue'
                    Write-Output $javlibraryData | Select-Object Url, Id, Title, Date, Year, Runtime, Director, Maker, Label, Series, Rating, Actress, Genre, CoverUrl, ScreenshotUrl
                }

                if ($urlLocation.Result -eq 'javlibraryja') {
                    $javlibraryData = Get-JavLibraryDataObject -Url $Find -Ja -ScriptRoot $ScriptRoot -ErrorAction 'SilentlyContinue'
                    Write-Output $javlibraryData | Select-Object Url, Id, Title, Date, Year, Runtime, Director, Maker, Label, Series, Rating, Actress, Genre, CoverUrl, ScreenshotUrl
                }

                if ($urlLocation.Result -eq 'javbus') {
                    $javbusData = Get-JavbusDataObject -Url $Find -ErrorAction 'SilentlyContinue'
                    Write-Output $javbusData | Select-Object Url, Id, Title, Date, Year, Runtime, Director, Maker, Label, Series, Rating, Actress, Genre, CoverUrl, ScreenshotUrl
                }

                if ($urlLocation.Result -eq 'javbusja') {
                    $javbusData = Get-JavbusDataObject -Url $Find -Ja -ErrorAction 'SilentlyContinue'
                    Write-Output $javbusData | Select-Object Url, Id, Title, Date, Year, Runtime, Director, Maker, Label, Series, Rating, Actress, Genre, CoverUrl, ScreenshotUrl
                }

                if ($urlLocation.Result -eq 'jav321') {
                    $jav321Data = Get-Jav321DataObject -Url $Find -ErrorAction 'SilentlyContinue'
                    Write-Output $jav321Data | Select-Object Url, Id, Title, Date, Year, Runtime, Director, Maker, Label, Series, Rating, Actress, Genre, CoverUrl, ScreenshotUrl
                }
            }
        } elseif ($null -ne $getItem) {
            if (Test-Path -Path $getItem -PathType Leaf) {
                $fileDetails = Convert-JavTitle -Path $Find -Recurse:$Recurse -Settings $Settings
                if ($Aggregated.IsPresent) {
                    $aggregatedDataObject = Get-AggregatedDataObject -FileDetails $fileDetails -Settings $ettings -R18:$R18 -Dmm:$Dmm -Javlibrary:$Javlibrary -JavlibraryJa:$JavlibraryJa -JavlibraryZh:$JavlibraryZh -Javbus:$Javbus -JavbusJa:$JavbusJa -Jav321:$Jav321 -ScriptRoot $ScriptRoot -ErrorAction 'SilentlyContinue'
                    Write-Output $aggregatedDataObject | Select-Object Search, Id, Title, AlternateTitle, Description, ReleaseDate, ReleaseYear, Runtime, Director, Maker, Label, Series, Rating, RatingCount, Actress, Genre, ActressThumbUrl, CoverUrl, ScreenshotUrl, TrailerUrl, DisplayName, FolderName, FileName
                } else {
                    if ($r18) {
                        $r18Data = Get-R18DataObject -Name $fileDetails.Id  -AltName $fileDetails.ContentId -ErrorAction 'SilentlyContinue'
                        Write-Output $r18Data | Select-Object Url, Id, ContentId, Title, Description, Date, Year, Runtime, Director, Maker, Label, Series, Actress, Genre, ActressThumbUrl, CoverUrl, ScreenshotUrl, TrailerUrl
                    }

                    if ($r18zh) {
                        $r18Data = Get-R18DataObject -Name $fileDetails.Id  -AltName $fileDetails.ContentId -Zh -ErrorAction 'SilentlyContinue'
                        Write-Output $r18Data | Select-Object Url, Id, ContentId, Title, Description, Date, Year, Runtime, Director, Maker, Label, Series, Actress, Genre, ActressThumbUrl, CoverUrl, ScreenshotUrl, TrailerUrl
                    }

                    if ($dmm) {
                        $dmmData = Get-DmmDataObject -Name $fileDetails.Id  -AltName $fileDetails.ContentId -ErrorAction 'SilentlyContinue'
                        Write-Output $dmmData | Select-Object Url, Id, ContentId, Title, Description, Date, Year, Runtime, Director, Maker, Label, Series, Rating, RatingCount, Actress, Genre, CoverUrl, ScreenshotUrl
                    }

                    if ($javlibrary) {
                        $javlibraryData = Get-JavlibraryDataObject -Name $fileDetails.Id -ScriptRoot $ScriptRoot -ErrorAction 'SilentlyContinue'
                        Write-Output $javlibraryData | Select-Object Url, Id, Title, Date, Year, Runtime, Director, Maker, Label, Series, Rating, Actress, Genre, CoverUrl, ScreenshotUrl
                    }

                    if ($javlibraryzh) {
                        $javlibraryData = Get-JavlibraryDataObject -Name $fileDetails.Id -ScriptRoot $ScriptRoot -Zh -ErrorAction 'SilentlyContinue'
                        Write-Output $javlibraryData | Select-Object Url, Id, Title, Date, Year, Runtime, Director, Maker, Label, Series, Rating, Actress, Genre, CoverUrl, ScreenshotUrl
                    }

                    if ($javlibraryja) {
                        $javlibraryData = Get-JavlibraryDataObject -Name $fileDetails.Id -ScriptRoot $ScriptRoot -Ja -ErrorAction 'SilentlyContinue'
                        Write-Output $javlibraryData | Select-Object Url, Id, Title, Date, Year, Runtime, Director, Maker, Label, Series, Rating, Actress, Genre, CoverUrl, ScreenshotUrl
                    }

                    if ($javbus) {
                        $javbusData = Get-JavbusDataObject -Name $fileDetails.Id -ErrorAction 'SilentlyContinue'
                        Write-Output $javlibraryData | Select-Object Url, Id, Title, Date, Year, Runtime, Director, Maker, Label, Series, Rating, Actress, Genre, CoverUrl, ScreenshotUrl
                    }

                    if ($javbusja) {
                        $javbusData = Get-JavbusDataObject -Name $fileDetails.Id -Ja -ErrorAction 'SilentlyContinue'
                        Write-Output $javbusData | Select-Object Url, Id, Title, Date, Year, Runtime, Director, Maker, Label, Series, Rating, Actress, Genre, CoverUrl, ScreenshotUrl
                    }

                    if ($jav321) {
                        $jav321Data = Get-Jav321DataObject -name $fileDetails.Id -ErrorAction 'SilentlyContinue'
                        Write-Output $jav321Data | Select-Object Url, Id, Title, Date, Year, Runtime, Director, Maker, Label, Series, Rating, Actress, Genre, CoverUrl, ScreenshotUrl
                    }
                }
            }
        } else {
            if ($Aggregated.IsPresent) {
                $aggregatedDataObject = Get-AggregatedDataObject -Id $Find -Settings $Settings -R18:$R18 -Dmm:$Dmm -Javlibrary:$Javlibrary -Javbus:$Javbus -JavbusJa:$JavbusJa -Jav321:$Jav321 -ScriptRoot $ScriptRoot -ErrorAction 'SilentlyContinue'
                Write-Output $aggregatedDataObject | Select-Object Search, Id, Title, AlternateTitle, Description, ReleaseDate, ReleaseYear, Runtime, Director, Maker, Label, Series, Rating, RatingCount, Actress, Genre, ActressThumbUrl, CoverUrl, ScreenshotUrl, TrailerUrl, DisplayName, FolderName, FileName
            } else {
                if ($r18) {
                    $r18Data = Get-R18DataObject -Name $Find -ErrorAction 'SilentlyContinue'
                    Write-Output $r18Data | Select-Object Url, Id, ContentId, Title, Description, Date, Year, Runtime, Director, Maker, Label, Series, Actress, Genre, ActressThumbUrl, CoverUrl, ScreenshotUrl, TrailerUrl
                }

                if ($r18zh) {
                    $r18Data = Get-R18DataObject -Name $Find -Zh -ErrorAction 'SilentlyContinue'
                    Write-Output $r18Data | Select-Object Url, Id, ContentId, Title, Description, Date, Year, Runtime, Director, Maker, Label, Series, Actress, Genre, ActressThumbUrl, CoverUrl, ScreenshotUrl, TrailerUrl
                }

                if ($dmm) {
                    $dmmData = Get-DmmDataObject -Name $Find -ErrorAction 'SilentlyContinue'
                    Write-Output $dmmData | Select-Object Url, Id, ContentId, Title, Description, Date, Year, Runtime, Director, Maker, Label, Series, Rating, RatingCount, Actress, Genre, CoverUrl, ScreenshotUrl
                }

                if ($javlibrary) {
                    $javlibraryData = Get-JavlibraryDataObject -Name $Find -ScriptRoot $ScriptRoot -ErrorAction 'SilentlyContinue'
                    Write-Output $javlibraryData | Select-Object Url, Id, Title, Date, Year, Runtime, Director, Maker, Label, Series, Rating, Actress, Genre, CoverUrl, ScreenshotUrl
                }

                if ($javlibraryzh) {
                    $javlibraryData = Get-JavlibraryDataObject -Name $Find -ScriptRoot $ScriptRoot -Zh -ErrorAction 'SilentlyContinue'
                    Write-Output $javlibraryData | Select-Object Url, Id, Title, Date, Year, Runtime, Director, Maker, Label, Series, Rating, Actress, Genre, CoverUrl, ScreenshotUrl
                }

                if ($javlibraryja) {
                    $javlibraryData = Get-JavlibraryDataObject -Name $Find -ScriptRoot $ScriptRoot -Ja -ErrorAction 'SilentlyContinue'
                    Write-Output $javlibraryData | Select-Object Url, Id, Title, Date, Year, Runtime, Director, Maker, Label, Series, Rating, Actress, Genre, CoverUrl, ScreenshotUrl
                }

                if ($javbus) {
                    $javbusData = Get-JavbusDataObject -Name $Find -ErrorAction 'SilentlyContinue'
                    Write-Output $javlibraryData | Select-Object Url, Id, Title, Date, Year, Runtime, Director, Maker, Label, Series, Rating, Actress, Genre, CoverUrl, ScreenshotUrl
                }

                if ($javbusja) {
                    $javbusData = Get-JavbusDataObject -Name $Find -Ja -ErrorAction 'SilentlyContinue'
                    Write-Output $javbusData | Select-Object Url, Id, Title, Date, Year, Runtime, Director, Maker, Label, Series, Rating, Actress, Genre, CoverUrl, ScreenshotUrl
                }

                if ($jav321) {
                    $jav321Data = Get-Jav321DataObject -Name $Find -ErrorAction 'SilentlyContinue'
                    Write-Output $jav321Data | Select-Object Url, Id, Title, Date, Year, Runtime, Director, Maker, Label, Series, Rating, Actress, Genre, CoverUrl, ScreenshotUrl
                }
            }
        }
    }

    end {
        Write-Debug "[$(Get-TimeStamp)][$($MyInvocation.MyCommand.Name)] Function ended"
    }
}
