program Facade;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  uFramework in 'uFramework.pas';

var
  email: TEmailHelper;
begin
  email := TEmailHelper.Create();
  email.Enviar('Ol� Mundo');
  Readln;
end.

