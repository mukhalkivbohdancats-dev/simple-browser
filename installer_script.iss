[Setup]
AppName=Кішка Браузер
AppVerName=Кішка Браузер 1.0
DefaultDirName={sd}\Кішка браузер
DefaultGroupName=Кішка Браузер
DisableProgramGroupPage=yes
OutputDir=.
OutputBaseFilename=KishkaBrowserSetup
Compression=lzma
SolidCompression=yes
PrivilegesRequired=lowest

[Files]
; Копіювання всіх зкомпільованих файлів з папки dist з перезаписом старих
Source: "dist\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autodesktop}\Кішка Браузер"; Filename: "{app}\main.exe"; IconFilename: "{app}\icon.ico"
Name: "{group}\Кішка Браузер"; Filename: "{app}\main.exe"; IconFilename: "{app}\icon.ico"

[UninstallDelete]
; Повне очищення папки при видаленні або чистій установці
Type: filesandordirs; Name: "{app}\*"
