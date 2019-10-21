module Main (main) where

import Codec.Picture
import Codec.Picture.Types (pixelMapXY)
import qualified Data.ByteString as BS
import Options.Applicative
import System.Environment (getArgs)

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

moire :: Int -> Int -> PixelRGBA8 -> PixelRGBA8
moire x y px =
  if (x `mod` 4 == 0) && (y `mod` 4 == 0)
  then PixelRGBA8 0 0 0 255
  else px

main :: IO ()
main = do
  args <- getArgs
  if null args then do
    input <- BS.getContents
    unless (BS.null input) (
      case decodeImage input of
        Left err -> die err
        Right dynamicImage ->
          dynamicImage
            & convertRGBA8
            & pixelMapXY moire
            & encodePng
            & putLBSLn)
  else do
    let opts = info (helper <*> options) (header "moire" <> fullDesc)
    Options { inputPath, outputPath } <- execParser opts
    readImage inputPath >>= \case
      Left err -> die err
      Right dynamicImage ->
        dynamicImage
          & convertRGBA8
          & pixelMapXY moire
          & ImageRGBA8
          & savePngImage outputPath
