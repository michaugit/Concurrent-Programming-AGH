-module(lab8_2).
-compile([export_all]).


get_mstimestamp() ->
	{Mega, Sec, Micro} = os:timestamp(),
	(Mega*1000000 + Sec)*1000 + round(Micro/1000).

sorts(L) -> 
  	merge_sort(L).

merge([],A) -> A;
merge(A,[]) -> A;
merge([Ha|Ta],[Hb|Tb]) ->
	if
		Ha<Hb -> [Ha]++merge(Ta,[Hb|Tb]);
		true -> [Hb]++merge([Ha|Ta],Tb)
	end.

merge_sort([]) -> [];
merge_sort([A]) -> [A];
merge_sort(List) ->
	{Left,Right} = lists:split(trunc(length(List)/2),List),
	merge(merge_sort(Left),merge_sort(Right)).

%---------------------------------------
sortw(L) -> 
  	merge_sort_concurrent(L). 
  
rcv(Pid) -> 
	receive
		{Pid, L} -> L
	end.

merge_sort_concurrent(L) ->
	Pid = spawn(?MODULE, merge_sort_execute, [self(), L]),
	% receive 
	% 	{Pid, List} ->  List
	% end.
	rcv(Pid).

	

merge_sort_execute(Pid, L) when length(L) < 100 -> Pid ! {self(), merge_sort(L)}; 
merge_sort_execute(Pid, L) -> 
	{Lleft, Lright} = lists:split(trunc(length(L)/2),L),
    Pid1 = spawn(?MODULE, merge_sort_execute, [self(), Lleft]),
    Pid2 = spawn(?MODULE, merge_sort_execute, [self(), Lright]),
	% receive
	% 	{Pid1, L1s} ->
	% 		L1 = L1s
	% end,
	% receive
	% 	{Pid2, L2s} -> 
	% 		L2 = L2s
	% end,
	L1 = rcv(Pid1),
    L2 = rcv(Pid2),
    Pid ! {self(), merge(L1,L2)}. 
	







gensort() ->
	L=[rand:uniform(5000)+100 || _ <- lists:seq(1, 25339)],	
	Lw=L,
	io:format("Liczba elementow = ~p ~n",[length(L)]),
	
	io:format("Sortuje sekwencyjnie~n"),	
	TS1=get_mstimestamp(),
	sorts(L),
	DS=get_mstimestamp()-TS1,	
	io:format("Czas sortowania ~p [ms]~n",[DS]),
	io:format("Sortuje wspolbieznie~n"),	
	TS2=get_mstimestamp(),
	sortw(Lw),
	DS2=get_mstimestamp()-TS2,	
	io:format("Czas sortowania ~p [ms]~n",[DS2]).
 