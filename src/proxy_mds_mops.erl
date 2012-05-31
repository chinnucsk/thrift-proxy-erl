%%%-------------------------------------------------------------------
%%% File    : proxy_mds_mops.erl
%%% Author  : Dai Wei <dai.wei@openx.com>
%%% Description :
%%%   Thrift callback uses Handler:handle_function. This module 
%%%   mainly provides that plus proxy-specific info on top of 
%%%   proxy_base.erl.
%%%
%%% Created : 15 May 2012 by Dai Wei <dai.wei@openx.com>
%%%-------------------------------------------------------------------

-module(proxy_mds_mops).

%% User defined macros:
-define(SERVER_PORT, 12521).
-define(CLIENT_PORT, 8710).
-define(THRIFT_SVC, opportunityService_thrift).

%% API
-export([start_link/0,
         start_link/1,
         get_adtype/0,
         set_adtype/1]).

%% gen_thrift_proxy callbacks
-export([trim_args/2]).

%% Thrift callbacks
-export([stop/1,
         handle_function/2]).

%% autogenerated macros:
-define(SERVER_NAME, list_to_atom(atom_to_list(?MODULE) ++ "_server")).

%%====================================================================
%% API
%%====================================================================
% Default replay to false (a normal proxy)
start_link() ->
  start_link(false).

start_link(Replay) when is_boolean(Replay) ->
  gen_thrift_proxy:start_link(?SERVER_NAME, 
      ?MODULE, ?SERVER_PORT, ?CLIENT_PORT, ?THRIFT_SVC, Replay).

set_adtype(NewAdType) ->
  gen_thrift_proxy:set_adtype(?SERVER_NAME, NewAdType).

get_adtype() ->
  gen_thrift_proxy:get_adtype(?SERVER_NAME).

%%====================================================================
%% gen_thrift_proxy callback functions
%%====================================================================
% Trim away timestamp, trax.id, etc. Hack hack hack!
trim_args(Fun, Args) ->
  lager:debug("Entering ~p:trim_args/1.", [?MODULE]),
  KeysToRemove = [<<"ox.internal.timestamp">>,<<"ox.internal.trax_id">>],
  if 
    Fun =:= getOpportunities ->
      gen_thrift_proxy:trim_args(Args, 1, KeysToRemove)
  end.

%%====================================================================
%% Thrift callback functions
%%====================================================================
handle_function (Function, Args) when is_atom(Function), is_tuple(Args) ->
  lager:info("~p:handle_function -- Function = ~p.", [?MODULE, Function]),
  gen_thrift_proxy:handle_function(?SERVER_NAME, Function, Args).

stop(Server) ->
  thrift_socket_server:stop(Server),
  ok.
