# Helper functions
function Get-VS-Path() {
    $VS_REG_PATH = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\VisualStudio"
    $VS_VERSIONS = @("14.0", "12.0", "10.0")

    foreach ($version in $VS_Versions) {
        $p = "$VS_REG_PATH\$version"

        if (Test-Path $p) {
            return Get-ItemProperty -Path $p `
            | Select-Object -ExpandProperty "ShellFolder" `
        }
        else {
            throw "Visual Studio couldn't be found on this computer"
        }
    }
}

function Get-Qmake-Path () {
    $QT_CONFIG= "$env:APPDATA\QtProject\qtcreator\qtversion.xml"

    if (Test-Path $QT_CONFIG) {
        [xml]$qt_user_config = Get-Content $QT_CONFIG
        
        return $qt_user_config.qtcreator.data[0].valuemap.ChildNodes `
        | Where-Object { $_.key -eq "QMakePath" } `
        | Select-Object -ExpandProperty "#text" `
    }
    else {
        throw "A Qt-Installation couldn't be found on this computer"
    }
}

# Create config file
$properties = @(
    "out=_dist"
    "shadow=_shadow"
    "logfile=_log.txt"
    "project=ByosensUI.pro"
    "qmakeflags=-r -spec win32-msvc2015"
    "qmakeconfig=release logging_enabled"
    "jom=C:\Qt\Tools\QtCreator\bin\jom.exe"
)

try {
    $p = Get-Qmake-Path
    $properties += ("qmake=$p")
    $properties += ("libs=$([System.IO.Path]::GetDirectoryName($p))")
}
catch [System.Exception] {
    Write-Error -Message $_.Exception.Message
    $properties += ("qmake=NOT FOUND")
}

try {
    $properties += ("visualstudio=$(Get-VS-Path)")
}
catch [System.Exception] {
    Write-Error -Message $_.Exception.Message
    $properties += ("visualstudio=NOT FOUND")
}

$config = New-Object System.Object

foreach ($property in $properties) {
    $name, $value = $property.Split("=")
    $config | Add-Member -Type NoteProperty -Name $name -Value $value
}

Export-Clixml -InputObject $config -Path ".\config.xml"