unit venda.cliente;

{$mode Delphi}{$H+}

interface

uses
  Classes, Windows, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  FileCtrl, venda.pessoa, biblioteca.dm, FileUtil, LazFileUtils, ZDataset,
  generics.Collections;

type

  { TformCliente }

  TformCliente = class(TForm)
    btnExcluirCliente: TButton;
    btnSalvarCliente: TButton;
    textCodigo: TEdit;
    labelIdade: TLabel;
    labelNomeCliente: TLabel;
    textNome: TEdit;
    ListBoxCliente: TListBox;
    textIdade: TEdit;
    procedure btnExcluirClienteClick(Sender: TObject);
    procedure btnSalvarClienteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LimparTelaCliente;
    procedure ListBoxClienteClick(Sender: TObject);
  private

  end;

var
  formCliente: TformCliente;

implementation

{$R *.lfm}

{ TformCliente }

procedure TformCliente.btnSalvarClienteClick(Sender: TObject);
var
  LCliente:TPessoa;
begin
  if textnome.Text = '' then
  begin
    ShowMessage('Informe um nome');
    exit;
  end;
  if textIdade.text = '' then
  begin
     ShowMessage('Informe uma idade');
    exit;
  end;
  LCliente:= TPessoa.create;
  LCliente.Nome := textnome.text;
  LCliente.Idade := strtoint(textIdade.text);
  if(textCodigo.text='') then LCliente.codigo := 0
  else LCliente.codigo := strtoint(textCodigo.Text);
  LCliente.GravarBanco();
  textCodigo.Text := inttostr(LCliente.codigo);
  ListBoxCliente.Items.Add(LCliente.RetornaLinha);
  LimparTelaCliente;
  LCliente.free;
end;

procedure TformCliente.btnExcluirClienteClick(Sender: TObject);
var
  LCliente:TPessoa;
  vetor:TStringArray;
  codigo:Integer;
begin
     LCliente:=TPessoa.create;
     vetor:=(ListBoxCliente.GetSelectedText.Split(' - '));
     codigo:= strtoint(vetor[0]);
     if MessageDlg('Deseja mesmo excluir?', mtWarning, [mbYes, mbNo], 0,mbNo) = mrYes then
     begin
          if LCliente.ExcluirCliente(codigo) = true then
          begin
             ShowMessage('Excluído com sucesso.');
             ListBoxCliente.DeleteSelected;
          end
     else ShowMessage('Não foi possível excluir.');
     end;
end;

procedure TformCliente.FormCreate(Sender: TObject);
var
  LCliente:TPessoa;
  LLista:TList<TPessoa>;
  i:Integer;
begin
   Llista:=LCliente.ListarTodos;
   for i:=0 to Llista.Count-1 do
   begin
     LCliente:=LLista[i];
     ListBoxCliente.items.add(LCliente.RetornaLinha);
   end;
  llista.free;
end;

procedure TformCliente.FormShow(Sender: TObject);
begin
  LimparTelaCliente;
end;

procedure TformCliente.LimparTelaCliente;
begin
   textNome.text := '';
   textIdade.text := '';
   textCodigo.text := '';
end;

procedure TformCliente.ListBoxClienteClick(Sender: TObject);
var
   LCliente:TPessoa;
begin
    if ListBoxCliente.GetSelectedText = '' then exit;
    LCliente:=TPessoa.Create;
    LCliente.BuscarPorCodigo(strtoint(ListBoxCliente.GetSelectedText.Split(' - ')[0]));
    textNome.text:=LCliente.Nome;
    textIdade.Text:=inttostr(LCliente.Idade);
    textCodigo.Text:=inttostr(LCliente.Codigo);
    LCliente.free;
    ListBoxCliente.DeleteSelected;
end;

end.

