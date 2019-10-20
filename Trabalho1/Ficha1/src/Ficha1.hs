module Ficha1 where

import Prelude hiding ((<*>),(<$>))

import Data.Char
import Parser

-- Exercícios

{-
    Exercício 1.1) Define combinadores de parsing para expressar os símbolos terminais number
        e ident.
-}

data Exp = AddExp Exp Exp
         | MulExp Exp Exp
         | SubExp Exp Exp
         | GThen Exp Exp
         | LThen Exp Exp
         | OneExp Exp
         | Var String
         | Const Int

instance Show Exp where
  show = showExp

showExp (AddExp e1 e2) = showExp e1 ++ " + " ++ showExp e2
showExp (SubExp e1 e2) = showExp e1 ++ " - " ++ showExp e2
showExp (MulExp e1 e2) = showExp e1 ++ " * " ++ showExp e2
showExp (GThen e1 e2)  = showExp e1 ++ " > " ++ showExp e2
showExp (OneExp e)     = "( " ++ showExp e ++ " )"
showExp (Const i)      = show i
showExp (Var a)        = a 

--R:

number  =   f <$> satisfy isDigit
       <|>  g <$> satisfy isDigit <*> number
  where f a = [a]
        g a b = a:b

ident =  oneOrMore (satisfy isAlpha)

{- 
    Exercício 1.2) Utilizando o tipo de dados Exp defina a expressão artimética "e=(var+3)*5".
-}

e :: Exp
e = MulExp (OneExp (AddExp (Var "var") (Const 3))) (Const 5)

{-
    Exercício 1.3) Escreva o parser baseado em combinadores que reconhece a notação de
        expressões aritméticas produzida pela função de pretty printing anterior e devolve a árvore
        de syntaxe abstrata com tipo Exp.
-}

--R:
pexp :: Parser Char Exp
pexp =   f <$> pterm
     <|> g <$> pterm <*> symbol' '+' <*> pexp
     <|> h <$> pterm <*> symbol' '-' <*> pexp
   where f a = a
         g a b c = AddExp a c
         h a b c = SubExp a c

pterm :: Parser Char Exp
pterm =  f <$> pfactor
     <|> g <$> pfactor <*> symbol' '*' <*> pterm
   where f a = a
         g a b c = MulExp a c

pfactor :: Parser Char Exp
pfactor =   f <$> number
       <|>  g <$> ident
       <|>  h <$> symbol' '(' <*> pexp <*> symbol' ')'
  where f a = Const (read a)
        g a = Var a
        h a e f = OneExp e

{-
    Exercício 1.4) Considere a seguinte expressão artimética:
    e1 = "2 * 4 - 34"

    Verfique que o parser desenvolvido não processa este input. Atualize a gramática de modo
    a considerar a existência de espaços a separar símbolos das expressões. Sugestão: defina
    um parser spaces, que define a linguage de zero, um ou mais espaços. Defina ainda
    uma parser symbol’ que processa o símbolo dado e depois consome (ignorando) eventuais
    espaços que apareçam a seguir.
-}

symbol' a = (\ a b c -> b) <$> spaces <*> symbol a <*> spaces 

{-
  Exercício 1.5) O parser spaces descreve uma construção sintatica muito frequente em
    parsing: zero, uma ou mais vezes (o operador * das expressões regulares). Adicione à
    biblioteca Parser.hs o combinador

    zeroOrMore :: Parser s r -> Parser s [r]

    que aplica um dado parser zero uma ou mais vezes e que devolve uma lista com os
    resultados das várias aplicações do parser.
-}

zeroOrMore :: Parser s r -> Parser s [r] 
zeroOrMore p = sf <$> p <*> zeroOrMore p
             <|> succeed []
  where sf x xs = x : xs

{-
  Exercício 1.6) Defina o parser spaces em termos de zeroOrMore.
-}

spaces = zeroOrMore
          (satisfy (\x -> x `elem` [' ','\t','\n']))

{-
  Exercício 1.7) Defina (em Parser.hs) o parser oneOrMore em termos de zeroOrMore.
    Sugestão: Recorde que a+ ≡ aa∗.

    Considere que definiu a seguinte linguagem de programação que é constituída por uma
    sequência de statements e em que um statement pode ser um cilo while, um condicional if
    ou uma atributição. Esta linguagem é definida pelo seguinte tipo de dados abstrato:
-}

data Prog = Prog Stats
type Id = String
data Stats = Stats [Stat]

data Stat = While Exp Stats
          | IfThenElse Exp Stats Stats
          | Assign Id Exp

--Considere ainda que foi escrita a seguinte função de pretty printing:

instance Show Prog where
  show = showProg

showProg (Prog sts) = showStats sts
  
instance Show Stats where
  show = showStats

showStats (Stats l) = showStatsList l

