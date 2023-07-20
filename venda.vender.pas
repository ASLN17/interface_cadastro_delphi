unit venda.vender;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, forms, Controls, Graphics, Dialogs, StdCtrls, Grids,
  biblioteca.dm, venda.classe, venda.produtovenda, ZDataset, StrUtils, Generics.Collections, Crt;

type

  { TformVendas }

  TformVendas = class(TForm)
    btnAdicionarVenda: TButton;
    btnExcluirVenda: TButton;
    btnSalvarVenda: TButton;
    ComboBoxCliente: TComboBox;
    ComboBoxProduto: TComboBox;
    textCodigoVenda: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    labelCliente: TLabel;
    labelProduto: TLabel;
    labelquantidade: TLabel;
    labelTotal: TLabel;
    labelTotalVenda: TLabel;
    labelVendasEfetuadas: TLabel;
    listVendas: TListBox;
    StringGrid1: TStringGrid;
    textQuantidade: TEdit;
    textTotal: TEdit;
    textTotalVenda: TEdit;
    totalVendas: TLabel;
    procedure btnAdicionarVendaClick(Sender: TObject);
    procedure btnExcluirVendaClick(Sender: TObject);
    procedure btnSalvarVendaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AdicionarGrid();
    procedure LimparTelaVenda();
    procedure GravarLista();
    procedure PreencheComboBox();
    procedure CalculaTotal();
    procedure listVendasDblClick(Sender: TObject);
  private

  end;

var
  formVendas: TformVendas;

implementation

{$R *.lfm}

{ TformVendas }

procedure TformVendas.btnAdicionarVendaClick(Sender: TObject);
var
   LVenda:TVendas;
   query:TZquery;
   codigoProduto, codigoCliente, qtd, i:integer;
   preco, total:double;
   //nomeProduto:String;
begin
  LVenda:=TVendas.Create;
  if ComboBoxCliente.Text = '' then
  begin
    ShowMessage('Selecione um cliente.');
    exit;
  end;
  if ComboBoxProduto.Text = '' then
  begin
    ShowMessage('Selecione um produto.');
    exit;
  end;
  if textQuantidade.Text = '' then
  begin
    ShowMessage('Informe a quantidade.');
    exit;
  end;
  //FAZER FOR PRA PERCORRER STRINGRID COLUNA 0 E VERIFICAR SE O ITEM JA EXISTE NA VENDA
  LVenda:=TVendas.Create;
  if ComboBoxProduto.ItemIndex = -1 then exit;
   query := TZquery.Create(nil);
   query.Connection := DM.Conexao;
   CodigoProduto := strtoint(SplitString(ComboBoxProduto.text, ' - ')[0]);
   codigoCliente := strtoint(SplitString(ComboBoxCliente.text, ' - ')[0]);
   for i:=1 to StringGrid1.RowCount -1 do
    begin
      if strtoint(Stringgrid1.Cells[0, i]) = codigoProduto then
      begin
           ShowMessage('Produto já adicionado anteriormente.');
         exit;
      end
    end;
   //query
   query.sql.Add('select preco from produto where codigo=:pcodigo');
   query.ParamByName('pcodigo').AsInteger := CodigoProduto;
   query.Open;
   preco := query.FieldByName('preco').AsFloat;
   qtd := strtoint(textQuantidade.Text);
   total := qtd * preco;
   textTotal.Text := floattostr(total);
   //salvando os valores
   LVenda.CodigoCliente := codigoCliente;
   LVenda.CodigoVenda := strtoint(textCodigoVenda.text);
   AdicionarGrid;
   query.close;
   CalculaTotal();
   LVenda.Free;
   query.free;
  end;

procedure TformVendas.btnExcluirVendaClick(Sender: TObject);
var
   LVenda:TVendas;
   codigoVenda:integer;
   vetor:TStringArray;
   vendaSelecionada:String;
begin
  LVenda:=TVendas.Create;
  if listVendas.GetSelectedText = '' then
  begin
    ShowMessage('Selecione a venda que deseja excluir.');
    exit;
  end
  else
  begin
    if MessageDlg('Deseja mesmo excluir?', mtWarning, [mbYes, mbNo], 0,mbNo) = mrYes then
       begin
          vendaSelecionada := listVendas.GetSelectedText;
          vetor := vendaSelecionada.Split(' - ');
          codigoVenda := strtoint(vetor[0]);
          LVenda.CodigoVenda := codigoVenda;
          LVenda.ExcluirBanco();
          ShowMessage('Excluído com sucesso.');
          listVendas.DeleteSelected;
       end
    else exit;
  end;
  LVenda.Free;
