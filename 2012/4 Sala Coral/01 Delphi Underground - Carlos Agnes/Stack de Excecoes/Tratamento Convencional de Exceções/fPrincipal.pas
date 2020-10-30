unit fPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Rtti, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs;

type
  TfrmPrincipal = class(TForm)
    btnTratamentoConvenvionalExcecoes: TButton;
    procedure btnTratamentoConvenvionalExcecoesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.fmx}

uses uCliente;

procedure TfrmPrincipal.btnTratamentoConvenvionalExcecoesClick(Sender: TObject);
var
  lCliente: TClientePF;
begin
  lCliente := TClientePF.Create;

  try
    lCliente.Nome := 'Jo�o da Silva';
    lCliente.Endereco := 'Centro de Conven��es Rebou�as';
    lCliente.CPF := 11122233385;

    lCliente.Salvar;
  finally
    lCliente.Free;
  end;
end;

end.
