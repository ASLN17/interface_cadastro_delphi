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
    btnExcluirLivro: TButton;
    labelNome: TLabel;
    labelLivrosCadastrados: TLabel;
    listBoxLivros: TListBox;
    textAno: TEdit;
    labelAno: TLabel;
    textCodigoAutor: TEdit;
    textCodigoLivro: TEdit;
    textNomeAutor: TEdit;
    textLivro: TEdit;
    procedure btnExcluirLivroClick(Sender: TObject);
    procedure btnSalvarLivroClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
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

procedure TFormLivro.limparTelaLivro;
  begin
    textLivro.Text := '';
    textNomeAutor.text:='';
    textCodigoAutor.Text := '';
    textAno.text:='';
    end;

procedure TFormLivro.btnSalvarLivroClick(Sender: TObject);
var
  LLivro:Tlivro;
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
     if textLivro.text = '' then
     begin
        ShowMessage('Informe o livro');
        exit;
     end;
     LLivro:=Tlivro.Create;
     LLivro.Nome:=textLivro.text;
     LLivro.Ano:= strtoint(textAno.text);
     LLivro.autor.Codigo := strtoint(textCodigoAutor.text);
     if(textCodigoLivro.text='') then LLivro.codigo := 0
     else LLivro.codigo := strtoint(textCodigoLivro.Text);
     LLivro.GravarBanco();
     textCodigoLivro.Text := inttostr(llivro.codigo);
     listBoxLivros.Items.Add(LLivro.RetornaLinhaComPipe);
     limparTelaLivro;
     LLivro.free;
end;

procedure TFormLivro.btnExcluirLivroClick(Sender: TObject);
var
  LLivro:TLivro;
  vetor:TStringArray;
  codigo:Integer;
begin
   LLivro:=TLivro.Create;
   vetor:=listBoxLivros.GetSelectedText.Split(' - ');
   codigo:=strtoint(vetor[0]);
   if MessageDlg('Deseja mesmo excluir?', mtWarning, [mbYes, mbNo], 0,mbNo) = mrYes then
   begin
     if LLivro.ExcluirLivro(codigo) = true then
     begin
     ShowMessage('Livro excluído com sucesso.');
     listBoxLivros.DeleteSelected;
     end
     else ShowMessage('Não foi possível excluir.');
   end;
end;

procedure TFormLivro.FormCreate(Sender: TObject);
var
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

procedure TFormLivro.FormShow(Sender: TObject);
begin
   limparTelaLivro;
end;

procedure TFormLivro.listBoxLivrosDblClick(Sender: TObject);
var
 LLivro:Tlivro;
begin
  if listBoxLivros.GetSelectedText = '' then exit;
  LLivro:=Tlivro.Create;
  LLivro.BuscarPorCodigo(strtoint(listBoxLivros.GetSelectedText.Split(' - ')[0]));
  textLivro.Text:=llivro.nome;
  textAno.text:= inttostr(llivro.ano);
  textCodigoAutor.text:= inttostr(llivro.Autor.Codigo);
  textNomeAutor.text:=llivro.autor.Nome;
  textCodigoLivro.Text := inttostr(llivro.codigo);
  LLivro.Free;
  listBoxLivros.DeleteSelected;
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

end.