end;

procedure TformVendas.btnSalvarVendaClick(Sender: TObject);
var
   LVenda:TVendas;
   LProdutoVenda:TVendaProduto;
   i, codigoCliente:Integer;
begin
   LVenda:=TVendas.Create;
   if(textCodigoVenda.Text='') then
      Lvenda.CodigoVenda := 0
   else
    Lvenda.CodigoVenda := strtoint(textCodigoVenda.Text);

    codigoCliente := strtoint(SplitString(ComboBoxCliente.text, ' - ')[0]);
    LVenda.CodigoCliente := codigoCliente;
    //for percorrendo toda a grid
    for i:=1 to StringGrid1.RowCount -1 do
    begin
       LProdutoVenda:=TVendaProduto.Create;
       LProdutoVenda.CodigoProduto := strtoint(StringGrid1.Cells[0, i]); //pegar codigo do produto da grid
       Lprodutovenda.Quantidade := strtofloat(StringGrid1.Cells[2, i]);
       LProdutoVenda.PrecoUnitarioPratico := strtofloat(StringGrid1.Cells[3, i]);
       LProdutoVenda.Total := strtofloat(StringGrid1.Cells[4, i]);
       lvenda.ListaProdutoVenda.Add(LProdutoVenda);
    end;
   LProdutoVenda.CodigoVenda := strtoint(textCodigoVenda.text);
   LVenda.GravarBanco();
   ShowMessage('Venda cadastrada com sucesso');
   LimparTelaVenda;
   GravarLista();
   PreencheComboBox();
end;

procedure TformVendas.FormShow(Sender: TObject);
begin
    GravarLista();
    PreencheComboBox();
end;

procedure TformVendas.AdicionarGrid;
var
   query:TZquery;
   row, codigoProduto:Integer;
   preco:Double;
begin
     codigoProduto := strtoint(SplitString(ComboBoxProduto.text, ' - ')[0]);
     query:=TZquery.Create(nil);
     query.Connection:=DM.Conexao;
     query.SQL.Add('select preco from produto where codigo=:pcodigo');
     query.ParamByName('pcodigo').AsInteger := codigoProduto;
     query.open;
     preco := query.FieldByName('preco').asFloat;
     query.open;
     row := StringGrid1.RowCount;
     StringGrid1.RowCount := row + 1;
     StringGrid1.Cells[0, row] := inttostr(codigoProduto);
     StringGrid1.Cells[1, row] := SplitString(ComboBoxProduto.text, ' - ')[1];
     StringGrid1.Cells[2, row] := textQuantidade.text;
     StringGrid1.Cells[3, row] := floattostr(preco);
     StringGrid1.Cells[4, row] := textTotal.text;
     CalculaTotal();
     query.close;
     query.Free;
end;

procedure TformVendas.LimparTelaVenda;
begin
  StringGrid1.Clear;
  textQuantidade.text := '';
  textTotal.text := '';
  ComboBoxCliente.Clear;
  ComboBoxProduto.Clear;
  listVendas.Clear;
end;

procedure TformVendas.listVendasDblClick(Sender: TObject);
var
   query, queryNome:TZquery;
   vendaSelecionada, nomeProduto, nomeCliente:String;
   vetor: TStringArray;
   codigoVenda, row, codigoCliente:Integer;
   LVenda:TVendas;
