﻿within BuildSysPro.BuildingStock.IndividualHousing.Mozart.MozartZones;
model ZoneLiving

  // Choix de la RT
  replaceable parameter
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.IndividualHousing.BuildingDataMOZART.BuildingType
    paraMaisonRT "Réglementation thermique utilisée" annotation (
      __Dymola_choicesAllMatching=true, dialog(group="Choix de la RT"));

  // Flux thermiques
parameter Boolean GLOEXT=false
    "Prise en compte de rayonnement GLO vers l'environnement et le ciel"                            annotation(dialog(tab="Flux thermiques"));
parameter Boolean CLOintPlancher=true
    "True : tout le flux est absorbé par le plancher; False : le flux est absorbé par toutes les parois au prorata des surfaces"
                                                                                                        annotation(dialog(tab="Flux thermiques"));
parameter Boolean QVin=false
    "True : commande du débit de renouvellement d'air ; False : débit constant"
                                                                                                annotation(dialog(tab="Flux thermiques"));

  // Parois
parameter Modelica.SIunits.Temperature Tp=293.15
    "Température initiale des parois"
    annotation(dialog(tab="Parois"));
  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState
    "Initialisation en régime stationnaire dans les parois"
    annotation (dialog(tab="Parois"));

  // Portes fenêtres
parameter Boolean useVoletPF=false "true si présence d'un volet, false sinon" annotation(dialog(tab="Portes Fenêtres"));
parameter Boolean useOuverturePF=false
    "true si l'ouverture de fenêtre peut être commandée, false sinon" annotation(dialog(tab="Portes Fenêtres"));
parameter Boolean useReduction1=false
    "Prise en compte ou non des facteurs de reduction"
    annotation (Dialog(tab="Portes Fenêtres"));
parameter Integer TypeFenetrePF1=1
    "Choix du type de fenetre ou porte-fenetre (PF)"
    annotation (Dialog(tab="Portes Fenêtres",enable=useReduction1,group="Paramètres"),
    choices( choice= 1 "Je ne sais pas - pas de menuiserie",
             choice= 2 "Battant Fenêtre Bois",
             choice= 3 "Battant Fenêtre Métal",
             choice= 4 "Battant PF avec soubassement Bois",
             choice= 5 "Battant PF sans soubassement Bois",
             choice= 6 "Battant PF sans soubassement Métal",
             choice= 7 "Coulissant Fenêtre Bois",
             choice= 8 "Coulissant Fenêtre Métal",
             choice= 9 "Coulissant PF avec soubassement Bois",
             choice= 10 "Coulissant PF sans soubassement Bois",
             choice= 11 "Coulissant PF sans soubassement Métal"));
parameter Real voilage1=0.95 "Voilage : = 0.95 si oui et = 1 sinon"
    annotation (Dialog(tab="Portes Fenêtres",enable=useReduction1,group="Paramètres"));
parameter Real position1=0.90
    "Position du vitrage : = 0.9 si interieure et = 1 si exterieure"
    annotation (Dialog(tab="Portes Fenêtres",enable=useReduction1,group="Paramètres"));
parameter Real rideaux1=0.85 "Presence de rideaux : = 0.85 si oui et = 1 sinon"
    annotation (Dialog(tab="Portes Fenêtres",enable=useReduction1,group="Paramètres"));
parameter Real ombrages1=0.85
    "Ombrage d'obstacles (vegetation, voisinage) : = 0.85 si oui et = 1 sinon"
    annotation (Dialog(tab="Portes Fenêtres",enable=useReduction1,group="Paramètres"));
parameter Real r11=paraMaisonRT.transmissionMenuiseriePortesFenetres
    "Coef. réducteur pour le direct si useReduction1 = false"
    annotation (Dialog(tab="Portes Fenêtres",enable=not useReduction1,group="Coefficients de réduction si useReduction1 = false"));
parameter Real r21=paraMaisonRT.transmissionMenuiseriePortesFenetres
    "Coef. réducteur pour le diffus si useReduction1 = false"
    annotation (Dialog(tab="Portes Fenêtres",enable=not useReduction1,group="Coefficients de réduction si useReduction1 = false"));

  // Ponts thermiques
  parameter Modelica.SIunits.ThermalConductance G_ponts=
      Utilities.Functions.CalculGThermalBridges(
      ValeursK=paraMaisonRT.ValeursK,
      LongueursPonts=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.LongueursPontsSejour,
      TauPonts=paraMaisonRT.TauPonts) "Ponts thermiques"
    annotation (dialog(tab="Ponts thermiques"));

    //Coefficients de pondération
