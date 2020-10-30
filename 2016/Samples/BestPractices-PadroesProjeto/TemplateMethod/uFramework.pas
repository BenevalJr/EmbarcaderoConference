unit uFramework;

interface

type
  // Abstract Class
  TCorrecao = class abstract
    procedure Iniciar(); virtual; abstract;
    procedure Corrigir(); virtual; abstract;
    procedure Finalizar(); virtual; abstract;
    procedure Processar();
  end;

  // Concrete Class
  TCorrecaoProva = class(TCorrecao)
    procedure Iniciar(); override;
    procedure Corrigir(); override;
    procedure Finalizar(); override;
  end;

  // Concrete Class
  TCorrecaoRedacao = class(TCorrecao)
    procedure Iniciar(); override;
    procedure Corrigir(); override;
    procedure Finalizar(); override;
  end;

implementation

{ TCorrecao }

procedure TCorrecao.Processar();
begin
  // chamo m�todos virtuais de mim mesmo
  // sobrescritos nas subclasses
  Iniciar();
  // aqui posso colocar um passo adicional
  // como um factory method
  Corrigir();
  Finalizar();
end;

{ TCorrecaoProva }

procedure TCorrecaoProva.Corrigir();
begin
  WriteLn('Corrigindo Prova');
end;

procedure TCorrecaoProva.Finalizar();
begin
  WriteLn('Finalizando corre��o da Prova');
end;

procedure TCorrecaoProva.Iniciar();
begin
   WriteLn('Iniciando corre��o da Prova');
end;

{ TCorrecaoRedacao }

procedure TCorrecaoRedacao.Corrigir();
begin
  WriteLn('Corrigindo Reda��o');
end;

procedure TCorrecaoRedacao.Finalizar();
begin
  WriteLn('Finalizando corre��o da Reda��o');
end;

procedure TCorrecaoRedacao.Iniciar();
begin
  WriteLn('Iniciando corre��o da Reda��o');
end;

end.
