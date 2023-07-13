unit biblioteca.cadastroautor;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,generics.Collections, StdCtrls,
  biblioteca.autor, biblioteca.cadastroLivro, gettext;

type

  { TfrmAutor }

  TfrmAutor = class(TForm)
    btnExcluir: TButton;
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
    procedure btnExcluirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBoxAutorDblClick(Sender: TObject);
  private
    procedure LimparTelaCadastroAutor;
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
     if textAutor.Text='' then
     begin
       ShowMessage('Informe o autor');
       exit;
     end;
     if textCidade.Text = '' then
     begin
       ShowMessage('Informe a cidade');
       exit;
     end;
     if textIdade.Text= '' then
     begin
       ShowMessage('Informe a idade');
       exit;
     end;
     LAutor:=TAutor.Create;
     LAutor.Nome:=textAutor.text;
     LAutor.Idade:= strtoint(textIdade.text);
     LAutor.Cidade:=textCidade.text;
     if(textcodigo.text='')then LAutor.Codigo:=0
     else
        LAutor.Codigo := strtoint(textcodigo.text);
     LAutor.GravarBanco();
     ListBoxAutor.Items.Add(LAutor.RetornaLinhaComPipe);
     LimparTelaCadastroAutor;
     LAutor.free;
end;

procedure TfrmAutor.btnExcluirClick(Sender: TObject);
var
  codigo:Integer;
  vetor:TStringArray;
  LAutor:Tautor;
begin
     Lautor:=TAutor.create;
     vetor:=(ListBoxAutor.GetSelectedText.Split(' - '));
     codigo:= strtoint(vetor[0]);
     if MessageDlg('Deseja mesmo excluir?', mtWarning, [mbYes, mbNo], 0,mbNo) = mrYes then
     begin
          if LAutor.ExcluirAutor(codigo) = true then
          begin
             ShowMessage('Excluído com sucesso.');
             ListBoxAutor.DeleteSelected;
          end
     else ShowMessage('Não foi possível excluir.');
     end;
end;
procedure TfrmAutor.FormCreate(Sender: TObject);
var
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
end;

procedure TfrmAutor.FormShow(Sender: TObject);
begin
     LimparTelaCadastroAutor;
end;

procedure TfrmAutor.ListBoxAutorDblClick(Sender: TObject);
var
  LAutor:TAutor;
begin
     if ListBoxAutor.GetSelectedText = '' then exit;
    LAutor:=TAutor.Create;
    LAutor.BuscarPorCodigo(strtoint(ListBoxAutor.GetSelectedText.Split(' - ')[0]));
    textAutor.text:=Lautor.Nome;
    textIdade.Text:=inttostr(LAutor.Idade);
    textCidade.Text:=LAutor.Cidade;
    textCodigo.Text:=inttostr(LAutor.Codigo);
    LAutor.free;
    ListBoxAutor.DeleteSelected;
end;

end.
