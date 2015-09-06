{-# LANGUAGE OverloadedStrings #-}
module ToDoSpec (main, spec) where 

import Test.Hspec
import ToDo
import Data.Text
import Data.String

main :: IO ()

main = hspec spec

sampleTodoLine = "    go buy a snark gun"
sampleTodoLineWithTags = "    go buy a snark gun @SHOPPING #SAFARI" 

spec :: Spec
spec =  do
    describe "Tag" $ do
        it "can create a Tag from a string" $
            (show (Project "Foo")) `shouldBe` "Project {pName = \"Foo\"}"

    describe "TodoEntry" $ do
        it "can create a TodoEntry from a string and preserve its contents" $
            (parseLine "this is a line #CURRENT @MORNING") `shouldBe` (parseLine "this is a line #CURRENT @MORNING") 

        it "can create a TodoEntry with the "
