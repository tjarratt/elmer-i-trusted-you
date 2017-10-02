port module Ports.LocalStorage exposing (..)

{-| This is just a dumb wrapper around window.localStorage


# setItem

@docs setItem


# getItem

@docs getItem


# callback for getItem

@docs getItemResponse

-}

import Json.Decode as JD
import Json.Encode as JE


-- port for saving a json-encoded value with a key in local storage


port setItem : ( String, JD.Value ) -> Cmd msg



-- port for retrieving previously-saved json encoded values in local storage


port getItem : String -> Cmd msg



-- subscribe part of getItem port


port getItemResponse : (( String, Maybe JE.Value ) -> msg) -> Sub msg