begin
  StringGrid1.RowCount:=1;
  if listVendas.GetSelectedText = '' then exit;
  LVenda := TVendas.Create;
  query := TZQuery.Create(nil);
  query.Connection := DM.Conexao;
  queryNome := TZQuery.Create(nil);
  queryNome.Connection := DM.Conexao;
  vendaSelecionada := listVendas.GetSelectedText;
  vetor := vendaSelecionada.Split(' - ');
  codigoVenda := strtoint(vetor[0]);
  //exclusao do item selecionado
  //salva o codigo do cliente - tabela venda
  query.SQL.Add('select * from venda where codigo=:pcodigo');
  query.ParamByName('pcodigo').AsInteger := codigoVenda;
  query.Open;
  if not query.EOF then
  begin
     codigoCliente := query.FieldByName('cliente_codigo').AsInteger;
     queryNome.SQL.Add('select * from cliente where codigo=:pcodigo');
     queryNome.ParamByName('pcodigo').AsInteger := codigoCliente;
     queryNome.Open;
     if not queryNome.EOF then
     begin
             nomeCliente := queryNome.FieldByName('nome').AsString;
             ComboBoxCliente.Text := inttostr(codigoCliente) + ' - ' + nomeCliente;
     end;
     queryNome.Close;
  end;
  query.Close;

  textCodigoVenda.text := inttostr(codigoVenda);

  //salva informações da venda
  query.sql.clear;
  query.SQL.Add('select * from venda_produto where codvenda=:pcodigo');
  query.ParamByName('pcodigo').AsInteger := codigoVenda;
  query.open;
  while not query.EOF do
  begin
       row := StringGrid1.RowCount;
       StringGrid1.RowCount := row + 1;
       StringGrid1.Cells[0, row] := inttostr(query.FieldByName('codproduto').AsInteger);
       StringGrid1.Cells[2, row] := floattostr(query.FieldByName('qtde').AsFloat);
       StringGrid1.Cells[3, row] := floattostr(query.FieldByName('valor_unitario').AsFloat);
       StringGrid1.Cells[4, row] := floattostr(query.FieldByName('valor_total').AsFloat);
       queryNome.SQL.Clear;
       queryNome.SQL.Add('select nome from produto where codigo=:pcodigo');
       queryNome.ParamByName('pcodigo').AsInteger := strtoint(StringGrid1.Cells[0, row]);
       queryNome.Open;
       nomeProduto := queryNome.FieldByName('nome').AsString;
       StringGrid1.Cells[1, row] :=  nomeProduto;
       queryNome.Close;
       query.Next;
  end;
  listVendas.DeleteSelected;
  query.close;
  query.free;
  queryNome.Free;
  CalculaTotal();
  // LVenda.GravarBanco();
  //LVenda.CodigoVenda := codigoVenda;
  //LVenda.ExcluirBanco();
end;

procedure TformVendas.GravarLista;
var
  query:TZQuery;
  nome, item:String;
  codigo:integer;
  data: TDateTime;
begin
     query:=TZquery.Create(nil);
     query.Connection:=DM.Conexao;
     query.SQL.Add('select * from venda order by codigo');
     query.Open;
     while not query.EOF do
     begin
        codigo := query.FieldByName('codigo').AsInteger;
        data := query.FieldByName('data').AsDateTime;
        item := inttostr(codigo) + ' - ' + datetostr(data);
        listVendas.Items.Add(item);
        query.Next;
     end;
     query.close;
     query.free;
end;

procedure TformVendas.PreencheComboBox;
var
  query:Tzquery;
  nome:String;
  codigo:integer;
begin
   query:=TZquery.Create(nil);
     query.Connection:=DM.Conexao;
     query.SQL.Add('select * from cliente order by codigo');
     query.Open;
     while not query.eof do
     begin
        codigo := query.FieldByName('codigo').AsInteger;
        nome := query.FieldByName('nome').AsString;
        ComboBoxCliente.Items.Add(inttostr(codigo) + ' - ' + nome);
        query.Next;
     end;
     query.sql.Clear;
     query.SQL.Add('select * from produto order by codigo');
     query.Open;
     while not query.EOF do
     begin
        codigo := query.FieldByName('codigo').AsInteger;
        nome := query.FieldByName('nome').AsString;
        ComboBoxProduto.Items.Add(inttostr(codigo) + ' - ' + nome);
        query.Next;
     end;
end;

procedure TformVendas.CalculaTotal;
var
  total:Double;
  i:integer;
begin
  //if StringGrid1.RowCount > 2 then
   begin
     total := 0;
     for i:=1 to StringGrid1.RowCount - 1 do
     begin
          total := strtofloat(StringGrid1.Cells[4, i]) + total;
     end;
   end;
  //else textTotalVenda.Text := '';
      {begin
           total := strtofloat(StringGrid1.Cells[4, i]);
           textTotalVenda.text := floattostr(total);
      end;}
   textTotalVenda.text := floattostr(total);
end;



end.

