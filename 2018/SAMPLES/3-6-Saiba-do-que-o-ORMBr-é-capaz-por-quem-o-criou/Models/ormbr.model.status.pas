unit ormbr.model.status;

interface

uses
  DB,
  Classes,
  /// orm
  ormbr.mapping.attributes,
  ormbr.mapping.register,
  ormbr.types.mapping;

type
  [Entity]
  [Table('Tab_Status','Uso com StatusComboBox')]
  [PrimaryKey('Id', AutoInc, NoSort, True, 'Chave prim�ria')]
  [Indexe('IDX_Descricao', 'Descricao')]
  [Sequence('SEQ_Status')]
  [OrderBy('Descricao Asc')]
  TTab_Status = class
  private
    { Private declarations }
    FId: Integer;
    FDescricao: String;
  public
    { Public declarations }
    [Restrictions([NoUpdate, NotNull])]
    [Column('Id', ftInteger)]
    [Dictionary('Status Id', 'Mensagem de valida��o', '', '', '', taCenter)]
    property Id: Integer read FId write FId;

    [Column('Descricao', ftString, 30)]
    [Dictionary('Descri��o', 'Mensagem de valida��o', '', '', '', taLeftJustify)]
    property Descricao: string read FDescricao write FDescricao;
  end;

implementation

initialization
  TRegisterClass.RegisterEntity(TTab_Status);

end.
