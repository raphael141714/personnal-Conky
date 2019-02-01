require 'cairo'
require 'settings'
require 'tools'

function conky_CPU_square(cx_str, cy_str)
    cairo_set_source_rgba (cr, getColor(rgba_background_a1))

    local cx = tonumber(cx_str) -- absisce du centre de l'icone
    local cy = tonumber(cy_str) -- ordonnee du centre de l'icone
    local cpu1 = tonumber(conky_parse("${cpu cpu1}"))
    local cpu2 = tonumber(conky_parse("${cpu cpu2}"))
    local cpu3 = tonumber(conky_parse("${cpu cpu3}"))
    local cpu4 = tonumber(conky_parse("${cpu cpu4}"))

    -----------------------------------------------------
    -- Octogone de 100%
    cairo_move_to (cr, cx + 32.0, cy)
    cairo_line_to (cr, cx + 32.0, cy)
    cairo_line_to (cr, cx, cy + 32.0)
    cairo_line_to (cr, cx - 32.0, cy)
    cairo_line_to (cr, cx, cy - 32.0)
    cairo_line_to (cr, cx + 32.0, cy)

    -- Dessin des 100%
    cairo_set_source_rgba (cr, getColor(rgba_background_a1))  -- Inside color
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, getColor(rgba_drawing)) -- Line color
	cairo_stroke (cr)

    -- Octogone de 50%
    cairo_move_to (cr, cx + 16.0, cy)
    cairo_line_to (cr, cx + 16.0, cy)
    cairo_line_to (cr, cx, cy + 16.0)
    cairo_line_to (cr, cx - 16.0, cy)
    cairo_line_to (cr, cx, cy - 16.0)
    cairo_line_to (cr, cx + 16.0, cy)

    -- Dessin des 50%
    cairo_set_source_rgba (cr, getColor(rgba_background_a1))
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, getColor(rgba_drawing))
    cairo_stroke (cr)

    -- Octogone des CPU
    cairo_line_to (cr, cx + 32.0*(cpu1/100), cy)
    cairo_line_to (cr, cx, cy + 32.0*(cpu2/100))
    cairo_line_to (cr, cx - 32.0*(cpu3/100), cy)
    cairo_line_to (cr, cx, cy - 32.0*(cpu4/100))
    cairo_line_to (cr, cx + 32.0*(cpu1/100), cy)

    -- Dessin du graph
    cairo_set_source_rgba (cr, getColor(rgba_accent_1))
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, getColor(rgba_accent_2))
    cairo_stroke (cr)

    return ""
end


function conky_double_RAM_circle(cx_str, cy_str)
    local cx = tonumber(cx_str) -- absisce du centre de l'icone
    local cy = tonumber(cy_str) -- ordonnee du centre de l'icone
    local user_ram = tonumber(conky_parse("${memperc}")) -- Valeur du cercle exterieur
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

    cairo_set_source_rgba (cr, getColor(rgba_accent_1))
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, getColor(rgba_accent_2))
	cairo_stroke (cr)

    -----------------------------------------------------
    -- Cercle derrière celui de la SWAP
    cairo_arc (cr, cx, cy, 24.0, 0, math.pi*2.0)

    cairo_set_source_rgba (cr, getColor(rgba_background_a1))
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, getColor(rgba_drawing))
	cairo_stroke (cr)

    -----------------------------------------------------
    -- init de la value de la swap
    alpha=math.acos((100-2*swap)/100)
    start_angle=math.pi*0.5 - alpha
    end_angle=math.pi*0.5 + alpha

    -- deuxieme partie : Cercle interieur de SWAP
    cairo_arc (cr, cx, cy, 24.0, start_angle, end_angle)
    cairo_close_path(cr)

    cairo_set_source_rgba (cr, getColor(rgba_accent_1))
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, getColor(rgba_accent_2))
	cairo_stroke (cr)

    return ""
end

