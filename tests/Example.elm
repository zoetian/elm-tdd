module Example exposing (suite)

import Expect
import Main
import Test exposing (..)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector exposing (id, tag, text)


suite : Test
suite =
    describe "Todo app"
        [ test "has a text input" <|
            \_ ->
                Main.init
                    |> Main.view
                    |> Query.fromHtml
                    |> Query.find [ id "todo-input" ]
                    |> Query.has [ tag "input" ]
        , test "has an \"add\" button" <|
            \_ ->
                Main.init
                    |> Main.view
                    |> Query.fromHtml
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
        , test "button has a click handler" <|
            \_ ->
                Main.init
                    |> Main.view
                    |> Query.fromHtml
                    |> Query.find [ id "add-button" ]
                    |> Event.simulate Event.click
                    |> Event.expect Main.Click
        , test "typing in input then click on button creates a list item" <|
            \_ ->
                Main.init
                    |> Main.update (Main.Input "foo")
                    |> Main.update Main.Click
                    |> Main.view
                    |> Query.fromHtml
                    |> Query.find [ id "todo-list" ]
                    |> Query.has [ tag "li", text "foo" ]
        , test "list item contains the thing you typed" <|
            \_ ->
                Main.init
                    |> Main.update (Main.Input "bar")
                    |> Main.update Main.Click
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
                    |> Main.update Main.Click
                    |> Main.update (Main.Input "bbb")
                    |> Main.update Main.Click
                    |> Main.view
                    |> Query.fromHtml
                    |> Query.findAll [ tag "li" ]
                    |> Query.count (Expect.equal 2)
        , test "can add multiple todo items with the same input order" <|
            \_ ->
                Main.init
                    |> Main.update (Main.Input "aaa")
                    |> Main.update Main.Click
                    |> Main.update (Main.Input "bbb")
                    |> Main.update Main.Click
                    |> Main.view
                    |> Query.fromHtml
                    |> Query.findAll [ tag "li" ]
                    |> Query.first
                    |> Query.has [ text "aaa" ]
        , test "disable add button when there's no input" <|
            \_ ->
                Main.init
                    |> Main.update (Main.Input "")
                    |> Main.update Main.Click
                    |> Main.view
                    |> Query.fromHtml
                    |> Query.findAll [ tag "li" ]
                    |> Query.count (Expect.equal 0)
        ]
