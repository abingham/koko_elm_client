module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Window exposing (..)
import Test exposing (dummyText)
import Types exposing (..)
import Views.Component exposing (pageSelector)
import Views.Home exposing (home)
import Views.Reader exposing (reader)
import Views.Editor exposing (editor)
import Css exposing (asPairs)
import Utility exposing (styles)


-- import Koko.Asciidoc exposing (toHtml)


main =
    programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


updateWindow : Model -> Int -> Int -> Model
updateWindow model w h =
    let
        new_window =
            KWindow w h
    in
        { model | window = new_window, message = "w: " ++ (toString model.window.width) ++ ", h: " ++ (toString model.window.height) }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Resize w h ->
            ( (updateWindow model w h), Cmd.none )

        GoTo p ->
            ( { model | page = p }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Window.resizes (\{ width, height } -> Resize width height)


windowCss model =
    [ Css.width (Css.px ((toFloat model.window.width) - 100.0))
    , Css.height (Css.px (0.9 * (toFloat model.window.height - 575.0)))
    ]


page : Model -> Html Msg
page model =
    case model.page of
        ReaderPage ->
            reader model

        EditorPage ->
            editor model

        HomePage ->
            home model


view : Model -> Html Msg
view model =
    --
    div []
        [ div [ id "header" ]
            [ Views.Component.pageSelector model
            ]
        , (page model)
        , div [ id "footer" ] [ text model.message ]
        ]


type alias Flags =
    { width : Int
    , height : Int
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model (KWindow flags.width flags.height) HomePage "Start!"
    , Cmd.none
    )
