unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, Data.DbxSqlite, Data.FMTBcd,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.DBScope, Data.DB,
  Data.SqlExpr, FMX.StdCtrls, FMX.Layouts, FMX.ListBox, FMX.TabControl, FMX.Edit,
  System.Actions, FMX.ActnList, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, FMX.Objects,
  FMX.PhoneDialer,        //Adicionar ao USES para fazer chamadas telefonicas
  FMX.Platform,           //Adicionar ao USES para verificar suporte de funcionalidades da plataforma
  Apple.Utils;            //Adicionar ao USES para abrir URL no Safari  //Adicionar ao LibraryPath o caminho C:\Documents and Settings\All Users\Documentos\RAD Studio\11.0\Samples\Delphi\RTL\CrossPlatform Utils

type
  TForm1 = class(TForm)
    TabControl1: TTabControl;
    TabLista: TTabItem;
    TabLoja: TTabItem;
    ListBoxLista: TListBox;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ToolBar2: TToolBar;
    SpeedButton1: TSpeedButton;
    ListBoxDetalhe: TListBox;
    SearchBox1: TSearchBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    LabelNome1: TLabel;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    LabelLoja: TLabel;
    LabelTel: TLabel;
    LabelSite: TLabel;
    LabelTipo: TLabel;
    ActionList1: TActionList;
    Action1: TAction;
    ChangeTabActionLoja: TChangeTabAction;
    ChangeTabActionLista: TChangeTabAction;
    BotaoMapa: TButton;
    TabMapa: TTabItem;
    ToolBar3: TToolBar;
    SpeedButton2: TSpeedButton;
    ssashopping: TSQLConnection;
    lojas: TSQLDataSet;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    ChangeTabActionMapa: TChangeTabAction;
    IdHTTP1: TIdHTTP;
    Image1: TImage;
    Image2: TImage;
    QryLocateLoja: TSQLQuery;
    LabelNome2: TLabel;
    procedure ssashoppingBeforeConnect(Sender: TObject);
    procedure ssashoppingAfterConnect(Sender: TObject);
    procedure ListBoxListaItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
    procedure AddLojas;
    procedure BotaoMapaClick(Sender: TObject);
    procedure ListBoxItem3Click(Sender: TObject);
    procedure ListBoxItem4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.BotaoMapaClick(Sender: TObject);
var
 strUrl: String;
 imgStream: TStream;
begin
 ChangeTabActionMapa.ExecuteTarget(self);

 strUrl := 'http://www.salvadorshopping.com.br/wp-content/uploads/mapas/' + QryLocateLoja.FieldByName('mapa').AsString;

 imgStream := TMemoryStream.Create;
 IdHTTP1.Get(StrUrl, imgStream);

 Image2.Bitmap.LoadFromStream(imgStream);
end;

procedure TForm1.ListBoxItem3Click(Sender: TObject);
var
  PhoneDialerService: IFMXPhoneDialerService;
begin
  { test whether the PhoneDialer services are supported }
  if TPlatformServices.Current.SupportsPlatformService(IFMXPhoneDialerService, IInterface(PhoneDialerService)) then
   begin
    { if the Telephone Number is entered in the edit box then make the call, else
      display an error message }
    if (LabelTel.Text <> '') and (LabelTel.Text <> 'n�o informado') then
      PhoneDialerService.Call(LabelTel.Text)
    else
     ShowMessage('Telefone n�o informado');
   end
  else
   ShowMessage('N�o � poss�vel realizar liga��es a partir deste dispositivo');

end;

procedure TForm1.ListBoxItem4Click(Sender: TObject);
begin
 showmessage(LabelSite.Text);
 OpenURL(LabelSite.Text);
end;

procedure TForm1.ListBoxListaItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
var
 strUrl: String;
 imgStream: TStream;
begin
 ChangeTabActionLoja.ExecuteTarget(self);

 QryLocateLoja.close;
 QryLocateLoja.ParamByName('nome').AsString := ListBoxLista.Selected.Text;
 QryLocateLoja.Open;

 labelnome1.text := QryLocateLoja.FieldByName('nome').AsString;
 labelnome2.text := QryLocateLoja.FieldByName('nome').AsString;
 botaomapa.Text  := 'Ver Mapa ' + QryLocateLoja.FieldByName('piso').AsString;
 labelloja.Text  := QryLocateLoja.FieldByName('loja').AsString;
 labeltel.Text   := QryLocateLoja.FieldByName('telefone').AsString;
 labelsite.Text  := QryLocateLoja.FieldByName('site').AsString;
 labeltipo.Text  := QryLocateLoja.FieldByName('tipo').AsString;

 strUrl := 'http://www.salvadorshopping.com.br/wp-content/uploads/lojas/' + QryLocateLoja.FieldByName('image').AsString;

 imgStream := TMemoryStream.Create;
 IdHTTP1.Get(StrUrl, imgStream);

 Image1.Bitmap.LoadFromStream(imgStream);
end;

procedure TForm1.ssashoppingAfterConnect(Sender: TObject);
begin
{ if not fileexists(ssashopping.Params.Values['Database']) then
  begin
}
   ssashopping.ExecuteDirect('CREATE TABLE IF NOT EXISTS lojas (loja INT(5) NOT NULL PRIMARY KEY, nome TEXT(30), telefone TEXT(15), piso TEXT(3), site TEXT(30), image TEXT(40), tipo TEXT(40), mapa TEXT(40))');

   AddLojas;
//  end;
end;

procedure TForm1.ssashoppingBeforeConnect(Sender: TObject);
begin
{$IFDEF IOS}
 ssashopping.Params.Values['Database'] := GetHomePath + PathDelim + 'Documents' + PathDelim + 'ssashopping.s3db';
{$ENDIF}
end;

