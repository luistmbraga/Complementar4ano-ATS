Combinadores de Parsing

Trabalho composto por:
1. ASTandPP.hs -> Declarações dos tipos ddados e funções de "pretty printing".
2. LangParser.hs -> Funções que realizam o parse da linguagem.
3. Parser.hs -> Biblioteca de combinadores de parsing.
4. SemanticAnalyzer.hs -> Funções que implementam a detecção de erros semânticos depois de realizado o parsing.

Modo de Uso:

1. Escrever "ghci SemanticAnalyzer.hs" no terminal;
2. Escrever "semanticAnalyzer [input]" ;
    Exemplo: semanticAnalyzer "[ Use y, Decl x, [ Decl y, Use x, Decl y], Use x]"