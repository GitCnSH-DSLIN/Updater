unit UFrmMain;

interface

uses Vcl.Forms, Vcl.VirtualImageList, Vcl.BaseImageCollection,
  Vcl.ImageCollection, System.ImageList, Vcl.ImgList, Vcl.Controls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.ToolWin, Vcl.Buttons, Vcl.StdCtrls,
  Vcl.CheckLst, System.Classes,
  //
  UConfig, System.Types;

type
  TFrmMain = class(TForm)
    LDefs: TCheckListBox;
    LLogs: TListBox;
    Splitter: TSplitter;
    BoxProgress: TPanel;
    LbStatus: TLabel;
    BtnStop: TSpeedButton;
    ProgressBar: TProgressBar;
    LbSize: TLabel;
    IL_File: TImageList;
    BoxTop: TPanel;
    ToolBar: TToolBar;
    BtnNew: TToolButton;
    BtnEdit: TToolButton;
    BtnRemove: TToolButton;
    BtnSeparator1: TToolButton;
    BtnUp: TToolButton;
    BtnDown: TToolButton;
    BtnSeparator2: TToolButton;
    BtnMasks: TToolButton;
    BtnSeparator3: TToolButton;
    BtnExecute: TToolButton;
    BoxAbout: TPanel;
    LbDigao: TLinkLabel;
    LbVersion: TLabel;
    IC_ToolBar: TImageCollection;
    IL_ToolBar: TVirtualImageList;
    IL_Masks: TImageList;
    BtnCustomization: TToolButton;
    BoxSecureMode: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnNewClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnRemoveClick(Sender: TObject);
    procedure BtnUpClick(Sender: TObject);
    procedure BtnDownClick(Sender: TObject);
    procedure LDefsClick(Sender: TObject);
    procedure LDefsClickCheck(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BtnExecuteClick(Sender: TObject);
    procedure LLogsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure BtnStopClick(Sender: TObject);
    procedure LDefsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure FormResize(Sender: TObject);
    procedure LbDigaoLinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
    procedure BtnMasksClick(Sender: TObject);
    procedure LLogsDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnCustomizationClick(Sender: TObject);
    procedure BoxSecureModeClick(Sender: TObject);
  private
    EngineRunning: Boolean;

    procedure FillDefinitions;
    procedure MoveDefinition(Flag: ShortInt);
    function AddDefinition(Def: TDefinition): Integer;
    function GetSelectedDefinition: TDefinition;
    procedure UpdateButtons;
    function AnyDefinitionChecked: Boolean;
  public
    procedure SetControlsState(Active: Boolean);
    procedure UpdSecureMode;
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

uses Vcl.Dialogs, System.UITypes, Vcl.Graphics, System.SysUtils,
  Winapi.Windows, Winapi.ShellAPI,
  UFrmDefinition, UFrmMasksManage, UEngine, URegistry, UVars, UCommon,
  UFrmCustomization, UVersionCheck;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  try
    ReportMemoryLeaksOnShutdown := True;

    LbVersion.Caption := Format('Version %s', [STR_VERSION]);

    pubLogFile := ExtractFilePath(Application.ExeName)+'Log.txt';

    TCustomization.LoadRegistry;

    Config := TConfig.Create;

    FillDefinitions;
    UpdateButtons;
    UpdSecureMode;
  except
    on E: Exception do
    begin
      MessageDlg('ERROR: '+E.Message, mtError, [mbOK], 0);
      Application.Terminate;
    end;
  end;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  if Assigned(Config) then
    Config.Free;

  TCustomization.SaveRegistry;
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  if Assigned(Config) and Config.CheckForNewVersion then
    CheckMyVersion;
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if EngineRunning then
  begin
    CanClose := False;
    MessageDlg('There is a process running', mtError, [mbOK], 0);
  end;
end;

procedure TFrmMain.FormResize(Sender: TObject);
begin
  LDefs.Invalidate;
end;

procedure TFrmMain.LbDigaoLinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
  ShellExecute(0, '', PChar(Link), '', '', SW_SHOWNORMAL);
end;

procedure TFrmMain.UpdateButtons;
var
  Sel: Boolean;
begin
  Sel := LDefs.ItemIndex <> -1;

  BtnEdit.Enabled := Sel;
  BtnRemove.Enabled := Sel;

  BtnUp.Enabled := Sel and (LDefs.ItemIndex > 0);
  BtnDown.Enabled := Sel and (LDefs.ItemIndex < LDefs.Count-1);

  BtnExecute.Enabled := AnyDefinitionChecked;
end;

function TFrmMain.AnyDefinitionChecked: Boolean;
var
  D: TDefinition;
begin
  for D in Config.Definitions do
    if D.Checked then Exit(True);

  Exit(False);
end;

procedure TFrmMain.LDefsClick(Sender: TObject);
begin
  UpdateButtons;
end;

procedure TFrmMain.LDefsClickCheck(Sender: TObject);
var
  D: TDefinition;
begin
  D := GetSelectedDefinition;
  D.Checked := LDefs.Checked[LDefs.ItemIndex];

  UpdateButtons;
end;

procedure TFrmMain.LDefsDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  D: TDefinition;
  A: string;
begin
  InitDrawItem(LDefs.Canvas, Rect, State);

  D := TDefinition(LDefs.Items.Objects[Index]);

  LDefs.Canvas.TextOut(Rect.Left+2, Rect.Top+2, D.Name);
  if D.LastUpdate>0 then
  begin
    A := DateTimeToStr(D.LastUpdate);

    LDefs.Canvas.Font.Color := clGray;
    LDefs.Canvas.TextOut(Rect.Right-LDefs.Canvas.TextWidth(A)-4, Rect.Top+2, A);
  end;
end;

function TFrmMain.GetSelectedDefinition: TDefinition;
begin
  Result := TDefinition(LDefs.Items.Objects[LDefs.ItemIndex]);
end;

function TFrmMain.AddDefinition(Def: TDefinition): Integer;
begin
  Result := LDefs.Items.AddObject(Def.Name, Def);
end;

procedure TFrmMain.FillDefinitions;
var
  D: TDefinition;
  Index: Integer;
begin
  for D in Config.Definitions do
  begin
    Index := AddDefinition(D);
    LDefs.Checked[Index] := D.Checked;
  end;
end;

procedure TFrmMain.BtnNewClick(Sender: TObject);
var
  D: TDefinition;
  Index: Integer;
begin
  if DoEditDefinition(False, D) then
  begin
    Index := AddDefinition(D);
    LDefs.ItemIndex := Index;

    UpdateButtons;
  end;
end;

procedure TFrmMain.BtnEditClick(Sender: TObject);
var
  D: TDefinition;
begin
  D := GetSelectedDefinition;
  if DoEditDefinition(True, D) then
  begin
    LDefs.Items[LDefs.ItemIndex] := D.Name;
  end;
end;

procedure TFrmMain.BtnRemoveClick(Sender: TObject);
var
  D: TDefinition;
begin
  D := GetSelectedDefinition;
  if MessageDlg('Do you want to remove definition "'+D.Name+'"?',
    mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    Config.Definitions.Remove(D);
    LDefs.DeleteSelected;

    UpdateButtons;
  end;
end;

procedure TFrmMain.MoveDefinition(Flag: ShortInt);
var
  Index, NewIndex: Integer;
begin
  Index := LDefs.ItemIndex;
  NewIndex := Index + Flag;

  Config.Definitions.Exchange(Index, NewIndex);
  LDefs.Items.Exchange(Index, NewIndex);

  UpdateButtons;
end;

procedure TFrmMain.BtnUpClick(Sender: TObject);
begin
  MoveDefinition(-1);
end;

procedure TFrmMain.BtnDownClick(Sender: TObject);
begin
  MoveDefinition(+1);
end;

procedure TFrmMain.BtnMasksClick(Sender: TObject);
begin
  DoMasksManage;
end;

procedure TFrmMain.BtnCustomizationClick(Sender: TObject);
begin
  DoCustomization;
end;

procedure TFrmMain.BtnExecuteClick(Sender: TObject);
var
  Eng: TEngine;
begin
  LLogs.Clear;

  LbStatus.Caption := string.Empty;
  LbSize.Caption := string.Empty;
  ProgressBar.Position := 0;

  BtnStop.Enabled := True;

  SetControlsState(False);

  Eng := TEngine.Create;
  Eng.Start;
end;

procedure TFrmMain.SetControlsState(Active: Boolean);
begin
  EngineRunning := not Active;
  BoxProgress.Visible := not Active;

  ToolBar.Visible := Active;
  LDefs.Enabled := Active;
end;

procedure TFrmMain.BtnStopClick(Sender: TObject);
begin
  BtnStop.Enabled := False;
end;

procedure TFrmMain.LLogsDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  A: string;
  IdxFile: Integer;
  Color: TColor;
begin
  if odSelected in State then LLogs.Canvas.Brush.Color := clBlack;
  LLogs.Canvas.FillRect(Rect);

  IdxFile := -1;

  A := LLogs.Items[Index];
  case A[1] of
    '@': Color := clWhite; //definition title
    ':': Color := clSilver; //general info
    '*': Color := $0070ADF1; //warning
    '#': Color := $006C6CFF; //error
    '+': begin
           Color := $0000D900;
           IdxFile := 0;
         end;
    '~': begin
           Color := $00C7B96D;
           IdxFile := 1;
         end;
    '-': begin
           Color := $009A9A9A;
           IdxFile := 2;
         end;
    else raise Exception.Create('Invalid log prefix');
  end;

  Delete(A, 1, 1);

  LLogs.Canvas.Font.Color := Color;

  if IdxFile<>-1 then
  begin
    IL_File.Draw(LLogs.Canvas, 3, Rect.Top+1, IdxFile);
    LLogs.Canvas.TextOut(18, Rect.Top, A);
  end else
    LLogs.Canvas.TextOut(3, Rect.Top, A);
end;

procedure TFrmMain.LLogsDblClick(Sender: TObject);
var
  A: string;
begin
  A := LLogs.Items[LLogs.ItemIndex];
  Delete(A, 1, 1);

  ShowMessage('Log content:'+#13#13+A);
end;

procedure TFrmMain.UpdSecureMode;
begin
  BoxSecureMode.Visible := Config.SecureMode;
end;

procedure TFrmMain.BoxSecureModeClick(Sender: TObject);
begin
  MessageDlg(
    'In secure mode, no files are changed during synchronization.'+#13+
    'This can be used to check which changes would be made according to the definition parameters.'+#13+
    #13+
    'When everything is ready, you can disable this option in the Customization dialog.',
    mtInformation, [mbOK], 0);
end;

end.
