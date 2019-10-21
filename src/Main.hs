module Main (main) where

import Codec.Picture
import Options.Applicative

data Options = Options
  { inputPath :: FilePath
  , outputPath :: FilePath
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

moire :: Image pixel -> Image pixel
moire = identity -- TODO

main :: IO ()
main = do
  let opts = info (helper <*> options) (header "moire" <> fullDesc)
  Options { inputPath, outputPath } <- execParser opts
  readImage inputPath >>= \case
    Left err -> die err
    Right inputImage -> do
      let outputImage = dynamicPixelMap moire inputImage
      savePngImage outputPath outputImage
