unit venda.cliente;

{$mode Delphi}{$H+}

interface

uses
  Classes, Windows, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  FileCtrl, venda.pessoa, biblioteca.dm, FileUtil, LazFileUtils;

type

  { TformCliente }

  TformCliente = class(TForm)
    btnAdicionarCliente: TButton;
    btnSalvarCliente: TButton;
    labelIdade: TLabel;
    labelNomeCliente: TLabel;
    textNome: TEdit;
    ListBoxCliente: TListBox;
    textIdade: TEdit;
    procedure btnAdicionarClienteClick(Sender: TObject);
    procedure btnRemoverClienteClick(Sender: TObject);
   // procedure LimparTelaCliente;
  private

  public

  end;

var
  formCliente: TformCliente;

implementation

{$R *.lfm}

{ TformCliente }

procedure TformCliente.btnAdicionarClienteClick(Sender: TObject);
begin
  ListBoxCliente.Items.Add(textNome.text+'|'+textIdade.text);
  textNome.text:='';
  textNome.SetFocus;
  textIdade.text:='';
  textIdade.SetFocus;
end;

procedure TformCliente.btnRemoverClienteClick(Sender: TObject);
begin
  ListBoxCliente.DeleteSelected;
end;

procedure LimparTelaCliente;
begin

end;

end.

