<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis simplifyAlgorithm="0" maxScale="0" readOnly="0" simplifyDrawingTol="1" labelsEnabled="0" simplifyMaxScale="1" version="3.22.0-Białowieża" simplifyLocal="1" minScale="100000000" hasScaleBasedVisibilityFlag="0" symbologyReferenceScale="-1" styleCategories="AllStyleCategories" simplifyDrawingHints="1">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
    <Private>0</Private>
  </flags>
  <temporal enabled="0" mode="0" accumulate="0" limitMode="0" startField="" startExpression="" endField="" endExpression="" durationUnit="min" fixedDuration="0" durationField="">
    <fixedRange>
      <start></start>
      <end></end>
    </fixedRange>
  </temporal>
  <renderer-v2 forceraster="0" referencescale="-1" type="RuleRenderer" enableorderby="0" symbollevels="0">
    <rules key="{3c4daf55-9606-40a5-b077-06b5d98f56c5}">
      <rule symbol="0" label="Oversvømmelse, nutid" description="Oversvømmelse, nutid" filter=" &quot;cnt_oversvoem&quot; > 0" key="{ff9c1c66-ab1a-4980-b69a-af5c6f7344ee}"/>
      <rule symbol="1" label="Oversvømmelse, fremtid" description="Oversvømmelse, fremtid" filter=" &quot;cnt_oversvoem_fremtid&quot; > 0" key="{3c4b9dfc-1e1d-47ba-9426-5c94ca77def8}"/>
    </rules>
    <symbols>
      <symbol alpha="1" force_rhr="0" type="fill" name="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer enabled="1" pass="0" locked="0" class="SimpleFill">
          <Option type="Map">
            <Option type="QString" value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale"/>
            <Option type="QString" value="141,90,153,255" name="color"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="0,0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="35,35,35,255" name="outline_color"/>
            <Option type="QString" value="solid" name="outline_style"/>
            <Option type="QString" value="0.26" name="outline_width"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="b_diagonal" name="style"/>
          </Option>
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="141,90,153,255"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0.26"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="b_diagonal"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" force_rhr="0" type="fill" name="1" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer enabled="1" pass="0" locked="0" class="SimpleFill">
          <Option type="Map">
            <Option type="QString" value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale"/>
            <Option type="QString" value="232,113,141,255" name="color"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="0,0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="35,35,35,255" name="outline_color"/>
            <Option type="QString" value="solid" name="outline_style"/>
            <Option type="QString" value="0.26" name="outline_width"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="f_diagonal" name="style"/>
          </Option>
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="232,113,141,255"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0.26"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="f_diagonal"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <customproperties>
    <Option type="Map">
      <Option type="List" name="dualview/previewExpressions">
        <Option type="QString" value="&quot;bbr_anv_tekst&quot;"/>
      </Option>
      <Option type="int" value="0" name="embeddedWidgets/count"/>
      <Option type="StringList" name="variableNames">
        <Option type="QString" value="eco_resultlayer"/>
      </Option>
      <Option type="StringList" name="variableValues">
        <Option type="QString" value="q_building_new"/>
      </Option>
    </Option>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer diagramType="Histogram" attributeLegend="1">
    <DiagramCategory sizeScale="3x:0,0,0,0,0,0" sizeType="MM" minimumSize="0" backgroundColor="#ffffff" spacingUnit="MM" backgroundAlpha="255" penWidth="0" width="15" penColor="#000000" showAxis="1" penAlpha="255" spacingUnitScale="3x:0,0,0,0,0,0" lineSizeScale="3x:0,0,0,0,0,0" opacity="1" diagramOrientation="Up" direction="0" lineSizeType="MM" minScaleDenominator="0" spacing="5" barWidth="5" labelPlacementMethod="XHeight" rotationOffset="270" height="15" scaleDependency="Area" enabled="0" maxScaleDenominator="1e+08" scaleBasedVisibility="0">
      <fontProperties style="" description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0"/>
      <axisSymbol>
        <symbol alpha="1" force_rhr="0" type="line" name="" clip_to_extent="1">
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
          <layer enabled="1" pass="0" locked="0" class="SimpleLine">
            <Option type="Map">
              <Option type="QString" value="0" name="align_dash_pattern"/>
              <Option type="QString" value="square" name="capstyle"/>
              <Option type="QString" value="5;2" name="customdash"/>
              <Option type="QString" value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale"/>
              <Option type="QString" value="MM" name="customdash_unit"/>
              <Option type="QString" value="0" name="dash_pattern_offset"/>
              <Option type="QString" value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale"/>
              <Option type="QString" value="MM" name="dash_pattern_offset_unit"/>
              <Option type="QString" value="0" name="draw_inside_polygon"/>
              <Option type="QString" value="bevel" name="joinstyle"/>
              <Option type="QString" value="35,35,35,255" name="line_color"/>
              <Option type="QString" value="solid" name="line_style"/>
              <Option type="QString" value="0.26" name="line_width"/>
              <Option type="QString" value="MM" name="line_width_unit"/>
              <Option type="QString" value="0" name="offset"/>
              <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
              <Option type="QString" value="MM" name="offset_unit"/>
              <Option type="QString" value="0" name="ring_filter"/>
              <Option type="QString" value="0" name="trim_distance_end"/>
              <Option type="QString" value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale"/>
              <Option type="QString" value="MM" name="trim_distance_end_unit"/>
              <Option type="QString" value="0" name="trim_distance_start"/>
              <Option type="QString" value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale"/>
              <Option type="QString" value="MM" name="trim_distance_start_unit"/>
              <Option type="QString" value="0" name="tweak_dash_pattern_on_corners"/>
              <Option type="QString" value="0" name="use_custom_dash"/>
              <Option type="QString" value="3x:0,0,0,0,0,0" name="width_map_unit_scale"/>
            </Option>
            <prop k="align_dash_pattern" v="0"/>
            <prop k="capstyle" v="square"/>
            <prop k="customdash" v="5;2"/>
            <prop k="customdash_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="customdash_unit" v="MM"/>
            <prop k="dash_pattern_offset" v="0"/>
            <prop k="dash_pattern_offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="dash_pattern_offset_unit" v="MM"/>
            <prop k="draw_inside_polygon" v="0"/>
            <prop k="joinstyle" v="bevel"/>
            <prop k="line_color" v="35,35,35,255"/>
            <prop k="line_style" v="solid"/>
            <prop k="line_width" v="0.26"/>
            <prop k="line_width_unit" v="MM"/>
            <prop k="offset" v="0"/>
            <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="offset_unit" v="MM"/>
            <prop k="ring_filter" v="0"/>
            <prop k="trim_distance_end" v="0"/>
            <prop k="trim_distance_end_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="trim_distance_end_unit" v="MM"/>
            <prop k="trim_distance_start" v="0"/>
            <prop k="trim_distance_start_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="trim_distance_start_unit" v="MM"/>
            <prop k="tweak_dash_pattern_on_corners" v="0"/>
            <prop k="use_custom_dash" v="0"/>
            <prop k="width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <data_defined_properties>
              <Option type="Map">
                <Option type="QString" value="" name="name"/>
                <Option name="properties"/>
                <Option type="QString" value="collection" name="type"/>
              </Option>
            </data_defined_properties>
          </layer>
        </symbol>
      </axisSymbol>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings obstacle="0" showAll="1" linePlacementFlags="18" zIndex="0" placement="1" dist="0" priority="0">
    <properties>
      <Option type="Map">
        <Option type="QString" value="" name="name"/>
        <Option name="properties"/>
        <Option type="QString" value="collection" name="type"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <geometryOptions removeDuplicateNodes="0" geometryPrecision="0">
    <activeChecks/>
    <checkConfiguration type="Map">
      <Option type="Map" name="QgsGeometryGapCheck">
        <Option type="double" value="0" name="allowedGapsBuffer"/>
        <Option type="bool" value="false" name="allowedGapsEnabled"/>
        <Option type="QString" value="" name="allowedGapsLayer"/>
      </Option>
    </checkConfiguration>
  </geometryOptions>
  <legend showLabelLegend="0" type="default-vector"/>
  <referencedLayers/>
  <fieldConfiguration>
    <field configurationFlags="None" name="fid">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="kom_kode">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="bbr_anv_kode">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="bbr_anv_tekst">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="areal_kaelder_m2">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="areal_byg_m2">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="skade_kategori">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="skade_type">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="tab_procent">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="kvm_pris_kr">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="vaerditab_kr">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="skadebeloeb_kr">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="skadebeloeb_kaelder_kr">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="cnt_oversvoem">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="areal_oversvoem_m2">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="min_vanddybde_cm">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="max_vanddybde_cm">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="avg_vanddybde_cm">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="skadebeloeb_fremtid_kr">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="skadebeloeb_kaelder_fremtid_kr">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="cnt_oversvoem_fremtid">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="areal_oversvoem_fremtid_m2">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="min_vanddybde_fremtid_cm">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="max_vanddybde_fremtid_cm">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="avg_vanddybde_fremtid_cm">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="risiko_kr">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias field="fid" index="0" name=""/>
    <alias field="kom_kode" index="1" name=""/>
    <alias field="bbr_anv_kode" index="2" name=""/>
    <alias field="bbr_anv_tekst" index="3" name=""/>
    <alias field="areal_kaelder_m2" index="4" name=""/>
    <alias field="areal_byg_m2" index="5" name=""/>
    <alias field="skade_kategori" index="6" name=""/>
    <alias field="skade_type" index="7" name=""/>
    <alias field="tab_procent" index="8" name=""/>
    <alias field="kvm_pris_kr" index="9" name=""/>
    <alias field="vaerditab_kr" index="10" name=""/>
    <alias field="skadebeloeb_kr" index="11" name=""/>
    <alias field="skadebeloeb_kaelder_kr" index="12" name=""/>
    <alias field="cnt_oversvoem" index="13" name=""/>
    <alias field="areal_oversvoem_m2" index="14" name=""/>
    <alias field="min_vanddybde_cm" index="15" name=""/>
    <alias field="max_vanddybde_cm" index="16" name=""/>
    <alias field="avg_vanddybde_cm" index="17" name=""/>
    <alias field="skadebeloeb_fremtid_kr" index="18" name=""/>
    <alias field="skadebeloeb_kaelder_fremtid_kr" index="19" name=""/>
    <alias field="cnt_oversvoem_fremtid" index="20" name=""/>
    <alias field="areal_oversvoem_fremtid_m2" index="21" name=""/>
    <alias field="min_vanddybde_fremtid_cm" index="22" name=""/>
    <alias field="max_vanddybde_fremtid_cm" index="23" name=""/>
    <alias field="avg_vanddybde_fremtid_cm" index="24" name=""/>
    <alias field="risiko_kr" index="25" name=""/>
  </aliases>
  <defaults>
    <default expression="" field="fid" applyOnUpdate="0"/>
    <default expression="" field="kom_kode" applyOnUpdate="0"/>
    <default expression="" field="bbr_anv_kode" applyOnUpdate="0"/>
    <default expression="" field="bbr_anv_tekst" applyOnUpdate="0"/>
    <default expression="" field="areal_kaelder_m2" applyOnUpdate="0"/>
    <default expression="" field="areal_byg_m2" applyOnUpdate="0"/>
    <default expression="" field="skade_kategori" applyOnUpdate="0"/>
    <default expression="" field="skade_type" applyOnUpdate="0"/>
    <default expression="" field="tab_procent" applyOnUpdate="0"/>
    <default expression="" field="kvm_pris_kr" applyOnUpdate="0"/>
    <default expression="" field="vaerditab_kr" applyOnUpdate="0"/>
    <default expression="" field="skadebeloeb_kr" applyOnUpdate="0"/>
    <default expression="" field="skadebeloeb_kaelder_kr" applyOnUpdate="0"/>
    <default expression="" field="cnt_oversvoem" applyOnUpdate="0"/>
    <default expression="" field="areal_oversvoem_m2" applyOnUpdate="0"/>
    <default expression="" field="min_vanddybde_cm" applyOnUpdate="0"/>
    <default expression="" field="max_vanddybde_cm" applyOnUpdate="0"/>
    <default expression="" field="avg_vanddybde_cm" applyOnUpdate="0"/>
    <default expression="" field="skadebeloeb_fremtid_kr" applyOnUpdate="0"/>
    <default expression="" field="skadebeloeb_kaelder_fremtid_kr" applyOnUpdate="0"/>
    <default expression="" field="cnt_oversvoem_fremtid" applyOnUpdate="0"/>
    <default expression="" field="areal_oversvoem_fremtid_m2" applyOnUpdate="0"/>
    <default expression="" field="min_vanddybde_fremtid_cm" applyOnUpdate="0"/>
    <default expression="" field="max_vanddybde_fremtid_cm" applyOnUpdate="0"/>
    <default expression="" field="avg_vanddybde_fremtid_cm" applyOnUpdate="0"/>
    <default expression="" field="risiko_kr" applyOnUpdate="0"/>
  </defaults>
  <constraints>
    <constraint field="fid" unique_strength="1" constraints="3" exp_strength="0" notnull_strength="1"/>
    <constraint field="kom_kode" unique_strength="0" constraints="0" exp_strength="0" notnull_strength="0"/>
    <constraint field="bbr_anv_kode" unique_strength="0" constraints="0" exp_strength="0" notnull_strength="0"/>
    <constraint field="bbr_anv_tekst" unique_strength="0" constraints="0" exp_strength="0" notnull_strength="0"/>
    <constraint field="areal_kaelder_m2" unique_strength="0" constraints="0" exp_strength="0" notnull_strength="0"/>
    <constraint field="areal_byg_m2" unique_strength="0" constraints="0" exp_strength="0" notnull_strength="0"/>
    <constraint field="skade_kategori" unique_strength="0" constraints="0" exp_strength="0" notnull_strength="0"/>
    <constraint field="skade_type" unique_strength="0" constraints="0" exp_strength="0" notnull_strength="0"/>
    <constraint field="tab_procent" unique_strength="0" constraints="0" exp_strength="0" notnull_strength="0"/>
    <constraint field="kvm_pris_kr" unique_strength="0" constraints="0" exp_strength="0" notnull_strength="0"/>
    <constraint field="vaerditab_kr" unique_strength="0" constraints="0" exp_strength="0" notnull_strength="0"/>
    <constraint field="skadebeloeb_kr" unique_strength="0" constraints="0" exp_strength="0" notnull_strength="0"/>
    <constraint field="skadebeloeb_kaelder_kr" unique_strength="0" constraints="0" exp_strength="0" notnull_strength="0"/>
    <constraint field="cnt_oversvoem" unique_strength="0" constraints="0" exp_strength="0" notnull_strength="0"/>
    <constraint field="areal_oversvoem_m2" unique_strength="0" constraints="0" exp_strength="0" notnull_strength="0"/>
    <constraint field="min_vanddybde_cm" unique_strength="0" constraints="0" exp_strength="0" notnull_strength="0"/>
    <constraint field="max_vanddybde_cm" unique_strength="0" constraints="0" exp_strength="0" notnull_strength="0"/>
    <constraint field="avg_vanddybde_cm" unique_strength="0" constraints="0" exp_strength="0" notnull_strength="0"/>
    <constraint field="skadebeloeb_fremtid_kr" unique_strength="0" constraints="0" exp_strength="0" notnull_strength="0"/>
    <constraint field="skadebeloeb_kaelder_fremtid_kr" unique_strength="0" constraints="0" exp_strength="0" notnull_strength="0"/>
    <constraint field="cnt_oversvoem_fremtid" unique_strength="0" constraints="0" exp_strength="0" notnull_strength="0"/>
    <constraint field="areal_oversvoem_fremtid_m2" unique_strength="0" constraints="0" exp_strength="0" notnull_strength="0"/>
    <constraint field="min_vanddybde_fremtid_cm" unique_strength="0" constraints="0" exp_strength="0" notnull_strength="0"/>
    <constraint field="max_vanddybde_fremtid_cm" unique_strength="0" constraints="0" exp_strength="0" notnull_strength="0"/>
    <constraint field="avg_vanddybde_fremtid_cm" unique_strength="0" constraints="0" exp_strength="0" notnull_strength="0"/>
    <constraint field="risiko_kr" unique_strength="0" constraints="0" exp_strength="0" notnull_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint field="fid" desc="" exp=""/>
    <constraint field="kom_kode" desc="" exp=""/>
    <constraint field="bbr_anv_kode" desc="" exp=""/>
    <constraint field="bbr_anv_tekst" desc="" exp=""/>
    <constraint field="areal_kaelder_m2" desc="" exp=""/>
    <constraint field="areal_byg_m2" desc="" exp=""/>
    <constraint field="skade_kategori" desc="" exp=""/>
    <constraint field="skade_type" desc="" exp=""/>
    <constraint field="tab_procent" desc="" exp=""/>
    <constraint field="kvm_pris_kr" desc="" exp=""/>
    <constraint field="vaerditab_kr" desc="" exp=""/>
    <constraint field="skadebeloeb_kr" desc="" exp=""/>
    <constraint field="skadebeloeb_kaelder_kr" desc="" exp=""/>
    <constraint field="cnt_oversvoem" desc="" exp=""/>
    <constraint field="areal_oversvoem_m2" desc="" exp=""/>
    <constraint field="min_vanddybde_cm" desc="" exp=""/>
    <constraint field="max_vanddybde_cm" desc="" exp=""/>
    <constraint field="avg_vanddybde_cm" desc="" exp=""/>
    <constraint field="skadebeloeb_fremtid_kr" desc="" exp=""/>
    <constraint field="skadebeloeb_kaelder_fremtid_kr" desc="" exp=""/>
    <constraint field="cnt_oversvoem_fremtid" desc="" exp=""/>
    <constraint field="areal_oversvoem_fremtid_m2" desc="" exp=""/>
    <constraint field="min_vanddybde_fremtid_cm" desc="" exp=""/>
    <constraint field="max_vanddybde_fremtid_cm" desc="" exp=""/>
    <constraint field="avg_vanddybde_fremtid_cm" desc="" exp=""/>
    <constraint field="risiko_kr" desc="" exp=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction key="Canvas" value="{00000000-0000-0000-0000-000000000000}"/>
  </attributeactions>
  <attributetableconfig sortOrder="1" sortExpression="&quot;cnt_oversvoem&quot;" actionWidgetStyle="dropDown">
    <columns>
      <column hidden="0" type="field" width="-1" name="fid"/>
      <column hidden="0" type="field" width="-1" name="kom_kode"/>
      <column hidden="0" type="field" width="-1" name="bbr_anv_kode"/>
      <column hidden="0" type="field" width="-1" name="bbr_anv_tekst"/>
      <column hidden="0" type="field" width="-1" name="areal_kaelder_m2"/>
      <column hidden="0" type="field" width="-1" name="areal_byg_m2"/>
      <column hidden="0" type="field" width="-1" name="skade_kategori"/>
      <column hidden="0" type="field" width="-1" name="skade_type"/>
      <column hidden="0" type="field" width="-1" name="tab_procent"/>
      <column hidden="0" type="field" width="-1" name="kvm_pris_kr"/>
      <column hidden="0" type="field" width="-1" name="vaerditab_kr"/>
      <column hidden="0" type="field" width="-1" name="skadebeloeb_kr"/>
      <column hidden="0" type="field" width="198" name="skadebeloeb_kaelder_kr"/>
      <column hidden="0" type="field" width="174" name="cnt_oversvoem"/>
      <column hidden="0" type="field" width="-1" name="areal_oversvoem_m2"/>
      <column hidden="0" type="field" width="-1" name="min_vanddybde_cm"/>
      <column hidden="0" type="field" width="-1" name="max_vanddybde_cm"/>
      <column hidden="0" type="field" width="-1" name="avg_vanddybde_cm"/>
      <column hidden="0" type="field" width="-1" name="skadebeloeb_fremtid_kr"/>
      <column hidden="0" type="field" width="-1" name="skadebeloeb_kaelder_fremtid_kr"/>
      <column hidden="0" type="field" width="160" name="cnt_oversvoem_fremtid"/>
      <column hidden="0" type="field" width="-1" name="areal_oversvoem_fremtid_m2"/>
      <column hidden="0" type="field" width="-1" name="min_vanddybde_fremtid_cm"/>
      <column hidden="0" type="field" width="-1" name="max_vanddybde_fremtid_cm"/>
      <column hidden="0" type="field" width="-1" name="avg_vanddybde_fremtid_cm"/>
      <column hidden="0" type="field" width="-1" name="risiko_kr"/>
      <column hidden="1" type="actions" width="-1"/>
    </columns>
  </attributetableconfig>
  <conditionalstyles>
    <rowstyles/>
    <fieldstyles/>
  </conditionalstyles>
  <storedexpressions/>
  <editform tolerant="1"></editform>
  <editforminit/>
  <editforminitcodesource>0</editforminitcodesource>
  <editforminitfilepath></editforminitfilepath>
  <editforminitcode><![CDATA[# -*- coding: utf-8 -*-
"""
QGIS form kan have en Python funktion der kaldes når formen bliver
åbnet.

Brug denne funktion til at tilføje ekstra logik til dine former.

Indtast funktionsnavnet i "Python Init function"
feltet.
Et eksempel:
"""
from qgis.PyQt.QtWidgets import QWidget

def my_form_open(dialog, layer, feature):
	geom = feature.geometry()
	control = dialog.findChild(QWidget, "MyLineEdit")
]]></editforminitcode>
  <featformsuppress>0</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable>
    <field editable="1" name="areal_byg_m2"/>
    <field editable="1" name="areal_kaelder_m2"/>
    <field editable="1" name="areal_oversvoem_fremtid_m2"/>
    <field editable="1" name="areal_oversvoem_m2"/>
    <field editable="1" name="avg_vanddybde_cm"/>
    <field editable="1" name="avg_vanddybde_fremtid_cm"/>
    <field editable="1" name="bbr_anv_kode"/>
    <field editable="1" name="bbr_anv_tekst"/>
    <field editable="1" name="cnt_oversvoem"/>
    <field editable="1" name="cnt_oversvoem_fremtid"/>
    <field editable="1" name="fid"/>
    <field editable="1" name="kom_kode"/>
    <field editable="1" name="kvm_pris_kr"/>
    <field editable="1" name="max_vanddybde_cm"/>
    <field editable="1" name="max_vanddybde_fremtid_cm"/>
    <field editable="1" name="min_vanddybde_cm"/>
    <field editable="1" name="min_vanddybde_fremtid_cm"/>
    <field editable="1" name="risiko_kr"/>
    <field editable="1" name="skade_kategori"/>
    <field editable="1" name="skade_type"/>
    <field editable="1" name="skadebeloeb_fremtid_kr"/>
    <field editable="1" name="skadebeloeb_kaelder_fremtid_kr"/>
    <field editable="1" name="skadebeloeb_kaelder_kr"/>
    <field editable="1" name="skadebeloeb_kr"/>
    <field editable="1" name="tab_procent"/>
    <field editable="1" name="vaerditab_kr"/>
  </editable>
  <labelOnTop>
    <field labelOnTop="0" name="areal_byg_m2"/>
    <field labelOnTop="0" name="areal_kaelder_m2"/>
    <field labelOnTop="0" name="areal_oversvoem_fremtid_m2"/>
    <field labelOnTop="0" name="areal_oversvoem_m2"/>
    <field labelOnTop="0" name="avg_vanddybde_cm"/>
    <field labelOnTop="0" name="avg_vanddybde_fremtid_cm"/>
    <field labelOnTop="0" name="bbr_anv_kode"/>
    <field labelOnTop="0" name="bbr_anv_tekst"/>
    <field labelOnTop="0" name="cnt_oversvoem"/>
    <field labelOnTop="0" name="cnt_oversvoem_fremtid"/>
    <field labelOnTop="0" name="fid"/>
    <field labelOnTop="0" name="kom_kode"/>
    <field labelOnTop="0" name="kvm_pris_kr"/>
    <field labelOnTop="0" name="max_vanddybde_cm"/>
    <field labelOnTop="0" name="max_vanddybde_fremtid_cm"/>
    <field labelOnTop="0" name="min_vanddybde_cm"/>
    <field labelOnTop="0" name="min_vanddybde_fremtid_cm"/>
    <field labelOnTop="0" name="risiko_kr"/>
    <field labelOnTop="0" name="skade_kategori"/>
    <field labelOnTop="0" name="skade_type"/>
    <field labelOnTop="0" name="skadebeloeb_fremtid_kr"/>
    <field labelOnTop="0" name="skadebeloeb_kaelder_fremtid_kr"/>
    <field labelOnTop="0" name="skadebeloeb_kaelder_kr"/>
    <field labelOnTop="0" name="skadebeloeb_kr"/>
    <field labelOnTop="0" name="tab_procent"/>
    <field labelOnTop="0" name="vaerditab_kr"/>
  </labelOnTop>
  <reuseLastValue>
    <field name="areal_byg_m2" reuseLastValue="0"/>
    <field name="areal_kaelder_m2" reuseLastValue="0"/>
    <field name="areal_oversvoem_fremtid_m2" reuseLastValue="0"/>
    <field name="areal_oversvoem_m2" reuseLastValue="0"/>
    <field name="avg_vanddybde_cm" reuseLastValue="0"/>
    <field name="avg_vanddybde_fremtid_cm" reuseLastValue="0"/>
    <field name="bbr_anv_kode" reuseLastValue="0"/>
    <field name="bbr_anv_tekst" reuseLastValue="0"/>
    <field name="cnt_oversvoem" reuseLastValue="0"/>
    <field name="cnt_oversvoem_fremtid" reuseLastValue="0"/>
    <field name="fid" reuseLastValue="0"/>
    <field name="kom_kode" reuseLastValue="0"/>
    <field name="kvm_pris_kr" reuseLastValue="0"/>
    <field name="max_vanddybde_cm" reuseLastValue="0"/>
    <field name="max_vanddybde_fremtid_cm" reuseLastValue="0"/>
    <field name="min_vanddybde_cm" reuseLastValue="0"/>
    <field name="min_vanddybde_fremtid_cm" reuseLastValue="0"/>
    <field name="risiko_kr" reuseLastValue="0"/>
    <field name="skade_kategori" reuseLastValue="0"/>
    <field name="skade_type" reuseLastValue="0"/>
    <field name="skadebeloeb_fremtid_kr" reuseLastValue="0"/>
    <field name="skadebeloeb_kaelder_fremtid_kr" reuseLastValue="0"/>
    <field name="skadebeloeb_kaelder_kr" reuseLastValue="0"/>
    <field name="skadebeloeb_kr" reuseLastValue="0"/>
    <field name="tab_procent" reuseLastValue="0"/>
    <field name="vaerditab_kr" reuseLastValue="0"/>
  </reuseLastValue>
  <dataDefinedFieldProperties/>
  <widgets/>
  <previewExpression>"bbr_anv_tekst"</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>2</layerGeometryType>
</qgis>
