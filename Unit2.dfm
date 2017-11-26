object dm: Tdm
  OldCreateOrder = False
  Height = 273
  Width = 412
  object UniConnection1: TUniConnection
    ProviderName = 'SQL Server'
    Database = 'ping'
    SpecificOptions.Strings = (
      'Oracle.Direct=True')
    Username = 'sa'
    Password = 'ljbbj@123'
    Server = '10.0.0.179'
    LoginPrompt = False
    Left = 32
    Top = 8
  end
  object UniQuery1: TUniQuery
    Connection = UniConnection1
    Left = 144
    Top = 8
  end
  object UniConnection2: TUniConnection
    ProviderName = 'SQL Server'
    Database = 'ping'
    Username = 'sa'
    Password = 'ljbbj@123'
    Server = '10.0.0.179'
    Left = 24
    Top = 72
  end
  object UniQuery2: TUniQuery
    Connection = UniConnection2
    Left = 144
    Top = 72
  end
  object SQLServerUniProvider2: TSQLServerUniProvider
    Left = 264
    Top = 80
  end
  object UniConnection3: TUniConnection
    ProviderName = 'MySQL'
    Port = 3336
    Database = 'TD_OA'
    SpecificOptions.Strings = (
      'MySQL.Charset=gbk')
    Username = 'zs'
    Password = 'zs19801231'
    Server = '10.0.0.18'
    Connected = True
    Left = 24
    Top = 160
  end
  object UniQuery3: TUniQuery
    Connection = UniConnection3
    Left = 136
    Top = 160
  end
  object MySQLUniProvider1: TMySQLUniProvider
    Left = 264
    Top = 168
  end
end