function conky_NET_arrows_wifi (cx_str, cy_str) 
    local cx = tonumber(cx_str) -- absisce du centre de l'icone
    local cy = tonumber(cy_str) -- ordonnee du centre de l'icone

    local arrow_color = wifi_ssid_color()

    if arrow_color == 0 then
        cairo_move_to (cr, cx - 16, cy - 16)
        cairo_line_to (cr, cx + 16.0, cy + 16.0)
        cairo_move_to (cr, cx + 16, cy - 16)
        cairo_line_to (cr, cx - 16.0, cy + 16.0)

        cairo_set_source_rgba (cr, getColor(rgba_background_a0))
        cairo_fill_preserve (cr)
        cairo_set_source_rgba (cr, 127/255, 140/255, 141/255, 1)
        cairo_stroke (cr)
    else
        local downspeed = tonumber(conky_parse("${downspeedf wlo1}"))
        local upspeed = tonumber(conky_parse("${upspeedf wlo1}"))

        local down_value = math.log(downspeed+1)*8
        local up_value = math.log(upspeed+1)*8

        ----------------------------------------------
        -- fleche gauche : contenu
        if up_value<62.5 then -- Remplir le rectangle
            cairo_move_to (cr, cx - 6.0 - 16.0, cy + 32.0)
            cairo_line_to (cr, cx - 6.0 - 16.0, cy + 32.0 - up_value*0.64)
            cairo_line_to (cr, cx + 6.0 - 16.0, cy + 32.0 - up_value*0.64)
            cairo_line_to (cr, cx + 6.0 - 16.0, cy + 32.0)
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

        cairo_set_source_rgba (cr, getColor(rgba_accent_2))
        cairo_fill_preserve (cr)
        cairo_set_source_rgba (cr, getColor(rgba_accent_2))
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
            cairo_line_to (cr, cx + 10.0, cy + 8.0)
            cairo_line_to (cr, cx + 10.0, cy + 32.0 - down_value*0.64)
            cairo_line_to (cr, cx + 6.0 + 16.0, cy + 32.0 - down_value*0.64)
            cairo_line_to (cr, cx + 6.0 + 16.0, cy + 8.0)
            cairo_line_to (cr, cx + 6.0 + 16.0 + 4.0, cy + 8.0)
            cairo_close_path (cr)
        end

        cairo_set_source_rgba (cr, getColor(rgba_accent_2))
        cairo_fill_preserve (cr)
        cairo_set_source_rgba (cr, getColor(rgba_accent_2))
        cairo_stroke (cr)

        ----------------------------------------------
        -- fleche gauche : template
        cairo_move_to (cr, cx - 6.0 - 16.0, cy + 32.0)
        cairo_line_to (cr, cx - 6.0 - 16.0, cy - 8.0)
        cairo_line_to (cr, cx - 12.0 - 16.0, cy - 8.0)
        cairo_line_to (cr, cx - 16.0, cy - 32.0)
        cairo_line_to (cr, cx + 12.0 - 16.0, cy - 8.0)
        cairo_line_to (cr, cx + 6.0 - 16.0, cy - 8.0)
        cairo_line_to (cr, cx + 6.0 - 16.0, cy + 32.0)
        cairo_close_path (cr)

        cairo_set_source_rgba (cr, getColor(rgba_background_a0))
        cairo_fill_preserve (cr)
        cairo_set_source_rgba (cr, getColor(rgba_drawing))
        cairo_stroke (cr)

        -----------------------------------------------
        -- fleche droite : template
        cairo_move_to (cr, cx + 6.0 + 16.0, cy - 32.0)
        cairo_line_to (cr, cx + 6.0 + 16.0, cy + 8.0)
        cairo_line_to (cr, cx + 12.0 + 16.0, cy + 8.0)
        cairo_line_to (cr, cx + 16.0, cy + 32.0)
        cairo_line_to (cr, cx - 12.0 + 16.0, cy + 8.0)
        cairo_line_to (cr, cx - 6.0 + 16.0, cy + 8.0)
        cairo_line_to (cr, cx - 6.0 + 16.0, cy - 32.0)
        cairo_close_path (cr)

        cairo_set_source_rgba (cr, getColor(rgba_background_a0))
        cairo_fill_preserve (cr)
        cairo_set_source_rgba (cr, getColor(rgba_drawing))
        cairo_stroke (cr)

        -----------------------------------------------
        -- indicateur ssid
        cairo_arc (cr, cx, cy, 4.0, 0, math.pi*2.0)

        cairo_set_source_rgba (cr, arrow_color[1], arrow_color[2], arrow_color[3], 1)
        cairo_fill_preserve (cr)
        cairo_set_source_rgba (cr, arrow_color[1], arrow_color[2], arrow_color[3], 1)
        cairo_stroke (cr)
    end
    return ""
end

