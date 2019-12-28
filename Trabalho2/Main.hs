module Main where
     --stack ghci --package QuickCheck -- .\Main.hs
import Test.QuickCheck
import Data.Char 
import Nomes 
import Localidades
import System.IO
import System.Directory

--NovoProp: nome, nif, email,morada   287
--NovoProp:Laurindo,558192493,611843917@gmail.com,Miranda do Douro

data NovoProp = NovoProp Nome NIF Email Localidade

instance Show NovoProp where
     show = pp_NovoProp

pp_NovoProp (NovoProp n nif e l) = "NovoProp:" ++ n ++ "," ++ nif ++ "," ++ e ++ "," ++ l

genNovoProp :: Gen NovoProp 
genNovoProp = do nome <- genNomeP 
                 nif  <- genNifP 
                 mail <- genEmailP 
                 loc  <- genLocalidadeP 
                 return (NovoProp nome nif mail loc)

genNomeP :: Gen Nome 
genNomeP = elements Nomes.listaNomes 

genNifP :: Gen NIF 
genNifP =  vectorOf 9 $ elements ['1'..'9']

genEmailP :: Gen Email 
genEmailP = do nome <- elements Nomes.listaNomes   
               esp  <- frequency  [(1, return "_"),(2,return "."),(15,return "")]
               num  <- frequency [(30, vectorOf 2 $ elements ['1'..'9']), (30, vectorOf 1 $ elements ['1'..'9']),(40, return "")]
               mail <- frequency [(60, return "@gmail.com"),(20,return "@hotmail.com"),(10,return "@yahoo.com"),(5,return "@outlook.com"),(5,return "@sapo.pt")] 
               return (nome ++ esp ++ num ++ mail)       

genLocalidadeP :: Gen Localidade 
genLocalidadeP = elements Localidades.lista_localidades

--NovoCliente:nome,nif,email,morada,X,Y  308
     -- X e Y : posicçao onde se encontra
--NovoCliente:Rodrigo Tiago Oliveira Ferreira,176743524,176743524@gmail.com,Carregal do Sal,33.99243,77.844696

data NovoCliente = NovoCliente Nome NIF Email Localidade Coordenadas

instance Show NovoCliente where
     show = pp_NovoCliente

pp_NovoCliente (NovoCliente n nif e l c) = "NovoCliente:" ++ n ++ "," ++ nif ++ "," ++ e ++ "," ++ l ++ "," ++ show (fst c) ++ "," ++ show (snd c)

type Nome = String 
type NIF = String
type Email = String 
type Localidade = String   
type Coordenadas = (Float,Float)

genNovoCliente :: Gen NovoCliente 
genNovoCliente = do nome  <- genNomeC 
                    nif   <- genNifC 
                    email <- genEmailC 
                    local <- genLocalidadeC 
                    coor  <- genCoordenadas
                    return (NovoCliente nome nif email local coor)

genNomeC :: Gen Nome 
genNomeC = do p_nome <- elements Nomes.listaNomes  
              s_nome <- elements Nomes.listaNomes 
              p_apel <- elements Nomes.listaApelidos 
              s_apel <- elements Nomes.listaApelidos 
              return (p_nome ++ " " ++ s_nome ++ " " ++ p_apel ++ " " ++ s_apel) 

genNifC :: Gen NIF 
genNifC = vectorOf 9 $ elements ['1'..'9']

genEmailC :: Gen Email 
genEmailC = do nome <- elements Nomes.listaNomes   
               esp  <- frequency  [(1, return "_"),(2,return "."),(15,return "")]
               num  <- frequency [(30, vectorOf 2 $ elements ['1'..'9']), (30, vectorOf 1 $ elements ['1'..'9']),(40, return "")]
               mail <- frequency [(60, return "@gmail.com"),(20,return "@hotmail.com"),(10,return "@yahoo.com"),(5,return "@outlook.com"),(5,return "@sapo.pt")] 
               return (nome ++ esp ++ num ++ mail) 


genLocalidadeC :: Gen Localidade 
genLocalidadeC = elements Localidades.lista_localidades 

genCoordenadas :: Gen Coordenadas 
genCoordenadas = do x <- choose (36.96583::Float,42.152946) 
                    y <- choose (-6.932739::Float,-9.500497) 
                    return (x,y)

--NovoCarro:tipo,marca,matricula,nif,velocidade media,preço por km, consumo por km, autonomia, X, Y     2000
     -- X e Y : posicçao onde se encontra
--NovoCarro:Hibrido,Alfa Romeu,SC-46-99,591799212,49,1.2358807,1.1895249,951,-45.61733,-94.458176

data NovoCarro = NovoCarro TipoCombustivel Marca Matricula NIF Velocidade Preco_Km CONS_Km Autonomia Coordenadas

