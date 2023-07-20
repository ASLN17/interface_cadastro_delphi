program ProjetoVenda;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, venda.principal, venda.cliente, venda.produto, venda.vender,
  venda.pessoa, biblioteca.autor, biblioteca.cadastroautor,
  biblioteca.cadastroLivro, biblioteca.livro, zcomponent, biblioteca.dm,
  classeproduto, venda.classe, venda.produtovenda;
  { you can add units after this }

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TformPrincipal, formPrincipal);
  Application.CreateForm(TformCliente, formCliente);
  Application.CreateForm(TformCadastroProduto, formCadastroProduto);
  Application.Run;
end.

