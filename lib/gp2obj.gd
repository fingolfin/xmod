##############################################################################
##
#W  gp2obj.gd                  GAP4 package `XMod'               Chris Wensley
#W                                                                 & Murat Alp
#Y  Copyright (C) 2001-2017, Chris Wensley et al,  
#Y  School of Computer Science, Bangor University, U.K. 

#############################################################################
##
#P  IsPreXModDomain( <obj> )
#P  IsPreCat1Domain( <obj> )
## 
##  these apply to groups, algebras, whatever ... 
##
DeclareProperty( "IsPreXModDomain", Is2DimensionalDomain );
DeclareProperty( "IsPreCat1Domain", Is2DimensionalDomain );

#############################################################################
##
#R  IsPreXModObj( <obj> )
##    A pre-crossed module is a group homomorphism which preserves an action
#R  IsPreCat1Obj( <obj> )
##    A pre-cat1-group is a pair of group endomorphisms with a common image
##  
DeclareRepresentation( "IsPreXModObj", Is2DimensionalGroup and 
    IsAttributeStoringRep, [ "boundary", "action" ] );
DeclareRepresentation( "IsPreCat1Obj", Is2DimensionalGroup and 
    IsAttributeStoringRep, [ "tailMap", "headMap", "rangeEmbedding" ] );

#############################################################################
##
#P  IsPerm2DimensionalGroup( <obj> )
#P  IsFp2DimensionalGroup( <obj> )
#P  IsPc2DimensionalGroup( <obj> )
##
DeclareProperty( "IsPerm2DimensionalGroup", Is2DimensionalGroup );
DeclareProperty( "IsFp2DimensionalGroup", Is2DimensionalGroup );
DeclareProperty( "IsPc2DimensionalGroup", Is2DimensionalGroup );

#############################################################################
##
#P  IsPreXMod( <PM> )
#P  IsPermPreXMod( <PM> )
#P  IsFpPreXMod( <PM> )
#P  IsPcPreXMod( <PM> )
##
DeclareProperty( "IsPreXMod", Is2DimensionalGroup );
DeclareSynonym( "IsPermPreXMod", IsPreXMod and IsPerm2DimensionalGroup );
DeclareSynonym( "IsFpPreXMod", IsPreXMod and IsFp2DimensionalGroup );
DeclareSynonym( "IsPcPreXMod", IsPreXMod and IsPc2DimensionalGroup );

#############################################################################
##
#P  IsXMod( <PM> )
#P  IsPermXMod( <XM> )
#P  IsFpXMod( <XM> )
#P  IsPcXMod( <XM> )
##
DeclareProperty( "IsXMod", IsPreXMod ); 
DeclareSynonym( "IsPermXMod", IsXMod and IsPerm2DimensionalGroup );
DeclareSynonym( "IsFpXMod", IsXMod and IsFp2DimensionalGroup );
DeclareSynonym( "IsPcXMod", IsXMod and IsPc2DimensionalGroup );

#############################################################################
##
#P  IsPreCat1Group( <PCG> )
#P  IsPermPreCat1Group( <PCG> )
#P  IsFpPreCat1Group( <PCG> )
#P  IsPcPreCat1Group( <PCG> )
##
DeclareProperty( "IsPreCat1Group", Is2DimensionalGroup );
DeclareSynonym( "IsPermPreCat1Group", 
    IsPreCat1Group and IsPerm2DimensionalGroup );
DeclareSynonym( "IsFpPreCat1Group", IsPreCat1Group and IsFp2DimensionalGroup );
DeclareSynonym( "IsPcPreCat1Group", IsPreCat1Group and IsPc2DimensionalGroup );

#############################################################################
##
#P  IsCat1Group( <C1G> )
#P  IsPermCat1Group( <CG> )
#P  IsFpCat1Group( <CG> )
#P  IsPcCat1Group( <CG> )
##
DeclareProperty( "IsCat1Group", IsPreCat1Group );
DeclareSynonym( "IsPermCat1Group", IsCat1Group and IsPerm2DimensionalGroup );
DeclareSynonym( "IsFpCat1Group", IsCat1Group and IsFp2DimensionalGroup );
DeclareSynonym( "IsPcCat1Group", IsCat1Group and IsPc2DimensionalGroup );

#############################################################################
##
#O  PreXModObj( <bdy>, <act> )
#A  Boundary( <PM> )
#A  AutoGroup( <PM> )
#A  XModAction( <PM> )
#A  ExternalSetXMod( <PM> )
##
DeclareOperation( "PreXModObj", [ IsGroupHomomorphism, IsGroupHomomorphism ] );
DeclareAttribute( "Boundary", IsPreXMod );
DeclareAttribute( "AutoGroup", IsPreXMod );
DeclareAttribute( "XModAction", IsPreXMod );
DeclareAttribute( "ExternalSetXMod", IsPreXMod ); 

