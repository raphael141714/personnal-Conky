require 'cairo'

function init_cairo()
  if conky_window == nil then
    return false
  end

  cs = cairo_xlib_surface_create(
    conky_window.display,
    conky_window.drawable,
    conky_window.visual,
    conky_window.width,
    conky_window.height)

  cr = cairo_create(cs)
  return true
end

function conky_main()
  if (not init_cairo()) then
    return
  end

end

function conky_double_RAM_circle(cx_str, cy_str)
    -- Couleur: blanc

    local cx = tonumber(cx_str) -- absisce du centre de l'icone
    local cy = tonumber(cy_str) -- ordonnee du centre de l'icone
    local user_ram = tonumber(conky_parse("${memperc}")) -- Valeur du cercle exterieur
    --local buffer_ram = tonumber(conky_parse("${buffers}"))
    --local cached_ram = tonumber(conky_parse("${cached}"))
    --local max_ram = tonumber(conky_parse("${memmax}"))
	local swap = tonumber(conky_parse("${swapperc}")) -- Valeur du cercle intérieur

    -----------------------------------------------------
    -- init de la value de la ram
	start_angle=0
    full_circle=2*math.pi
	end_angle=(user_ram/100)*full_circle -- Pour un cercle, il par de 0 à 2*pi radians

	-- premiere partie : Cercle exterieur de RAM
    cairo_move_to (cr, cx, cy)
    cairo_line_to (cr, cx + 32.0, cy)
	cairo_arc (cr,cx,cy,32.0,start_angle,end_angle)
    cairo_close_path(cr)

    cairo_set_source_rgba (cr, 52/255, 73/255, 94/255,1)
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, 44/255, 62/255, 80/255,1)
	cairo_stroke (cr)

    -----------------------------------------------------
    -- Cercle derrière celui de la SWAP
    cairo_arc (cr, cx, cy, 24.0, 0, math.pi*2.0)

    cairo_set_source_rgba (cr, 236/255, 240/255, 241/255, 1)
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, 189/255, 195/255, 199/255, 1)
	cairo_stroke (cr)

    -----------------------------------------------------
    -- init de la value de la swap
    alpha=math.acos((100-2*swap)/100)
    start_angle=math.pi*0.5 - alpha
    end_angle=math.pi*0.5 + alpha

    -- deuxieme partie : Cercle interieur de SWAP
    cairo_arc (cr, cx, cy, 24.0, start_angle, end_angle)
    cairo_close_path(cr)

    cairo_set_source_rgba (cr, 155/255, 89/255, 182/255, 1)
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, 142/255, 68/255, 173/255, 1)
	cairo_stroke (cr)

    return
end

function conky_CPU_square(cx_str, cy_str)
    -- Couleur: blanc
    cairo_set_source_rgba (cr, 236/255, 240/255, 241/255,1)

    local cx = tonumber(cx_str) -- absisce du centre de l'icone
    local cy = tonumber(cy_str) -- ordonnee du centre de l'icone
    local cpu0 = tonumber(conky_parse("${cpu cpu0}"))
    local cpu1 = tonumber(conky_parse("${cpu cpu1}"))
    local cpu2 = tonumber(conky_parse("${cpu cpu2}"))
    local cpu3 = tonumber(conky_parse("${cpu cpu3}"))
    local cpu4 = tonumber(conky_parse("${cpu cpu4}"))
    local cpu5 = tonumber(conky_parse("${cpu cpu5}"))
    local cpu6 = tonumber(conky_parse("${cpu cpu6}"))
    local cpu7 = tonumber(conky_parse("${cpu cpu7}"))

    -----------------------------------------------------
    -- Octogone de 100%
    cairo_move_to (cr, cx + 32.0, cy)
    cairo_line_to (cr, cx + 32.0, cy)
    cairo_line_to (cr, cx + 24.0, cy + 24.0)
    cairo_line_to (cr, cx, cy + 32.0)
    cairo_line_to (cr, cx - 24.0, cy + 24.0)
    cairo_line_to (cr, cx - 32.0, cy)
    cairo_line_to (cr, cx - 24.0, cy - 24.0)
    cairo_line_to (cr, cx, cy - 32.0)
    cairo_line_to (cr, cx + 24.0, cy - 24.0)
    cairo_line_to (cr, cx + 32.0, cy)

    -- Dessin des 100%
    cairo_set_source_rgba (cr, 236/255, 240/255, 241/255,1)
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, 127/255, 140/255, 141/255,1)
	cairo_stroke (cr)

    -- Octogone de 50%
    cairo_move_to (cr, cx + 16.0, cy)
    cairo_line_to (cr, cx + 16.0, cy)
    cairo_line_to (cr, cx + 12.0, cy + 12.0)
    cairo_line_to (cr, cx, cy + 16.0)
    cairo_line_to (cr, cx - 12.0, cy + 12.0)
    cairo_line_to (cr, cx - 16.0, cy)
    cairo_line_to (cr, cx - 12.0, cy - 12.0)
    cairo_line_to (cr, cx, cy - 16.0)
    cairo_line_to (cr, cx + 12.0, cy - 12.0)
    cairo_line_to (cr, cx + 16.0, cy)

    -- Dessin des 50%
    cairo_set_source_rgba (cr, 236/255, 240/255, 241/255,1)
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, 127/255, 140/255, 141/255,1)
	cairo_stroke (cr)

    -- Octogone des CPU
    cairo_line_to (cr, cx + 32.0*(cpu0/100), cy)
    cairo_line_to (cr, cx + 24.0*(cpu1/100), cy + 24.0*(cpu1/100))
    cairo_line_to (cr, cx, cy + 32.0*(cpu2/100))
    cairo_line_to (cr, cx - 24.0*(cpu3/100), cy + 24.0*(cpu3/100))
    cairo_line_to (cr, cx - 32.0*(cpu4/100), cy)
    cairo_line_to (cr, cx - 24.0*(cpu5/100), cy - 24.0*(cpu5/100))
    cairo_line_to (cr, cx, cy - 32.0*(cpu6/100))
    cairo_line_to (cr, cx + 24.0*(cpu7/100), cy - 24.0*(cpu7/100))
    cairo_line_to (cr, cx + 32.0*(cpu0/100), cy)

    -- Dessin du graph
    cairo_set_source_rgba (cr, 52/255, 152/255, 219/255,1)
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, 41/255, 128/255, 185/255,1)
    cairo_stroke (cr)

    return
