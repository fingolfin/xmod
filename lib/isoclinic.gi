#############################################################################
##
#W  isoclinic.gi               GAP4 package `XMod'                Alper Odabas
#W                                                                & Enver Uslu
##  version 2.43, 09/10/2015 
##
#Y  Copyright (C) 2001-2015, Chris Wensley et al 
#Y   
##  This file contains generic methods for finding isoclinism classes 
##  of crossed modules. 
##

#############################################################################
##
#M  FixedPointSubgroupXMod . . . . elements of the range fixed by the source
##
InstallMethod( FixedPointSubgroupXMod, "generic method for precrossed modules", 
    true, [ IsPreXMod, IsGroup, IsGroup ], 0,
function( XM, T, Q )

    local  genQ, act, ext, orb, elts, fix, gens;

    if not ( IsSubgroup( Source(XM), T ) and IsSubgroup( Range(XM), Q ) ) then 
        Error( "T,Q not subgroups of S,R" ); 
    fi; 
    genQ := GeneratorsOfGroup( Q ); 
    act := XModAction( XM );
    ext := ExternalSet( Q, T, genQ, List( genQ, g -> Image(act,g) ) ); 
    orb := Orbits( ext );  
    elts := Concatenation( Filtered( orb, o -> Length(o) = 1) ); 
    fix := Subgroup( T, elts ); 
    gens := SmallGeneratingSet( fix ); 
    return Subgroup( T, gens ); 
end );
       
#############################################################################
##
#M  StabilizerSubgroupXMod . . . . elements of Q<=R which fix T<=S pointwise
##
InstallMethod( StabilizerSubgroupXMod, 
    "generic method for a crossed module and subgroups of source, range", 
    true, [ IsPreXMod, IsGroup, IsGroup ], 0,
function( XM, T, Q )

    local alpha, sonuc, t, q, list;

    if not ( IsSubgroup( Source(XM), T ) and IsSubgroup( Range(XM), Q ) ) then 
        Error( "T,Q not subgroups of S,R" ); 
    fi; 
    alpha := XModAction(XM);
    list := [];
    for q in Q do
        if ForAll( T, t -> Image(Image(alpha,q),t)=t ) then
            Add( list, q );
        fi;        
    od;
    ##  if the lists consist only the identity element then there is a bug 
    ##  in the function AsMagma. 
    if ( Length( Set(list) ) = 1 ) then
        return TrivialSubgroup( Q );
    fi;
    return AsGroup(list);
end );

#############################################################################
##
#M  CentreXMod  . . . . . . . . . the centre of a crossed module
##
InstallMethod( CentreXMod, "generic method for crossed modules", true, 
    [ IsXMod ], 0,
function( XM )

    local alpha, T, G, partial, fix, k_partial, k_alpha, PM, K;

    T := Source(XM);
    G := Range(XM);
    alpha := XModAction(XM);
    partial := Boundary(XM);
    K := Intersection( Centre(G), StabilizerSubgroupXMod( XM, T, G ) );
    fix := FixedPointSubgroupXMod( XM, T, G );
##  k_partial := GroupHomomorphismByFunction( fix, K, x -> Image(partial,x) );
##  k_alpha := GroupHomomorphismByFunction( K, AutomorphismGroup( fix ), 
##                 x -> Image( alpha, x ) );
##  return XModByBoundaryAndAction( k_partial, k_alpha );
    return SubXMod( XM, fix, K ); 
end );

#############################################################################
##
#M  Centralizer  . . . . . . . . for a subcrossed module of a crossed module
##
InstallOtherMethod( Centralizer, "generic method for crossed modules", true, 
    [ IsXMod, IsXMod ], 0,
function( XM, YM )

    local  srcX, rngY, genR, actY, ext, orb, elts, fix, gens, srcC, rngC; 

    if not IsSubXMod( XM, YM ) then 
        Error( "YM is not a subcrossed module of XM" ); 
    fi;
    srcX := Source( XM ); 
    rngY := Range( YM  ); 
    genR := GeneratorsOfGroup( rngY ); 
    actY := XModAction( YM );
    ext := ExternalSet( rngY, srcX, genR, List( genR, g -> Image(actY,g) ) ); 
    orb := Orbits( ExternalSetXMod( XM ) );  
    elts := Concatenation( Filtered( orb, o -> Length(o) = 1) ); 
    fix := Subgroup( srcX, elts ); 
    gens := SmallGeneratingSet( fix ); 
    srcC := Subgroup( srcX, gens ); 
    rngC := Intersection( StabilizerSubgroupXMod( XM, srcX, rngY ), 
                          Centralizer( Range(XM), rngY ) );
    if ( srcC = srcX ) then 
        srcC := srcX; 
        if ( rngC = Range(XM) ) then 
            return XM; 
        fi;
    fi; 
    return SubXMod( XM, srcC, rngC ); 
end ); 

#############################################################################
##
#M  Displacement 
##
InstallMethod( Displacement, "generic method for hom, element, element", 
    true, [ IsGroupHomomorphism, IsObject, IsObject ], 0,
function( alpha, s, r )

    local  S, R, a, x; 

    R := Source( alpha ); 
    if not ( r in R ) then 
        return fail; 
    fi; 
    a := Image( alpha, r ); 
    S := Source( a ); 
    if not ( Range(a) = S ) then 
        return fail; 
    fi;
    return s^-1 * Image( a, s );
end ); 

