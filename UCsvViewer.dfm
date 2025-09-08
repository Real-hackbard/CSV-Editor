object FrmCsvViewer: TFrmCsvViewer
  Left = 328
  Top = 158
  Width = 629
  Height = 482
  Caption = 'CSV Viewer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 621
    Height = 61
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 17
      Top = 13
      Width = 86
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Delimiter'
    end
    object Label2: TLabel
      Left = 39
      Top = 30
      Width = 64
      Height = 29
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Position starts with'
      WordWrap = True
    end
    object Label3: TLabel
      Left = 213
      Top = 12
      Width = 72
      Height = 13
      Caption = 'Current Record'
    end
    object EdtDelim: TEdit
      Left = 118
      Top = 9
      Width = 41
      Height = 21
      TabOrder = 0
      Text = ';'
    end
    object SpinEdit1: TSpinEdit
      Left = 118
      Top = 35
      Width = 43
      Height = 22
      MaxValue = 50
      MinValue = 0
      TabOrder = 1
      Value = 0
      OnChange = SpinEdit1Change
    end
    object SpinEdit2: TSpinEdit
      Left = 212
      Top = 27
      Width = 121
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 0
      OnChange = SpinEdit2Change
    end
    object CheckBox1: TCheckBox
      Left = 345
      Top = 29
      Width = 149
      Height = 17
      Caption = '1. line contains fieldnames'
      Enabled = False
      TabOrder = 3
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 61
    Width = 621
    Height = 394
    ActivePage = TabSheet1
    Align = alClient
    MultiLine = True
    TabOrder = 1
    TabPosition = tpBottom
    object TabSheet1: TTabSheet
      Caption = 'Flat View'
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 613
        Height = 366
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
        OnClick = Memo1Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Details'
      ImageIndex = 1
      object ListView1: TListView
        Left = 0
        Top = 0
        Width = 613
        Height = 366
        Align = alClient
        BorderStyle = bsNone
        Columns = <
          item
            Caption = 'Position'
          end
          item
            Caption = 'Value'
            Width = 300
          end>
        GridLines = True
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
  end
end
