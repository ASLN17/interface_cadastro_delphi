unit venda.pessoa;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TPessoa }

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
      function funcao:String;

  end;

implementation

{ TPessoa }

function TPessoa.funcao: String;
begin
       result:='';
end;

end.

