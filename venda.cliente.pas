unit venda.cliente;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, Windows, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  FileCtrl, venda.pessoa, FileUtil, LazFileUtils;

type

  { TformCliente }

  TformCliente = class(TForm)
    btnAdicionarCliente: TButton;
    btnSalvarCliente: TButton;
    Label1: TLabel;
    Label2: TLabel;
    textNome: TEdit;
    ListBox1: TListBox;
    textIdade: TEdit;
    procedure btnAdicionarClienteClick(Sender: TObject);
    procedure btnRemoverClienteClick(Sender: TObject);
    procedure btnSalvarClienteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);


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

  ListBox1.Items.Add(textNome.text+'|'+textIdade.text);
  textNome.text:='';
  textNome.SetFocus;
  textIdade.text:='';
  textIdade.SetFocus;
  LPessoa.Free;

end;

procedure TformCliente.btnRemoverClienteClick(Sender: TObject);
begin
  ListBox1.DeleteSelected;
end;

procedure TformCliente.btnSalvarClienteClick(Sender: TObject);
var
  i:integer;
  f:textfile;
begin
  AssignFile(F, 'clientes.txt');
  Rewrite(F);
  //SetFileAttributes('clientes.txt', FILE_ATTRIBUTE_NORMAL);
  for i:= 0 to ListBox1.Items.Count-1 do
      Writeln(F, ListBox1.Items[i]);
  CloseFile(F);
end;

procedure TformCliente.FormCreate(Sender: TObject);
var
  f: TextFile;
  i:integer;
  linhaArquivo:string;
begin
  if FileExists('clientes.txt') then
  begin
    AssignFile(F, 'clientes.txt');
    FileMode := fmOpenRead;
    Reset(f);
    while not eof(f) do begin
     readln(f, linhaArquivo);
     ListBox1.Items.Add(linhaArquivo);
    end;
    closefile(f);
  end;
end;

end.

