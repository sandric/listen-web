require 'listen'
require 'sinatra'
require "sinatra/streaming"

set :server, :thin
set :bind, '0.0.0.0'

get '/' do
  #listener = Listen.to('/home/sandric/listen-test', debug: false) do |modified, added, removed|
    #puts "modified absolute path: #{modified}" if modified.any?
    #puts "added absolute path: #{added}" if added.any? 
    #puts "removed absolute path: #{removed}" if removed.any? 
  #end
  #listener.start # not blocking
  #sleep

  stream do |out|
    out.puts <<eos
    <style>
      div {
        padding: 5px;
        padding-left: 20%;
        font-weight: bold;
        font-family: monospace;
        margin-bottom: 10px;

        animation: fadein 2s;
        -moz-animation: fadein 2s; /* Firefox */
        -webkit-animation: fadein 2s; /* Safari and Chrome */
        -o-animation: fadein 2s; /* Opera */
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

    out.puts "<div class='modified'>/home/sandric/listen-test</div>"
    sleep 1
    out.puts "<div class='added'>/home/sandric/listen-test</div>"
    sleep 1
    out.puts "<div class='removed'>/home/sandric/listen-test</div>"
  end
end
