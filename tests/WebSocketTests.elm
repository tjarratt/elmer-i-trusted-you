module WebSocketTests exposing (..)

import Test exposing (..)
import Expect
import Elmer exposing (atIndex, (<&&>))
import Elmer.Html as Markup
import Elmer.Html.Event as Event
import Elmer.Spy as Spy exposing (Spy, andCallFake)
import Elmer.Spy.Matchers exposing (wasCalledWith, stringArg)
import Elmer.Html.Matchers exposing (element, elements, hasText, hasAttribute, hasProperty)
import Elmer.Platform.Subscription as Subscription
import WebSocket
import App
import MyModule
import Ports.LocalStorage exposing (..)


webSocketSendSpy : Spy
webSocketSendSpy =
    Spy.create "webSocketSend" (\_ -> WebSocket.send)
        |> andCallFake (\_ _ -> Cmd.none)


getItemSpy : Spy
getItemSpy =
    Spy.create "fake-getItem" (\_ -> getItem)
        |> andCallFake (\_ -> Cmd.none)


getItemSubSpy : Spy
getItemSubSpy =
    Spy.create "fake-getItemSub" (\_ -> MyModule.getItemSub)
        |> andCallFake
            (\_ tagger ->
                Subscription.fake "myModule" tagger
            )


webSocketListenSpy : Spy
webSocketListenSpy =
    Spy.create "webSocketListen" (\_ -> WebSocket.listen)
        |> andCallFake
            (\_ tagger ->
                Subscription.fake "webSocket" tagger
            )


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


listenTests : Test
listenTests =
    describe "listen for message"
        [ describe "when a list of items is received via the websocket"
            [ test "it shows the items" <|
                \() ->
                    Elmer.given App.defaultModel App.view App.update
                        |> Spy.use [ webSocketListenSpy, getItemSubSpy ]
                        |> Subscription.with (\() -> App.subscriptions)
                        |> Subscription.send "webSocket" "[\"fun\",\"sun\",\"beach\"]"
                        |> Subscription.send "myModule" "banner, michael"
                        |> Markup.target "#items li"
                        |> Markup.expect
                            (elements <|
                                (atIndex 0 <| hasText "fun")
                                    <&&> (atIndex 1 <| hasText "sun")
                                    <&&> (atIndex 2 <| hasText "beach")
                            )
            ]
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
                    |> Spy.expect "fake-getItem"
                        (wasCalledWith [ stringArg "foobar" ])
        , test "You're gonna get some hop-ons" <|
            \() ->
                Elmer.given App.defaultModel App.view App.update
                    |> Spy.use [ webSocketListenSpy, getItemSubSpy ]
                    |> Subscription.with (\() -> App.subscriptions)
                    |> Subscription.send "myModule" "banner, michael"
                    |> Markup.target "#family-loves"
                    |> Markup.expect
                        (element <|
                            (hasText "banner, michael")
                        )
        ]
