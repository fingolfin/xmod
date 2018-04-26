##############################################################################
##
#W  loops.tst                   GAP4 package `XMod'              Chris Wensley
##  
#Y  Copyright (C) 2001-2018, Chris Wensley et al, 
#Y  School of Computer Science, Bangor University, U.K. 

gap> START_TEST( "XMod package: loops.tst" );
gap> saved_infolevel_xmod := InfoLevel( InfoXMod );; 
gap> SetInfoLevel( InfoXMod, 1 );;

gap> F2 := FreeGroup( 2 );; 
gap> a2 := F2.1;;  b2 := F2.2;; 
gap> rels := [ a2^4, b2^4, a2^(-1)*b2*a2*b2 ];; 
gap> M2 := F2/rels;; 
gap> M1 := PcGroupFpGroup( M2 );; 
#I  You are creating a Pc group with non-prime relative orders.
#I  Many algorithms require prime relative orders.
#I  Use `RefinedPcGroup' to convert.
gap> M0 := RefinedPcGroup( M1 );; 
gap> genM0 := GeneratorsOfGroup( M0 );; 
gap> a := M0.1;;  b := M0.2;;  c := M0.3;;  d := M0.4;; 
gap> [ c^2=d, a^2=b, c^a=c^-1 ]; 
[ true, true, true ]
gap> SetName( M0, "c4|Xc4" ); 

gap> X0 := XModByAutomorphismGroup( M0 );; 
gap> Display( X0 );
Crossed module [c4|Xc4->PAut(c4|Xc4)] :- 
: Source group c4|Xc4 has generators:
  [ f1, f2, f3, f4 ]
: Range group has generators:
  [ f1, f2, f3, f4, f5 ]
: Boundary homomorphism maps source generators to:
  [ f2, <identity> of ..., f5, <identity> of ... ]
: Action homomorphism maps range generators to automorphisms:
  f1 --> { source gens --> [ f1, f2, f2*f3, f4 ] }
  f2 --> { source gens --> [ f1, f2, f3*f4, f4 ] }
  f3 --> { source gens --> [ f1*f2*f3, f2, f3, f4 ] }
  f4 --> { source gens --> [ f1*f3, f2, f3, f4 ] }
  f5 --> { source gens --> [ f1*f4, f2, f3, f4 ] }
  These 5 automorphisms generate the group of automorphisms.

