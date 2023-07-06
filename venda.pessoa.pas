unit venda.pessoa;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  TPessoa=class(TObject)

	private
		FIdade:Integer;
		FNome:String;
    FLougradouro:String;
    FNumero:String;
    FCidade:String;
    public
      property Idade:Integer read FIdade write FIdade;
      property Nome:String read FNome write FNome;

  end;

implementation

end.