protected
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient TauPlancher(b=
        paraMaisonRT.bPlancher)
    annotation (Placement(transformation(extent={{-58,-100},{-38,-80}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient TauLNC(b=
        paraMaisonRT.bLNC)
    annotation (Placement(transformation(extent={{-58,-60},{-38,-40}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient TauPlafond(b=
        paraMaisonRT.bSousCombles)
    annotation (Placement(transformation(extent={{-58,80},{-38,100}})));

//Parois horizontales
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall ParoiSousCombles(
    ParoiInterne=true,
    Tp=Tp,
    InitType=InitType,
    RadInterne=not CLOintPlancher,
    hs_ext=paraMaisonRT.hsIntHorHaut,
    hs_int=paraMaisonRT.hsIntHorHaut,
    caracParoi(
      n=paraMaisonRT.ParoiSousCombles.n,
      m=paraMaisonRT.ParoiSousCombles.m,
      e=paraMaisonRT.ParoiSousCombles.e,
      mat=paraMaisonRT.ParoiSousCombles.mat,
      positionIsolant=paraMaisonRT.ParoiSousCombles.positionIsolant),
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondSejour)
    annotation (Placement(transformation(extent={{-7,82},{7,96}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall PlancherBas(
    ParoiInterne=true,
    Tp=Tp,
    RadInterne=true,
    hs_ext=paraMaisonRT.hsIntHorBas,
    hs_int=paraMaisonRT.hsIntHorBas,
    caracParoi(
      n=paraMaisonRT.PlancherBas.n,
      m=paraMaisonRT.PlancherBas.m,
      e=paraMaisonRT.PlancherBas.e,
      mat=paraMaisonRT.PlancherBas.mat,
      positionIsolant=paraMaisonRT.PlancherBas.positionIsolant),
    InitType=InitType,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondSejour)
    annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={51,-92})));

//Parois verticales extérieures
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurNord(
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    RadInterne=not CLOintPlancher,
    hs_ext=paraMaisonRT.hsExtVert,
    hs_int=paraMaisonRT.hsIntVert,
    alpha_ext=paraMaisonRT.alphaExt,
    eps=paraMaisonRT.eps,
    caracParoi(
      n=paraMaisonRT.Mur.n,
      m=paraMaisonRT.Mur.m,
      e=paraMaisonRT.Mur.e,
      mat=paraMaisonRT.Mur.mat,
      positionIsolant=paraMaisonRT.Mur.positionIsolant),
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurNordSejour)
    annotation (Placement(transformation(extent={{-7,22},{7,36}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurOuest(
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    RadInterne=not CLOintPlancher,
    hs_ext=paraMaisonRT.hsExtVert,
    hs_int=paraMaisonRT.hsIntVert,
    alpha_ext=paraMaisonRT.alphaExt,
    eps=paraMaisonRT.eps,
    caracParoi(
      n=paraMaisonRT.Mur.n,
      m=paraMaisonRT.Mur.m,
      e=paraMaisonRT.Mur.e,
      mat=paraMaisonRT.Mur.mat,
      positionIsolant=paraMaisonRT.Mur.positionIsolant),
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurOuestSejour)
    annotation (Placement(transformation(extent={{-7,2},{7,16}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurSud(
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    RadInterne=not CLOintPlancher,
    hs_ext=paraMaisonRT.hsExtVert,
    hs_int=paraMaisonRT.hsIntVert,
    alpha_ext=paraMaisonRT.alphaExt,
    eps=paraMaisonRT.eps,
    caracParoi(
      n=paraMaisonRT.Mur.n,
      m=paraMaisonRT.Mur.m,
      e=paraMaisonRT.Mur.e,
      mat=paraMaisonRT.Mur.mat,
      positionIsolant=paraMaisonRT.Mur.positionIsolant),
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurSudSejour)
    annotation (Placement(transformation(extent={{-7,-18},{7,-4}})));

//Parois verticales internes
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurLNC(
    ParoiInterne=true,
    Tp=Tp,
    InitType=InitType,
    RadInterne=not CLOintPlancher,
    hs_ext=paraMaisonRT.hsIntVert,
    hs_int=paraMaisonRT.hsIntVert,
    caracParoi(
      n=paraMaisonRT.Mur.n,
      m=paraMaisonRT.Mur.m,
      e=paraMaisonRT.Mur.e,
      mat=paraMaisonRT.Mur.mat,
      positionIsolant=paraMaisonRT.Mur.positionIsolant),
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurLNCSejour)
    annotation (Placement(transformation(extent={{-7,-58},{7,-44}})));

//Vitrages
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window VitrageOuest(
    GLOext=GLOEXT,
    RadInterne=not CLOintPlancher,
    useVolet=useVoletPF,
    useOuverture=useOuverturePF,
    k=1/(1/paraMaisonRT.UvitrageAF - 1/paraMaisonRT.hsExtVert - 1/paraMaisonRT.hsIntVert),
    hs_ext=paraMaisonRT.hsExtVert,
    hs_int=paraMaisonRT.hsIntVert,
    eps=paraMaisonRT.eps_vitrage,
    useReduction=useReduction1,
    TypeFenetrePF=TypeFenetrePF1,
    voilage=voilage1,
    position=position1,
    rideaux=rideaux1,
    ombrages=ombrages1,
    r1=r11,
    r2=r21,
    DifDirOut=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_VitrageOuestSejour,
    H=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.H_VitrageOuestSejour)
    annotation (Placement(transformation(extent={{-36,2},{-22,16}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window VitrageSudAF(
    GLOext=GLOEXT,
    RadInterne=not CLOintPlancher,
    useVolet=useVoletPF,
    useOuverture=useOuverturePF,
    k=1/(1/paraMaisonRT.UvitrageAF - 1/paraMaisonRT.hsExtVert - 1/paraMaisonRT.hsIntVert),
    hs_ext=paraMaisonRT.hsExtVert,
    hs_int=paraMaisonRT.hsIntVert,
    eps=paraMaisonRT.eps_vitrage,
    useReduction=useReduction1,
    TypeFenetrePF=TypeFenetrePF1,
    voilage=voilage1,
    position=position1,
    rideaux=rideaux1,
    ombrages=ombrages1,
    r1=r11,
    r2=r21,
    DifDirOut=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_VitrageSudSejour,
    H=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.H_VitrageSudSejour)
    annotation (Placement(transformation(extent={{-36,-38},{-22,-24}})));

//Ponts thermiques
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor PontsThermiques(G=G_ponts)
    annotation (Placement(transformation(extent={{-58,-80},{-43,-65}})));

//Composants pour prise en compte du rayonnement GLO/CLO
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tciel if GLOEXT
     == true annotation (Placement(transformation(extent={{-100,0},{-80,20}}),
        iconTransformation(extent={{-100,-60},{-80,-40}})));
  BuildSysPro.BoundaryConditions.Radiation.PintRadDistrib PintdistriRad(
    np=8,
    nf=2,
    Sf={BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_VitrageSudSejour,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_VitrageOuestSejour},
    Sp={BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondSejour,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurNordSejour,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurSudSejour,BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_RefendSejourCuisine,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_RefendEntreeSejour,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurOuestSejour,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondSejour,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurLNCSejour}) if not
    CLOintPlancher
    annotation (Placement(transformation(extent={{-2,-92},{18,-72}})));

//Composants de base
protected
  Modelica.Blocks.Math.MultiSum multiSum(nu=2)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-14,-66})));
public
  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(V=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondSejour
        *BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.HauteurMozart, Tair=293.15)
    annotation (Placement(transformation(extent={{70,16},{90,36}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Text annotation (
      Placement(transformation(extent={{-100,30},{-80,50}}), iconTransformation(
          extent={{-100,-20},{-80,0}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a TSejour
    annotation (Placement(transformation(extent={{80,-29},{100,-9}}),
        iconTransformation(extent={{-7,-34},{13,-14}})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal renouvellementAir(
      use_Qv_in=QVin, Qv=paraMaisonRT.renouvAir*BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondSejour
        *BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.HauteurMozart) annotation (
     Placement(transformation(
        extent={{11,-11},{-11,11}},
        rotation=270,
        origin={71,-49})));
Modelica.Blocks.Interfaces.RealInput RenouvAir if         QVin==true
    annotation (Placement(transformation(extent={{120,-98},{80,-58}}),
        iconTransformation(extent={{7,-7},{-7,7}},
        rotation=180,
        origin={-47,27})));

  Modelica.Blocks.Interfaces.BooleanInput ouvertureFenetres[2] if useOuverturePF
    "ouverture des fenêtres Sud, Ouest"
    annotation (Placement(transformation(extent={{-120,-68},{-80,-28}}),
        iconTransformation(extent={{-54,58},{-40,72}})));
  Modelica.Blocks.Interfaces.RealInput fermetureVolets[2] if useVoletPF
    "fermeture des volets Sud, Ouest"
    annotation (Placement(transformation(extent={{-120,-100},{-80,-60}}),
        iconTransformation(extent={{-7,-7},{7,7}},
        rotation=0,
        origin={-47,49})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxNord[3]
    annotation (Placement(transformation(extent={{-112,80},{-88,104}}),
        iconTransformation(extent={{-100,89},{-76,113}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxSud[3]
    annotation (Placement(transformation(extent={{-112,64},{-88,88}}),
        iconTransformation(extent={{-100,67},{-76,91}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxOuest[3]
    annotation (Placement(transformation(extent={{-112,48},{-88,72}}),
        iconTransformation(extent={{-100,47},{-76,71}})));
  Modelica.Blocks.Interfaces.RealOutput FLUXrefendCuisine if not CLOintPlancher
    annotation (Placement(transformation(extent={{90,70},{110,90}}),
        iconTransformation(extent={{60,50},{80,70}})));
  Modelica.Blocks.Interfaces.RealOutput FLUXrefendEntree if not CLOintPlancher
    annotation (Placement(transformation(extent={{90,50},{110,70}}),
        iconTransformation(extent={{60,-50},{80,-30}})));
  Modelica.Blocks.Interfaces.RealInput VENTSud if useOuverturePF annotation (Placement(
        transformation(extent={{-112,-22},{-88,2}}), iconTransformation(extent=
            {{-100,22},{-76,46}})));
  Modelica.Blocks.Interfaces.RealInput VENTOuest if useOuverturePF annotation (Placement(
        transformation(extent={{-112,-38},{-88,-14}}),
                                                    iconTransformation(extent={
            {-100,2},{-76,26}})));
equation
  if CLOintPlancher==false then
    connect(multiSum.y, PintdistriRad.RayEntrant) annotation (Line(
      points={{-14,-73.02},{-14,-82},{-1,-82}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXFenetres[1], VitrageSudAF.FluxAbsInt) annotation (
      Line(
      points={{19,-80.5},{24,-80.5},{24,-29.6},{-26.9,-29.6}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXFenetres[2], VitrageOuest.FluxAbsInt) annotation (
      Line(
      points={{19,-79.5},{24,-79.5},{24,10.4},{-26.9,10.4}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[1], ParoiSousCombles.FluxAbsInt) annotation (
     Line(
      points={{19,-84.875},{24,-84.875},{24,92.5},{2.1,92.5}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[2], MurNord.FluxAbsInt) annotation (Line(
      points={{19,-84.625},{24,-84.625},{24,32.5},{2.1,32.5}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[3], MurSud.FluxAbsInt) annotation (Line(
      points={{19,-84.375},{24,-84.375},{24,-7.5},{2.1,-7.5}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[4], FLUXrefendCuisine) annotation (Line(
      points={{19,-84.125},{24,-84.125},{24,80},{100,80}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[5], FLUXrefendEntree) annotation (Line(
      points={{19,-83.875},{24,-83.875},{24,60},{100,60}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[6], MurOuest.FluxAbsInt) annotation (Line(
      points={{19,-83.625},{24,-83.625},{24,12.5},{2.1,12.5}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[7], PlancherBas.FluxAbsInt) annotation (Line(
      points={{19,-83.375},{47.5,-83.375},{47.5,-89.9}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[8], MurLNC.FluxAbsInt) annotation (Line(
      points={{19,-83.125},{24,-83.125},{24,-47.5},{2.1,-47.5}},
      color={0,0,127},
      smooth=Smooth.None));
else
    connect(multiSum.y, PlancherBas.FluxAbsInt) annotation (Line(
      points={{-14,-73.02},{48,-73.02},{48,-89.9},{47.5,-89.9}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  if GLOEXT==true then
    connect(Tciel, VitrageOuest.T_ciel) annotation (Line(
      points={{-90,10},{-64,10},{-64,2.7},{-35.3,2.7}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Tciel, VitrageSudAF.T_ciel) annotation (Line(
      points={{-90,10},{-64,10},{-64,-37.3},{-35.3,-37.3}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Tciel, MurNord.T_ciel) annotation (Line(
      points={{-90,10},{-64,10},{-64,22.7},{-6.3,22.7}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Tciel, MurOuest.T_ciel) annotation (Line(
      points={{-90,10},{-64,10},{-64,2.7},{-6.3,2.7}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Tciel, MurSud.T_ciel) annotation (Line(
      points={{-90,10},{-64,10},{-64,-17.3},{-6.3,-17.3}},
      color={191,0,0},
      smooth=Smooth.None));
  end if;

  if QVin==true then
    connect(RenouvAir, renouvellementAir.Qv_in) annotation (Line(
      points={{100,-78},{92,-78},{92,-49},{80.68,-49}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  if useVoletPF then
    connect(fermetureVolets[2], VitrageOuest.fermeture_volet)
      annotation (
      Line(
      points={{-100,-70},{-76,-70},{-76,13.9},{-35.3,13.9}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
    connect(fermetureVolets[1], VitrageSudAF.fermeture_volet)
      annotation (
      Line(
      points={{-100,-90},{-76,-90},{-76,-26.1},{-35.3,-26.1}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  end if;

  if useOuverturePF then
    connect(ouvertureFenetres[2], VitrageOuest.ouverture_fenetre)
      annotation (
      Line(
        points={{-100,-38},{-74,-38},{-74,9},{-31.1,9}},
        color={255,0,255},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
    connect(ouvertureFenetres[1], VitrageSudAF.ouverture_fenetre)
      annotation (
      Line(
        points={{-100,-58},{-74,-58},{-74,-31},{-31.1,-31}},
        color={255,0,255},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
  end if;

    connect(Text, MurNord.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,26.9},{-6.3,26.9}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Text, MurOuest.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,6.9},{-6.3,6.9}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Text, MurSud.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,-13.1},{-6.3,-13.1}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(TauPlafond.Tponder, ParoiSousCombles.T_ext) annotation (Line(
      points={{-43,89.8},{-6.3,89.8},{-6.3,86.9}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(TauLNC.Tponder, MurLNC.T_ext) annotation (Line(
      points={{-43,-50.2},{-6.3,-50.2},{-6.3,-53.1}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(TauPlancher.Tponder, PlancherBas.T_ext) annotation (Line(
      points={{-43,-90.2},{34,-90.2},{34,-98.3},{53.1,-98.3}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(ParoiSousCombles.T_int, noeudAir.port_a) annotation (Line(
      points={{6.3,86.9},{40,86.9},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
    connect(MurNord.T_int, noeudAir.port_a) annotation (Line(
      points={{6.3,26.9},{40,26.9},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
    connect(MurOuest.T_int, noeudAir.port_a) annotation (Line(
      points={{6.3,6.9},{40,6.9},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
    connect(MurSud.T_int, noeudAir.port_a) annotation (Line(
      points={{6.3,-13.1},{40,-13.1},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
    connect(MurLNC.T_int, noeudAir.port_a) annotation (Line(
      points={{6.3,-53.1},{40,-53.1},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
    connect(PlancherBas.T_int, noeudAir.port_a) annotation (Line(
      points={{53.1,-85.7},{53.1,-60},{40,-60},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Text, VitrageOuest.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,6.9},{-35.3,6.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, VitrageSudAF.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,-33.1},{-35.3,-33.1}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, TauPlancher.port_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,-46},{-64,-46},{-64,-87},{-57,-87}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, TauLNC.port_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,-47},{-57,-47}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, TauPlafond.port_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,80},{-64,80},{-64,93},{-57,93}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(VitrageOuest.CLOTr, multiSum.u[1]) annotation (Line(
      points={{-22.7,12.5},{-11.9,12.5},{-11.9,-60}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(VitrageSudAF.CLOTr, multiSum.u[2]) annotation (Line(
      points={{-22.7,-27.5},{-16.1,-27.5},{-16.1,-60}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(Text, renouvellementAir.port_a) annotation (Line(
      points={{-90,40},{-52,40},{-52,-46},{-64,-46},{-64,-102},{71,-102},{71,-58.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(noeudAir.port_a, TSejour) annotation (Line(
      points={{80,22},{80,2},{80,-19},{90,-19}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, PontsThermiques.port_a) annotation (Line(
      points={{-90,40},{-52,40},{-52,-46},{-64,-46},{-64,-72.5},{-57.25,-72.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(renouvellementAir.port_b, noeudAir.port_a) annotation (Line(
      points={{71,-39.1},{71,-30},{40,-30},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(TauPlancher.port_int, noeudAir.port_a) annotation (Line(
      points={{-57,-93},{-60,-93},{-60,-98},{30,-98},{30,-60},{40,-60},{40,40},{
          80,40},{80,22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TauLNC.port_int, noeudAir.port_a) annotation (Line(
      points={{-57,-53},{-60,-53},{-60,-98},{30,-98},{30,-60},{40,-60},{40,40},{
          80,40},{80,22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TauPlafond.port_int, noeudAir.port_a) annotation (Line(
      points={{-57,87},{-60,87},{-60,82},{40,82},{40,40},{80,40},{80,22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(PontsThermiques.port_b, noeudAir.port_a) annotation (Line(
      points={{-43.75,-72.5},{-36,-72.5},{-36,-98},{30,-98},{30,-60},{40,-60},{40,
          40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(VitrageSudAF.T_int, noeudAir.port_a) annotation (Line(
      points={{-22.7,-33.1},{40,-33.1},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(VitrageOuest.T_int, noeudAir.port_a) annotation (Line(
      points={{-22.7,6.9},{40,6.9},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(FluxNord, MurNord.FLUX) annotation (Line(
      points={{-100,92},{-66,92},{-66,35.3},{-2.1,35.3}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FluxSud, MurSud.FLUX) annotation (Line(
      points={{-100,76},{-66,76},{-66,-4.7},{-2.1,-4.7}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FluxSud, VitrageSudAF.FLUX) annotation (Line(
      points={{-100,76},{-66,76},{-66,-27.5},{-31.1,-27.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FluxOuest, VitrageOuest.FLUX) annotation (Line(
      points={{-100,60},{-66,60},{-66,12.5},{-31.1,12.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FluxOuest, MurOuest.FLUX) annotation (Line(
      points={{-100,60},{-66,60},{-66,15.3},{-2.1,15.3}},
      color={255,192,1},
      smooth=Smooth.None));

  connect(VENTSud, VitrageSudAF.V) annotation (Line(
      points={{-100,-10},{-70,-10},{-70,-31},{-35.3,-31}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(VENTOuest, VitrageOuest.V) annotation (Line(
      points={{-100,-26},{-70,-26},{-70,9},{-35.3,9}},
      color={0,0,127},
      smooth=Smooth.None));
annotation (Placement(transformation(extent={{-12,-50},{8,-25}})),
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,120}}),
graphics={
        Bitmap(extent={{-66,82},{66,-64}}, fileName="modelica://BuildSysPro/Resources/Images/Batiments/Batiments types/Mozart/Sejour.png"),
        Ellipse(extent={{-36,42},{-8,14}},  lineColor={0,0,0}),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-22,58},
          rotation=360),
        Ellipse(
          extent={{-24,30},{-20,26}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-52,-48},{-40,-38},{-22,-46}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={-60,-28},
          rotation=180),
        Line(
          points={{-38,38},{-22,46},{-8,38}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Polygon(
          points={{-8,40},{-6,36},{-10,38},{-8,40}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-52,28},
          rotation=90),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-22,-2},
          rotation=180),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={8,28},
          rotation=270),
        Polygon(
          points={{0,-2},{2,2},{-2,0},{0,-2}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-37,18},
          rotation=90)}),
           Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),       graphics),
    Documentation(info="<html>
<p><i><b>Zone séjour Mozart</b></i></p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>néant</p>
<p><u><b>Bibliographie</b></u></p>
<p>néant</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>néant</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>néant</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Alexandre Hautefeuille, Gilles Plessis, Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
end ZoneLiving;
