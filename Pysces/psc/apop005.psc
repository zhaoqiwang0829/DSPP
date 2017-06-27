# Generated by PySCeS 0.9.0 (2017-06-22 16:17)
 
# Keywords
Description: Tyson1991 - Cell Cycle 6 var
Modelname: BIOMD0000000005
Output_In_Conc: True
Species_In_Conc: True
 
# GlobalUnitDefinitions
UnitVolume: litre, 1.0, 0, 1
UnitArea: metre, 1.0, 0, 2
UnitLength: metre, 1.0, 0, 1
UnitSubstance: mole, 1.0, 0, 1
UnitTime: second, 1.0, 0, 1
 
FIX: CT EmptySet YT 
 
# Compartments
Compartment: cell, 1.0, 3 
 
# Reactions
Reaction2@cell:
    C2 > CP
    cell*C2*Reaction2_k8notP

Reaction3@cell:
    CP > C2
    cell*CP*Reaction3_k9

Reaction1@cell:
    M > C2 + YP
    cell*Reaction1_k6*M

Reaction6@cell:
    EmptySet > Y
    cell*Reaction6_k1aa

Reaction7@cell:
    Y > EmptySet
    cell*Reaction7_k2*Y

Reaction4@cell:
    Y + CP > pM
    cell*CP*Reaction4_k3*Y

Reaction5@cell:
    M > pM
    cell*Reaction5_k5notP*M

Reaction8@cell:
    YP > EmptySet
    cell*Reaction8_k7*YP

Reaction9@cell:
    pM > M
    cell*pM*(Reaction9_k4prime+Reaction9_k4*pow(M/CT,2.0))
# Reaction9 has modifier(s): CT  
 
# Assignment rules
!F CT = C2+CP+M+pM
!F YT = Y+YP+M+pM
 
# Fixed species
CT@cell = 0.0
EmptySet@cell = 0.0
YT@cell = 0.0
 
# Variable species
YP@cell = 0.0
Y@cell = 0.0
C2@cell = 0.0
CP@cell = 0.75
M@cell = 0.0
pM@cell = 0.25
 
# Parameters
Reaction2_k8notP = 1000000.0
Reaction3_k9 = 1000.0
Reaction1_k6 = 1.0
Reaction6_k1aa = 0.015
Reaction7_k2 = 0.0
Reaction4_k3 = 200.0
Reaction5_k5notP = 0.0
Reaction8_k7 = 0.6
Reaction9_k4 = 180.0
Reaction9_k4prime = 0.018
 
