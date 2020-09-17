

$personalIdCode = Read-Host "Sisestage isikukood"
if ($personalIdCode.ToString().Length -ne 11) {
    Write-Warning "Isikukood on ebakorrektse pikkusega"
} else {
    $errorVar = $false
    #Esimese numbri kontroll
    [int]$firstNumber = [convert]::ToInt32($personalIdCode[0], 10)
    if ($firstNumber -lt 1 -or
    $firstNumber -gt 8) {
        Write-Warning "Esimene number peab olema vahemikus 1-8"
        $errorVar = $true
    }

    # Sünnikuu kontroll
    [int]$monthNumber = $personalIdCode.Substring(3, 2)
    if ($monthNumber -lt 1 -or $monthNumber -gt 12) {
        Write-Warning "Ebakorrektne sünnikuu"
        $errorVar = $true
    }

    # Täpse sünniaasta arvutamine
    [int]$birthYear = $personalIdCode.Substring(1, 2)

    # Sünnikuupäeva kontroll
    [int]$dayNumber = $personalIdCode.Substring(5, 2)
    if ($dayNumber -lt 1) {
        Write-Warning "Ebakorrektne sünnikuupäev"
        $errorVar = $true
    }
    if ($monthNumber -eq 2) {
        if ($birthYear % 4 -eq 0) {
            if ($dayNumber -gt 29) {
                Write-Warning "Ebakorrektne sünnikuupäev"
                $errorVar = $true
            }
        } else {
            if ($dayNumber -gt 28) {
                Write-Warning "Ebakorrektne sünnikuupäev"
                $errorVar = $true
            }
        }
    } elseif ($monthNumber -eq 1 -or
    $monthNumber -eq 3 -or
    $monthNumber -eq 5 -or
    $monthNumber -eq 7 -or
    $monthNumber -eq 8 -or
    $monthNumber -eq 10 -or
    $monthNumber -eq 12) {
        if ($dayNumber -gt 31) {
            Write-Warning "Ebakorrektne sünnikuupäev"
            $errorVar = $true
        }
    } elseif ($monthNumber -eq 4 -or
    $monthNumber -eq 6 -or
    $monthNumber -eq 9 -or
    $monthNumber -eq 11) {
        if ($dayNumber -gt 30) {
            Write-Warning "Ebakorrektne sünnikuupäev"
            $errorVar = $true
        }
    } 
    # Kontrollnumbri kontroll
    [int]$testNumberSum = 0
    for ($i = 0; $i -le 9; $i++) {
        [int]$currentNumber = [convert]::ToInt32($personalIdCode[$i], 10)
        [int]$multiplicator = ($i + 1)
        if ($multiplicator -eq 10) {
            $multiplicator = 1
        }
        $testNumberSum += $currentNumber * $multiplicator
    }

    $testNumberSumResidue = $testNumberSum % 11

    if ($testNumberSumResidue -eq 10) {
        $testNumberSum = 0
        [int]$index = 2
        for ($i = 0; $i -le 9; $i++) {
            if ($index++ -eq 9) {
                $index = 0
            }
            [int]$currentNumber = [convert]::ToInt32($personalIdCode[$index], 10)
            [int]$multiplicator = ($i + 3)
            if ($multiplicator -eq 10) {
                $multiplicator = 1
            }
            $testNumberSum += $currentNumber * $multiplicator
        }
    }

    $testNumberSumResidue = $testNumberSum % 11

    if ($testNumberSumResidue -ne [convert]::ToInt32($personalIdCode[$i], 10)) {
        Write-Warning "Ebakorrektne kontrollnumber"
        $errorVar = $true
    }

    if ($errorVar) {
        return
    }

    [string]$gender
    [int]$birthCentury
    [int]$birthYear
    [string]$birthMonth
    [int]$birthDay
    [string]$hospital
    [int]$birthQueue

    # Sugu ja sünnisajandi arvutamine
    [int]$firstIdDigit = [convert]::ToInt32($personalIdCode[0], 10)
    if ($firstIdDigit -eq 1) {
        $gender = "Mees"
        $birthCentury = 1800
    } elseif ($firstIdDigit -eq 2) {
        $gender = "Naine"
        $birthCentury = 1800
    } elseif ($firstIdDigit -eq 3) {
        $gender = "Mees"
        $birthCentury = 1900
    } elseif ($firstIdDigit -eq 4) {
        $gender = "Naine"
        $birthCentury = 1900
    } elseif ($firstIdDigit -eq 5) {
        $gender = "Mees"
        $birthCentury = 2000
    } elseif ($firstIdDigit -eq 6) {
        $gender = "Naine"
        $birthCentury = 2000
    } elseif ($firstIdDigit -eq 7) {
        $gender = "Mees"
        $birthCentury = 2100
    } elseif ($firstIdDigit -eq 8) {
        $gender = "Naine"
        $birthCentury = 2100
    }

    # Haigla ja sündivusjärjekorra arvutamine
    [int]$hospitalAndBornOrder = '{0:d3}' -f [int] $personalIdCode.Substring(7, 3)
    if ($hospitalAndBornOrder -ge 001 -and $hospitalAndBornOrder -le 010) {
        $hospital = "Kuressaare Haigla"
        $birthQueue = $hospitalAndBornOrder
    } elseif ($hospitalAndBornOrder -ge 011 -and $hospitalAndBornOrder -le 019) {
        $hospital = "Tartu Ülikooli Naistekliinik, Tartumaa, Tartu"
        $birthQueue = $hospitalAndBornOrder - 10
    } elseif ($hospitalAndBornOrder -ge 021 -and $hospitalAndBornOrder -le 220) {
        $hospital = "Ida-Tallinna Keskhaigla, Pelgulinna sünnitusmaja, Hiiumaa, Keila, Rapla haigla, Loksa haigla"
        $birthQueue = $hospitalAndBornOrder - 20
    } elseif ($hospitalAndBornOrder -ge 221 -and $hospitalAndBornOrder -le 270) {
        $hospital = "Ida-Viru Keskhaigla (Kohtla-Järve, endine Jõhvi)"
        $birthQueue = $hospitalAndBornOrder - 220
    } elseif ($hospitalAndBornOrder -ge 271 -and $hospitalAndBornOrder -le 370) {
        $hospital = "Maarjamõisa Kliinikum (Tartu), Jõgeva Haigla"
        $birthQueue = $hospitalAndBornOrder - 270
    } elseif ($hospitalAndBornOrder -ge 371 -and $hospitalAndBornOrder -le 420) {
        $hospital = "Narva Haigla"
        $birthQueue = $hospitalAndBornOrder - 370
    } elseif ($hospitalAndBornOrder -ge 421 -and $hospitalAndBornOrder -le 470) {
        $hospital = "Pärnu Haigla"
        $birthQueue = $hospitalAndBornOrder - 420
    } elseif ($hospitalAndBornOrder -ge 471 -and $hospitalAndBornOrder -le 490) {
        $hospital = "Pelgulinna Sünnitusmaja (Tallinn), Haapsalu haigla"
        $birthQueue = $hospitalAndBornOrder - 470
    } elseif ($hospitalAndBornOrder -ge 491 -and $hospitalAndBornOrder -le 520) {
        $hospital = "Järvamaa Haigla (Paide)"
        $birthQueue = $hospitalAndBornOrder - 490
    } elseif ($hospitalAndBornOrder -ge 521 -and $hospitalAndBornOrder -le 570) {
        $hospital = "Rakvere, Tapa haigla"
        $birthQueue = $hospitalAndBornOrder - 520
    } elseif ($hospitalAndBornOrder -ge 571 -and $hospitalAndBornOrder -le 600) {
        $hospital = "Valga Haigla"
        $birthQueue = $hospitalAndBornOrder - 570
    } elseif ($hospitalAndBornOrder -ge 601 -and $hospitalAndBornOrder -le 650) {
        $hospital = "Viljandi Haigla"
        $birthQueue = $hospitalAndBornOrder - 600
    } elseif ($hospitalAndBornOrder -ge 651 -and $hospitalAndBornOrder -le 700) {
        $hospital = "Lõuna-Eesti Haigla (Võru), Põlva Haigla"
        $birthQueue = $hospitalAndBornOrder - 650
    }

    #Kuupäeva arvutamine
    if ($monthNumber -eq 1) {
        $birthMonth = "Jaanuar"
    } elseif ($monthNumber -eq 2) {
        $birthMonth = "Veebruar"
    } elseif ($monthNumber -eq 3) {
        $birthMonth = "Märts"
    } elseif ($monthNumber -eq 4) {
        $birthMonth = "Aprill"
    } elseif ($monthNumber -eq 5) {
        $birthMonth = "Mai"
    } elseif ($monthNumber -eq 6) {
        $birthMonth = "Juuni"
    } elseif ($monthNumber -eq 7) {
        $birthMonth = "Juuli"
    } elseif ($monthNumber -eq 8) {
        $birthMonth = "August"
    } elseif ($monthNumber -eq 9) {
        $birthMonth = "September"
    } elseif ($monthNumber -eq 10) {
        $birthMonth = "Oktoober"
    } elseif ($monthNumber -eq 11) {
        $birthMonth = "November"
    } elseif ($monthNumber -eq 12) {
        $birthMonth = "Detsember"
    }
    $specificBirthYear = $birthCentury + $birthYear
    Write-Host "Tervist, oled $gender. Sündisid aastal $specificBirthYear. $dayNumber. $birthMonth. Sündisid $hospital antud päeval $birthQueue-na"
}