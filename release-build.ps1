if (!(Test-Path "config.xml")) {
    Write-Error -Message "config.xml has to be created first! `n`
    Make sure that you are in /build when you start the script." `
    -Category ProtocolError

    exit(1)
}

$config = Import-Clixml "config.xml"
Write-Output $config

Set-Location ".."

$exes = @(("app", "app.exe"), ("src", "byosens.dll"), ("tests", "tests.exe"))
$libs = @("Qt5Charts.dll", "Qt5Core.dll", "Qt5Gui.dll", "Qt5SerialPort.dll",
          "Qt5Svg.dll", "Qt5Test.dll", "Qt5Widgets.dll")

Write-Progress -Activity "Configuration" -Status "Creating directories"

foreach ($folder in @($config.out, $config.shadow)) {
    if (!(Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder
    }
}

# Load compiler, headers etc
$environment_Vars = & "$($config.visualstudio)VC\vcvarsall.bat" x64 "&set"
foreach ($var in $environment_Vars) {
    $key, $value = $var.split("=")
    [System.Environment]::SetEnvironmentVariable($key, $value, "Process")

    Write-Progress `
    -Activity "Configuration" `
    -Status "Loading environment variable [$key]" `
    -PercentComplete (++$counter / $environment_Vars.Count * 100)
}

# Build to shadow directory
Set-Location $config.shadow

Write-Progress -Activity "Compilation" -Status "QMake"
& $config.qmake "..\$($config.project)" $config.qmakeflags.split(" ") `
"CONFIG+=$($config.qmakeconfig)" >> "..\$($config.logfile)"

Write-Progress -Activity "Compilation" -Status "Compiling"
& $config.jom /S /L /J 8 >> "..\$($config.logfile)"

# Copy executables and libraries
Set-Location "..\$($config.out)"

Write-Progress -Activity "Distribution" -Status "Copying libraries"
$libs | ForEach-Object { Copy-Item "$($config.libs)\$_" }

Write-Progress -Activity "Distribution" -Status "Copying executables"
$exes | ForEach-Object { Copy-Item "..\$($config.shadow)\$($_[0])\release\$($_[1])" }

# Run tests
Write-Progress -Activity "Testing" -Status "Running tests"
& ".\tests.exe" "-silent"

# Uncomment to remove shadow files:
# Remove-Item "..\$path_Shadow" -Recurse 

Set-Location ..