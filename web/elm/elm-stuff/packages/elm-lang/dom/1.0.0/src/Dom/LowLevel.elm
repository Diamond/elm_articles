module Dom.LowLevel exposing
  ( onDocument
  , onWindow
  )

{-| This library backs user facing libraries like `elm-lang/mouse` and
`elm-lang/window` that expose the functionality here in a much nicer way. In
99% of cases, you will find what you want in those libraries, not here.

# Global Event Listeners
@docs onDocument, onWindow

-}

import Json.Decode as Json
import Native.Dom
import Task exposing (Task)


{-| Add an event handler on the `document`. The resulting task will never end,
and when you kill the process it is on, it will detach the relevant JavaScript
event listener.
-}
onDocument : String -> Json.Decoder msg -> (msg -> Task Never ()) -> Task Never Never
onDocument =
  Native.Dom.onDocument


{-| Add an event handler on `window`. The resulting task will never end, and
when you kill the process it is on, it will detach the relevant JavaScript
event listener.
-}
onWindow : String -> Json.Decoder msg -> (msg -> Task Never ()) -> Task Never Never
onWindow =
  Native.Dom.onWindow
