module MyModule exposing (getItemSub)

import WebSocket


getItemSub : String -> (String -> msg) -> Sub msg
getItemSub str msg =
    WebSocket.listen "ws://DAAAANG.com" msg