gap> bdy0 := Boundary( X0 );; 
gap> A0 := AutomorphismGroup( M0 );; 
gap> isoP0 := IsomorphismPcGroup( A0 );; 
gap> Range( X0 ) = Range( isoP0 ); 
true 
gap> P0 := Range( X0 );; 
gap> Size( P0 ); 
32
gap> genP0 := GeneratorsOfGroup( P0 );; 
gap> g1 := genP0[1];;  g2 := genP0[2];;  g3 := genP0[3];; 
gap> g4 := genP0[4];;  g5 := genP0[5];; 
gap> act := XModAction( X0 );; 
gap> igenP0 := List( genP0, g -> ImageElm( act, g ) );; 
gap> ima := List( igenP0, g -> ImageElm( g, a ) ); 
[ f1, f1, f1*f2*f3, f1*f3, f1*f4 ]
gap> imc := List( igenP0, g -> ImageElm( g, c ) ); 
[ f2*f3, f3*f4, f3, f3, f3 ]
gap> for p in P0 do 
>        Print( "-------------------------------------------------\n" );;
>        ip := Image( act, p );; 
>        Print( [p,ip], "\n" ); 
>        if ( ( ImageElm(ip,a) = a*b^2 ) and ( ImageElm(ip,b) = b ) ) then 
>            Print( "alpha = ", p, "\n" );; 
>        fi;;
>        if ( ( ImageElm(ip,a) = a ) and ( ImageElm(ip,b) = b^-1 ) ) then 
>            Print( "beta = ", p, "\n" );; 
>        fi;;
>        if ( ( ImageElm(ip,a) = a^-1 ) and ( ImageElm(ip,b) = b ) ) then 
>            Print( "gamma = ", p, "\n" );; 
>        fi;;
>        if ( ( ImageElm(ip,a) = a ) and ( ImageElm(ip,b) = a^2*b ) ) then 
>            Print( "delta = ", p, "\n" );; 
>        fi;;
>        if ( ( ImageElm(ip,a) = a*b ) and ( ImageElm(ip,b) = b ) ) then 
>            Print( "tau = ", p, "\n" );; 
>        fi;;
>        if ( ( ImageElm(ip,a) = a ) and ( ImageElm(ip,b) = b^a ) ) then 
>            Print( "conjugation by a = ", p, "\n" );; 
>        fi;;
>        if ( ( ImageElm(ip,a) = a^b ) and ( ImageElm(ip,b) = b ) ) then 
>            Print( "conjugation by b = ", p, "\n" );; 
>        fi;;
>    od; 
-------------------------------------------------
[ <identity> of ..., IdentityMapping( c4|Xc4 ) ]
alpha = <identity> of ...
beta = <identity> of ...
conjugation by a = <identity> of ...
conjugation by b = <identity> of ...
-------------------------------------------------
[ f5, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f4, f2, f3, f4 ] ]
-------------------------------------------------
[ f4, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f3, f2, f3, f4 ] ]
-------------------------------------------------
[ f4*f5, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f3*f4, f2, f3, f4 ] ]
-------------------------------------------------
[ f3, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f2*f3, f2, f3, f4 ] ]
-------------------------------------------------
[ f3*f5, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f2*f3*f4, f2, f3, f4 ] ]
-------------------------------------------------
[ f3*f4, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f2*f4, f2, f3, f4 ] ]
-------------------------------------------------
[ f3*f4*f5, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f2, f2, f3, f4 ] ]
gamma = f3*f4*f5
tau = f3*f4*f5
-------------------------------------------------
[ f2, Pcgs([ f1, f2, f3, f4 ]) -> [ f1, f2, f3*f4, f4 ] ]
alpha = f2
beta = f2
conjugation by a = f2
conjugation by b = f2
-------------------------------------------------
[ f2*f5, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f4, f2, f3*f4, f4 ] ]
-------------------------------------------------
[ f2*f4, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f3, f2, f3*f4, f4 ] ]
-------------------------------------------------
[ f2*f4*f5, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f3*f4, f2, f3*f4, f4 ] ]
-------------------------------------------------
[ f2*f3, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f2*f3, f2, f3*f4, f4 ] ]
-------------------------------------------------
[ f2*f3*f5, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f2*f3*f4, f2, f3*f4, f4 ] ]
-------------------------------------------------
[ f2*f3*f4, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f2*f4, f2, f3*f4, f4 ] ]
-------------------------------------------------
[ f2*f3*f4*f5, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f2, f2, f3*f4, f4 ] ]
gamma = f2*f3*f4*f5
tau = f2*f3*f4*f5
-------------------------------------------------
[ f1, Pcgs([ f1, f2, f3, f4 ]) -> [ f1, f2, f2*f3, f4 ] ]
alpha = f1
beta = f1
conjugation by a = f1
conjugation by b = f1
-------------------------------------------------
[ f1*f5, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f4, f2, f2*f3, f4 ] ]
-------------------------------------------------
[ f1*f4, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f3, f2, f2*f3, f4 ] ]
-------------------------------------------------
[ f1*f4*f5, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f3*f4, f2, f2*f3, f4 ] ]
-------------------------------------------------
[ f1*f3, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f2*f3, f2, f2*f3, f4 ] ]
-------------------------------------------------
[ f1*f3*f5, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f2*f3*f4, f2, f2*f3, f4 ] ]
-------------------------------------------------
[ f1*f3*f4, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f2*f4, f2, f2*f3, f4 ] ]
-------------------------------------------------
[ f1*f3*f4*f5, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f2, f2, f2*f3, f4 ] ]
gamma = f1*f3*f4*f5
tau = f1*f3*f4*f5
-------------------------------------------------
[ f1*f2, Pcgs([ f1, f2, f3, f4 ]) -> [ f1, f2, f2*f3*f4, f4 ] ]
alpha = f1*f2
beta = f1*f2
conjugation by a = f1*f2
conjugation by b = f1*f2
-------------------------------------------------
[ f1*f2*f5, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f4, f2, f2*f3*f4, f4 ] ]
-------------------------------------------------
[ f1*f2*f4, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f3, f2, f2*f3*f4, f4 ] ]
-------------------------------------------------
[ f1*f2*f4*f5, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f3*f4, f2, f2*f3*f4, f4 ] ]
-------------------------------------------------
[ f1*f2*f3, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f2*f3, f2, f2*f3*f4, f4 ] ]
-------------------------------------------------
[ f1*f2*f3*f5, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f2*f3*f4, f2, f2*f3*f4, f4 ] ]
-------------------------------------------------
[ f1*f2*f3*f4, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f2*f4, f2, f2*f3*f4, f4 ] ]
-------------------------------------------------
[ f1*f2*f3*f4*f5, Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f2, f2, f2*f3*f4, f4 ] ]
gamma = f1*f2*f3*f4*f5
tau = f1*f2*f3*f4*f5

gap> alpha := ImageElm( act, g5 ); 
Pcgs([ f1, f3, f2, f4 ]) -> [ f1*f4, f3, f2, f4 ]
gap> beta := ImageElm( act, g2 ); 
Pcgs([ f1, f3, f2, f4 ]) -> [ f1, f3*f4, f2, f4 ]
gap> gamma := ImageElm( act, g3*g4*g5 ); 
Pcgs([ f1, f2, f3, f4 ]) -> [ f1*f2, f2, f3, f4 ]
gap> delta := ImageElm( act, g1 ); 
Pcgs([ f1, f3, f2, f4 ]) -> [ f1, f2*f3, f2, f4 ]
gap> tau := ImageElm( act, g4 ); 
Pcgs([ f1, f3, f2, f4 ]) -> [ f1*f3, f3, f2, f4 ]

gap> all := AllLoopsXMod( X0 ); 
#I  LoopsXMod with a = <identity> of ..., [ 16, 128 ]
#I  LoopsXMod with a = f1, [ 16, 64 ]
#I  LoopsXMod with a = f3, [ 16, 64 ]
#I  LoopsXMod with a = f1*f3, [ 16, 64 ]
#I  LoopsXMod with a = f3*f4, [ 16, 128 ]
[ [c4|Xc4->Group( [ f9, f7, f5, f4, f3, f2, f1 ] )], 
  [c4|Xc4->Group( [ f9, f7, f5, f3*f4, f2, f1 ] )], 
  [c4|Xc4->Group( [ f9, f7, f5, f4, f3, f2*f8 ] )], 
  [c4|Xc4->Group( [ f9, f7, f5, f3*f4, f2*f8, f1*f4 ] )], 
  [c4|Xc4->Group( [ f9, f7, f5, f4, f3, f2, f1 ] )] ]

gap> SetInfoLevel( InfoXMod, saved_infolevel_xmod );; 
gap> STOP_TEST( "loops.tst", 10000 );

##############################################################################
##
#E  loops.tst . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
