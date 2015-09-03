#############################################################################
##
##  PackageInfo.g  file for the package XMod 
##  Chris Wensley and Murat Alp 
##

SetPackageInfo( rec(
PackageName := "XMod",
Subtitle := "Crossed Modules and Cat1-Groups",

Version := "2.43",
Date := "03/09/2015",

##  duplicate these values for inclusion in the manual: 
##  <#GAPDoc Label="PKGVERSIONDATA">
##  <!ENTITY VERSION "2.43">
##  <!ENTITY TARFILENAME "xmod-2.43.tar.gz">
##  <!ENTITY HTMLFILENAME "xmod243.html">
##  <!ENTITY RELEASEDATE "03/09/2015">
##  <!ENTITY LONGRELEASEDATE "3rd September 2015">
##  <!ENTITY COPYRIGHTYEARS "1997-2015">
##  <#/GAPDoc>

PackageWWWHome := 
  "http://pages.bangor.ac.uk/~mas023/chda/xmod/",

ArchiveURL := "http://pages.bangor.ac.uk/~mas023/chda/xmod/xmod-2.43", 
ArchiveFormats := ".tar.gz",

Persons := [
  rec(
    LastName      := "Wensley",
    FirstNames    := "Christopher D.",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "c.d.wensley@bangor.ac.uk",
    WWWHome       := "http://www.bangor.ac.uk/~mas023/",
    PostalAddress := Concatenation( [
                       "Dr. C.D. Wensley\n",
                       "School of Computer Science\n",
                       "Bangor University\n",
                       "Dean Street\n",
                       "Bangor\n",
                       "Gwynedd LL57 1UT\n",
                       "UK"] ),
    Place         := "Bangor",
    Institution   := "Bangor University"
  ),
  rec(
    LastName      := "Alp",
    FirstNames    := "Murat",
    IsAuthor      := true,
    Email         := "muratalp@nigde.edu.tr",
    PostalAddress := Concatenation( [ 
                       "Prof. Dr. M. Alp\n",
                       "Nigde Universitesi\n",
                       "Fen-Edebiyat Fakultesi\n",
                       "Matematik Bolumu\n",
                       "Nigde\n",
                       "Turkey"] ),
    Place         := "Nigde",
    Institution   := "Nigde University"
  ),
    rec(
    LastName      := "Odabas",
    FirstNames    := "Alper",
    IsAuthor      := true,
    Email         := "aodabas@ogu.edu.tr",
    PostalAddress := Concatenation( [ 
                       "Dr. A. Odabas \n",
                       "Osmangazi University \n",
                       "Arts and Sciences Faculty \n",
                       "Department of Mathematics and Computer Science \n",
                       "Eskisehir \n",
                       "Turkey"] ),
    Place         := "Eskisehir",
    Institution   := "Osmangazi University"
  ),
    rec(
    LastName      := "Uslu",
    FirstNames    := "Enver Onder",
    IsAuthor      := true,
    Email         := "enveruslu@ogu.edu.tr",
    PostalAddress := Concatenation( [ 
                       "Dr. E. O. Uslu \n",
                       "Osmangazi University \n",
                       "Arts and Sciences Faculty \n",
                       "Department of Mathematics and Computer Science \n",
                       "Eskisehir \n",
                       "Turkey"] ),
    Place         := "Eskisehir",
    Institution   := "Osmangazi University"
  )
],

Status := "accepted",
CommunicatedBy := "Derek Holt (Warwick)",
AcceptDate := "12/1996",

README_URL := 
  Concatenation( ~.PackageWWWHome, "README" ),
PackageInfoURL := 
  Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),

AbstractHTML :=
 "The XMod package provides a collection of functions for computing with \
crossed modules and cat1-groups, their derivations and sections, \
morphisms of these structures, and higher-dimensional generalisations.",

PackageDoc := rec(
  BookName  := "XMod",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Crossed Modules and Cat1-Groups in GAP",
  Autoload  := true
),

Dependencies := rec(
  GAP := ">=4.7",
  NeededOtherPackages := [ ["Gpd", ">= 1.34"], 
                           ["Hap", ">= 1.10"],
                           ["autpgrp", ">= 1.5"] ], 
  SuggestedOtherPackages := [ ["GAPDoc", ">= 1.5.1"] ],
  ExternalConditions := [ ]
),

AvailabilityTest := ReturnTrue,

BannerString := Concatenation( 
  "Loading XMod ", String( ~.Version ), " for GAP 4.7", 
  " - Murat Alp and Chris Wensley ...\n" ),

Autoload := false,

TestFile := "tst/testall.g",

Keywords := ["crossed module", "cat1-group", "derivation", "section", 
             "actor", "crossed square" ]

));