showStatsList :: [Stat] -> [Char]
showStatsList [] = ""
showStatsList (st:[]) = showStat st 
showStatsList (st:sts) = showStat st ++ ";\n " ++ (showStatsList sts)

instance Show Stat where
  show = showStat

showStat :: Stat -> [Char]
showStat (Assign n e) = n ++ " = " ++ showExp e
showStat (While e sts) = "while (" ++ showExp e ++ ")\n " ++ "{ " ++ showStats sts ++ "}"
showStat (IfThenElse e s s1) = "if (" ++ showExp e ++ ")\nthen{" ++ showStats s ++ "}\nelse{" ++ showStats s1 ++ "}\n"

oneOrMore p =  sf1 <$> p <*> zeroOrMore p 
  where sf1 x xs = x : xs

{-
  Exercício 1.8) Escreva o parser baseado em combinadores para esta linguagem cuja notação
      é definida pela função showProg.
-}

-- R:

pProg :: Parser Char Prog
pProg = Prog <$> pStats


-- Funcoes antes da resolucao de 1.10
{--
pStats :: Parser Char Stats
pStats =  f <$> token ""
      <|> g <$> pStat
      <|> h <$> pStat <*> token ";\n" <*> pStats
      where f a = Stats []
            g a = Stats [a]
            h a b c = Stats (a: (i c))
            i = (\ (Stats b) -> b)

pStat :: Parser Char Stat
pStat =   h <$> token  "while (" <*> pexp <*> symbol' ')' <*> symbol' '{' <*> pStats <*> symbol' '}'
      <|> g <$> token "if (" <*> pexp <*> token ")\nthen{" <*> pStats <*> token "}\nelse{" <*> pStats <*> token "}\n"
      <|> f <$> ident <*> symbol' '=' <*> pexp
      where g a b c d e f g = IfThenElse b d f
            f a b c = Assign a c
            h a b c d e f = While b e

--}

{-
  Exercício 1.9) No desenvolvimento do parser pProg foram utilizadas construções sintáticas
    muito frequentes em linguagem de programação: separatedBy (lista de elementos sepa-
    rados por um dado separador, neste exemplo ponto e virgula), enclosedBy (elementos
    delimitados por um símbolo inicial e final, neste exemplo parentesis curvos). Defina em
    Parser.hs estes combinadores que descartam o resultado de fazer parsing aos separado-
    res/delimitadores.  


separatedBy :: Parser s a -> Parser s b -> Parser s [a]
separatedBy p s =  f <$>  p <*> s <*> (separatedBy p s)
               <|> g <$>  p
              where f a b c = a : c
                    g a     = [a]
-}
separatedBy :: Parser s a -> Parser s b -> Parser s [a]
separatedBy d s =  f <$> d
                <|> g <$> d <*> s <*> separatedBy d s 
              where f a = [a] 
                    g a b c = a:c                    

enclosedBy :: Parser s a -> Parser s b -> Parser s c -> Parser s b
enclosedBy p1 p2 p3 =  g <$> p1 <*> p2 <*> p3
                  where g a b c = b
                        

{-
  Exercício 1.10) Re-escreva pProg utilizando separatedBy e enclosedBy
-}

token' a = (\ a b c -> b) <$> spaces <*> token a <*> spaces

pStats :: Parser Char Stats
pStats = Stats <$> separatedBy pStat (symbol' ';')

pStat :: Parser Char Stat
pStat =  f <$> token' "while" <*> (enclosedBy (symbol' '(') pexp (symbol' ')'))
                              <*> (enclosedBy (symbol' '{') pStats (symbol' '}'))
     <|> g <$> token' "if"    <*> (enclosedBy (symbol' '(') pexp (symbol' ')'))
                              <*> token' "then" <*> (enclosedBy (symbol' '{') pStats (symbol' '}'))
                              <*> token' "else" <*> (enclosedBy (symbol' '{') pStats (symbol' '}'))
     <|> h <$> ident <*> symbol' '=' <*> pexp
    where f w c b = While c b 
          g a b c d e f = IfThenElse b d f
          h a b c = Assign a c

{-
  Exercício 1.11) Adicione à biblioteca Parser.hs mais construções sintáticas frequentes
    em longuagens de programação, nomeadamente:
-}

followedBy :: Parser s a -> Parser s b -> Parser s [a]
followedBy d s =  f <$> d <*> s
              <|> g <$> d <*> s <*> followedBy d s 
            where f a b = [a] 
                  g a b c = a:c

{-
block :: Parser s a -- open delimiter
-> Parser s b -- syntactic symbol that follows statements
-> Parser s r -- parser of statements
-> Parser s f -- close delimiter
-> Parser s [r]
-}

block :: Parser s a -> Parser s b -> Parser s r -> Parser s f -> Parser s [r]
block od ss ps cd = enclosedBy od (followedBy ps ss) cd
                            