{-# OPTIONS_GHC -Wno-missing-export-lists #-}
module Examples where

import BaseTypes ( Sats, Label(Label), Participant(Part) )
import Contracts
    ( ContractAdvertisement(..),
      Contract,
      (??),
      (!!),
      (||),
      put,
      withdraw,
      split,
      (##),
      after,
      (++) )
import Prelude hiding ((!!), (++), (||))


payOrRefund :: Sats -> ContractAdvertisement
payOrRefund payment = ContractAdvertisement
    { preconditions = Part "A" !! payment $ Label "x0"
    , contract = Part "A" ## withdraw (Part "B") ++ Part "B" ## withdraw (Part "A")
    }
resolve :: Sats -> Sats -> Contract
resolve fee payment = split
        [ (fee, withdraw (Part "M"))
        , (payment, Part "M" ## withdraw (Part "B") ++ Part "M" ## withdraw (Part "A"))
        ]

escrow :: Sats -> Sats -> ContractAdvertisement
escrow fee payment = ContractAdvertisement
    { preconditions = preconditions (payOrRefund payment)
    , contract =
        contract (payOrRefund payment) ++ resolve fee (payment - fee)
    }

escrowPut :: Sats -> Sats -> Integer -> Integer -> ContractAdvertisement
escrowPut fee payment t1 t2 = ContractAdvertisement
    { preconditions =
        preconditions (payOrRefund payment)
        || (Part "A" ?? (fee `div` 2) $ Label "x")
        || (Part "B" ?? (fee - fee `div` 2) $ Label "y")
    , contract =
        contract (payOrRefund payment)
        ++  after t1 (withdraw (Part "B"))
        ++  put [Label "x"] (
            after t2 (withdraw (Part "B"))
            ++ put [Label "y"] (resolve fee payment)
        )
    }
