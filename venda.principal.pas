unit venda.principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  venda.cliente, venda.produto, venda.vender;

type

  { TformPrincipal }

  TformPrincipal = class(TForm)
    btnCadastroCliente: TButton;
    btnVendas: TButton;
    btnCadastroProduto: TButton;
    btnVendas1: TButton;
    btnVendas2: TButton;
    procedure btnCadastroClienteClick(Sender: TObject);
    procedure btnCadastroProdutoClick(Sender: TObject);
    procedure btnVendas2Click(Sender: TObject);
    procedure btnVendasClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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

procedure TformPrincipal.btnCadastroProdutoClick(Sender: TObject);
begin
  formCadastroProduto.ShowModal;
end;

procedure TformPrincipal.btnVendas2Click(Sender: TObject);
  var
   lform:TformCliente;
   i:integer;
begin
   for i := 0 to 1000 do
   begin
        lform:=TformCliente.Create(self);
   end;

end;

procedure TformPrincipal.btnVendasClick(Sender: TObject);
begin
  formVendas.ShowModal;
end;

procedure TformPrincipal.FormCreate(Sender: TObject);
var
  fc:TextFile;
  fp:TextFile;
  arq, registroVenda:TextFile;
begin
  AssignFile(fc, 'clientes.txt');
  AssignFile(fp, 'produtos.txt');
  AssignFile(arq, 'total.txt');

  if not FileExists('registroVendas.txt') then
  begin
       AssignFile(registroVenda, 'registroVendas.txt');
       Rewrite(registroVenda);
       writeln(registroVenda, '0');
       CloseFile(registroVenda);
  end;

end;

end.

