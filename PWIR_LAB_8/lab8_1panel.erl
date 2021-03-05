-module(lab8_1panel).
-compile([export_all]).

% ==========================================
print({gotoxy,X,Y}) ->
    io:format("\e[~p;~pH",[Y,X]).
% print({printxy,X,Y,Msg}) ->
%     io:format("\e[~p;~pH~p",[Y,X,Msg]);   
% print({clear}) ->
%     io:format("\ec",[]);
% print({sending,It, Rand, ID}) ->
%     io:format("\e[~p;1H Value: ~p -> Sending [PID: ~p]~p",[(4*(It-1)-3)+1, Rand, ID, self()]);
% print({mediate,It, N, ID}) ->
%     io:format("\e[~p;1H Value: ~p -> Mediate [PID: ~p]~p",[(4*(It-1)-2)+1, N, ID, self()]).
pr() ->
    receive
         {clear} ->
            io:format("\ec",[]),
            pr(); 
        {sending,It, Rand, ID} ->
            io:format("\e[~p;1H Value: ~p -> Sending [PID: ~p]",[It*4 , Rand, ID]),
            pr();
        {mediate,It, N, ID} ->
            io:format("\e[~p;1H Value: ~p -> Mediate [PID: ~p]",[It*4 + 1, N, ID]),
            pr();
        {finish,It, N, ID} ->
            io:format("\e[~p;1H Value: ~p -> Received [PID: ~p]",[It*4 + 2, N, ID]),
            pr();
        {printxy,X,Y,Msg} ->
            io:format("\e[~p;~pH ~p",[Y,X,Msg]),
            pr();
        {gotoxy,X,Y} -> 
            io:format("\e[~p;~pH",[Y,X]),
            pr()
    end.
% ==========================================


produce(_,_,0) -> ok;
produce(Producer, Mediator, Iterator) ->
    Producer!{produce,Mediator, Iterator},
    produce(Producer,Mediator, Iterator-1).

producer(Printer) ->
	receive {produce,Mediator, It} ->
        Rand = rand:uniform(100),
        io:format("\e[~p;1H Value: ~p -> Sending [PID: ~p]",[It*4 , Rand, self()]),
        print({gotoxy,1,25}),
        % Printer!({sending, It, Rand, self()}),
	  	Mediator!{mediate,Rand, It},
		producer(Printer)
  end.

mediator(Receiver, Printer) ->
	receive {mediate,N, It} -> 
        io:format("\e[~p;1H Value: ~p -> Mediate [PID: ~p]",[It*4 + 1, N, self()]),
        print({gotoxy,1,25}),
        % Printer!{mediate, It, N, self()},
        Receiver!{pickup,N, It},
		mediator(Receiver, Printer)
	end.


receiver(Printer) ->
  receive {pickup,N, It} ->
        io:format("\e[~p;1H Value: ~p -> Received [PID: ~p]",[It*4 + 2, N, self()]),
        print({gotoxy,1,25}),
        % Printer!{finish,N,It},
		receiver(Printer)
  end.


fmain(HowMany) ->
    Printer     =  spawn(?MODULE, pr, []),
    Printer!{clear},
    
	PidRECEIVER = spawn(?MODULE, receiver,  [Printer]),
	PidMEDIATOR = spawn(?MODULE, mediator,  [PidRECEIVER,Printer]),
    PidPRODUCER = spawn(?MODULE, producer,  [Printer]),

    produce(PidPRODUCER, PidMEDIATOR, HowMany),

    receive 
        XD ->
        D=2
    end.

    % io:format("End~n").
