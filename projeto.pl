% 1.Fatos sobre o lugar -> lugar(Nome,Estacao,Tipo,Dificuldade)

lugar(serraDoCipo,[inverno,primavera],diversao,dificil).
lugar(paoDeAcucar,[verao,outono,inverno,primavera],esporte,dificil).
lugar(saoBentoDoSapucai,[inverno,primavera],esporte,dificil).
lugar(pindamonhangaba,[inverno,primavera],esporte,medio).
lugar(chapadaDaDiamantina,[inverno,primavera],diversao,medio).
lugar(lapinha,[inverno,primavera],esporte,medio).
lugar(serraCaiada,[primavera,verao],diversao,facil).
lugar(pedraDaBoca,[primavera,verao],diversao,facil).
lugar(lapaDoSeuAntao,[verao,outono,inverno,primavera],esporte,facil).

% 2.Definir estacao do ano -> getEstacao(DiaEntrada,MesEntrada,Estacao)

getEstacao(X,Y,outono) :- (X>=20,X=<31,(Y=marco;Y=3));(X>0,X=<30,(Y=abril;Y=4));(X>0,X=<31,(Y=maio;Y=5));(X>0,X<20,(Y=junho;Y=6)).
getEstacao(X,Y,inverno) :- (X>=20,X=<30,(Y=junho;Y=6));(X>0,X=<31,(Y=julho;Y=7));(X>0,X=<31,(Y=agosto;Y=8));(X>0,X<22,(Y=setembro;Y=9)).
getEstacao(X,Y,primavera) :- (X>=22,X=<30,(Y=setembro;Y=9));(X>0,X=<31,(Y=outubro;Y=10));(X>0,X=<30,(Y=novembro;Y=11));(X>0,X<21,(Y=dezembro;Y=12)).
getEstacao(X,Y,verao) :- (X>=21,X=<31,(Y=dezembro;Y=12));(X>0,X=<31,(Y=janeiro;Y=1));(X>0,X=<29,(Y=fevereiro;Y=2));(X>0,X<20,(Y=marco;Y=3)).

% 3.Cadastrar escalador -> setEscalador(Pessoa,NumMarinheiros)

:-dynamic(getEscalador/2).
setEscalador(X,Y) :- asserta(getEscalador(X,Y)).   

% 4.Determinar forma fisica -> forma(Pessoa,Forma)

forma(X,fraca) :- \+(getEscalador(X,_)).
forma(X,fraca) :- getEscalador(X,Y),Y>=0,Y<10.
forma(X,media) :- getEscalador(X,Y),Y>=10,Y<25.
forma(X,atletica) :- getEscalador(X,Y),Y>=25.

% 5.Determinar nivel da pessoa -> getNivel(Horas,Nivel)

getNivel(X,facil) :- X>=0,X<16. 
getNivel(X,medio) :- X>=16,X<40.
getNivel(X,dificil) :- X>=40.

% 6.Determinar quais niveis de dificuldade a pessoa tem acesso -> checkDificuldade(Nome,Horas,Dificuldade)

checkDificuldade(X,Y,facil) :- forma(X,Forma),(Forma=fraca;Forma=media;Forma=atletica),getNivel(Y,Nivel),(Nivel=facil;Nivel=medio;Nivel=dificil).
checkDificuldade(X,Y,medio) :- forma(X,Forma),(Forma=media;Forma=atletica),getNivel(Y,Nivel),(Nivel=medio;Nivel=dificil).
checkDificuldade(X,Y,dificil) :- forma(X,Forma),(Forma=atletica),getNivel(Y,Nivel),(Nivel=dificil).

% 7.Determinar lugares com o mesmo tipo passado -> checkTipo(Tipo,Lugar)

checkTipo(X,Y) :- lugar(Y,_,X,_).

% 8.Determinar lugares com a mesma estacao passada -> checkEstacao(Estacao,Lugar)

pertence(X,[X|_]). % Caso Base
pertence(X,[_|Z]) :- pertence(X,Z). % Passo Recursivo 
checkEstacao(X,Y) :- lugar(Y,Z,_,_),pertence(X,Z).

% 9.Cadastrar duplas de lugar e dificuldade -> SetDupla((Lugar,Dificuldade))

:-dynamic(getDupla/1).
setDupla(X) :- assert(getDupla(X)).

% 10.Recomendar escalada -> recomendarEscalada(Pessoa,HorasPraticadas,Tipo,DiaEntrada,MesEntrada,ListaRecomendada)

recomendarEscalada(Nome,Horas,Tipo,Dia,Mes,Lista) :-
	getEstacao(Dia,Mes,Estacao),
	checkDificuldade(Nome,Horas,DificuldadePessoa),
	checkTipo(Tipo,LugarTipo),
	checkEstacao(Estacao,LugarEstacao),
	LugarTipo = LugarEstacao,
	lugar(LugarTipo,_,_,Dificuldade),
	Dificuldade = DificuldadePessoa,
	Lista = (LugarTipo,Dificuldade),
	setDupla(Lista).
	
% 11. Gerar lista de recomendações -> getLista(Lista)	
getLista(Lista) :- findall(X,getDupla(X),Lista), retractall(getDupla(_)).
