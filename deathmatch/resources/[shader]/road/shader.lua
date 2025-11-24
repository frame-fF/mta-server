setOcclusionsEnabled( false )
addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/1.jpg')
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'plaintarmac1')
engineApplyShaderToWorldTexture(shader, 'ws_carparknew2a')
engineApplyShaderToWorldTexture(shader, 'tar_venturasjoin')
engineApplyShaderToWorldTexture(shader, 'vegasdirtyroad3_256')
engineApplyShaderToWorldTexture(shader, 'desert_1linetar')
engineApplyShaderToWorldTexture(shader, 'desert_1line256')
engineApplyShaderToWorldTexture(shader, 'dt_roadblend')
engineApplyShaderToWorldTexture(shader, 'tar_1line256hvgtravel')
engineApplyShaderToWorldTexture(shader, 'tar_1line256hvlightsand')
engineApplyShaderToWorldTexture(shader, 'snpdwargrn1')
engineApplyShaderToWorldTexture(shader, 'tar_1line256hvblenddrtdot')
engineApplyShaderToWorldTexture(shader, 'tar_1line256hvblenddrt')
engineApplyShaderToWorldTexture(shader, 'tar_1line256hvblend2')
engineApplyShaderToWorldTexture(shader, 'tar_freewyleft')
engineApplyShaderToWorldTexture(shader, 'tar_freewyright')
engineApplyShaderToWorldTexture(shader, 'tar_lineslipway')
engineApplyShaderToWorldTexture(shader, 'lod_des_road1')
engineApplyShaderToWorldTexture(shader, 'des_1line256')
engineApplyShaderToWorldTexture(shader, 'des_1lineend')
engineApplyShaderToWorldTexture(shader, 'des_1linetar')
engineApplyShaderToWorldTexture(shader, 'tar_1line256hv')
engineApplyShaderToWorldTexture(shader, 'tar_1line256hvblend')
engineApplyShaderToWorldTexture(shader, 'roaddgrassblnd')
engineApplyShaderToWorldTexture(shader, 'tar_1linefreewy')
engineApplyShaderToWorldTexture(shader, 'concretenewgery256')
engineApplyShaderToWorldTexture(shader, 'roof06l256')
engineApplyShaderToWorldTexture(shader, 'stormdrain1_nt')
engineApplyShaderToWorldTexture(shader, 'lasrmd3_sjm')
engineApplyShaderToWorldTexture(shader, 'lasrmd2_sjm')
engineApplyShaderToWorldTexture(shader, 'stormdrain1b_sl')
engineApplyShaderToWorldTexture(shader, 'gm_lacarpark1')
engineApplyShaderToWorldTexture(shader, 'craproad2_lae')
engineApplyShaderToWorldTexture(shader, 'ws_carparknew2')
engineApplyShaderToWorldTexture(shader, 'ws_carparknew1')
engineApplyShaderToWorldTexture(shader, 'craproad3_lae')
engineApplyShaderToWorldTexture(shader, 'sf_junction3')
engineApplyShaderToWorldTexture(shader, 'by_cobain9')
engineApplyShaderToWorldTexture(shader, 'concretenewb256')
engineApplyShaderToWorldTexture(shader, 'bow_abattoir_conc2')
engineApplyShaderToWorldTexture(shader, 'craproad3_lae')
engineApplyShaderToWorldTexture(shader, 'greyground256')
engineApplyShaderToWorldTexture(shader, 'ws_carpark2')
engineApplyShaderToWorldTexture(shader, 'dustyconcrete')
engineApplyShaderToWorldTexture(shader, 'motocross_256')
engineApplyShaderToWorldTexture(shader, 'tar_1line256hvtodirt')
engineApplyShaderToWorldTexture(shader, 'wallbluetinge256')
engineApplyShaderToWorldTexture(shader, 'concretemanky')
engineApplyShaderToWorldTexture(shader, 'concretemanky')
engineApplyShaderToWorldTexture(shader, 'concretemanky')
engineApplyShaderToWorldTexture(shader, 'concretemanky')
engineApplyShaderToWorldTexture(shader, 'concretemanky')
engineApplyShaderToWorldTexture(shader, 'sam_camo')
engineApplyShaderToWorldTexture(shader, 'ws_carpark2')
engineApplyShaderToWorldTexture(shader, 'ws_carpark2')
engineApplyShaderToWorldTexture(shader, 'ws_carpark2')
engineApplyShaderToWorldTexture(shader, 'ws_carpark2')
engineApplyShaderToWorldTexture(shader, 'ws_carpark2')
engineApplyShaderToWorldTexture(shader, 'ws_carpark2')
engineApplyShaderToWorldTexture(shader, 'ws_carpark2')

