#define MyAppName "Kishka Browser"
#define MyAppVersion "1.4"
#define MyAppPublisher "Kishka"
#define MyAppExeName "Kishka-Browser_V1.4.exe"

[Setup]
AppId={{8A7B5C3D-1E4F-4A2B-9C3D-K1SHKA00001}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}

DefaultDirName=C:\Kishka Browser
DefaultGroupName={#MyAppName}

DisableDirPage=no
DisableProgramGroupPage=no

OutputDir=installer
OutputBaseFilename=Kishka-Browser_V1.4_Setup
SetupIconFile=icon.ico
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=admin
UninstallDisplayIcon={app}\icon.ico
UninstallDisplayName={#MyAppName} {#MyAppVersion}

[Languages]
Name: "ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl"

[Tasks]
Name: "desktopicon"; Description: "Створити ярлик на робочому столі"; GroupDescription: "Додаткові ярлики:"; Flags: checkedonce

[Files]
Source: "icon.ico"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\icon.ico"
Name: "{group}\Видалити {#MyAppName}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\icon.ico"; Tasks: desktopicon

[Dirs]
Name: "C:\Kishka Browser\Downloads"; Permissions: users-full; Flags: uninsneveruninstall

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "Запустити {#MyAppName}"; Flags: nowait postinstall skipifsilent

[Code]
var
  DownloadPage: TDownloadWizardPage;

function OnDownloadProgress(const Url, FileName: String; const Progress, ProgressMax: Int64): Boolean;
begin
  Result := True;
end;

procedure InitializeWizard;
begin
  DownloadPage := CreateDownloadPage(SetupMessage(msgWizardPreparing), SetupMessage(msgPreparingDesc), @OnDownloadProgress);
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
  if CurPageID = wpReady then begin
    DownloadPage.Clear;
    DownloadPage.Add('https://github.com/mukhalkivbohdancats-dev/simple-browser/releases/download/v1.4/Kishka-Browser_V1.4.exe', 'Kishka-Browser_V1.4.exe', '');
    DownloadPage.Show;
    try
      try
        DownloadPage.Download;
      except
        MsgBox('Помилка завантаження: ' + GetExceptionMessage + #13#10 + 
               'Перевірте інтернет або вимкніть антивірус.', mbCriticalError, MB_OK);
        Result := False;
      end;
    finally
      DownloadPage.Hide;
    end;
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    if FileExists(ExpandConstant('{tmp}\Kishka-Browser_V1.4.exe')) then
    begin
      FileCopy(ExpandConstant('{tmp}\Kishka-Browser_V1.4.exe'), ExpandConstant('{app}\Kishka-Browser_V1.4.exe'), False);
    end else
    begin
      MsgBox('Помилка: Файл не було завантажено! Можливо, його заблокував антивірус.', mbError, MB_OK);
    end;
  end;
end;
