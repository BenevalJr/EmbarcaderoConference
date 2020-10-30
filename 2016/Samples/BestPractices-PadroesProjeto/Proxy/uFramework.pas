unit uFramework;

interface

type
  // Subject (classe base para conex�es DataSnap)
  TCustomRemoteServer = class abstract
    procedure Connect(); virtual; abstract;
  end;

  // Real Subject
  TSOAPConnection = class(TCustomRemoteServer)
    procedure Connect(); override;
  end;

  // Real Subject
  TSocketConnection = class(TCustomRemoteServer)
    procedure Connect(); override;
  end;

  // Proxy
  TConnectionBroker = class(TCustomRemoteServer)
  strict private
    FRemoteServer: TCustomRemoteServer;
  public
    procedure Connect(); override;
    constructor Create(AServer: TCustomRemoteServer);
  end;

  TClientDataSet = class
    RemoteServer: TCustomRemoteServer;
  end;

implementation

{ TSOAPConnection }

procedure TSOAPConnection.Connect();
begin
  Writeln('Conectado no servidor SOAP');
end;

{ TConnectionBroker }

procedure TConnectionBroker.Connect();
begin
  // delega��o polim�rfica
  self.FRemoteServer.Connect();
end;

constructor TConnectionBroker.Create(
    AServer: TCustomRemoteServer);
begin
  Self.FRemoteServer := AServer;
end;

{ TSocketConnection }

procedure TSocketConnection.Connect();
begin
  Writeln('Conectado no servidor Socket');
end;

end.
