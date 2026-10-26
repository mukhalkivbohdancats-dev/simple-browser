#define MyAppName "Kishka Browser"
#define MyAppVersion "1.4"
#define MyAppPublisher "Kishka"
#define MyAppExeName "Kishka-Browser_V1.4.exe"

[Setup]
AppId={{8A7B5C3D-1E4F-4A2B-9C3D-K1SHKA00001}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}

; Шлях за замовчуванням
DefaultDirName=C:\Kishka Browser
DefaultGroupName={#MyAppName}

; Дозволяємо інсталятору питати про папку та меню "Пуск"
DisableDirPage=no
DisableProgramGroupPage=no

; УВАГА: Рядок DisableTasksPage=no видалено, оскільки такої директиви не існує.
; Сторінка завдань з'явиться автоматично завдяки секції [Tasks] нижче.

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
; Питання про ярлик на робочому столі
Name: "desktopicon"; Description: "Створити ярлик на робочому столі"; GroupDescription: "Додаткові ярлики:"; Flags: checkedonce

[Files]
; Тільки іконка (важкий exe завантажиться під час встановлення)
Source: "icon.ico"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
; Ярлики створюються на основі того, що обрав користувач
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\icon.ico"
Name: "{group}\Видалити {#MyAppName}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\icon.ico"; Tasks: desktopicon

[Dirs]
; Створюємо папку для завантажень
Name: "C:\Kishka Browser\Downloads"; Permissions: users-full; Flags: uninsneveruninstall

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "Запустити {#MyAppName}"; Flags: nowait postinstall skipifsilent

[Code]
var
  DownloadPage: TDownloadWizardPage;

function OnDownloadProgress(const Url, FileName: String; const Progress, ProgressMax: Int64): Boolean;
begin
  if Progress = ProgressMax then
    Log(Format('Успішно завантажено: %s', [FileName]));
  Result := True;
end;

procedure InitializeWizard;
begin
  DownloadPage := CreateDownloadPage(SetupMessage(msgWizardPreparing), SetupMessage(msgPreparingDesc), @OnDownloadProgress);
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  if CurPageID = wpReady then begin
    DownloadPage.Clear;
    // Посилання на ваш EXE у GitHub Releases
    DownloadPage.Add('https://github.com/mukhalkivbohdancats-dev/simple-browser/releases/download/v1.4/Kishka-Browser_V1.4.exe', 'Kishka-Browser_V1.4.exe', '');
    DownloadPage.Show;
    try
      try
        DownloadPage.Download;
        Result := True;
      except
        SuppressibleMsgBox(AddPeriod(GetExceptionMessage), mbCriticalError, MB_OK, IDOK);
        Result := False;
      end;
    finally
      DownloadPage.Hide;
    end;
  end else
    Result := True;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    // Переносимо завантажений exe у ту папку, яку обрав користувач
    FileCopy(ExpandConstant('{tmp}\Kishka-Browser_V1.4.exe'), ExpandConstant('{app}\Kishka-Browser_V1.4.exe'), False);
  end;
end;