#############################################################################
##
#M  DisplacementSubgroup . . . subgroup of source generated by displacvements
##
InstallMethod( DisplacementSubgroup, "generic method for crossed modules", 
    true, [ IsXMod ], 0,
function( XM )

    local  alpha, alp, sonuc, T, G, t, t0, g, list, one;

    T := Source(XM);
    G := Range(XM);
    alpha := XModAction(XM);
    list := []; 
    one := One( T );
    for g in GeneratorsOfGroup( G ) do 
        alp := Image( alpha, g ); 
        for t in GeneratorsOfGroup( T ) do
            t0 := t^-1 * Image( alp, t ); 
            if ( ( t0 <> one ) and ( Position(list,t0) = fail ) ) then  
                Add( list, t0 );
            fi;
        od;
    od;
    if ( Length( Set(list) ) = 0 ) then 
        list := [ one ];
    fi;
    return Subgroup( T, list );
end );

#############################################################################
##
#M  Normalizer . . . . . . . . . for a subcrossed module of a crossed module
##
InstallOtherMethod( Normalizer, "generic method for crossed modules", true, 
    [ IsXMod, IsXMod ], 0,
function( XM, YM )

    local  act, T, G, S, H, t, h, d, pos, elts, gens, srcN, rngN; 

    if not IsSubXMod( XM, YM ) then 
        Error( "YM is not a subcrossed module of XM" ); 
    fi;
    elts := [ ]; 
    act := XModAction( XM ); 
    T := Source( XM ); 
    G := Range( XM  ); 
    S := Source( YM ); 
    H := Range( YM  ); 
    ## is there a more efficient method, just using generators? 
    for t in T do 
        for h in H do 
            d := Displacement( act, t, h ); 
            if ( d in S ) then 
                pos := Position( elts, d ); 
                if ( pos = fail ) then 
                    Add( elts, d ); 
                fi; 
            fi;
        od; 
    od;
    srcN := Subgroup( S, elts ); 
    gens := SmallGeneratingSet( srcN ); 
    srcN := Subgroup( S, gens ); 
    rngN := Intersection( Normalizer( G, H ), 
                StabilizerSubgroupXMod( XM, S, G ) ); 
    return SubXMod( XM, srcN, rngN ); 
end ); 

#############################################################################
##
#M  CrossActionSubgroup . . . . . . . . . source group for CommutatorSubXMod
##
InstallMethod( CrossActionSubgroup, "generic method for two normal subxmods", 
    true, [ IsXMod, IsXMod, IsXMod ], 0,
function( TG, SH, RK )

    local  alpha, alp, T, s, s0, k, r, r0, h, list, one;

    ## if not ( IsSub2dDomain(TG,SH) and IsSub2dDomain(TG,RK) ) then 
    ##     Error( "SH,RK not subcrossed modules of TG" ); 
    ## fi; 
    T := Source(TG);
    alpha := XModAction(TG);
    list := [];
    one := One( T );
    for k in GeneratorsOfGroup( Range(RK) ) do 
        alp := Image( alpha, k ); 
        for s in GeneratorsOfGroup( Source(SH) ) do 
            s0 := s^-1 * Image( alp, s ); 
            if ( ( s0 <> one ) and ( Position(list,s0) = fail ) ) then  
                Add( list, s0 );
            fi;
        od;
    od;
    for h in GeneratorsOfGroup( Range(SH) ) do 
        alp := Image( alpha, h ); 
        for r in GeneratorsOfGroup( Source(RK) ) do 
            r0 := Image( alp, r^-1 ) * r; 
            if ( ( r0 <> one ) and ( Position(list,r0) = fail ) ) then  
                Add( list, r0 );
            fi;
        od;
    od;
    if ( Length( Set(list) ) = 0 ) then 
        list := [ one ];
    fi;
    return Subgroup( T, list );
end );

#############################################################################
##
#M  IntersectionSubXMod  . . . . intersection of subcrossed modules SH and RK
##
InstallMethod( IntersectionSubXMod, "generic method for crossed modules", 
    true, [ IsXMod, IsXMod, IsXMod ], 0,
function( XM, SH, RK)

    local alpha, T, G, S, H, R, K, partial, k_partial, k_alpha, SR, HK;

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
    k_alpha := GroupHomomorphismByFunction( HK, AutomorphismGroup(SR), 
                   x -> Image(alpha,x) );
    return XModByBoundaryAndAction( k_partial, k_alpha );
end );

#############################################################################
##
#M  FactorXMod  . . . . . . . . . . . . . . . . . the quotient crossed module
##
InstallMethod( FactorXMod, "generic method for crossed modules", true, 
    [ IsXMod, IsXMod ], 0,
function( XM, PM )

    local  alpha1, alpha2, partial1, partial2, nhom1, nhom2, T, G, S, H, 
           B1, B2, bdy, act, FM;

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
    bdy := GroupHomomorphismByFunction( B1, B2, 
             a -> Image( nhom2, 
               Image(partial1,PreImagesRepresentative( nhom1, a ) ) ) );
    act := GroupHomomorphismByFunction( B2, AutomorphismGroup(B1), 
             b -> GroupHomomorphismByFunction( B1, B1, 
               c -> Image( nhom1, 
                   (Image(Image(alpha1,PreImagesRepresentative(nhom2,b)), 
                       PreImagesRepresentative(nhom1,c) ) ) ) ) );
    FM := XModByBoundaryAndAction( bdy, act );
    if ( HasName(XM) and HasName(PM) ) then 
        SetName( FM, Concatenation( Name(XM), "/", Name(PM) ) ); 
    fi; 
    return FM; 
end );

