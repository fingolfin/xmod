#############################################################################
##
#W  isclnc.gi                 GAP4 package `XMod'               
#W                                                                
##  version 2.43, 27/08/2015 
##
#Y  Copyright (C) 2001-2015,   
#Y   
##
## 
##  
##

#############################################################################
##
#M  TG  . . . . . . . . . the TG group of crossed module (d,T,G)
##
InstallMethod( TG, "generic method for crossed modules", true, 
	[ Is2dGroup ], 0,
function( XM )

local alpha,sonuc,T,G,t,g,list;

T := Source(XM);
G := Range(XM);
alpha := XModAction(XM);
list := [];

for t in T do
		if (ForAll(G,g -> Image(Image(alpha,g),t)=t)) then
		Add(list,t);
		fi;		
od; 
  ### If the list consist only the identity element then there is a bug in the function AsMagma. 
  if Set(list) = [ () ] then
		return Subgroup(Source(XM),[()]);
  fi;
  ###
return AsGroup(list);
end );
       
#############################################################################
##
#M  stGT  . . . . . . . . . the stGT group of crossed module (d,T,G)
##
InstallMethod( stGT,
    "generic method for crossed modules", true, [ Is2dGroup ], 0,
function( XM )

local alpha,sonuc,T,G,t,g,list;

T := Source(XM);
G := Range(XM);
alpha := XModAction(XM);
list := [];
for g in G do
		if (ForAll(T,t -> Image(Image(alpha,g),t)=t)) then
		Add(list,g);
		fi;		
od;
  ### If the list consist only the identity element then there is a bug in the function AsMagma.  
  if Set(list) = [ () ] then
		return Subgroup(Range(XM),[()]);
  fi;
  ###
return AsGroup(list);
end );

#############################################################################
##
#M  CenterXMod  . . . . . . . . . the center of crossed module
##
InstallMethod( CenterXMod,
    "generic method for crossed modules", true, [ Is2dGroup ], 0,
function( XM )

local alpha, T, G, partial, k_partial, k_alpha, PM, K;
T := Source(XM);
G := Range(XM);
alpha := XModAction(XM);
partial := Boundary(XM);
K := Intersection(Center(G),stGT(XM));

k_partial := GroupHomomorphismByFunction( TG(XM), K, x -> Image(partial,x) );
k_alpha := GroupHomomorphismByFunction( K, AutomorphismGroup(TG(XM)), x -> Image(alpha,x) );

return XMod(k_partial,k_alpha);
end );

#############################################################################
##
#M  AllHomomorphismsViaSmallGroup  . . . . . . . . . all isomorphisms by using small group library.
## We use small group library since the function AllHomomorphisms fails for some groups G and H.
##
InstallMethod( AllHomomorphismsViaSmallGroup,
    "generic method for crossed modules", true, [ IsGroup, IsGroup ], 0,
function( G,H )

local A,B,a,b,h,f,i,sonuc;

if IsomorphismGroups(G,H) = fail  then
	Print("",G," !~ ",G," \n" );
	sonuc := [];
	return sonuc;
fi;

A := SmallGroup(IdGroup(G));
B := SmallGroup(IdGroup(H));
if ( Size(A) = 1 ) then
	sonuc := [];
	Add(sonuc,IsomorphismGroups(G,H));
else
	h := AllHomomorphisms(A,B);
	f := Filtered(h,IsBijective);
	a := IsomorphismGroups(G,A);
	b := IsomorphismGroups(B,H);
	sonuc := List(f, i -> CompositionMapping(b,i,a));
fi;	
return sonuc;
end );

#############################################################################
##
#M  DGT  . . . . . . . . . the DGT group of crossed module (d,T,G)
##
InstallMethod( DGT,
    "generic method for crossed modules", true, [ Is2dGroup ], 0,
function( XM )

local alpha,sonuc,T,G,t,g,list;

T := Source(XM);
G := Range(XM);
alpha := XModAction(XM);
list := [];

for t in T do
		for g in G do
		Add(list,Image(Image(alpha,g),t)*t^-1);
		od;
od;
  ### If the list consist only the identity element then there is a bug in the function AsMagma. 
  if Set(list) = [ () ] then
		return Subgroup(Source(XM),[()]);
  fi;
  ###
return AsGroup(list);
end );

