###############################################################################
##
#W  gp2ind.gd                   GAP4 package `XMod'               Chris Wensley
##
#Y  Copyright (C) 2001-2017, Chris Wensley et al,  
#Y  School of Computer Science, Bangor University, U.K. 
##  
##  This file declares functions for induced crossed modules. 
##  
###############################################################################
##  Layout of groups for induced crossed module calculations:
## 
##          Fin. Pres. Groups              Groups
##          =================           ============
##
##        FN=FM -------> FI            N=M -------> I
##            |          |              |           |
##            |          |              |           |
##            V          V              V           V
##           FP -------> FQ             P --------> Q
##
##############################################################################
##  Layout of groups for induced cat1-group calculations:
##
##                                          iota*
##         G ------------> I         PG ------------> PI
##         ||             ||         ||               || 
##         ||             ||         ||               ||  
##         th            t*h*        th              t*h* 
##         ||             ||         ||               || 
##         ||             ||         ||               || 
##         VV             VV         VV               VV 
##         R ------------> Q         PR ------------> PQ
##                                          iota
##
##############################################################################

#############################################################################
##
##  #A  InducedXModData( <IX> )
##
##  DeclareAttribute( "InducedXModData", Is2DimensionalDomain, "mutable" );

#############################################################################
##
#O  CoproductXMod( <xmod>, <xmod> )
#A  CoproductInfo( <xmod> ) 
##
DeclareOperation( "CoproductXMod", [ IsXMod, IsXMod ] ); 
DeclareAttribute( "CoproductInfo", IsXMod, "mutable" );

#############################################################################
##
#P  IsInducedXMod( <IX> )
##
DeclareProperty( "IsInducedXMod", IsXMod );

#############################################################################
##
#A  MorphismOfInducedXMod( <IX> )
##
DeclareAttribute( "MorphismOfInducedXMod", IsInducedXMod );

#############################################################################
##
#F  InducedXMod( <args> )
#O  InclusionInducedXModByCopower( <grp>, <hom>, <trans> )
#O  SurjectiveInducedXMod( <xmod>, <hom> )
##
DeclareGlobalFunction( "InducedXMod" );
DeclareOperation( "InclusionInducedXModByCopower", 
    [ IsXMod, IsGroupHomomorphism, IsList ] );
DeclareOperation( "SurjectiveInducedXMod", [ IsXMod, IsGroupHomomorphism ] );

##############################################################################
##
#F  InducedCat1Group( <args> )
#O  InclusionInducedCat1Data( <grp>, <hom>, <trans> )
#O  InducedCat1GroupByFreeProduct( [ <grp>, <hom> ] )  ???
##
DeclareGlobalFunction( "InducedCat1Group" );
DeclareOperation( "InclusionInducedCat1Data", 
    [ IsCat1Group, IsGroupHomomorphism, IsList ] );
DeclareOperation( "InducedCat1GroupByFreeProduct", [ IsList ] );

##############################################################################
##
#O  AllInducedXMods( <grp> )
#O  AllInducedCat1Groups( <grp> )
##
DeclareGlobalFunction( "AllInducedXMods" );
DeclareGlobalFunction( "AllInducedCat1Groups" );

##############################################################################
##
#E  gp2ind.gd . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