#############################################################################
##
#M  NaturalMorphismByNormalSubXMod . . . . . . . . the quotient xmod morphism
##
InstallMethod( NaturalMorphismByNormalSubXMod, 
    "generic method for crossed modules", true, [ IsXMod, IsXMod ], 0,
function( XM, PM )

    local  FM, nhom1, nhom2, iso1, iso2;

    FM := FactorXMod( XM, PM ); 
    nhom1 := NaturalHomomorphismByNormalSubgroup( Source(XM), Source(PM) );
    nhom2 := NaturalHomomorphismByNormalSubgroup( Range(XM), Range(PM) );
    iso1 := IsomorphismGroups( Image(nhom1), Source(FM) );
    iso2 := IsomorphismGroups( Image(nhom2), Range(FM) );
    return XModMorphismByHoms( XM, FM, nhom1*iso1, nhom2*iso2 ); 
end );

#############################################################################
##
#M  DerivedSubXMod  . . . . . . . . . . the commutator of the crossed module
##
InstallMethod( DerivedSubXMod, "generic method for crossed modules", true, 
    [ IsXMod ], 0,
function(XM)

    local  D, dgt; 

    D := DerivedSubgroup( Range( XM ) );
    dgt := DisplacementSubgroup( XM ); 
    return SubXMod( XM, dgt, D ); 
end );

#############################################################################
##
#M  CommutatorSubXMod  . . . . . . . commutator subxmod of two normal subxmods
##
InstallMethod( CommutatorSubXMod, "generic method for crossed modules", true, 
    [ IsXMod, IsXMod, IsXMod ], 0,
function( TG, SH, RK )

    local  cas, com;

    cas := CrossActionSubgroup( TG, SH, RK ); 
    com := CommutatorSubgroup( Range(SH), Range(RK) );
    return SubXMod( TG, cas, com ); 
end );

#############################################################################
##
#M  LowerCentralSeries  . . . . . . . . . the lower central series of an xmod
##
InstallOtherMethod( LowerCentralSeries, "generic method for crossed modules", 
    true, [ IsXMod ], 0,
function(XM)

    local  list, C;

    list := [ XM ];
    C := DerivedSubXMod( XM );
    while ( C <> list[ Length(list) ] )  do
        Add( list, C );
        C := CommutatorSubXMod( XM, C, XM );
    od;
    return list;
end );
    
#############################################################################
##
#M  IsAbelian2dGroup . . . . . . . . . check that a crossed module is abelian
##
InstallMethod( IsAbelian2dGroup, "generic method for crossed modules", true, 
    [ IsXMod ], 0,
function( XM )
    return ( XM = CentreXMod( XM ) );
end );

#############################################################################
##
#M  IsAspherical2dGroup . . . . . . check that a crossed module is aspherical
##
InstallMethod( IsAspherical2dGroup, "generic method for crossed modules", 
    true, [ IsXMod ], 0,
function( XM )
    return ( Size( Kernel( Boundary(XM) ) ) = 1 ); 
end );

#############################################################################
##
#M  IsSimplyConnected2dGroup . check that a crossed module is simply connected
##
InstallMethod( IsSimplyConnected2dGroup, "generic method for crossed modules", 
    true, [ IsXMod ], 0,
function( XM )
    return ( Size( CoKernel( Boundary(XM) ) ) = 1 );
end );

#############################################################################
##
#M  IsFaithful2dGroup . . . . . . . . check that a crossed module is faithful
##
InstallMethod( IsFaithful2dGroup, "generic method for crossed modules", true, 
    [ IsXMod ], 0,
function( XM )
    return ( Size( StabilizerSubgroupXMod( XM, Source(XM), Range(XM) ) ) = 1 ); 
end );

