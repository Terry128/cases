object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #1050#1077#1081#1089'-'#1079#1072#1076#1072#1095#1072' 1'
  ClientHeight = 641
  ClientWidth = 665
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMode = pmAuto
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 161
    Height = 625
    TabOrder = 0
    object lbSource: TLabel
      Left = 32
      Top = 48
      Width = 93
      Height = 13
      Caption = #1048#1089#1093#1086#1076#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
    end
    object bnSelect: TButton
      Left = 8
      Top = 8
      Width = 145
      Height = 25
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083' '#1089' '#1076#1072#1085#1085#1099#1084#1080
      TabOrder = 0
      OnClick = bnSelectClick
    end
    object mmData: TMemo
      Left = 32
      Top = 67
      Width = 93
      Height = 550
      ScrollBars = ssVertical
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 175
    Top = 8
    Width = 481
    Height = 625
    TabOrder = 1
    object Label2: TLabel
      Left = 16
      Top = 48
      Width = 48
      Height = 13
      Caption = 'min '#1080' max'
    end
    object Label1: TLabel
      Left = 151
      Top = 48
      Width = 86
      Height = 13
      Caption = #1052#1077#1078#1076#1091' min '#1080' max'
    end
    object Label3: TLabel
      Left = 243
      Top = 48
      Width = 82
      Height = 13
      Caption = #1054#1090#1088#1080#1094#1072#1090#1077#1083#1100#1085#1099#1077
    end
    object lbResult: TLabel
      Left = 356
      Top = 90
      Width = 85
      Height = 25
      Caption = 'lbResult'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbResultCaption: TLabel
      Left = 362
      Top = 65
      Width = 79
      Height = 19
      Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object bnCalc: TButton
      Left = 16
      Top = 8
      Width = 449
      Height = 25
      Caption = #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1088#1072#1089#1095#1077#1090
      TabOrder = 0
      OnClick = bnCalcClick
    end
    object mmMinMax: TMemo
      Left = 16
      Top = 67
      Width = 129
      Height = 160
      TabOrder = 1
    end
    object mmBetween: TMemo
      Left = 151
      Top = 67
      Width = 86
      Height = 550
      ScrollBars = ssVertical
      TabOrder = 2
    end
    object mmNegative: TMemo
      Left = 243
      Top = 67
      Width = 86
      Height = 550
      ScrollBars = ssVertical
      TabOrder = 3
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 8
    Top = 40
  end
end
