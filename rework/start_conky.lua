require 'cairo'
require 'rework.graphs'


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
        print("Fail to load cairo")
        return ""
    end

    conky_CPU_square (gap_x, gap_y)
    conky_double_RAM_circle (gap_x, gap_y + spacing*1)
    conky_NET_graph (gap_x, gap_y + spacing*2)
    conky_TEMP_meter (gap_x, gap_y + spacing*3)

return ""
end