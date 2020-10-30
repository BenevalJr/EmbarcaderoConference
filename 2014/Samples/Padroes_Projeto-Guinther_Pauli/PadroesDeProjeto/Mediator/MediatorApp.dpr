{
Sobre o autor:
Guinther Pauli
Delphi Certified Professional - 3,5,6,7,2005,2006,Delphi Web,Kylix,XE
Microsoft Certified Professional - MCP,MCAD,MCSD.NET,MCTS,MCPD (C#, ASP.NET, Arquitetura)
Colaborador Editorial Revistas .net Magazine e ClubeDelphi
MVP (Most Valuable Professional) - Embarcadero Technologies - US
http://gpauli.com
http://www.facebook.com/guintherpauli
http://www.twitter.com/guintherpauli
http://br.linkedin.com/in/guintherpauli
}

program MediatorApp;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  uFramework in 'uFramework.pas';

var
  // Mediador
  mediator: ConcreteMediator;
  // Colegas
  sup: Suporte;
  user: Usuario;
begin
  // Cria mediador
  mediator := ConcreteMediator.Create();
  // Cria colega (suporte) e configura quem ser� o mediador
  sup := Suporte.Create(mediator);
  // Cria colega (usu�rio) e configura quem ser� o mediador
  user := Usuario.Create(mediator);
  // Informa ao mediador quem ser�o as partes envolvidas
  mediator.Suporte := sup;
  mediator.Usuario := user;
  // Faz a comunica��o entre as partes usando mediador
  user.Enviar('Meu Windows n�o est� iniciando');
  sup.Enviar('Formate a m�quina');
  ReadLn;
end.