#############################################################################
##
#M  IsNilpotent2dGroup  . . . . . . . . . . . check that an xmod is nilpotent
##
InstallMethod( IsNilpotent2dGroup, "generic method for crossed modules", 
    true, [ IsXMod ], 0,
function(XM)

    local  S, n, sonuc;

    S := LowerCentralSeries( XM );
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
#M  NilpotencyClassOf2dGroup . . . . .  nilpotency degree of a crossed module
##
InstallMethod( NilpotencyClassOf2dGroup, "generic method for crossed modules", 
    true, [ IsXMod ], 0,
function(XM)

    if not IsNilpotent2dGroup(XM) then
        return 0;
    else
        return Length( LowerCentralSeries(XM) ) - 1;        
    fi;
end );



############################################################################# 
#####                FUNCTIONS FOR ISOCLINISM OF GROUPS                 ##### 
############################################################################# 

#############################################################################
##
#M IsStemGroup . . . check that the centre is a subgroup of the derived group
## 
InstallMethod( IsStemGroup, "generic method for groups", true, [ IsGroup ], 0,
function(G)
    return IsSubgroup( DerivedSubgroup(G), Centre(G) );
end );

#############################################################################
##
#M AllStemGroupIds . . . list of all IdGroup's of stem groups of chosen order 
## 
InstallMethod( AllStemGroupIds, "generic method for posint", true, 
    [ IsPosInt ], 0,
function(a) 

    local  g, i, j, sonuc, sayi;

    sonuc := [ ]; 
    for g in AllSmallGroups( a ) do 
        if IsStemGroup( g ) then 
            Add( sonuc, IdGroup( g ) ); 
        fi;
    od; 
    return sonuc; 
end );

#############################################################################
##
#M AllStemGroupFamilies . . . split stem groups of chosen order into families 
## 
InstallMethod( AllStemGroupFamilies, "generic method for posint", true, 
    [ IsPosInt ], 0,
function(a) 

    local  ids, len, found, id, gi, g, i, j, sonuc, new, sayi;

    ids := AllStemGroupIds( a );
    len := Length( ids ); 
    found := ListWithIdenticalEntries( len, false );
    sonuc := [ ]; 
    for i in [1..len] do 
        if not found[i] then 
            found[i] := true; 
            id := ids[i]; 
            new := [ id ];
            gi := SmallGroup( id ); 
            for j in [i+1..len] do 
                if not found[j] then 
                    if AreIsoclinicGroups( gi, SmallGroup( ids[j] ) ) then
                        found[j] := true; 
                        Add( new, ids[j] );
                    fi; 
                fi; 
            od;
        Add( sonuc, ShallowCopy( new ) ); 
        fi; 
    od;
    return sonuc; 
end );

#############################################################################
##
#M CentralQuotient . . . . . . . . . . . . . . . . . . . . . . . . . . G/Z(G)
#M CentralQuotientHomomorphism . . . . . . . . . . . . . . . . .  G -> G/Z(G)
## 
InstallMethod( CentralQuotient, "generic method for groups", true, 
    [ IsGroup ], 0,
function( G ) 

    local  ZG, Q, nat; 

    ZG := Centre( G ); 
    Q := FactorGroup( G, ZG ); 
    if ( HasName(G) and not HasName(ZG) ) then 
        SetName( ZG, Concatenation( "Z(", Name(G), ")" ) ); 
    fi; 
    nat := NaturalHomomorphismByNormalSubgroup( G, ZG ); 
    if HasName(G) then 
        SetName( Q, Concatenation( Name(G), "/", Name(ZG) ) ); 
        SetName( nat, Concatenation( "central quotient homomorphism ", 
                          Name(G), " -> ", Name(Q) ) ); 
    fi;
    SetCentralQuotientHomomorphism( G, nat ); 
    return Q;
end );

InstallMethod( CentralQuotientHomomorphism, "generic method for groups", true, 
    [ IsGroup ], 0,
function( G ) 

    local  Q; 

    Q := CentralQuotient( G );
    return NaturalHomomorphismByNormalSubgroup( G, Q ); 
end );

InstallOtherMethod( CentralQuotient, "generic method for crossed modules", 
    true, [ IsXMod ], 0,
function( XM ) 

    local  ZM, QM, nat; 

    ZM := CentreXMod( XM ); 
    QM := FactorXMod( XM, ZM ); 
    if ( HasName(XM) and not HasName(ZM) ) then 
        SetName( ZM, Concatenation( "Z(", Name(XM), ")" ) ); 
    fi; 
    nat := NaturalMorphismByNormalSubXMod( XM, ZM ); 
    if HasName(XM) then 
        SetName( QM, Concatenation( Name(XM), "/", Name(ZM) ) ); 
        SetName( nat, Concatenation( "central quotient morphism ", 
                          Name(XM), " -> ", Name(QM) ) ); 
    fi;
    SetCentralQuotientHomomorphism( XM, nat ); 
    return QM;
end );

InstallOtherMethod( CentralQuotientHomomorphism, "generic method for xmods", 
    true, [ IsXMod ], 0,
function( XM ) 

    local  QM, nat; 

    QM := CentralQuotient( XM );
    nat := NaturalMorphismByNormalSubXMod( XM, QM ); 
    if HasName(XM) then 
        SetName( nat, Concatenation( "central quotient morphism ", 
                          Name(XM), " -> ", Name(QM) ) ); 
    fi;
    return nat;
end );

#############################################################################
##
#M MiddleLength . . .
## 
InstallMethod( MiddleLength, "generic method for groups", true, 
    [ IsGroup ], 0,
function( G ) 

    local sonuc, ZG, DG, BG, KG, m1, l1, l2;

    ZG := Center(G);
    DG := DerivedSubgroup(G);
    KG := Intersection(DG,ZG);
    BG := FactorGroup(DG,KG);
    return Log2( Float( Size(BG) ) );     
end );

#############################################################################
##
#M AreIsoclinicGroups . . . 
## 
InstallMethod( AreIsoclinicGroups, "generic method for two groups", true, 
    [ IsGroup, IsGroup ], 0,
function( G1, G2 ) 
    local  iso; 
    iso := Isoclinism( G1, G2 ); 
    if ( iso = false ) then 
        return false; 
    elif ( iso = fail ) then 
        return fail; 
    else 
        return true; 
    fi; 
end );

#############################################################################
##
#M Isoclinism . . . 
## 
InstallMethod( Isoclinism, "generic method for two groups", true, 
    [ IsGroup, IsGroup ], 0,
function( G1, G2 )

    local  B1, B2, ComG1, ComG2, nhom1, nhom2, iterb1, iterb2, iterB, iterC, 
           isoB, isoC, b1, b2, gb1, gb2, f, g, sonuc, x, y, 
           gx, gy, gor1, gor2, yeni_iso;

    if (IsomorphismGroups(G1,G2) <> fail) then
        return true;
    fi;
    B1 := CentralQuotient(G1);
    B2 := CentralQuotient(G2);
    ComG1 := DerivedSubgroup(G1);
    ComG2 := DerivedSubgroup(G2);
    isoB := IsomorphismGroups(B1,B2);
    isoC := IsomorphismGroups(ComG1,ComG2);
    if ( ( isoB = fail ) or ( isoC = fail ) ) then 
        return false;
    fi;
    nhom1 := CentralQuotientHomomorphism(G1);
    nhom2 := CentralQuotientHomomorphism(G2);
    iterB := Iterator( AllAutomorphisms(B2) ); 
    iterC := Iterator( AllAutomorphisms(ComG2) );
    ### ilk iki ˛art˝ geÁerse 3. y¸ kontrol edelim
    ### anlams˝z hata al˝yorum 
    iterb1 := Iterator( B1 );
    while not IsDoneIterator( iterB ) do 
        f := isoB * NextIterator(iterB); 
        while not IsDoneIterator( iterC ) do 
            g := isoC * NextIterator(iterC); 
            sonuc := true;
            yeni_iso := false;
            while ( ( not yeni_iso ) and ( not IsDoneIterator(iterb1) ) ) do 
                b1 := NextIterator( iterb1 ); 
                ## yeni_iso degeri dogru geliyorsa yeni f,g 
                ## ikili iÁin dˆng¸y¸ k˝r.
                ## if ( yeni_iso = true ) then        
                ##     break;
                ## fi;
                x := PreImagesRepresentative(nhom1,b1);
                gb1 := Image(f,b1);
                gx := PreImagesRepresentative(nhom2,gb1);
                iterb2 := Iterator( B1 );
                while ( ( not yeni_iso ) and ( not IsDoneIterator(iterb2) ) ) do 
                    b2 := NextIterator( iterb2 ); 
                    y := PreImagesRepresentative(nhom1,b2);
                    gb2 := Image(f,b2);
                    gy := PreImagesRepresentative(nhom2,gb2);            
                    gor1 := Image(g,Comm(x,y));    
                    gor2 := Comm(gx,gy);
                    if (gor1 <> gor2) then 
                        yeni_iso := true;
                        ## sonuc := false;
                        ## 3. sart bu f,g ikilisi iÁin salanm˝yor 
                        ## break; 
                    fi;
                od;
            od;
            ## 3. sart˝ salayan 1 tane f,g ikilisi bulunmas˝ yeterlidir.  
            if sonuc then        
                return [f,g];
            fi;
        od;
    od;
    return fail;
end );

#############################################################################
##
#M IsoclinicStemGroup . . . 
## 
InstallMethod( IsoclinicStemGroup, "generic method for a group", 
    true, [ IsGroup ], 0,
function(G)

    local  i, len, divs, id, gi;

    if ( HasIsAbelian(G) and IsAbelian(G) ) then 
        return [ [ 1, 1 ] ]; 
    fi;
    if IsStemGroup(G) then 
        return G;
    fi; 
    divs := DivisorsInt( Size(G) );
    len := Length( divs ); 
    for i in divs{[1..len-1]} do 
        for gi in AllSmallGroups( i ) do 
            if IsStemGroup( gi ) then
                if AreIsoclinicGroups( G, gi ) then 
                    return gi; 
                fi; 
            fi;        
        od;
    od;
    return fail; 
end );


############################################################################# 
#####            FUNCTIONS FOR ISOCLINISM OF CROSSED MODULES            ##### 
############################################################################# 

#############################################################################
##
#M IsStemXMod . . check that the centre xmod is a subxmod of the derived xmod
## 
InstallMethod( IsStemXMod, "generic method for crossed modules", true, 
    [ IsXMod ], 0,
function(X0)
    return IsSubXMod( DerivedSubXMod(X0), CentreXMod(X0) );
end );


#############################################################################
##
#M  AreIsoclinicXMods
##
InstallMethod( AreIsoclinicXMods, "generic method for crossed modules", true, 
    [ IsXMod, IsXMod ], 0,
function(XM1,XM2)

    local  cakma3, cakma4, kG12, kG11, T, G, S, H, sonuc, kT11, kT12, 
           cakma, cakma2, yeni_iso, x, y, z1, z2, gz1, gz2, gx, gy, 
           gor1, gor2, pisi0, pisi1, nisi1, nisi0, nhom1, nhom2, nhom3, nhom4, 
           DXM1, DXM2, CXM1, CXM2, FXM1, FXM2, b1, a1, T1, G1, 
           b2, a2, T2, G2, alpha1, phi1, m1_ler, m2_ler, m1, m2, b11, a11, 
           T11, G11, b12, a12, T12, G12, alpha11, phi11, m11, alp, ph, 
           isoT, isoG, isoT1, isoG1, iterT2, iterG2, iterT12, iterG12, mor, 
           QXM1, QXM2;

    sonuc := true;
    T := Source(XM1);
    G := Range(XM1);
    S := Source(XM2);
    H := Range(XM2);
    DXM1 := DerivedSubXMod(XM1);
    DXM2 := DerivedSubXMod(XM2);
    b1 := Boundary(DXM1);
    a1 := XModAction(DXM1);
    T1 := Source(DXM1);
    G1 := Range(DXM1);
    b2 := Boundary(DXM2);
    a2 := XModAction(DXM2);
    T2 := Source(DXM2);
    G2 := Range(DXM2);
    
    isoT := IsomorphismGroups(T1,T2); 
    isoG := IsomorphismGroups(G1,G2);
    if ( ( isoT = fail ) or (isoG = fail ) ) then 
        return false; 
    fi;

    ## alpha1 := AllIsomorphisms( T1, T2 ); 
    iterT2 := Iterator( AllAutomorphisms(T2) ); 
    m1_ler := [];        
    ## for alp in alpha1 do
    while not IsDoneIterator( iterT2 ) do 
        alp := isoT * NextIterator( iterT2 ); 
        ## phi1 := AllIsomorphisms( G1, G2 ); 
        ## for ph in phi1 do 
        iterG2 := Iterator( AllAutomorphisms(G2) ); 
        while not IsDoneIterator( iterG2 ) do 
            ph := isoG * NextIterator( iterG2 ); 
            mor := Make2dGroupMorphism(DXM1,DXM2,alp,ph); 
            if IsPreXModMorphism( mor ) then 
                if IsXModMorphism( mor ) then 
                    Add( m1_ler, mor );
                fi; 
            fi;
        od;
    od;    
    ## m1_ler := Filtered(m1_ler,IsXModMorphism); 
    if ( Length(m1_ler) = 0 ) then
        Info( InfoXMod, 1, "There is no morphism CXM1 -> CXM2" );
        return false;
    fi;
    
    CXM1 := CentreXMod(XM1);
    CXM2 := CentreXMod(XM2);
    FXM1 := FactorXMod(XM1,CXM1); 
    FXM2 := FactorXMod(XM2,CXM2); 
    b11 := Boundary(FXM1);
    a11 := XModAction(FXM1);
    T11 := Source(FXM1);
    G11 := Range(FXM1);
    b12 := Boundary(FXM2);
    a12 := XModAction(FXM2);
    T12 := Source(FXM2);
    G12 := Range(FXM2);
        
    isoT1 := IsomorphismGroups(T11,T12); 
    isoG1 := IsomorphismGroups(G11,G12);
    if ( ( isoT1 = fail ) or ( isoG1 = fail ) ) then 
        return false;
    fi;
    
    ## alpha11 := AllIsomorphisms(T11,T12);
    iterT12 := Iterator( AllAutomorphisms( T12 ) ); 
    m2_ler := [];        
    ## for alp in alpha11 do 
    while not IsDoneIterator( iterT12 ) do 
        alp := isoT1 * NextIterator( iterT12 ); 
        ## phi11 := AllIsomorphisms(G11,G12); 
        ## for ph in phi11 do 
        iterG12 := Iterator( AllAutomorphisms( G12 ) ); 
        while not IsDoneIterator( iterG12 ) do 
            ph := isoG1 * NextIterator( iterG12 ); 
            mor := Make2dGroupMorphism( FXM1, FXM2, alp, ph ); 
            if ( IsPreXModMorphism( mor ) and IsXModMorphism( mor ) ) then 
                Add( m2_ler, mor );  
            fi;
        od;
    od;
    if ( Length(m2_ler) = 0 ) then
        Info( InfoXMod, 1, "There is no morphism FXM1 -> FXM2" );
        return false;
    fi;
    
    QXM1 := Intersection( Centre(G), 
                StabilizerSubgroupXMod( XM1, T, G ) ); 
    nhom1 := NaturalHomomorphismByNormalSubgroup( G, QXM1 ); 
    kG11 := Image( nhom1 );
    cakma3 := GroupHomomorphismByImages( kG11, G11, GeneratorsOfGroup(kG11), 
                                                    GeneratorsOfGroup(G11) );
    QXM2 := Intersection( Centre(H), 
                StabilizerSubgroupXMod( XM2, S, H ) ); 
    nhom2 := NaturalHomomorphismByNormalSubgroup( H, QXM2 ); 
    kG12 := Image( nhom2 );
    cakma4 := GroupHomomorphismByImages( G12, kG12, GeneratorsOfGroup(G12),
                                                    GeneratorsOfGroup(kG12) );

    nhom3 := NaturalHomomorphismByNormalSubgroup( T,
                 FixedPointSubgroupXMod( XM1, T, G ) ); 
    kT11 := Image(nhom3); 
    cakma := GroupHomomorphismByImages( kT11, T11, GeneratorsOfGroup(kT11),
                                                   GeneratorsOfGroup(T11) );
    nhom4 := NaturalHomomorphismByNormalSubgroup( S,
                 FixedPointSubgroupXMod( XM2, S, H ) ); 
    kT12 := Image(nhom4);
    cakma2 := GroupHomomorphismByImages( T12, kT12, GeneratorsOfGroup(T12),
                                                    GeneratorsOfGroup(kT12) );
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
                x := PreImagesRepresentative(nhom3,z1);
                gz1 := Image(nisi1,Image(cakma,z1));
                gx := PreImagesRepresentative(nhom4,Image(cakma2,gz1));
                for z2 in kG11 do
                    y := PreImagesRepresentative(nhom1,z2);
                    gz2 := Image(nisi0,Image(cakma3,z2));
                    gy := PreImagesRepresentative(nhom2,Image(cakma4,gz2));    
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
                x := PreImagesRepresentative(nhom1,z1);
                gz1 := Image(nisi0,Image(cakma3,z1));
                gx := PreImagesRepresentative(nhom2,Image(cakma4,gz1));
                for z2 in kG11 do
                    y := PreImagesRepresentative(nhom1,z2);
                    gz2 := Image(nisi0,Image(cakma3,z2));
                    gy := PreImagesRepresentative(nhom2,Images(cakma4,gz2));            
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
    Info( InfoXMod, 1, "there is no morphism that provides conditions" );    
    return sonuc;
end );

#############################################################################
##
#M  IsomorphismXMods  . . check that the given crossed modules are isomorphic
##
InstallMethod( IsomorphismXMods, "generic method for crossed modules", true, 
    [ Is2dGroup, Is2dGroup ], 0,
function(XM1,XM2)

    local  T1, G1, T2, G2, isoT, isoG, iterT, iterG, alp, ph, mor;

    T1 := Source(XM1);
    G1 := Range(XM1);
    T2 := Source(XM2);
    G2 := Range(XM2);
    isoT := IsomorphismGroups(T1,T2); 
    isoG := IsomorphismGroups(G1,G2);
    if ( ( isoT = fail ) or ( isoG = fail ) ) then 
        return fail; 
    fi; 
    iterT := Iterator( AllAutomorphisms( T2 ) ); 
    iterG := Iterator( AllAutomorphisms( G2 ) ); 
    while not IsDoneIterator( iterT ) do 
        alp := isoT * NextIterator( iterT ); 
        while not IsDoneIterator( iterG ) do 
            ph := isoG * NextIterator( iterG ); 
            mor := Make2dGroupMorphism( XM1, XM2, alp, ph ); 
            if ( IsPreXModMorphism( mor ) and IsXModMorphism( mor ) ) then 
                return mor; 
            fi;
        od;
    od;    
    return fail;
end );

#############################################################################
##
#M  AllXModsWithGroups . . . . . . . . all xmods with given source and range
##
InstallMethod( AllXModsWithGroups, "generic method for a pair of groups", 
    true, [ IsGroup, IsGroup ], 0,
function( T, G )

    local  list, autT, itTG, itGA, b1, a1, obj;

    list := [ ];
    autT := AutomorphismGroup(T); 
    itTG := Iterator( AllHomomorphisms(T,G) );
    while not IsDoneIterator( itTG ) do 
        b1 := NextIterator( itTG ); 
        itGA := Iterator( AllHomomorphisms(G,autT) );
        while not IsDoneIterator( itGA ) do 
            a1 := NextIterator( itGA ); 
            obj := PreXModObj( b1, a1 );  
            if ( IsPreXMod( obj ) and IsXMod( obj ) ) then 
                Add( list, obj );
            fi;
        od; 
    od;
    return list;
end );

#############################################################################
##
#F  AllXMods( <T>, <G> )             xmods with given source and range 
#F  AllXMods( <size> )               xmods with a given size 
#F  AllXMods( <order> )              xmods whose cat1-group has a given order
## 
InstallGlobalFunction( AllXMods, function( arg )

    local  nargs, a, list, s1, j1, s2, j2, T, G, sizes; 

    nargs := Length( arg ); 
    if ( nargs = 2 ) then 
        ## given source and range 
        if ( IsGroup( arg[1] ) and IsGroup( arg[2] ) ) then 
            return AllXModsWithGroups( arg[1], arg[2] ); 
        fi; 
    elif ( nargs = 1 ) then 
        a := arg[1]; 
        ## given size 
        if ( IsList(a) and (Length(a)=2) and IsInt(a[1]) and IsInt(a[2]) ) then 
            list := [ ]; 
            s1 := NumberSmallGroups( a[1] ); 
            for j1 in [1..s1] do
                T := SmallGroup( a[1], j1 );
                s2 := NumberSmallGroups( a[2] );        
                for j2 in [1..s2] do
                    G := SmallGroup( a[2], j2 );
                    Append( list, AllXModsWithGroups( T, G ) ); 
                od; 
            od;
            return list; 
        ## given total size 
        elif IsInt(a) then 
            sizes := List( DivisorsInt(a), d -> [d,a/d] ); 
            list := [ ];
            for s1 in sizes do
                Append( list, AllXMods( s1 ) ); 
            od;
            return list; 
        fi; 
    fi; 
    Error( "standard usage: AllXMods(S,R), AllXMods([n,m]), AllXMods(n)" ); 
end );

#############################################################################
##
#M  IsoclinicXModFamily  . . . . all xmods in the list isoclinic to the xmod
##
InstallMethod( IsoclinicXModFamily, "generic method for crossed modules", 
    true, [ Is2dGroup, IsList ], 0,
function( XM, XM1_ler )

    local  sonuc, sayi, XM1;

    sonuc := [];
    sayi := 0;
    for XM1 in XM1_ler do
        if AreIsoclinicXMods(XM,XM1) then
            Print(XM," ~ ",XM1,"\n" );    
            Add(sonuc,Position(XM1_ler,XM1));
            sayi := sayi + 1;            
        else
            Print(XM," |~ ",XM1,"\n" );            
        fi;        
    od; 
    ## Print(sayi,"\n");
    return sonuc;
end );

#############################################################################
##
#M  IsomorphicXModFamily  . . . all xmods in the list isomorphic to the xmod
##
InstallMethod( IsomorphicXModFamily, "generic method for crossed modules", 
    true, [ Is2dGroup, IsList ], 0,
function( XM, XM1_ler )

    local  sonuc, sayi, iso, XM1;

    sonuc := [];
    sayi := 0;
    for XM1 in XM1_ler do
        iso := IsomorphismXMods(XM,XM1); 
        if ( iso <> fail ) then
            # Print(XM," ~ ",XM1,"\n" );    
            Add(sonuc,Position(XM1_ler,XM1));
            sayi := sayi + 1;
        fi;
    od;        
    ## Print(sayi,"\n");
    return sonuc;
end );


#############################################################################
##
#M  IsoAllXMods  . . . . . . . . . . . all crossed modules up to isomorphism
##
InstallMethod( IsoAllXMods, "generic method for crossed modules", true, 
    [ IsList ], 0,
function(allxmods)

    local  n, l, i, j, k, isolar, list1, list2;

    n := Length( allxmods );
    list1 := [];
    list2 := [];
    for i in [1..n] do
        if i in list1 then
            continue;
        else
            isolar := IsomorphicXModFamily(allxmods[i],allxmods);
            Append(list1,isolar);        
            Add(list2,allxmods[i]);
        fi; 
    od; 
    return list2;
end );

#############################################################################
##
#M  RankXMod  . . . . . . . . . . . . . . . . the rank of the crossed module
##
InstallMethod( RankXMod, "generic method for crossed modules", true, 
    [ Is2dGroup ], 0,
function(XM)

    local  ZXMod, DXMod, BXMod, KXMod, m1, m2, l1, l2;

    ZXMod := CentreXMod(XM);
    DXMod := DerivedSubXMod(XM);
    BXMod := FactorXMod(XM,ZXMod);
    KXMod := IntersectionSubXMod(XM,ZXMod,DXMod);
    m1 := Size(BXMod);
    m2 := Size(KXMod);
    l1 := Log2(Float(m1[1])) + Log2(Float(m2[1]));
    l2 := Log2(Float(m1[2])) + Log2(Float(m2[2]));
    return [l1,l2];
end );

#############################################################################
##
#M  MiddleLength  . . . . . . . the middle length of the crossed module
##
InstallOtherMethod( MiddleLength, "generic method for crossed modules", true, 
    [ Is2dGroup ], 0,
function(XM)

    local  sonuc, ZXMod, DXMod, BXMod, KXMod, m1, l1, l2;

    ZXMod := CentreXMod(XM);
    DXMod := DerivedSubXMod(XM);
    KXMod := IntersectionSubXMod(XM,DXMod,ZXMod);
    BXMod := FactorXMod(DXMod,KXMod);
    m1 := Size(BXMod);     
    l1 := Log2(Float(m1[1]));
    l2 := Log2(Float(m1[2]));
    return [l1,l2];
end );

#############################################################################
##
#M  TableRowXMod  . .. . table row for isoclinism families of crossed modules
##
InstallMethod( TableRowXMod, "generic method for crossed modules", true, 
    [ Is2dGroup, IsList ], 0,
function(XM,XM_ler)

    local  Eler, Iler, i, j, sinif, B;

    sinif := IsoclinicXModFamily( XM, XM_ler );
    B := LowerCentralSeries( XM );
    
Print("---------------------------------------------------------------------------------------------------------------------------------- \n");
Print("---------------------------------------------------------------------------------------------------------------------------------- \n");
Print("Number","\t","Rank","\t\t","M. L.","\t\t","Class","\t","|G/Z|","\t\t","|g2|","\t\t","|g3|","\t\t","|g4|","\t\t","|g5| \n");
Print("---------------------------------------------------------------------------------------------------------------------------------- \n");
Print(Length(sinif),"\t",RankXMod(XM),"\t",MiddleLength(XM),"\t",NilpotencyClassOf2dGroup(XM),"\t",Size(FactorXMod(XM,CentreXMod(XM))));    

if Length(B) > 1 then
for i in [2..Length(B)] do
        Print("\t");
        Print(Size(B[i]));
        
od;
fi;

Print("\n---------------------------------------------------------------------------------------------------------------------------------- \n");
return sinif;
end );