instance Show NovoCarro where
     show = pp_NovoCarro

pp_NovoCarro (NovoCarro tc m mtr nif v p c au co ) = "NovoCarro:" ++ tc ++ "," ++ m ++ "," ++ mtr ++ ","
                                                    ++ nif ++ "," ++ show v ++ "," ++ show p ++ "," ++ show c ++ ","
                                                    ++ show au ++ "," ++ show (fst co) ++ "," ++ show (snd co)

type TipoCombustivel = String
type Marca = String  
type Matricula = String
type Velocidade = Int  
type Preco_Km = Float 
type CONS_Km = Float  
type Autonomia = Int  

genNovoCarro :: [NIF] -> Gen NovoCarro 
genNovoCarro nifs = do comb <- genTipoCombustivel  
                       marc <- genMarcas 
                       matr <- genMatriculas 
                       nif  <- elements nifs 
                       vel  <- genVelocidade 
                       p_km <- genPrecoKM 
                       c_km <- genConsumoKM 
                       aut  <- genAutonomia 
                       coor <- genCoordenadas
                       return (NovoCarro comb marc matr nif vel p_km c_km aut coor)

genTipoCombustivel :: Gen TipoCombustivel
genTipoCombustivel = frequency [(95, return "Gasolina"),(3, return "Hibrido"), (2, return "Electrico")] 

genMarcas :: Gen Marca 
genMarcas = frequency [(81, return "Abarth"),(12, return "Aixam"),(370, return "Alfa Romeu"),(2, return "Alpine"),(20, return "Aston Martin"),(2487,return "Audi"),
                       (1, return "Austin Healey"),(2, return "Austin Morris"),(2, return "Bellier"),(29, return "Bentley"),(5072, return "BMW"),(10, return "Cadillac"),
                       (4, return "Chatenet"),(168,return "Chevrolet"),(42,return "Chrysler"),(1747,return "Citroen"),(150,return "Dacia"),(10,return "Daewoo"),(5, return "Daihatsu"),
                       (6, return "Datsun"),(37, return "Dodge"),(116,return "DS"),(59,return "Ferrari"),(1946,return "Fiat"),(2,return "Fisker"),(1663,return "Ford"), 
                       (318,return "Honda"),(13,return "Hummer"),(398,return "Hyundai"),(7,return "Infiniti"),(5,return "Isuzu"),(262,return "Jaguar"),(181,return "Jeep"),
                       (324,return "Kia"),(11,return "Lamborghini"),(60,return "Lancia"),(328,return "Land Rover"),(148, return "Lexus"),(2,return "Ligier"),(7,return "Lotus"),
                       (40,return "Maserati"),(2,return "Maybach"),(388,return "Mazda"),(2,return "McLaren"),(4847,return "Mercedes-Benz"),(19,return "MG"),(5,return "Microcar"),
                       (1092,return "MINI"),(385,return "Mitsubishi"),(3,return "Morgan"),(1372,return "Nissan"),(2069,return "Opel"),(3550,return "Peugeot"),(3,return "Pontiac"),
                       (654,return "Porsche"),(4834,return "Renault"),(3,return "Rolls Royce"),(16,return "Rover"),(26,return "Saab"),(1848,return "Seat"),(470,return "Skoda"),
                       (693,return "Smart"),(4,return "SsangYong"),(21,return "Subaru"),(83,return "Suzuki"),(1,return "Tata"),(45, return "Tesla"),(1147,return "Toyota"),
                       (5,return "Triumph"),(1,return "UMM"),(1,return "Vauxhall"),(1332,return "Volvo"),(2934,return "VW")] 

genMatriculas :: Gen Matricula 
genMatriculas = do x <- vectorOf 2 $ elements ['A'..'Z'] 
                   y <- vectorOf 2 $ elements ['1'..'9'] 
                   z <- vectorOf 2 $ elements ['1'..'9'] 
                   return (x ++ "-" ++ y ++ "-" ++ z) 

-- Generator para velocidade, gera com mais frequência velocidades compreendidads entre [30..100] do que os outros limites
genVelocidade :: Gen Velocidade 
genVelocidade = frequency [(70, elements [30..90]),(20,elements [91..110]),(10,elements [111..130])] 

genPrecoKM :: Gen Preco_Km 
genPrecoKM = choose(1::Float,4) 

genConsumoKM :: Gen CONS_Km 
genConsumoKM = frequency [(80, choose (4::Float,8)),(15, choose (9::Float,13)),(5, choose (14::Float,16))] 

genAutonomia :: Gen Autonomia 
genAutonomia = frequency [(20, elements [200..400]),(70,elements[400..700]),(10,elements[700..900])] 