function conky_TEMP_meter (cx_str, cy_str)
    local cx = tonumber(cx_str)
    local cy = tonumber(cy_str)

    local cpu_temp = tonumber(conky_parse("${acpitemp}"))
    local sh_output = io.popen("sensors radeon-pci-0100 | grep temp | awk '{ gsub(\"+\",\"\"); split($2,var,\"°\"); print var[1]; }'")
    local sh_temp = sh_output:read("*a")
    local gpu_temp = tonumber(sh_temp)
    sh_output:close()

    --------------------------------------------------------------------------------------
    -- Thermometre de gauche : valeur
    if cpu_temp<46 then
        cairo_arc (cr, cx - 16.0, cy + 24.0, 8.0, (-0.5+(1/6))*math.pi, (-0.5-(1/6))*math.pi)
        cairo_arc (cr, cx - 16.0, cy + 24.0 - 8.0, 4.0, math.pi, math.pi*2.0)
        cairo_close_path (cr)

        cairo_set_source_rgba (cr, getColor(rgba_accent_1))
        cairo_fill_preserve (cr)
        cairo_set_source_rgba (cr, getColor(rgba_accent_1))
        cairo_stroke (cr)
    elseif cpu_temp<90 then
        cairo_arc (cr, cx - 16.0, cy + 24.0, 8.0, (-0.5+(1/6))*math.pi, (-0.5-(1/6))*math.pi)
        cairo_arc (cr, cx - 16.0, cy + 24.0 - 8.0 - (cpu_temp-46.0), 4.0, math.pi, math.pi*2.0)
        cairo_close_path (cr)

        cairo_set_source_rgba (cr, getColor(rgba_accent_1))
        cairo_fill_preserve (cr)
        cairo_set_source_rgba (cr, getColor(rgba_accent_1))
        cairo_stroke (cr)
    else
        cairo_arc (cr, cx - 16.0, cy + 24.0, 8.0, (-0.5+(1/6))*math.pi, (-0.5-(1/6))*math.pi)
        cairo_arc (cr, cx - 16.0, cy + 24.0 - 8.0 - (44.0), 4.0, math.pi, math.pi*2.0)
        cairo_close_path (cr)

        cairo_set_source_rgba (cr, getColor(rgba_warning))
        cairo_fill_preserve (cr)
        cairo_set_source_rgba (cr, getColor(rgba_warning))
        cairo_stroke (cr)
    end

    --------------------------------------------------------------------------------------
    -- Thermometre de droite : GPU
    if gpu_temp<46 then
        cairo_arc (cr, cx + 16.0, cy + 24.0, 8.0, (-0.5+(1/6))*math.pi, (-0.5-(1/6))*math.pi)
        cairo_arc (cr, cx + 16.0, cy + 24.0 - 8.0, 4.0, math.pi, math.pi*2.0)
        cairo_close_path (cr)

        cairo_set_source_rgba (cr, getColor(rgba_accent_1))
        cairo_fill_preserve (cr)
        cairo_set_source_rgba (cr, getColor(rgba_accent_1))
        cairo_stroke (cr)
    elseif gpu_temp<90 then
        cairo_arc (cr, cx + 16.0, cy + 24.0, 8.0, (-0.5+(1/6))*math.pi, (-0.5-(1/6))*math.pi)
        cairo_arc (cr, cx + 16.0, cy + 24.0 - 8.0 -  (gpu_temp-46.0), 4.0, math.pi, math.pi*2.0)
        cairo_close_path (cr)

        cairo_set_source_rgba (cr, getColor(rgba_accent_1))
        cairo_fill_preserve (cr)
        cairo_set_source_rgba (cr, getColor(rgba_accent_1))
        cairo_stroke (cr)
    else -- Disque > 70 degres
        cairo_arc (cr, cx + 16.0, cy + 24.0, 8.0, (-0.5+(1/6))*math.pi, (-0.5-(1/6))*math.pi)
        cairo_arc (cr, cx + 16.0, cy + 24.0 - 8.0 - (44.0), 4.0, math.pi, math.pi*2.0)
        cairo_close_path (cr)

        -- Dessin du disque > 70 degres
        cairo_set_source_rgba (cr, getColor(rgba_warning))
        cairo_fill_preserve (cr)
        cairo_set_source_rgba (crconky_set_update_interval(0.1), getColor(rgba_warning))
        cairo_stroke (cr)
    end

    --------------------------------------------------------------------------------------
    -- Thermometre de gauche : CPU
    cairo_arc (cr, cx - 16.0, cy + 24.0, 8.0, (-0.5+(1/6))*math.pi, (-0.5-(1/6))*math.pi)
    cairo_line_to (cr, cx - 16.0 - 4.0, cy - 32.0 + 4.0)
    cairo_arc (cr, cx - 16.0, cy - 32.0 + 4.0, 4.0, math.pi, math.pi*2.0)
    cairo_close_path (cr)

    cairo_set_source_rgba (cr, getColor(rgba_background_a0))
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, getColor(rgba_drawing))
    cairo_stroke (cr)

    --------------------------------------------------------------------------------------
    -- Thermometre de droite : GPU
    cairo_arc (cr, cx + 16.0, cy + 24.0, 8.0, (-0.5+(1/6))*math.pi, (-0.5-(1/6))*math.pi)
    cairo_line_to (cr, cx + 16.0 - 4.0, cy - 32.0 + 4.0)
    cairo_arc (cr, cx + 16.0, cy - 32.0 + 4.0, 4.0, math.pi, math.pi*2.0)
    cairo_close_path (cr)

    cairo_set_source_rgba (cr, getColor(rgba_background_a0))
    cairo_fill_preserve (cr)
    cairo_set_source_rgba (cr, getColor(rgba_drawing))
    cairo_stroke (cr)

    return ""
end