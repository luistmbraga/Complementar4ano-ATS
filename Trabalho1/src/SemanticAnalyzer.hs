module SemanticAnalyzer where

import Parser
import ASTandPP
import LangParser

isDecl (Decl _) = True
isDecl _ = False

isUse (Use _) = True
isUse _ = False

isBlock (Block _) = True
isBlock _ = False

(<||>) :: (a -> Bool) -> (a -> Bool) -> a -> Bool
(p <||> q) inp = (p inp) || (q inp)

-- Verifica de existe um Decl de um determinado Use
-- Exemplo: 
-- declOfUse (Use "w") [Decl "w", Decl "q"] 
-- True
-- declOfUse (Use "d") [Decl "w", Decl "q"] 
-- False
declOfUse :: It -> [It] -> Bool
declOfUse (Use a) b = elem (Decl a) b

-- Verifica os erros de uma nível
-- 1 Argumento: lista de declarações herdadas
-- 2 Argumento: lista do que já foi processado
-- 3 Argumento: lista do que falta processar
-- 
-- Classificação dos erros:
-- 1 condicional: se for "Use" e não for declarado no que vai ser 
--                processado ou no que foi processado ou nas declaracoes herdadas <- é um erro **
-- 2 condicional: se for uma declaracao e existir uma declarcao dela no futuro <- é um erro
-- 3 condicional: caso contrário está correto
-- ** por análise do enunciado não se considera erro se existir no passado
levelerrors :: Its -> Its -> Its -> Its
levelerrors _ _ []      = []
levelerrors pe t (x:xs) | isUse x && not (declOfUse x xs || declOfUse x t || declOfUse x pe)  = x : levelerrors pe (t ++ [x]) xs 
                        | isDecl x && (elem x xs)                                             = x : levelerrors pe (t ++ [x]) xs 
                        | otherwise                                                           = levelerrors pe (t ++ [x]) xs

-- Funcao que detecta os erros gerais
-- Aplica a "levelerrors" a um nivel e aplica o mesmo aos blocks
-- "leva" consigo a lista de declaracoes do nível presente para os próximos
-- Aplica a "levelerrors" só a objectos do tipo "Use" e "Decl"
errors :: Its -> Its -> Its
errors pdecl its = levelerrors pdecl [] f ++ concat( map ( error . (\ (Block a) -> a) )  h)
              where f     = filter (isDecl <||> isUse )  its           -- filtra objectos do tipo "Decl" e "Use"
                    error = errors ((filter isDecl its) ++ pdecl ) 
                    h     = filter isBlock its                         -- filtra objectos do tipo Block

-- Funcao criada a partir da necessidade de cobrir o caso em que é gerada uma lista vazia,
-- pois a função head do Prelude dá exception
head' :: [(P,String)] -> (P,String)
head' [] = (R [], "")
head' (x:xs) = x

-- Funcao principal
-- 1 Realiza o Parse da linguagem
-- 2 Retira o primeiro elemento que consumiu todo o input (fez parse correctamente)
-- 3 Analisa os erros semanticos
semanticAnalyzer = errors [] . (\ (R a) -> a) . fst . head' . filter ( (==) "" . snd) . pP