end

function conky_DISK_cylinder(cx_str, cy_str)
    -- Couleur: blanc
    cairo_set_source_rgba (cr, 236/255, 240/255, 241/255,1)

    local cx = tonumber(cx_str) -- absisce du centre de l'icone
    local cy = tonumber(cy_str) -- ordonnee du centre de l'icone
    local disk = tonumber(conky_parse("${fs_used_perc}"))*0.01
    local full_circle = math.pi*2.0

    -----------------------------------------------------
    -- Cylindre extérieur

    -- Dessin de l'ellipse du bas et du cylindre de derriere
    half_under_ellipse (cx - 32.0, cy + 24.0, 64.0, 8.0)
    cairo_line_to (cr, cx - 32.0, cy - 28.0)
    half_upper_ellipse (cx - 32.0, cy - 32.0, 64.0, 8.0)
    cairo_close_path (cr)

    cairo_set_source_rgba (cr, 236/255, 240/255, 241/255,1)
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, 127/255, 140/255, 141/255,1)
    cairo_stroke (cr)

    -- Dessin du cylindre interieur de veleur d'occupation du disque
    half_under_ellipse (cx - 28.0, cy + 24.0, 56.0, 6.0)
    cairo_line_to (cr, cx - 28.0, cy + 28.0 - 56.0*disk)
    half_upper_ellipse (cx - 28.0, cy + 25.0 - 56.0*disk, 56.0, 6.0)
    ellipse (cx - 28.0, cy + 25.0 - 56.0*disk, 56.0, 6.0)
    cairo_close_path (cr)

    cairo_set_source_rgba (cr, 155/255, 89/255, 182/255, 1)
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, 142/255, 68/255, 173/255, 1)
	cairo_stroke (cr)

    -- Dessin de l'ellipse du haut
    ellipse (cx - 32.0, cy - 32.0, 64.0, 8.0)

    cairo_set_source_rgba (cr, 127/255, 140/255, 141/255,1)
    cairo_stroke (cr)

    return
end

-- Les fonctions suivantes servent pour le dessin d'ellipse et de demi-elipses.
-- Attention: elles excentrent le dessin.
function ellipse(cx, cy, width, height)
    cairo_save (cr);

    cairo_translate (cr, cx + width*0.5, cy + height*0.5);
    cairo_scale (cr, width*0.5, height*0.5);
    cairo_arc (cr, 0.0, 0.0, 1.0, 0.0, math.pi*2.0);

    cairo_restore (cr);

    return
end

function half_under_ellipse(cx, cy, width, height)
    cairo_save (cr);

    cairo_translate (cr, cx + width*0.5, cy + height*0.5);
    cairo_scale (cr, width*0.5, height*0.5);
    cairo_arc (cr, 0.0, 0.0, 1.0, 0.0, math.pi);


    cairo_restore (cr);

    return
