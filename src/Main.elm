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
    { todos : List Todo, content : String }


type alias Todo =
    { todoContent : String
    , isCompleted : Bool
    , isEdited : Bool
    }


init : Model
init =
    { todos = [], content = "" }



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ style "margin-top" "20px"
        , style "margin-left" "20px"
        ]
        [ form
            [ id "todo-form", onSubmit Add ]
            [ input
                [ id "todo-input"
                , placeholder "Add your todo here"
                , onInput Input
                ]
                []
            , button
                [ id "add-button"
                , type_ "submit"
                ]
                [ text "Add" ]
            ]
        , ul
            []
            (model.todos
                |> List.indexedMap
                    (\checkedIdx todo ->
                        if todo.isCompleted then
                            li
                                [ id "todo-list"
                                , style "text-decoration" "line-through"
                                , onDoubleClick (Edit checkedIdx)
                                ]
                                [ input
                                    [ type_ "checkbox"
                                    , onClick (Checked checkedIdx)
                                    ]
                                    []
                                , if todo.isEdited then
                                    input [ value todo.todoContent, type_ "text" ] []

                                  else
                                    text todo.todoContent
                                , button [ id "delete-button", onClick (Delete checkedIdx) ] [ text "Delete" ]
                                ]

                        else
                            li
                                [ id "todo-list"
                                , onDoubleClick (Edit checkedIdx)
                                ]
                                [ input
                                    [ type_ "checkbox"
                                    , onClick (Checked checkedIdx)
                                    ]
                                    []
                                , if todo.isEdited then
                                    input [ value todo.todoContent, type_ "text" ] []

                                  else
                                    text todo.todoContent
                                , button [ id "delete-button", onClick (Delete checkedIdx) ] [ text "Delete" ]
                                ]
                    )
            )
        ]


type Msg
    = Input String
    | Add
    | Checked Int
    | Delete Int
    | Edit Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        Input todoItem ->
            { model | content = todoItem }

        Add ->
            if model.content == "" then
                model

            else
                -- { model | todos = model.todos ++ [ ( model.content, False ) ] }
                { model | todos = model.todos ++ [ { todoContent = model.content, isCompleted = False, isEdited = False } ] }

        Checked checkedIdx ->
            let
                checkedItem =
                    Array.get checkedIdx (Array.fromList model.todos)
            in
            case checkedItem of
                Nothing ->
                    model

                Just checkedTodo ->
                    { model | todos = setAt checkedIdx { checkedTodo | isCompleted = not checkedTodo.isCompleted } model.todos }

        Delete deletedIdx ->
            let
                newTodo =
                    removeAt deletedIdx model.todos
            in
            { model | todos = newTodo }

        Edit editIdx ->
            let
                editedItem =
                    Array.get editIdx (Array.fromList model.todos)
            in
            case editedItem of
                Nothing ->
                    model

                Just editedTodo ->
                    { model | todos = setAt editIdx { editedTodo | isEdited = not editedTodo.isEdited } model.todos }
