Set-Alias cl clear   
Set-Alias top Taskmgr.exe                                                                                                   
function whoareyou() { Get-ComputerInfo | Select-Object CsName, CsManufacturer, CsModel, Osname, osbuildnumber }                     
function battery()
{
 (Get-CimInstance win32_battery).EstimatedChargeRemaining;
   if ((Get-CimInstance Win32_Battery).BatteryStatus -eq 2)
   {
      Write-Host 'Loading'
   };
}
function clock() { while ($true) { Write-Progress -Activity 'PowerShell Clock'  -Status (Get-Date -Format F) -PercentComplete ((Get-Date).Second / .6); Start-Sleep -Milliseconds 99 } }

# Shell:                                                                                                                
$wscript = New-Object -ComObject WScript.Shell

Import-Module assert
(Split-Path -Path (Get-Module assert).path ) + '\Format\src\Format.psm1' | Import-Module
New-Alias nice Format-Collection -Force

function node-project
{
   git init
   npx license $(npm get init.license) -o "$(npm get init.author.name)" > LICENSE
   npx gitignore node
   npx covgen "$(npm get init.author.email)"
   npm init -y
   git add -A
   git commit -m 'Initial commit'
}

function new-pw ($length)
{
   -join ((1..$length) | ForEach-Object { Get-Random -Min 33 -Max 127 | ForEach-Object { [char]$_ } }) | Set-Clipboard
}

function conda
{
   powershell.exe -ExecutionPolicy ByPass -NoExit -Command "& 'C:\ProgramData\Anaconda3\shell\condabin\conda-hook.ps1' ; conda activate 'C:\ProgramData\Anaconda3' "    
}

function leelatraingpu {
   if ((Get-Process | Where-Object { ($_.ProcessName -eq 'powershell') -and $_.CommandLine -like '*nvidia-smi.exe dmon' } | Measure-Object).Count -eq 0) {
      Start-Process powershell -ArgumentList nvidia-smi.exe, dmon ;
   }
   Set-Location C:\Users\Martin\lc0-v0.29.0-rc\;
   &'./lc0-training-client.exe' --password $env:LC0_PW --user $env:LC0_USER --report-gpu;
   Set-Location -;
}

$equal_tempered_scale = @{Eb2 = 77.78; E2 = 82.41; F2 = 87.31; Gb2 = 92.50; G2 = 98.00; Ab2 = 103.83; A2 = 110.00; Bb2 = 116.54; B2 = 123.47; C3 = 130.81; Db3 = 138.59; D3 = 146.83; Eb3 = 155.56; E3 = 164.81; F3 = 174.61; Gb3 = 185.00; G3 = 196.00; Ab3 = 207.65; A3 = 220.00; Bb3 = 233.08; B3 = 246.94; C4 = 261.63; Db4 = 277.18; D4 = 293.66; Eb4 = 311.13; E4 = 329.63; F4 = 349.23; Gb4 = 369.99; G4 = 392.00; Ab4 = 415.30; A4 = 440.00; Bb4 = 466.16; B4 = 493.88; C5 = 523.25; Db5 = 554.37; D5 = 587.33; Eb5 = 622.25; E5 = 659.25; F5 = 698.46; Gb5 = 739.99; G5 = 783.99; Ab5 = 830.61; A5 = 880.00; Bb5 = 932.33; B5 = 987.77; C6 = 1046.50; Db6 = 1108.73; D6 = 1174.66; Eb6 = 1244.51; E6 = 1318.51; F6 = 1396.91; Gb6 = 1479.98; G6 = 1567.98; Ab6 = 1661.22; A6 = 1760.00; Bb6 = 1864.66; B6 = 1975.53 }

#  @('a4','a4','bb4','d4','g4','bb4','c5','f4','a4','bb4','bb4','g4','bb4','d5','eb5','g4','d5','c5')|%{[System.Console]::Beep($equal_tempered_scale[$_],430)}

# Signing:

# $codeCertificate = Get-ChildItem Cert:\LocalMachine\My | Where-Object {$_.Subject -eq "CN=ATA Authenticode"}
# Set-AuthenticodeSignature -FilePath $path -Certificate $codeCertificate -TimeStampServer http://timestamp.digicert.com

Add-Type -TypeDefinition '
using System;
using System.Runtime.InteropServices;
 
namespace Utilities {
   public static class Display
   {
      [DllImport("user32.dll", CharSet = CharSet.Auto)]
      private static extern IntPtr PostMessage(
         IntPtr hWnd,
         UInt32 Msg,
         IntPtr wParam,
         IntPtr lParam
      );
 
      public static void PowerOff ()
      {
         PostMessage(
            (IntPtr)0xffff, // HWND_BROADCAST
            0x0112,         // WM_SYSCOMMAND
            (IntPtr)0xf170, // SC_MONITORPOWER
            (IntPtr)0x0002  // POWER_OFF
         );
      }
   }
}
'

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile))
{
   Import-Module "$ChocolateyProfile"
}
function datepicker {
   Add-Type -AssemblyName System.Windows.Forms
   Add-Type -AssemblyName System.Drawing

   $form = New-Object Windows.Forms.Form -Property @{
      StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
      Size          = New-Object Drawing.Size 280, 250
      Text          = 'Select a Date'
      Topmost       = $true
   }

   $calendar = New-Object Windows.Forms.MonthCalendar -Property @{
      ShowTodayCircle   = $false
      MaxSelectionCount = 1
   }
   $form.Controls.Add($calendar)

   $okButton = New-Object Windows.Forms.Button -Property @{
      Location     = New-Object Drawing.Point 38, 185
      Size         = New-Object Drawing.Size 75, 23
      Text         = 'OK'
      DialogResult = [Windows.Forms.DialogResult]::OK
   }
   $form.AcceptButton = $okButton
   $form.Controls.Add($okButton)

   $cancelButton = New-Object Windows.Forms.Button -Property @{
      Location     = New-Object Drawing.Point 113, 185
      Size         = New-Object Drawing.Size 75, 23
      Text         = 'Cancel'
      DialogResult = [Windows.Forms.DialogResult]::Cancel
   }
   $form.CancelButton = $cancelButton
   $form.Controls.Add($cancelButton)

   $result = $form.ShowDialog()

   if ($result -eq [Windows.Forms.DialogResult]::OK) {
      $date = $calendar.SelectionStart
      Write-Host "Date selected: $($date.ToShortDateString())"
      return $date
   }
}
if(! (Test-Path function:Set-DefaultAudioDevice)){
   $res=iwr "https://raw.githubusercontent.com/SomeProgrammerGuy/Powershell-Default-Audio-Device-Changer/243d8a7860126de31887066f4714d496898aec0d/Set-DefaultAudioDevice.ps1"
   write-debug "received $res"
   iex $res.Content
}
function choose-speaker {
   Set-DefaultAudioDevice(Get-RenderDeviceId -renderDeviceName "Speakers" -renderDeviceInterface "Realtek(R) Audio" | select -Last 1)
}

function choose-headset {
   Set-DefaultAudioDevice(Get-RenderDeviceId -renderDeviceName "Headset Earphone" -renderDeviceInterface "Corsair HS70 Wireless Gaming Headset" | select -First 1)
}

Set-Alias c-s choose-speaker
Set-Alias c-h choose-headset
