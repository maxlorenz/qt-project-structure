# Get VS and Qmake bin path
$VS_REG = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\VisualStudio"
[xml]$qt_conf = Get-Content "$env:APPDATA\QtProject\qtcreator\qtversion.xml"

$VS = @("$VS_REG\14.0", "$VS_REG\12.0", "$VS_REG\10.0") `
| Where-Object { Test-Path $_ } `
| ForEach-Object { Get-ItemProperty $_ | Select-Object -ExpandProperty "ShellFolder" }

$Qmake = $qt_conf.qtcreator.data[0].valuemap.ChildNodes `
| Where-Object { $_.key -eq "QMakePath" } `
| Select-Object -ExpandProperty "#text" -First 1

# Load environment variables
& "$VS\VC\vcvarsall.bat" x64 "&set" `
| ForEach-Object { $k, $v = $_.split("="); [System.Environment]::SetEnvironmentVariable($k, $v, "Process") }

if (!(Test-Path dist)) { New-Item -ItemType Directory -Path dist }
Set-Location .\dist

# Build
& "$Qmake" ../SampleProject.pro -spec win32-msvc2015 CONFIG+=release
& C:\Qt\Tools\QtCreator\bin\jom.exe /S

# Copy libs + exes
$Qt_libs = [System.IO.Path]::GetDirectoryName($Qmake)
@("Qt5Core.dll", "Qt5Gui.dll", "Qt5Test.dll", "Qt5Widgets.dll") `
| ForEach-Object { Copy-Item "$Qt_libs\$_" -Force }

Get-ChildItem -Path ".\*\*" -Recurse -Include "*.exe", "*.dll" `
| ForEach-Object { Copy-Item $_ -Force }

# Show test results
& ".\tst_sampletest.exe"
Set-Location ..