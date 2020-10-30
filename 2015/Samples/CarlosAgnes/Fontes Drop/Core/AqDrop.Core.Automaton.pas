unit AqDrop.Core.Automaton;

interface

uses
  AqDrop.Core.Collections;

type
  /// ----------------------------------------------------------------------------------------------------------------
  /// <summary>
  ///   EN-US:
  ///     Enum type that defines the states types of an automaton:
  ///       - stInitial: Indicates that the state is the first (initial) state of the automaton;
  ///       - stIntermediate: Indicates that the state is an intermediate state of the automaton;
  ///       - stFinal: Indicates that the state is a final state of the automaton.
  ///   PT-BR
  ///     Tipo enumerado para defini��o dos tipos de estados de um aut�mato:
  ///       - stInitial: Indica que o estado � o primeiro (inicial) estado do aut�mato;
  ///       - stIntermediate: Indica que o estado � um estado intermedi�rio do aut�mato;
  ///       - stFinal: Indica que o estado � um estado final do aut�mato.
  /// </summary>
  /// ----------------------------------------------------------------------------------------------------------------
  TAqAutomatonStateType = (astInitial, astIntermediate, astFinal);

  TAqAutomatonDictionary<TIdentifier, TValue> = class;
  TAqAutomatonTransition<TIdentifier, TValue, TOutput> = class;
  TAqAutomatonState<TIdentifier, TValue, TOutput> = class;
  TAqAutomaton<TIdentifier, TValue, TOutput> = class;


  /// ------------------------------------------------------------------------------------------------------------------
  /// <summary>
  ///   EN-US:
  ///     Objects of this class represents dictionaries accepted by the automaton.
  ///   PT-BR:
  ///     Objetos desta classe representam dicion�rios aceitos pelo aut�mto.
  /// </summary>
  /// ------------------------------------------------------------------------------------------------------------------
  TAqAutomatonDictionary<TIdentifier, TValue> = class
  strict private
    FIdentifier: TIdentifier;
    FValues: TAqList<TValue>;

    function GetValues: TAqReadList<TValue>;
  public
    /// <summary>
    ///   EN-US:
    ///     Class constructor.
    ///   PT-BR:
    ///     Construtor da classe.
    /// </summary>
    /// <param name="pIdentifier">
    ///   EN-US:
    ///     Dictionary identifier.
    ///   PT-BR:
    ///     Identificador do dicion�rio.
    /// </param>
    /// <param name="pValues">
    ///   EN-US:
    ///     Values that will compose the dictionary.
    ///   PT-BR:
    ///     Valores que ir�o compor o dicion�rio.
    /// </param>
    constructor Create(const pIdentifier: TIdentifier; const pValues: array of TValue);
    /// <summary>
    ///   EN-US:
    ///     Class destructor.
    ///   PT-BR:
    ///     Destrutor da classe.
    /// </summary>
    destructor Destroy; override;
    /// <summary>
    ///   EN-US:
    ///     Checks whether a value belongs to the dictionary.
    ///   PT-BR:
    ///     Verifica se um valor pertence ao dicion�rio.
    /// </summary>
    /// <param name="pValor">
    ///   EN-US:
    ///     Value to be tested.
    ///   PT-BR:
    ///     Valor que deve ser testado.
    /// </param>
    /// <returns>
    ///   EN-US:
    ///     Returns True if the value was validated by the dictionary.
    ///   PT-BR:
    ///     Retorna True se o valor for validado pelo dicion�rio.
    /// </returns>
    function Validate(const pValue: TValue): Boolean;
    /// <summary>
    ///   EN-US:
    ///     Dictionary identifier.
    ///   PT-BR:
    ///     Identificador do dicion�rio.
    /// </summary>
    property Identifier: TIdentifier read FIdentifier;
    /// <summary>
    ///   EN-US:
    ///     Values contained by the dictionary.
    ///   PT-BR:
    ///     Valores contidos pelo dicion�rio.
    /// </summary>
    property Values: TAqReadList<TValue> read GetValues;
  end;

  /// ------------------------------------------------------------------------------------------------------------------
  /// <summary>
  ///   EN-US:
  ///     Class to create transitions between the automaton states.
  ///   PT-BR:
  ///     Classe para criar transi��es entre os estados do aut�mato.
  /// </summary>
  /// ------------------------------------------------------------------------------------------------------------------
  TAqAutomatonTransition<TIdentifier, TValue, TOutput> = class
  strict private
    FSource: TAqAutomatonState<TIdentifier, TValue, TOutput>;
    FTarget:  TAqAutomatonState<TIdentifier, TValue, TOutput>;
    FDictionaries: TAqList<TAqAutomatonDictionary<TIdentifier, TValue>>;
  public
    /// <summary>
    ///   EN-US:
    ///     Class constructor.
    ///   PT_BR:
    ///     Construtor da classe.
    /// </summary>
    /// <param name="pSource">
    ///   EN-US:
    ///     Source state of the transition.
    ///   PT-BR:
    ///     Estado de origem da transi��o.
    /// </param>
    /// <param name="pTarget">
    ///   EN-US:
    ///     Target state of the transition.
    ///   PT-BR:
    ///     Estado de destino da transi��o.
    /// </param>
    constructor Create(const pSource:  TAqAutomatonState<TIdentifier, TValue, TOutput>;
      const pTarget:  TAqAutomatonState<TIdentifier, TValue, TOutput>);
    /// <summary>
    ///   EN-US:
    ///     Class destructor.
    ///   PT-BR:
    ///     Destrutor da classe.
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    ///   EN-US:
    ///     Adds a dictionary to the transition.
    ///   PT-BR:
    ///     Adiciona um dicion�rio � transi��o.
    /// </summary>
    /// <param name="pDictionary">
    ///   EN-US:
    ///     Dictionary to be added.
    ///   PT-BR:
    ///     Dicion�rio a ser adicionado.
    /// </param>
    /// <returns>
    ///   EN_US:
    ///     Dictionary index in the transition.
    ///   PT_BR:
    ///     �ndice do dicion�rio na transi��o.
    /// </returns>
    function AddDictionary(const pDictionary: TAqAutomatonDictionary<TIdentifier, TValue>): Int32; overload;

    /// <summary>
    ///   EN-US:
    ///     Adds an automaton predefined dictionary to the transition.
    ///   PT-BR:
    ///     Adiciona um dicion�rio predefinido no aut�mato � transi��o.
    /// </summary>
    /// <param name="pDictionaryID">
    ///   EN-US:
    ///     ID of the predefined dictionary.
    ///   PT-BR:
    ///     Identificador do dicion�rio predefinido.
    /// </param>
    /// <returns>
    ///   EN-US:
    ///     Dictionary ID in transition.
    ///   PT-BR:
    ///     �ndice do dicion�rio na transi��o.
    /// </returns>
    function AddDictionary(const pDictionaryID: TIdentifier): Int32; overload;

    /// <summary>
    ///   EN-US:
    ///     Checks whether the transition supports a value (has a dictionary that contains the value informed).
    ///   PT-BR:
    ///     Verifica se a transi��o suporta um valor informado (possui um dicion�rio que contenha o valor).
    /// </summary>
    /// <param name="pValue">
    ///   EN-US:
    ///     Value to be checked.
    ///   PT-BR:
    ///     Valor a ser testado.
    /// </param>
    /// <returns>
    ///   EN-US:
    ///     Returns True if the transition supports the value.
    ///   PT-BR:
    ///     Retorna True se a transi��o suporta o valor.
    /// </returns>
    function SupportsValue(const pValue: TValue): Boolean;

    /// <summary>
    ///   EN-US:
    ///     Transition target.
    ///   PT-BR:
    ///     Destino da transi��o.
    /// </summary>
    property Target: TAqAutomatonState<TIdentifier, TValue, TOutput> read FTarget;
  end;

  /// ------------------------------------------------------------------------------------------------------------------
  /// <summary>
  ///   EN-US:
  ///     Class to create states to an automaton.
  ///   PT-BR:
  ///     Classe para criar estados para um aut�mato.
  /// </summary>
  /// ------------------------------------------------------------------------------------------------------------------
  TAqAutomatonState<TIdentifier, TValue, TOutput> = class
  strict private
    FAutomaton: TAqAutomaton<TIdentifier, TValue, TOutput>;
    FID: UInt32;
    FStateType: TAqAutomatonStateType;
    FTransitions: TAqList<TAqAutomatonTransition<TIdentifier, TValue, TOutput>>;
    FOutput: TOutput;

    function GetTransitions: TAqReadList<TAqAutomatonTransition<TIdentifier, TValue, TOutput>>;
    function GetIsFinal: Boolean;

    function TryTransition(const pValue: TValue;
      out pState: TAqAutomatonState<TIdentifier, TValue, TOutput>): Boolean;
  public
    /// <summary>
    ///   EN-US:
    ///     Basic constructor.
    ///   PT-BR:
    ///     Construtor b�sico da classe.
    /// </summary>
    /// <param name="pAutomaton">
    ///   EN-US:
    ///     Automaton which the state belongs.
    ///   PT-BR:
    ///     Aut�mato ao qual o estado pertence.
    /// </param>
    /// <param name="pID">
    ///   EN-US:
    ///     State ID (given by the automaton).
    ///   PT-BR:
    ///     ID do estado dentro do aut�mato.
    /// </param>
    constructor Create(const pAutomaton: TAqAutomaton<TIdentifier, TValue, TOutput>; const pID: UInt32); overload;
    /// <summary>
    ///   EN-US:
    ///     Constructor for creating initial and intermediate states.
    ///   PT-BR:
    ///     Construtor para cria��o de estados iniciais ou intermedi�rios.
    /// </summary>
    /// <param name="pAutomaton">
    ///   EN-US:
    ///     Automaton which the state belongs.
    ///   PT-BR:
    ///     Aut�mato ao qual o estado pertence.
    /// </param>
    /// <param name="pID">
    ///   EN-US:
    ///     State ID (given by the automaton).
    ///   PT-BR:
    ///     ID do estado dentro do aut�mato.
    /// </param>
    /// <param name="pStateType">
    ///   EN-US:
    ///     Defines the type of the state to be created.
    ///   PT-BR:
    ///     Determina o tipo de estado que ser� criado.
    /// </param>
    constructor Create(const pAutomaton: TAqAutomaton<TIdentifier, TValue, TOutput>; const pID: UInt32;
      const pStateType: TAqAutomatonStateType); overload;
    /// <summary>
    ///   EN-US:
    ///     Constructor for creating final states.
    ///   PT-BR:
    ///     Construtor para cria��o de estados finais.
    /// </summary>
    /// <param name="pAutomaton">
    ///   EN-US:
    ///     Automaton which the state belongs.
    ///   PT-BR:
    ///     Aut�mato ao qual o estado pertence.
    /// </param>
    /// <param name="pID">
    ///   EN-US:
    ///     State ID (given by the automaton).
    ///   PT-BR:
    ///     ID do estado dentro do aut�mato.
    /// </param>
    /// <param name="pOutput">
    ///   EN-US:
    ///     Defines the output of the final state.
    ///   PT-BR:
    ///     Determina o tipo de sa�da do estado final.
    /// </param>
    constructor Create(const pAutomaton: TAqAutomaton<TIdentifier, TValue, TOutput>; const pID: UInt32;
      const pOutput: TOutput); overload;
    /// <summary>
    ///   EN-US:
    ///     Class destructor.
    ///   PT-BR:
    ///     Destrutor da classe.
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    ///   EN-US:
    ///     Adds a transition to another state as target.
    ///   PT-BR:
    ///     Adiciona uma transi��o para outro estado como destino.
    /// </summary>
    /// <param name="pTarget">
    ///   EN-US:
    ///     Transition target.
    ///   PT-BR:
    ///     Estado de destino da transi��o.
    /// </param>
    /// <returns>
    ///   EN-US:
    ///     Returns the object created to represent the transition.
    ///   PT-BR:
    ///     Retorna o objeto criado para representar a transa��o.
    /// </returns>
    function AddTransition(const pTarget: TAqAutomatonState<TIdentifier, TValue, TOutput>)
      : TAqAutomatonTransition<TIdentifier, TValue, TOutput>; overload;

    /// <summary>
    ///   EN-US:
    ///     Try to execute the transition corresponding to the value informed.
    ///   PT-BR:
    ///     Tenta executar a transa��o correspondente ao valor informado.
    /// </summary>
    /// <param name="pValue">
    ///   EN-US:
    ///     Value that should be used on transition.
    ///   PT-BR:
    ///     Valor que deve ser usado na transic�o.
    /// </param>
    /// <param name="pState">
    ///   EN-US:
    ///     State reached in case of a sucessful transition.
    ///   PT-BR:
    ///     Estado alcan�ado no caso de sucesso na transi��o.
    /// </param>
    /// <returns>
    ///   EN-US:
    ///     Returns True if the state supports a transition with the value informed.
    ///   PT-BR:
    ///     Retorna True se o estado suportar uma transi��o com o valor informado.
    /// </returns>
    function Transition(const pValue: TValue;
      out pState: TAqAutomatonState<TIdentifier, TValue, TOutput>): Boolean;

    /// <summary>
    ///   EN-US:
    ///     Automaton of the state.
    ///   PT-BR:
    ///     Aut�mato do estado.
    /// </summary>
    property Automaton: TAqAutomaton<TIdentifier, TValue, TOutput> read FAutomaton;
    /// <summary>
    ///   EN-US:
    ///     State output (in case of a final state).
    ///   PT-BR:
    ///     Sa�da do estado (no caso de um estado final).
    /// </summary>
    property Output: TOutput read FOutput;
    /// <summary>
    ///   EN-US:
    ///     State ID in the automaton.
    ///   PT-BR:
    ///     ID do estado dentro do aut�mato.
    /// </summary>
    property ID: UInt32 read FID;
    /// <summary>
    ///   EN-US:
    ///     State transitions.
    ///   PT-BR:
    ///     Transi��es do estado.
    /// </summary>
    property Transitions: TAqReadList<TAqAutomatonTransition<TIdentifier, TValue, TOutput>> read GetTransitions;
    /// <summary>
    ///   EN-US:
    ///     Identifies if the state is final or not.
    ///   PT-BR:
    ///     Identifica se o estado � final ou n�o.
    /// </summary>
    property IsFinal: Boolean read GetIsFinal;
  end;

  /// ------------------------------------------------------------------------------------------------------------------
  /// <summary>
  ///   EN-US:
  ///     Class for creating automatons.
  ///   PT-BR:
  ///     Classe para cria��o de aut�mato de estados.
  /// </summary>
  /// ------------------------------------------------------------------------------------------------------------------
  TAqAutomaton<TIdentifier, TValue, TOutput> = class
  strict private
    FStates: TAqList<TAqAutomatonState<TIdentifier, TValue, TOutput>>;
    FDictionaries: TAqDictionary<TIdentifier, TAqAutomatonDictionary<TIdentifier, TValue>>;

    function GetInitialState: TAqAutomatonState<TIdentifier, TValue, TOutput>;
  strict protected
    function GetDefaultValue: TValue; virtual; abstract;
  public
    /// <summary>
    ///   EN-US:
    ///     Class constructor.
    ///   PT-BR:
    ///     Construtor da classe.
    /// </summary>
    constructor Create;
    /// <summary>
    ///   EN-US:
    ///     Class destructor.
    ///   PT-BR:
    ///     Destrutor da classe.
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    ///   EN-US:
    ///     Allows to add a dictionary to the automaton.
    ///   PT-BR:
    ///     Permite adicionar um dicion�rio para o aut�mato.
    /// </summary>
    /// <param name="pDictionaryID">
    ///   EN-US:
    ///     Dictionary ID.
    ///   PT-BR:
    ///     Identificador do dicion�rio.
    /// </param>
    /// <param name="pValues">
    ///   EN-US:
    ///     Values contained by the dictionary.
    ///   PT-BR:
    ///     Valores contidos no dicion�rio.
    /// </param>
    /// <returns>
    ///   EN-US:
    ///     Returns the dictionary added to the automaton.
    ///   PT-BR:
    ///     Retorna o dicion�rio adicionado ao aut�mato.
    /// </returns>
    function AddDictionary(const pDictionaryID: TIdentifier;
      const pValues: array of TValue): TAqAutomatonDictionary<TIdentifier, TValue>;

    /// <summary>
    ///   EN-US:
    ///     Adds an intermediate state to the automaton.
    ///   PT-BR:
    ///     Adiciona um estado intermedi�rio ao aut�mato.
    /// </summary>
    /// <returns>
    ///   EN-US:
    ///     Returns the new state.
    ///   PT-BR:
    ///     Retorna o novo estado.
    /// </returns>
    function AddIntermediateState: TAqAutomatonState<TIdentifier, TValue, TOutput>;
    /// <summary>
    ///   EN-US:
    ///     Adds a final state to the automaton.
    ///   PT-BR:
    ///     Adiciona um estado final ao Aut�mato.
    /// </summary>
    /// <param name="pOutput">
    ///   EN-US:
    ///     Output type represented by the state to be created.
    ///   PT-BR:
    ///     Tipo de sa�da representado pelo estado a ser criado.
    /// </param>
    /// <returns>
    ///   EN-US:
    ///     Returns the new state.
    ///   PT-BR:
    ///     Retorna o novo estado.
    /// </returns>
    function AddFinalState(const pOutput: TOutput): TAqAutomatonState<TIdentifier, TValue, TOutput>;

    /// <summary>
    ///   EN-US:
    ///     Checks whether exists a dictionary with the informed ID.
    ///   PT-BR:
    ///     Verifica se existe um dicion�rio com o identificador informado.
    /// </summary>
    /// <param name="pDictionaryID">
    ///   EN-US:
    ///     ID of the dictionary to be found.
    ///   PT-BR:
    ///     Identificador do dicion�rio a ser localizado.
    /// </param>
    /// <param name="pDictionary">
    ///   EN-US:
    ///     If found, the dictionary will be returned in pDictionary.
    ///   PT-BR:
    ///     Se encontrado, o dicion�rio ser� retornado em pDictionary.
    /// </param>
    /// <returns>
    ///   EN-US:
    ///     Returns True if a dictionary with that ID was found.
    ///   PT-BR:
    ///     Retorna True se um dicion�rio com o referido ID foi encontrado.
    /// </returns>
    function GetDictionary(const pDictionaryID: TIdentifier;
      out pDictionary: TAqAutomatonDictionary<TIdentifier, TValue>): Boolean; overload;
    /// <summary>
    ///   EN-US:
    ///     Try to retrive a dictionary with the informed ID.
    ///   PT-BR:
    ///     Tenta devolver um dicion�rio com o identificador informado.
    /// </summary>
    /// <param name="pDictionaryID">
    ///   EN-US:
    ///     ID of the dictionary to be found.
    ///   PT-BR:
    ///     Identificador do dicion�rio a ser localizado.
    /// </param>
    /// <returns>
    ///   EN-US:
    ///     If found, returns the dictionary referred by pDictionaryID. Otherwise, an exception will be raised.
    ///   PT-BR:
    ///     Se encontrado, retorna o dicion�rio referido por pDictionaryID. Caso contr�rio, uma exce��o ser� levantada.
    /// </returns>
    function GetDictionary(const pDictionaryID: TIdentifier): TAqAutomatonDictionary<TIdentifier, TValue>; overload;

    /// <summary>
    ///   EN-US:
    ///     Default value of the automaton.
    ///   PT_BR:
    ///     Valor default (OUTRO) do aut�mato.
    ///</summary>
    property DefaultValue: TValue read GetDefaultValue;

    /// <summary>
    ///   EN-US:
    ///     Initial state of the automaton.
    ///   PT_BR:
    ///     Estado inicial do aut�mato.
    ///</summary>
    property InitialState: TAqAutomatonState<TIdentifier, TValue, TOutput> read GetInitialState;
  end;

