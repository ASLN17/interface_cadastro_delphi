unit venda.produto;

{$mode Delphi}{$H+}

interface

uses
  Classes, Windows, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  classeproduto, LazFileUtils, ZDataSet, biblioteca.dm, generics.Collections, Crt;

type

  { TformCadastroProduto }

  TformCadastroProduto = class(TForm)
    btnSalvarProduto: TButton;
    btnExcluirProduto: TButton;
    textCodigo: TEdit;
    labelNome: TLabel;
    labelPreco: TLabel;
    textNomeProduto: TEdit;
    textPreco: TEdit;
    ListBoxProd: TListBox;
    procedure btnExcluirProdutoClick(Sender: TObject);
    procedure btnRemoverProduto(Sender: TObject);
    procedure btnSalvarProdutoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    //procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBoxProdDblClick(Sender: TObject);
    procedure LimparTelaProduto;
  private

  public

  end;

var
  formCadastroProduto: TformCadastroProduto;

implementation

{$R *.lfm}

{ TformCadastroProduto }

procedure TformCadastroProduto.btnRemoverProduto(Sender: TObject);
begin
  ListBoxProd.DeleteSelected;
end;

procedure TformCadastroProduto.btnExcluirProdutoClick(Sender: TObject);
var
  LProduto:TProduto;
  vetor:TStringArray;
  codigo:Integer;
begin
     LProduto:=TProduto.create;
     vetor:=(ListBoxProd.GetSelectedText.Split(' - '));
     codigo:= strtoint(vetor[0]);
     if MessageDlg('Deseja mesmo excluir?', mtWarning, [mbYes, mbNo], 0,mbNo) = mrYes then
     begin
          if LProduto.ExcluirProduto(codigo) = true then
          begin
             ShowMessage('Excluído com sucesso.');
             ListBoxProd.DeleteSelected;
          end
     else ShowMessage('Não foi possível excluir.');
     end;
end;

procedure TformCadastroProduto.btnSalvarProdutoClick(Sender: TObject);
var
  LProduto:TProduto;
begin
   if textNomeProduto.text = '' then
   begin
     ShowMessage('Informe um nome.');
     exit;
   end;
   if textPreco.Text = '' then
   begin
     ShowMessage('Informe um preço.');
     exit;
   end;
   LProduto:=TProduto.Create;
   LProduto.Nome := textNomeProduto.Text;
   LProduto.Preco := strtoint(textPreco.text);
   if(textCodigo.text='') then LProduto.codigo := 0
   else LProduto.codigo := strtoint(textCodigo.Text);
    LProduto.GravarBanco();
    textCodigo.Text := inttostr(LProduto.codigo);
    ListBoxProd.Items.Add(LProduto.RetornaLinha);
    Delay(1000);
    LimparTelaProduto;
end;

procedure TformCadastroProduto.FormCreate(Sender: TObject);
var
  LProduto:TProduto;
  LLista:TList<TProduto>;
  i:Integer;
begin
   Llista:=LProduto.ListarTodos;
   for i:=0 to Llista.Count-1 do
   begin
     LProduto:=LLista[i];
     ListBoxProd.items.add(LProduto.RetornaLinha);
   end;
  llista.free;
end;

procedure TformCadastroProduto.FormShow(Sender: TObject);
begin
  LimparTelaProduto;
end;

procedure TformCadastroProduto.ListBoxProdDblClick(Sender: TObject);
var
  LProduto:TProduto;
  vetor:TStringArray;
begin
   LProduto:=TProduto.Create;
   vetor:=ListBoxProd.GetSelectedText.Split(' - ');
   LProduto.BuscaCodigo(strtoint(vetor[0]));
   textCodigo.text := inttostr(LProduto.codigo);
   textNomeProduto.text := LProduto.nome;
   textPreco.text := inttostr(LProduto.preco);
   LProduto.Free;
   ListBoxProd.DeleteSelected;
end;

procedure TformCadastroProduto.LimparTelaProduto;
begin
   textNomeProduto.Text := '';
   textPreco.text := '';
   textCodigo.text := '';
end;

end.