end

function half_upper_ellipse(cx, cy, width, height)
    cairo_save (cr);

    cairo_translate (cr, cx + width*0.5, cy + height*0.5);
    cairo_scale (cr, width*0.5, height*0.5);
    cairo_arc (cr, 0.0, 0.0, 1.0, math.pi, math.pi*2.0);


    cairo_restore (cr);

    return
end

function conky_NET_arrows_eth (cx_str, cy_str)
    local cx = tonumber(cx_str) -- absisce du centre de l'icone
    local cy = tonumber(cy_str) -- ordonnee du centre de l'icone

    local downspeed = tonumber(conky_parse("${downspeedf eth0}"))
    local upspeed = tonumber(conky_parse("${upspeedf eth0}"))

    local down_value = math.log(downspeed+1)*8
    local up_value = math.log(upspeed+1)*8

    ----------------------------------------------
    -- fleche gauche : template
    cairo_move_to (cr, cx - 8.0 - 16.0, cy + 32.0)
    cairo_line_to (cr, cx - 8.0 - 16.0, cy - 8.0)
    cairo_line_to (cr, cx - 12.0 - 16.0, cy - 8.0)
    cairo_line_to (cr, cx - 16.0, cy - 32.0)
    cairo_line_to (cr, cx + 12.0 - 16.0, cy - 8.0)
    cairo_line_to (cr, cx + 8.0 - 16.0, cy - 8.0)
    cairo_line_to (cr, cx + 8.0 - 16.0, cy + 32.0)
    cairo_close_path (cr)

    cairo_set_source_rgba (cr, 236/255, 240/255, 241/255,1)
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, 127/255, 140/255, 141/255,1)
    cairo_stroke (cr)

    -----------------------------------------------
    -- fleche droite : template
    cairo_move_to (cr, cx + 8.0 + 16.0, cy - 32.0)
    cairo_line_to (cr, cx + 8.0 + 16.0, cy + 8.0)
    cairo_line_to (cr, cx + 12.0 + 16.0, cy + 8.0)
    cairo_line_to (cr, cx + 16.0, cy + 32.0)
    cairo_line_to (cr, cx - 12.0 + 16.0, cy + 8.0)
    cairo_line_to (cr, cx - 8.0 + 16.0, cy + 8.0)
    cairo_line_to (cr, cx - 8.0 + 16.0, cy - 32.0)
    cairo_close_path (cr)

    cairo_set_source_rgba (cr, 236/255, 240/255, 241/255,1)
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, 127/255, 140/255, 141/255,1)
    cairo_stroke (cr)

    ----------------------------------------------
    -- fleche gauche : contenu
    if up_value<62.5 then -- Remplir le rectangle
        cairo_move_to (cr, cx - 8.0 - 16.0, cy + 32.0)
        cairo_line_to (cr, cx - 8.0 - 16.0, cy + 32.0 - up_value*0.64)
        cairo_line_to (cr, cx + 8.0 - 16.0, cy + 32.0 - up_value*0.64)
        cairo_line_to (cr, cx + 8.0 - 16.0, cy + 32.0)
        cairo_close_path (cr)
    else -- remplir le triangle
        cairo_move_to (cr, cx - 8.0 - 16.0, cy + 32.0)
        cairo_line_to (cr, cx - 8.0 - 16.0, cy - 8.0)
        cairo_line_to (cr, cx - 8.0 - 16.0 - 4.0, cy - 8.0)
        cairo_line_to (cr, cx - 16.0 -0.5*(100-up_value)*0.64, cy + 32.0 - up_value*0.64)
        cairo_line_to (cr, cx - 16.0 +0.5*(100-up_value)*0.64, cy + 32.0 - up_value*0.64)
        cairo_line_to (cr, cx + 8.0 - 16.0 + 4.0, cy - 8.0)
        cairo_line_to (cr, cx + 8.0 - 16.0, cy - 8.0)
        cairo_line_to (cr, cx + 8.0 - 16.0, cy + 32.0)
        cairo_close_path (cr)
    end

    cairo_set_source_rgba (cr, 241/255, 196/255, 15/255,1)
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, 243/255, 156/255, 18/255,1)
    cairo_stroke (cr)

    -----------------------------------------------
    -- fleche droite : contenu
    if down_value<37.5 then -- remplir le triangle
        cairo_move_to (cr, cx + 16.0, cy + 32.0)
        cairo_line_to (cr, cx + 16.0 - 0.5*down_value*0.64, cy + 32.0 - down_value*0.64)
        cairo_line_to (cr, cx + 16.0 + 0.5*down_value*0.64, cy + 32.0 - down_value*0.64)
        cairo_close_path (cr)
    else -- remplir le rectangle
        cairo_move_to (cr, cx + 16.0, cy + 32.0)
        cairo_line_to (cr, cx + 4.0, cy + 8.0)
        cairo_line_to (cr, cx + 8.0, cy + 8.0)
        cairo_line_to (cr, cx + 8.0, cy + 32.0 - down_value*0.64)
        cairo_line_to (cr, cx + 8.0 + 16.0, cy + 32.0 - down_value*0.64)
        cairo_line_to (cr, cx + 8.0 + 16.0, cy + 8.0)
        cairo_line_to (cr, cx + 8.0 + 16.0 + 4.0, cy + 8.0)
        cairo_close_path (cr)
    end

    cairo_set_source_rgba (cr, 26/255, 188/255, 156/255,1)
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, 22/255, 160/255, 133/255,1)
    cairo_stroke (cr)

    return
