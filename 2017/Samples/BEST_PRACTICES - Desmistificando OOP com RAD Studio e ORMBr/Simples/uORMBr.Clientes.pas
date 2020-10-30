unit uORMBr.Clientes;

interface

uses
  Classes,
  DB,
  SysUtils,
  Generics.Collections,
  /// orm
  ormbr.mapping.attributes,
  ormbr.types.mapping,
  ormbr.types.lazy,
  ormbr.types.nullable,
  ormbr.mapping.register ;

type

  [Entity]
  [Table('clientes', 'Tabela de Clientes')]
  [PrimaryKey('id', AutoInc, NoSort, True, 'Chave prim�ria')]
  [Sequence('seq_clientes')]
  TClientes = class
  private
    FId: Integer;
    FNome: String;
    FNascimento: TDateTime;
    FEndereco: string;

  public
    [Restrictions([NoUpdate, NotNull])]
    [Column('id', ftInteger)]
    [Dictionary('id', 'Mensagem de valida��o', '', '', '', taCenter)]
    property Id: Integer read FId write FId;

    [Column('nome', ftString, 40)]
    [Dictionary('nome', 'Mensagem de valida��o', '', '', '', taLeftJustify)]
    property Nome: String read FNome write FNome;

//    [Column('nascimento', ftDate)]
//    [Dictionary('nascimento', 'Mensagem de valida��o', '', '', '', taLeftJustify)]
//    property Nascimento: TDateTime read FNascimento write FNascimento;

//    [Column('endereco', ftstring, 50)]
//    [Dictionary('endereco', 'Mensagem de valida��o', '', '', '', taLeftJustify)]
//    property Endereco: string read FEndereco write FEndereco;
  end;

implementation

initialization

TRegisterClass.RegisterEntity(TClientes);


end.
