unit Unit1;

interface

uses
  Windows, SysUtils, Variants, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  ActnList, ToolWin, ImgList, System.ImageList, System.Actions, ShellApi,
  Types, CommCtrl, Clipbrd, ComObj;

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
    Edit: TMenuItem;
    CutItem: TMenuItem;
    CopyItem: TMenuItem;
    PasteItem: TMenuItem;
    WindowMinimizeItem: TMenuItem;
    StatusBar1: TStatusBar;
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
    SaveDialog1: TSaveDialog;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    N2: TMenuItem;
    CopyField1: TMenuItem;
    CopyRow2: TMenuItem;
    Panel1: TPanel;
    OpenDialog1: TOpenDialog;
    Edit2: TEdit;
    Label3: TLabel;
    ImageList2: TImageList;
    ImageList1: TImageList;
    PopupMenu1: TPopupMenu;
    Copyline1: TMenuItem;
    Copyfiled1: TMenuItem;
    Clear1: TMenuItem;
    Export1: TMenuItem;
    Grid1: TMenuItem;
    Remove1: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    BringtoFront1: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    Duplicates1: TMenuItem;
    N10: TMenuItem;
    ListView1: TListView;
    Panel2: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    CheckBox2: TCheckBox;
    BitBtn1: TBitBtn;
    ProgressBar1: TProgressBar;
    About1: TMenuItem;
    ExporttoExcel1: TMenuItem;
    procedure FileNew1Execute(Sender: TObject);
    procedure FileOpen1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure FileSave1Execute(Sender: TObject);
    procedure FileSaveAs1Execute(Sender: TObject);
    procedure FileSave1Update(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
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
    procedure Edit2Change(Sender: TObject);
    procedure Copyline1Click(Sender: TObject);
    procedure Copyfiled1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure Export1Click(Sender: TObject);
    procedure Grid1Click(Sender: TObject);
    procedure Remove1Click(Sender: TObject);
    procedure BringtoFront1Click(Sender: TObject);
    procedure Duplicates1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure ListView1MouseEnter(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ExporttoExcel1Click(Sender: TObject);
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
    FSplitFileSize: Int64;
    procedure GetSplitFileSize;
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
    procedure CountStringsInMDIChildren(const SearchText: string);
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

uses UCsvViewer;

// export ListView to excel map
procedure ExportToExcel(ListView: TListView);
var
  ExcelApp: Variant;
  Row, Col: Integer;
  Item: TListItem;
begin
  if ListView.Items.Count = 0 then Exit;
  // Start Excel instance
  try
    ExcelApp := CreateOleObject('Excel.Application');
  except
    on E: Exception do
    begin
      ShowMessage('Excel could not be started. Is it installed? ' + E.Message);
      Exit;
    end;
  end;
  // Add new worksheet
  ExcelApp.Workbooks.Add;
  ExcelApp.Visible := True; // Makes Excel visible to the user.
  // 1. Export column headers
  for Col := 0 to ListView.Columns.Count - 1 do
  begin
    ExcelApp.Cells[1, Col + 1].Value := ListView.Columns[Col].Caption;
    ExcelApp.Cells[1, Col + 1].Font.Bold := True; // Format the heading in bold.
  end;
  // 2. Export data rows
  for Row := 0 to ListView.Items.Count - 1 do
  begin
    Item := ListView.Items[Row];
    // First column (item caption)
    ExcelApp.Cells[Row + 2, 1].Value := Item.Caption;
    // Additional columns (SubItems)
    for Col := 0 to Item.SubItems.Count - 1 do
    begin
      ExcelApp.Cells[Row + 2, Col + 2].Value := Item.SubItems[Col];
    end;
  end;
  // Automatically adjust column width
  ExcelApp.ActiveSheet.Columns.AutoFit;
end;

// precise determination of the file size in bytes
function GetFileSize(const AFile: string): Int64;
var
  SR: TSearchRec;
begin
  if FindFirst(AFile, 0, SR) = 0 then
  begin
    // extract the lower 32 bits of a 64-bit file size variable
    Int64Rec(Result).Lo := SR.FindData.nFileSizeLow;
    // extract the higher 32 bits of a 64-bit file size variable
    Int64Rec(Result).Hi := SR.FindData.nFileSizeHigh;
    SysUtils.FindClose(SR);
  end else
    Result := -1; // if he gets nothing
end;

// Split the file size result into its decimal components.
procedure TForm1.GetSplitFileSize;
begin
  if RadioButton2.Checked = true then
  begin
    FSplitFileSize := GetFileSize(OpenDialog1.FileName); // viewer
  end;

  if RadioButton1.Checked = true then
  begin
  FSplitFileSize := GetFileSize(OpenDialog.FileName);  // editor
  end;

  // display size
  StatusBar1.Panels[5].Text := Format(' %.0n bytes', [FSplitFileSize * 1.0])
end;

// find duplcates in all csv window data
procedure TForm1.CountStringsInMDIChildren(const SearchText: string);
var
  i: Integer;
  total: Integer;
  ChildForm: TFrmCsvViewer; // Replace TMyChildForm with your form class.
begin
  total := 0;
  for i := 0 to Self.MDIChildCount - 1 do
  begin
    // Check whether the window is of the expected type.
    if Self.MDIChildren[i] is TFrmCsvViewer then
    begin
      ChildForm := TFrmCsvViewer(Self.MDIChildren[i]);
      // Example: Checks whether the text in the memo contains the search string.
      if Pos(SearchText, ChildForm.Memo1.Text) > 0 then
      begin
        Inc(total);
      end;
    end;
  end;
  // duplicate result
  StatusBar1.Panels[7].Text := ('The string was found in ' +
                                IntToStr(total) +
                                ' CSV windows data');
end;

{ export ListView entries to CSV file format (check the seperator
  The default separator can be entered here at the top; otherwise,
  it is determined when the function is called. }
procedure ExportListViewToCSV(AListView: TListView; const AFileName:
          string; ADelimiter: Char = ';');
var
  CSVLines: TStringList;
  RowTokens: TStringList;
  I, J: Integer;
  ListItem: TListItem;
begin
  if AListView = nil then Exit;
  // create memory access for ListView lines and rows
  CSVLines := TStringList.Create;
  RowTokens := TStringList.Create;
  try
    // Set up the quoting and separator behavior
    RowTokens.Delimiter := ADelimiter;
    RowTokens.QuoteChar := '"';
    // 1. Export Column Headers
    if AListView.Columns.Count > 0 then
    begin
      for I := 1 to AListView.Columns.Count - 1 do
        RowTokens.Add(AListView.Columns[I].Caption);
      CSVLines.Add(RowTokens.DelimitedText);
    end;
    // 2. Export Data Rows
    for I := 0 to AListView.Items.Count - 1 do
    begin
      RowTokens.Clear;
      ListItem := AListView.Items[I];
      // The first column data is stored in the item's Caption property
      RowTokens.Add(ListItem.Caption);
      // Subsequent columns are stored in the SubItems list
      for J := 0 to ListItem.SubItems.Count - 1 do
      begin
        RowTokens.Add(ListItem.SubItems[J]);
      end;
      // Pad out any missing subitems if rows are uneven
      while RowTokens.Count < AListView.Columns.Count do
        RowTokens.Add('');
      CSVLines.Add(RowTokens.DelimitedText);
    end;
    // Save the entire CSV using UTF-8 encoding to support international characters
    CSVLines.SaveToFile(AFileName, TEncoding.UTF8);
  finally
    RowTokens.Free;
    CSVLines.Free;
  end;
end;

// Here, the columns for the ListView are counted.
procedure TForm1.GetCountRecords;
var
  sl: TstringList;
begin
  sl := TStringList.Create;
  try
    sl.LoadFromFile(FFilename);
    if CheckBox1.Checked then
      FCountRecords := sl.Count - 1
    else
      FCountRecords := sl.Count
  finally
    sl.Free;
  end;
end;

// determines the mouse position for the field copy
procedure TForm1.GetSubItemFromPoint(X, Y: Integer; var SubItem: Integer);
var
  { is used to determine which item or subitem of a TListView control is
    located at a specific screen or client position. }
  hti: TLVHitTestInfo;
begin
  // Handover of the position
  hti.pt := Point(X, Y);
  // determining for which sub-item
  SubItem := ListView_SubItemHitTest(ListView1.Handle, @hti);
  if SubItem > 0 then
  begin
    // Handover to the main menu for entry
    FPopupMenuListItem := ListView1.Items[SubItem];
    SubItem := hti.iSubItem;
  end
  else
    FPopupMenuListItem := nil;
end;

// generates the ListView gridlines
procedure TForm1.Grid1Click(Sender: TObject);
begin
  if Grid1.Checked = true then
    ListView1.GridLines := true
  else
    ListView1.GridLines := false;
end;

// Here, the ListView entries are sorted when clicked.
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

// Comparing entries
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

// creates the context when an entry is to be modified
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

procedure TForm1.ListView1MouseEnter(Sender: TObject);
begin

end;

// creating the ListView columns
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

    { Determine the number of columns in the CSV file and create columns
      corresponding to the CSV entries. }

    for i := 0 to FColumns.Count - 1 do
    begin
      if FCancel = true then Exit;   // abort

      Column := ListView1.Columns.Add;
      if CheckBox1.Checked then
        Column.Caption := AnsiUpperCase(FColumns[i])
      else
        Column.Caption := '';
    end;

    ClearStatus;
  except
    raise Exception.Create('Error creating columns');
  end;
end;

// read file data progress status
procedure TForm1.ProgressBar1Change(Sender: TObject);
begin
  Label2.Caption := 'Progress Lines : ' + IntToStr(ProgressBar1.Position);
  Application.ProcessMessages;
end;

// csv editor
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
  BringtoFront1.Enabled := true;
  Duplicates1.Enabled := true;
  ToolButton9.Enabled := true;
  Label3.Caption := '  Duplicates : ';
  StatusBar1.Panels[6].Text  := 'Dubplicates :';
  StatusBar1.Panels[0].Text  := 'MDI :';
end;

// csv viewer
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
  BringtoFront1.Enabled := false;
  Duplicates1.Enabled := false;
  ToolButton9.Enabled := false;
  Label3.Caption := '  Search : ';
  StatusBar1.Panels[6].Text  := 'Search :';
  StatusBar1.Panels[0].Text  := 'Line :';
end;

// remove multi slect entries in ListView
procedure TForm1.Remove1Click(Sender: TObject);
var
  i : integer;
begin
  with ListView1 do
    for i := Items.Count - 1 downto 0 do
      if Items[i].Selected then
        ListView1.Items[i].Delete;

  StatusBar1.Panels[7].Text  := '0';
  StatusBar1.Panels[1].Text := IntToStr(FCountRecords);
end;

// about
procedure TForm1.About1Click(Sender: TObject);
begin
  MessageDlg('CSV Editor v1.1' + Char(10) +
             'Copyright © hackbard' + Char(10) +
             'github.com | Release 2026',mtInformation, [mbOK], 0);
end;

// progress abort button
procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  FCancel := True;
  UpdateStatus('Progress abort.');
  BitBtn1.Enabled := false;
  Application.ProcessMessages;
end;

// search child and bring to front
procedure TForm1.BringtoFront1Click(Sender: TObject);
var
  i: Integer;
  ChildForm: TForm;
  Child : string;
  ChildExists: Boolean;
begin
  // Check whether `csv to` exists as an MDI child.
  for i := 0 to Application.MainForm.MDIChildCount - 1 do
  begin
    if Form1.MDIChildren[i] is TFrmCsvViewer then
    begin
      ChildExists := True;
      // Optional: Bring the found window to the foreground.
      Form1.MDIChildren[i].BringToFront;
      Break;
    end;
  end;

  // If not, get out.
  if not ChildExists then
  begin
    // Create a new MDI child, as it does not yet exist.
    //TMyChildForm.Create(Application);
    Exit;
  end;

  // Bring a specific MDI child to the foreground if it exists.
  InputQuery('Find the Data window', 'Bring CSV Data to front : ', Child);

  for i := 0 to Pred(Application.MainForm.MDIChildCount) do
  begin
    ChildForm := Application.MainForm.MDIChildren[i];
    // Example: Search within the window's caption string.
    if Pos(Child, ChildForm.Caption) > 0 then
    begin
      // Window found or action performed
      ChildForm.BringToFront;
      Break;
    end;
    // Note: To use specific components (such as TEdit or TMemo)
    // to search within the child form, you can use ChildForm.FindComponent
    // or use a component loop (ChildForm.Components[j]).
  end;
end;

// clear the ListView list
procedure TForm1.Clear1Click(Sender: TObject);
begin
  Label6.Caption := 'Status: cleared.';
  ListView1.Clear;
  ListView1.Columns.Clear;
  ListView1.Update;
  StatusBar1.Panels[1].Text  := '0';
  StatusBar1.Panels[7].Text  := '0';
  StatusBar1.Panels[5].Text := '0 kb';
  Application.ProcessMessages;
end;

procedure TForm1.ClearStatus;
begin
  Label6.Caption := 'Status: cleared.';
end;

// copy the entire item strand
procedure TForm1.CopyField1Click(Sender: TObject);
var
  SubItem: Integer;
begin
  // Determine the field corresponding to the mouse position.
  GetSubItemFromPoint(FX, FY, SubItem);
  if Assigned(FPopupMenuListItem) then
  begin
    // copy to clipboard
    if SubItem > 0 then
      Clipboard.AsText := FPopupMenuListItem.SubItems[SubItem-1];
  end;
end;

// Copy a specific field located under the mouse cursor.
procedure TForm1.Copyfiled1Click(Sender: TObject);
var
  SubItem: Integer;
begin
  // Determine the field corresponding to the mouse position.
  GetSubItemFromPoint(FX, FY, SubItem);
  if Assigned(FPopupMenuListItem) then
  begin
    // copy to clipboard
    if SubItem > 0 then
      Clipboard.AsText := FPopupMenuListItem.SubItems[SubItem-1];
  end;
end;

// copy the entire item strand
procedure TForm1.Copyline1Click(Sender: TObject);
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

// Sorting and size unit of the created columns
procedure TForm1.SetColumnSortArrow;
var
  Header: THandle;
  HDItem: THDItem;
  Buf: array[0..MAX_PATH] of Char;
  Index: Integer;
begin
  Index := 1;
  // macro used to retrieve the window handle (HWND) of the header control within a TListView
  Header := ListView_GetHeader(ListView1.Handle);
  // To initialize a structure or variable entirely with zeros
  FillChar(HDItem, SizeOf(HDItem), 0);
  // specifically when interacting with a Header Control via THeaderControl or raw Win32 APIs
  HDItem.Mask := HDI_BITMAP or HDI_FORMAT or HDI_IMAGE or HDI_ORDER or HDI_TEXT or HDI_WIDTH;
  // fil text
  HDItem.pszText := Buf;
  // returns the size in bytes of the variable or type
  HDItem.cchTextMax := sizeof(Buf);
  // macro retrieves information about an item in a header control.
  Header_GetItem(Header, Index, HDItem);
  // manage Header Controls, such as adding a sort arrow to a TListView column header
  HDItem.fmt := HDItem.fmt or HDF_SORTUP;
  // properties of a specific item (column) in a header control
  Header_SetItem(Header, Index, HDItem);
end;

// creating the MDIChildrens
procedure TForm1.CreateMDIChild(const Name: string);
var
  Child: TFrmCsvViewer;
begin
  { create a new MDI child window }
  Child := TFrmCsvViewer.Create(Application);
  Child.FormStyle := fsMDIChild;
  Child.Caption := ExtractFileName(Name);
  if FileExists(Name) then
   begin
     Child.Data.LoadFromFile(Name);
     Child.FileName := Name;
     Child.Init;
     Child.ShowRecord;
   end;
   Child.Show;
end;

// find duplicates in all csv window data (MainMenu)
procedure TForm1.Duplicates1Click(Sender: TObject);
var
  Duplicates : string;
  ChildExists: Boolean;
  i : integer;
begin
  ChildExists := False;

  // Check whether `csv to` exists as an MDI child.
  for i := 0 to Application.MainForm.MDIChildCount - 1 do
  begin
    if Form1.MDIChildren[i] is TFrmCsvViewer then
    begin
      ChildExists := True;
      // Optional: Bring the found window to the foreground.
      Form1.MDIChildren[i].BringToFront;
      Break;
    end;
  end;

  // if nothing else works, get out
  if not ChildExists then
  begin
    // Create a new MDI child, as it does not yet exist.
    //TMyChildForm.Create(Application);
    Exit;
  end;

  InputQuery('Find dunplicates in all CSV data', 'Search : ', Duplicates);
  { count duplicate strings or manage duplicate string values within a
    hierarchy of parent-child controls/nodes }
  CountStringsInMDIChildren(Duplicates);
end;

// check the seperator
procedure TForm1.Edit1Change(Sender: TObject);
begin
  FileOpenItem.Enabled := (Length(Edit1.Text) > 0) and (Edit1.Text <> ' ');
end;

{ Two functions are executed here for the editor and the viewer:
  identifying identical data across different MDIs, and determining
  the search terms for the viewer. }
procedure TForm1.Edit2Change(Sender: TObject);
var
  i, j : integer;
  SearchText: string;
  Found : Boolean;
  Duplicates : string;
  ChildExists: Boolean;
begin
  // search duplcates in the editor MDIs
  if RadioButton1.Checked = true then
  BEGIN
    ChildExists := False;

    // Check whether `csv to` exists as an MDI child.
    for i := 0 to Application.MainForm.MDIChildCount - 1 do
    begin
      if Form1.MDIChildren[i] is TFrmCsvViewer then
      begin
        ChildExists := True;
        // Optional: Bring the found window to the foreground.
        Form1.MDIChildren[i].BringToFront;
        Break;
      end;
    end;

    // if nothing else works, get out
    if not ChildExists then
    begin
      // Create a new MDI child, as it does not yet exist.
      //TMyChildForm.Create(Application);
      Exit;
    end;

    // in case an InputBox is needed after all.
    //InputQuery('Find dunplicates in all CSV data', 'Search : ', Duplicates);

    { count duplicate strings or manage duplicate string values within a
    hierarchy of parent-child controls/nodes }
    CountStringsInMDIChildren(Edit2.Text);
  END;


  // search entries in the viewer (ListView)
  if RadioButton2.Checked = true then
  BEGIN
    Found := false;
    for i := 0 to ListView1.Items.Count - 1 do
      if ListView1.Items[i].Caption = Edit2.Text then
        begin
          Found := true;  // if found
          // Select the entry
          ListView1.Selected := ListView1.Items[i];
          // make it visible
          ListView1.Selected.MakeVisible(True);
          Application.ProcessMessages;
          break;
        end;

    SearchText := Edit2.Text;
    Found := False;
    for i := 0 to ListView1.Items.Count - 1 do
    begin
      // Checking the main column (caption)
      if Pos(LowerCase(SearchText), LowerCase(ListView1.Items[i].Caption)) > 0 then
      begin
        Found := True;
      end
      else
      begin
        // Checking the sub-items (additional columns)
        for j := 0 to ListView1.Items[i].SubItems.Count - 1 do
        begin
          if Pos(LowerCase(SearchText), LowerCase(ListView1.Items[i].SubItems[j])) > 0 then
          begin
            Found := True;
            Break;
          end;
        end;
      end;
      if Found then
      begin
        // Check whether the items have been selected.
        ListView1.Items[i].Selected := True;
        // make it visible
        ListView1.Items[i].MakeVisible(False);
        // count the selection in StatusBar
        StatusBar1.Panels[7].Text := IntToStr(ListView1.SelCount);
        Break; // Stoppen beim ersten Treffer
      end;
    end;
  END;
end;

// this enables/disable the controls on form entries
procedure TForm1.EnableControls(Enable: Boolean);
var
  i: Integer;
begin
  for i := 0 to Form1.ControlCount - 1 do
  begin
    // in case all form controls need to be disabled (e.g. EnableControls(true)  )
    Form1.Controls[i].Enabled := Enable;
  end;
end;

// save ListView entries as CSV file
procedure TForm1.Export1Click(Sender: TObject);
var
  delimiter : Char;
begin
  if SaveDialog1.Execute then
  begin
    delimiter := Edit1.Text[1];

    // This line uses the function's default separator that is currently set.
    //ExportListViewToCSV(ListView1, 'C:\output.csv');

    // Or Semicolon-Separated Export (Common for European Excel versions)
    ExportListViewToCSV(ListView1, SaveDialog1.FileName, delimiter);
  end;
end;

procedure TForm1.ExporttoExcel1Click(Sender: TObject);
begin
  ExportToExcel(ListView1);
end;

{ In modern versions of Delphi (Delphi 2009 and newer), you can change
  an AnsiString to a standard string (which is a UnicodeString) by using
  an explicit typecast:    MyString := string(ChangeAnsiStringToString);  }
Function ChangeAnsiStringToString(const S: AnsiString): String; inline;
begin
  Result := String(S);
end;

// populate the ListView with data from the CSV file
procedure TForm1.FillListview;
var
  i,j : Integer;
  sl: TStringList;
  StartIdx: Integer;
  DelimitedLine: TStringList;
  LVItem: TListItem;
begin
  try
    // Issue the abortion certificate.
    FCancel := False;
    UpdateStatus('read file... press [Abort] to stop.');
    ListView1.Items.Clear;
    // create access for list in memory
    sl := TStringList.Create;
    try
      // create delimeted access in memory
      DelimitedLine := TStringlist.Create;
      // ensures that only your defined Delimiter character (and quoted strings) splits the text
      Delimitedline.StrictDelimiter := True;
      { set the delimiter of a TStringList in Delphi by assigning a Char
        directly to the Delimiter property, such as DelimitedFile.Delimiter := ';' }
      DelimitedLine.Delimiter := Char(FDelimiter);
      try
        // load list from file
        sl.LoadFromFile(FFilename);
        ProgressBar1.Max := sl.Count;

        // Arranges the first row into columns.
        if CheckBox1.Checked then
          StartIdx := 1
        else
          StartIdx := 0;

        for i := StartIdx to sl.Count - 1 do
        begin
          if FCancel = true then Exit;   // abort

          // Separate the individual terms using the delimiter.
          DelimitedLine.DelimitedText := sl[i];
          // create ListViewItems
          LVItem := ListView1.Items.Add;
          // Enter the data into the first column.
          LVItem.Caption := IntToStr(i);

            // Sort the delimiter lines from the list into the columns of the ListView.
            for j := 0 to DelimitedLine.Count - 1 do
            begin
              LVitem.SubItems.Add(DelimitedLine[j]);
              ListView1.Columns.Items[j].Width := ColumnTextWidth;
            end;

          // display read status
          ProgressBar1.StepIt;
          ProgressBar1.Refresh;
          // count the entries
          FCountRecords := i;
          UpdateStatusbar;
        end;
      finally
        // Release the delimiter items.
        DelimitedLine.Free;
      end;
    finally
      // Make the list available again.
      sl.Free;
    end;
    // End the process.
    Progressbar1.Position := 0;
    FColumnToSort := 0;
    FSortDir := 1;
    ListView1.AlphaSort;
    UpdateStatus('read finish.');
  except
    raise Exception.Create('Error reading file');
  end;
end;

// create new MDIChild
procedure TForm1.FileNew1Execute(Sender: TObject);
begin
  CreateMDIChild('New CSV' + IntToStr(MDIChildCount + 1));
  Duplicates1.Enabled := true;
  BringtoFront1.Enabled := true;
  // count how many MDIChilds are open
  StatusBar1.Panels[1].Text := IntToStr(Application.MainForm.MDIChildCount);
end;

// load CSV file for Editor or Viewer
procedure TForm1.FileOpen1Execute(Sender: TObject);
var
  c : integer;
begin
  StatusBar1.Panels[5].Text := '0 kb';

  // Editor
  if RadioButton1.Checked = true then
  begin
    if OpenDialog.Execute then
    begin
      // fil data from CSV file in MDIChild
      CreateMDIChild(OpenDialog.FileName);
      Duplicates1.Enabled := true;
      BringtoFront1.Enabled := true;
      // Determine the exact file size in bytes.
      GetSplitFileSize;
      StatusBar1.Panels[3].Text := ExtractFileName(OpenDialog.FileName);
      // count how many MDIChilds are open
      StatusBar1.Panels[1].Text := IntToStr(MDIChildCount);
    end;
  end;

  // viewer
  if RadioButton2.Checked = true then
  begin

    // Go out if the separator is missing.
    if Edit1.Text = '' then
      begin
        MessageDlg('No separator specified or none found!',mtInformation, [mbOK], 0);
        Exit;
      end;

      if OpenDialog1.Execute then
      begin
        try
          FCancel := false;
          BitBtn1.Enabled := true;
          ListView1.Items.Clear;
          FCountRecords := 0;
          UpdateStatusbar;
          FFilename := OpenDialog1.FileName;

          { AnsiChar is often unnecessary in modern, Unicode-based versions
            of Delphi (Delphi 2009 and later), as the delimiter is of type
            Char (WideChar) in those versions. If errors occur, the code
            must be changed to use PWideChar. }
          FDelimiter := AnsiChar(Edit1.Text[1]);

          GetColumns;
          MakeColumns;
          GetCountRecords;
          FillListview;
          UpdateStatusbar;
          EnableControls(True);

          // Numerical list
          if CheckBox2.Checked = false then
          begin
            ListView1.Columns[0].Width := 0;
          end else begin
            ListView1.Columns[0].Width := 60;
          end;

          // get csv filename
          StatusBar1.Panels[3].Text := ExtractFileName(OpenDialog1.FileName);
          // Determine the exact file size in bytes.
          GetSplitFileSize;
        except
          on E: Exception do
          begin
            MessageBox(Handle, PChar(E.Message), 'CSV Editor', MB_ICONERROR);
            EnableControls(True);
          end;
        end;
      end;
    StatusBar1.Panels[7].Text  := '0';
    // count line entries
    StatusBar1.Panels[1].Text := IntToStr(FCountRecords);
  end;
end;

procedure TForm1.FileExit1Execute(Sender: TObject);
begin
  Close;
end;

// save MDIChild to CSV file
procedure TForm1.FileSave1Execute(Sender: TObject);
var
   Child : TFrmCsvViewer;
begin
  Beep;
  if MessageBox(Handle,'Overwrite CSV file?','Confirm',MB_YESNO) = IDYES then
    BEGIN
      // get data & save
      Child := TFrmCsvViewer(Self.ActiveMDIChild);
      Child.Data.SaveToFile(Child.FileName);
    END;
end;

// save at a specific location
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

// identify the open MDI children
procedure TForm1.FileSave1Update(Sender: TObject);
begin
   (Sender as TAction).Enabled := Self.MDIChildCount > 0;
   // update MDIChild cound & display
   StatusBar1.Panels[1].Text := IntToStr(Application.MainForm.MDIChildCount);
end;

// enables drag & drop of CSV files.
procedure TForm1.WMDROPFILES (var Msg: TMessage);
var
  i, anzahl, size: integer;
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
  // enables drag & drop of CSV files.
  DragAcceptFiles(self.Handle, true);
  // Turn off abort.
  FCancel := False;
  // create memory access for column list
  FColumns := TStringList.Create;
  // Prevents flickering when files are being read.
  Panel1.DoubleBuffered := true;
  Panel2.DoubleBuffered := true;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  // Release the list from memory.
  FColumns.Free;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // count how many MDIChilds are open
  StatusBar1.Panels[1].Text := IntToStr(MDIChildCount);
end;

// creation of the columns in the ListView
procedure TForm1.GetColumns;
var
  sl: TStringList;
begin
  // create memory acces
  sl := TStringList.Create;
  try
    // load CSV data
    sl.LoadFromFile(FFilename);

    { AnsiChar is often unnecessary in modern, Unicode-based versions
      of Delphi (Delphi 2009 and later), as the delimiter is of type
      Char (WideChar) in those versions. If errors occur, the code
      must be changed to use PWideChar. }
    FColumns.Delimiter := Char(FDelimiter);
    FColumns.DelimitedText := sl[0];
  finally
    // Make the list available again.
    sl.Free;
  end;
end;

// update read data progress
procedure TForm1.UpdateStatus(Value: AnsiString);
begin
  Label6.Caption := 'Status: ' + Value;
  Application.ProcessMessages;
end;

// update read data records display progress
procedure TForm1.UpdateStatusbar;
begin
  if FCountRecords = 0 then
    Label5.Caption := 'Records: '
  else
    Label5.Caption := 'Records: ' + IntToStr(FCountRecords);
  Application.ProcessMessages;
end;



end.