procedure TForm1.AddLojas;
begin
ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("2ndFloor.fw.png","2ND FLOOR","n�o informado","71 33412176","www.2ndfloor.com.br","L2",2093,"2093.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("33sergioArno.fw.png","33 S�RGIO ARNO  ","n�o informado","71 30195289","sergioarno.com.br","L1",1033,"1033.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("5aSec.png","5 � SEC","n�o informado","71 30196666","www.5asec.com.br","G1",4014,"4014.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("aZ.png","A ... Z","n�o informado","71 30199612","n�o informado","L1",1006,"1006.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("aDiamantina.png","A DIAMANTINA","n�o informado","71 30191728","www.adiamantina.com.br","L1",1017,"1017.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("aFormula.fw.png","A F�RMULA","n�o informado","71 31133650","n�o informado","L1",1102,"1102.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("aPorteira.png","A PORTEIRA EXPRESS","n�o informado","71 30192027","www.aporteira.com.br","L3",3058,"3058.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("aTarde.png","A TARDE","n�o informado","71 32723078","atarde.uol.com.br","G1",4016,"4016.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("abuelaGoye.fw.png","ABUELA GOYE","n�o informado","71 33415649","www.abuelagoye.com.br","L2",2123,"2123.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("acarajeOlga.jpg","ACARAJ� DE OLGA","ALIMENTA��O","71 30157996","www.acarajedeolga.com","G1",0407,"Q407.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("acessorium.png","ACESSORIUM","ACESS�RIOS","71 33421842","n�o informado","G1",4009,"4009.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("adLifeStyle.fw.png","AD LIFE STYLE","MODA FEMININA E MASCULINA","71 33426824","www.adlifestyle.com.br","L1",1079,"1079.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("adcos.fw.png","ADCOS","PERFUMARIA E COSM�TICOS","71 30118848","www.adcos.com.br","L1",1187,"1187.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("adega.jpg","ADEGA","ADEGA","71 33428398","www.adegatiosam.com.br","L1",10152,"1015B.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("adidas.fw.png","ADIDAS","ARTIGOS ESPORTIVOS","71 34142427","www.adidas.com.br","L2",2036,"2036.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("adolfoDominguez.fw.png","ADOLFO DOMINGUEZ","MODA FEMININA","71 33411268","www.adolfodominguezshop.com","L2",21291,"2129A.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("adrielle.png","ADRIELLE","CAL�ADOS/BOLSAS","71 33412071","www.adrielle.com.br","L1",1153,"1153.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("aguaDeCheiro.png","�GUA DE CHEIRO","PERFUMARIA E COSM�TICOS","71 30196698","www.aguadecheiro.com.br","L2",2043,"2043.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("alMare.png","AL MARE","RESTAURANTES","71 30337615","www.almaresalvador.com.br","L1",1034,"1034.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("alphabeto.fw.png","ALPHABETO","MODA E ARTIGOS INFANTIS","71 30191398","www.alphabeto.com","L1",1137,"1137.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("amorAosPedacos.jpg","AMOR AOS PEDA�OS","CAF� / CH� / DOCERIA / SORVETERIA","71 30165858","n�o informado","L1",11111,"1111A.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("andarella.fw.png","ANDARELLA","CAL�ADOS/BOLSAS","71 33415337","www.andarella.com.br","L2",2081,"2081.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("animaFest.jpg","ANIMAFEST","ARTIGOS PARA FESTA","71 33419291","www.animafest.com.br","L1",1117,"1117.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("animale.fw.png","ANIMALE","MODA FEMININA","71 30197614","www.animale.com.br","L2",20671,"2067A.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("anne.jpg","ANNE","MODA FEMININA","71 33420117","www.anne.com.br","L2",2018,"2018.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","ANNE PRESENTES","PRESENTES","71 30222600","n�o informado","L1",1045,"1045.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("aramis (1).jpg","ARAMIS","MODA MASCULINA","71 31798037","www.aramis.com.br","L2",2110,"2110.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("armarinho.png","ARMARINHO SALVADOR","ARMARINHO","71 30197470","armarinhosalvador.com.br","G1",4001,"4001.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("armazemAmazonico.jpg","ARMAZ�M AMAZ�NICO STORE","PERFUMARIA E COSM�TICOS","71 30195662","www.armazemamazonico.com.br","L1",1143,"1143.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("armazemBeer.png","ARMAZ�M BEER SPECIAL","ADEGA","71 41112646","www.armazembeer.com","L1",0127,"Q127.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("arteEmPapel.png","ARTE EM PAPEL","PRESENTES","71 32712603","www.arteempapel.com.br","L1",1149,"1149.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("arteEmPapel.png","ARTE EM PAPEL","PRESENTES","71 31131125","www.arteempapel.com.br","L2",2072,"2072.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","ATHLETIC","ARTIGOS ESPORTIVOS","71 30232604","n�o informado","L2",0207,"Q207.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("australia.jpg","AUSTR�LIA STEAK HOUSE","FAST FOOD","71 30199994","www.australiasteakhouse.com.br","L3",3038,"3038.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("authenticFeet.png","AUTHENTIC FEET","ARTIGOS ESPORTIVOS","71 32725442","www.authenticfeet.com.br","L2",2046,"2046.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("avatim.jpg","AVATIM","PERFUMARIA E COSM�TICOS","71 30232700","www.avatim.com.br","L2",2100,"2100.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("babyBeefExpress.png","BABY BEEF EXPRESS","FAST FOOD","71 34142311","www.babybeefexpress.com.br","L3",3017,"3017.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("bacco.fw.png","BACCO","RESTAURANTES","71 30230518","n�o informado","L2",0212,"Q212.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("balcaoIngressos.jpg","BALC�O DE INGRESSOS","INGRESSOS","71 33410265","balcaodeingressos.com","G1",0411,"Q411.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("bambinoDecor.fw.png","BAMBINO DECOR","ARTIGOS INFANTIS","71 32718420","www.bambinodecor.com.br","L1",1206,"1206.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("bamboo.png","BAMBOO PODOLOGIA E BEM ESTAR","PODOLOGIA E MASSOTERAPIA","71 33411919","bamboopodologia.blogspot.com.br","G1",4018,"4018.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("bancoBrasil.fw.png","BANCO DO BRASIL","BANCOS E CAIXAS ELETR�NICOS","71 33418522","www.bb.com.br","L1",1157,"1157.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","BANCO ITA�","BANCOS E CAIXAS ELETR�NICOS","71 36161450","n�o informado","L1",1165,"1165.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("baberCity.fw.png","BARBER CITY","SAL�O DE BELEZA","71 33428147","www.barbercity.com.br","L1",1004,"1004.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("barreds.png","BARREDS","MODA FEMININA","71 32724231","www.barreds.com.br","L2",2142,"2142.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("beijuMix.png","BEIJU MIX","ALIMENTA��O","71 3018-1507","www.beijumix.com.br","G1",0406,"Q406.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("belSalvador.fw.png","BEL SALVADOR","PERFUMARIA E COSM�TICOS","71 33426813","www.belsalvador.com.br","L1",1096,"1096.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("belSalvador.fw.png","BEL SALVADOR","PERFUMARIA E COSM�TICOS","71 33414575","www.belsalvador.com.br","L1",1190,"1190.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("belleBijou.png","BELLE BIJOU","BIJUTERIAS E ACESS�RIOS","71 30193096","www.bellebijou.com.br","L2",2144,"2144.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("berloque.fw.png","BERLOQUE","BIJUTERIAS E ACESS�RIOS","71 30142465","www.berloque.com.br","L1",1097,"1097.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("bibi.fw.png","BIBI CAL�ADOS","CAL�ADOS","71 30127306","www.bibi.com.br","L1",1122,"1122.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("bilbao.png","BILBAO","MODA MASCULINA","71 33414711","www.bilbao.com.br","L2",2052,"2052.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("bilabong.fw.png","BILLABONG / ELEMENT","MODA JOVEM","71 30192487","www.billabong.combr","L2",2133,"2133.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("bluK.jpg","BLU K","MODA FEMININA","71 33427250","www.bluk.com.br","L2",2073,"2073.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("bobstore.png","BOB STORE","MODA FEMININA","71 33412563","www.bobstore.com.br","L2",2158,"2158.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("bobs.jpg","BOBS","FAST FOOD","71 30233186","www.bobs.com.br","L3",3008,"3008.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("bompreco.fw.png","BOMPRE�O","SUPERMERCADO","71 32732350","www.bomprecomercado.com","L1",1001,"1001.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("bonapart.png","BONAPARTE","FAST FOOD","71 30228816","www.bonaparte.com.br","L3",30151,"3015A.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","BONNIE","MODA FEMININA","71 30181912","n�o informado","L2",2032,"2032.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("boraBaheea.png","BORA BAH��A STORE","ARTIGOS ESPORTIVOS","71 32722336","www.borabaheastore.com","G1",4024,"4024.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("borgesCalcados.fw.png","BORGES CAL�ADOS","CAL�ADOS/BOLSAS","71 33427303","www.borgescalcados.com.br","L1",1002,"1002.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("brooksfield.png","BROOKSFIELD","MODA MASCULINA","71 33411449","www.brooksfield.com.br","L2",2063,"2063.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("burgerKing.png","BURGER KING","FAST FOOD","71 32726146","www.burgerking.com.br","L3",3003/3004,"3003/3004.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("cacauShown.fw.png","CACAU SHOW","CAF� / CH� / DOCERIA / SORVETERIA","71 32720248","www.cacaushow.com.br","L1",1126,"1126.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("caipiraExpress.jpg","CAIPIRA EXPRESS","FAST FOOD","71 30193999","n�o informado","L3",3047,"3047.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("caixa.fw.png","CAIXA ECON�MICA","BANCOS E CAIXAS ELETR�NICOS","71 34028600","www.caixa.gov.br","L1",1052,"1052.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("calvinKleinJeans.jpg","CALVIN KLEIN JEANS","MODA FEMININA E MASCULINA","71 30190182","www.calvinkleininc.com","L2",2108,"2108.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("calvinKleinUnderwear.jpg","CALVIN KLEIN UNDERWEAR","MODA �NTIMA","71 30191209","n�o informado","L2",2118,"2118.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("camarote7.png","CAMAROTE 7","MODA FEMININA","71 33418938","n�o informado","L1",1196,"1196.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("cambalhota.jpg","CAMBALHOTA","MODA E ARTIGOS INFANTIS","71 30165757","n�o informado","L1",1199,"1199.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("camboja.jpg","CAMBODJA","MODA FEMININA","71 30193468","www.cambodja.com.br","L2",2013,"2013.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("colombo.png","CAMISARIA COLOMBO","MODA MASCULINA","n�o informado","www.camisariacolombo.com.brLoja/","L1",1105,"1105.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("carga&recarga.png","CARGA E RECARGA","INFORM�TICA","71 30225200","n�o informado","G1",4012,"4012.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("carlosMiele.fw.png","CARLOS MIELE","MODA FEMININA","71 32720163","www.carlosmiele.com.br","L2",2053,"2053.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","CARLOS RODEIRO JOALHEIRO","J�IAS E SEMIJ�IAS","71 33428280","n�o informado","L2",2050,"2050.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("carmenSteffens.fw.png","CARMEN STEFFENS","CAL�ADOS/BOLSAS","71 33410192","www.carmensteffens.com.br","L1",1191,"1191.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("carolinaCosta.fw.png","CAROLINA COSTA","BIJUTERIAS E ACESS�RIOS","71 33410274","www.carolinacosta.com.br","L1",1124,"1124.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("carroDeBoi.fw.png","CARRO DE BOI","RESTAURANTES","71 30193473","n�o informado","L3",3034,"3034.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("casaDaCopia.png","CASA DA C�PIA","COPIADORA","71 30134520","www.casadacopia.com.br","G1",4002,"4002.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("casaDoCartucho.png","CASA DO CARTUCHO","INFORM�TICA","71 38782090","www.casadocartucho.com","L1",1167,"1167.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","CASA DO P�O DE QUEIJO","CAF� / CH� / DOCERIA / SORVETERIA","71 30232697","n�o informado","L1",1036,"1036.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("casasBahia.fw.png","CASAS BAHIA","ELETROELETR�NICOS","71 31145651","www.casasbahia.com.br","G2",5002,"5002.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("castros.fw.png","CASTROS","CAL�ADOS/BOLSAS","71 30356524","n�o informado","L1",1127,"1127.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("centauro.fw.png","CENTAURO","ARTIGOS ESPORTIVOS","71 30199251","www.centauro.com.br","L2",2061,"2061.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("chalezinho.fw.png","CHALEZINHO","RESTAURANTES","71 30196103","n�o informado","L3",3033,"3033.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("champion.fw.png","CHAMPION","REL�GIOS","71 91743944","www.championrelogios.com.br","L1",111,"Q111.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("chang.png","CHANG","ELETR�NICOS","71 33421040","n�o informado","G1",4006,"4006.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","CHARLOT","PERFUMARIA E COSM�TICOS","71 30193302","n�o informado","L2",2014,"2014.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("charlotte.jpg","CHARLOTTE BEAUT�","PERFUMARIA E COSM�TICOS","71 32726008","n�o informado","L1",1056,"1056.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","CHEZ CAF�","CAF� / CH� / DOCERIA / SORVETERIA","71 30199307","n�o informado","L1",1155,"1155.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("chilliBeans.fw.png","CHILLI BEANS","ACESS�RIOS","71 30338690","www.chillibeans.com.br","L2",0205,"Q205.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("chocolatesBrasil.png","CHOCOLATES BRASIL CACAU","CAF� / CH� / DOCERIA / SORVETERIA","71 30195221","www.chocolatesbrasilcacau.com.br","G1",4010,"4010.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("cinemark.fw.png","CINEMARK","CINEMAS","71 30233916","www.cinemark.com.br","L3",3005,"3005.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("citroen.fw.png","CITROEN","EXPOSI��O VE�CULO","71 33608000","www.citroen.com.br","L1",0121,"Q121.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("claro.fw.png","CLARO","TELEFONIA","n�o informado","www.claro.com.br","L2",2037,"2037.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("claro.fw.png","CLARO FIXO - EMBRATEL / LIVRE","TELEFONIA","71 31816060","www.claro.com.br","L1",0117,"Q117.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("clinique.fw.png","CLINIQUE","PERFUMARIA E COSM�TICOS","71 30193315","www.clinique.com.br","L1",0109,"Q109.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","COLCCI","MODA FEMININA E MASCULINA","71 30199278","n�o informado","L2",2120,"2120.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","COLCH�ES ORTOBOM","DIVERSOS","71 30197903","n�o informado","L1",1066,"1066.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("coloneziService.png","COLON�ZI SERVICE","ASSIST�NCIA T�CNICA DE CELULARES","71 30162569","www.colonezi.com.br","G1",4007,"4007.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("ciaDoChurrasco.jpg","COMPANHIA DO CHURRASCO","ALIMENTA��O","71 30230472","n�o informado","L3",3057,"3057.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("comparatto.png","COMPARATTO","CAL�ADOS/BOLSAS","71 32724006","www.comparatto.com.br","L2",2071,"2071.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("comparatto.png","COMPARATTO ACESS�RIOS","BIJUTERIAS E ACESS�RIOS","71 33428211","www.comparatto.com.br","L1",1073,"1073.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","CONTAINER HOME","CASA E DECORA��O","71 32724018","n�o informado","L2",2092,"2092.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("contem1g.png","CONT�M 1G","PERFUMARIA E COSM�TICOS","71 30146015","www.contem1g.com.br","L2",2163,"2163.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("corbeluxe.fw.png","CORBELUXE","CAL�ADOS/BOLSAS","71 30234218","www.corbeluxe.com.br","L1",1014,"1014.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("cori.fw.png","CORI","MODA FEMININA","71 32725903","www.cori.com.br","L2",2062,"2062.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("correios.png","CORREIOS","CORREIOS","71 31132766","www.correios.com.br","G1",40032,"4003B.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("couroECia.fw.png","COURO e CIA","CAL�ADOS/BOLSAS","71 30197954","couroecia.com.br","L2",2069,"2069.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("crawford.fw.png","CRAWFORD","MODA MASCULINA","71 30233560","www.crawford.com.br","L1",1040,"1040.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("cristallo.fw.png","CRISTALLO","CAF� / CH� / DOCERIA / SORVETERIA","71 30230888","n�o informado","L2",2056,"2056.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("crocs.fw.png","CROCS","CAL�ADOS","71 3019-8837","www.crocs.com.br","L2",2089,"2089.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("cvc.jpg","CVC","AG�NCIA DE VIAGENS","71 36160300","www.cvc.com.br","L1",1120,"1120.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("cvc.jpg","CVC VIAGENS","AG�NCIA DE VIAGENS","71 30826200","www.cvc.com.br","L1",1018,"1018.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("cyrela.jpg","CYRELA","IMOBILI�RIO","71 33555100","www.cyrela.com.brba","G2",5004,"5004.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("daducha.png","DADUCHA","MODA E ARTIGOS INFANTIS","71 30193967","www.daducha.com.br","L1",1202,"1202.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("damyller.fw.png","DAMYLLER","MODA FEMININA E MASCULINA","71 33418702","www.dmylr.com.br","L1",1067,"1067.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","DENTAL WHITE","CLINICA ODONTOL�GICA","71 34142318","clinicadentalwhite.com.brsalvador/","G1",4019,"4019.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("denySports.fw.png","DENY SPORTS","CAL�ADOS/BOLSAS","71 30196638","www.denysports.com.br","L1",1103,"1103.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("diamondEiraws.fw.png","DIAMOND e IRAWS","J�IAS E SEMIJ�IAS","71 30195940","www.diamondiraws.com.br","L1",1070,"1070.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("dinni.fw.png","DINNI","CAL�ADOS/BOLSAS","71 30120817","www.dinni.com.br","L1",1046,"1046.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("divinoFogao.png","DIVINO FOG�O","FAST FOOD","71 30192444","www.divinofogao.com.br","L3",3048,"3048.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("docDog.png","DOC DOG","CAL�ADOS/BOLSAS","71 30195973","www.docdog.com.br","L1",1144,"1144.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("docesSonhos.fw.png","DOCES SONHOS","CAF� / CH� / DOCERIA / SORVETERIA","71 32712300","www.docessonhosdoceria.com.br","L3",3042,"3042.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("domCroulo.fw.png","DOM CRIOULO CAF�","CAF� / CH� / DOCERIA / SORVETERIA","71 30199927","n�o informado","L1",1061,"1061.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("donatario.fw.png","DONAT�RIO","FAST FOOD","71 30228880","www.donatario.com.br","L3",3014,"3014.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("dressTo.png","DRESS TO","MODA FEMININA","71 30195043","xn--dressto%20-%20vero%202013%20www-9uc.dressto.com.br","L2",2058,"2058.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","DROGARIAS FARMAIS","DROGARIAS","71 31131995","www.farmais.com.br","L1",1101,"1101.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("dryWash.fw.png","DRY WASH","LAVA-JATO","71 32725446","www.drywash.com.br","G1",0409,"Q409.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("dudalina.jpg","DUDALINA","MODA FEMININA E MASCULINA","71 32722849","www.dudalina.com.br","L2",2098,"2098.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("dumond.jpg","DUMOND","CAL�ADOS/BOLSAS","71 30334283","www.dumond.com.br","L2",2140,"2140.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("dzarm.png","DZARM","MODA JOVEM","71 33417525","www.dzarm.com.br","L2",2085,"2085.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("eggos.png","EGGOS SHOES","CAL�ADOS/BOLSAS","71 30191390","n�o informado","L1",1114,"1114.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("elementais.jpg","ELEMENTAIS","MODA FEMININA","71 30185869","www.elementais.com.br","L2",2016,"2016.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("ellus.fw.png","ELLUS","MODA JOVEM","71 33413202","ellus.com","L2",2150,"2150.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("emporioBijux.png","EMP�RIO BIJUX","BIJUTERIAS E ACESS�RIOS","71 33411795","www.emporiobijux.com.br","L2",2007,"2007.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("enjoy.jpg","ENJOY","MODA FEMININA","71 32720513","www.enjoy.com.br","L2",2103,"2103.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("espacoFashion.png","ESPA�O FASHION","MODA FEMININA","71 3341-1673","www.espacofashion.net.br","L2",2023,"2023.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","ESPA�O KIDS","MODA E ARTIGOS INFANTIS","71 32720004","n�o informado","L2",2040,"2040.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","ESTA��O SHOES","CAL�ADOS/BOLSAS","71 33412016","n�o informado","L1",1140,"1140.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("etna.fw.png","ETNA","CASA E DECORA��O","71 32047750","www.etna.com.br","L2",2091,"2091.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("express.png","EXPRESS FASHION","MODA FEMININA","71 33416789","n�o informado","L1",1178,"1178.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("fabrizioGiannone.png","FABRIZIO GIANNONE DESIGNER","J�IAS E SEMIJ�IAS","71 30222524","www.fabriziogiannone.com.br","L2",2034,"2034.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","FANTASIA DISNEY","ARTIGOS INFANTIS","71 41020287","n�o informado","L1",0122,"Q122.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("farm.jpg","FARM","MODA FEMININA","71 30229150","www.farmrio.com.br","L2",2011,"2011.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("farmaciaFlora.fw.png","FARM�CIA FLORA MANIPULA��O","FARM�CIAS DE MANIPULA��O","71 33406492","www.farmaciaflora.com.br","L1",1060,"1060.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("farmaciaSantana.fw.png","FARM�CIA SANTANA","DROGARIAS","71 33406656","www.farmaciassantana.com.br","L1",1088,"1088.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("fascar.fw.png","FASCAR","CAL�ADOS/BOLSAS","71 30192105","www.fascar.com.br","L2",2105,"2105.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("fastShop.fw.png","FAST SHOP","ELETROELETR�NICOS","71 33113250","www.fastshop.com.br","L1",1092,"1092.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("feitoAgrao.jpg","FEITO A GR�O","ALIMENTA��O","71 30338392","www.feitoagrao.com.br","L2",0206,"Q206.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("felissa.png","FELISSA JOIAS","J�IAS E SEMIJ�IAS","71 3022-9930","www.felissa.com.br","L1",1121,"1121.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("feranda.jpg","FERANDA","MODA FEMININA","71 30191263","www.feranda.com.br","L2",2048,"2048.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("ferreiroCafe.png","FERREIRO CAF�","RESTAURANTES","71 33427426","ferreirocafesalvador.blogspot.com","L1",1035,"1035.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("folic.png","FOLIC","MODA FEMININA","71 30194127","www.folic.com.br","L2",21191,"2119A.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("fototica.png","FOTOTICA","�TICAS","71 32738457","www.fototica.com.br","L1",1054,"1054.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("fredissimo.fw.png","FRED�SSIMO","ALIMENTA��O","71 33410771","www.freddissimo.com.br","L3",0304,"Q304.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","FUN SHOES","CAL�ADOS INFANTIS","71 30330002","n�o informado","L1",0125,"Q125.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("galeriaArteViva.fw.png","GALERIA ARTE VIVA","MOLDURARIA","71 38781363","www.galeriaarteviva.com.br","L1",1049,"1049.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("gameStation.fw.png","GAME STATION","DIVERS�ES","71 33427691","www.gamestation.com.br","L3",3001,"3001.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("ganache.jpg","GANACHE","CAF� / CH� / DOCERIA / SORVETERIA","71 30321791","n�o informado","L3",0303,"Q303.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("gattai.png","GATTAI","RESTAURANTES","71 30228886","www.gattairestaurante.com.br","L1",1032,"1032.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("genteMiuda.png","GENTE MI�DA","DIVERS�ES","71 30211200","n�o informado","G1",0405,"Q405.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("giraffas.png","GIRAFFAS","FAST FOOD","71 30228238","www.giraffas.com.br","L3",3045,"3045.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("gourmandise.png","GOURMANDISE","ALIMENTA��O","71 30233223","www.gourmandisebrasil.com","L2",0214,"Q214.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("gpAutoExpress.png","GP AUTOEXPRESS","SERVI�OS","71 30340330","www.gpautoexpress.com.br","G1",0415,"Q415.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("graffiti.png","GRAFFITI","ACESS�RIOS","71 32724654","n�o informado","L1",0138,"Q138.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("granado.png","GRANADO / L2-2129","PERFUMARIA E COSM�TICOS","71 32720819","www.granado.com.br","L2",21293,"2129C.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("grats.png","GRAT�S","CAL�ADOS/BOLSAS","71 3272- 2642","www.gratscalcados.com.br","L1",1205,"1205.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("gregory.png","GREGORY","MODA FEMININA","71 30194175","www.gregory.com.br","L2",2060,"2060.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("griletto.png","GRILETTO","ALIMENTA��O","71 30132894","www.griletto.com.br","L3",3051,"3051.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("hstern.png","H. STERN","J�IAS E SEMIJ�IAS","71 32710066","www.hstern.com.br","L2",2157,"2157.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("heringStore.png","HERING STORE","MODA FEMININA E MASCULINA","71 32724951","www.hering.com.br","L1",1082,"1082.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("heyMan.png","HEY MAN","MODA JOVEM","71 30198886","n�o informado","L2",2029,"2029.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("his.png","HIS","MODA MASCULINA","71 33406828","n�o informado","L2",2030,"2030.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("hope.png","HOPE","MODA �NTIMA","71 30340044","www.hopelingerie.com.br","L1",1185,"1185.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","HOUSE e CO.","CASA E DECORA��O","71 30111810","n�o informado","L1",1181,"1181.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("hpStore.png","HP STORE","INFORM�TICA","71 32725150","www8.hp.combrpt/hp-store-locator/index.html","L1",11422,"1142B.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("hsbc.png","HSBC","BANCOS E CAIXAS ELETR�NICOS","71 33413340","www.hsbc.com.br","L1",1089,"1089.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("iceWatch.jpg","ICE-WATCH","REL�GIOS","71 33414796","ice-watch.com","L1",0139,"Q139.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("ilForno.png","IL FORNO","FAST FOOD","71 38781344","n�o informado","L3",3026,"3026.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imaginarium.jpg","IMAGINARIUM","CASA E DECORA��O","71 30197003","imaginarium.com.br","L2",2126,"2126.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("inTheStreet.png","IN THE STREET","MODA FEMININA","71 33415049","www.inthestreet.com.br","L1",1194,"1194.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("insinuante.png","INSINUANTE","ELETROELETR�NICOS","71 32716353","www.insinuante.com.br","L1",1024,"1024.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("io.png","IO","MODA FEMININA","71 38781243","n�o informado","L2",2017,"2017.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("isolution.png","I-SOLUTION","TELEFONIA","71 78113153","www.iphonesolution.com.br","L1",0119,"Q119.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("iStick.png","I-STICK","DECORA��O","71 32726835","www.istickonline.com","L2",0224,"Q224.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("itBeach.png","IT BEACH","CAL�ADOS/BOLSAS","71 30113380","www.itbeach.com.br","L2",2125,"2125.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("jacMotors.jpg","JAC MOTORS","EXPOSI��O VE�CULO","71 30118463","www.jacmotorsbrasil.com.br","L1",0143,"Q143.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("jacquesJanine.png","JACQUES JANINE","SAL�O DE BELEZA","71 30232825","jacquesjanine.com.br","L1",1180,"1180.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("joge.jpg","JOG�","MODA �NTIMA","71 31142389","www.joge.com.br","L2",2153,"2153.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("johnJohn.png","JOHN JOHN","MODA JOVEM","71 32726145","www.johnjohndenim.com","L2",2119,"2119.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("jorgeBischoff.jpg","JORGE BISCHOFF","CAL�ADOS/BOLSAS","71 30192019","www.jorgebischoff.com.br","L2",2134,"2134.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("jurandir.jpg","JURANDIR PIRES","CASA E DECORA��O","71 33414453","www.jurandirpires.com.br","L2",2041,"2041.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("kallaynne.png","KAL LAYNNE","MODA FEMININA","71 30197720","kallaynne.blogspot.com","L1",1081,"1081.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("kingmarket.png","KING MARKET","CASA E DECORA��O","71 38787131","www.kingmarket.com.br","L2",2033,"2033.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("kipling.png","KIPLING","CAL�ADOS/BOLSAS","71 33427345","www.kipling.com.br","L1",1027,"1027.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("kleberJoias.jpg","KL�BER J�IAS","J�IAS E SEMIJ�IAS","71 31132383","www.kleberjoias.com.br","L2",2059,"2059.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("kopenhagen.png","KOPENHAGEN","CAF� / CH� / DOCERIA / SORVETERIA","71 30182533","www.kopenhagen.com.br","L2",0213,"Q213.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("lacoste.jpg","LACOSTE","MODA FEMININA E MASCULINA","71 33416708","www.lacoste.combra/","L2",2161,"2161.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("leBiscuit.png","LE BISCUIT","LOJAS DE DEPARTAMENTO","71 33433903","www.lebiscuit.com.br","L2",20742,"2074B.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("leLisBlanc.png","LE LIS BLANC DEUX","MODA FEMININA","71 34142369","www.lelis.com.br","L2",2102,"2102.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("lepostiche.png","LE POSTICHE","BOLSAS","71 30235002","www.lepostiche.com.br","L1",1037,"1037.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("leader.png","LEADER","LOJAS DE DEPARTAMENTO","71 32730040","www.leader.com.br","L1",1209,"1209.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("leaoDeOuro.jpg","LE�O DE OURO","CAL�ADOS/BOLSAS","71 33406499","www.leaodeouro.com.br","L1",1063,"1063.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("leaoMania.jpg","LE�O MANIA","ARTIGOS ESPORTIVOS","71 32720097","www.leaomania.comhome","G1",0408,"Q408.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("lesChemises.png","LES CHEMISES","MODA FEMININA","71 30146942","www.leschemises.com.br","L2",2122,"2122.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("levis.png","LEVIS","MODA FEMININA E MASCULINA","71 33419821","www.levi.com.br","L2",2137,"2137.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("limits.jpg","LIMITS","MODA JOVEM","71 33412158","loja.limits.com.br","L2",2132,"2132.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("lindaLui.png","LINDA LUI","MODA FEMININA","71 30197224","n�o informado","L2",2057,"2057.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("lislife.png","LISLASER","CABELEIREIRO E EST�TICA","71 33413838","www.lislaser.com.br","L1",10691,"1069A.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("lislife.png","LISLIFE","CABELEIREIRO E EST�TICA","71 33417575","www.lislaser.com.br","L1",1005,"1005.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("livrariaCultura.fw.png","LIVRARIA CULTURA","LIVRARIA","71 35059050","www.livrariacultura.com.br","L2",21292,"2129B.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("loccitane.png","LOCCITANE","PERFUMARIA E COSM�TICOS","71 32721904","br.loccitane.com","L2",2101,"2101.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("login.jpg","LOGIN","INFORM�TICA","71 33421070","www.login.com.br","L1",1172,"1172.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("lojasAmericanas.png","LOJAS AMERICANAS","LOJAS DE DEPARTAMENTO","n�o informado","www.americanas.com.br","L1",1166,"1166.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("lookNfun.jpg","LOOKN FUN","ARTIGOS INFANTIS","71 32722609","looknfun.com.br","L1",0135,"Q135.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("loterias.png","LOTERIA SALVADOR SHOPPING","CASA LOT�RICA","71 30191314","n�o informado","G1",4005,"4005.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("lucca.png","LUCCA CAF�S ESPECIAIS","CAF� / CH� / DOCERIA / SORVETERIA","71 30227367","n�o informado","L1",10862,"1086B.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("luigiBertolli.jpg","LUIGI BERTOLLI","MODA FEMININA E MASCULINA","71 96111778","www.luigibertolli.com.br","L2",2021,"2021.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("lukParfums.jpg","LUK PARFUMS","PERFUMARIA E COSM�TICOS","71 30191874","www.lukparfums.com.br","L1",1163,"1163.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("lupo.png","LUPO","MODA �NTIMA","71 33414624","www.lupo.com.br","L2",2106,"2106.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("mmartan.png","M MARTAN","CASA E DECORA��O","71 30335155","www.mmartan.com.br","L1",1145,"1145.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("mOfficer.png","M.OFFICER","MODA FEMININA E MASCULINA","71 32721015","www.mofficer.com.br","L2",2077,"2077.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("macCosmeticos.png","MAC COSM�TICOS","PERFUMARIA E COSM�TICOS","71 30115154","www.maccosmetics.com.br","L2",2104,"2104.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("madameMs.png","MADAME MS","MODA FEMININA","71 30196692","www.madamems.com.br","L1",1177,"1177.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("mahalo.png","MAHALO","SURFWEAR","71 30340960","www.mahalo.com.br","L1",1075,"1075.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("mahogany.png","MAHOGANY","PERFUMARIA E COSM�TICOS","71 30193305","www.mahogany.com.br","L1",1009,"1009.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("malwee.png","MALWEE ADULTO","MODA FEMININA E MASCULINA","71 32721498","www.malwee.com.br","L1",1201,"1201.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("malwee.png","MALWEE BRASILEIRINHO- L1-1186","MODA E ARTIGOS INFANTIS","71 30377200","www.malwee.com.br","L1",1186,"1186.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("mandiCo.png","MANDI e CO","MODA FEMININA E MASCULINA","71 30198480","www.mandi.net/","L2",2107,"2107.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("maoTai.jpg","MAO TAI","FAST FOOD","71 30161572","www.maotai.com.br","L3",3007,"3007.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","MAR REVOLTO","SURFWEAR","71 34507513","n�o informado","L1",1171,"1171.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("maramac.png","MARA MAC","MODA FEMININA","71 33413942","www.maramac.com.br","L2",2076,"2076.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("mariaCheirosa.jpg","MARIA CHEIROSA","PERFUMARIA E COSM�TICOS","71 33428042","mariacheirosa.com.br","L1",1078,"1078.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("maricota.png","MARICOTA CAF�","CAF� / CH� / DOCERIA / SORVETERIA","71 30337280","n�o informado","L1",0133,"Q133.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("marietta.png","MARIETTA","FAST FOOD","71 33411097","www.marietta.com.br","L3",3040,"3040.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("marietta.png","MARIETTA CAFE","FAST FOOD","71 38781310","www.marietta.com.br","G1",0401,"Q401.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("mariposa.jpg","MARIPOSA","RESTAURANTES","71 30161801","www.mariposa.com.br","L3",3037,"3037.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("marisa.png","MARISA","LOJAS DE DEPARTAMENTO","71 32732650","www.marisa.com.br","L1",1062,"1062.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("masseria.png","MASSERIA","FAST FOOD","71 33414491","n�o informado","L3",3009,"3009.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("maz.jpg","MAZ","CAL�ADOS","71 30143123","www.mazworld.com.br","L2",20862,"2086B.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("mcDonalds.png","MC DONALDS","FAST FOOD","71 33428202","www.mcdonalds.com.br","L3",3029,"3028/3029.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("melindaMelinda.png","MELINDA MELINDA","BIJUTERIAS E ACESS�RIOS","71 32718457","www.melindamelinda.com.br","L1",11421,"1142A.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("merciaJoias.jpg","MERCIA REL�GIOS","REL�GIOS","71 32720824","n�o informado","L1",0132,"Q132.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("miau.jpg","MIAU! SAL�O DE BELEZA INFANTO-JUVENIL","SAL�O DE BELEZA","71 30151889","n�o informado","L1",1051,"1051.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("mimo.png","MIMO MALAS","ACESS�RIOS VIAGEM","71 32726138","n�o informado","L2",0209,"Q209.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("miniKalzone.png","MINI KALZONE","FAST FOOD","71 33426633","www.minikalzone.com.br","L3",3002,"3002.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("minilab.jpg","MINILAB","FOTO/REVELA��O","71 33401995","n�o informado","L1",1057,"1057.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("missBella.jpg","MISSBELLA","MODA FEMININA","71 32721541","www.missbella.com.br","L1",1138,"1138.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("mitchell.png","MITCHELL","MODA MASCULINA","71 30198881","www.mitchell.com.br","L2",2027,"2027.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("mito.jpg","MITO","MODA FEMININA E MASCULINA","71 33411699","www.sejamito.com.br","L1",1008,"1008.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("mmModas.png","MM MODA","MODA MASCULINA","71 33412160","n�o informado","L1",1156,"1156.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("molduraExpressa.jpg","MOLDURA EXPRESSA","MOLDURARIA","71 33418768","n�o informado","L1",1069,"1069.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("monalisa.png","MONALISA","FAST FOOD","71 30228816","n�o informado","L3",3015,"3015.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("monicaSanches.png","MONICA SANCHES","BOLSAS","71 33410763","www.monicasanches.com.br","L1",1043,"1043.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("morana.png","MORANA","BIJUTERIAS E ACESS�RIOS","71 32721451","www.morana.com.br","L1",1125,"1125.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("mrCabana.png","MR. CABANA","�TICAS","71 30196593","mrcabana.com.br","L1",0120,"Q120.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("mrCat.png","MR. CAT","CAL�ADOS/BOLSAS","71 30194297","mrcat.com.br","L2",2152,"2152.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("mrPretzels.png","MR. PRETZELS","ALIMENTA��O","71 32723985","www.mrpretzels.com.br","L1",0113,"Q113.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("multiCoisas.png","MULTICOISAS","CASA E DECORA��O","71 32720340","www.multicoisas.com.br","G1",4013,"4013.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","MUNDO DAS FLORES","FLORICULTURA","71 33410393","n�o informado","L1",0141,"Q141.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("mundoIphone.jpg","MUNDO DO IPHONE E BLACKBERRY","TELEFONIA","71 30221337","www.mundodoiphone.com.br","L1",0107,"Q107.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("mundoVerde.png","MUNDO VERDE","PRODUTOS NATURAIS E ESOT�RICOS","71 34142301","www.mundoverde.com.br","L1",1074,"1074.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("myth.png","MYTH","MODA FEMININA","71 32725953","www.myth.com.br","L1",1022,"1022.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("nagem.png","NAGEM","INFORM�TICA","40042021","www.nagem.com.br","L1",1010,"1010.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("nelinho.png","NELINHO/L1-1197","TELEFONIA","71 33284267","n�o informado","L1",1197,"1197.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("net.png","NET","TV A CABO","71 35060892","www.netcombo.com.br","L1",0128,"Q128.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("nike.png","NIKE","ARTIGOS ESPORTIVOS","71 33417010","www.nike.com","L2",2130,"2130.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("nokia.png","NOKIA","TELEFONIA","71 30331235","www.nokia.combr-pt/","L1",0105,"Q105.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("nutriStore.png","NUTRISTORE","SUPLEMENTOS E VITAMINAS","71 30339009","www.nutristore.com.br","L1",0124,"Q124.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("boticario.jpg","O BOTIC�RIO","PERFUMARIA E COSM�TICOS","71 32712223","www.boticario.com.br","L1",1116,"1116.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("boticario.jpg","O BOTIC�RIO","PERFUMARIA E COSM�TICOS","71 32711430","www.boticario.com.br","L2",2070,"2070.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("oakley.png","OAKLEY","MODA JOVEM","71 30194922","www.oakley.com.br","L2",2145,"2145.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","OFICINA DE �CULOS","CONSERTOS","71 30197312","n�o informado","G1",4015,"4015.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("ohBoy.png","OH, BOY!","MODA FEMININA","71 30199632","www.ohboy.com.br","L2",2022,"2022.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("oi.png","OI","TELEFONIA","71 33413745","www.oi.com.br","L1",1031,"1031.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("oi.png","OI","TELEFONIA","71 33413745","www.oi.com.br","L2",2002,"2002.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("olivaGourmet.png","OLIVA GOURMET","RESTAURANTES","71 30190201","www.restauranteoliva.com.br","L3",3021,"3021.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("opcao.png","OP��O","MODA FEMININA E MASCULINA","71 33429630","site.opcaojeans.com.br","L1",1025,"1025.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("opcao.png","OP��O JEANS","MODA JOVEM","71 33412095","site.opcaojeans.com.br","L1",1130,"1130.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("organico.jpg","ORG�NICO","ALIMENTA��O","71 30114331","n�o informado","L3",3011,"3011.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("osklen.jpg","OSKLEN","MODA FEMININA E MASCULINA","71 30190855","osklen.com","L2",2155,"2155.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("oticaDaGente.jpg","�TICA DA GENTE","�TICAS","71 33406888","www.oticadagente.com.br","L1",1020,"1020.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("oticasErnesto.jpg","�TICA ERNESTO","�TICAS","71 3342-8048","www.oticaernesto.com.br","L1",1038,"1038.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("oticasOpcao.jpg","�TICAS OP��O","�TICAS","71 33411933","www.oticasopcao.com","L1",1087,"1087.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("oticasPop.jpg","�TICAS POP","�TICAS","71 30199421","www.oticaspop.com.br","L1",1129,"1129.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("panthaiPratas.png","PANTHAI PRATAS","J�IAS E SEMIJ�IAS","71 32722677","www.panthai.com.br","L1",0134,"Q134.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("papelCia.png","PAPEL E CIA","INFORM�TICA","71 33436455","www.papelecia.com.br","L1",1107,"1107.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","PASTEL BEACH","FAST FOOD","71 38781951","n�o informado","L3",3025,"3025.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("perini.png","PERINI","ALIMENTA��O","71 3341-0873","www.perini.com.br","L3",0301,"Q301.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("petitBernard.png","PETIT BERNARD","ALIMENTA��O","71 34142314","www.petitbernard.com.br","L3",3018,"3018.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("pharmapele.jpg","PHARMAPELE","FARM�CIAS DE MANIPULA��O","71 33419660","www.pharmapele.com.br","L1",1044,"1044.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("planetGirls.png","PLANET GIRLS","MODA FEMININA","71 33412380","www.planetgirls.com.br","L1",1188,"1188.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("planetAnimal.png","PLANETA ANIMAL","PET SHOP","71 38781516","www.planetaanimalvet.com.br","L1",1016,"1016.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("planetaBebe.png","PLANETA BEB�","DIVERSOS","71 33433939","www.planetabb.com.br","L2",2065,"2065.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("planetaBombom.png","PLANETA BOMBOM","BOMBONIERE","71 30226111","www.planetabombom.com.br","L1",1023,"1023.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("polishop.png","POLISHOP","ELETROELETR�NICOS","71 30116674","www.polishop.com.br","L1",1170,"1170.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("porttePorcelanato.png","PORTTE PORCELANATO","DECORA��O","71 33530380","www.portteporcelanato.com.br","L1",0108,"Q108.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("premier.png","PREMIER COSM�TICOS DO MAR MORTO","COSM�TICOS","71 96821855","www.premiermarmorto.com.br","L2",0227,"Q227.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("prismaVision.png","PRISMA VISION","�TICAS","71 34610362","n�o informado","L2",2117,"2117.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("puc.png","PUC","MODA E ARTIGOS INFANTIS","71 30222122","www.puc.com.br","L2",20741,"2074A.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("puket.jpg","PUKET","MODA �NTIMA","71 30191123","www.puket.com.br","L2",2008,"2008.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("quattoAmici.png","QUATTRO AMICI","FAST FOOD","71 33417404","n�o informado","L3",3043,"3043.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("deltaexpresso.jpg","DELTAEXPRESSO CAF�","CAF� / CH� / DOCERIA / SORVETERIA","71 30166002","www.deltaexpresso.com.br","L3",1,"0.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("radish.jpg","RADISH","FAST FOOD","71 30141266","n�o informado","L3",3010,"3010.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("raizes.png","RA�ZES","FAST FOOD","71 32724241","n�o informado","L3",3016,"3016.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("redDog.jpg","RED DOG","CAL�ADOS/BOLSAS","71 33415353","reddog.com.br","L1",1128,"1128.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("reiDoMate.png","REI DO MATE","DIVERSOS","71 33415124","www.reidomate.com.br","L1",1019,"1019.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("renner.png","RENNER","LOJAS DE DEPARTAMENTO","71 37978200","www.lojasrenner.com.br","L2",2001,"2001.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("reserva.png","RESERVA","MODA MASCULINA","71 33412687","www.usereserva.com","L2",2154,"2154.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("restauraJeans.png","RESTAURA JEANS","CONSERTO ROUPAS/SAPATOS","71 32723336","www.restaurajeans.com","G1",4008,"4008.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("rihappy.png","RI HAPPY","BRINQUEDOS","71 33426828","www.rihappy.com.br","L1",1204,"1204.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("riachuelo.png","RIACHUELO","LOJAS DE DEPARTAMENTO","71 34440300","www.riachuelo.com.br","L2",2045,"2045.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("ricardoEletro.png","RICARDO ELETRO","LOJAS DE DEPARTAMENTO","71 33406311","www.ricardoeletro.com.br","L1",1077,"1077.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("richards.png","RICHARDS","MODA FEMININA E MASCULINA","71 33410967","www.richards.com.br","L2",2159,"2159.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("rose.png","ROSE TOQUE �NTIMO","MODA �NTIMA","71 33414466","n�o informado","L1",1179,"1179.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("sacada.png","SACADA","MODA FEMININA","71 30199378","www.sacada.com","L2",20672,"2067B.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("safetec.png","SAFETEC INFORM�TICA","COPIADORA","71 30135841","n�o informado","G2",0502,"Q502.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("saladCreations.jpg","SALAD CREATIONS","FAST FOOD","71 30196776","www.saladcreations.com.br","L3",3054,"3054.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("salinas.png","SALINAS","MODA PRAIA","71 33410220","www.salinascompras.com.br","L2",2160,"2160.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("salvadorCafe.png","SALVADOR CAF�","ALIMENTA��O","71 30227497","n�o informado","L2",0204,"Q204.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("samello.png","SAMELLO","CAL�ADOS/BOLSAS","71 33417767","www.samello.com.br","L1",1200,"1200.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("samsung.fw.png","SAMSUNG","TELEFONIA","n�o informado","www.samsung.com.br","L1",1084,"1084.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("santaLolla.jpg","SANTA LOLLA","CAL�ADOS/BOLSAS","71 33417614","www.santalolla.com.br","L2",2127,"2127.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("sapatariaDoFuturo.jpg","SAPATARIA DO FUTURO","CONSERTO ROUPAS/SAPATOS","71 33411022","www.sapatariadofuturo.com.br","L1",1053,"1053.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("saraivaMegastore.png","SARAIVA MEGA STORE","LIVRARIA","71 33417020","www.livrariasaraiva.com.br","L2",20252,"2025B.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("sartore.png","SARTTORE","MODA JOVEM","71 3019-4792","n�o informado","L2",2090,"2090.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("scala.png","SCALA","MODA �NTIMA","71 30191563","www.scalasemcostura.com.br","L2",2047,"2047.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("schutz.png","SCHUTZ","CAL�ADOS/BOLSAS","71 33413277","www.schutz.com.br","L2",2149,"2149.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("sergios.png","S�RGIOS","CAL�ADOS/BOLSAS","71 33426806","sergios.com.br","L2",2035,"2035.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("serrara.png","SERRARA","J�IAS E SEMIJ�IAS","71 30233028","www.serrara.com.br","L2",21041,"2104A.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("sevenCafe.png","SEVEN CAF�","ALIMENTA��O","71 30156061","www.sevencafe.com.br","L2",0210,"Q210.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("shop126.png","SHOP 126","MODA FEMININA","71 33413533","www.shop126.com.br","L2",2141,"2141.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("siberian.png","SIBERIAN","MODA FEMININA E MASCULINA","71 30233351","www.siberian.com.br","L1",1041,"1041.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("sky.png","SKY","TV A CABO","71 34928801","www.sky.com.br","L1",0102,"Q102.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("skyler.png","SKYLER","MODA MASCULINA","71 30190527","www.skyler.com.br","L1",1164,"1164.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("soSaude.png","S� SA�DE","ARTIGOS HOSPITALARES","71 30198558","www.sosaude.com.br","G1",4021,"4021.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("sohoStera.png","SOHO","RESTAURANTES","71 30326208","www.sohorestaurante.com.br","L3",3032,"3032.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("sonhoDosPes.png","SONHO DOS P�S","CAL�ADOS/BOLSAS","71 30191694","www.sonhodospes.com.br","L1",1195,"1195.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("sony.png","SONY","ELETROELETR�NICOS E INFORM�TICA","71 30199027","www.sony.com.br","L1",1131,"1131.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","SOUTH","MODA JOVEM","71 33414855","n�o informado","L1",1072,"1072.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("spadaccino.png","SPADACCINO EXPRESS","FAST FOOD","71 30198738","n�o informado","L3",3039,"3039.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("spicy.png","SPICY","CASA E DECORA��O","71 33410555","www.spicy.com.br","L1",1139,"1139.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","SPN","SUPLEMENTOS E VITAMINAS","71 30222910","n�o informado","L1",0118,"Q118.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("spoleto.jpg","SPOLETO","FAST FOOD","71 3018-2322","www.spoleto.com.br","L3",3055,"3055.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("stcTour.jpg","STC TOUR VIAGENS E TURISMO","AG�NCIA DE VIAGENS","71 31132525","www.stctour.com.br","L1",1012,"1012.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("strFashion.png","STR FASHION","MODA JOVEM","71 32727154","n�o informado","L2",2004,"2004.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("stroke.png","STROKE/ L2-2114","MODA FEMININA","71 32726916","www.stroke.com.br","L2",2114,"2114.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("subway.png","SUBWAY","FAST FOOD","71 32720253","www.subway.com.br","L3",3022,"3022.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("sunny.png","SUNNY","MODA PRAIA","71 33411333","n�o informado","L1",1013,"1013.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("superComfort.png","SUPERCOMFORT","CAL�ADOS","71 30335154","n�o informado","L1",1160,"1160.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("tabacariaCorona.png","TABACARIA CORONA","TABACARIA","71 30120515","n�o informado","L1",1162,"1162.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("taco.png","TACO","MODA JOVEM","71 30195261","www.taco.com.br","L1",1184,"1184.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","TAIMY","REL�GIOS","71 31136712","n�o informado","G1",0412,"Q412.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("tamViagens.fw.png","TAM VIAGENS","AG�NCIA DE VIAGENS","71 30335700","www.facebook.compages/Tam-Viagens-Salvador-Shopping/258309647521997?fref=ts","L2",2096,"2096.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("taniaBulhoes.png","T�NIA BULH�ES","PERFUMARIA E COSM�TICOS","71 30193568","www.taniabulhoes.com.br","L2",2121,"2121.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","TAZZO CAF�","ALIMENTA��O","71 34814011","n�o informado","L1",0101,"Q101.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("terraBrasil.png","TERRA BRASIL","RESTAURANTES","71 30222070","n�o informado","L3",3035,"3035.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("texMEx.png","TEX E MEX","FAST FOOD","71 32720473","%20www.texemex.com.br","L3",3053,"3053.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("thaiWok.png","THAI WOK","FAST FOOD","71 38781000","n�o informado","L3",3052,"3052.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("ticketmix.png","TICKETMIX","INGRESSOS","71 38782053","ticketmix.com.br","G2",0501,"Q501.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("tim.png","TIM","TELEFONIA","n�o informado","www.tim.com.br","L1",1182,"1182.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("tim.png","TIM SELFSHOP","TELEFONIA","71 32711406","www.tim.com.br","L2",2044,"2044.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("tim.png","TIM-MEGAGIRO","TELEFONIA","71 30144984","www.tim.com.br","L2",0202,"Q202.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("tipTop.png","TIP TOP","MODA E ARTIGOS INFANTIS","71 30194416","www.tiptop.com.br","L1",1147,"1147.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("tng.jpg","TNG","MODA FEMININA E MASCULINA","71 32727327","www.tng.com.br","L1",1085,"1085.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("tokai.jpg","TOKAI","FAST FOOD","71 30352911","n�o informado","L3",3056,"3056.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("tomCat.jpg","TOM CAT","ARTIGOS ESPORTIVOS","71 30160595","n�o informado","L1",1059,"1059.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("tomyHilfiger.jpg","TOMMY HILFIGER / ALEATORY","MODA FEMININA E MASCULINA","71 32727453","www.tommyhilfiger.com.br","L2",2139,"2139.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("touch.png","TOUCH","REL�GIOS","71 38781000","n�o informado","L1",0144,"Q144.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("toulon.png","TOULON","MODA MASCULINA","71 33410604","www.toulon.com.br","L2",2038,"2038.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("trackField.png","TRACK e FIELD","MODA PRAIA","71 32713056","www.trackandfield.com.br","L2",2136,"2136.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("tribos.png","TRIBOS STREETWEAR","MODA FEMININA","71 30197322","www.lojastribos.com.br","L1",1099,"1099.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("trinco.png","TRINCO","CONSERTOS","71 30146401","n�o informado","L1",1048,"1048.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("triton.png","TRITON","MODA FEMININA E MASCULINA","71 30192730","www.triton.com.br","L2",2116,"2116.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("triton.png","TRITON EYEWEAR","�TICAS","71 32723345","www.tritoneyewear.com.br","L1",1141,"1141.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("trousseau.png","TROUSSEAU","CASA E DECORA��O","71 30232274","n�o informado","L2",2135,"2135.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("trudys.png","TRUDYS","BIJUTERIAS E ACESS�RIOS","71 33406777","trudys.com.br","L2",2068,"2068.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("tuttiPresentes.jpg","TUTTI PRESENTES","PRESENTES","71 30196801","www.tuttipresentes.com.br","L1",1135,"1135.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("tyrol.jpg","TYROL","MODA E ARTIGOS INFANTIS","71 33412163","tyrol.com.br","L2",2099,"2099.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","VACINA LOUIS PASTEUR","SERVI�OS","71 33540209","www.vacinaslouispasteur.com.br","G1",4022,"4022.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("valisere.jpg","VALISERE/L2-2086","MODA �NTIMA","71 30343111","www.valisere.com.br","L2",20861,"2086A.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("velmond.png","VELMOND","MODA MASCULINA","71 30175256","n�o informado","L1",1151,"1151.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("versatto.png","VERSATTO EXPRESS FOOD","FAST FOOD","71 81150536","n�o informado","L3",3012,"3012.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("viamia.png","VIA MIA","CAL�ADOS/BOLSAS","71 32712262","www.viamia.com.br","L2",2128,"2128.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("viaParis.jpg","VIA PARIS","SAL�O DE BELEZA","71 30114417","www.viaparisbeleza.com.br","L1",1112,"1112.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("viaParis.jpg","VIA PARIS COSM�TIQUES","COSM�TICOS","71 30117446","www.viaparisbeleza.com.br","L1",1119,"1119.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("vibe.jpg","VIBE","MODA JOVEM","71 30191556","n�o informado","L2",2003,"2003.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("victorHugo.jpg","VICTOR HUGO","CAL�ADOS/BOLSAS","71 33414357","www.victorhugo.com.br","L2",2111,"2111.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("vilalara.jpg","VILA LARA","CAL�ADOS/BOLSAS","71 32720059","n�o informado","L1",1148,"1148.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("vilaRomana.png","VILA ROMANA","MODA MASCULINA","71 30234170","n�o informado","L2",2015,"2015.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("visaoTurismo.png","VIS�O TURISMO","AG�NCIA DE VIAGENS","71 33404200","www.visaotur.com.br","L1",1169,"1169.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("vivagula.png","VIVA GULA","CAF� / CH� / DOCERIA / SORVETERIA","71 30190200","www.vivagula.com.br","L3",3019,"3019.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("vivara.png","VIVARA","J�IAS E SEMIJ�IAS","71 32713954","www.vivara.com.br","L2",2026,"2026.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("vivendaDoCamarao.png","VIVENDA DO CAMAR�O","FAST FOOD","71 34940099","www.vivendadocamarao.com.br","L3",3013,"3013.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("vivo.png","VIVO","TELEFONIA","71 34142148","www.vivo.com.br","L1",1071,"1071.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","VOGLIO","MODA FEMININA","71 33411052","n�o informado","L1",1118,"1118.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("vr.jpg","VR","MODA MASCULINA","71 30227026","n�o informado","L2",2151,"2151.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("waveBeach.png","WAVE BEACH","SURFWEAR","71 30233166","www.wavebeach.com.br","L1",1108,"1108.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("worldTennis.png","WORLD TENNIS","CAL�ADOS/BOLSAS","71 33415007","www.worldtennis.com.br","L1",1192,"1192.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("xarmonix.png","XARMONIX","CASA E DECORA��O","71 30199295","www.xarmonix.com.br","L2",2079,"2079.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("yanping.png","YAN PING","FAST FOOD","71 32720944","www.yanping.com.br","L3",3023,"3023.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("yoFrozen.png","YOFROZEN","SORVETES","71 30233988","www.yofrozen.com.br","L1",0126,"Q126.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("yoggi.png","YOGGI","SORVETES","71 30131344","www.yoggi.com.br","L1",1174,"1174.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","ZINZANE","MODA FEMININA","71 34142422","www.zinzane.com.br","L2",2005,"2005.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("zip.jpg","ZIP","MODA MASCULINA","71 33415639","n�o informado","L2",2094,"2094.gif")');

//ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("sankaku.jpg","SANKAKU","ARTIGOS ESPORTIVOS","71 30372226","n�o informado","L1",10691,"1069.gif")');   //TODO: Numero da loja incorreto?!

//ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("itown.png","ITOWN","ELETROELETR�NICOS E INFORM�TICA","71 32726845","n�o informado","L2",2129,"2129.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("imgPadrao.png","QUIOSQUE DA FIFA","PRESENTES E BRINQUEDOS","n�o informado","n�o informado","L1",50,"50.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("snc.png","SNC","SUPLEMENTOS NUTRICIONAIS","71 30145490","n�o informado","L1",1193,"1193.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("josefine.jpg","JOSEFINE PLUS SIZE","MODA FEMININA","n�o informado","n�o informado","L1",1173,"1173.gif")');

ssashopping.ExecuteDirect('insert into lojas (image, nome, tipo, telefone, site, piso, loja, mapa) values ("Logomarca_QDB.jpg","QUEM DISSE, BERENICE?","COSM�TICOS","71 31132393","www.quemdisseberenice.com.br","L1",1091,"1091.gif")');

end;

end.
