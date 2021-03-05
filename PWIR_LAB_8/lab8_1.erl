-module(lab8_1).
-compile([export_all]).

producer(Mediator) ->
    receive
        {generate, 0} -> 
            io:format("Value: ~p -> Sending [PID: ~p]~n",[-1,self()]),
            Mediator ! {mediate, -1};
        {generate, Len} ->
            Rand = rand:uniform(100),
            io:format("Value: ~p -> Sending [PID: ~p]~n",[Rand,self()]),
            Mediator ! {mediate, Rand},
            self()! {generate, (Len-1)},
            producer(Mediator)
    end.

mediator(Bufor, BufSize) ->
	  receive 
        {mediate,N}  when (length(Bufor) < BufSize) ->
            Nbuff= Bufor++[N],     
		    io:format("Buffor: ~w -> Mediate [PID: ~p]~n",[Nbuff,self()]),
		    mediator(Nbuff, BufSize);
        {giveme, Where} when length(Bufor) > 0 ->
            [H|T] = Bufor,
            Where!{pickup, H},
            mediator(T, BufSize)
	  end.


receiver(Mediator) ->
    timer:sleep(5000),
    Mediator ! {giveme, self()},
    receive {pickup,N} when N >= 0 ->
        io:format("Value: ~p -> Received [PID: ~p]~n",[N,self()]),
		    receiver(Mediator);
        {pickup,N} when N < 0 ->
        io:format("Value: ~p -> Received [PID: ~p] AND ITS FINISH~n",[N,self()])
    end.


fmain(HowMany) ->
	  
	PidMEDIATOR = spawn(?MODULE, mediator,  [[], floor(HowMany / 2)]),
    PidRECEIVER = spawn(?MODULE, receiver,  [PidMEDIATOR]),
    PidPRODUCER = spawn(?MODULE, producer,  [PidMEDIATOR]),
    
    PidPRODUCER ! {generate, HowMany},
    PidRECEIVER ! {giveme, PidRECEIVER},

    

    io:format("End~n").
