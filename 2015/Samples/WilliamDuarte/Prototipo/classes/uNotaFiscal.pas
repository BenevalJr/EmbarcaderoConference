unit uNotaFiscal;

interface

uses
  uEmpresa;

Type
  TProdutoNFCe = class
  private
    FcEANTrib: String;
    FcProd: String;
    FvBC: Double;
    FqCom: Double;
    FValorICMS: Double;
    FvUnCom: Double;
    FuCom: String;
    FCFOP: Integer;
    FNCM: String;
    FxProd: String;
    FAliquota: Double;
    FvOutro: Double;
    FvDesc: Double;
    FvProd: Double;
    FCST: Integer;
    FOrigem: Integer;
    FCSOSN: Integer;
    procedure SetAliquota(const Value: Double);
    procedure SetcEANTrib(const Value: String);
    procedure SetCFOP(const Value: Integer);
    procedure SetcProd(const Value: String);
    procedure SetCSOSN(const Value: Integer);
    procedure SetCST(const Value: Integer);
    procedure SetNCM(const Value: String);
    procedure SetOrigem(const Value: Integer);
    procedure SetqCom(const Value: Double);
    procedure SetuCom(const Value: String);
    procedure SetValorICMS(const Value: Double);
    procedure SetvBC(const Value: Double);
    procedure SetvDesc(const Value: Double);
    procedure SetvOutro(const Value: Double);
    procedure SetvProd(const Value: Double);
    procedure SetvUnCom(const Value: Double);
    procedure SetxProd(const Value: String);
  published
    property cProd    : String read FcProd write SetcProd;
    property cEANTrib : String read FcEANTrib write SetcEANTrib;
    property xProd    : String read FxProd write SetxProd;
    property NCM      : String read FNCM write SetNCM;
    property CFOP     : Integer read FCFOP write SetCFOP;
    property uCom     : String read FuCom write SetuCom;
    property qCom     : Double read FqCom write SetqCom;
    property vUnCom   : Double read FvUnCom write SetvUnCom;
    property vProd    : Double read FvProd write SetvProd;
    property vDesc    : Double read FvDesc write SetvDesc;
    property vOutro   : Double read FvOutro write SetvOutro;
    property Origem   : Integer read FOrigem write SetOrigem;
    property CST      : Integer read FCST write SetCST;
    property CSOSN    : Integer read FCSOSN write SetCSOSN;
    property vBC      : Double read FvBC write SetvBC;
    property Aliquota : Double read FAliquota write SetAliquota;
    property ValorICMS: Double read FValorICMS write SetValorICMS;
  end;

  TPagamentoNFCe = class
  private
    Fvalor: double;
    Fcodigo: integer;
    procedure Setcodigo(const Value: integer);
    procedure Setvalor(const Value: double);
  published
    property codigo : integer read Fcodigo write Setcodigo;
    property valor  : double read Fvalor write Setvalor;
  end;

  ArrayProdutos   = Array of TProdutoNFCe;
  ArrayPagamentos = Array of TPagamentoNFCe;

  TNFCe = class
  private
    FValorDesc: Double;
    FdEmi: TDateTime;
    FValorProd: Double;
    FnatOp: String;
    FValorICMS: Double;
    FSerie: String;
    FCFOP: Integer;
    FNumero: String;
    FValorNota: Double;
    FEmpresa: TEmpresa;
    FValorBase: Double;
    FProdutos: ArrayProdutos;
    FPagamentos: ArrayPagamentos;
    procedure SetCFOP(const Value: Integer);
    procedure SetdEmi(const Value: TDateTime);
    procedure SetEmpresa(const Value: TEmpresa);
    procedure SetnatOp(const Value: String);
    procedure SetNumero(const Value: String);
    procedure SetSerie(const Value: String);
    procedure SetValorBase(const Value: Double);
    procedure SetValorDesc(const Value: Double);
    procedure SetValorICMS(const Value: Double);
    procedure SetValorNota(const Value: Double);
    procedure SetValorProd(const Value: Double);
    procedure SetProdutos(const Value: ArrayProdutos);
    procedure SetPagamentos(const Value: ArrayPagamentos);
  public
    Constructor Create;
  published
    property natOp      : String read FnatOp write SetnatOp;
    property Serie      : String read FSerie write SetSerie;
    property Numero     : String read FNumero write SetNumero;
    property dEmi       : TDateTime read FdEmi write SetdEmi;
    property Empresa    : TEmpresa read FEmpresa write SetEmpresa;
    property CFOP       : Integer read FCFOP write SetCFOP;
    property Produtos   : ArrayProdutos read FProdutos write SetProdutos;
    property Pagamentos : ArrayPagamentos read FPagamentos write SetPagamentos;
    property ValorBase  : Double read FValorBase write SetValorBase;
    property ValorICMS  : Double read FValorICMS write SetValorICMS;
    property ValorProd  : Double read FValorProd write SetValorProd;
    property ValorDesc  : Double read FValorDesc write SetValorDesc;
    property ValorNota  : Double read FValorNota write SetValorNota;

  end;

