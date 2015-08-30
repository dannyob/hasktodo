module ToDo (
Tag(MakeTag),
someFunc
        ) where


data Tag = MakeTag String deriving (Show, Eq)

someFunc :: IO ()
someFunc = putStrLn "someFunc"
