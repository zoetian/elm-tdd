module Test.Generated.Main45100003 exposing (main)

import Example

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "Example" [Example.suite] ]
        |> Test.concat
        |> Test.Runner.Node.run { runs = Nothing, report = JsonReport, seed = 338994005660277, processes = 8, paths = ["/Users/pivotal/workspace/todo/tests/Example.elm"]}