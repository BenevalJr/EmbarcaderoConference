program Builder;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  uFramework in 'uFramework.pas';

var
  relClientes: TRelatorio;
  relProdutos: TRelatorio;
  relClientesBuilder: TRelatorioBuilder;
  relProdutosBuilder: TRelatorioBuilder;
  criador: TGerador;

procedure mostrarRelatorio(relatorio: TRelatorio);
var
  s: string;
begin
  Writeln(relatorio.Cabecalho);
  for s in relatorio.Detalhes do
    Writeln(s);
  Writeln(relatorio.Rodape);
end;

begin
  // cria o builder para relat�rio de clientes
  relClientesBuilder := TRelatorioClientesBuilder.Create();
  // cria director
  criador := TGerador.Create();
  // seta builder para relat�rio de clientes
  criador.setRelatorioBuilder(relClientesBuilder);
  // pede ao criador para montar relatorio
  criador.constructRelatorio();
 // obt�m o relat�rio de clientes criado
  relClientes := criador.getRelatorio();
  // mostra
  mostrarRelatorio(relClientes);
  // cria o builder para relat�rio de produtos
  relProdutosBuilder := TRelatorioProdutosBuilder.Create();
  // seta builder para relat�rio de produtos
  criador.setRelatorioBuilder(relProdutosBuilder);
  // pede ao criador para montar relatorio
  criador.constructRelatorio();
  // obt�m o relat�rio de produtos criado
  relProdutos := criador.getRelatorio();
  // mostra
  mostrarRelatorio(relProdutos);
  Readln;
end.
