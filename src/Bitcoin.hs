{-# OPTIONS_GHC -Wno-missing-export-lists #-}
module Bitcoin where 
import BaseTypes (Sats)

data TransactionInput =
    InputReference Transaction Int
    | Coinbase Sats

data Transaction = Transaction {
    input :: [TransactionInput]
    , output :: [Sats]
    , witness :: [String]
    , absLock :: Integer
}

newtype Blockchain = Blockchain [(Transaction, Integer)]