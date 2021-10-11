{-------------------------------------------------------------------------------

LEA-RNG

Auteur : Bacterius

Générateur de nombres pseudo-aléatoires basé sur l'algorithme de chiffrement LEA-128.

-------------------------------------------------------------------------------}

unit LEA_RNG;

interface

uses Windows, LEA_Hash;

{ Initialise le générateur }
procedure randomize;
{ Récupère un nombre pseudo-aléatoire compris entre 0 et Range (non inclus) }
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
 H := Hash(Seed, 4);            { On récupère le hash de la valeur actuelle du générateur       }
 Seed := H.A + H.B + H.C + H.D; { On attribue à la valeur actuelle la somme des entiers du hash }
 Result := Seed mod Range;      { On récupère une valeur entre 0 et Range exclus (avec "mod")   }
end;

end.