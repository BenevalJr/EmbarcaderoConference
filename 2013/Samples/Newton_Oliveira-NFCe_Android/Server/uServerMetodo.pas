unit uServerMetodo;

interface

uses System.SysUtils,
  System.Classes,
  System.DateUtils,
  Datasnap.DSServer,
  Datasnap.DSAuth,
  generics.collections,
  uNota,
  ACBrNFe,
  pcnConversao,
  pcnAuxiliar,
  ACBrEAD;

type

  TServerMethods1 = class(TDSServerModule)
    ACBrNFe1: TACBrNFe;
    ACBrEAD1: TACBrEAD;
  private
    function StringToHex(S: String): String;
    function GeraURLQrCode: string;
    function Iif(Condicao: Boolean; Verdadeiro, Falso: Variant): Variant;
    { Private declarations }
  public
    { Public declarations }
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;
    function EnviarNota(pNotaFiscal: TNotaFiscal): String;
  end;

implementation

{$R *.dfm}

uses System.StrUtils;

function TServerMethods1.EchoString(Value: string): string;
begin
  Result := Value;
end;

function TServerMethods1.EnviarNota(pNotaFiscal: TNotaFiscal): String;
var
  lAno, lMes, lDia, lHora, lMinuto, lSegundo, lMSegundo: word;
  lItem: TItem;
  liItem: integer;
  lData: TDateTime;
begin

  DecodeDateTime(Now, lAno, lMes, lDia, lHora, lMinuto, lSegundo, lMSegundo);
  lData := EncodeDateTime(lAno, lMes, lDia, lHora - 2, lMinuto, lSegundo,
    lMSegundo);
  {
    Result := pNotaFiscal.Cliente.Nome;

    for lItem in pNotaFiscal.Itens do
    begin
    Result := Result + sLineBreak + lItem.Descricao;
    end;
  }

  ACBrNFe1 := TACBrNFe.Create(nil);
  ACBrNFe1.Configuracoes.Certificados.NumeroSerie := 'Coloque aqui o numero de serie';
  ACBrNFe1.Configuracoes.WebServices.UF := 'Coloque aqui o estado';
  ACBrNFe1.Configuracoes.WebServices.Ambiente := taHomologacao;
  ACBrNFe1.Configuracoes.Geral.ModeloDF := moNFCe;
  ACBrNFe1.Configuracoes.Geral.PathSchemas :=
    'C:\acbr\Exemplos\ACBrNFe2\Delphi\Schemas';
  with ACBrNFe1.NotasFiscais.Add.NFe do
  begin
    Ide.cNF := StrToInt(pNotaFiscal.NumeroNota);
    Ide.natOp := 'VENDA';
    Ide.indPag := ipVista;
    Ide.modelo := 65;
    Ide.serie := 1;
    Ide.nNF := StrToInt(pNotaFiscal.NumeroNota);
    Ide.dEmi := lData;

    Ide.dSaiEnt := lData;
    Ide.hSaiEnt := lData;

    Ide.tpNF := tnSaida;
    Ide.tpEmis := teNormal;
    Ide.tpAmb := taHomologacao;
    // Lembre-se de trocar esta vari�vel quando for para ambiente de produ��o
    Ide.cUF := 13;
    Ide.cMunFG := 1302603;
    Ide.finNFe := fnNormal;
    Ide.tpImp := tiNFCe;

    Ide.indFinal := cfConsumidorFinal;
    Ide.indPres := pcPresencial;

    Emit.CNPJCPF := '04214987000222';
    Emit.IE := '041041399';
    Emit.xNome := 'Empresa Exemplo';
    Emit.xFant := 'Empresa Exemplo';
    Emit.EnderEmit.fone := '101010101010';
    Emit.EnderEmit.CEP := 69050010;
    Emit.EnderEmit.xLgr := 'AVENIDA DJALMA BATISTA';
    Emit.EnderEmit.nro := '333';
    Emit.EnderEmit.xCpl := '';
    Emit.EnderEmit.xBairro := 'CENTRO';
    Emit.EnderEmit.cMun := 1302603;
    Emit.EnderEmit.xMun := 'MANAUS';
    Emit.EnderEmit.UF := 'AM';
    Emit.EnderEmit.cPais := 1058;
    Emit.EnderEmit.xPais := 'BRASIL';

    Emit.IEST := '';
    Emit.CRT := crtRegimeNormal;

    {
      Dest.CNPJCPF := '05481336000137';
      Dest.ISUF := '';
      Dest.xNome := 'D.J. COM. E LOCA��O DE SOFTWARES LTDA - ME';

      Dest.EnderDest.fone := '1533243333';
      Dest.EnderDest.CEP := 18270170;
      Dest.EnderDest.xLgr := 'Rua Coronel Aureliano de Camargo';
      Dest.EnderDest.nro := '973';
      Dest.EnderDest.xCpl := '';
      Dest.EnderDest.xBairro := 'Centro';
      Dest.EnderDest.cMun := 3554003;
      Dest.EnderDest.xMun := 'Tatu�';
      Dest.EnderDest.UF := 'SP';
      Dest.EnderDest.cPais := 1058;
      Dest.EnderDest.xPais := 'BRASIL';
    }
    // Adicionando Produtos
    liItem := 0;
    for lItem in pNotaFiscal.Itens do
    begin
      inc(liItem);

      with Det.Add do
      begin
        Prod.nItem := liItem;
        Prod.cProd := '123456';
        Prod.cEAN := '7896523206646';
        Prod.xProd := lItem.Descricao;
        Prod.NCM := '94051010';
        Prod.EXTIPI := '';
        Prod.CFOP := '5101';
        Prod.uCom := 'UN';
        Prod.qCom := 1;
        Prod.vUnCom := 50;
        Prod.vProd := 50;

        Prod.cEANTrib := '7896523206646';
        Prod.uTrib := 'UN';
        Prod.qTrib := 1;
        Prod.vUnTrib := 50;

        Prod.vOutro := 0;
        Prod.vFrete := 0;
        Prod.vSeg := 0;
        Prod.vDesc := 0;
        Prod.IndTot := itSomaTotalNFe;

        with Imposto do
        begin
          // lei da transparencia nos impostos
          vTotTrib := 0;

          with ICMS do
          begin
            CST := cst00;
            ICMS.orig := oeNacional;
            ICMS.modBC := dbiValorOperacao;
            ICMS.vBC := 50;
            ICMS.pICMS := 18;
            ICMS.vICMS := 18;
            ICMS.modBCST := dbisMargemValorAgregado;
            ICMS.pMVAST := 0;
            ICMS.pRedBCST := 0;
            ICMS.vBCST := 0;
            ICMS.pICMSST := 0;
            ICMS.vICMSST := 0;
            ICMS.pRedBC := 0;
          end;
        end;
      end;
    end;

    Total.ICMSTot.vBC := 100;
    Total.ICMSTot.vICMS := 18;
    Total.ICMSTot.vBCST := 0;
    Total.ICMSTot.vST := 0;
    Total.ICMSTot.vProd := 100;
    Total.ICMSTot.vFrete := 0;
    Total.ICMSTot.vSeg := 0;
    Total.ICMSTot.vDesc := 0;
    Total.ICMSTot.vII := 0;
    Total.ICMSTot.vIPI := 0;
    Total.ICMSTot.vPIS := 0;
    Total.ICMSTot.vCOFINS := 0;
    Total.ICMSTot.vOutro := 0;
    Total.ICMSTot.vNF := 100;

    Total.ISSQNtot.vServ := 0;
    Total.ISSQNtot.vBC := 0;
    Total.ISSQNtot.vISS := 0;
    Total.ISSQNtot.vPIS := 0;
    Total.ISSQNtot.vCOFINS := 0;

    Transp.modFrete := mfSemFrete; // NFC-e n�o pode ter FRETE

    with pag.Add do // PAGAMENTOS apenas para NFC-e
    begin
      tPag := fpDinheiro;
      vPag := 100;
    end;

    InfAdic.infCpl := '';
    InfAdic.infAdFisco := '';
  end;
  try
    ACBrNFe1.Enviar(1, false);
    Result := GeraURLQrCode;
  except
    on e: exception do
    begin
      Result := e.Message;
    end;
  end;
