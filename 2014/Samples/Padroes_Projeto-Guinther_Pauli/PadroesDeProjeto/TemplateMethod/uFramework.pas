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

unit uFramework;

interface

type
  // Abstract Class
  Correcao = class abstract
    public procedure Corrigir(); virtual; abstract;
    public procedure VerificarPrerequisitos(); virtual; abstract;
    public procedure EnviarDadosParaBancoDeDados(); virtual; abstract;
    public procedure LimparCorrecoesAnteriores(); virtual; abstract;
    public procedure Iniciar(); virtual; abstract;
    // Template Method
    public procedure Processar();
  end;

  CorrecaoProva = class(Correcao)
    public procedure Corrigir(); override;
    public procedure VerificarPrerequisitos(); override;
    public procedure EnviarDadosParaBancoDeDados(); override;
    public procedure LimparCorrecoesAnteriores(); override;
    public procedure Iniciar(); override;
  end;

  CorrecaoRedacao = class(Correcao)
    public procedure Corrigir(); override;
    public procedure VerificarPrerequisitos(); override;
    public procedure EnviarDadosParaBancoDeDados(); override;
    public procedure LimparCorrecoesAnteriores(); override;
    public procedure Iniciar(); override;
  end;

  CorrecaoInscricao = class(Correcao)
    public procedure Corrigir(); override;
    public procedure VerificarPrerequisitos(); override;
    public procedure EnviarDadosParaBancoDeDados(); override;
    public procedure LimparCorrecoesAnteriores(); override;
    public procedure Iniciar(); override;
  end;


implementation

{ Correcao }

procedure Correcao.Processar;
begin
  // orquesta a chama de m�todos virtuais
  Iniciar();
  VerificarPrerequisitos();
  LimparCorrecoesAnteriores();
  Corrigir();
  EnviarDadosParaBancoDeDados();
end;

{ CorrecaoProva }

procedure CorrecaoProva.Corrigir();
begin
  Writeln('Corrigindo prova...');
end;

procedure CorrecaoProva.EnviarDadosParaBancoDeDados();
begin
  Writeln('Enviando dados da prova para o BD...');
end;

procedure CorrecaoProva.Iniciar();
begin
  Writeln('Iniciando processo de corre��o da prova...');
end;

procedure CorrecaoProva.LimparCorrecoesAnteriores();
begin
  Writeln('Limpando dados de corre��es anteriores de provas...');
end;

procedure CorrecaoProva.VerificarPrerequisitos();
begin
  Writeln('Verificando pr�-requisitos para corre��o da prova...');
end;

{ CorrecaoRedacao }

procedure CorrecaoRedacao.Corrigir();
begin
  Writeln('Corrigindo reda��o pela nota...');
end;

procedure CorrecaoRedacao.EnviarDadosParaBancoDeDados();
begin
  Writeln('Enviando dados da reda��o para o BD...');
end;

procedure CorrecaoRedacao.Iniciar();
begin
   Writeln('Iniciando processo de corre��o da reda��o...');
end;

procedure CorrecaoRedacao.LimparCorrecoesAnteriores();
begin
  Writeln('Limpando dados de corre��es anteriores de reda��o...');
end;

procedure CorrecaoRedacao.VerificarPrerequisitos();
begin
  Writeln('Verificando pr�-requisitos para correa��o da reda��o...');
end;

{ CorrecaoInscricao }

procedure CorrecaoInscricao.Corrigir();
begin
  Writeln('Processando inscri��o...');
end;

procedure CorrecaoInscricao.EnviarDadosParaBancoDeDados();
begin
  Writeln('Enviando dados da inscri��o para o BD...');
end;

procedure CorrecaoInscricao.Iniciar();
begin
   Writeln('Iniciando processo de inscri��o...');
end;

procedure CorrecaoInscricao.LimparCorrecoesAnteriores();
begin
  Writeln('Limpando dados de inscri��es anteriores...');
end;

procedure CorrecaoInscricao.VerificarPrerequisitos();
begin
  Writeln('Verificando pr�-requisitos para inscri��o...');
end;

end.
