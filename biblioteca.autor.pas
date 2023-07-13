unit biblioteca.autor;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, biblioteca.dm, ZDataset, StrUtils,Generics.Collections, Dialogs;

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
    procedure GravarBanco();
    procedure BuscarPorCodigo(ACodigo:Integer);
    function ListarTodos: TList<TAutor>;
    function ExcluirAutor(Acodigo:Integer):Boolean;
end;
implementation

{ TAutor }

function TAutor.RetornaLinhaComPipe: String;
begin
  Result:= inttostr(FCodigo) + ' - ' + FNome;
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
   if FCodigo=0 then
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

function TAutor.ExcluirAutor(Acodigo:Integer):Boolean;
var
   query:TZquery;
   queryExclusao:TZquery;
begin
   Result:=false;
   query:=TZquery.Create(nil);
   queryExclusao:=TZquery.create(nil);
   query.Connection:=Dm.Conexao;
   queryExclusao.Connection:=Dm.Conexao;
   query.sql.Clear;
   query.SQL.add('select * from livro where codigoAutor=:pcodigoautor');
   query.ParamByName('pcodigoautor').asinteger := Acodigo;
   query.Open;
   if query.EOF then
   begin
      queryExclusao.sql.Clear;
      queryExclusao.SQL.add('delete from autor where codigo=:pcodigo');
      queryExclusao.ParamByName('pcodigo').asInteger := Acodigo;
      queryExclusao.ExecSQL;
      Result:=true
   end;
   query.close;
   queryExclusao.free;
   query.Free;
end;

end.