#############################################################################
##
#M  IntersectionSubXMod  . . . . . . . . . the intersection of the subcrossed modules SH and RK
##
InstallMethod( IntersectionSubXMod,
    "generic method for crossed modules", true, [ Is2dGroup, Is2dGroup, Is2dGroup ], 0,
function(XM,SH,RK)

local alpha, T, G, S, H, R, K,  partial, k_partial, k_alpha, SR, HK;

T := Source(XM);
G := Range(XM);
alpha := XModAction(XM);
partial := Boundary(XM);
S := Source(SH);
H := Range(SH);
R := Source(RK);
K := Range(RK);

SR := Intersection(S,R);
HK := Intersection(H,K);

k_partial := GroupHomomorphismByFunction( SR, HK, x -> Image(partial,x) );
k_alpha := GroupHomomorphismByFunction( HK, AutomorphismGroup(SR), x -> Image(alpha,x) );

return PreXModObj(k_partial,k_alpha);
end );

#############################################################################
##
#M  DerivedSubXMod  . . . . . . . . . the commutator of the crossed module
##
InstallMethod( DerivedSubXMod,
    "generic method for crossed modules", true, [ Is2dGroup ], 0,
function(XM)

local alpha, T, G, partial, k_partial, k_alpha, PM, D;

T := Source(XM);
G := Range(XM);
D := DerivedSubgroup(G);
alpha := XModAction(XM);
partial := Boundary(XM);

k_partial := GroupHomomorphismByFunction( DGT(XM), D, x -> Image(partial,x) );
k_alpha := GroupHomomorphismByFunction( D, AutomorphismGroup(DGT(XM)), x -> Image(alpha,x) );

return XMod(k_partial,k_alpha);
end );

#############################################################################
##
#M  CommSubXMod  . . . . . . . . . the commutator subcrossed module of the normal subcrossed modules SH and RK
##
InstallMethod( CommSubXMod,
    "generic method for crossed modules", true, [ Is2dGroup, Is2dGroup, Is2dGroup ], 0,
function(XM,SH,RK)

local alpha, T, G, S, H, R, K,  partial, k_partial, k_alpha, s,k,r,h,DKS_DHR, KomHK,list;
T := Source(XM);
G := Range(XM);
alpha := XModAction(XM);
partial := Boundary(XM);
S := Source(SH);
H := Range(SH);
R := Source(RK);
K := Range(RK);
list := [];
## for elements of DKS and DHR 
for s in S do
		for k in K do
		Add(list,Image(Image(alpha,k),s)*s^-1);
		od;
od;
for r in R do
		for h in H do
		Add(list,Image(Image(alpha,h),r)*r^-1);
		od;
od;
list := Set(list);
  ### If the list consist only the identity element then there is a bug in the function AsMagma. 
  if Set(list) = [ () ] then
		DKS_DHR := Subgroup(Source(XM),[()]);
  else
		DKS_DHR := AsGroup(list);
  fi;
  ###
KomHK := CommutatorSubgroup(H,K);

k_partial := GroupHomomorphismByFunction( DKS_DHR, KomHK, x -> Image(partial,x) );
k_alpha := GroupHomomorphismByFunction( KomHK, AutomorphismGroup(DKS_DHR), x -> Image(alpha,x) );

return PreXModObj(k_partial,k_alpha);
end );

#############################################################################
##
#M  LowerCentralSeriesOfXMod  . . . . . . . . . the lower central series of the crossed module
##
InstallMethod( LowerCentralSeriesOfXMod,
    "generic method for crossed modules", true, [ Is2dGroup ], 0,
function(XM)

local liste, C;

    liste := [ XM ];
    C := DerivedSubXMod( XM );
  #  while (IsEqualXMod(C,liste[Length(liste)]) = false)  do
  while ( C <> liste[Length(liste)] )  do
        Add( liste, C );
        C := CommSubXMod( XM, C, XM );
    od;

    return liste;
	end );
	
#############################################################################
##
#M  IsNilpotentXMod  . . . . . . . . . check that the crossed module is nilpotent
##
InstallMethod( IsNilpotentXMod,
    "generic method for crossed modules", true, [ Is2dGroup ], 0,
function(XM)

local S,n,sonuc;

    S := LowerCentralSeriesOfXMod( XM );
	n := Length(S);
	if ( Size(S[n]) = [1,1] ) then
		sonuc := true;
	else
		sonuc := false;
	fi;
return sonuc;
end );