end

function conky_NET_arrows_wifi (cx_str, cy_str)
    local cx = tonumber(cx_str) -- absisce du centre de l'icone
    local cy = tonumber(cy_str) -- ordonnee du centre de l'icone

    local downspeed = tonumber(conky_parse("${downspeedf wlan0}"))
    local upspeed = tonumber(conky_parse("${upspeedf wlan0}"))

    local down_value = math.log(downspeed+1)*8
    local up_value = math.log(upspeed+1)*8

    ----------------------------------------------
    -- fleche gauche : template
    cairo_move_to (cr, cx - 8.0 - 16.0, cy + 32.0)
    cairo_line_to (cr, cx - 8.0 - 16.0, cy - 8.0)
    cairo_line_to (cr, cx - 12.0 - 16.0, cy - 8.0)
    cairo_line_to (cr, cx - 16.0, cy - 32.0)
    cairo_line_to (cr, cx + 12.0 - 16.0, cy - 8.0)
    cairo_line_to (cr, cx + 8.0 - 16.0, cy - 8.0)
    cairo_line_to (cr, cx + 8.0 - 16.0, cy + 32.0)
    cairo_close_path (cr)

    cairo_set_source_rgba (cr, 236/255, 240/255, 241/255,1)
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, 127/255, 140/255, 141/255,1)
    cairo_stroke (cr)

    -----------------------------------------------
    -- fleche droite : template
    cairo_move_to (cr, cx + 8.0 + 16.0, cy - 32.0)
    cairo_line_to (cr, cx + 8.0 + 16.0, cy + 8.0)
    cairo_line_to (cr, cx + 12.0 + 16.0, cy + 8.0)
    cairo_line_to (cr, cx + 16.0, cy + 32.0)
    cairo_line_to (cr, cx - 12.0 + 16.0, cy + 8.0)
    cairo_line_to (cr, cx - 8.0 + 16.0, cy + 8.0)
    cairo_line_to (cr, cx - 8.0 + 16.0, cy - 32.0)
    cairo_close_path (cr)

    cairo_set_source_rgba (cr, 236/255, 240/255, 241/255,1)
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, 127/255, 140/255, 141/255,1)
    cairo_stroke (cr)

    ----------------------------------------------
    -- fleche gauche : contenu
    if up_value<62.5 then -- Remplir le rectangle
        cairo_move_to (cr, cx - 8.0 - 16.0, cy + 32.0)
        cairo_line_to (cr, cx - 8.0 - 16.0, cy + 32.0 - up_value*0.64)
        cairo_line_to (cr, cx + 8.0 - 16.0, cy + 32.0 - up_value*0.64)
        cairo_line_to (cr, cx + 8.0 - 16.0, cy + 32.0)
        cairo_close_path (cr)
    else -- remplir le triangle
        cairo_move_to (cr, cx - 8.0 - 16.0, cy + 32.0)
        cairo_line_to (cr, cx - 8.0 - 16.0, cy - 8.0)
        cairo_line_to (cr, cx - 8.0 - 16.0 - 4.0, cy - 8.0)
        cairo_line_to (cr, cx - 16.0 -0.5*(100-up_value)*0.64, cy + 32.0 - up_value*0.64)
        cairo_line_to (cr, cx - 16.0 +0.5*(100-up_value)*0.64, cy + 32.0 - up_value*0.64)
        cairo_line_to (cr, cx + 8.0 - 16.0 + 4.0, cy - 8.0)
        cairo_line_to (cr, cx + 8.0 - 16.0, cy - 8.0)
        cairo_line_to (cr, cx + 8.0 - 16.0, cy + 32.0)
        cairo_close_path (cr)
    end

    cairo_set_source_rgba (cr, 241/255, 196/255, 15/255,1)
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, 243/255, 156/255, 18/255,1)
    cairo_stroke (cr)

    -----------------------------------------------
    -- fleche droite : contenu
    if down_value<37.5 then -- remplir le triangle
        cairo_move_to (cr, cx + 16.0, cy + 32.0)
        cairo_line_to (cr, cx + 16.0 - 0.5*down_value*0.64, cy + 32.0 - down_value*0.64)
        cairo_line_to (cr, cx + 16.0 + 0.5*down_value*0.64, cy + 32.0 - down_value*0.64)
        cairo_close_path (cr)
    else -- remplir le rectangle
        cairo_move_to (cr, cx + 16.0, cy + 32.0)
        cairo_line_to (cr, cx + 4.0, cy + 8.0)
        cairo_line_to (cr, cx + 8.0, cy + 8.0)
        cairo_line_to (cr, cx + 8.0, cy + 32.0 - down_value*0.64)
        cairo_line_to (cr, cx + 8.0 + 16.0, cy + 32.0 - down_value*0.64)
        cairo_line_to (cr, cx + 8.0 + 16.0, cy + 8.0)
        cairo_line_to (cr, cx + 8.0 + 16.0 + 4.0, cy + 8.0)
        cairo_close_path (cr)
    end

    cairo_set_source_rgba (cr, 26/255, 188/255, 156/255,1)
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, 22/255, 160/255, 133/255,1)
    cairo_stroke (cr)

    return
