unit venda.produto;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, Windows, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  LazFileUtils;

type

  { TformCadastroProduto }

  TformCadastroProduto = class(TForm)
    btnAdicionarProduto: TButton;
    btnSalvarProduto: TButton;
    labelNome: TLabel;
    labelPreco: TLabel;
    textNomeProduto: TEdit;
    textPreco: TEdit;
    ListBoxProd: TListBox;
    procedure btnAdicionarProdutoClick(Sender: TObject);
    procedure btnRemoverProduto(Sender: TObject);
    procedure btnSalvarProdutoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  formCadastroProduto: TformCadastroProduto;

implementation

{$R *.lfm}

{ TformCadastroProduto }

procedure TformCadastroProduto.btnAdicionarProdutoClick(Sender: TObject);
begin
  ListBoxProd.Items.add(textNomeProduto.text+'|'+textPreco.text);
  textNomeProduto.text:='';
  textNomeProduto.SetFocus;
  textPreco.text:='';
  textPreco.SetFocus;
end;

procedure TformCadastroProduto.btnRemoverProduto(Sender: TObject);
begin
  ListBoxProd.DeleteSelected;
end;

procedure TformCadastroProduto.btnSalvarProdutoClick(Sender: TObject);
var
  i:integer;
  f:textfile;
begin
  AssignFile(F, 'produtos.txt');
  Rewrite(F);
  //SetFileAttributes('produtos.txt', FILE_ATTRIBUTE_NORMAL);
  for i:= 0 to ListBoxProd.Items.Count-1 do
      Writeln(F, ListBoxProd.Items[i]);
  CloseFile(F);
end;

procedure TformCadastroProduto.FormCreate(Sender: TObject);
var
  f: TextFile;
  i:integer;
  linhaArquivo:string;
begin
  if FileExists('produtos.txt') then
  begin
    AssignFile(F, 'produtos.txt');
    FileMode := fmOpenRead;
    Reset(f);
    while not eof(f) do begin
     readln(f, linhaArquivo);
     ListBoxProd.Items.Add(linhaArquivo);
    end;
    closefile(f);
  end;
end;

end.