#############################################################################
##
#M  NilpotencyClassOfXMod  . . . . . . . . . the nilpotency degree of the crossed module
##
InstallMethod( NilpotencyClassOfXMod,
    "generic method for crossed modules", true, [ Is2dGroup ], 0,
function(XM)

local sonuc;

	if not IsNilpotentXMod(XM) then
		sonuc := 0;
	else
	sonuc := Length(LowerCentralSeriesOfXMod(XM))-1;		
	fi;
			
return sonuc;
end );

#############################################################################
##
#M  CorrespondingMap  . . . . . . . . . the tool for quotient crossed module
##
InstallMethod( CorrespondingMap,
    "generic method for crossed modules", true, [ IsGroup, IsGroup ], 0,
function(G,N)

local liste1,liste2,B,eB,nhom,i,f;

liste1 := [];
liste2 := [];
nhom := NaturalHomomorphismByNormalSubgroup(G,N);
B := Image(nhom); 	# G/N 
eB := Elements(B);
	for i in [1..Size(B)] do
	Add(liste1,Representative(PreImages(nhom,eB[i])));
	Add(liste2,eB[i]);	
	od;
f := MappingByFunction(Domain(liste1),Domain(liste2), i -> liste2[Position(liste1,i)]);
return f;
end );

#############################################################################
##
#M  FactorXMod  . . . . . . . . . the quotient crossed module
##
InstallMethod( FactorXMod,
    "generic method for crossed modules", true, [ Is2dGroup, Is2dGroup ], 0,
function(XM,PM)

local alpha1,alpha2,partial1,partial2,nhom1,nhom2,T,G,S,H,B1,B2,bdy,act,a,f1,f2,b,c,liste;

alpha1 := XModAction(XM);
partial1 := Boundary(XM);
T := Source(XM);
G := Range(XM);
alpha2 := XModAction(PM);
partial2 := Boundary(PM);
S := Source(PM);
H := Range(PM);
nhom1 := NaturalHomomorphismByNormalSubgroup(T,S);
nhom2 := NaturalHomomorphismByNormalSubgroup(G,H);
B1 := Image(nhom1); # T/S bölüm grubu
B2 := Image(nhom2); # G/H bölüm grubu
f1 := CorrespondingMap(T,S);
f2 := CorrespondingMap(G,H);

bdy := GroupHomomorphismByFunction(B1,B2, a ->  Image(nhom2,Image(partial1,Representative(PreImages(nhom1,a)))));
act := GroupHomomorphismByFunction(B2, AutomorphismGroup(B1), b -> GroupHomomorphismByFunction(B1, B1, c -> Image(nhom1,(Image(Image(alpha1,Representative(PreImages(nhom2,b))),Representative(PreImages(nhom1,c)))) )) );

return XMod(bdy,act);
end );