resourcestring
  StrThisStateAlreadyHasAConnectionToTheInformedTarget = 'This state already has a connection to the informed target.';
  StrThisDictionaryWasAlreadyIncludedInThisTransition = 'This dictionary was already included in this transition.';
  StrTheInclusionOfThisDictionaryWouldCauseTheAutomatonToBecomeNondeterministic =
    'The inclusion of this dictionary would cause the automaton to become nondeterministic.';
  StrInvalidValueToCreateADictionary = 'Invalid value to create a dictionary.';
  StrIDAlreadyUsedInAnotherDictionary = 'ID already used in another dictionary.';
  StrDictionaryNotFound = 'Dictionary not found.';

implementation

uses
  System.Generics.Defaults,
  AqDrop.Core.Exceptions;

{ TAqAutomatonState<TIdentifier, TValue, TOutput> }

function TAqAutomatonState<TIdentifier, TValue, TOutput>.AddTransition(
  const pTarget: TAqAutomatonState<TIdentifier, TValue, TOutput>)
  : TAqAutomatonTransition<TIdentifier, TValue, TOutput>;
var
  lTransition: TAqAutomatonTransition<TIdentifier, TValue, TOutput>;
begin
  for lTransition in FTransitions do
  begin
    if lTransition.Target = pTarget then
    begin
      raise EAqInternal.Create(StrThisStateAlreadyHasAConnectionToTheInformedTarget);
    end;
  end;

  Result := FTransitions[
    FTransitions.Add(TAqAutomatonTransition<TIdentifier, TValue, TOutput>.Create(Self, pTarget))];
