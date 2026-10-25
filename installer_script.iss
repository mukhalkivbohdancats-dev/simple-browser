[Setup]
AppName=Kishka Browser
AppVersion=1.1
DefaultDirName={autopf}\KishkaBrowser
DefaultGroupName=Kishka Browser
DisableDirPage=no
UninstallDisplayIcon={app}\main.exe
Compression=lzma2
SolidCompression=yes
OutputDir=exe
OutputBaseFilename=Kishka-Browser-Installer_V1.1
SetupIconFile=icon.ico
PrivilegesRequired=lowest

[Tasks]
Name: "desktopicon"; Description: "Створити ярлик на робочому столі"; GroupDescription: "Додатково:"

[Files]
; Повне перезаписування старих файлів, щоб не залишалося сміття
Source: "dist\main\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs confirmoverwrite

[Icons]
Name: "{group}\Kishka Browser"; Filename: "{app}\main.exe"; IconFilename: "{app}\icon.ico"
Name: "{autodesktop}\Kishka Browser"; Filename: "{app}\main.exe"; IconFilename: "{app}\icon.ico"; Tasks: desktopicon

[Run]
Filename: "{app}\main.exe"; Description: "Запустити Kishka Browser"; Flags: postinstall nowait skipifsilent