#############################################################################
##
#M  IsIsoclinicXMod  . . . . . . . . . check that the given crossed modules are isoclinic
##
InstallMethod( IsIsoclinicXMod,
    "generic method for crossed modules", true, [ Is2dGroup, Is2dGroup ], 0,
function(XM1,XM2)

local cakma3,cakma4,kG12,kG11,T,G,S,H,sonuc,kT11,kT12,cakma,cakma2,yeni_iso,x,y,z1,z2,gz1,gz2,gx,gy,gor1,gor2,pisi0,pisi1,nisi1,nisi0,nhom1,nhom2,nhom3,nhom4,ComXM1,ComXM2,MXM1,MXM2,BXM1,BXM2,b1,a1,T1,G1,b2,a2,T2,G2,alpha1,phi1,m1_ler,m2_ler,m1,m2,b11,a11,T11,G11,b12,a12,T12,G12,alpha11,phi11,m11,alp,ph;

sonuc := true;

T := Source(XM1);
G := Range(XM1);
S := Source(XM2);
H := Range(XM2);

ComXM1 := DerivedSubXMod(XM1);
ComXM2 := DerivedSubXMod(XM2);
	b1 := Boundary(ComXM1);
	a1 := XModAction(ComXM1);
	T1 := Source(ComXM1);
	G1 := Range(ComXM1);
	b2 := Boundary(ComXM2);
	a2 := XModAction(ComXM2);
	T2 := Source(ComXM2);
	G2 := Range(ComXM2);
	
	if IsomorphismGroups(T1,T2) = fail  then
	#Print("T1 !~ T2 \n" );
	sonuc := false;
	return sonuc;
	fi;

	if IsomorphismGroups(G1,G2) = fail  then
	#Print("G1 !~ G2 \n" );
	sonuc := false;
	return sonuc;
	fi;

MXM1 := CenterXMod(XM1);
MXM2 := CenterXMod(XM2);
BXM1 := FactorXMod(XM1,MXM1); 
BXM2 := FactorXMod(XM2,MXM2); 
		b11 := Boundary(BXM1);
		a11 := XModAction(BXM1);
		T11 := Source(BXM1);
		G11 := Range(BXM1);
		b12 := Boundary(BXM2);
		a12 := XModAction(BXM2);
		T12 := Source(BXM2);
		G12 := Range(BXM2);
		
	if IsomorphismGroups(T11,T12) = fail  then
	#Print("T11 !~ T12 \n" );
	sonuc := false;
	return sonuc;
	fi;

		
	if IsomorphismGroups(G11,G12) = fail  then
	#Print("G11 !~ G12 \n" );
	sonuc := false;
	return sonuc;
	fi;
	
	alpha1 := AllHomomorphismsViaSmallGroup(T1,T2);	
	phi1 := AllHomomorphismsViaSmallGroup(G1,G2);	
	m1_ler := [];		
	for alp in alpha1 do
		for ph in phi1 do
			if ( IsPreXModMorphism(Make2dGroupMorphism(ComXM1,ComXM2,alp,ph)) ) then
			Add(m1_ler,PreXModMorphism(ComXM1,ComXM2,alp,ph));
			fi;
		od;
	od;	
	
		m1_ler := Filtered(m1_ler,IsXModMorphism);
		
		if Length(m1_ler) = 0 then
		#Print("There is no morphism \n");
		return false;
		fi;
	
	alpha11 := AllHomomorphismsViaSmallGroup(T11,T12);
	phi11 := AllHomomorphismsViaSmallGroup(G11,G12);	
	m2_ler := [];		
	for alp in alpha11 do
		for ph in phi11 do
			if ( IsPreXModMorphism(Make2dGroupMorphism(BXM1,BXM2,alp,ph)) ) then
			Add(m2_ler,PreXModMorphism(BXM1,BXM2,alp,ph));
			fi;
		od;
	od;
			
		if Length(m2_ler) = 0 then
		#Print("There is no morphism \n");
		return false;
		fi;
	
			
nhom1 := NaturalHomomorphismByNormalSubgroup(G,Intersection(Center(G),stGT(XM1)));;
kG11 := Image(nhom1);
cakma3 := GroupHomomorphismByImages(kG11,G11,GeneratorsOfGroup(kG11),GeneratorsOfGroup(G11));

nhom2 := NaturalHomomorphismByNormalSubgroup(H,Intersection(Center(H),stGT(XM2)));;
kG12 := Image(nhom2);
cakma4 := GroupHomomorphismByImages(G12,kG12,GeneratorsOfGroup(G12),GeneratorsOfGroup(kG12));

nhom3 := NaturalHomomorphismByNormalSubgroup(T,TG(XM1));;
kT11 := Image(nhom3); 
cakma := GroupHomomorphismByImages(kT11,T11,GeneratorsOfGroup(kT11),GeneratorsOfGroup(T11));

nhom4 := NaturalHomomorphismByNormalSubgroup(S,TG(XM2));;
kT12 := Image(nhom4);
cakma2 := GroupHomomorphismByImages(T12,kT12,GeneratorsOfGroup(T12),GeneratorsOfGroup(kT12));

	for m2 in m2_ler do
		nisi1 := SourceHom( m2 );
		nisi0 := RangeHom( m2 );
	for m1 in m1_ler do
		pisi1 := SourceHom(m1);
		pisi0 := RangeHom(m1);
		
	sonuc := true;
	yeni_iso := false;	
	
	### start check diagram 1	
	
	for z1 in kT11 do
			x := Representative(PreImages(nhom3,z1));
			gz1 := Image(nisi1,Image(cakma,z1));
			gx := Representative(PreImages(nhom4,Image(cakma2,gz1)));
		for z2 in kG11 do
			y := Representative(PreImages(nhom1,z2));
			gz2 := Image(nisi0,Image(cakma3,z2));
			gy := Representative(PreImages(nhom2,Image(cakma4,gz2)));	

				gor1 := Image(pisi1,Image(Image(XModAction(XM1),y),x)*x^-1);	
				gor2 := Image(Image(XModAction(XM2),gy),gx)*gx^-1;
	
			if (gor1 <> gor2) then
				sonuc := false;
				yeni_iso := true;
				break;			
			fi;
		
		od;
		
		if ( yeni_iso = true ) then		
		break;
		fi;
	od;

	### end check diagram 1

		if ( yeni_iso = true ) then		
		break;
		fi;
	
	### start check diagram 2	
	
	for z1 in kG11 do

			x := Representative(PreImages(nhom1,z1));
			gz1 := Image(nisi0,Image(cakma3,z1));
			gx := Representative(PreImages(nhom2,Image(cakma4,gz1)));
		for z2 in kG11 do
			y := Representative(PreImages(nhom1,z2));
			gz2 := Image(nisi0,Image(cakma3,z2));
			gy := Representative(PreImages(nhom2,Images(cakma4,gz2)));			
			
				gor1 := Image(pisi0,Comm(x,y));	
				gor2 := Comm(gx,gy);
	
			if (gor1 <> gor2) then
				sonuc := false;
				yeni_iso := true;
				break;			
			fi;
		
		od;
		if ( yeni_iso = true ) then		
		break;
		fi;
	od;
	
	### end check diagram 2
	
		if ( yeni_iso = true ) then		
		break;
		fi;
	
	if ( sonuc = true ) then	
		return sonuc;
	fi;	
	od;
	od;
	Print("There is no morphism that provides conditions \n");	
return sonuc;
end );