end;

constructor TAqAutomatonState<TIdentifier, TValue, TOutput>.Create
  (const pAutomaton: TAqAutomaton<TIdentifier, TValue, TOutput>; const pID: UInt32;
  const pStateType: TAqAutomatonStateType);
begin
  Create(pAutomaton, pID);

  FStateType := pStateType;
  FOutput := Default(TOutput);
end;

constructor TAqAutomatonState<TIdentifier, TValue, TOutput>.Create
  (const pAutomaton: TAqAutomaton<TIdentifier, TValue, TOutput>;
  const pID: UInt32);
begin
  FTransitions := TAqList<TAqAutomatonTransition<TIdentifier, TValue, TOutput>>.Create(True);
  FAutomaton := pAutomaton;
  FID := pID;
end;

constructor TAqAutomatonState<TIdentifier, TValue, TOutput>.Create(
  const pAutomaton: TAqAutomaton<TIdentifier, TValue, TOutput>; const pID: UInt32; const pOutput: TOutput);
begin
  Create(pAutomaton, pID);

  FStateType := TAqAutomatonStateType.astFinal;
  FOutput := pOutput;
end;

destructor TAqAutomatonState<TIdentifier, TValue, TOutput>.Destroy;
begin
  FTransitions.Free;

  inherited;
