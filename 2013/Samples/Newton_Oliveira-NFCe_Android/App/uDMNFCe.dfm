object DMNFCe: TDMNFCe
  OldCreateOrder = False
  Height = 409
  Width = 398
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=C:\EmbarcaderoConference\NFC.sdb'
      'DriverID=SQLite')
    Connected = True
    LoginPrompt = False
    BeforeConnect = FDConnection1BeforeConnect
    Left = 56
    Top = 24
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 168
    Top = 320
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 48
    Top = 320
  end
  object tblCliente: TFDTable
    Active = True
    IndexFieldNames = 'id'
    Connection = FDConnection1
    UpdateOptions.UpdateTableName = 'cliente'
    TableName = 'cliente'
    Left = 56
    Top = 88
  end
  object tblProduto: TFDTable
    Active = True
    IndexFieldNames = 'codigo'
    Connection = FDConnection1
    UpdateOptions.UpdateTableName = 'produto'
    TableName = 'produto'
    Left = 56
    Top = 144
  end
  object Android: TSQLConnection
    ConnectionName = 'Android'
    DriverName = 'DataSnap'
    LoginPrompt = False
    Params.Strings = (
      'DriverName=DataSnap'
      'DriverUnit=Data.DBXDataSnap'
      'HostName=192.168.25.203'
      'Port=211'
      'CommunicationProtocol=tcp/ip'
      'DatasnapContext=datasnap/'
      
        'DriverAssemblyLoader=Borland.Data.TDBXClientDriverLoader,Borland' +
        '.Data.DbxClientDriver,Version=19.0.0.0,Culture=neutral,PublicKey' +
        'Token=91d62ebb5b0d1b1b')
    Left = 330
    Top = 12
    UniqueId = '{E44DF839-CED4-4E2C-B1DB-F23CB456268E}'
  end
end
