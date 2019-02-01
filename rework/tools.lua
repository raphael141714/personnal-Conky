function getColor(rgba)
    return rgba[1], rgba[2], rgba[3], rgba[4]
end

-- Return a color for know ssid, black for unknow ssid and 0 if not connected
function wifi_ssid_color ()
    local sh_output = io.popen("iwgetid -r")
    local ssid = sh_output:read("*a")
    sh_output:close()
    local color = {}

    if      ssid == "" then             color = 0
    elseif  ssid == "EMA\n" then        color = {0/255, 161/255, 154/255}
    elseif  ssid == "JW-AP\n" then      color = {236/255, 74/255, 148/255}
    elseif  ssid == "Lepengouin\n" then color = {161/255, 236/255, 148/255}
    else                                color = {0, 0, 0}
    end

    return color
end