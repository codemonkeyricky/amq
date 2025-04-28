{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric  #-}

module Common where

import           Data.Aeson           (FromJSON, ToJSON, decode, encode)
import qualified Data.ByteString.Lazy as DBL
import qualified Data.ByteString.UTF8 as UTF8
import           GHC.Generics

data Event = Event
  { uid    :: Integer
  , event  :: String
  , action :: String
  } deriving (Show, Eq, Generic, ToJSON, FromJSON)

serialize :: Event -> UTF8.ByteString
serialize = UTF8.fromString . show . encode
