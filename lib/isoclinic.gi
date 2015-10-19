#############################################################################
##
#W  isoclinic.gi               GAP4 package `XMod'                Alper Odabas
#W                                                                & Enver Uslu
##  version 2.43, 19/10/2015 
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
function( alpha, r, s )

    local  a; 

    if not ( r in Source(alpha) ) then 
        return fail; 
    fi; 
    a := Image( alpha, r );
    if not ( Range(a) = Source(a) ) then 
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
            d := Displacement( act, h, t ); 
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
#M  IntersectionSubXMods  . . . . intersection of subcrossed modules SH and RK
##
InstallMethod( IntersectionSubXMods, "generic method for crossed modules", 
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
    while not IsDoneIterator( iterT ) do
        iterG := Iterator( AllAutomorphisms( G2 ) ); 
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
                    if AreIsoclinicDomains( gi, SmallGroup( ids[j] ) ) then
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
#M CentralQuotient . . . . . . . . . . . . . . . . . . . .  (G -> G/Z(G))
## 
InstallMethod( CentralQuotient, "generic method for groups", true, 
    [ IsGroup ], 0,
function( G ) 

    local  ZG, Q, nat, XQ; 

    ZG := Centre( G ); 
    Q := FactorGroup( G, ZG ); 
    if HasName(G) then 
        if not HasName(ZG) then 
            SetName( ZG, Concatenation( "Z(", Name(G), ")" ) ); 
        fi;
        SetName( Q, Concatenation( Name(G), "/", Name(ZG) ) ); 
    fi; 
    nat := NaturalHomomorphismByNormalSubgroup( G, ZG ); 
    XQ := XModByCentralExtension( nat ); 
    return XQ;
end );

InstallOtherMethod( CentralQuotient, "generic method for crossed modules", 
    true, [ IsXMod ], 0,
function( XM ) 

    local  act, ZM, QM, ul, ur, dl, dr, nat, up, dn, gdl, gdr, iul, adg, 
           prod, proj1, proj2, map, xp, CrossedSquare; 

    act := XModAction( XM ); 
    ZM := CentreXMod( XM ); 
    QM := FactorXMod( XM, ZM ); 
    ul := Source( XM ); 
    dl := Range( XM );
    ur := Source( QM ); 
    dr := Range( QM );
    if ( HasName(XM) and not HasName(ZM) ) then 
        SetName( ZM, Concatenation( "Z(", Name(XM), ")" ) ); 
    fi; 
    nat := NaturalMorphismByNormalSubXMod( XM, ZM ); 
    up := XModByCentralExtension( SourceHom(nat) );
    dn := XModByCentralExtension( RangeHom(nat) );
    gdl := GeneratorsOfGroup( dl ); 
    gdr := List( gdl, r -> Image( Boundary(dn), r ) ); 
    iul := List( gdl, r -> Image( act, r ) ); 
    adg := GroupHomomorphismByImages( dr, Range(act), gdr, iul );
    prod := DirectProduct( dl, ur );
    proj1 := Projection( prod, 1 );
    proj2 := Projection( prod, 2 );
    map := MappingByFunction( prod, ul, 
               function(c) 
               local  a,s;
               a := Image( act, Image(proj1,c) ); 
               s := PreImagesRepresentative( Boundary(up), Image(proj2,c) );  
               return Image(a,s^-1)*s; 
               end );
    xp := XPairObj( [dl,ur], ul, map );
    CrossedSquare := PreCrossedSquareObj( up, XM, dn, QM, adg, xp );
    SetIsCrossedSquare( CrossedSquare, true );
    if HasName(XM) then 
        SetName( QM, Concatenation( Name(XM), "/", Name(ZM) ) ); 
    fi;
    return CrossedSquare;
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
#M AreIsoclinicDomains . . . . . . . . . . . for two domains: groups or xmods
## 
InstallMethod( AreIsoclinicDomains, "generic method for two groups or xmods", 
    true, [ IsDomain, IsDomain ], 0,
function( D1, D2 ) 
    local  iso;
    if not ( ( IsGroup(D1) and IsGroup(D2) ) or 
             ( Is2dGroup(D1) and Is2dGroup(D2) ) ) then 
        Error( "D1 and D2 should be groups or 2dgroups" ); 
    fi; 
    iso := Isoclinism( D1, D2 );
    if ( ( iso = fail ) or ( iso = false ) ) then 
        return false; 
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

    local  CQ1, CQ2, Q1, Q2, D1, D2, nhom1, nhom2, sgQ1, lsgQ1, itAQ2, itAD2, 
           isoQ, isoD, p1, q1, p2, q2, i, iq1, iq2, j, g1, h1, 
           g2, h2, gor1, gor2, ok;

    if ( IsomorphismGroups(G1,G2) <> fail ) then 
        Error( "not yet implemented" ); 
        return true;
    fi;
    CQ1 := CentralQuotient(G1);
    Q1 := Range(CQ1);
    CQ2 := CentralQuotient(G2);
    Q2 := Range(CQ2);
    D1 := DerivedSubgroup(G1);
    D2 := DerivedSubgroup(G2);
    isoQ := IsomorphismGroups(Q1,Q2);
    isoD := IsomorphismGroups(D1,D2);
    if ( ( isoQ = fail ) or ( isoD = fail ) ) then 
        return fail;
    fi;
    nhom1 := Boundary( CQ1 );
    nhom2 := Boundary( CQ2 );
    itAQ2 := Iterator( AllAutomorphisms(Q2) ); 
    sgQ1 := SmallGeneratingSet( Q1 );
    lsgQ1 := Length( sgQ1 ); 
    while not IsDoneIterator( itAQ2 ) do 
        i := isoQ * NextIterator( itAQ2 ); 
        ok := true;
        itAD2 := Iterator( AllAutomorphisms(D2) );
        while not IsDoneIterator( itAD2 ) do 
            j := isoD * NextIterator(itAD2); 
            ok := true;
            p1 := 0; 
            while ( ok and ( p1 < lsgQ1 ) ) do 
                p1 := p1+1; 
                q1 := sgQ1[p1]; 
                g1 := PreImagesRepresentative( nhom1, q1 );
                iq1 := Image( i, q1 );
                h1 := PreImagesRepresentative( nhom2, iq1 );
                p2 := 0;
                while ( ok and ( p2 < lsgQ1 ) ) do 
                    p2 := p2+1;
                    q2 := sgQ1[p2];
                    g2 := PreImagesRepresentative( nhom1, q2 );
                    iq2 := Image( i, q2 ); 
                    h2 := PreImagesRepresentative( nhom2, iq2 );            
                    gor1 := Image( j, Comm(g1,g2) );    
                    gor2 := Comm( h1, h2 );
                    ok := ( gor1 = gor2 ); 
                od;
            od;
            if ok then 
                return [i,j];
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
    for i in divs{[2..len-1]} do 
        for gi in AllSmallGroups( i ) do 
            if IsStemGroup( gi ) then
                if AreIsoclinicDomains( G, gi ) then 
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

InstallOtherMethod( Isoclinism, "generic method for crossed modules", true, 
    [ IsXMod, IsXMod ], 0,
function( X1, X2 )

    local  SX1, RX1, SX2, RX2, D1, D2, isoD, autD2, CX1, Q1, CX2, Q2, isoQ, 
           SQ1, RQ1, SQ2, RQ2, actX1, actX2, autQ2, nhom1, shom1, rhom1, 
           nhom2, shom2, rhom2, sgRQ1, lsgRQ1, sgSQ1, lsgSQ1, a, i, si, ri, 
           ok, b, j, sj, rj, p1, r1, x1, ir1, d1, p2, r2, x2, ir2, d2, 
           gor1, gor2, p3, s1, y1, is1, e1; 

    SX1 := Source(X1);
    RX1 := Range(X1);
    SX2 := Source(X2);
    RX2 := Range(X2);
    actX1 := XModAction( X1 );
    actX2 := XModAction( X2 );
    D1 := DerivedSubXMod(X1);
    D2 := DerivedSubXMod(X2);
    ## check condition 2 : require D1 ~ D2 
    isoD := IsomorphismXMods( D1, D2 ); 
    if ( isoD = fail ) then 
        Print( "derived subcrossed modules are not isomorphic\n" );
        return fail; 
    fi;
    autD2 := AutomorphismPermGroup( D2 ); 

    CX1 := CentralQuotient( X1 );
    Q1 := Right2dGroup( CX1 );
    CX2 := CentralQuotient( X2 ); 
    Q2 := Right2dGroup( CX2 ); 
    ## check condition 1 : require Q1 ~ Q2 
    isoQ := IsomorphismXMods( Q1, Q2 ); 
    if ( isoQ = fail ) then 
        Print( "factor crossed modules X/ZX are not isomorphic\n" );
        return fail; 
    fi;

    SQ1 := Source(Q1);
    RQ1 := Range(Q1);
    SQ2 := Source(Q2);
    RQ2 := Range(Q2);
    autQ2 := AutomorphismPermGroup( Q2 ); 
    nhom1 := LeftRightMorphism( CX1 ); 
    shom1 := SourceHom( nhom1 );
    rhom1 := RangeHom( nhom1 ); 
    nhom2 := LeftRightMorphism( CX2 ); 
    shom2 := SourceHom( nhom2 );
    rhom2 := RangeHom( nhom2 ); 
    sgRQ1 := SmallGeneratingSet( RQ1 ); 
    lsgRQ1 := Length( sgRQ1 ); 
    sgSQ1 := SmallGeneratingSet( SQ1 ); 
    lsgSQ1 := Length( sgSQ1 ); 

    for a in autQ2 do 
        i := isoQ * PermAutomorphismAsXModMorphism( Q2, a ); 
        si := SourceHom( i ); 
        ri := RangeHom( i );
        ok := true; 
        for b in autD2 do 
            j := isoD * PermAutomorphismAsXModMorphism( D2, b );
            sj := SourceHom( j );
            rj := RangeHom( j );
            ok := true; 
            p1 := 0; 
            while ( ok and ( p1 < lsgRQ1 ) ) do
                p1 := p1+1;
                r1 := sgRQ1[p1];
                x1 := PreImagesRepresentative( rhom1, r1 );
                ir1 := Image( ri, r1 ); 
                d1 := PreImagesRepresentative( rhom2, ir1 );
                p2 := 0;
                while ( ok and ( p2 < lsgRQ1 ) ) do
                    p2 := p2+1;
                    r2 := sgRQ1[p2];
                    x2 := PreImagesRepresentative( rhom1, r2 );
                    ir2 := Image( ri, r2 ); 
                    d2 := PreImagesRepresentative( rhom2, ir2 );
                    gor1 := Image( rj, Comm(x1,x2) );
                    gor2 := Comm( d1, d2 );
                    ok := ( gor1 = gor2 ); 
                od;
                p3 := 0;
                while ( ok and ( p3 < lsgSQ1 ) ) do 
                    p3 := p3+1;
                    s1 := sgSQ1[p3];
                    y1 := PreImagesRepresentative( shom1, s1 );
                    is1 := Image( si, s1 );
                    e1 := PreImagesRepresentative( shom2, is1 );
                    gor1 := Image( sj, Displacement( actX1, x1, y1 ) ); 
                    gor2 := Displacement( actX2, d1, e1 );
                    ok := ( gor1 = gor2 ); 
                od;
            od;
            if ok then 
                return [i,j]; 
            fi; 
        od;
    od; 
    Info( InfoXMod, 1, "no morphism exists satisfying the conditions" );    
    return fail;
end );


#############################################################################
##
#M  IsoclinicXModFamily  . . . . all xmods in the list isoclinic to the xmod
##
InstallMethod( IsoclinicXModFamily, "generic method for crossed modules", 
    true, [ Is2dGroup, IsList ], 0,
function( XM, XM1_ler )

    local  sonuc, XM1;

    sonuc := [ ];
    for XM1 in XM1_ler do
        if AreIsoclinicDomains( XM, XM1 ) then
            Print(XM," ~ ",XM1,"\n" );    
            Add( sonuc, Position(XM1_ler,XM1) );
        else
            Print(XM," |~ ",XM1,"\n" );            
        fi;        
    od; 
    return sonuc;
end );

#############################################################################
##
#M  IsomorphicXModFamily  . . . all xmods in the list isomorphic to the xmod
##
InstallMethod( IsomorphicXModFamily, "generic method for crossed modules", 
    true, [ Is2dGroup, IsList ], 0,
function( XM, XM1_ler )

    local  sonuc, iso, XM1;

    sonuc := [ ];
    for XM1 in XM1_ler do
        iso := IsomorphismXMods( XM, XM1 ); 
        if ( iso <> fail ) then
            Add( sonuc, Position(XM1_ler,XM1) );
        fi;
    od; 
    return sonuc;
end );

#############################################################################
##
#M  AllXModsUpToIsomorphism . . .  . . all crossed modules up to isomorphism
##
InstallMethod( AllXModsUpToIsomorphism, "generic method for list of xmods", 
    true, [ IsList ], 0,
function( allxmods )

    local  n, found, all, i, j, k, isolar, list;

    n := Length( allxmods ); 
    found := ListWithIdenticalEntries( n, 0 );
    all := ShallowCopy( allxmods ); 
    list := [];
    for i in [1..n] do
        if ( found[i] = 0 ) then
            Add( list, allxmods[i] );
            isolar := IsomorphicXModFamily( allxmods[i], all );
            for j in isolar do 
                k := Position( allxmods, all[j] ); 
                found[k] := 1; 
            od;
        fi; 
    od; 
    return list;
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
    KXMod := IntersectionSubXMods(XM,ZXMod,DXMod);
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
    KXMod := IntersectionSubXMods(XM,DXMod,ZXMod);
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








