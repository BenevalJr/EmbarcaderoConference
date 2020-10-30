unit fPrinicpal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DBCtrls, Grids, DBGrids, DB, StdCtrls, DBTables,
  Vcl.Buttons;

type
  TfrmPrincipal = class(TForm)
    dgrEstados: TDBGrid;
    dnvEstados: TDBNavigator;
    pnlPesquisa: TPanel;
    rdgTipos: TRadioGroup;
    dtsCadastroEstados: TDataSource;
    tblCadastroEstados: TTable;
    Database: TDatabase;
    tblCadastroEstadosID_ESTADO: TIntegerField;
    tblCadastroEstadosNOME: TStringField;
    tblCadastroEstadosSIGLA: TStringField;
    edtPesquisa: TEdit;
    btnBuscar: TBitBtn;
    procedure dgrEstadosTitleClick(Column: TColumn);
    procedure btnBuscarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.btnBuscarClick(Sender: TObject);
begin
  tblCadastroEstados.Filtered:= False;
  case rdgTipos.ItemIndex of
    0: tblCadastroEstados.Locate('NOME', edtPesquisa.Text, [loPartialKey]);
    1: tblCadastroEstados.FindKey([edtPesquisa.Text]);
    2: begin
         tblCadastroEstados.Filter  := 'NOME = ' + QuotedStr(edtPesquisa.Text);
         tblCadastroEstados.Filtered:= True;
    end;
  end;

end;

procedure TfrmPrincipal.dgrEstadosTitleClick(Column: TColumn);
begin
  tblCadastroEstados.IndexFieldNames:= Column.FieldName;
end;

end.
