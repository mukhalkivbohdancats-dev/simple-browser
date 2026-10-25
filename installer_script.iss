[Setup]
AppName=Кішка Браузер
AppVerName=Кішка Браузер 1.3
DefaultDirName={sd}\Кішка браузер
DefaultGroupName=Кішка Браузер
DisableProgramGroupPage=yes
OutputDir=exe
OutputBaseFilename=Kishka-Browser-Installer_V1.3
Compression=lzma
SolidCompression=yes
PrivilegesRequired=lowest

[Files]
; Оновлення файлів
Source: "dist\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autodesktop}\Кішка Браузер"; Filename: "{app}\main.exe"; IconFilename: "{app}\icon.ico"
Name: "{group}\Кішка Браузер"; Filename: "{app}\main.exe"; IconFilename: "{app}\icon.ico"

[UninstallDelete]
Type: filesandordirs; Name: "{app}\*"

; Налаштування завершено
; Готово
