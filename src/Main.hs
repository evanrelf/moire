module Main (main) where

import Options.Applicative

data Options = Options
  { input :: FilePath
  , output :: FilePath
  } deriving (Show)

options :: Parser Options
options = Options
  <$> strOption (mconcat
        [ long "input"
        , short 'i'
        , metavar "PATH"
        , help "Input path"
        ])
  <*> strOption (mconcat
        [ long "output"
        , short 'o'
        , metavar "PATH"
        , help "Output path"
        ])

moire :: Options -> IO ()
moire = print

main :: IO ()
main = execParser opts >>= moire
  where opts = info (helper <*> options) (header "moire" <> fullDesc)
