unit biblioteca.autor;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, biblioteca.dm, ZDataset, StrUtils,Generics.Collections;

type

  { TAutor }

  TAutor=Class(TObject)
  private
    FNome:String;
    FIdade:integer;
    FCidade:String;
    FCodigo:integer;

  public
    property Nome:String read FNome write FNome;
    property Idade:integer read FIdade write FIdade;
    property Cidade:String read FCidade write FCidade;
    property Codigo:integer read FCodigo write FCodigo;
    function RetornaLinhaComPipe:String;
    procedure PreencheCamposPorLinha(ALinha:String);
    procedure GerarCodigo;
    procedure GravarBanco();
    procedure BuscarPorCodigo(ACodigo:Integer);
    function ListarTodos: TList<TAutor>;
end;
implementation

{ TAutor }

function TAutor.RetornaLinhaComPipe: String;
begin
  Result:= inttostr(FCodigo) + '|' + FNome + '|' + inttostr(Fidade) + '|' + FCidade;
end;

procedure TAutor.PreencheCamposPorLinha(ALinha: String);
var
  vetor:TStringArray;
begin
  vetor:= SplitString(ALinha,'|');
  FCodigo:= strtoint(vetor[0]);
  FNome:= vetor[1];
  Fidade:= strtoint(vetor[2]);
  Fcidade:= vetor[3];
end;
procedure TAutor.GerarCodigo;
begin
{var
  contador:TextFile;
  LCodigoAtual:Integer;
  linhaArquivo:String;
begin
  if not FileExists('contador_autores.txt') then
  begin
       AssignFIle(contador, 'contador_autores.txt');
       rewrite(contador);
       writeln(contador, '0');
       closefile(contador);
  end;

  if fileexists('contador_autores.txt') then
  begin
       AssignFile(contador, 'contador_autores.txt');
       reset(contador);
       readln(contador, linhaArquivo);
       LCodigoAtual:=strtoint(linhaArquivo)+1;
       FCodigo := LCodigoAtual;
       rewrite(contador);
       writeln(contador, FCodigo);
       closefile(contador);
  end;
  }
end;
function TAutor.ListarTodos():TList<TAutor>;
var
  query:TZquery;
  LAutor:TAutor;
  LListaAutores:TList<TAutor>;
begin
   LListaAutores:=TList<TAutor>.Create;
   query:=Tzquery.Create(nil);
   query.Connection:=Dm.Conexao;
   query.SQL.Add('select * from autor order by codigo');
   query.open;
   while not query.eof do
   begin
     LAutor:=TAutor.Create;
     Lautor.Codigo := Query.FieldByName('codigo').AsInteger;
     Lautor.Nome := Query.FieldByName('nome').AsString;
     Lautor.Cidade := query.FieldByName('cidade').asString;
     Lautor.Idade := query.FieldByName('idade').AsInteger;
     LListaAutores.Add(lautor);
     query.Next;
   end;
   query.Close;
   query.free;

   Result:=LListaAutores;
end;
procedure TAutor.GravarBanco();
var
  query:TZquery;
begin
   query:=Tzquery.Create(nil);
   query.Connection:=DM.Conexao;

   if FCOdigo=0 then
   begin
        query.SQL.Add('insert into autor values(default,:pnome, :pidade, :pcidade) returning codigo');
   end
   else
   begin
        query.SQL.Add('update autor set nome=:pnome,idade=:pidade, cidade=:pcidade where codigo=:pcodigo returning codigo');
        query.ParamByName('pcodigo').AsInteger := FCodigo;
   end;

   query.ParamByName('pnome').AsString := FNome;
   query.ParamByName('pidade').AsInteger := FIdade;
   query.ParamByName('pcidade').AsString := FCidade;

   query.open;
   if not query.EOF then
   begin
      FCodigo := query.FieldByName('codigo').AsInteger;
   end;
   query.close;

   query.free;
end;

procedure TAutor.BuscarPorCodigo(ACodigo: Integer);
var
  query:TZquery;
begin
   query:=Tzquery.Create(nil);
   query.Connection:=Dm.Conexao;
   query.SQL.Add('select * from autor where codigo=:pcodigo');
   query.ParamByName('pcodigo').asinteger:=Acodigo;
   query.open;
   if  not query.eof then
   begin
     FCodigo := Query.FieldByName('codigo').AsInteger;
     FNome := Query.FieldByName('nome').AsString;
     FIdade:= query.FieldByName('idade').AsInteger;
     FCidade:=query.FieldByName('cidade').asString;
   end;
   query.Close;
   query.free;
end;

end.

