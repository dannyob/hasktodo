module ToDoSpec (main, spec) where 

import Test.Hspec
import ToDo 

main :: IO ()

main = hspec spec

spec :: Spec
spec =  do
    describe "Tag" $ do
        it "can create a Tag from a string" $
            (show (MakeTag "Foo")) `shouldBe` "MakeTag \"Foo\""