#############################################################################
##
#A  PeifferSubgroup( <obj> )
#A  PeifferSub2DimensionalGroup( <obj> )
#O  PeifferSubgroupPreXMod( <PM> )
#O  PeifferSubgroupPreCat1Group( <P1C> )
##
DeclareAttribute( "PeifferSubgroup", Is2DimensionalGroup );
DeclareAttribute( "PeifferSub2DimensionalGroup", Is2DimensionalGroup );
DeclareOperation( "PeifferSubgroupPreXMod", [ IsPreXMod ] );
DeclareOperation( "PeifferSubgroupPreCat1Group", [ IsPreCat1Group ] );

#############################################################################
##
#O  PreXModByBoundaryAndAction( <bdy>, <act> )
##
DeclareOperation( "PreXModByBoundaryAndAction",
   [ IsGroupHomomorphism, IsGroupHomomorphism ] );

#############################################################################
##
#F  XMod( <args> )
#O  AsXMod( <arg> )
#O  XModByBoundaryAndAction( <bdy>, <act> )
#O  XModByTrivialAction( <f> )
#O  XModByNormalSubgroup( <G>, <N> )
#O  XModByCentralExtension( <hom> )
#O  XModByGroupOfAutomorphisms( <G>, <A> )
#F  XModByAutomorphismGroup( <args> )
#A  XModByInnerAutomorphismGroup( <G> )
#O  XModByAbelianModule( <R> )
#A  XModByPeifferQuotient( <PM> )
##
DeclareGlobalFunction( "XMod" );
DeclareOperation( "AsXMod", [ IsDomain ] );
DeclareOperation( "XModByBoundaryAndAction",
   [ IsGroupHomomorphism, IsGroupHomomorphism ] );
DeclareOperation( "XModByTrivialAction", [ IsGroupHomomorphism ] );
DeclareOperation( "XModByNormalSubgroup", [ IsGroup, IsGroup ] );
DeclareOperation( "XModByCentralExtension", [ IsGroupHomomorphism ] );
DeclareOperation( "XModByGroupOfAutomorphisms", 
    [ IsGroup, IsGroupOfAutomorphisms ] );
DeclareGlobalFunction( "XModByAutomorphismGroup" );
DeclareAttribute( "XModByInnerAutomorphismGroup", IsGroup );
DeclareOperation( "XModByAbelianModule", [ IsAbelianModule ] );
DeclareAttribute( "XModByPeifferQuotient", IsPreXMod );

#############################################################################
##
#P  IsTrivialAction2DimensionalGroup( <obj> )
#P  IsNormalSubgroup2DimensionalGroup( <obj> )
#P  IsCentralExtension2DimensionalGroup( <obj> )
#P  IsAutomorphismGroup2DimensionalGroup( <XM> )
#P  IsAbelianModule2DimensionalGroup( <obj> )
#P  IsFreeXMod( <XM> )
##
DeclareProperty( "IsTrivialAction2DimensionalGroup", Is2DimensionalGroup );
DeclareProperty( "IsNormalSubgroup2DimensionalGroup", Is2DimensionalGroup );
DeclareProperty( "IsCentralExtension2DimensionalGroup", Is2DimensionalGroup );
DeclareProperty( "IsAutomorphismGroup2DimensionalGroup", Is2DimensionalGroup );
DeclareProperty( "IsAbelianModule2DimensionalGroup", Is2DimensionalGroup );
DeclareProperty( "IsFreeXMod", IsPreXModObj );

#############################################################################
##
#O  IsSubPreXMod( <obj> )
#O  IsSubXMod( <obj> )
#O  IsSubPreCat1Group( <obj> )
#O  IsSubCat1Group( <obj> )
##
DeclareOperation( "IsSubPreXMod", 
    [ Is2DimensionalGroup, Is2DimensionalGroup ] );
DeclareOperation( "IsSubXMod", [ Is2DimensionalGroup, Is2DimensionalGroup ] );
DeclareOperation( "IsSubPreCat1Group", 
    [ Is2DimensionalGroup, Is2DimensionalGroup ] );
DeclareOperation( "IsSubCat1Group", [ Is2DimensionalGroup, Is2DimensionalGroup ] );

##############################################################################
##
#O  Sub2DimensionalGroup( <obj>, <src>, <rng> )
#O  SubPreXMod( <PM, Ssrc, Srng> )
#O  SubXMod( <PM, Ssrc, Srng> )
#O  SubPreCat1Group( <C>, <H> )                           
##
DeclareOperation( "Sub2DimensionalGroup", 
    [ Is2DimensionalGroup, IsGroup, IsGroup ] );
DeclareOperation( "SubPreXMod", [ IsPreXMod, IsGroup, IsGroup ] );
DeclareOperation( "SubXMod", [ IsXMod, IsGroup, IsGroup ] );
DeclareOperation( "SubPreCat1Group", [ IsPreCat1Group, IsGroup, IsGroup ] );
DeclareOperation( "SubCat1Group", [ IsCat1Group, IsGroup, IsGroup ] );

