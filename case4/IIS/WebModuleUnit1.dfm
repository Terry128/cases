object WebModule1: TWebModule1
  OldCreateOrder = False
  Actions = <
    item
      Default = True
      Name = 'DefaultHandler'
      PathInfo = '/'
      OnAction = WebModule1DefaultHandlerAction
    end>
  Height = 230
  Width = 415
  object FDConnection: TFDConnection
    Params.Strings = (
      'Database=energo'
      'User_Name=test_user'
      'Password=Test,123'
      'DriverID=MySQL')
    Left = 72
    Top = 48
  end
  object FDQuery: TFDQuery
    Connection = FDConnection
    Left = 152
    Top = 48
  end
  object FDQueryTemp: TFDQuery
    Connection = FDConnection
    Left = 232
    Top = 48
  end
end