end

function conky_TIME_clock (cx_str, cy_str)
    local cx = tonumber(cx_str)
    local cy = tonumber(cy_str)

    local seconds = tonumber(conky_parse("${time %s}"))
    local minutes = tonumber(conky_parse("${time %m}"))
    local hours = tonumber(conky_parse("${time %H}"))
    local clock_step = math.pi/30
    local clock_hour_step = math.pi/6
    local clock_offset = -0.5*math.pi

    local full_circle = math.pi*2.0
    local step = math.pi/6

    cairo_arc (cr, cx, cy, 32.0, 0, full_circle)

    cairo_set_source_rgba (cr, 149/255, 165/255, 166/255,1)
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, 127/255, 140/255, 141/255,1)
    cairo_stroke (cr)

    for i=0,full_circle,step do
        cairo_arc (cr, cx, cy, 28.0, i, i+math.pi/6)
        cairo_line_to (cr, math.cos(i+step)*24.0 + cx, math.sin(i+step)*24.0 + cy)
    end

    cairo_set_source_rgba (cr, 236/255, 240/255, 241/255,1)
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, 127/255, 140/255, 141/255,1)
    cairo_stroke (cr)

    -- Heures
    cairo_move_to (cr, cx, cy)
    cairo_line_to (cr, cx + math.cos(clock_offset + (hours + minutes/60)*clock_hour_step)*8, cy + math.sin(clock_offset+(hours + minutes/60)*clock_hour_step)*8)

    -- Minutes
    cairo_move_to (cr, cx, cy)
    cairo_line_to (cr, cx + math.cos(clock_offset + clock_step*minutes)*16, cy + math.sin(clock_offset + clock_step*minutes)*16)

    -- Secondes
    cairo_move_to (cr, cx, cy)
    cairo_line_to (cr, cx + math.cos(clock_offset + clock_step * seconds)*24, cy + math.sin(clock_offset + clock_step * seconds)*24)

    cairo_set_source_rgba (cr, 236/255, 240/255, 241/255,1)
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, 127/255, 140/255, 141/255,1)
    cairo_stroke (cr)

    return
end

