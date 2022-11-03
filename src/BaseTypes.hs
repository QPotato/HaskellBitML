{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# OPTIONS_GHC -Wno-identities #-}
{-# OPTIONS_GHC -Wno-missing-export-lists #-}

module BaseTypes where

newtype Participant = Part String deriving Show
newtype Label = Label String deriving Show
newtype Sats = Sats Integer deriving (Show, Num, Enum, Eq, Ord, Real, Integral)
newtype Secret = Secret Integer deriving Show