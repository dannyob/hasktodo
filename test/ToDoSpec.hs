{-# LANGUAGE OverloadedStrings #-}
module ToDoSpec (main, spec) where 

import Test.Hspec
import ToDo


import Data.List (find)

main :: IO ()

main = hspec spec

sampleTodoLine = "    go buy a snark gun"
sampleTodoLineWithTags :: String
sampleTodoLineWithTags = "    go buy a snark gun @SHOPPING #SAFARI" 

spec :: Spec
spec =  do
    describe "Tag" $ 
        it "can create a Tag from a string" $
            show (Project "Foo") `shouldBe` "Project {pName = \"Foo\"}"

    describe "TodoEntry" $ do
        it "can create a TodoEntry from a string and preserve its contents" $
            parseLine "this is a line #CURRENT @MORNING" `shouldBe` parseLine "this is a line #CURRENT @MORNING" 

        it "can spot a Current tag" $
            Data.List.find (== Current) (tags $ parseLine "this is a @CURRENT line") `shouldBe` Just Current
            
        it "can spot no Current tag" $
            (Data.List.find (== Current) $ tags $ parseLine "this is a line") `shouldBe` Nothing
            
        it "can spot an Urgent tag" $
            (Data.List.find (== Urgent) $ tags $ parseLine "this is a @URGENT line") `shouldBe` Just Urgent