within BuildSysPro.Utilities.Data.WallData;
record LightPartitionWall =
   BuildSysPro.Utilities.Icons.VerticalInternalWall (
    n=3,
    m={1,1,1},
    e={0.01,0.03,0.01},
    mat={BuildSysPro.Utilities.Data.Solids.PlasterBoard(),
                                    BuildSysPro.Utilities.Data.Solids.Air30(),
        BuildSysPro.Utilities.Data.Solids.PlasterBoard()},
    positionIsolant={0,1,0}) "Light internal partition wall - 3 layers"
                                             annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Gilles PLESSIS, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>"));
