%%%-------------------------------------------------------------------
%%% File    : proxy_ads_mds.erl
%%% Author  : Dai Wei <dai.wei@openx.com>
%%% Description :
%%%   Thrift callback uses Handler:handle_function. This module 
%%%   mainly provides that plus proxy-specific info on top of 
%%%   proxy_base.erl.
%%%
%%% Created : 15 May 2012 by Dai Wei <dai.wei@openx.com>
%%%-------------------------------------------------------------------

-module(proxy_ads_mds).

%% User defined macros:
-define(SERVER_PORT, 8701).
-define(CLIENT_PORT, 12470).
-define(THRIFT_SVC, deliveryService_thrift).

%% API
-export([start_link/0,
         set_adtype/1]).

%% Thrift callbacks
-export([stop/1,
         handle_function/2]).

%% autogenerated macros:
-define(SERVER_NAME, list_to_atom(atom_to_list(?MODULE) ++ "_server")).

%%====================================================================
%% API
%%====================================================================
start_link() ->
  gen_thrift_proxy:start_link(?SERVER_NAME, 
      ?MODULE, ?SERVER_PORT, ?CLIENT_PORT, ?THRIFT_SVC).

set_adtype(NewAdType) ->
  gen_thrift_proxy:set_adtype(?SERVER_NAME, NewAdType).

%%====================================================================
%% Thrift callback functions
%%====================================================================
handle_function (Function, Args) when is_atom(Function), is_tuple(Args) ->
  lager:info("~p:handle_function -- Function = ~p.", [?MODULE, Function]),
  {reply, gen_thrift_proxy:handle_function(?SERVER_NAME, Function, Args)}.

stop(Server) ->
  thrift_socket_server:stop(server),
  ok.
