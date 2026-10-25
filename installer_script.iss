[Setup]
AppName=Kishka Browser
AppVersion=1.2
DefaultDirName={autopf}\KishkaBrowser_New
DefaultGroupName=Kishka Browser New
DisableDirPage=no
UninstallDisplayIcon={app}\KishkaBrowser.exe
Compression=lzma2
SolidCompression=yes
OutputDir=exe
OutputBaseFilename=Kishka-Browser-Installer_V1.2
SetupIconFile=icon.ico
PrivilegesRequired=lowest

[Tasks]
Name: "desktopicon"; Description: "Створити ярлик на робочому столі"; GroupDescription: "Додатково:"

[Files]
Source: "dist\KishkaBrowser\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs confirmoverwrite

[Icons]
Name: "{group}\Kishka Browser"; Filename: "{app}\KishkaBrowser.exe"; IconFilename: "{app}\icon.ico"
Name: "{autodesktop}\Kishka Browser"; Filename: "{app}\KishkaBrowser.exe"; IconFilename: "{app}\icon.ico"; Tasks: desktopicon

[Run]
Filename: "{app}\KishkaBrowser.exe"; Description: "Запустити Kishka Browser"; Flags: postinstall nowait skipifsilent
