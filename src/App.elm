module App
    exposing
        ( Model
        , defaultModel
        , view
        , update
        , subscriptions
        )

import Json.Decode as JD
import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events as Event
import Ports.LocalStorage exposing (..)
import WebSocket
import MyModule


type Msg
    = SendMessage
    | SendMessage2
    | WebSocketMessage String
    | MessageUpdate String
    | Foo String


type alias Model =
    { items : List String
    , message : String
    , banner : String
    }


defaultModel : Model
defaultModel =
    { items = []
    , message = ""
    , banner = ""
    }


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.input [ Attr.id "message-field", Event.onInput MessageUpdate ] []
        , Html.button [ Attr.id "send-button", Event.onClick SendMessage ] []
        , Html.button [ Attr.id "send-button2", Event.onClick SendMessage2 ] []
        , Html.ul [ Attr.id "items" ] <| List.map renderItem model.items
        , Html.span [ Attr.id "family-loves" ] [ Html.text model.banner ]
        ]


renderItem : String -> Html Msg
renderItem text =
    Html.li []
        [ Html.text text ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MessageUpdate message ->
            ( { model | message = message }, Cmd.none )

        SendMessage ->
            ( model, WebSocket.send "ws://testserver.com" model.message )

        SendMessage2 ->
            ( model, getItem "foobar" )

        Foo thingy ->
            ( { model | banner = "banner, michael" }, Cmd.none )

        WebSocketMessage wsMessage ->
            ( { model | items = parseItems wsMessage }, Cmd.none )


parseItems : String -> List String
parseItems json =
    JD.decodeString (JD.list JD.string) json
        |> Result.withDefault []


{-| Subscribes to updates from the outside world (ooh, spooky!)
-}
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ MyModule.getItemSub "foobiz" Foo
        , WebSocket.listen "ws://testserver.com" WebSocketMessage
        ]
