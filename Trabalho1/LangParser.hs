module LangParser where

import Prelude hiding ((<*>),(<$>))
import ASTandPP
import Parser

pP :: Parser Char P
pP = R <$> pIts -- primeiro elemento cujo second é ""

pIts :: Parser Char Its
pIts =  enclosedBy (symbol' '[') (separatedBy pIt (symbol' ',')) (symbol' ']')
                   
pIt :: Parser Char It
pIt =   f <$> token' "Decl" <*> ident
   <|>  g <$> token' "Use" <*> ident
   <|>  Block <$> pIts
   where f a b = Decl b
         g a b = Use b
           