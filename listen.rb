require 'listen'
require 'sinatra'
require "sinatra/streaming"

set :server, :thin
set :bind, '0.0.0.0'

get '/' do
  stream do |out|
    out.puts <<eos
    <style>
      div {
        padding: 5px;
        padding-left: 5%;
        font-weight: bold;
        font-family: monospace;
        margin-bottom: 10px;

        animation: fadein 2s;
        -moz-animation: fadein 2s; /* Firefox */
        -webkit-animation: fadein 2s; /* Safari and Chrome */
        -o-animation: fadein 2s; /* Opera */
      }

      span {
        padding-right: 50px;
        font-weight: normal;
        font-size: smaller;
      }
      
      .modified {
        background-color: #ead891;
      }
      .added {
        background-color: #9befb7;
      }
      .removed {
        background-color: #f7b2b2;
      }

      @keyframes fadein {
          from {
              opacity:0;
              background-color: #e5b5c4;
          }
          to {
              opacity:1;
          }
      }
      @-moz-keyframes fadein { /* Firefox */
          from {
              opacity:0;
              background-color: #e5b5c4;
          }
          to {
              opacity:1;
          }
      }
      @-webkit-keyframes fadein { /* Safari and Chrome */
          from {
              opacity:0;
              background-color: #e5b5c4;
          }
          to {
              opacity:1;
          }
      }
      @-o-keyframes fadein { /* Opera */
          from {
              opacity:0;
              background-color: #e5b5c4; 
          }
          to {
              opacity: 1;
          }
      }

    </style>
eos

    out.puts "<div>Starting listening...</div>" 

    listener = Listen.to('/home/sandric/listen-test', debug: true) do |modifications, additions, deletions|
      time = Time.now.strftime("%d/%m/%Y %H:%M:%S")

      modifications.each { |modification| out.puts "<div class='modified'><span>#{time}</span>#{modification}</div>" }
      additions.each { |addition| out.puts "<div class='added'><span>#{time}</span>#{addition}</div>" }
      deletions.each { |deletion| out.puts "<div class='removed'><span>#{time}</span>#{deletion}</div>" }
    end
    listener.start # not blocking
    sleep
  end
end