implementation

{ TPagamentoNFCe }

procedure TPagamentoNFCe.Setcodigo(const Value: integer);
begin
  Fcodigo := Value;
end;

procedure TPagamentoNFCe.Setvalor(const Value: double);
begin
  Fvalor := Value;
end;

{ TProdutoNFCe }

procedure TProdutoNFCe.SetAliquota(const Value: Double);
begin
  FAliquota := Value;
end;

procedure TProdutoNFCe.SetcEANTrib(const Value: String);
begin
  FcEANTrib := Value;
end;

procedure TProdutoNFCe.SetCFOP(const Value: Integer);
begin
  FCFOP := Value;
end;

procedure TProdutoNFCe.SetcProd(const Value: String);
begin
  FcProd := Value;
end;

procedure TProdutoNFCe.SetCSOSN(const Value: Integer);
begin
  FCSOSN := Value;
end;

procedure TProdutoNFCe.SetCST(const Value: Integer);
begin
  FCST := Value;
end;

procedure TProdutoNFCe.SetNCM(const Value: String);
begin
  FNCM := Value;
end;

procedure TProdutoNFCe.SetOrigem(const Value: Integer);
begin
  FOrigem := Value;
end;

procedure TProdutoNFCe.SetqCom(const Value: Double);
begin
  FqCom := Value;
end;

procedure TProdutoNFCe.SetuCom(const Value: String);
begin
  FuCom := Value;
end;

procedure TProdutoNFCe.SetValorICMS(const Value: Double);
begin
  FValorICMS := Value;
end;

procedure TProdutoNFCe.SetvBC(const Value: Double);
begin
  FvBC := Value;
end;

procedure TProdutoNFCe.SetvDesc(const Value: Double);
begin
  FvDesc := Value;
end;

procedure TProdutoNFCe.SetvOutro(const Value: Double);
begin
  FvOutro := Value;
end;

procedure TProdutoNFCe.SetvProd(const Value: Double);
begin
  FvProd := Value;
end;

procedure TProdutoNFCe.SetvUnCom(const Value: Double);
begin
  FvUnCom := Value;
end;

procedure TProdutoNFCe.SetxProd(const Value: String);
begin
  FxProd := Value;
end;

{ TNFCe }

constructor TNFCe.Create;
begin
  FEmpresa := TEmpresa.Create;

  //FProdutos := TObjectList<TProdutoNFCe>.Create;
  //FPagamentos := TObjectList<TPagamentoNFCe>.Create;
end;

procedure TNFCe.SetCFOP(const Value: Integer);
begin
  FCFOP := Value;
end;

procedure TNFCe.SetdEmi(const Value: TDateTime);
begin
  FdEmi := Value;
end;

procedure TNFCe.SetEmpresa(const Value: TEmpresa);
begin
  FEmpresa := Value;
end;

procedure TNFCe.SetnatOp(const Value: String);
begin
  FnatOp := Value;
end;

procedure TNFCe.SetNumero(const Value: String);
begin
  FNumero := Value;
end;

procedure TNFCe.SetPagamentos(const Value: ArrayPagamentos);
begin
  FPagamentos := Value;
end;

procedure TNFCe.SetProdutos(const Value: ArrayProdutos);
begin
  FProdutos := Value;
end;

procedure TNFCe.SetSerie(const Value: String);
begin
  FSerie := Value;
end;

procedure TNFCe.SetValorBase(const Value: Double);
begin
  FValorBase := Value;
end;

procedure TNFCe.SetValorDesc(const Value: Double);
begin
  FValorDesc := Value;
end;

procedure TNFCe.SetValorICMS(const Value: Double);
begin
  FValorICMS := Value;
end;

procedure TNFCe.SetValorNota(const Value: Double);
begin
  FValorNota := Value;
end;

procedure TNFCe.SetValorProd(const Value: Double);
begin
  FValorProd := Value;
end;

end.
