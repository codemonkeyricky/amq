{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric  #-}

module Common where

import           Data.Aeson   (FromJSON, ToJSON, decode, encode)
import           GHC.Generics

data Event = Event
  { id     :: Integer
  , event  :: String
  , action :: String
  } deriving (Show, Eq, Generic, ToJSON, FromJSON)
