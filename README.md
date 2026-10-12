# Soc-Mini-Tool
Mini Windows SOC Investigator

A beginner-friendly Windows security investigation tool built with PowerShell.

Overview

Mini Windows SOC Investigator collects useful Windows system information to support basic security investigations. It demonstrates practical PowerShell commands commonly useful in a Security Operations Center (SOC).

Features

Process Investigation: Lists running processes, parent process IDs, memory usage, and processes running from AppData.

Network Investigation: Displays TCP connections, connection states, IP addresses, ports, and owning process IDs.

Service Investigation: Lists Windows services, their states, and startup modes.

Event Log Investigation: Retrieves recent System, Application, and PowerShell Operational events.

Full System Investigation: Provides a basic system snapshot, process and service counts, and recent critical or error System events.

Interactive Menu: Allows the user to choose an investigation.

Requirements

Windows 10 or Windows 11

Windows PowerShell 5.1 or compatible PowerShell

Git (only needed to contribute to this repository)

Some queries may require additional permissions or may return different results depending on Windows configuration.

How to Run

Download or clone this repository.

Open PowerShell in the project folder.

Run:

.\main.ps1

Choose an investigation from the menu.

If your execution policy blocks the script, you can allow it for the current PowerShell session:

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

Then run the script again.

Learning Objectives

Practice PowerShell commands for endpoint investigation.

Understand process IDs and parent process IDs.

Inspect TCP connections and owning processes.

Review Windows services and event logs.

Build a simple command-line SOC tool.

Limitations

This tool collects information; it does not automatically determine whether a system is compromised. Findings must be validated using additional evidence. It does not stop processes, change services, or modify event logs.

Future Improvements

Export investigation reports to CSV or TXT.

Add event filtering by Event ID and time range.

Correlate process and network information.

Improve error handling and reporting.

Disclaimer

For educational purposes and authorized security investigations only.
