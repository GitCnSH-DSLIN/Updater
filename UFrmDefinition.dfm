object FrmDefinition: TFrmDefinition
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'New Definition'
  ClientHeight = 467
  ClientWidth = 633
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LbName: TLabel
    Left = 8
    Top = 8
    Width = 27
    Height = 13
    Caption = 'Name'
  end
  object LbSource: TLabel
    Left = 8
    Top = 56
    Width = 33
    Height = 13
    Caption = 'Source'
  end
  object LbDestination: TLabel
    Left = 8
    Top = 104
    Width = 54
    Height = 13
    Caption = 'Destination'
  end
  object LbInclusions: TLabel
    Left = 8
    Top = 152
    Width = 47
    Height = 13
    Caption = 'Inclusions'
  end
  object LbExclusions: TLabel
    Left = 320
    Top = 152
    Width = 49
    Height = 13
    Caption = 'Exclusions'
  end
  object BottomLine: TBevel
    Left = 8
    Top = 424
    Width = 617
    Height = 9
    Shape = bsTopLine
  end
  object BtnSourceFolder: TSpeedButton
    Left = 600
    Top = 71
    Width = 25
    Height = 23
    Caption = '...'
    OnClick = BtnSourceFolderClick
  end
  object BtnDestinationFolder: TSpeedButton
    Left = 600
    Top = 119
    Width = 25
    Height = 23
    Caption = '...'
    OnClick = BtnDestinationFolderClick
  end
  object EdName: TEdit
    Left = 8
    Top = 24
    Width = 353
    Height = 21
    TabOrder = 0
  end
  object EdSource: TEdit
    Left = 8
    Top = 72
    Width = 593
    Height = 21
    TabOrder = 1
  end
  object EdDestination: TEdit
    Left = 8
    Top = 120
    Width = 593
    Height = 21
    TabOrder = 2
  end
  object EdInclusions: TMemo
    Left = 8
    Top = 168
    Width = 305
    Height = 193
    ScrollBars = ssBoth
    TabOrder = 3
    WordWrap = False
    OnKeyPress = EdMasksKeyPress
    OnKeyUp = EdMasksKeyUp
  end
  object EdExclusions: TMemo
    Left = 320
    Top = 168
    Width = 305
    Height = 193
    ScrollBars = ssBoth
    TabOrder = 4
    WordWrap = False
    OnKeyPress = EdMasksKeyPress
    OnKeyUp = EdMasksKeyUp
  end
  object CkRecursive: TCheckBox
    Left = 8
    Top = 376
    Width = 145
    Height = 17
    Caption = 'Recursive subdirectories'
    TabOrder = 5
  end
  object CkDelete: TCheckBox
    Left = 8
    Top = 400
    Width = 153
    Height = 17
    Caption = 'Delete files on destination'
    TabOrder = 6
  end
  object BtnOK: TButton
    Left = 232
    Top = 432
    Width = 81
    Height = 29
    Caption = 'OK'
    TabOrder = 7
    OnClick = BtnOKClick
  end
  object BtnCancel: TButton
    Left = 320
    Top = 432
    Width = 81
    Height = 29
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 8
  end
end
