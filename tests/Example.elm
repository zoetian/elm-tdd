module Example exposing (suite)

import Expect
import Html exposing (button)
import Html.Attributes exposing (placeholder, type_)
import Main
import Test exposing (..)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, id, style, tag, text)


suite : Test
suite =
    describe "Todo app"
        [ test "all input field of text can be saved after hitting enter" <|
            \_ ->
                Main.init
                    |> Main.view
                    |> Query.fromHtml
                    |> Query.children []
                    |> Query.index 0
                    |> Query.has [ tag "form", id "todo-form" ]
        , test "has a text input inside the form" <|
            \_ ->
                Main.init
                    |> Main.view
                    |> Query.fromHtml
                    |> Query.children []
                    |> Query.index 0
                    |> Query.children []
                    |> Query.index 0
                    |> Query.has [ id "todo-input", placeholder "Add your todo here" |> attribute ]
        , test "has an \"Add\" button inside the form" <|
            \_ ->
                Main.init
                    |> Main.view
                    |> Query.fromHtml
                    |> Query.children []
                    |> Query.index 0
                    |> Query.children []
                    |> Query.index 1
                    |> Query.has [ id "add-button", tag "button", text "Add" ]
        , test "input has an input handler" <|
            \_ ->
                Main.init
                    |> Main.view
                    |> Query.fromHtml
                    |> Query.find [ id "todo-input" ]
                    |> Event.simulate (Event.input "foo")
                    |> Event.expect (Main.Input "foo")
        , test "form has a submit handler" <|
            \_ ->
                Main.init
                    |> Main.view
                    |> Query.fromHtml
                    |> Query.find [ id "todo-form" ]
                    |> Event.simulate Event.submit
                    |> Event.expect Main.Add
        , test "typing in input then click on button creates a list item" <|
            \_ ->
                Main.init
                    |> Main.update (Main.Input "foo")
                    |> Main.update Main.Add
                    |> Main.view
                    |> Query.fromHtml
                    |> Query.find [ id "todo-list" ]
                    |> Query.has [ tag "li", text "foo" ]
        , test "list item contains the thing you typed" <|
            \_ ->
                Main.init
                    |> Main.update (Main.Input "bar")
                    |> Main.update Main.Add
                    |> Main.view
                    |> Query.fromHtml
                    |> Query.find [ id "todo-list" ]
                    |> Query.has [ tag "li", text "bar" ]
        , test "initializes with no list items" <|
            \_ ->
                Main.init
                    |> Main.view
                    |> Query.fromHtml
                    |> Query.findAll [ tag "li" ]
                    |> Query.count (Expect.equal 0)
        , test "no list items before clicking" <|
            \_ ->
                Main.init
                    |> Main.update (Main.Input "new")
                    |> Main.view
                    |> Query.fromHtml
                    |> Query.findAll [ tag "li" ]
                    |> Query.count (Expect.equal 0)
        , test "can add multiple todo items" <|
            \_ ->
                Main.init
                    |> Main.update (Main.Input "aaa")
                    |> Main.update Main.Add
                    |> Main.update (Main.Input "bbb")
                    |> Main.update Main.Add
                    |> Main.view
                    |> Query.fromHtml
                    |> Query.findAll [ tag "li" ]
                    |> Query.count (Expect.equal 2)
        , test "can add multiple todo items with the same input order" <|
            \_ ->
                Main.init
                    |> Main.update (Main.Input "aaa")
                    |> Main.update Main.Add
                    |> Main.update (Main.Input "bbb")
                    |> Main.update Main.Add
                    |> Main.view
                    |> Query.fromHtml
                    |> Query.findAll [ tag "li" ]
                    |> Query.first
                    |> Query.has [ text "aaa" ]
        , test "disable add button when there's no input" <|
            \_ ->
                Main.init
                    |> Main.update (Main.Input "")
                    |> Main.update Main.Add
                    |> Main.view
                    |> Query.fromHtml
                    |> Query.findAll [ tag "li" ]
                    |> Query.count (Expect.equal 0)
        , test "after adding new list item, each has a checkbox before text" <|
            \_ ->
                Main.init
                    |> Main.update (Main.Input "aaa")
                    |> Main.update Main.Add
                    |> Main.view
                    |> Query.fromHtml
                    |> Query.find [ tag "li" ]
                    |> Query.has [ tag "input" ]
        , test "checkbox has a click handler" <|
            \_ ->
                Main.init
                    |> Main.update (Main.Input "aaa")
                    |> Main.update Main.Add
                    |> Main.view
                    |> Query.fromHtml
                    |> Query.find [ tag "input", attribute <| type_ "checkbox" ]
                    |> Event.simulate Event.click
                    |> Event.expect (Main.Checked 0)
        , test "when checkbox is unchecked, related list item will not be crossed" <|
            \_ ->
                Main.init
                    |> Main.update (Main.Input "aaa")
                    |> Main.update Main.Add
                    |> Main.view
                    |> Query.fromHtml
                    |> Query.find [ tag "li" ]
                    |> Query.hasNot [ style "text-decoration" "line-through" ]
        , test "when checkbox is checked, the checked list item will be crossed" <|
            \_ ->
                Main.init
                    |> Main.update (Main.Input "aaa")
                    |> Main.update Main.Add
                    |> Main.update (Main.Checked 0)
                    |> Main.view
                    |> Query.fromHtml
                    |> Query.find [ tag "li" ]
                    |> Query.has [ style "text-decoration" "line-through" ]
        , test "when checkbox is unchecked, the checked list item will not be crossed" <|
            \_ ->
                Main.init
                    |> Main.update (Main.Input "aaa")
                    |> Main.update Main.Add
                    |> Main.update (Main.Checked 0)
                    |> Main.update (Main.Checked 0)
                    |> Main.view
                    |> Query.fromHtml
                    |> Query.find [ tag "li" ]
                    |> Query.hasNot [ style "text-decoration" "line-through" ]
        , test "each delete button has a click handler" <|
            \_ ->
                Main.init
                    |> Main.update (Main.Input "aaa")
                    |> Main.update Main.Add
                    |> Main.view
                    |> Query.fromHtml
                    |> Query.find [ id "delete-button" ]
                    |> Event.simulate Event.click
                    |> Event.expect (Main.Delete 0)
        , test "clicked on delete button can delete the selected list item" <|
            \_ ->
                Main.init
                    |> Main.update (Main.Input "aaa")
                    |> Main.update Main.Add
                    |> Main.update (Main.Delete 0)
                    |> Main.view
                    |> Query.fromHtml
                    |> Query.hasNot [ tag "li", text "aaa" ]
        , test "each list item text has a double clicked handler" <|
            \_ ->
                Main.init
                    |> Main.update (Main.Input "aaa")
                    |> Main.update Main.Add
                    |> Main.view
                    |> Query.fromHtml
                    |> Query.find [ id "todo-list" ]
                    |> Event.simulate Event.doubleClick
                    |> Event.expect (Main.Edit 0)
        , test "double clicked on the selected list item will have an input field" <|
            \_ ->
                Main.init
                    |> Main.update (Main.Input "aaa")
                    |> Main.update Main.Add
                    |> Main.update (Main.Edit 0)
                    |> Main.view
                    |> Query.fromHtml
                    |> Query.find [ id "todo-list" ]
                    |> Query.has [ tag "input", type_ "text" |> attribute ]

        --        , test "double clicked on the selected list item can edit the text" <|
        --            \_ ->
        --                Main.init
        --                    |> Main.update (Main.Input "aaa")
        --                    |> Main.update Main.Add
        --                    |> Main.update (Main.Edit 0)
        --                    |> Main.update (Main.Input "bbb")
        --                    |> Main.view
        --                    |> Query.fromHtml
        --                    |> Query.has [ tag "li", text "bbb" ]
        --
        --
        --                    |> Event.simulate (Event.input "bbb")
        --                    |> Event.expect (Main.Input "bbb")
        ]
