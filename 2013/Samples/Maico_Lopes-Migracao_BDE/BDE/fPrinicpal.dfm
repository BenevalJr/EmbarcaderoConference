object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Cadastro de Estados'
  ClientHeight = 454
  ClientWidth = 405
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object dgrEstados: TDBGrid
    Left = 0
    Top = 161
    Width = 405
    Height = 293
    Align = alClient
    DataSource = dtsCadastroEstados
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnTitleClick = dgrEstadosTitleClick
  end
  object dnvEstados: TDBNavigator
    Left = 0
    Top = 0
    Width = 405
    Height = 25
    DataSource = dtsCadastroEstados
    Align = alTop
    TabOrder = 1
  end
  object pnlPesquisa: TPanel
    Left = 0
    Top = 25
    Width = 405
    Height = 136
    Align = alTop
    TabOrder = 2
    object edtPesquisa: TEdit
      Left = 8
      Top = 26
      Width = 305
      Height = 21
      TabOrder = 0
    end
    object rdgTipos: TRadioGroup
      Left = 8
      Top = 53
      Width = 385
      Height = 59
      Caption = 'Tipos de Pesquisa'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Usando TDataSet.Locate'
        'Usando TDataSet.FindKey'
        'Usando TDataSet.Filter')
      TabOrder = 1
    end
    object btnBuscar: TBitBtn
      Left = 320
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Buscar'
      TabOrder = 2
      OnClick = btnBuscarClick
    end
  end
  object dtsCadastroEstados: TDataSource
    DataSet = tblCadastroEstados
    Left = 208
    Top = 224
  end
  object tblCadastroEstados: TTable
    Active = True
    DatabaseName = 'ERP'
    TableName = 'TB_ESTADOS'
    Left = 208
    Top = 168
    object tblCadastroEstadosID_ESTADO: TIntegerField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'ID_ESTADO'
    end
    object tblCadastroEstadosNOME: TStringField
      DisplayLabel = 'Nome'
      FieldName = 'NOME'
      Required = True
      Size = 30
    end
    object tblCadastroEstadosSIGLA: TStringField
      DisplayLabel = 'Sigla'
      FieldName = 'SIGLA'
      Required = True
      Size = 2
    end
  end
  object Database: TDatabase
    AliasName = 'ERP'
    Connected = True
    DatabaseName = 'ERP'
    KeepConnection = False
    LoginPrompt = False
    Params.Strings = (
      'PASSWORD=masterkey'
      'USER NAME=SYSDBA')
    SessionName = 'Default'
    Left = 208
    Top = 104
  end
end
