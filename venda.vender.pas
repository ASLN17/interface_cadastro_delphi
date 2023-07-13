unit venda.vender;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Grids,
  venda.cliente, venda.produto, StrUtils;

type

  { TformVendas }

  TformVendas = class(TForm)
    Button1: TButton;
    btnSalvarArquivo: TButton;
    ComboBoxCliente: TComboBox;
    ComboBoxProduto: TComboBox;
    countVendas: TEdit;
    Label6: TLabel;
    listVendas: TListBox;
    totalVendas: TLabel;
    textTotalVenda: TEdit;
    Label5: TLabel;
    textQuantidade: TEdit;
    textTotal: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    StringGrid1: TStringGrid;
    procedure btnAddGrid(Sender: TObject);
    procedure btnSalvarArquivoClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure listVendasDblClick(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure textQuantidadeChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
     procedure CalculaTotal;
     procedure MostraVenda;
     function RetornaNumeroVendas:String;

  public

  end;

var
  formVendas: TformVendas;

implementation

{$R *.lfm}

{ TformVendas }

procedure TformVendas.btnAddGrid(Sender: TObject);
var
  row:integer;
  x, y, i:integer;
  f:textfile;
  linha:string;
begin

  if (ComboBoxCliente.ItemIndex <> -1) and (textQuantidade.Text <> '') and (ComboBoxProduto.ItemIndex <> -1) then
  begin;
    if StringGrid1.RowCount = 1 then row:=1
    else row:=StringGrid1.RowCount;
    StringGrid1.RowCount:=row + 1;
    StringGrid1.Cells[0,row]:= ComboBoxProduto.Items.Names[ComboBoxProduto.ItemIndex];
    StringGrid1.Cells[2,row]:= ComboBoxProduto.Items.Values[ComboBoxProduto.Items.Names[ComboBoxProduto.ItemIndex]];
    StringGrid1.Cells[1,row]:= textQuantidade.text;
    StringGrid1.Cells[3,row]:= textTotal.text;
    CalculaTotal;
    AssignFile(f, 'total.txt');
    Rewrite(f);
    For y:=1 to StringGrid1.rowcount-1 do
    begin
         for i:=0 to 3 do
          begin
           writeln(f, StringGrid1.cells[i,y]);
      end;
      writeln(f, '===============');
    end;
    writeln(F, linha);
    closefile(f);


  end
end;

procedure TformVendas.btnSalvarArquivoClick(Sender: TObject);
var
  f:textfile;
  y,i:integer;
  linha:string;
begin
  countVendas.text:= inttostr(strtoint(RetornaNumeroVendas)+1);
  AssignFile(f,'venda' + countVendas.text + '.txt');
  Rewrite(f);
  writeln(f, 'Numero da venda: ' + countVendas.text);
  writeln(f, 'Nome do cliente: ' + (ComboBoxCliente.Items[ComboBoxCliente.ItemIndex]));              //cliente
  For y:=1 to StringGrid1.rowcount - 1 do
  begin
      for i:=0 to 3 do
      begin
        writeln(f, StringGrid1.cells[i,y]);
      end;
      writeln(f, '===============');
  end;
  closefile(f);
  AssignFile(f,'registrovendas.txt');
  Rewrite(f);
  writeln(f, StrToInt(countVendas.Text));
  closefile(f);
  MostraVenda;
end;

procedure TformVendas.FormHide(Sender: TObject);
var
i, j:integer;
begin
  for i:=0 to Self.ComponentCount-1 do
  begin
      if Self.Components[i].ClassName = 'TEdit' then
         TEdit(Self.Components[i]).Text:='';
      if Self.Components[i].ClassName = 'TComboBox' then
         TComboBox(Self.Components[i]).ItemIndex:=-1;
  end;
  with StringGrid1 do
    for j := 1 to RowCount -1 do
        rows[j].Clear;
end;

procedure TformVendas.listVendasDblClick(Sender: TObject);
var
   i,numeroLinhaLida:integer;
   linhaArquivo, nomearquivo, valorLinha, teste:String;
   coluna:integer;
   f:TextFile;
begin
     i:=0;
     numeroLinhaLida:=0;
     nomearquivo:=(listVendas.GetSelectedText+'.txt');
      AssignFile(F, nomearquivo);
      FileMode := fmOpenRead;
      Reset(f);
      numeroLinhaLida:=1;
      StringGrid1.RowCount:=1;
      while not eof(f) do begin
       readln(f, linhaArquivo);
       if numeroLinhaLida=1 then
       begin
          valorLinha:=TrimLeft(linhaArquivo.Split(':')[1]);
          countVendas.text:=valorLinha;
       end
       else
         if numeroLinhaLida=2 then
         begin
           valorLinha:=TrimLeft(linhaArquivo.Split(':')[1]);
          ComboBoxCliente.Text:=valorLinha;
         end
         else
           case numeroLinhaLida of
           3:
             begin
                inc(i);
               StringGrid1.RowCount:=StringGrid1.RowCount+1;
               StringGrid1.Cells[0,i]:=linhaArquivo;
             end;
           4: StringGrid1.Cells[1,i]:=linhaArquivo;
           5: StringGrid1.Cells[2,i]:=linhaArquivo;
           6: StringGrid1.Cells[3,i]:=linhaArquivo;
           7: numeroLinhaLida:=2;
           end;
         end;
         inc(numeroLinhaLida);

        closefile(f);
        CalculaTotal;
end;

procedure TformVendas.StringGrid1DblClick(Sender: TObject);
begin
   //StringGrid1.DeleteRow(DeleteSelected);
end;

procedure TformVendas.textQuantidadeChange(Sender: TObject);
var
  LValorProduto:string;
begin
  textTotal.Text:='0';
  if textQuantidade.text= '' then exit;
  LValorProduto:=ComboBoxProduto.Items.Values[ComboBoxProduto.Items.Names[ComboBoxProduto.ItemIndex]] ;
  textTotal.Text:=FloatToStr( StrToFloat(LValorProduto)*StrToFloat(textQuantidade.text));
end;

procedure TformVendas.FormShow(Sender: TObject);
var
  i:integer;
  nome:string;
  preco:string;
  teste:integer;
begin
  ComboBoxCliente.Items.Clear;
           {
 for i:= 0 to formCliente.ListBox1.Items.Count-1 do
 begin
   nome:=formCliente.ListBox1.Items[i];
   NOME:=nome.Split('|')[0];
   ComboBoxCliente.Items.add(nome);
 end;
 ComboBoxProduto.Items.Clear;
  for i := 0 to formCadastroProduto.ListBoxProd.Items.Count-1 do
  begin
    nome:=formCadastroProduto.ListBoxProd.Items[i];
    preco:=nome.Split('|')[1];
    NOME:=nome.Split('|')[0];
    ComboBoxProduto.Items.AddPair(nome,preco);
    teste:=ComboBoxProduto.Items.Count;
  end;
  MostraVenda;  }
end;

procedure TformVendas.CalculaTotal;
var
   i:Integer;
   SomaTotal:Double;
begin
  SomaTotal:= 0;
  for i:=1 to StringGrid1.RowCount-1  do
  begin
     SomaTotal:= StrToFloat(StringGrid1.Cells[3, i]) + SomaTotal;
  end;
  textTotalVenda.Text:=FloatToStr(SomaTotal);
end;

procedure TformVendas.MostraVenda;
var
  i:integer;
  nomearquivo:String;
begin
  listVendas.items.clear;
  for i:=0 to StrToInt(RetornaNumeroVendas) do
  begin
    nomearquivo:='venda'+inttostr(i)+'.txt';
    if FileExists(nomearquivo) then
    begin
      listVendas.Items.Add('venda'+inttostr(i));
    end;
  end;
end;

function TformVendas.RetornaNumeroVendas: String;
var
  f: TextFile;
  linhaArquivo,quantVendas:string;
  VetorString:TStringArray;
  linha,i,y:integer;
  nomearquivo:string;
begin
  if FileExists('registroVendas.txt') then
  begin
    AssignFile(F, 'registroVendas.txt');
    FileMode := fmOpenRead;
    Reset(f);
    ReadLn(f ,quantVendas);
    Result:=quantVendas;
    closefile(f);
  end;
end;

end.

