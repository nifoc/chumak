%% This Source Code Form is subject to the terms of the Mozilla Public
%% License, v. 2.0. If a copy of the MPL was not distributed with this
%% file, You can obtain one at http://mozilla.org/MPL/2.0/.
-module(pair_client).
-export([main/0]).

main() ->
    application:start(chumak),
    {ok, Socket} = chumak:socket(pair),

    case chumak:connect(Socket, tcp, "localhost", 5555) of
        {ok, _BindPid} ->
            io:format("Connected OK with Pid: ~p\n", [Socket]);
        {error, Reason} ->
            io:format("Connection Failed for this reason: ~p\n", [Reason]);
        X ->
            io:format("Unhandled reply for bind ~p \n", [X])
    end,
    loop(Socket).

loop(Socket) ->
    {ok, Data1} = chumak:recv_multipart(Socket),
    io:format("Received ~p\n", [Data1]),
    ok = chumak:send_multipart(Socket, [<<"Hey Jude">>]),
    loop(Socket).
