unit fPrinicpal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DBCtrls, Grids, DBGrids, DB, StdCtrls, DBTables,
  Vcl.Buttons, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Comp.Client, FireDAC.Phys.IBBase,
  FireDAC.Phys.FB, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.VCLUI.Wait, FireDAC.Comp.UI;

type
  TfrmPrincipal = class(TForm)
    dgrEstados: TDBGrid;
    dnvEstados: TDBNavigator;
    pnlPesquisa: TPanel;
    rdgTipos: TRadioGroup;
    dtsCadastroEstados: TDataSource;
    edtPesquisa: TEdit;
    btnBuscar: TBitBtn;
    DataBase: TFDConnection;
    FDPhysFBDriverLink: TFDPhysFBDriverLink;
    tblCadastroEstados: TFDTable;
    tblCadastroEstadosID_ESTADO: TIntegerField;
    tblCadastroEstadosNOME: TStringField;
    tblCadastroEstadosSIGLA: TStringField;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
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
