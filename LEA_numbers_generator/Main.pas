unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, LEA_RNG;

type
  TMainForm = class(TForm)
    InfoLbl: TLabel;
    DelphiBox: TGroupBox;
    DelphiBtn: TButton;
    LEABox: TGroupBox;
    LEABtn: TButton;
    SepBevel: TBevel;
    NumberList: TListBox;
    InfoLbl3: TLabel;
    QuitBtn: TButton;
    InfoLbl2: TLabel;
    IntervalEdit: TEdit;
    procedure QuitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NewList(Sender: TObject);
    procedure IntervalEditKeyPress(Sender: TObject; var Key: Char);
    procedure IntervalEditChange(Sender: TObject);
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.QuitBtnClick(Sender: TObject);
begin
 Close; { On ferme l'application }
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
 System.randomize;  { On initialise le g�n�rateur de Delphi }
 LEA_RNG.randomize; { On initialise notre g�n�rateur � nous }
end;

procedure TMainForm.NewList(Sender: TObject);
Var
 I, V: Integer;
begin
 if Sender is TButton then with TButton(Sender) do
   with NumberList do
   try
    Items.BeginUpdate;
    Items.Clear;
    V := StrToInt(IntervalEdit.Text); { On r�cup�re la borne sup�rieure de l'intervalle }
    for I := 1 to 21 do               { Pour les 21 nombres que l'on d�sire tirer ...   }
     case TButton(Sender).Tag of
      0: Items.Add(IntToStr(System.random(V)));  { Si premier bouton, on prend le g�n�rateur Delphi }
      1: Items.Add(IntToStr(LEA_RNG.random(V))); { Si deuxi�me bouton, on prend le g�n�rateur LEA   }
     end;
   finally
    Items.EndUpdate;
   end;
end;

procedure TMainForm.IntervalEditKeyPress(Sender: TObject; var Key: Char);
begin
 if not (Key in ['0'..'9', #8]) then Key := #0;
 { Evite d'entrer autre chose que des nombres pour l'intervalle }
end;

procedure TMainForm.IntervalEditChange(Sender: TObject);
begin
 { L'intervalle doit �tre strictement positif, et ne doit pas exc�der la borne sup�rieure du type
   Longword. Si l'intervalle est �crit en vert, on peut g�n�rer les nombres. Sinon, l'intervalle
   est incorrect et l'on ne peut pas g�n�rer les nombres.                                         }
 if StrToIntDef(IntervalEdit.Text, 0) = 0 then IntervalEdit.Font.Color := clRed else
  IntervalEdit.Font.Color := clGreen;

 DelphiBtn.Enabled := (IntervalEdit.Font.Color = clGreen);
 LEABtn.Enabled := (IntervalEdit.Font.Color = clGreen);
end;

end.
