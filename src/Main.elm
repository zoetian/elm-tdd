module Main exposing (Model, Msg(..), init, main, update, view)

import Array
import Browser
import Html exposing (Html, button, div, form, input, li, span, text, ul)
import Html.Attributes exposing (checked, id, placeholder, style, type_, value)
import Html.Events exposing (onClick, onDoubleClick, onInput, onSubmit)
import List.Extra exposing (removeAt, setAt)


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { todos : List String, input : String }


init : Model
init =
    { todos = [], input = "" }



-- VIEW


view : Model -> Html Msg
view model =
    Html.div []
        ([ Html.input [ id "todo-input", onInput Input ] []
         , button [ id "add-button", onClick Click ] [ text "Add" ]
         ]
            ++ (model.todos
                    |> List.map
                        (\t ->
                            li
                                [ id "todo-list" ]
                                [ text t ]
                        )
               )
        )


type Msg
    = Input String
    | Click


update : Msg -> Model -> Model
update msg model =
    case msg of
        Input todoItem ->
            { model | input = todoItem }

        Click ->
            if model.input == "" then
                model

            else
                { model | todos = model.todos ++ [ model.input ] }
