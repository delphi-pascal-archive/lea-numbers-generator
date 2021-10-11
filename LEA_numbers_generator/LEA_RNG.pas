{-------------------------------------------------------------------------------

LEA-RNG

Auteur : Bacterius

G�n�rateur de nombres pseudo-al�atoires bas� sur l'algorithme de chiffrement LEA-128.

-------------------------------------------------------------------------------}

unit LEA_RNG;

interface

uses Windows, LEA_Hash;

{ Initialise le g�n�rateur }
procedure randomize;
{ R�cup�re un nombre pseudo-al�atoire compris entre 0 et Range (non inclus) }
function random(Range: Longword): Longword;

implementation

var
 Seed: Longword;

procedure randomize;
begin
 Seed := GetTickCount; { On se base sur le temps machine }
end;

function random(Range: Longword): Longword;
Var
 H: THash;
begin
 H := Hash(Seed, 4);            { On r�cup�re le hash de la valeur actuelle du g�n�rateur       }
 Seed := H.A + H.B + H.C + H.D; { On attribue � la valeur actuelle la somme des entiers du hash }
 Result := Seed mod Range;      { On r�cup�re une valeur entre 0 et Range exclus (avec "mod")   }
end;

end.