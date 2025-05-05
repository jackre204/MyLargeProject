
function dxDrawCircleRectangle(x, y, rx, ry, color, radius, postGUI)
    rx = rx - radius * 2
    ry = ry - radius * 2
    x = x + radius
    y = y + radius

    if (rx >= 0) and (ry >= 0) then
        dxDrawRectangle(x, y, rx, ry, color, postGUI)
        dxDrawRectangle(x, y - radius, rx, radius, color, postGUI)
        dxDrawRectangle(x, y + ry, rx, radius, color, postGUI)
        dxDrawRectangle(x - radius, y, radius, ry, color, postGUI)
        dxDrawRectangle(x + rx, y, radius, ry, color, postGUI)

        dxDrawCircle(x, y, radius, 180, 270, color, color, 7, 1, postGUI)
        dxDrawCircle(x + rx, y, radius, 270, 360, color, color, 7, 1, postGUI)
        dxDrawCircle(x + rx, y + ry, radius, 0, 90, color, color, 7, 1, postGUI)
        dxDrawCircle(x, y + ry, radius, 90, 180, color, color, 7, 1, postGUI)
    end
end

function dxDrawBorder(x, y, w, h, size, color, postGUI)
	size = size or 2;
	
	dxDrawRectangle(x - size, y, size, h, color or tocolor(0, 0, 0, 180), postGUI);
	dxDrawRectangle(x + w, y, size, h, color or tocolor(0, 0, 0, 180), postGUI);
	dxDrawRectangle(x - size, y - size, w + (size * 2), size, color or tocolor(0, 0, 0, 180), postGUI);
	dxDrawRectangle(x - size, y + h, w + (size * 2), size, color or tocolor(0, 0, 0, 180), postGUI);
end