#############################################################################
##
#M  IsIsomorphicXMod  . . . . . . . . . check that the given crossed modules are isomorphic
##
InstallMethod( IsIsomorphicXMod,
    "generic method for crossed modules", true, [ Is2dGroup, Is2dGroup ], 0,
function(XM1,XM2)

local sonuc,T1,G1,b2,a2,b1,a1,T2,G2,alpha1,phi1,m1_ler,m1,alp,ph;

sonuc := true;

T1 := Source(XM1);
G1 := Range(XM1);
b1 := Boundary(XM1);
a1 := XModAction(XM1);
	
T2 := Source(XM2);
G2 := Range(XM2);
b2 := Boundary(XM2);
a2 := XModAction(XM2);


	if IsomorphismGroups(T1,T2) = fail  then
	#Print("T1 !~ T2 \n" );
	sonuc := false;
	return sonuc;
	fi;

	if IsomorphismGroups(G1,G2) = fail  then
	#Print("G1 !~ G2 \n" );
	sonuc := false;
	return sonuc;
	fi;

	alpha1 := AllHomomorphismsViaSmallGroup(T1,T2);	
	phi1 := AllHomomorphismsViaSmallGroup(G1,G2);	
	m1_ler := [];		
	for alp in alpha1 do
		for ph in phi1 do
			if ( IsPreXModMorphism(Make2dGroupMorphism(XM1,XM2,alp,ph)) ) then
			Add(m1_ler,PreXModMorphism(XM1,XM2,alp,ph));
			fi;
		od;
	od;	
	
		m1_ler := Filtered(m1_ler,IsXModMorphism);
		
		if Length(m1_ler) = 0 then
		sonuc := false;
		return sonuc;
		fi;	
	
return sonuc;
end );

#############################################################################
##
#M  PreAllXMods  . . . . . . . . . all precrossed modules in the given order interval
##
InstallMethod( PreAllXMods,
    "generic method for crossed modules", true, [ IsInt, IsInt ], 0,
function(min,max)

local s1,i1,j1,s2,i2,j2,s3,i3,j3,s4,i4,j4,sonuc,sayi,T,G,S,H,b1,a1,b2,a2,XM1_ler,XM2_ler,XM1,XM2,b11,a11,PreXM1_ler;

sonuc := [];
a1 := [];
b1 := [];
a2 := [];
b2 := [];
sayi := 0;
XM1_ler := [];
PreXM1_ler := [];

	for i1 in [min..max] do
	s1 := Length(IdsOfAllSmallGroups(i1));		
	for j1 in [1..s1] do
	T := SmallGroup(i1,j1);
		for i2 in [min..max] do
		s2 := Length(IdsOfAllSmallGroups(i2));		
		for j2 in [1..s2] do
		G := SmallGroup(i2,j2);
		b1 := AllHomomorphisms(T,G);
		a1 := AllHomomorphisms(G,AutomorphismGroup(T));	
						for b11 in b1 do
							for a11 in a1 do
							if IsPreXMod(PreXModObj(b11,a11)) then
								Add(PreXM1_ler,PreXModObj(b11,a11));
							fi;
							od;
						od;
							
			
		od;
		od;
	od;	
	od;
return PreXM1_ler;
end );