function conky_TEMP_meter (cx_str, cy_str)
    local cx = tonumber(cx_str)
    local cy = tonumber(cy_str)

    local cpu_temp = tonumber(conky_parse("${acpitemp}"))
    local gpu_temp = tonumber(conky_parse("${nvidia temp}"))
    local sh_output = io.popen("hddtemp /dev/sda|awk '{print $NF}'| tr -d '°C'")
    local sh_temp = sh_output:read("*a")
    local disk_temp = tonumber(sh_temp)
    sh_output:close()

    --------------------------------------------------------------------------------------
    -- Thermometre de gauche : CPU
    cairo_arc (cr, cx - 24.0, cy + 24.0, 8.0, (-0.5+(1/6))*math.pi, (-0.5-(1/6))*math.pi)
    cairo_line_to (cr, cx - 24.0 - 4.0, cy - 32.0 + 4.0)
    cairo_arc (cr, cx - 24.0, cy - 32.0 + 4.0, 4.0, math.pi, math.pi*2.0)
    cairo_close_path (cr)

    cairo_set_source_rgba (cr, 236/255, 240/255, 241/255,1)
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, 127/255, 140/255, 141/255,1)
    cairo_stroke (cr)

    --------------------------------------------------------------------------------------
    -- Thermometre de gauche : valeur
    if cpu_temp<46 then
        cairo_arc (cr, cx - 24.0, cy + 24.0, 8.0, (-0.5+(1/6))*math.pi, (-0.5-(1/6))*math.pi)
        cairo_arc (cr, cx - 24.0, cy + 24.0 - 8.0, 4.0, math.pi, math.pi*2.0)
        cairo_close_path (cr)

        cairo_set_source_rgba (cr, 52/255, 152/255, 219/255,1)
        cairo_fill_preserve (cr)
        cairo_set_source_rgba (cr, 41/255, 128/255, 185/255,1)
        cairo_stroke (cr)
    elseif cpu_temp<90 then
        cairo_arc (cr, cx - 24.0, cy + 24.0, 8.0, (-0.5+(1/6))*math.pi, (-0.5-(1/6))*math.pi)
        cairo_arc (cr, cx - 24.0, cy + 24.0 - 8.0 - (cpu_temp-46.0), 4.0, math.pi, math.pi*2.0)
        cairo_close_path (cr)

        if cpu_temp<70 then
            cairo_set_source_rgba (cr, 52/255, 152/255, 219/255,1)
            cairo_fill_preserve (cr)
            cairo_set_source_rgba (cr, 41/255, 128/255, 185/255,1)
            cairo_stroke (cr)
        elseif cpu_temp<80 then
            cairo_set_source_rgba (cr, 230/255, 126/255, 34/255,1)
            cairo_fill_preserve (cr)
            cairo_set_source_rgba (cr, 211/255, 84/255, 0/255,1)
            cairo_stroke (cr)
        else -- Disque > 60 degres
            cairo_set_source_rgba (cr, 231/255, 76/255, 60/255,1)
            cairo_fill_preserve (cr)
            cairo_set_source_rgba (cr, 192/255, 57/255, 43/255,1)
            cairo_stroke (cr)
        end
    else
        cairo_arc (cr, cx - 24.0, cy + 24.0, 8.0, (-0.5+(1/6))*math.pi, (-0.5-(1/6))*math.pi)
        cairo_arc (cr, cx - 24.0, cy + 24.0 - 8.0 - (44.0), 4.0, math.pi, math.pi*2.0)
        cairo_close_path (cr)

        cairo_set_source_rgba (cr, 231/255, 76/255, 60/255,1)
        cairo_fill_preserve (cr)
        cairo_set_source_rgba (cr, 192/255, 57/255, 43/255,1)
        cairo_stroke (cr)
    end

    --------------------------------------------------------------------------------------
    -- Thermometre du milieu : GPU
    cairo_arc (cr, cx, cy + 24.0, 8.0, (-0.5+(1/6))*math.pi, (-0.5-(1/6))*math.pi)
    cairo_line_to (cr, cx - 4.0, cy - 32.0 + 4.0)
    cairo_arc (cr, cx, cy - 32.0 + 4.0, 4.0, math.pi, math.pi*2.0)
    cairo_close_path (cr)

    cairo_set_source_rgba (cr, 236/255, 240/255, 241/255,1)
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, 127/255, 140/255, 141/255,1)
    cairo_stroke (cr)

    --------------------------------------------------------------------------------------
    -- Thermometre de milieu : valeur
    if gpu_temp<46 then
        cairo_arc (cr, cx, cy + 24.0, 8.0, (-0.5+(1/6))*math.pi, (-0.5-(1/6))*math.pi)
        cairo_arc (cr, cx, cy + 24.0 - 8.0, 4.0, math.pi, math.pi*2.0)
        cairo_close_path (cr)

        cairo_set_source_rgba (cr, 46/255, 204/255, 113/255,1)
        cairo_fill_preserve (cr)
        cairo_set_source_rgba (cr, 39/255, 174/255, 96/255,1)
        cairo_stroke (cr)
    elseif gpu_temp<90 then
        cairo_arc (cr, cx, cy + 24.0, 8.0, (-0.5+(1/6))*math.pi, (-0.5-(1/6))*math.pi)
        cairo_arc (cr, cx, cy + 24.0 - 8.0 - (gpu_temp-46.0), 4.0, math.pi, math.pi*2.0)
        cairo_close_path (cr)

        if gpu_temp<70 then
            cairo_set_source_rgba (cr, 46/255, 204/255, 113/255,1)
            cairo_fill_preserve (cr)
            cairo_set_source_rgba (cr, 39/255, 174/255, 96/255,1)
            cairo_stroke (cr)
        elseif gpu_temp<80 then
            cairo_set_source_rgba (cr, 230/255, 126/255, 34/255,1)
            cairo_fill_preserve (cr)
            cairo_set_source_rgba (cr, 211/255, 84/255, 0/255,1)
            cairo_stroke (cr)
        else -- GPU > 60 degres
            cairo_set_source_rgba (cr, 231/255, 76/255, 60/255,1)
            cairo_fill_preserve (cr)
            cairo_set_source_rgba (cr, 192/255, 57/255, 43/255,1)
            cairo_stroke (cr)
        end
    else
        cairo_arc (cr, cx, cy + 24.0, 8.0, (-0.5+(1/6))*math.pi, (-0.5-(1/6))*math.pi)
        cairo_arc (cr, cx, cy + 24.0 - 8.0 - (44.0), 4.0, math.pi, math.pi*2.0)
        cairo_close_path (cr)

        cairo_set_source_rgba (cr, 231/255, 76/255, 60/255,1)
        cairo_fill_preserve (cr)
        cairo_set_source_rgba (cr, 192/255, 57/255, 43/255,1)
        cairo_stroke (cr)
    end

    --------------------------------------------------------------------------------------
    -- Thermometre de droite : Disque
    cairo_arc (cr, cx + 24.0, cy + 24.0, 8.0, (-0.5+(1/6))*math.pi, (-0.5-(1/6))*math.pi)
    cairo_line_to (cr, cx + 24.0 - 4.0, cy - 32.0 + 4.0)
    cairo_arc (cr, cx + 24.0, cy - 32.0 + 4.0, 4.0, math.pi, math.pi*2.0)
    cairo_close_path (cr)

    --------------------------------------------------------------------------------------
    -- Dessin des thermometres
    cairo_set_source_rgba (cr, 236/255, 240/255, 241/255,1)
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, 127/255, 140/255, 141/255,1)
    cairo_stroke (cr)

    --------------------------------------------------------------------------------------
    -- Thermometre de droite : Disque
    if disk_temp<26 then
        cairo_arc (cr, cx + 24.0, cy + 24.0, 8.0, (-0.5+(1/6))*math.pi, (-0.5-(1/6))*math.pi)
        cairo_arc (cr, cx + 24.0, cy + 24.0 - 8.0, 4.0, math.pi, math.pi*2.0)
        cairo_close_path (cr)

        cairo_set_source_rgba (cr, 155/255, 89/255, 182/255, 1)
        cairo_fill_preserve (cr)
        cairo_set_source_rgba (cr, 142/255, 68/255, 173/255, 1)
    	cairo_stroke (cr)
    elseif disk_temp<70 then
        cairo_arc (cr, cx + 24.0, cy + 24.0, 8.0, (-0.5+(1/6))*math.pi, (-0.5-(1/6))*math.pi)
        cairo_arc (cr, cx + 24.0, cy + 24.0 - 8.0 - (disk_temp-26.0), 4.0, math.pi, math.pi*2.0)
        cairo_close_path (cr)

        if disk_temp<50 then
            cairo_set_source_rgba (cr, 155/255, 89/255, 182/255, 1)
            cairo_fill_preserve (cr)
            cairo_set_source_rgba (cr, 142/255, 68/255, 173/255, 1)
        	cairo_stroke (cr)
        elseif disk_temp<60 then
            cairo_set_source_rgba (cr, 230/255, 126/255, 34/255,1)
            cairo_fill_preserve (cr)
            cairo_set_source_rgba (cr, 211/255, 84/255, 0/255,1)
            cairo_stroke (cr)
        else -- Disque > 60 degres
            cairo_set_source_rgba (cr, 231/255, 76/255, 60/255,1)
            cairo_fill_preserve (cr)
            cairo_set_source_rgba (cr, 192/255, 57/255, 43/255,1)
            cairo_stroke (cr)
        end
    else -- Disque > 70 degres
        cairo_arc (cr, cx + 24.0, cy + 24.0, 8.0, (-0.5+(1/6))*math.pi, (-0.5-(1/6))*math.pi)
        cairo_arc (cr, cx + 24.0, cy + 24.0 - 8.0 - (44.0), 4.0, math.pi, math.pi*2.0)
        cairo_close_path (cr)

        -- Dessin du disque > 70 degres
        cairo_set_source_rgba (cr, 231/255, 76/255, 60/255,1)
        cairo_fill_preserve (cr)
        cairo_set_source_rgba (crconky_set_update_interval(0.1), 192/255, 57/255, 43/255,1)
        cairo_stroke (cr)
    end

    return
