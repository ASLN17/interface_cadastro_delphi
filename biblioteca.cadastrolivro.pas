unit biblioteca.cadastroLivro;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids,
  DBCtrls, ExtCtrls, biblioteca.livro, biblioteca.autor, biblioteca.dm,
  StrUtils, DB, ZDataset, generics.Collections;

type

  { TFormLivro }

  TFormLivro = class(TForm)
    Autor: TLabel;
    btnSalvarLivro: TButton;
    labelNome: TLabel;
    labelLivrosCadastrados: TLabel;
    listBoxLivros: TListBox;
    textAno: TEdit;
    labelAno: TLabel;
    textCodigoAutor: TEdit;
    textCodigoLivro: TEdit;
    textNomeAutor: TEdit;
    textLivro: TEdit;
    procedure btnSalvarLivroClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure listBoxLivrosDblClick(Sender: TObject);
    procedure textCodigoAutorChange(Sender: TObject);
  private
     procedure limparTelaLivro;
  public

  end;

var
  formLivro: TformLivro;

implementation

{$R *.lfm}

procedure TFormLivro.btnSalvarLivroClick(Sender: TObject);
var
  LLivro:Tlivro;
  arqLivro:TextFile;
  i:integer;
begin
     if textNomeAutor.Text='' then
     begin
        ShowMessage('Selecione um autor');
        exit;
     end;
     if length(textAno.Text) <> 4 then
     begin
        ShowMessage('Ano inválido');
        exit;
     end;
     //
     LLivro:=Tlivro.Create;
     LLivro.Nome:=textLivro.text;
     LLivro.Ano:= strtoint(textAno.text);
     LLivro.autor.Codigo := strtoint(textCodigoAutor.text);

     if(textCodigoLivro.text='') then LLivro.codigo := 0
     else LLivro.codigo := strtoint(textCodigoLivro.Text);

     LLivro.GravarBanco();
     textCodigoLivro.Text := inttostr(llivro.codigo);
     listBoxLivros.Items.Add(LLivro.RetornaLinhaComPipe);
     LLivro.free;
end;

procedure TFormLivro.FormCreate(Sender: TObject);
var
  arq:textfile;
  linha:String;
  LLivro:TLivro;
  LLista:TList<TLivro>;
  i:Integer;
begin
   LLivro:=TLivro.create;
   LLista:=LLivro.ListarTodos;
   for i:=0 to llista.Count-1 do
   begin
     ListBoxLivros.items.add(llista[i].RetornaLinhaComPipe);
   end;
  llista.free;
  LLivro.free;
end;

procedure TFormLivro.listBoxLivrosDblClick(Sender: TObject);
var
 LLivro:Tlivro;
begin
  if listBoxLivros.GetSelectedText = '' then exit;
  LLivro:=Tlivro.Create;
  LLivro.PreencheCamposPorLinha(listBoxLivros.GetSelectedText);
  textLivro.Text:=llivro.nome;
  textAno.text:= inttostr(llivro.ano);
  textCodigoAutor.text:= inttostr(llivro.Autor.Codigo);
  textNomeAutor.text:=llivro.autor.Nome;
  textCodigoLivro.Text := inttostr(llivro.codigo);
  LLivro.Free;
end;

procedure TFormLivro.textCodigoAutorChange(Sender: TObject);
var
  query:TZquery;
begin
   if trim(textCodigoAutor.Text)='' then exit;
   query:= Tzquery.Create(nil);
   query.Connection:= Dm.Conexao;
   query.SQL.Clear;
   query.SQL.Add('select nome from autor where codigo=:pcodigo');
   query.ParamByName('pcodigo').AsInteger := Strtoint(textCodigoAutor.text);
   query.Open;
   textNomeAutor.text:=Query.FieldByName('nome').AsString;
   query.Close;
   query.Free;
end;

procedure TFormLivro.limparTelaLivro;
  begin
    textLivro.Text := '';
    textNomeAutor.text:='';
    textCodigoAutor.Text := '';
    textAno.text:='';
  end;
{procedure TFormLivro.GravarArquivo(linhaArquivo:String);
var
  arqLivros: TextFile;
  i:integer;
  linha:string;
  begin
    linha:=linhaArquivo;
    AssignFile(arqLivros, 'livros.txt');
    if FileExists('livros.txt') then Append(arqLivros)
    else Rewrite(arqLivros);
    writeln(arqLivros, linha);
    closefile(arqLivros);
end;
}
end.

