module ToDoSpec (main, spec) where 

import Test.Hspec
import ToDo 

main :: IO ()

main = hspec spec

spec :: Spec
spec =  do
    describe "Tag" $ do
        it "can create a Tag from a string" $
            (show (Context "Foo")) `shouldBe` "Context {name = \"Foo\"}"

    describe "TodoEntry" $ do
        it "can create a TodoEntry from a string" $
            (TodoEntry "this is a line #CURRENT @MORNING") `shouldBe` (TodoEntry "this is a line #CURRENT @MORNING") 
