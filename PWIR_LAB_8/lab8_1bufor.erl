-module(lab8_1bufor).
-compile([export_all]).

generator(0, _) -> ok;
generator(Len, [H|T]) ->
        Rand = rand:uniform(100),
        io:format("GEN: ~p PID: ~p~n",[Rand, self()]),
        H ! {data, Rand},
        generator(Len-1, T++[H]).


generator1() ->
    receive
        {generate, 0, _} -> ok;
        {generate, Len, [H|T]} ->
            Rand = rand:uniform(100),
            io:format("GEN: ~p PID: ~p~n",[Rand, self()]),
            H ! {data, Rand},
            self()! {generate, (Len-1), (T++[H])},
            generator1()
    end.


processor(Bufor) ->
    receive
        {data, Num} ->
            io:format("PROCESSING ~p  PID: ~p ~n",[Num,self()]),
            N = 2 * Num,
            Bufor ! {computed,N},
            processor(Bufor)
    end.

bufor(List) ->
    receive
        {computed,Num} ->
            io:format("BUFOR: ~w PID: ~p ~n",[([Num]++List), self()]),
            bufor([Num]++List)
     end.

main() ->
    PIDbuf = spawn(?MODULE,bufor,[[]]),
    PIDprocess1 = spawn(?MODULE, processor, [PIDbuf]),
    PIDprocess2 = spawn(?MODULE, processor, [PIDbuf]),
    PIDprocess3 = spawn(?MODULE, processor, [PIDbuf]),
    PIDgen = spawn(?MODULE, generator1, []),

    PIDgen ! {generate, 5, [PIDprocess1, PIDprocess2, PIDprocess3]}.
    % generator(5, [PIDprocess1, PIDprocess2, PIDprocess3] ).