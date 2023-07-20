unit biblioteca.livro;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, biblioteca.dm, biblioteca.autor, ZDataset, StrUtils,
  Generics.Collections;

type

  { TLivro }

  TLivro=Class(TObject)
  private
    FCodigo: integer;
    FNome:String;
    FAno:integer;
    FAutor:TAutor;
  public
    property codigo:integer read FCodigo write FCodigo;
    property nome:String read FNome write FNome;
    property ano:integer read FAno write FAno;
    property Autor:TAutor read FAutor write FAutor;
    function RetornaLinhaComPipe:String;
    procedure GravarBanco();
    procedure BuscarPorCodigo(ACodigo:Integer);
    function ListarTodos: TList<TLivro>;
    function ExcluirLivro(Acodigo:Integer):Boolean;
    constructor Create;
    destructor Destroy;override;
  end;

implementation

{TformLivro}

function TLivro.RetornaLinhaComPipe: String;
begin
  Result:= inttostr(FCodigo) + ' - ' + FNome;
end;

function TLivro.ListarTodos():TList<TLivro>;
var
  query:TZquery;
  LLivro:TLivro;
  LListaLivros:TList<TLivro>;
begin
   LListaLivros:=TList<TLivro>.Create;
   query:=Tzquery.Create(nil);
   query.Connection:=Dm.Conexao;
   query.SQL.Add('select * from livro order by codigo');
   query.open;
   while not query.eof do
   begin
     LLivro:=TLivro.Create;
     LLivro.codigo := query.FieldByName('codigo').asInteger;
     LLivro.nome:=query.FieldByName('nome').AsString;
     LLivro.Ano:=query.FieldByName('ano').AsInteger;
     LLivro.Autor.BuscarPorCodigo(query.FieldByName('codigoautor').AsInteger);;
     LListaLivros.Add(LLivro);
     query.Next;
   end;
   query.Close;
   query.free;
   Result:=LListaLivros;
end;

constructor TLivro.Create;
begin
  FAutor:=TAutor.Create;
end;

destructor TLivro.Destroy;
begin
   FAutor.free;
  inherited Destroy;
end;

procedure TLivro.GravarBanco();
var
  query:TZquery;
begin
   query:=Tzquery.Create(nil);
   query.Connection:=DM.Conexao;
   if FCodigo=0 then
   begin
     query.SQL.Add('insert into livro(codigo,nome,ano,codigoautor) values(default,:pnome, :ano, :codigoAutor) returning codigo');
     query.ParamByName('pnome').AsString := FNome;
     query.ParamByName('ano').AsInteger := FAno;
     query.ParamByName('codigoAutor').AsInteger := FAutor.Codigo;
     query.open;
     if not query.EOF then
     begin
        FCodigo := query.FieldByName('codigo').AsInteger;
     end;
     query.close;
   end
   else
   begin
     query.SQL.Add('update livro set nome=:pnome, ano=:pano, codigoautor=:pcodigoautor where codigo=:pcodigo');
     query.ParamByName('pnome').AsString := FNome;
     query.ParamByName('pano').asInteger:= FAno;
     query.ParamByName('pcodigoAutor').AsInteger:= FAutor.Codigo;
     query.ParamByName('pcodigo').AsInteger := FCodigo;
     query.ExecSQL;
   end;
   query.free;
end;

function TLivro.ExcluirLivro(Acodigo:Integer):Boolean;
var
  query:TZQuery;
begin
    query:=TZQuery.Create(nil);
    query.Connection:=DM.Conexao;
    query.SQL.Clear;
    query.sql.Add('delete from livro where codigo=:pcodigo');
    query.ParamByName('pcodigo').AsInteger:=Acodigo;
    query.execSQL;
    query.close;
    query.free;
    Result:=true;
end;

procedure TLivro.BuscarPorCodigo(ACodigo: Integer);
var
  query:TZquery;
begin
   query:=Tzquery.Create(nil);
   query.Connection:=Dm.Conexao;
   query.SQL.Add('select * from livro where codigo=:pcodigo');
   query.ParamByName('pcodigo').asinteger:=Acodigo;
   query.open;
   if  not query.eof then
   begin
     FCodigo:=query.FieldByName('codigo').asInteger;
     FNome:=Query.FieldByName('nome').AsString;
     FAno:=Query.FieldByName('ano').AsInteger;
     fAutor.BuscarPorCodigo(query.FieldByName('codigoAutor').asinteger);
   end;
   query.Close;
   query.free;
end;
end.