end;

function TAqAutomatonState<TIdentifier, TValue, TOutput>.GetIsFinal: Boolean;
begin
  Result := FStateType = TAqAutomatonStateType.astFinal;
end;

function TAqAutomatonState<TIdentifier, TValue, TOutput>.GetTransitions:
  TAqReadList<TAqAutomatonTransition<TIdentifier, TValue, TOutput>>;
begin
  Result := FTransitions.GetTReadList;
end;

function TAqAutomatonState<TIdentifier, TValue, TOutput>.TryTransition(const pValue: TValue;
  out pState: TAqAutomatonState<TIdentifier, TValue, TOutput>): Boolean;
var
  lI: Int32;
begin
  lI := FTransitions.Count - 1;

  while (lI >= 0) and not FTransitions[lI].SupportsValue(pValue) do
  begin
    Dec(lI);
  end;

  Result := lI >= 0;

  if Result then
  begin
    pState := FTransitions[lI].Target;
  end;
end;

function TAqAutomatonState<TIdentifier, TValue, TOutput>.Transition(const pValue: TValue;
  out pState: TAqAutomatonState<TIdentifier, TValue, TOutput>): Boolean;
begin
  Result := TryTransition(pValue, pState) or TryTransition(FAutomaton.DefaultValue, pState);
