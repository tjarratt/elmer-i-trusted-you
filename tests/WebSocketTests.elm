module WebSocketTests exposing (..)

import Test exposing (..)
import Expect
import Elmer
import Elmer.Html as Markup
import Elmer.Html.Event as Event
import Elmer.Spy as Spy exposing (Spy, andCallFake)
import Elmer.Spy.Matchers exposing (wasCalledWith, stringArg)
import WebSocket
import App
import Ports.LocalStorage exposing (..)


webSocketSendSpy : Spy
webSocketSendSpy =
    Spy.create "webSocketSend" (\_ -> WebSocket.send)
        |> andCallFake (\_ _ -> Cmd.none)


getItemSpy : Spy
getItemSpy =
    Spy.create "fakeGetItem" (\_ -> getItem)
        |> andCallFake (\_ -> Cmd.none)


sendTests : Test
sendTests =
    describe "send message"
        [ test "it says hello to the websocket" <|
            \() ->
                Elmer.given App.defaultModel App.view App.update
                    |> Spy.use [ webSocketSendSpy ]
                    |> Markup.target "#message-field"
                    |> Event.input "Hello!"
                    |> Markup.target "#send-button"
                    |> Event.click
                    |> Spy.expect "webSocketSend"
                        (wasCalledWith
                            [ stringArg "ws://testserver.com"
                            , stringArg "Hello!"
                            ]
                        )
        ]


jesusFuckingChristJustWorkTests : Test
jesusFuckingChristJustWorkTests =
    describe "come on"
        [ test "Michael. COME ON." <|
            \() ->
                Elmer.given App.defaultModel App.view App.update
                    |> Spy.use [ getItemSpy ]
                    |> Markup.target "#send-button2"
                    |> Event.click
                    |> Spy.expect "fakeGetItem"
                        (wasCalledWith [ stringArg "foobar" ])
        ]
