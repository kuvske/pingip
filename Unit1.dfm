object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #32593#32476#30021#36890#27979#35797#31243#24207
  ClientHeight = 143
  ClientWidth = 453
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 8
    Width = 3
    Height = 13
  end
  object Label2: TLabel
    Left = 80
    Top = 43
    Width = 168
    Height = 26
    Caption = #27599#22825#23450#26102#33258#21160#26816#27979#32593#32476#36890#30021#24773#20917#13'(11:30   12:30   16:30   19:15)'
  end
  object Label3: TLabel
    Left = 104
    Top = 8
    Width = 3
    Height = 13
  end
  object ListBox1: TListBox
    Left = 8
    Top = 69
    Width = 169
    Height = 65
    AutoComplete = False
    ItemHeight = 13
    TabOrder = 0
    Visible = False
  end
  object ListBox2: TListBox
    Left = 254
    Top = 70
    Width = 170
    Height = 65
    AutoComplete = False
    ItemHeight = 13
    TabOrder = 1
    Visible = False
  end
  object ping: TButton
    Left = 320
    Top = 38
    Width = 89
    Height = 25
    Caption = #32593#32476#27979#35797#19977#27425
    TabOrder = 2
    OnClick = pingClick
  end
  object Button1: TButton
    Left = 320
    Top = 8
    Width = 89
    Height = 25
    Caption = #37038#20214#26597#35810#32467#26524
    TabOrder = 3
    Visible = False
    OnClick = Button1Click
  end
  object UniQuery1: TUniQuery
    Connection = dm.UniConnection1
    Left = 272
    Top = 32
  end
  object UniQuery2: TUniQuery
    Connection = dm.UniConnection2
    Left = 136
    Top = 8
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 200
    Top = 80
  end
  object UniQuery3: TUniQuery
    Connection = dm.UniConnection3
    Left = 24
    Top = 8
  end
end
