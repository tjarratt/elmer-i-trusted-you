module App exposing
  ( Model
  , defaultModel
  , view
  , update
  )

import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events as Event
import WebSocket

type Msg
  = SendMessage
  | MessageUpdate String

type alias Model =
  { items : List String
  , message : String
  }

defaultModel : Model
defaultModel =
  { items = []
  , message = ""
  }

view : Model -> Html Msg
view model =
  Html.div []
    [ Html.input [ Attr.id "message-field", Event.onInput MessageUpdate ] []
    , Html.button [ Attr.id "send-button", Event.onClick SendMessage ] []
    , Html.ul [ Attr.id "items" ] []
    ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    MessageUpdate message ->
      ( { model | message = message }, Cmd.none )
    SendMessage ->
      ( model, WebSocket.send "ws://testserver.com" model.message )