end;

{ TAqAutomatonTransition<TIdentifier, TValue, TOutput> }

function TAqAutomatonTransition<TIdentifier, TValue, TOutput>.AddDictionary
  (const pDictionary: TAqAutomatonDictionary<TIdentifier, TValue>): Int32;
var
  lI: Int32;
  lIValue: Int32;
begin
  for lI := 0 to FDictionaries.Count - 1 do
  begin
    if FDictionaries[lI] = pDictionary then
    begin
      raise EAqInternal.Create(StrThisDictionaryWasAlreadyIncludedInThisTransition);
    end;
  end;

  for lI := 0 to FSource.Transitions.Count - 1 do
  begin
    if FSource.Transitions[lI] <> Self then
    begin
      for lIValue := 0 to pDictionary.Values.Count - 1 do
      begin
        if FSource.Transitions[lI].SupportsValue(pDictionary.Values[lIValue]) then
        begin
          raise EAqInternal.Create
            (StrTheInclusionOfThisDictionaryWouldCauseTheAutomatonToBecomeNondeterministic);
        end;
      end;
    end;
  end;

  Result := FDictionaries.Add(pDictionary);
end;

function TAqAutomatonTransition<TIdentifier, TValue, TOutput>.AddDictionary
  (const pDictionaryID: TIdentifier): Int32;
