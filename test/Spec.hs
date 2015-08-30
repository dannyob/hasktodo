module Main (main) where 

import Test.Hspec
import ToDo 
import System.Exit (exitFailure)

main :: IO ()

main = hspec $ do
    describe "Tag" $ do
        it "can create a Tag from a string" $
            MakeTag "Foo" `shouldBe` (MakeTag "Foo")

