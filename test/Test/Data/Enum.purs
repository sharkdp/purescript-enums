module Test.Data.Enum (testEnum) where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)

import Data.Enum (class Enum, class BoundedEnum, defaultToEnum, defaultFromEnum,
                  defaultCardinality, enumFromTo, enumFromThenTo, upFrom,
                  downFrom)
import Data.Maybe (Maybe(..))

import Test.Assert (ASSERT, assert)

data T = A | B | C | D | E

derive instance eqT  :: Eq  T
derive instance ordT :: Ord T

instance enumT :: Enum T where
  succ A = Just B
  succ B = Just C
  succ C = Just D
  succ D = Just E
  succ E = Nothing

  pred A = Nothing
  pred B = Just A
  pred C = Just B
  pred D = Just C
  pred E = Just D

instance boundedT :: Bounded T where
  bottom = A
  top = E

instance boundedEnumT :: BoundedEnum T where
  cardinality = defaultCardinality
  toEnum = defaultToEnum
  fromEnum = defaultFromEnum

testEnum :: Eff (console :: CONSOLE, assert :: ASSERT) Unit
testEnum = do
  log "enumFromTo"
  assert $ enumFromTo A A == [A]
  assert $ enumFromTo B A == []
  assert $ enumFromTo A C == [A, B, C]
  assert $ enumFromTo A E == [A, B, C, D, E]

  log "enumFromThenTo"
  assert $ enumFromThenTo A B E == [A, B, C, D, E]
  assert $ enumFromThenTo A C E == [A,    C,    E]
  assert $ enumFromThenTo A E E == [A,          E]
  assert $ enumFromThenTo A C C == [A,    C      ]
  assert $ enumFromThenTo A C D == [A,    C      ]

  log "upFrom"
  assert $ upFrom B == [C, D, E]
  assert $ upFrom D == [      E]
  assert $ upFrom E == [       ]

  log "downFrom"
  assert $ downFrom D == [C, B, A]
  assert $ downFrom B == [      A]
  assert $ downFrom A == [       ]
