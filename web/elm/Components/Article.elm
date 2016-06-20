module Article exposing (view, Model)

import Html exposing (Html, span, strong, em, a, text)
import Html.Attributes exposing (class, href)

type alias Model =
  { title : String, url : String, postedBy : String, postedOn: String, favorite : Bool }

view : Model -> Html a
view model =
  span [ class "article" ] [
    a [ href model.url ] [ strong [ ] [ text model.title ] ]
    , span [ ] [ text (" Posted by: " ++ model.postedBy) ]
    , em [ ] [ text (" (posted on: " ++ model.postedOn ++ ")") ] ]
