object FrmMasksAutoComplete: TFrmMasksAutoComplete
  Left = 0
  Top = 0
  BorderStyle = bsNone
  BorderWidth = 1
  ClientHeight = 127
  ClientWidth = 276
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object L: TListBox
    Left = 0
    Top = 17
    Width = 276
    Height = 110
    Style = lbOwnerDrawFixed
    Align = alClient
    BorderStyle = bsNone
    ItemHeight = 20
    Sorted = True
    TabOrder = 0
    OnDblClick = LDblClick
    OnDrawItem = LDrawItem
    OnKeyPress = LKeyPress
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 276
    Height = 17
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Insert Masks Table'
    TabOrder = 1
  end
end