begin
  Result := AddDictionary(FSource.Automaton.GetDictionary(pDictionaryID));
end;

constructor TAqAutomatonTransition<TIdentifier, TValue, TOutput>.Create(
  const pSource, pTarget: TAqAutomatonState<TIdentifier, TValue, TOutput>);
begin
  FDictionaries := TAqList<TAqAutomatonDictionary<TIdentifier, TValue>>.Create;
  FSource := pSource;
  FTarget := pTarget;
end;

destructor TAqAutomatonTransition<TIdentifier, TValue, TOutput>.Destroy;
begin
  FDictionaries.Free;

  inherited;
end;

function TAqAutomatonTransition<TIdentifier, TValue, TOutput>.SupportsValue(const pValue: TValue): Boolean;
var
  lI: Int32;
begin
  lI := FDictionaries.Count - 1;

  while (lI >= 0) and not FDictionaries[lI].Validate(pValue) do
  begin
    Dec(lI);
  end;

  Result := lI >= 0;
end;

{ TAqAutomatonDictionary<TIdentifier, TValue> }

constructor TAqAutomatonDictionary<TIdentifier, TValue>.Create(const pIdentifier: TIdentifier;
  const pValues: array of TValue);
var
  lValue: TValue;
begin
  FIdentifier := pIdentifier;
  FValues := TAqList<TValue>.Create;

  for lValue in pValues do
  begin
    if Validate(lValue) then
    begin
      raise EAqInternal.Create(StrInvalidValueToCreateADictionary);
    end;
    FValues.Add(lValue);
  end;
