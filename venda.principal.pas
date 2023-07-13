unit venda.principal;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Grids,
  venda.cliente, venda.produto, venda.vender, biblioteca.autor,
  biblioteca.cadastroautor, biblioteca.cadastroLivro;

type

  { TformPrincipal }

  TformPrincipal = class(TForm)
    btnCadastroCliente: TButton;
    btnCadastroProduto: TButton;
    btnVendas: TButton;
    btnCadastroAutor: TButton;
    btnCadastroLivro: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    procedure btnCadastroClienteClick(Sender: TObject);
    procedure btnCadastroLivroClick(Sender: TObject);
    procedure btnCadastroProdutoClick(Sender: TObject);
    procedure btnVendasClick(Sender: TObject);
    procedure btnCadastroAutorClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
  private

  public

  end;

var
  formPrincipal: TformPrincipal;

implementation

{$R *.lfm}

{ TformPrincipal }

procedure TformPrincipal.btnCadastroClienteClick(Sender: TObject);
begin
     formCliente.ShowModal;
end;

procedure TformPrincipal.btnCadastroLivroClick(Sender: TObject);
var
  frmLivro:TFormLivro;
begin
     frmLivro:=TformLivro.Create(Self);
     frmLivro.showModal;
     frmLivro.Free;
end;

procedure TformPrincipal.btnCadastroProdutoClick(Sender: TObject);
begin
     formCadastroProduto.ShowModal;
end;

procedure TformPrincipal.btnVendasClick(Sender: TObject);
var
  formVendas:TformVendas;
begin
     formVendas:=TformVendas.Create(Self);
     formVendas.ShowModal;
     formVendas.Free;
end;

procedure TformPrincipal.btnCadastroAutorClick(Sender: TObject);
var
  frm:TfrmAutor;
begin
  frm:=TfrmAutor.Create(Self);
  frm.showModal;
  frm.free;
end;

procedure TformPrincipal.FormKeyPress(Sender: TObject; var Key: char);
begin
    ShowMessage('Pressionou ' + key );
end;

end.

