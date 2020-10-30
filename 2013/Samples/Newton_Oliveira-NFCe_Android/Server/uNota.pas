unit uNota;

interface

uses
  System.Classes, System.Generics.Collections;

type

  TCliente = class(TPersistent)
  private
    FNome: string;
    FDoc: string;
  published
    property Nome: string read FNome write FNome;
    property Doc: string read FDoc write FDoc;
  end;

  TItem = class(TPersistent)
  private
    FCodigo: Integer;
    FDescricao: String;
    FQtd: Double;
    FVlrUni: Double;
  published
    property Codigo: Integer read FCodigo write FCodigo;
    property Descricao: String read FDescricao write FDescricao;
    property Qtd: Double read FQtd write FQtd;
    property VlrUni: Double read FVlrUni write FVlrUni;
  end;

  TNotaFiscal = class(TPersistent)
  private
    FCliente: TCliente;
    FItens: TObjectList<TItem>;
    FNumeroNota: string;
  public
    constructor create;
    property NumeroNota: string read FNumeroNota write FNumeroNota;
    property Cliente: TCliente read FCliente;
    property Itens: TObjectList<TItem> read FItens;
  end;

implementation

{ TNotaFiscal }

constructor TNotaFiscal.create;
begin
  FCliente := TCliente.Create;
  FItens := TObjectList<TItem>.Create(true);
end;


end.
