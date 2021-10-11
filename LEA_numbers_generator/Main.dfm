object MainForm: TMainForm
  Left = 209
  Top = 122
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Algorithm LEA-RNG'
  ClientHeight = 385
  ClientWidth = 425
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Courier New'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object InfoLbl: TLabel
    Left = 10
    Top = 10
    Width = 287
    Height = 70
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'Utilisation de l'#39'algorithme de chiffrement LEA-128 comme generat' +
      'eur de nombres pseudo-aleatoires.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object SepBevel: TBevel
    Left = 10
    Top = 89
    Width = 287
    Height = 2
  end
  object InfoLbl3: TLabel
    Left = 10
    Top = 322
    Width = 287
    Height = 53
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'Algorithmes LEA-128 et LEA-RNG developpes par Bacterius (www.del' +
      'phifr.com)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object InfoLbl2: TLabel
    Left = 10
    Top = 256
    Width = 180
    Height = 17
    Caption = 'Intervalle: 0 <= x <'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object DelphiBox: TGroupBox
    Left = 10
    Top = 94
    Width = 287
    Height = 75
    Caption = ' Generateur de Delphi '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object DelphiBtn: TButton
      Left = 10
      Top = 30
      Width = 267
      Height = 30
      Caption = 'Nouvelle liste de nombres'
      TabOrder = 0
      OnClick = NewList
    end
  end
  object LEABox: TGroupBox
    Left = 10
    Top = 172
    Width = 287
    Height = 75
    Caption = ' Generateur LEA '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object LEABtn: TButton
      Tag = 1
      Left = 10
      Top = 30
      Width = 267
      Height = 30
      Caption = 'Nouvelle liste de nombres'
      TabOrder = 0
      OnClick = NewList
    end
  end
  object NumberList: TListBox
    Left = 305
    Top = 10
    Width = 111
    Height = 367
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 17
    ParentFont = False
    TabOrder = 2
  end
  object QuitBtn: TButton
    Left = 10
    Top = 286
    Width = 287
    Height = 30
    Caption = 'Exit'
    TabOrder = 3
    OnClick = QuitBtnClick
  end
  object IntervalEdit: TEdit
    Left = 198
    Top = 252
    Width = 99
    Height = 25
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -15
    Font.Name = 'Courier New'
    Font.Style = []
    MaxLength = 10
    ParentFont = False
    TabOrder = 4
    Text = '10000'
    OnChange = IntervalEditChange
    OnKeyPress = IntervalEditKeyPress
  end
end