#############################################################################
##
#M  AllXMods  . . . . . . . . . all crossed modules in the given order interval
##
InstallMethod( AllXMods,
    "generic method for crossed modules", true, [ IsInt, IsInt ], 0,
function(min,max)

local s1,i1,j1,s2,i2,j2,s3,i3,j3,s4,i4,j4,sonuc,sayi,T,G,S,H,b1,a1,b2,a2,XM1_ler,XM2_ler,XM1,XM2,b11,a11,PreXM1_ler;

sonuc := [];
a1 := [];
b1 := [];
a2 := [];
b2 := [];
sayi := 0;
XM1_ler := [];
PreXM1_ler := [];

	for i1 in [min..max] do
	s1 := Length(IdsOfAllSmallGroups(i1));		
	for j1 in [1..s1] do
	T := SmallGroup(i1,j1);
		for i2 in [min..max] do
		s2 := Length(IdsOfAllSmallGroups(i2));		
		for j2 in [1..s2] do
		G := SmallGroup(i2,j2);
		b1 := AllHomomorphisms(T,G);
		a1 := AllHomomorphisms(G,AutomorphismGroup(T));	
						for b11 in b1 do
							for a11 in a1 do
							if (  IsPreXMod(PreXModObj(b11,a11)) ) then
								Add(PreXM1_ler,PreXModObj(b11,a11));
							fi;
							od;
						od;
						XM1_ler := Filtered( PreXM1_ler,IsXMod );		
			
		od;
		od;
	od;	
	od;
return XM1_ler;
end );

#############################################################################
##
#M  IsoclinicXModFamily  . . . . . . . . . all crossed modules in the list which are isoclinic to the crossed module
##
InstallMethod( IsoclinicXModFamily,
    "generic method for crossed modules", true, [ Is2dGroup, IsList ], 0,
function(XM,XM1_ler)

local sonuc,sayi,XM1;

sonuc := [];
sayi := 0;

		for XM1 in XM1_ler do
			if IsIsoclinicXMod(XM,XM1) then
				Print(XM," ~ ",XM1,"\n" );	
				Add(sonuc,Position(XM1_ler,XM1));
				sayi := sayi + 1;			
			else
				Print(XM," |~ ",XM1,"\n" );			
			fi;		
		od;	
		
#Print(sayi,"\n");
return sonuc;
end );

#############################################################################
##
#M  IsomorphicXModFamily  . . . . . . . . . all crossed modules in the list which are isomorphic to the crossed module
##
InstallMethod( IsomorphicXModFamily,
    "generic method for crossed modules", true, [ Is2dGroup, IsList ], 0,
function(XM,XM1_ler)

local sonuc,sayi,XM1;

sonuc := [];
sayi := 0;

	
		for XM1 in XM1_ler do
		if IsIsomorphicXMod(XM,XM1) then
		# Print(XM," ~ ",XM1,"\n" );	
		Add(sonuc,Position(XM1_ler,XM1));
		sayi := sayi + 1;
		fi;
		
		od;		
#Print(sayi,"\n");
return sonuc;
end );


#############################################################################
##
#M  IsoAllXMods  . . . . . . . . . all crossed modules up to isomorphism
##
InstallMethod( IsoAllXMods,
    "generic method for crossed modules", true, [ IsList ], 0,
function(allxmods)

local n,l,i,j,k,isolar,liste1,liste2;

n := Length(allxmods);
liste1 := [];
liste2 := [];

	for i in [1..n] do
		if i in liste1 then
			continue;
		else
		isolar := IsomorphicXModFamily(allxmods[i],allxmods);
		Append(liste1,isolar);		
		Add(liste2,allxmods[i]);
		fi;	
	od;
	
return liste2;
end );