end
)

addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/2.jpg') -- стена ЛВПД
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'office_wallnu1')
engineApplyShaderToWorldTexture(shader, 'mp_cop_wood') 
end
)


addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/3.jpg') --асфальт боком
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'ws_freeway3blend')
engineApplyShaderToWorldTexture(shader, 'ws_freeway3')
engineApplyShaderToWorldTexture(shader, 'vegasdirtyroad2_256')
engineApplyShaderToWorldTexture(shader, 'vegasroad3_256')
engineApplyShaderToWorldTexture(shader, 'sf_road5')
engineApplyShaderToWorldTexture(shader, 'sf_junction5')
engineApplyShaderToWorldTexture(shader, 'vegastriproad1_256')
engineApplyShaderToWorldTexture(shader, 'vegasroad2_256')
engineApplyShaderToWorldTexture(shader, 'hiwayend_256')
engineApplyShaderToWorldTexture(shader, 'hiwaymidlle_256')
engineApplyShaderToWorldTexture(shader, 'vegasroad1_256')
engineApplyShaderToWorldTexture(shader, 'vegasdirtyroad1_256')
engineApplyShaderToWorldTexture(shader, 'cos_hiwaymid_256')
engineApplyShaderToWorldTexture(shader, 'sl_freew2road1')
engineApplyShaderToWorldTexture(shader, 'roadnew4_512')
engineApplyShaderToWorldTexture(shader, 'roadnew4_256')
engineApplyShaderToWorldTexture(shader, 'dt_road')
engineApplyShaderToWorldTexture(shader, 'sl_roadbutt1')
engineApplyShaderToWorldTexture(shader, 'craproad1_lae')
engineApplyShaderToWorldTexture(shader, 'snpedtest1')
engineApplyShaderToWorldTexture(shader, 'roadnew4blend_256')
engineApplyShaderToWorldTexture(shader, 'snpedtest1blend')
engineApplyShaderToWorldTexture(shader, 'craproad7_lae7')

engineApplyShaderToWorldTexture(shader, 'ws_carpark1')
engineApplyShaderToWorldTexture(shader, 'mannblok2_lan')
engineApplyShaderToWorldTexture(shader, 'mannblok2_lan')
engineApplyShaderToWorldTexture(shader, 'mannblok2_lan')
engineApplyShaderToWorldTexture(shader, 'mannblok2_lan')

end
)

addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/4.png') -- окно изнутри ЛВПД
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'mp_police_win')
end
)

addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/5.png')
dxSetShaderValue(shader, 'gTexture', terrain)




engineApplyShaderToWorldTexture(shader, 'ws_sub_pen_conc3')
engineApplyShaderToWorldTexture(shader, 'dt_road_stoplinea')
engineApplyShaderToWorldTexture(shader, 'curb_64h')




engineApplyShaderToWorldTexture(shader, 'crossing_law2')


engineApplyShaderToWorldTexture(shader, 'greyground256sand')
engineApplyShaderToWorldTexture(shader, 'crossing_law')
engineApplyShaderToWorldTexture(shader, 'crossing_law3')

engineApplyShaderToWorldTexture(shader, 'greycrossing')


end
)

addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/6.jpg') --тетка на стене ЛС
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'sunbillb07')
end
)

addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/8.jpg') --тратуар
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'vegaspavement2_256')
engineApplyShaderToWorldTexture(shader, 'greyground256128')
engineApplyShaderToWorldTexture(shader, 'blendpavement2b_256')
engineApplyShaderToWorldTexture(shader, 'hiwayinside5_256')
engineApplyShaderToWorldTexture(shader, 'hiwayinside4_256')
engineApplyShaderToWorldTexture(shader, 'hiwayinside_256')
engineApplyShaderToWorldTexture(shader, 'hiwayoutside_256')
engineApplyShaderToWorldTexture(shader, 'hiwayinside2_256')
engineApplyShaderToWorldTexture(shader, 'hiwayinsideblend3_256')

engineApplyShaderToWorldTexture(shader, 'vgsroadirt2_256')
engineApplyShaderToWorldTexture(shader, 'vgsroadirt1_256')
engineApplyShaderToWorldTexture(shader, 'vegasdirtypaveblend1')
engineApplyShaderToWorldTexture(shader, 'vegasdirtypaveblend2')
engineApplyShaderToWorldTexture(shader, 'vegasdirtypave1_256')
engineApplyShaderToWorldTexture(shader, 'vegasdirtypave2_256')
engineApplyShaderToWorldTexture(shader, 'hiwayinside4_256')
engineApplyShaderToWorldTexture(shader, 'greyground256128')
engineApplyShaderToWorldTexture(shader, 'greyground256128')
engineApplyShaderToWorldTexture(shader, 'greyground256128')
engineApplyShaderToWorldTexture(shader, 'greyground256128')
end
)

addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/9.jpg') --тетка на стене ЛС
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'la_tilered')
engineApplyShaderToWorldTexture(shader, 'ws_floortiles4')
end
)

addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/10.png') -- Кусты
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'newtreeleaves128')
engineApplyShaderToWorldTexture(shader, 'newtreed256')
end
)

addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/11.png') -- Пол ТЦ
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'mallfloor4')
engineApplyShaderToWorldTexture(shader, 'mallfloor5_128')
engineApplyShaderToWorldTexture(shader, 'mallfloor6')
engineApplyShaderToWorldTexture(shader, 'mallfloor4')
end
)

addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/12.png') -- Газон
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'ap_tarmac')
engineApplyShaderToWorldTexture(shader, 'des_dirt1')
engineApplyShaderToWorldTexture(shader, 'con2sand1a')
engineApplyShaderToWorldTexture(shader, 'con2sand1b')
engineApplyShaderToWorldTexture(shader, 'des_scrub1')
engineApplyShaderToWorldTexture(shader, 'des_scrub1_dirt1')
engineApplyShaderToWorldTexture(shader, 'desgrassbrn')
engineApplyShaderToWorldTexture(shader, 'des_grass2scrub')
engineApplyShaderToWorldTexture(shader, 'desgrassbrnsnd')
engineApplyShaderToWorldTexture(shader, 'sandgrnd128')
engineApplyShaderToWorldTexture(shader, 'desgreengrass')
engineApplyShaderToWorldTexture(shader, 'desgrasandblend')
engineApplyShaderToWorldTexture(shader, 'desgrassbrn_lod')
engineApplyShaderToWorldTexture(shader, 'desgrasandblend_lod')
engineApplyShaderToWorldTexture(shader, 'des_scrub1_lod')
engineApplyShaderToWorldTexture(shader, 'des_dirt1_lod')
engineApplyShaderToWorldTexture(shader, 'hiway2sand1a')
engineApplyShaderToWorldTexture(shader, 'vgn_ground8_lod')
engineApplyShaderToWorldTexture(shader, 'vgn_ground7_lod')
engineApplyShaderToWorldTexture(shader, 'vgn_ground6_lod')
engineApplyShaderToWorldTexture(shader, 'vgn_ground5_lod')
engineApplyShaderToWorldTexture(shader, 'vgn_ground4_lod')
engineApplyShaderToWorldTexture(shader, 'vgn_ground3_lod')
engineApplyShaderToWorldTexture(shader, 'vgn_ground2_lod')

