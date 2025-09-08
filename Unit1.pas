unit Unit1;

interface

uses
  Windows, SysUtils, Variants, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  ActnList, ToolWin, ImgList, System.ImageList, System.Actions, ShellApi,
  Types, XPMan, CommCtrl, Clipbrd;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    FileCloseItem: TMenuItem;
    Window1: TMenuItem;
    N1: TMenuItem;
    FileExitItem: TMenuItem;
    WindowCascadeItem: TMenuItem;
    WindowTileItem: TMenuItem;
    WindowArrangeItem: TMenuItem;
    OpenDialog: TOpenDialog;
    FileSaveItem: TMenuItem;
    FileSaveAsItem: TMenuItem;
    Edit1: TMenuItem;
    CutItem: TMenuItem;
    CopyItem: TMenuItem;
    PasteItem: TMenuItem;
    WindowMinimizeItem: TMenuItem;
    StatusBar: TStatusBar;
    ActionList1: TActionList;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    FileNew1: TAction;
    FileSave1: TAction;
    FileExit1: TAction;
    FileOpen1: TAction;
    FileSaveAs1: TAction;
    WindowCascade1: TWindowCascade;
    WindowTileHorizontal1: TWindowTileHorizontal;
    WindowArrangeAll1: TWindowArrange;
    WindowMinimizeAll1: TWindowMinimizeAll;
    HelpAbout1: TAction;
    FileClose1: TWindowClose;
    WindowTileVertical1: TWindowTileVertical;
    WindowTileItem2: TMenuItem;
    ToolBar2: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton9: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ImageList1: TImageList;
    SaveDialog1: TSaveDialog;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    OpenDialog1: TOpenDialog;
    N2: TMenuItem;
    CopyField1: TMenuItem;
    CopyRow2: TMenuItem;
    Panel1: TPanel;
    ListView1: TListView;
    Panel2: TPanel;
    chKHasColumnNames: TCheckBox;
    Label5: TLabel;
    Label6: TLabel;
    Label1: TLabel;
    edtDelimiter: TEdit;
    ProgressBar1: TProgressBar;
    Label2: TLabel;
    procedure FileNew1Execute(Sender: TObject);
    procedure FileOpen1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure FileSave1Execute(Sender: TObject);
    procedure FileSaveAs1Execute(Sender: TObject);
    procedure FileSave1Update(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtDelimiterChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GetSubItemFromPoint(X, Y: Integer; var SubItem: Integer);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure CopyField1Click(Sender: TObject);
    procedure CopyRow2Click(Sender: TObject);
    procedure ProgressBar1Change(Sender: TObject);
  private
    { Private declarations }
    FFilename: AnsiString;
    FDelimiter: AnsiChar;
    FColumns: TStringList;
    FCountRecords: Integer;
    FColumnToSort: Integer;
    FLastSorted: Integer;
    FSortDir: Integer;
    FCancel: Boolean;
    FPopupMenuListItem: TListItem;
    FX: Integer;
    FY: Integer;
    procedure UpdateStatusbar;
    procedure GetColumns;
    procedure MakeColumns;
    procedure SetColumnSortArrow;
    procedure FillListview;
    procedure GetCountRecords;
    procedure UpdateStatus(Value: AnsiString);
    procedure ClearStatus;
    procedure EnableControls(Enable: Boolean);
    procedure CreateMDIChild(const Name: string);
    procedure WMDROPFILES(var Msg: TMessage); message WM_DROPFILES;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

const
  HDF_SORTUP   = $0400;
  HDF_SORTDOWN = $0200;

implementation

{$R *.DFM}
{$R resource.res}

uses UCsvViewer;

procedure TForm1.GetCountRecords;
var
  sl: TstringList;
begin
  sl := TStringList.Create;
  try
    sl.LoadFromFile(FFilename);
    if chKHasColumnNames.Checked then
      FCountRecords := sl.Count - 1
    else
      FCountRecords := sl.Count
  finally
    sl.Free;
  end;
end;

procedure TForm1.GetSubItemFromPoint(X, Y: Integer; var SubItem: Integer);
var
  hti: TLVHitTestInfo;
begin
  hti.pt := Point(X, Y);
  SubItem := ListView_SubItemHitTest(ListView1.Handle, @hti);
  if SubItem > 0 then
  begin
    FPopupMenuListItem := ListView1.Items[SubItem];
    SubItem := hti.iSubItem;
  end
  else
    FPopupMenuListItem := nil;
end;

procedure TForm1.ListView1ColumnClick(Sender: TObject; Column: TListColumn);
begin
  FColumnToSort := Column.Index;
  if FColumnToSort = FLastSorted then
    FSortDir := 1 - FSortDir
  else
    FSortDir := 0;
  FLastSorted := FColumnToSort;
  (Sender as TCustomListView).AlphaSort;
end;

procedure TForm1.ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
var
  ix: Integer;
begin
  if FColumnToSort = 0 then
  begin
    if FSortDir = 0 then
    begin
      if StrToInt(Item1.Caption) > StrToInt(Item2.Caption) then
        Compare := 1;
    end
    else
      if StrToInt(Item2.Caption) > StrToInt(Item1.Caption) then
        Compare := -1;
  end
  else
  begin
    ix := FColumnToSort - 1;
    if FSortDir = 0 then
      Compare := CompareText(Item1.SubItems[ix], Item2.SubItems[ix])
    else
      Compare := CompareText(Item2.SubItems[ix], Item1.SubItems[ix]);
  end;
end;


procedure TForm1.ListView1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
  begin
    FX := X;
    FY := Y;
    FPopupMenuListItem := ListView1.GetItemAt(X, Y);
  end;
end;

procedure TForm1.MakeColumns;
var
  Column: TListColumn;
  i: Integer;
begin
  try
    UpdateStatus('Create columns...');
    ListView1.Items.Clear;
    ListView1.Columns.Clear;
    Column := ListView1.Columns.Add;
    Column.Caption := 'Lfd. Nr.';
    for i := 0 to FColumns.Count - 1 do
    begin
      Column := ListView1.Columns.Add;
      if chKHasColumnNames.Checked then
        Column.Caption := AnsiUpperCase(FColumns[i])
      else
        Column.Caption := '';
    end;
    ClearStatus;
  except
    raise Exception.Create('Error creating columns');
  end;
end;

procedure TForm1.ProgressBar1Change(Sender: TObject);
begin
  Label2.Caption := 'Progress Lines : ' + IntToStr(ProgressBar1.Position);
  if FCancel = true then Exit;
  Application.ProcessMessages;
end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
  FileNewItem.Enabled := true;
  FileCloseItem.Enabled := true;
  FileSaveItem.Enabled := true;
  FileSaveAsItem.Enabled := true;

  CutItem.Enabled := true;
  CopyItem.Enabled := true;
  PasteItem.Enabled := true;

  WindowCascadeItem.Enabled := true;
  WindowTileItem.Enabled := true;
  WindowTileItem2.Enabled := true;
  WindowMinimizeItem.Enabled := true;
  WindowArrangeItem.Enabled := true;

  CopyField1.Enabled := false;
  CopyRow2.Enabled := false;

  Panel1.Visible := false;

end;

procedure TForm1.RadioButton2Click(Sender: TObject);
begin
  FileNewItem.Enabled := false;
  FileCloseItem.Enabled := false;
  FileSaveItem.Enabled := false;
  FileSaveAsItem.Enabled := false;

  CutItem.Enabled := false;
  CopyItem.Enabled := false;
  PasteItem.Enabled := false;

  WindowCascadeItem.Enabled := false;
  WindowTileItem.Enabled := false;
  WindowTileItem2.Enabled := false;
  WindowMinimizeItem.Enabled := false;
  WindowArrangeItem.Enabled := false;

  CopyField1.Enabled := true;
  CopyRow2.Enabled := true;

  Panel1.Visible := true;
end;

procedure TForm1.ClearStatus;
begin
  Label6.Caption := 'Status: ';
end;

procedure TForm1.CopyField1Click(Sender: TObject);
var
  SubItem: Integer;
begin
  GetSubItemFromPoint(FX, FY, SubItem);
  if Assigned(FPopupMenuListItem) then
  begin
    if SubItem > 0 then
      Clipboard.AsText := FPopupMenuListItem.SubItems[SubItem-1];
  end;
end;

procedure TForm1.CopyRow2Click(Sender: TObject);
var
  s: AnsiString;
  i: Integer;
begin
  if Assigned(FPopupMenuListItem) then
  begin
    for i := 0 to FPopupMenuListItem.SubItems.Count - 1 do
    begin
      s := s +  FPopupMenuListItem.SubItems[i] + FDelimiter;
    end;
    Setlength(s, Length(s) - 1);
    ClipBoard.AsText := s;
  end;
end;

procedure TForm1.SetColumnSortArrow;
var
  Header: THandle;
  HDItem: THDItem;
  Buf: array[0..MAX_PATH] of Char;
  Index: Integer;
begin
  Index := 1;
  Header := ListView_GetHeader(ListView1.Handle);
  FillChar(HDItem, SizeOf(HDItem), 0);
  HDItem.Mask := HDI_BITMAP or HDI_FORMAT or HDI_IMAGE or HDI_ORDER or HDI_TEXT or HDI_WIDTH;
  HDItem.pszText := Buf;
  HDItem.cchTextMax := sizeof(Buf);
  Header_GetItem(Header, Index, HDItem);
  HDItem.fmt := HDItem.fmt or HDF_SORTUP;
  Header_SetItem(Header, Index, HDItem);
end;

procedure TForm1.CreateMDIChild(const Name: string);
var
  Child: TFrmCsvViewer;
begin
  { create a new MDI child window }
  Child := TFrmCsvViewer.Create(Application);
  Child.FormStyle := fsMDIChild;
  Child.Caption := Name;
  if FileExists(Name) then
   begin
     Child.Data.LoadFromFile(Name);
     Child.FileName := Name;
     Child.Init;
     Child.ShowRecord;
   end;
   Child.Show;
end;

procedure TForm1.edtDelimiterChange(Sender: TObject);
begin
  FileOpenItem.Enabled := (Length(edtDelimiter.Text) > 0) and (edtDelimiter.Text <> ' ');
end;

procedure TForm1.EnableControls(Enable: Boolean);
var
  i: Integer;
begin
  for i := 0 to Form1.ControlCount - 1 do
  begin
    Form1.Controls[i].Enabled := Enable;
  end;
end;

Function ChangeAnsiStringToString(const S: AnsiString): String; inline;
  begin
    Result := String(S);
  end;

procedure TForm1.FillListview;
var
  i: Integer;
  j: Integer;
  sl: TStringList;
  StartIdx: Integer;
  DelimitedLine: TStringList;
  LVItem: TListItem;
begin
  try
    FCancel := False;
    UpdateStatus('read File... Abort ESC');
    ListView1.Items.Clear;
    sl := TStringList.Create;
    try
      DelimitedLine := TStringlist.Create;
      Delimitedline.StrictDelimiter := True;
      DelimitedLine.Delimiter := Char(FDelimiter);
      try
        sl.LoadFromFile(FFilename);
        ProgressBar1.Max := sl.Count;
        Application.ProcessMessages;
        if chKHasColumnNames.Checked then
          StartIdx := 1
        else
          StartIdx := 0;
        for i := StartIdx to sl.Count - 1 do
        begin
          if FCancel = true then Break;
          DelimitedLine.DelimitedText := sl[i];
          LVItem := ListView1.Items.Add;
          LVItem.Caption := IntToStr(i);
            for j := 0 to DelimitedLine.Count - 1 do
            begin
              LVitem.SubItems.Add(DelimitedLine[j]);
              ListView1.Columns.Items[j].Width := ColumnTextWidth;

              if FCancel = true then Break;

            end;


            if FCancel = true then Break;
          ProgressBar1.StepIt;
          ProgressBar1.Refresh;
          FCountRecords := i;
          UpdateStatusbar;
        end;
      finally
        DelimitedLine.Free;
      end;
    finally
      sl.Free;
    end;
    Progressbar1.Position := 0;
    FColumnToSort := 0;
    FSortDir := 1;
    ListView1.AlphaSort;
    UpdateStatus('Read finish');
  except
    raise Exception.Create('Error reading file');
  end;
end;

procedure TForm1.FileNew1Execute(Sender: TObject);
begin
  CreateMDIChild('New CSV' + IntToStr(MDIChildCount + 1));
end;

procedure TForm1.FileOpen1Execute(Sender: TObject);
begin
  if RadioButton1.Checked = true then begin
  if OpenDialog.Execute then CreateMDIChild(OpenDialog.FileName);
  end;

  if RadioButton2.Checked = true then begin
    if OpenDialog1.Execute then
  begin
    try
      ListView1.Visible := False;
      EnableControls(False);
      FCountRecords := 0;
      UpdateStatusbar;
      FFilename := OpenDialog1.FileName;
      FDelimiter := AnsiChar(edtDelimiter.Text[1]);
      Caption := FFilename;
      GetColumns;
      MakeColumns;
      GetCountRecords;
      FillListview;
      UpdateStatusbar;
      ListView1.Visible := True;
      EnableControls(True);
      ListView1.SetFocus;
    except
      on E: Exception do
      begin
        MessageBox(Handle, PChar(E.Message), 'CSV Editor', MB_ICONERROR);
        EnableControls(True);
      end;
    end;
  end;
  end;


end;

procedure TForm1.FileExit1Execute(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FileSave1Execute(Sender: TObject);
var
   Child : TFrmCsvViewer;
begin
   Child := TFrmCsvViewer(Self.ActiveMDIChild);
   Child.Data.SaveToFile(Child.FileName);
end;

procedure TForm1.FileSaveAs1Execute(Sender: TObject);
var
   Child : TFrmCsvViewer;
begin
   Child := TFrmCsvViewer(Self.ActiveMDIChild);
   if SaveDialog1.Execute then
   begin
      Child.FileName := SaveDialog1.FileName;
      Child.Data.SaveToFile(Child.FileName);
   end;
end;

procedure TForm1.FileSave1Update(Sender: TObject);
begin
   (Sender as TAction).Enabled := Self.MDIChildCount > 0;
end;


procedure TForm1.WMDROPFILES (var Msg: TMessage);
var i, anzahl, size: integer;
  Dateiname: string;
begin
   inherited;
   anzahl := DragQueryFile(Msg.WParam, $FFFFFFFF, nil, 255);
   for i := 0 to (anzahl - 1) do
   begin
      size := DragQueryFile(Msg.WParam, i , nil, 0) + 1;
      SetLength(Dateiname, size);
      DragQueryFile(Msg.WParam,i , PChar(Dateiname), size);
      CreateMDIChild(Dateiname);
   end;
   DragFinish(Msg.WParam);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   DragAcceptFiles(self.Handle, true);
   FCancel := False;
   FColumns := TStringList.Create;

   Panel1.DoubleBuffered := true;
   Panel2.DoubleBuffered := true;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FColumns.Free;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_TAB then FCancel := True;
end;

procedure TForm1.GetColumns;
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    sl.LoadFromFile(FFilename);
    FColumns.Delimiter := Char(FDelimiter);
    FColumns.DelimitedText := sl[0];
  finally
    sl.Free;
  end;
end;

procedure TForm1.UpdateStatus(Value: AnsiString);
begin
  Label6.Caption := 'Status: ' + Value;
  Application.ProcessMessages;
end;

procedure TForm1.UpdateStatusbar;
begin
  if FCountRecords = 0 then
    Label5.Caption := 'Records: '
  else
    Label5.Caption := 'Records: ' + IntToStr(FCountRecords);
  Application.ProcessMessages;
end;



end.