end

function conky_UPTIME_timer (cx_str, cy_str)
    local cx = tonumber(cx_str)
    local cy = tonumber(cy_str)

    -- Recuperation de l'uptime
    local uptime = conky_parse("$uptime")

    -- Recupération des positions des secondes, minutes, heures et jours dans la chaine d'uptime
    local seconds_pos_in_string = string.find (uptime, "s")
    local minutes_pos_in_string = string.find (uptime, "m")
    local hours_pos_in_string = string.find (uptime, "h")
    local days_pos_in_string = string.find (uptime, "d")

    -- Translation de la chaine en nombres
    if not seconds_pos_in_string then
        seconds = 0
    else
        seconds = string.sub(uptime, seconds_pos_in_string - 2, seconds_pos_in_string - 1)
    end

    if not minutes_pos_in_string then
        minutes = 0
    else
        minutes = string.sub(uptime, minutes_pos_in_string - 2, minutes_pos_in_string - 1)
    end

    if not hours_pos_in_string then
        hours = 0
    else
        hours = string.sub(uptime, hours_pos_in_string - 2, hours_pos_in_string - 1)
    end

    if not days_pos_in_string then
        days = 0
    else
        days = string.sub(uptime, days_pos_in_string - 2, days_pos_in_string - 1)
    end

    -- Definition des angles
    local clock_step = math.pi/30
    local clock_hour_step = math.pi/12
    local clock_offset = -0.5*math.pi

    -- Tracage du cercle superieur
    cairo_arc (cr, cx, cy - 32.0 + 8.0, 8.0, 0, math.pi*2.0)
    cairo_move_to (cr, cx + 4.0, cy - 32.0 + 8.0)
    cairo_arc_negative (cr, cx, cy - 32.0 + 8.0, 4.0, math.pi*2.0, 0)
    cairo_move_to (cr, cx + 24.0, cy + 8.0)
    cairo_arc (cr, cx, cy + 8.0, 24.0, 0.0, math.pi*2.0)
    cairo_move_to (cr, cx + 20.0, cy + 8.0)

    cairo_set_source_rgba (cr, 149/255, 165/255, 166/255,1)
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, 127/255, 140/255, 141/255,1)
	cairo_stroke (cr)

    -- Tracage des marques
    for i=0,2.0*math.pi,clock_hour_step do
        cairo_arc (cr, cx, cy + 8.0, 20.0, i, i+math.pi/6)
        cairo_line_to (cr, math.cos(i+2.0*clock_hour_step)*16.0 + cx, cy + 8.0 + math.sin(i+2.0*clock_hour_step)*16.0)
        cairo_move_to (cr, math.cos(i+2.0*clock_hour_step)*20.0 + cx, cy + 8.0 + math.sin(i+2.0*clock_hour_step)*20.0)
    end

    cairo_arc (cr, cx, cy + 8.0, 20.0, 0, math.pi*2.0)

    -- Tracage des aiguilles
    cairo_move_to (cr, cx, cy + 8.0)
    cairo_line_to (cr, cx + math.cos(seconds*clock_step + clock_offset)*16.0, cy + 8.0 + math.sin(seconds*clock_step + clock_offset)*16.0)
    cairo_move_to (cr, cx, cy + 8.0)
    cairo_line_to (cr, cx + math.cos(minutes*clock_step + clock_offset)*12.0, cy + 8.0 + math.sin(minutes*clock_step + clock_offset)*12.0)
    cairo_move_to (cr, cx, cy + 8.0)
    cairo_line_to (cr, cx + math.cos(hours*clock_hour_step + clock_offset)*8.0, cy + 8.0 + math.sin(hours*clock_hour_step + clock_offset)*8.0)
    cairo_move_to (cr, cx, cy + 8.0)
    cairo_line_to (cr, cx + math.cos(days*clock_step + clock_offset)*4.0, cy + 8.0 + math.sin(days*clock_step + clock_offset)*4.0)

    -- Dessin du chronometre
    cairo_set_source_rgba (cr, 236/255, 240/255, 241/255,1)
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, 127/255, 140/255, 141/255,1)
	cairo_stroke (cr)

    return

end

function conky_getGPUtemp()
    local val = conky_parse("${nvidia temp}")
    return val
end

function conky_getCPUtemp()
    local val = conky_parse("${acpitemp}")
    return val
end

function conky_end()

end
