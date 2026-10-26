; ============================================================
;  Kishka Browser V1.4 — Inno Setup Script
;  Розміщується у корені репозиторію поруч з icon.ico
; ============================================================

#define MyAppName "Kishka Browser"
#define MyAppVersion "1.4"
#define MyAppPublisher "Kishka"
#define MyAppExeName "Kishka-Browser_V1.4.exe"

[Setup]
; Унікальний ID — НЕ змінюйте його між версіями
AppId={{8A7B5C3D-1E4F-4A2B-9C3D-K1SHKA00001}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName=C:\KishkaBrowser
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes

; Куди покласти готовий інсталятор (папка "installer" у корені)
OutputDir=installer
OutputBaseFilename=Kishka-Browser_V1.4_Setup

; Іконка самого інсталятора
SetupIconFile=icon.ico

; Стиснення
Compression=lzma2/ultra64
SolidCompression=yes

; Сучасний стиль вікна інсталятора
WizardStyle=modern

; Потрібні права адміністратора (щоб писати в C:\)
PrivilegesRequired=admin

; Іконка для "Програми та компоненти" Windows
UninstallDisplayIcon={app}\icon.ico
UninstallDisplayName={#MyAppName} {#MyAppVersion}

[Languages]
Name: "ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl"
Name: "english";   MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "Створити ярлик на робочому столі"; GroupDescription: "Додаткові ярлики:"; Flags: checkedonce

[Files]
; Головний .exe, який зібрав PyInstaller
Source: "dist\Kishka-Browser_V1.4.exe"; DestDir: "{app}"; Flags: ignoreversion

; Іконка (щоб вікно браузера теж її бачило)
Source: "icon.ico"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
; Ярлик у меню "Пуск"
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\icon.ico"
Name: "{group}\Видалити {#MyAppName}"; Filename: "{uninstallexe}"

; Ярлик на робочому столі (якщо обрано)
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\icon.ico"; Tasks: desktopicon

[Dirs]
; Папка для завантажень на диску C:
Name: "C:\KishkaBrowser\Downloads"; Permissions: users-full; Flags: uninsneveruninstall

[Run]
; Після встановлення запропонувати запустити браузер
Filename: "{app}\{#MyAppExeName}"; Description: "Запустити {#MyAppName}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
; Видаляємо лише сам .exe, але Downloads залишаємо недоторканим
Type: files; Name: "{app}\{#MyAppExeName}"
