radioStations = {
    {"http://stream002.radio.hu/mr2.mp3", "MR2 Petőfi"},
    {"http://195.56.193.129:8100/listen.pls", "Sunshine FM"},
    {"https://stream.diazol.hu:31032/mulatos.mp3", "Mex Mulatós Rádió"},
    {"https://radioadmin.info/magyarmulatos", "Magyar Mulatós Rádió"},
    {"https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://schranz.in:8000/listen.pls?sid=1&t=.m3u", "Hardtechno AFK killer fm"}
}

function registerEvent(event, element, func)
    addEvent(event, true)
    addEventHandler(event, element, func)
end