#############################################################################
##
#O  TrivialSub2DimensionalGroup( <obj> )
#A  TrivialSubPreXMod( <obj> )
#A  TrivialSubXMod( <obj> )
#A  TrivialSubPreCat1Group( <obj> )
#A  TrivialSubCat1Group( <obj> )
#P  IsIdentityCat1Group( <obj> )
#P  IsEndomorphismPreCat1Group( <obj> )
##
DeclareOperation( "TrivialSub2DimensionalGroup", [ Is2DimensionalGroup ] );
DeclareAttribute( "TrivialSubPreXMod", IsPreXMod );
DeclareAttribute( "TrivialSubXMod", IsXMod );
DeclareAttribute( "TrivialSubPreCat1Group", IsPreCat1Group );
DeclareAttribute( "TrivialSubCat1Group", IsCat1Group );
DeclareProperty( "IsIdentityCat1Group", IsCat1Group );
DeclareProperty( "IsEndomorphismPreCat1Group", IsPreCat1Group ); 

#############################################################################
##
#O  PreCat1Obj( <arg> )
#A  HeadMap( <PCG> )
#A  TailMap( <PCG> )
#A  RangeEmbedding( <PCG> )
#A  KernelEmbedding( <C> )
##
DeclareOperation( "PreCat1Obj",
    [ IsGroupHomomorphism, IsGroupHomomorphism, IsGroupHomomorphism ] );
DeclareAttribute( "HeadMap", IsPreCat1Group );
DeclareAttribute( "TailMap", IsPreCat1Group );
DeclareAttribute( "RangeEmbedding", IsPreCat1Group );
DeclareAttribute( "KernelEmbedding", IsPreCat1Group );

#############################################################################
##
#F  PreCat1Group( <arg> )
#O  PreCat1GroupByTailHeadEmbedding( <t>, <h>, <e> )
#O  PreCat1GroupByEndomorphisms( <tail>, <head> )
#A  EndomorphismPreCat1Group( <PCG> ) 
#O  PreCat1GroupByNormalSubgroup( <G>, <N> )
#A  ReverseCat1Group( <PCG> )
##
DeclareGlobalFunction( "PreCat1Group" );
DeclareOperation( "PreCat1GroupByTailHeadEmbedding",
    [ IsGroupHomomorphism, IsGroupHomomorphism, IsGroupHomomorphism ] );
DeclareOperation( "PreCat1GroupByEndomorphisms",
    [ IsGroupHomomorphism, IsGroupHomomorphism ] );
DeclareAttribute( "EndomorphismPreCat1Group", IsPreCat1Group ); 
DeclareOperation( "PreCat1GroupByNormalSubgroup", [ IsGroup, IsGroup ] );
DeclareAttribute( "ReverseCat1Group", IsPreCat1Group );

#############################################################################
##
#O  PreXModByPreCat1Group( <PCG> )
#O  PreCat1GroupByPreXMod( <PM> )
#A  XModOfCat1Group( <C1G> )
#O  XModByCat1Group( <C1G> )
#A  Cat1GroupOfXMod( <XM> )
#O  Cat1GroupByXMod( <XM> )
##
DeclareOperation( "PreXModByPreCat1Group", [ IsPreCat1Group ] );
DeclareOperation( "PreCat1GroupByPreXMod", [ IsPreXMod ] );
DeclareAttribute( "XModOfCat1Group", IsCat1Group );
DeclareOperation( "XModByCat1Group", [ IsCat1Group ] );
DeclareAttribute( "Cat1GroupOfXMod", IsXMod );
DeclareOperation( "Cat1GroupByXMod", [ IsXMod ] );

#############################################################################
##
#A  SourceEmbedding( <XM> )
##
##  homomorphism from Source(XM) to Source(Cat1GroupOfXMod(XM))
##
DeclareAttribute( "SourceEmbedding", IsPreXMod );

#############################################################################
##
#F  Cat1Group( <arg> )
#O  Cat1Select( <size>, <gpnum>, <num> )
#O  PermCat1Select( <size>, <gpnum>, <num> )
#O  Cat1GroupByPeifferQuotient( <PM> )
#O  DiagonalCat1Group( <list> )
#O  AllCat1Groups( <gp> )
##
DeclareGlobalFunction( "Cat1Group" );
DeclareOperation( "Cat1Select", [ IsInt, IsInt, IsInt ] );
DeclareOperation( "PermCat1Select", [ IsInt, IsInt, IsInt ] );
DeclareOperation( "Cat1GroupByPeifferQuotient", [ IsPreCat1Group ] );
DeclareOperation( "DiagonalCat1Group", [ IsList ] ); 
DeclareOperation( "AllCat1Groups", [ IsGroup ] ); 

#############################################################################
##
#A  DirectProduct2dInfo( <D> )
#A  Coproduct2dInfo( <D> )
##
DeclareAttribute( "DirectProduct2dInfo", Is2DimensionalDomain, "mutable" );
DeclareAttribute( "Coproduct2dInfo", Is2DimensionalDomain, "mutable" );

#############################################################################
##
#A  NormalSubXMods( <XM> )
#A  NormalSubXCat1Groups( <C1G> )
##
DeclareAttribute( "NormalSubXMods", IsXMod );
DeclareAttribute( "NormalSubCat1Groups", IsCat1Group );

#############################################################################
##
#E  gp2obj.gd . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