end;

destructor TAqAutomatonDictionary<TIdentifier, TValue>.Destroy;
begin
  FValues.Free;

  inherited;
end;

function TAqAutomatonDictionary<TIdentifier, TValue>.GetValues: TAqReadList<TValue>;
begin
  Result := FValues.GetTReadList;
end;

function TAqAutomatonDictionary<TIdentifier, TValue>.Validate(const pValue: TValue): Boolean;
var
  lI: Int32;
begin
  lI := FValues.Count - 1;

  while (lI >= 0) and (FValues.IndexOf(pValue) < 0) do
  begin
    Dec(lI);
  end;

  Result := lI >= 0;
end;

{ TAqAutomaton<TIdentifier, TValue, TOutput> }

function TAqAutomaton<TIdentifier, TValue, TOutput>.AddDictionary(const pDictionaryID: TIdentifier;
  const pValues: array of TValue): TAqAutomatonDictionary<TIdentifier, TValue>;
begin
  if FDictionaries.ContainsKey(pDictionaryID) then
  begin
    raise EAqInternal.Create(StrIDAlreadyUsedInAnotherDictionary);
  end;

  Result := TAqAutomatonDictionary<TIdentifier, TValue>.Create(pDictionaryID, pValues);

  try
    FDictionaries.Add(pDictionaryID, Result);
  except
    Result.Free;
    raise;
  end;
