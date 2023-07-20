unit venda.pessoa;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, biblioteca.dm, StrUtils, ZDataSet, Generics.Collections;

type

  { TPessoa }

  TPessoa=class(TObject)

	private
		FIdade:Integer;
		FNome:String;
    FCodigo:integer;
    FCidade:String;
    public
      property Idade:Integer read FIdade write FIdade;
      property Nome:String read FNome write FNome;
      property Cidade:string read FCidade write FCidade;
      property Codigo:Integer read FCodigo write FCodigo;
      function ListarTodos: TList<TPessoa>;
      procedure GravarBanco();
      function RetornaLinha:String;
      function ExcluirCliente(Acodigo:Integer):Boolean;
      procedure BuscarPorCodigo(ACodigo: Integer);
  end;

implementation

{ TPessoa }

procedure TPessoa.GravarBanco();
var
  query:TZquery;
begin
   query:=TZQuery.Create(nil);
   query.Connection:=Dm.Conexao;
    if FCodigo=0 then
   begin
        query.SQL.Add('insert into cliente values(:pnome, :pidade, default) returning codigo');
   end
   else
   begin
        query.SQL.Add('update cliente set nome=:pnome,idade=:pidade where codigo=:pcodigo returning codigo');
        query.ParamByName('pcodigo').AsInteger := FCodigo;
   end;
   query.ParamByName('pnome').AsString := FNome;
   query.ParamByName('pidade').AsInteger := FIdade;
   query.open;
   if not query.EOF then
   begin
      FCodigo := query.FieldByName('codigo').AsInteger;
   end;
   query.close;
   query.free;
end;

function TPessoa.ListarTodos():TList<TPessoa>;
var
  query:TZquery;
  LCliente:TPessoa;
  LListaCliente:TList<TPessoa>;
begin
   LListaCliente:=TList<TPessoa>.Create;
   query:=Tzquery.Create(nil);
   query.Connection:=Dm.Conexao;
   query.SQL.Add('select * from cliente order by codigo');
   query.open;
   while not query.eof do
   begin
     LCliente := TPessoa.Create;
     LCliente.codigo := query.FieldByName('codigo').asInteger;
     LCliente.nome := query.FieldByName('nome').AsString;
     LCliente.Idade := query.FieldByName('idade').AsInteger;
     LListaCliente.Add(LCliente);
     query.Next;
   end;
   query.Close;
   query.free;
   Result:=LListaCliente;
end;

function TPessoa.RetornaLinha:String;
begin
  Result:= inttostr(FCodigo) + ' - ' + FNome;
end;

function TPessoa.ExcluirCliente(ACodigo:Integer):Boolean;
var
  query:TZQuery;
  queryExclusao:TZquery;
begin
  Result:=false;
  query:=TZQuery.Create(nil);
  query.Connection:=DM.Conexao;
  queryExclusao:=TZQuery.Create(nil);
  queryExclusao.connection:=DM.Conexao;
  //query.SQL.Clear;
  query.SQL.Add('select * from venda where codigoCliente=:pcodigo');
  query.ParamByName('pcodigo').AsInteger := ACodigo;
  query.Open;
  if query.EOF then
  begin
    //queryExclusao.sql.Clear;
      queryExclusao.SQL.add('delete from cliente where codigo=:pcodigo');
      queryExclusao.ParamByName('pcodigo').asInteger := Acodigo;
      queryExclusao.ExecSQL;
      Result:=true
   end;
   query.close;
   queryExclusao.free;
   query.Free;
end;

procedure TPessoa.BuscarPorCodigo(ACodigo: Integer);
var
  query:TZquery;
begin
   query:=Tzquery.Create(nil);
   query.Connection:=Dm.Conexao;
   query.SQL.Add('select * from cliente where codigo=:pcodigo');
   query.ParamByName('pcodigo').asinteger:=Acodigo;
   query.open;
   if  not query.eof then
   begin
     FCodigo := Query.FieldByName('codigo').AsInteger;
     FNome := Query.FieldByName('nome').AsString;
     FIdade:= query.FieldByName('idade').AsInteger;
   end;
   query.Close;
   query.free;
end;


end.