end;

function TServerMethods1.GeraURLQrCode: string;
var
  lURL: string;
  ltpAmb: string;
  lDest: string;
  lHash_SHA1: string;
begin
  if ACBrNFe1.NotasFiscais.Items[0].NFe.Ide.tpAmb = taProducao then
    lURL := 'http://www.sefaz.am.gov.br/nfce/consultanfce?'
  else
    lURL := 'http://www.sefaz.am.gov.br/nfce/consultanfce?';

  if ACBrNFe1.NotasFiscais.Items[0].NFe.Ide.tpAmb = taProducao then
    ltpAmb := '1'
  else
    ltpAmb := '2';
  lDest := Iif(Length(ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.CNPJCPF) > 0,
    ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.CNPJCPF, '');

  Result := lURL + 'chNFe=' + ACBrNFe1.NotasFiscais.Items[0].NFe.procNFe.CHNFE +
    '&nVersao=' + '100' + '&tpAmb=' + ltpAmb + Iif((Length(lDest) > 0),
    ('&cDest=' + lDest), '') + '&dhEmi=' +
    StringToHex(DateTimeTodhUTC(ACBrNFe1.NotasFiscais.Items[0].NFe.Ide.dEmi,
    GetUTC(ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.EnderEmit.UF,
    ACBrNFe1.NotasFiscais.Items[0].NFe.Ide.dEmi))) + '&vNF=' +
    FormatFloat(',0.00;-,0.00', ACBrNFe1.NotasFiscais.Items[0]
    .NFe.Total.ICMSTot.vNF) + '&vICMS=' + FormatFloat(',0.00;-,0.00',
    ACBrNFe1.NotasFiscais.Items[0].NFe.Total.ICMSTot.vICMS) + '&digVal=' +
    StringToHex(ACBrNFe1.NotasFiscais.Items[0].NFe.procNFe.digVal) +
    '&cIdToken=' + '000001';

  lHash_SHA1 := ACBrEAD1.CalcularHash(UTF8Encode(Result), dgstSHA1);
  Result := Result + '&cHashQRCode=' + lHash_SHA1;

end;

function TServerMethods1.StringToHex(S: String): String;
var
  i: integer;
begin
  Result := '';
  for i := 1 to Length(S) do
    Result := Result + IntToHex(ord(S[i]), 2);
end;

function TServerMethods1.Iif(Condicao: Boolean;
  Verdadeiro, Falso: Variant): Variant;
begin
  if Condicao then
    Result := Verdadeiro
  else
    Result := Falso;
end;

function TServerMethods1.ReverseString(Value: string): string;
begin
  Result := System.StrUtils.ReverseString(Value);
end;

end.