#############################################################################
##
#M  RankOfXMod  . . . . . . . . . the rank of the crossed module
##
InstallMethod( RankOfXMod,
    "generic method for crossed modules", true, [ Is2dGroup ], 0,
function(XM)

local sonuc,ZXMod,DXMod,BXMod,KXMod,m1,m2,l1,l2;

ZXMod := CenterXMod(XM);
DXMod := DerivedSubXMod(XM);
BXMod := FactorXMod(XM,ZXMod);
KXMod := IntersectionSubXMod(XM,ZXMod,DXMod);
	m1 := Size(BXMod);
	m2 := Size(KXMod);
	 
	 l1 := Log2(Float(m1[1])) + Log2(Float(m2[1]));
	 l2 := Log2(Float(m1[2])) + Log2(Float(m2[2]));
	sonuc := [l1,l2];
	
return sonuc;
end );

#############################################################################
##
#M  MiddleLengthOfXMod  . . . . . . . . . the middle length of the crossed module
##
InstallMethod( MiddleLengthOfXMod, "generic method for crossed modules", true, 
	[ Is2dGroup ], 0,
function(XM)

local sonuc,ZXMod,DXMod,BXMod,KXMod,m1,l1,l2;

ZXMod := CenterXMod(XM);
DXMod := DerivedSubXMod(XM);
KXMod := IntersectionSubXMod(XM,DXMod,ZXMod);
BXMod := FactorXMod(DXMod,KXMod);
	m1 := Size(BXMod);	 
	 l1 := Log2(Float(m1[1]));
	 l2 := Log2(Float(m1[2]));
	sonuc := [l1,l2];
	
return sonuc;
end );

#############################################################################
##
#M  IsAbelianXMod  . . . . . . . . . check that the crossed module is abelian
##
InstallMethod( IsAbelianXMod,
    "generic method for crossed modules", true, [ Is2dGroup ], 0,
function( XM )

local ZXM,sonuc;

ZXM := CenterXMod(XM);
if XM = ZXM then
	sonuc := true;
else
	sonuc := false;
fi;
return sonuc;
end );

#############################################################################
##
#M  IsAsphericalXMod  . . . . . . . . . check that the crossed module is aspherical
##
InstallMethod( IsAsphericalXMod,
    "generic method for crossed modules", true, [ Is2dGroup ], 0,
function( XM )

local bdy,sonuc;

bdy := Boundary(XM);
if Size(Kernel(bdy)) = 1 then
	sonuc := true;
else
	sonuc := false;
fi;
return sonuc;
end );

#############################################################################
##
#M  IsSimplyConnectedXMod  . . . . . . . . . check that the crossed module is simply connected
##
InstallMethod( IsSimplyConnectedXMod, "generic method for pre-cat1-groups", true,
    [ Is2dGroup ], 0,
function( XM )

local bdy,sonuc;

bdy := Boundary(XM);
if Size(CoKernel(bdy)) = 1 then
	sonuc := true;
else
	sonuc := false;
fi;
return sonuc;
end );

#############################################################################
##
#M  IsFaithfulXMod  . . . . . . . . . check that the crossed module is faithful
##
InstallMethod( IsFaithfulXMod, "generic method for crossed modules", true, [ Is2dGroup ], 0,
function( XM )

local G,sonuc;

G := stGT(XM);
if Size(G) = 1 then
	sonuc := true;
else
	sonuc := false;
fi;
return sonuc;
end );

#############################################################################
##
#M  TableRowXMod  . . . . . . . . . table row for isoclinism families of crossed modules
##
InstallMethod( TableRowXMod,
    "generic method for crossed modules", true, [ Is2dGroup, IsList ], 0,
function(XM,XM_ler)

local Eler,Iler,i,j,sinif,B;

sinif := IsoclinicXModFamily(XM,XM_ler);

B := LowerCentralSeriesOfXMod(XM);
	
Print("---------------------------------------------------------------------------------------------------------------------------------- \n");
Print("---------------------------------------------------------------------------------------------------------------------------------- \n");
Print("Number","\t","Rank","\t\t","M. L.","\t\t","Class","\t","|G/Z|","\t\t","|g2|","\t\t","|g3|","\t\t","|g4|","\t\t","|g5| \n");
Print("---------------------------------------------------------------------------------------------------------------------------------- \n");
Print(Length(sinif),"\t",RankOfXMod(XM),"\t",MiddleLengthOfXMod(XM),"\t",NilpotencyClassOfXMod(XM),"\t",Size(FactorXMod(XM,CenterXMod(XM))));	

if Length(B) > 1 then
for i in [2..Length(B)] do
		Print("\t");
		Print(Size(B[i]));
		
od;
fi;

Print("\n---------------------------------------------------------------------------------------------------------------------------------- \n");
return sinif;
end );








