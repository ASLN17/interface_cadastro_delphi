unit biblioteca.cadastroautor;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,generics.Collections, StdCtrls,
  biblioteca.autor, biblioteca.cadastroLivro, gettext;

type

  { TfrmAutor }

  TfrmAutor = class(TForm)
    textIdade: TEdit;
    textCodigo: TEdit;
    textCidade: TEdit;
    textAutor: TEdit;
    labelNomeAutor1: TLabel;
    btnAdicionarAutor: TButton;
    labelCidade: TLabel;
    labelIdade: TLabel;
    labelNomeAutor: TLabel;
    ListBoxAutor: TListBox;
    procedure btnAdicionarAutorClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBoxAutorDblClick(Sender: TObject);
  private
    procedure LimparTelaCadastroAutor;
    //procedure MostraAutores;
  public

  end;

var
  frmAutor : TfrmAutor;

implementation

{$R *.lfm}

{ TForm1 }

procedure TfrmAutor.LimparTelaCadastroAutor;
begin
     textAutor.text:= '';
     textIdade.text:= '';
     textCidade.text:= '';
     textCodigo.text:= '';
end;
procedure TfrmAutor.btnAdicionarAutorClick(Sender: TObject);
var
  LAutor:TAutor;
begin
     LAutor:=TAutor.Create;
     LAutor.Nome:=textAutor.text;
     LAutor.Idade:= strtoint(textIdade.text);
     LAutor.Cidade:=textCidade.text;
     if(textcodigo.text='')then
        LAutor.Codigo:=0
     else
        LAutor.Codigo := strtoint(textcodigo.text);
     LAutor.GravarBanco();
     ListBoxAutor.Items.Add(LAutor.RetornaLinhaComPipe);
     LimparTelaCadastroAutor;
     LAutor.free;
end;

procedure TfrmAutor.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
{var
  arquivoAutores:TextFile;
  i:integer;
begin
   AssignFile(arquivoAutores, 'arquivoGeralAutores.txt');
   Rewrite(arquivoAutores);
   for i := 0 to ListBoxAutor.Items.Count-1 do
   begin
      writeln(arquivoautores, ListBoxAutor.Items[i]);
   end;
   closefile(arquivoautores);}
end;

procedure TfrmAutor.FormCreate(Sender: TObject);
var
  arq:textfile;
  linha:String;
  LAutor:TAutor;
  LLista:TList<TAutor>;
  i:Integer;
begin
   Lautor:=TAutor.create;
   LLista:=lautor.ListarTodos;
   for i:=0 to llista.Count-1 do
   begin
     ListBoxAutor.items.add(llista[i].RetornaLinhaComPipe);
   end;
  llista.free;
  lautor.free;
     {
  //adicionar itens
  if FileExists('arquivoGeralAutores.txt') then
  begin
    AssignFile(arq, 'arquivoGeralAutores.txt');
    Reset(arq);
    while not eof(arq) do
    begin
        Readln(arq, linha);
        ListBoxAutor.Items.Add(linha);
    end;
  closefile(arq);
  end;
  }
end;

procedure TfrmAutor.FormShow(Sender: TObject);
begin
     //MostraAutores;
     LimparTelaCadastroAutor;
end;

procedure TfrmAutor.ListBoxAutorDblClick(Sender: TObject);
var
  LAutor:TAutor;
begin
  LAutor:=TAutor.Create;
  LAutor.BuscarPorCodigo(strtoint(ListBoxAutor.GetSelectedText.Split('|')[0]));

  textAutor.text:=Lautor.Nome;
  textIdade.Text:=inttostr(LAutor.Idade);
  textCidade.Text:=LAutor.Cidade;
  textCodigo.Text:=inttostr(LAutor.Codigo);
  //ListBoxAutor.DeleteSelected;
  LAutor.free;
end;


end.