engineApplyShaderToWorldTexture(shader, 'des_scrub1_dirt1b')
engineApplyShaderToWorldTexture(shader, 'des_scrub1_dirt1a')
engineApplyShaderToWorldTexture(shader, 'vgn_ground10_lod')
engineApplyShaderToWorldTexture(shader, 'vgn_ground11_lod')
engineApplyShaderToWorldTexture(shader, 'vgn_ground9_lod')
engineApplyShaderToWorldTexture(shader, 'vgn_ground1_lod')
engineApplyShaderToWorldTexture(shader, 'bow_church_grass_gen')
engineApplyShaderToWorldTexture(shader, 'des_dirt1_glfhvy')
engineApplyShaderToWorldTexture(shader, 'golf_heavygrass')
engineApplyShaderToWorldTexture(shader, 'sandgrndlod')
engineApplyShaderToWorldTexture(shader, 'des_dirt1_grass')
engineApplyShaderToWorldTexture(shader, 'des_grass2dirt1')
engineApplyShaderToWorldTexture(shader, 'venturas_fwend')
engineApplyShaderToWorldTexture(shader, 'desstones_dirt1')
engineApplyShaderToWorldTexture(shader, 'des_roadedge2')
engineApplyShaderToWorldTexture(shader, 'des_roadedge1')
engineApplyShaderToWorldTexture(shader, 'grasstype5_desdirt')
engineApplyShaderToWorldTexture(shader, 'grasstype5_4')
engineApplyShaderToWorldTexture(shader, 'grasstype5')
engineApplyShaderToWorldTexture(shader, 'grasstype4')
engineApplyShaderToWorldTexture(shader, 'des_dirt2blend')
engineApplyShaderToWorldTexture(shader, 'des_dirt2dedgrass')
engineApplyShaderToWorldTexture(shader, 'des_dirt2track')
engineApplyShaderToWorldTexture(shader, 'des_dirt2')
engineApplyShaderToWorldTexture(shader, 'grassdead1')
engineApplyShaderToWorldTexture(shader, 'grassdead1blnd')
engineApplyShaderToWorldTexture(shader, 'des_dirtgravel')
engineApplyShaderToWorldTexture(shader, 'des_dirttrack1')
engineApplyShaderToWorldTexture(shader, 'des_dirttrack1r')
engineApplyShaderToWorldTexture(shader, 'des_dirttrackl')
engineApplyShaderToWorldTexture(shader, 'des_dirttrackx')
engineApplyShaderToWorldTexture(shader, 'des_dirt2 trackl')
engineApplyShaderToWorldTexture(shader, 'blendrock2grgrass')
engineApplyShaderToWorldTexture(shader, 'brngrss2stones')
engineApplyShaderToWorldTexture(shader, 'grasstype5_dirt')
engineApplyShaderToWorldTexture(shader, 'rocktq128_dirt')
engineApplyShaderToWorldTexture(shader, 'des_dirtgrassmixbmp')
engineApplyShaderToWorldTexture(shader, 'des_dirtgrassmixc')
engineApplyShaderToWorldTexture(shader, 'des_dirt2stones')
engineApplyShaderToWorldTexture(shader, 'sfn_rockhole')
engineApplyShaderToWorldTexture(shader, 'sfn_grass1')
engineApplyShaderToWorldTexture(shader, 'des_dirt2trackr')
engineApplyShaderToWorldTexture(shader, 'sjmscorclawn')
engineApplyShaderToWorldTexture(shader, 'des_dirt2stones')
engineApplyShaderToWorldTexture(shader, 'des_dirt2stones')
engineApplyShaderToWorldTexture(shader, 'des_dirt2stones')
engineApplyShaderToWorldTexture(shader, 'des_dirt2stones')
engineApplyShaderToWorldTexture(shader, 'des_dirt2stones')
engineApplyShaderToWorldTexture(shader, 'des_dirt2stones')
engineApplyShaderToWorldTexture(shader, 'des_dirt2stones')
engineApplyShaderToWorldTexture(shader, 'des_dirt2stones')
engineApplyShaderToWorldTexture(shader, 'des_dirt2stones')
engineApplyShaderToWorldTexture(shader, 'des_dirt2stones')


end
)

addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/13.png') -- Трава
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'sm_des_bush3')
engineApplyShaderToWorldTexture(shader, 'sm_des_bush2')
engineApplyShaderToWorldTexture(shader, 'sm_des_bush1')
engineApplyShaderToWorldTexture(shader, 'sm_des_bush2')
engineApplyShaderToWorldTexture(shader, 'sm_des_bush2')
engineApplyShaderToWorldTexture(shader, 'sm_des_bush2')
engineApplyShaderToWorldTexture(shader, 'sm_des_bush2')
end
)

addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/14.png') -- Тратуар красный
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'pavebsand256')
engineApplyShaderToWorldTexture(shader, 'pavebsandend')
end
)

addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/15.jpg') -- гора
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'des_redrockmid')
engineApplyShaderToWorldTexture(shader, 'des_rocky1')
end
)
addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/16.jpg') -- гора
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'des_redrockbot')
engineApplyShaderToWorldTexture(shader, 'des_rocky1_dirt1')
end
)

addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/17.jpg') -- гора без травы
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'des_redrock1')
engineApplyShaderToWorldTexture(shader, 'des_redrock2')
engineApplyShaderToWorldTexture(shader, 'sm_rock2_desert')
engineApplyShaderToWorldTexture(shader, 'des_redrockmidlod')
engineApplyShaderToWorldTexture(shader, 'des_redrockbotlod')
engineApplyShaderToWorldTexture(shader, 'des_yelrocklod')

engineApplyShaderToWorldTexture(shader, 'grassbrn2rockbrnlod')
engineApplyShaderToWorldTexture(shader, 'rocktbrn128lod')
engineApplyShaderToWorldTexture(shader, 'rocktbrn_dirt2')
engineApplyShaderToWorldTexture(shader, 'grassbrn2rockbrn')
engineApplyShaderToWorldTexture(shader, 'rocktbrn128')
engineApplyShaderToWorldTexture(shader, 'des_yelrock')
engineApplyShaderToWorldTexture(shader, 'cw2_mountrock')
engineApplyShaderToWorldTexture(shader, 'sfn_rocktbrn128')
engineApplyShaderToWorldTexture(shader, 'rocktbrn128blndlit')
end
)


addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/18.png') -- рамка у машины
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'ramka')

end
)

addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/19.jpg') -- трава лод
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'des_dirt1lod')
engineApplyShaderToWorldTexture(shader, 'des_grass2scrublod')
engineApplyShaderToWorldTexture(shader, 'des_grass2dirt1lod')
engineApplyShaderToWorldTexture(shader, 'desgrassbrnlod')
engineApplyShaderToWorldTexture(shader, 'des_scrub1_dirt1lod')
engineApplyShaderToWorldTexture(shader, 'des_scrub1lod')
engineApplyShaderToWorldTexture(shader, 'des_dirttrack1lod')
engineApplyShaderToWorldTexture(shader, 'desertgryard256lod')
engineApplyShaderToWorldTexture(shader, 'desgrassbrn_grn')
engineApplyShaderToWorldTexture(shader, 'desertgryard256')
engineApplyShaderToWorldTexture(shader, 'des_dirt2gygrasslod')
engineApplyShaderToWorldTexture(shader, 'des_dirt2gygrass')
engineApplyShaderToWorldTexture(shader, 'des_dirttrack1rlod')
engineApplyShaderToWorldTexture(shader, 'blendrock2grasslod')
engineApplyShaderToWorldTexture(shader, 'des_roadedge2lod')
engineApplyShaderToWorldTexture(shader, 'des_roadedge1lod')
engineApplyShaderToWorldTexture(shader, 'des_dirttrackllod')
engineApplyShaderToWorldTexture(shader, 'des_dirt1lod')
engineApplyShaderToWorldTexture(shader, 'des_dirt1lod')
engineApplyShaderToWorldTexture(shader, 'des_dirt1lod')
engineApplyShaderToWorldTexture(shader, 'des_dirt1lod')
engineApplyShaderToWorldTexture(shader, 'des_dirt1lod')
engineApplyShaderToWorldTexture(shader, 'des_dirt1lod')
engineApplyShaderToWorldTexture(shader, 'des_dirt1lod')
engineApplyShaderToWorldTexture(shader, 'des_dirt1lod')
engineApplyShaderToWorldTexture(shader, 'des_dirt1lod')

end
)

addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/20.jpg') -- банер спавн 1000*500
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'cm_clothing ad1')

end
)

addEventHandler('onClientResourceStart', resourceRoot,
function()
shader = dxCreateShader('shader.fx')
terrain = dxCreateTexture('img/888.png') -- пустая
dxSetShaderValue(shader, 'gTexture', terrain)
engineApplyShaderToWorldTexture(shader, 'antenna1')
engineApplyShaderToWorldTexture(shader, 'sm_agave_1')
engineApplyShaderToWorldTexture(shader, 'sm_agave_2')
engineApplyShaderToWorldTexture(shader, 'sm_agave_bloom')
engineApplyShaderToWorldTexture(shader, 'bevflower1')
engineApplyShaderToWorldTexture(shader, 'ruffroadlas')
engineApplyShaderToWorldTexture(shader, 'sm_minipalm1')
engineApplyShaderToWorldTexture(shader, 'clothline1_lae')
engineApplyShaderToWorldTexture(shader, 'ganggraf03_la')
engineApplyShaderToWorldTexture(shader, 'ganggraf04_la')
engineApplyShaderToWorldTexture(shader, 'telewireslong2')
engineApplyShaderToWorldTexture(shader, 'telewires_law')
engineApplyShaderToWorldTexture(shader, 'telewireslong')
engineApplyShaderToWorldTexture(shader, 'grille2_la')
engineApplyShaderToWorldTexture(shader, 'lasjmrail1')
engineApplyShaderToWorldTexture(shader, 'dead_fuzzy')
engineApplyShaderToWorldTexture(shader, 'dead_agave')
engineApplyShaderToWorldTexture(shader, 'plantb256')
engineApplyShaderToWorldTexture(shader, 'kbplanter_plants1')
engineApplyShaderToWorldTexture(shader, 'deadpalm01')
engineApplyShaderToWorldTexture(shader, 'lanlabra1_m')
engineApplyShaderToWorldTexture(shader, 'kbplanter_plants1')
engineApplyShaderToWorldTexture(shader, 'kbplanter_plants1')
engineApplyShaderToWorldTexture(shader, 'kbplanter_plants1')
end
)

--- Sitemiz : https://sparrow-mta.blogspot.com/

--- Facebook : https://facebook.com/sparrowgta/
--- İnstagram : https://instagram.com/sparrowmta/
--- YouTube : https://www.youtube.com/@TurkishSparroW/

--- Discord : https://discord.gg/DzgEcvy