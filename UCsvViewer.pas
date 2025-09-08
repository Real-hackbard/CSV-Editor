unit UCsvViewer;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Spin;

type
  TFrmCsvViewer = class(TForm)
    Panel1: TPanel;
    EdtDelim: TEdit;
    Label1: TLabel;
    SpinEdit1: TSpinEdit;
    Label2: TLabel;
    SpinEdit2: TSpinEdit;
    Label3: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ListView1: TListView;
    Memo1: TMemo;
    CheckBox1: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Memo1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    FRecno : Integer;
    FFileName: string;
    procedure SetData(const Value: TStrings);
    function GetData: TStrings;

  protected
    procedure AutoDetectDelim;


  public
    { Public-Deklarationen }
    procedure ShowRecord;
    procedure Init;
    property Data : TStrings read GetData write SetData;
    property FileName:string read FFileName write FFileName;
  end;

var
  FrmCsvViewer: TFrmCsvViewer;

implementation

uses CsvUtils;

{$R *.DFM}

{ TFrmCsvViewer }


procedure TFrmCsvViewer.ShowRecord;
var
   s : string;
   li : TListItem;
   flds : TStrings;
   i : Integer;
begin
   ListView1.Items.BeginUpdate;
   try
      ListView1.Items.Clear;
      s := GetData[FRecno];

      flds := TStringList.Create;
      try
      ParseCSVLine(s, flds, EdtDelim.text[1], '"');

      for i := 0 to flds.Count-1 do
      begin
         li := ListView1.Items.Add;
         li.Caption := IntToStr(i+ SpinEdit1.Value);
         li.SubItems.Add(flds.Strings[i]);
      end;
      finally
         flds.Free;
      end;
   finally
      ListView1.Items.EndUpdate;
   end;
end;

procedure TFrmCsvViewer.FormShow(Sender: TObject);
begin
   ShowRecord;
end;

procedure TFrmCsvViewer.SpinEdit1Change(Sender: TObject);
begin
   ShowRecord;
end;

procedure TFrmCsvViewer.SpinEdit2Change(Sender: TObject);
begin
   FRecno := SpinEdit2.Value;
   ShowRecord;
end;

procedure TFrmCsvViewer.SetData(const Value: TStrings);
begin
   Memo1.Lines.Assign(Value);
   if Assigned(value) then
      SpinEdit1.MaxValue := GetData.Count+1;
end;

function TFrmCsvViewer.GetData: TStrings;
begin
   Result := Memo1.Lines;
end;

procedure TFrmCsvViewer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if FormStyle = fsMDIChild then
     Action := caFree;
end;

procedure TFrmCsvViewer.Memo1Click(Sender: TObject);
begin
   FRecno := Memo1.CaretPos.y;
   SpinEdit2.Value := FRecno;
end;


function CharCount(const s:string; c: Char):Integer;
var
   i : Integer;
begin
   Result := 0;
   for i := Length(s) downto 1 do
      if s[i]=c then
         Inc(Result);
end;

procedure TFrmCsvViewer.AutoDetectDelim;
const
   delims = ',;|'#8;
var
   cc : Integer;
   s : String;
   i : integer;
   max_count : integer;
begin
   s := Data.Strings[0];

   max_count := 0;
   for i := 1 to 4 do
   begin
      cc := CharCount(s, delims[i]);
      if cc > max_count then
      begin
         max_count := cc;
         EdtDelim.Text := delims[i];
      end;
   end;
end;

procedure TFrmCsvViewer.Init;
begin
   SpinEdit1.MinValue := 0;
   SpinEdit1.MaxValue := GetData.Count+1;
   AutoDetectDelim;
end;

end.
