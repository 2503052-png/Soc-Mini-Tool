
# ==========================================
# MINI WINDOWS SOC INVESTIGATOR
# ==========================================

function Show-Header {
    Clear-Host
    Write-Host "========================================"
    Write-Host "      MINI WINDOWS SOC INVESTIGATOR"
    Write-Host "========================================"
}

# ==========================================
# PHASE 1: PROCESS INVESTIGATION
# ==========================================

function Process-Investigation {
    Write-Host "`n[1] Running Processes"

    Get-CimInstance Win32_Process |
        Select-Object Name, ProcessId, ParentProcessId |
        Format-Table -AutoSize

    Write-Host "`n[2] Top 10 Memory-Using Processes"

    Get-Process |
        Sort-Object WorkingSet64 -Descending |
        Select-Object -First 10 Name, Id, WorkingSet64 |
        Format-Table -AutoSize

    Write-Host "`n[3] Processes Running From AppData"

    Get-CimInstance Win32_Process |
        Where-Object { $_.ExecutablePath -like '*\AppData\*' } |
        Select-Object Name, ProcessId, ParentProcessId, ExecutablePath |
        Format-Table -AutoSize

    Write-Host "`nPHASE 1 COMPLETE"
}

# ==========================================
# PHASE 2: NETWORK INVESTIGATION
# ==========================================

function Network-Investigation {
    Write-Host "`n[1] TCP Connections"

    Get-NetTCPConnection -ErrorAction SilentlyContinue |
        Select-Object LocalAddress, LocalPort,
                      RemoteAddress, RemotePort,
                      State, OwningProcess |
        Format-Table -AutoSize

    Write-Host "`n[2] Established Connections"

    Get-NetTCPConnection -State Established -ErrorAction SilentlyContinue |
        Select-Object LocalAddress, LocalPort,
                      RemoteAddress, RemotePort,
                      OwningProcess |
        Format-Table -AutoSize

    Write-Host "`n[3] Processes With Established Connections"

    Get-NetTCPConnection -State Established -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty OwningProcess -Unique |
        ForEach-Object {
            Get-Process -Id $_ -ErrorAction SilentlyContinue |
                Select-Object Name, Id
        } |
        Format-Table -AutoSize

    Write-Host "`nPHASE 2 COMPLETE"
}

# ==========================================
# PHASE 3: SERVICE INVESTIGATION
# ==========================================

function Service-Investigation {
    Write-Host "`n[1] All Windows Services"

    Get-CimInstance Win32_Service |
        Select-Object Name, State, StartMode, ProcessId |
        Format-Table -AutoSize

    Write-Host "`n[2] Stopped Services"

    Get-CimInstance Win32_Service |
        Where-Object { $_.State -eq 'Stopped' } |
        Select-Object Name, State, StartMode, ProcessId |
        Format-Table -AutoSize

    Write-Host "`n[3] Automatic Services Not Running"

    Get-CimInstance Win32_Service |
        Where-Object {
            $_.StartMode -eq 'Auto' -and
            $_.State -ne 'Running'
        } |
        Select-Object Name, State, StartMode, ProcessId |
        Format-Table -AutoSize

    Write-Host "`nPHASE 3 COMPLETE"
}

# ==========================================
# PHASE 4: EVENT LOG INVESTIGATION
# ==========================================

function EventLog-Investigation {
    Write-Host "`n[1] Recent System Events"

    Get-WinEvent -LogName System -MaxEvents 10 -ErrorAction SilentlyContinue |
        Select-Object TimeCreated, Id, LevelDisplayName, ProviderName, Message |
        Format-List

    Write-Host "`n[2] Recent Application Events"

    Get-WinEvent -LogName Application -MaxEvents 10 -ErrorAction SilentlyContinue |
        Select-Object TimeCreated, Id, LevelDisplayName, ProviderName, Message |
        Format-List

    Write-Host "`n[3] Recent PowerShell Operational Events"

    Get-WinEvent -LogName "Microsoft-Windows-PowerShell/Operational" `
        -MaxEvents 10 -ErrorAction SilentlyContinue |
        Select-Object TimeCreated, Id, LevelDisplayName, ProviderName, Message |
        Format-List

    Write-Host "`nPHASE 4 COMPLETE"
}

# ==========================================
# PHASE 5: FULL SYSTEM INVESTIGATION
# ==========================================

function Full-System-Investigation {
    Write-Host "`n[1] System Information"

    Get-CimInstance Win32_OperatingSystem |
        Select-Object CSName, Caption, Version, LastBootUpTime |
        Format-List

    Write-Host "`n[2] Total Running Processes"

    (Get-Process).Count

    Write-Host "`n[3] Established Network Connections"

    (Get-NetTCPConnection -State Established `
        -ErrorAction SilentlyContinue).Count

    Write-Host "`n[4] Running Services"

    (Get-CimInstance Win32_Service |
        Where-Object { $_.State -eq 'Running' }).Count

    Write-Host "`n[5] Recent Critical or Error System Events"

    Get-WinEvent -FilterHashtable @{
        LogName = 'System'
        Level = 1, 2
    } -MaxEvents 10 -ErrorAction SilentlyContinue |
        Select-Object TimeCreated, Id, LevelDisplayName, ProviderName |
        Format-Table -AutoSize

    Write-Host "`nFULL SYSTEM INVESTIGATION COMPLETE"
}

# ==========================================
# MAIN MENU
# ==========================================

do {
    Show-Header

    Write-Host "1. Process Investigation"
    Write-Host "2. Network Investigation"
    Write-Host "3. Service Investigation"
    Write-Host "4. Event Log Investigation"
    Write-Host "5. Full System Investigation"
    Write-Host "6. Exit"

    $choice = Read-Host "`nSelect an option (1-6)"

    switch ($choice) {
        '1' { Process-Investigation }
        '2' { Network-Investigation }
        '3' { Service-Investigation }
        '4' { EventLog-Investigation }
        '5' { Full-System-Investigation }
        '6' { Write-Host "`nExiting SOC Investigator..." }
        default { Write-Host "`nInvalid choice. Select a number from 1 to 6." }
    }

    if ($choice -ne '6') {
        Write-Host ""
        Read-Host "Press Enter to return to the menu"
    }

} while ($choice -ne '6')
