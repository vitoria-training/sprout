module Page.Top.Top exposing (..)

import Task
import Html exposing (..)
import Html.Attributes exposing (..)
import Element exposing (..)
import Element.Input as Input
import Element.Region as Region
import Element.Font as Font
import Element.Background as Background
import Browser
import Browser.Dom exposing (Viewport)
import Browser.Events as E
import Page.About.Parts.About_Parts as AP

main : Program () Model Msg
main =
    let
        handleResult v =
            case v of
                Err _ ->
                    NoOp

                Ok vp ->
                    GotInitialViewport vp
    in
    Browser.element
        { init = \_ -> ( initialModel, Task.attempt handleResult Browser.Dom.getViewport )
        , view = aboutElement
        , update = update
        , subscriptions = subscriptions
        }

subscriptions : model -> Sub Msg
subscriptions _ =
    E.onResize (\w h -> Resize ( toFloat w, toFloat h ))

-- MODEL
type alias Model =
    { width : Float
    , height : Float }

initialModel : Model
initialModel =
    { width = 0
    , height = 0 }

type Msg
    = NoOp
    | GotInitialViewport Viewport
    | Resize ( Float, Float )

-- UPDATE
setCurrentDimensions : { a | width : b, height : c } -> ( b, c ) -> { a | width : b, height : c }
setCurrentDimensions model ( w, h ) =
    { model | width = w, height = h }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotInitialViewport vp ->
            ( setCurrentDimensions model ( vp.scene.width, vp.scene.height ), Cmd.none )

        Resize ( w, h ) ->
            ( setCurrentDimensions model ( w, h ), Cmd.none )

        NoOp ->
            ( model, Cmd.none )

-- HeaderButoon template
butoonFontSize : Float -> Int
butoonFontSize width=
  round width // 70

topPaddingXY : { x : number, y : number }
topPaddingXY =
  { x = 35
  , y = 70}

aboutPaddingXY : { x : number, y : number }
aboutPaddingXY =
  { x = 50
  , y = 70}

contentsPaddingXY : { x : number, y : number }
contentsPaddingXY =
  { x = 20
  , y = 70}

contactPaddingXY : { x : number, y : number }
contactPaddingXY =
  { x = 60
  , y = 70}

headerButoon : { a | width : Float, height : Float } -> { b | x : Int, y : Int } -> String -> Element d
headerButoon model paddingXYValue label=
  column [ Element.width <| px ( round model.width // 10 )] [
    Input.button[ paddingXY ( round model.width // paddingXYValue.x ) ( round model.height // paddingXYValue.y )
      , spacing ( round model.height // 60 )
      , Element.width <| px ( round model.width // 12 )
      , Element.height fill
      , Background.color ( rgb255 211 211 211 )
      , Font.color ( rgb255 0 0 0 )
      , Font.size ( butoonFontSize model.width )
      , centerX
      , centerY
    ]
    { label = Element.text <| label
      , onPress = Nothing
    }
  ]

-- Footer Fixed value
footerFontSize : Float -> Int
footerFontSize mainScreenWidth =
    round mainScreenWidth // 70

footerHeight : Float -> Int
footerHeight mainScreenHeight =
    round mainScreenHeight // 13

footerPadding : { top : number, left : number, right : number, bottom : number }
footerPadding =
    { top = 0
    , left = 10
    , right = 10
    , bottom = 30 }

aboutElement : Model -> Html msg
aboutElement model=
        let
            contentsList =
                column [ Element.width <| px ( round model.width // 6 ) ] [
                    Input.button[ paddingXY ( round model.width // contentsPaddingXY.x ) ( round model.height // contentsPaddingXY.y )
                      , spacing ( round model.height // 60 )
                      , Element.width <| px ( round model.width // 6 )
                      , Element.width fill
                      , Background.color ( rgb255 211 211 211 )
                      , Font.color ( rgb255 0 0 0 )
                      , Font.size ( butoonFontSize model.width )
                      , centerX
                      , centerY
                      ]
                    { label = Element.text <| "Contents"
                    , onPress = Nothing
                    }
                ]
        in
        layout [ Element.width fill
            , Element.height fill ] <|
            column[ Element.width fill
                , Element.height fill ][
                -- Header
                column [ Element.width fill][
                    row [ Element.width fill
                        , Element.height <| px ( round model.height // 15 )
                    ][
                        column [ Element.width <| px ( round model.width // 30 ) ] [ 
                        -- Since I want it to be square, I use "height" and "width".
                            Element.image [ Element.width <| px ( round model.width // 40 )
                            , Element.height <| px ( round model.width // 40 )
                            , centerX
                            , centerY ]
                            { src = "../../Picture/elm_logo.png"
                            , description = "elm_logo" }
                        ]
                        , column [ Element.width fill] []
                        , headerButoon model topPaddingXY "Top"
                        , headerButoon model aboutPaddingXY "About"
                        , contentsList
                        , headerButoon model contactPaddingXY "Contact"
                        , column [ Element.width <| px ( round model.width // 100 ) ] [ ]
                    ]
                ]
                -- Top
                , column [ Element.width fill
                    , Element.height <| px 
                    (round model.height 
                    - round model.height // 15 
                    - round model.height // 13) ] [
                    row [ Element.width fill ][
                        column [ Element.width fill
                            , Element.height  <| px ( round model.height - round model.height // 7 ) ] [
                            Input.button[ paddingXY ( round model.width // 40 ) ( round model.height // 70 )
                                , spacing ( round model.height // 60 )
                                , Element.width <| px ( round model.width // 7 )
                                , Background.color ( rgb255 211 211 211 )
                                , Font.color ( rgb255 0 0 0 )
                                , Font.size ( butoonFontSize model.width )
                                , centerX
                                , centerY
                            ]
                            { label = Element.text <| "Play Contents!"
                            , onPress = Nothing
                            }
                        ]
                    ]
                ]
                -- Footer
                , column [Element.width fill][
                    row [Element.width fill][
                        el[ Background.color ( rgb255 128 128 128 )
                        , Font.color ( rgb255 0 0 0 )
                        , Font.size ( footerFontSize model.width )
                        , paddingEach footerPadding
                        , Element.width fill
                        , Element.height <| px ( footerHeight model.height )
                        ]
                        ( Element.text 
                        """© 2023 React Inc. All Rights Reserved.\nI'm happy! thank you!""")
                    ]
                ]
            ]