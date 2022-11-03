{-# OPTIONS_GHC -Wno-missing-export-lists #-}
{-# OPTIONS_GHC -Wno-identities #-}
{-# LANGUAGE GADTs #-}
module Contracts where

import Prelude hiding ((!!), (++), (||))

import BaseTypes

data ContractPreconditions where
  PersistentDeposit :: Participant
                       -> Sats
                       -> Label
                       -> ContractPreconditions
  VolatileDeposit :: Participant
                     -> Sats
                     -> Label
                     -> ContractPreconditions
  PreconditionSecret :: Secret -> ContractPreconditions
  Cons :: ContractPreconditions
          -> ContractPreconditions
          -> ContractPreconditions
    deriving Show

data Contract where
  PutAndReveal :: [Label] -> [Secret] -> Bool -> Contract -> Contract
  Withdraw :: Participant -> Contract
  Split :: [(Sats, Contract)] -> Contract
  Auth :: Participant -> Contract -> Contract
  After :: Integer -> Contract -> Contract
  Sum :: Contract -> Contract -> Contract
    deriving Show

data ContractAdvertisement = ContractAdvertisement {
    preconditions :: ContractPreconditions
    , contract :: Contract
} deriving Show

(??) :: Participant -> Sats -> Label -> ContractPreconditions
(a ?? v) x = VolatileDeposit a v x

(!!) :: Participant -> Sats -> Label -> ContractPreconditions
(a !! v) x = PersistentDeposit a v x

(||) :: ContractPreconditions -> ContractPreconditions -> ContractPreconditions
(||) = Cons

secret :: Secret -> ContractPreconditions
secret = PreconditionSecret

put :: [Label] -> Contract -> Contract
put deposits = PutAndReveal deposits [] True

reveal :: [Secret] -> Contract -> Contract
reveal secrets = PutAndReveal [] secrets True

putAndReveal :: [Label] -> [Secret] -> Bool -> Contract -> Contract
putAndReveal = PutAndReveal

withdraw :: Participant -> Contract
withdraw = Withdraw

split :: [(Sats, Contract)] -> Contract
split = Split

infixl 3 ##
(##) :: Participant -> Contract -> Contract
(##) = Auth

after :: Integer -> Contract -> Contract
after = After

infixl 2 ++
(++) :: Contract -> Contract -> Contract
d ++ c = Sum d c