--Aluguer: nif cliente, X destino, Y destino, tipoCombustivel , preferencia    500
--Aluguer:204447396,94.46036,-72.85452,Electrico,MaisPerto
--tipoCombustivel Gasolina, Hibrido, Electrico
--preferencia MaisPerto MaisBarato

data Aluguer = Aluguer NIF Coordenadas TipoCombustivel Preferencia

instance Show Aluguer where
     show = pp_Aluguer

pp_Aluguer (Aluguer nif co tc p) = "Aluguer:" ++ nif ++ "," ++ show (fst co) ++ ","
                                   ++ show (snd co) ++ "," ++ tc ++ "," ++ p

type Preferencia = String

genAluguer :: [NIF] -> Gen Aluguer 
genAluguer nifs = do nif  <- elements nifs
                     coor <- genCoordenadas 
                     comb <- genTipoCombustivel 
                     pref <- genPreferencia 
                     return (Aluguer nif coor comb pref)

genPreferencia :: Gen Preferencia
genPreferencia = elements ["MaisPerto", "MaisBarato"]              

--genCoordenadas :: Gen Coordenadas
--genCoordenadas  = elements elements [(x,y) | x <- [36.96583 .. 42.152946], y <- [-6.932739 .. -9.500497]]

--genCoordenadas :: Gen Coordenada
--genCoordenadas  = elements [(x,y) | x <- (elements (enumFromThenTo 36.96583 36.96584 42.152946)), y <- (elements (enumFromThenTo (-6.932739) (-6.93274) (-9.500497)))]

-- 38.781047, -9.500497 Cabo da Roca
-- 38.208140, -6.932739 Oliva de La Frontera

-- 42.152946, -8.1999904 Melgaço
-- 36.96583, -7.888082 St. Mary


--Classificar: matricula ou nif (cliente ou prop) , nota (0-100)    200
--Classificar:YK-17-88,40
--Classificar:289068463,69

data Classificar = Classificar ID Nota

type ID = String

instance Show Classificar where
     show = pp_Classificar


pp_Classificar (Classificar id n) = "Classificar:" ++ id ++ "," ++ show n

type Nota = Int 


genClassificar :: [String] -> Gen Classificar
genClassificar l = do 
               matr <- elements l
               nota <- genNota
               return $ Classificar matr nota

genNota :: Gen Nota 
genNota = frequency [(10,elements[0..20]),(20,elements[20..50]),(60,elements[50..90]),(10,elements[80..100])]  

--import Test.QuickCheck

data Log = Log [NovoProp] [NovoCliente] [NovoCarro] [Aluguer] [Classificar]

instance Show Log where
     show = pp_Log

pp_Log (Log lp lcl lca la lcla) = pp_ListLog lp ++ pp_ListLog lcl ++ pp_ListLog lca ++ pp_ListLog la 
                                  ++ pp_ListLog lcla

pp_ListLog [] = ""
pp_ListLog (x:xs) = show x ++ "\n" ++ pp_ListLog xs

genLogs :: Int -> Int -> Int -> Int -> Int -> Gen Log
genLogs nProps nClientes nCarros nAlugueres nClassifs  = 
                          do props     <- vectorOf nProps genNovoProp
                             clientes  <- vectorOf nClientes genNovoCliente
                             let nifsC = map nifCliente clientes 
                             let nifsP = map nifProp props
                             let nifs  = nifsC ++ nifsP
                             carros    <- vectorOf nCarros $ genNovoCarro nifs
                             let matrs = map matrCarro carros
                             alugueres <- vectorOf nAlugueres $ genAluguer nifsC
                             ids <- shuffle (nifs ++ matrs)
                             classifs  <- vectorOf nClassifs $ genClassificar ids
                             return $ Log props clientes carros alugueres classifs


nifCliente :: NovoCliente -> NIF
nifCliente (NovoCliente _ nif _ _ _) = nif

nifProp :: NovoProp -> NIF
nifProp (NovoProp _ nif _ _) = nif

matrCarro :: NovoCarro -> Matricula
matrCarro (NovoCarro _ _ matr _ _ _ _ _ _) = matr

prompt :: String -> IO String
prompt text = do
          putStr text
          hFlush stdout
          getLine
          
file = "log.txt"

fileName n = do
             exists <- doesFileExist a
             if exists then (fileName (n+1))
             else return a
          where a = "("++ (show n) ++")"++file

main :: IO ()
main = do
     nProps <- prompt "Numero de Proprietarios: "
     nClientes <- prompt "Numero de Clientes: "
     nCarros <- prompt "Numero de Carros: "
     nAlugueres <- prompt "Numero de Alugueres: "
     nClassifs <- prompt "Numero de Classificacoes: "
     log <- generate $ genLogs (read nProps) (read nClientes) (read nCarros) (read nAlugueres) (read nClassifs)
     filename <- fileName 0
     writeFile filename ("Logs\n" ++ show log)
     return ()
