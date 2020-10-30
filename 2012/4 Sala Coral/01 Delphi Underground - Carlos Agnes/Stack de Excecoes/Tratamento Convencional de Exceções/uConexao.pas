unit uConexao;

interface

type
  TConexao = class
  public
    class procedure Conectar;
    class function ExecutarSQL(const pInstrucao: string): Integer;
  end;

implementation

uses
  System.SysUtils;

{ TConexao }

class procedure TConexao.Conectar;
begin
  // Comandos para conectar com o SGBD desejado;
  raise Exception.Create('N�o foi poss�vel estabelecer conex�o com o banco de dados.');
end;

class function TConexao.ExecutarSQL(const pInstrucao: string): Integer;
begin
  try
    Conectar;

    // Comandos para a execu��o da instru��o
    // Result := ComponenteDeQuery.Execute;

    Result := 1;
  except
    raise Exception.Create('N�o foi poss�vel executar a instru��o SQL.');
  end;
end;

end.