end;

function TAqAutomaton<TIdentifier, TValue, TOutput>.AddFinalState(const pOutput: TOutput)
  : TAqAutomatonState<TIdentifier, TValue, TOutput>;
begin
  Result := TAqAutomatonState<TIdentifier, TValue, TOutput>.Create(Self, FStates.Count, pOutput);

  try
    FStates.Add(Result);
  except
    Result.Free;
    raise;
  end;
end;

function TAqAutomaton<TIdentifier, TValue, TOutput>.AddIntermediateState
  : TAqAutomatonState<TIdentifier, TValue, TOutput>;
begin
  Result := TAqAutomatonState<TIdentifier, TValue, TOutput>.Create(Self, FStates.Count,
    TAqAutomatonStateType.astIntermediate);

  try
    FStates.Add(Result);
  except
    Result.Free;
    raise;
  end;
end;

constructor TAqAutomaton<TIdentifier, TValue, TOutput>.Create;
begin
  FDictionaries :=
    TAqDictionary<TIdentifier, TAqAutomatonDictionary<TIdentifier, TValue>>.Create([TAqDictionaryContent.adcValue]);
  FStates := TAqList<TAqAutomatonState<TIdentifier, TValue, TOutput>>.Create(True);
  FStates.Add(TAqAutomatonState<TIdentifier, TValue, TOutput>.Create(Self, 0, TAqAutomatonStateType.astInitial))
end;

destructor TAqAutomaton<TIdentifier, TValue, TOutput>.Destroy;
begin
  FStates.Free;
  FDictionaries.Free;

  inherited;
end;

function TAqAutomaton<TIdentifier, TValue, TOutput>.GetDictionary(const pDictionaryID: TIdentifier;
  out pDictionary: TAqAutomatonDictionary<TIdentifier, TValue>): Boolean;
begin
  Result := FDictionaries.TryGetValue(pDictionaryID, pDictionary);
end;

function TAqAutomaton<TIdentifier, TValue, TOutput>.GetDictionary(const pDictionaryID: TIdentifier)
  : TAqAutomatonDictionary<TIdentifier, TValue>;
begin
  if not FDictionaries.TryGetValue(pDictionaryID, Result) then
  begin
    raise EAqInternal.Create(StrDictionaryNotFound);
  end;
end;

function TAqAutomaton<TIdentifier, TValue, TOutput>.GetInitialState: TAqAutomatonState<TIdentifier, TValue, TOutput>;
begin
  Result := FStates.First;
end;

end.

