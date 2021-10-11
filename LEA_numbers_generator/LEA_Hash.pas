{    Date : 05/06/2009 13:29:37
  Modifi� par Cirec pour assurer la compatibilit� avec unicode de Delphi2009                                  }
(*

Algorithme LEA-128 (Lossy Elimination Algorithm - Algorithme de perte de donn�es par �limination).
Auteur: Bacterius.

Algorithme de perte de donn�es par �limination : on �limine la donn�e et on en tire son empreinte.
Effectivement, cet algorithme va r�duire une donn�e de taille variable (de 1 octet, 12 m�gas, ou m�me
1 gigaoctet) en sa repr�sentation unique (de taille fixe : 16 octets). Chaque donn�e aura une
repr�sentation unique (th�oriquement : mais en pratique, il y aura toujours des collisions, car il
y a plus de possibilit�s de messages que de possibilit�s de hash : d'apr�s le principe des tiroirs).
Math�matiquement, si Hash(x) est la fonction par laquelle passe la donn�e x, et H le hash de cette
donn�e x, on a :

y <> x
Hash(x) = H
Hash(y) <> H

Cet algorithme de hachage est bas� sur un hachage octet par octet, c'est � dire
que chaque octet (caract�re) du message va changer le hachage. Voici un sch�ma :
________________________________________________________________________________

VALEURS DE DEPART  | MESSAGE
                   |
   A  B  C  D      |
   |  |  |  |      |
   ?  ?  ?  ?  <---- OCTET 1 DU MESSAGE (alt�ration de A, B, C, D)
   |  |  |  |      |
   ?  ?  ?  ?  <---- OCTET 2 DU MESSAGE (alt�ration de A, B, C, D)
   |  |  |  |      |
   ?  ?  ?  ?  <---- OCTET 3 DU MESSAGE (alt�ration de A, B, C, D)
   |  |  |  |      |
   ................. etc ...
   |  |  |  |      |
   W  X  Y  Z  <---- HACHAGES (alt�r�s)
   \  |  |  /      |
    Hachage    <---- de 128 bits, c'est la r�union de W, X, Y et Z (32 bits chacun)
________________________________________________________________________________

L'algorithme de hachage tient surtout � la fa�on dont sont alt�r�es les valeurs
A, B, C et D � chaque octet du message.
HashTable contient les 4 valeurs de d�part. Elles repr�sentent la "signature"
de l'algorithme. Si vous changez ces valeurs, les hachages changeront
�galement.
HashTransform associe � chaque valeur d'un octet (0..255) une valeur d'un double
mot. Si vous changez une ou plusieurs de ces valeurs, certains hachages risquent
d'�tre diff�rents.
Cet algorithme n'est pas sp�cialement rapide (environ 0.05 millisecondes le hachage
d'un message de 255 octets), et le test de collisions n'est pas termin�.
Comme pour tous les algorithmes de hash, on s'efforce de faire des hachages les
moins similaires possibles pour des petits changements. Essayez avec "a", puis "A",
puis "b", vous verrez !

� Les fonctions
- Hash : cette fonction effectue le hachage d'une donn�e Buffer, de taille Size.
         Il s'agit de la fonction de base pour hacher un message.
- HashToAnsiString : cette fonction convertit un hachage en une cha�ne lisible.
- AnsiStringToHash : cette fonction convertit une cha�ne lisible en hash, si celle-ci
                 peut correspondre � un hash. En cas d'erreur, toutes les valeurs
                 du hash sont nulles.
- SameHash     : cette fonction compare deux hachages et dit si celles-ci sont identiques.
                 Renvoie True le cas �ch�ant, False sinon.
- HashCrypt : cette fonction crypte un hachage tout en conservant son aspect.
- HashUncrypt : cette fonction d�crypte un hachage crypt� avec la bonne clef.
- IsHash : cette fonction v�rifie si la cha�ne pass�e peut �tre ou est un hachage.
- HashStr : cette fonction effectue le hachage d'une cha�ne de caract�res.
- HashInt : cette fonction effectue le hachage d'un entier sur 32 bits.
            Attention : la fonction effectue le hachage de l'entier directement,
            elle ne convertit absolument pas l'entier en texte !
- HashFile : cette fonction effectue le hachage du contenu d'un fichier.

� Collisions.
Dans tout algorithme de hachage existent des collisions. Cela d�coule logiquement
de l'affirmation suivante :
Il y a un nombre limit� de hachages possibles (2^128). Mais il existe une infinit�
de messages possibles, si l'on ne limite pas les caract�res.
Cependant, l'algorithme peut r�duire le nombre de collisions, qui, th�oriquement
infini, ne l'est pas � l'�chelle humaine. Si l'on suppose qu'� l'�chelle humaine,
nous ne tenons compte, sch�matiquement, de messages de 10 octets maximum (c'est
un exemple), l'on a une possibilit� de combinaisons de 255^10 octets, sur une
possibilit� de 2^128 hachages. Il est donc possible de n'avoir aucune collision,
puisqu'il y a plus de possibilit�s de hachages que de possibilit�s de combinaisons.

� Protection additionnelle
Un hash est d�j� th�oriquement impossible � inverser. Cependant, cela est possible
� l'�chelle mondiale avec un r�seau de super-calculateurs, moyennant tout de m�me
une quantit� de temps impressionnante (avec les 80 et quelques supercalculateurs
de IBM, l'on ne met que 84 ans � trouver le message (de 10 caract�res) correspondant
au hachage). Vous pouvez donc ajouter des protections suppl�mentaires :
- Le salage : cela consiste � ajouter une donn�e suppl�mentaire au message avant
  hachage. Cela rend le hachage moins vuln�rable aux attaques par dictionnaire.
  Par exemple, si vous avez un mot de passe "chat", quand quelqu'un va attaquer
  le hachage de "chat", il va rapidement le trouver dans le dictionnaire, va
  s'apercevoir que le hachage est le m�me, et va d�duire qu'il s'agit de votre
  mot de passe. Pour �viter �a, vous allez ajouter une donn�e moins �vidente au
  message, disons "QS77". Vous allez donc hacher le mot de passe "QS77chat"
  ( ou "chatQS77"). Ce mot ne figure evidemment pas dans le dictionnaire.
  Le pirate va donc avoir un probl�me, et va alors eventuellement laisser tomber,
  ou bien changer de technique, et attaquer par force brute (tester toutes les
  combinaisons possibles). Si vous avez un mot de passe de 5 caract�res ASCII, cela
  lui prendra au plus 5 jours. Si vous avez un mot de passe de 10 caract�res,
  cela mettra 70 milliards d'ann�es. Donc, optez pour un mot de passe d'au
  moins 6 caract�res (et eventuellement, rajoutez un caract�re sp�cial, comme
  un guillemet, pour forcer le pirate � attaquer en ASCII et non pas en
  alphanum�rique (il lui faudrait plus de temps de tester les 255 caract�res ASCII
  que seulement les 26 lettres de l'alphabet et les nombres ...)).
- Le cryptage : cela consiste � crypter le hachage par-dessus (tout en lui faisant garder
  son aspect de hachage ! Par exemple, si vous avez un hachage "A47F", n'allez
  pas le crypter en "%E#!", il appara�trait evident qu'il est crypt� !).
  Cela a pour effet de compliquer encore plus le travail du pirate, qui,
  inconsciemment, sera en train d'essayer de percer un mauvais hachage !
  Si le cryptage est bien r�alis�, il peut s'av�rer plus qu'efficace. Cependant,
  pensez � conserver la clef de cryptage/d�cryptage, sans quoi, si pour une raison
  ou pour une autre vous aviez � r�cup�rer le hash d'origine (cela peut arriver parfois),
  vous devriez tester toutes les clefs ...
  Une fonction de cryptage et une de d�cryptage est fournie dans cette unit�.
- Le byteswap : cela consiste � "swapper" les octets du hachage. Cela revient �
  crypter le hachage puisque cette op�ration est r�versible "permutative" (la
  fonction de cryptage joue �galement le r�le de la fonction de d�cryptage).

Ajouter une petite protection ne co�te rien de votre c�t�, et permet de se prot�ger
plus qu'efficacement contre des attaques. M�me si un hash en lui-m�me est d�j� pas
mal, mieux vaut trop que pas assez !

� Autres utilit�s du hash
- g�n�rateur de nombres al�atoires : l'algorithme de hachage est si particulier
pour le MD5 par exemple, qu'il a �t� d�clar� comme efficace en tant que g�n�rateur
de nombres pseudo-al�atoires, et il a pass� avec succ�s tous les tests statistiques.
L'algorithme LEA n'est pas garanti d'�tre efficace comme g�n�rateur de nombres
pseudo-al�atoires.

} *)

unit LEA_Hash;

interface

uses Windows, SysUtils, Dialogs;

const
  { Ces valeurs sont pseudo-al�atoires (voir plus bas) et sont distinctes (pas de doublon) }
  { Notez que le hachage d'une donn�e nulle (de taille 0) renverra HashTable (aucune alt�ration) }
  HashTable: array [0..3] of Longword = ($CF306227, $4FCE8AC8, $ACE059ED, $4E3079A6);
  { MODIFIER CES VALEURS ENTRAINERA UNE MODIFICATION DE TOUS LES HACHAGES }

const
  { Ces valeurs sont pr�calcul�es sur la base du polynome du nombre $3E8A42F7 }
  HashTransform: array [0..255] of Longword = (
  $3E8A42F7,$181354AB,$3026A956,$2835FDFD,$1D59D743,$054A83E8,$2D7F7E15,$356C2ABE,
  $3AB3AE86,$22A0FA2D,$0A9507D0,$1286537B,$27EA79C5,$3FF92D6E,$17CCD093,$0FDF8438,
  $0873D8E3,$10608C48,$385571B5,$2046251E,$152A0FA0,$0D395B0B,$250CA6F6,$3D1FF25D,
  $32C07665,$2AD322CE,$02E6DF33,$1AF58B98,$2F99A126,$378AF58D,$1FBF0870,$07AC5CDB,
  $10E7B1C6,$08F4E56D,$20C11890,$38D24C3B,$0DBE6685,$15AD322E,$3D98CFD3,$258B9B78,
  $2A541F40,$32474BEB,$1A72B616,$0261E2BD,$370DC803,$2F1E9CA8,$072B6155,$1F3835FE,
  $18946925,$00873D8E,$28B2C073,$30A194D8,$05CDBE66,$1DDEEACD,$35EB1730,$2DF8439B,
  $2227C7A3,$3A349308,$12016EF5,$0A123A5E,$3F7E10E0,$276D444B,$0F58B9B6,$174BED1D,
  $21CF638C,$39DC3727,$11E9CADA,$09FA9E71,$3C96B4CF,$2485E064,$0CB01D99,$14A34932,
  $1B7CCD0A,$036F99A1,$2B5A645C,$334930F7,$06251A49,$1E364EE2,$3603B31F,$2E10E7B4,
  $29BCBB6F,$31AFEFC4,$199A1239,$01894692,$34E56C2C,$2CF63887,$04C3C57A,$1CD091D1,
  $130F15E9,$0B1C4142,$2329BCBF,$3B3AE814,$0E56C2AA,$16459601,$3E706BFC,$26633F57,
  $3128D24A,$293B86E1,$010E7B1C,$191D2FB7,$2C710509,$346251A2,$1C57AC5F,$0444F8F4,
  $0B9B7CCC,$13882867,$3BBDD59A,$23AE8131,$16C2AB8F,$0ED1FF24,$26E402D9,$3EF75672,
  $395B0AA9,$21485E02,$097DA3FF,$116EF754,$2402DDEA,$3C118941,$142474BC,$0C372017,
  $03E8A42F,$1BFBF084,$33CE0D79,$2BDD59D2,$1EB1736C,$06A227C7,$2E97DA3A,$36848E91,
  $3E8A42F7,$2699165C,$0EACEBA1,$16BFBF0A,$23D395B4,$3BC0C11F,$13F53CE2,$0BE66849,
  $0439EC71,$1C2AB8DA,$341F4527,$2C0C118C,$19603B32,$01736F99,$29469264,$3155C6CF,
  $36F99A14,$2EEACEBF,$06DF3342,$1ECC67E9,$2BA04D57,$33B319FC,$1B86E401,$0395B0AA,
  $0C4A3492,$14596039,$3C6C9DC4,$247FC96F,$1113E3D1,$0900B77A,$21354A87,$39261E2C,
  $2E6DF331,$367EA79A,$1E4B5A67,$06580ECC,$33342472,$2B2770D9,$03128D24,$1B01D98F,
  $14DE5DB7,$0CCD091C,$24F8F4E1,$3CEBA04A,$09878AF4,$1194DE5F,$39A123A2,$21B27709,
  $261E2BD2,$3E0D7F79,$16388284,$0E2BD62F,$3B47FC91,$2354A83A,$0B6155C7,$1372016C,
  $1CAD8554,$04BED1FF,$2C8B2C02,$349878A9,$01F45217,$19E706BC,$31D2FB41,$29C1AFEA,
  $1F45217B,$075675D0,$2F63882D,$3770DC86,$021CF638,$1A0FA293,$323A5F6E,$2A290BC5,
  $25F68FFD,$3DE5DB56,$15D026AB,$0DC37200,$38AF58BE,$20BC0C15,$0889F1E8,$109AA543,
  $1736F998,$0F25AD33,$271050CE,$3F030465,$0A6F2EDB,$127C7A70,$3A49878D,$225AD326,
  $2D85571E,$359603B5,$1DA3FE48,$05B0AAE3,$30DC805D,$28CFD4F6,$00FA290B,$18E97DA0,
  $0FA290BD,$17B1C416,$3F8439EB,$27976D40,$12FB47FE,$0AE81355,$22DDEEA8,$3ACEBA03,
  $35113E3B,$2D026A90,$0537976D,$1D24C3C6,$2848E978,$305BBDD3,$186E402E,$007D1485,
  $07D1485E,$1FC21CF5,$37F7E108,$2FE4B5A3,$1A889F1D,$029BCBB6,$2AAE364B,$32BD62E0,
  $3D62E6D8,$2571B273,$0D444F8E,$15571B25,$203B319B,$38286530,$101D98CD,$080ECC66);
  { MODIFIER CES VALEURS PEUT ENTRAINER UNE MODIFICATION DE CERTAINS HACHAGES }

type
  THash = record          { La structure d'un hash LEA sur 128 bits }
   A, B, C, D: Longword;  { Les quatre double mots                  }
  end;

function Hash         (const Buffer; const Size: Longword): THash;
function HashStr      (const Str     : AnsiString  ): THash;
function HashInt      (const Int     : Integer ): THash;
function HashFile     (const FilePath: String  ): THash;
function HashToString (const Hash    : THash   ): AnsiString;
function StringToHash (const Str     : AnsiString  ): THash;
function SameHash     (const A, B    : THash   ): Boolean;
function Same         (A, B: Pointer; SzA, SzB: Longword): Boolean;
function HashCrypt    (const Hash    : AnsiString;  Key: Integer): AnsiString;
function HashUncrypt  (const Hash    : AnsiString;  Key: Integer): AnsiString;
function IsHash       (const Hash    : AnsiString  ): Boolean;

implementation

function Hash(const Buffer; const Size: Longword): THash;
Var
 V: PByte;
 E: Pointer;
begin
 { Etapes du hachage : on va r�cup�rer 4 valeurs de d�part A, B, C, D de 32 bits
   provenant du tableau HashTable. Ce sont les "vecteurs d'initialisation". On va alors
   alt�rer ces valeurs � l'aide du message contenu dans Buffer. Plusieurs alt�rations sont
   n�cessaires. Ensuite, on reconstitue l'empreinte en mettant bout � bout les 4 valeurs de
   32 bits obtenues. }

 { On r�cup�re les valeurs du tableau }
 Move(HashTable, Result, 16);

 { Si buffer vide, on a les valeurs initiales }
 if Size = 0 then Exit;

 { On prend le premier octet du buffer }
 V := @Buffer;
 { On calcule le dernier octet du buffer }
 E := Ptr(Longword(@Buffer) + Size);

 with Result do
  repeat { Pour chaque octet, tant qu'on est pas arriv� � la fin ... }
   begin
    { On effectue une alt�ration complexe }
    A := (A shl 5) xor (D shr  2) or V^ + B;
    B := (B shl 2) xor (C shr 11) or V^ + A;
    C := (C shl 7) xor (A shr  4) or V^ + D;
    D := (D shl 8) xor (B shr 14) or V^ + C;
    Inc(A, (HashTransform[V^] xor D) + (C xor (D or (not B))));
    Inc(B, (HashTransform[V^] xor C) + (D xor (B or (not A))));
    Inc(C, (HashTransform[V^] xor B) + (A xor (C or (not D))));
    Inc(D, (HashTransform[V^] xor A) + (B xor (A or (not C))));
    Inc(V); { On passe � l'octet suivant ! }
    { Ne pas modifier les 8 lignes de calcul, sinon cela peut ne plus marcher }
   end
  until V = E;
end;

function HashStr(const Str: AnsiString): THash;
begin
 { On va envoyer le pointeur sur la cha�ne � la fonction Hash. }
 Result := Hash(PAnsiChar(Str)^, Length(Str));
end;

function HashInt(const Int: Integer): THash;
begin
 { On envoie directement le nombre dans le buffer. }
 Result := Hash(Int, SizeOf(Integer));
end;

function HashFile(const FilePath: String): THash;
Var
 H, M: Longword;
 P: Pointer;
begin
 { On va mettre � 0 pour cette fonction, car autant il n'�tait pas possible que les fonctions
   pr�c�dentes n'�chouent, celle-ci peut �chouer pour diverses raisons. }
 ZeroMemory(@Result, 16);

 { On ouvre le fichier }
 H := CreateFile(PChar(FilePath), GENERIC_READ, FILE_SHARE_READ or FILE_SHARE_WRITE,
                 nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);

 { Si erreur d'ouverture, on s'en va }
 if H = INVALID_HANDLE_VALUE then Exit;
 { CreateFileMapping rejette les fichiers de taille 0 : ainsi, on doit les tester avant }
 if GetFileSize(H, nil) = 0 then
  begin
   Result := Hash('', 0); { On r�cup�re un hash nul }
   CloseHandle(H);        { On lib�re le handle }
   Exit;
  end;

 { On cr�e une image m�moire du fichier }
 try
  M := CreateFileMapping(H, nil, PAGE_READONLY, 0, 0, nil);
  try
   { On r�cup�re un pointeur sur l'image du fichier en m�moire }
   if M = 0 then Exit;
   P := MapViewOfFile(M, FILE_MAP_READ, 0, 0, 0);
   try
    { On envoie le pointeur au hash, avec comme taille de buffer la taille du fichier }
    if P = nil then Exit;
    Result := Hash(P^, GetFileSize(H, nil));
   finally
   { On lib�re tout ... }
   UnmapViewOfFile(P);
   end;
  finally
   CloseHandle(M);
  end;
 finally
  CloseHandle(H);
 end;
end;

function HashToString(const Hash: THash): AnsiString;
begin
 { On ajoute les quatre entiers l'un apr�s l'autre sous forme h�xad�cimale ... }
 Result := AnsiString(Format('%.8x%.8x%.8x%.8x', [Hash.A, Hash.B, Hash.C, Hash.D]));
end;

function StringToHash(const Str: AnsiString): THash;
begin
 if IsHash(Str) then
  with Result do
   begin
    { Astuce de Delphi : un HexToInt sans trop de probl�mes ! Rajouter un "$" devant le nombre et
     appeller StrToInt. Cette astuce accepte un maximum de 8 caract�res apr�s le signe "$".      }
    A := StrToInt(Format('$%s', [Copy(Str, 1, 8)]));
    B := StrToInt(Format('$%s', [Copy(Str, 9, 8)]));
    C := StrToInt(Format('$%s', [Copy(Str, 17, 8)]));
    D := StrToInt(Format('$%s', [Copy(Str, 25, 8)]));
   end
 else ZeroMemory(@Result, 16); { Si Str n'est pas un hash, on met tout � 0 }
end;

function SameHash(const A, B: THash): Boolean;
begin
 { On compare les deux hashs ... }
 Result := CompareMem(@A, @B, 16);
end;

function Same(A, B: Pointer; SzA, SzB: Longword): Boolean;
begin
 { Cette fonction va regarder si deux objets m�moire (d�finis par leur pointeur de d�but
   et leur taille) sont identiques en comparant leur hash. }
 Result := SameHash(Hash(A, SzA), Hash(B, SzB));
end;

const
 Z = #0; { Le caract�re nul, plus pratique de l'appeller Z que de faire chr(0) ou #0 }

function hxinc(X: AnsiChar): AnsiChar; { Incr�mentation h�xad�cimale }
const
 XInc: array [48..70] of AnsiChar = ('1', '2', '3', '4', '5', '6', '7', '8', '9', 'A',
                                      Z, Z, Z, Z, Z, Z, Z, 'B', 'C', 'D', 'E', 'F', '0');
begin
 if ord(X) in [48..57, 65..70] then Result := XInc[ord(X)] else Result := Z;
end;

function hxdec(X: AnsiChar): AnsiChar; { D�cr�mentation h�xad�cimale ... }
const
 XDec: array [48..70] of AnsiChar = ('F', '0', '1', '2', '3', '4', '5', '6', '7', '8',
                                      Z, Z, Z, Z, Z, Z, Z, '9', 'A', 'B', 'C', 'D', 'E');
begin
 if ord(X) in [48..57, 65..70] then Result := XDec[ord(X)] else Result := Z;
end;

function HashCrypt(const Hash: AnsiString; Key: Integer): AnsiString;
Var
 I, J: Integer;
 S: AnsiString;
 P: Integer;
begin
 { Cryptage avec une clef alphanum�rique - comme le cryptage de C�sar ! }
 Result := '';
 if not IsHash(Hash) then Exit;
 Result := AnsiString(Uppercase(String(Hash)));
 S := AnsiString(IntToStr(Key));
 P := 0;
 for I := 1 to Length(Hash) do
  begin
   Inc(P);
   if P = Length(S) + 1 then P := 1;
   for J := 1 to StrToInt(String(S[P])) do Result[I] := hxinc(Result[I]);
  end;
end;

function HashUncrypt(const Hash: AnsiString; Key: Integer): AnsiString;
Var
 I, J: Integer;
 S: AnsiString;  
 P: Integer;
begin
 { D�cryptage ... }
 Result := '';
 if not IsHash(Hash) then Exit;
 Result := AnsiString(Uppercase(String(Hash)));
 S := AnsiString(IntToStr(Key));
 P := 0;
 for I := 1 to Length(Hash) do
  begin
   Inc(P);
   if P = Length(S) + 1 then P := 1;
   for J := 1 to StrToInt(String(S[P])) do Result[I] := hxdec(Result[I]);
  end;
end;

function IsHash(const Hash: AnsiString): Boolean;
Var
 I: Integer;
begin
 { V�rification de la validit� de la cha�ne comme hash. }
 Result := False;
 if Length(Hash) <> 32 then Exit; { Si la taille est diff�rente de 32, c'est d�j� mort ... }
 { Si l'on rencontre un seul caract�re qui ne soit pas dans les r�gles, on s'en va ... }
 {$ifndef unicode}
 for I := 1 to 32 do if not (Hash[I] in ['0'..'9', 'A'..'F', 'a'..'f']) then Exit;
 {$else}
 for I := 1 to 32 do if not CharInSet(Hash[I], ['0'..'9', 'A'..'F', 'a'..'f']) then Exit;
 {$endif}
 { Si la chaine a pass� tous les tests, c'est bon ! }
 Result := True;
end;

end.