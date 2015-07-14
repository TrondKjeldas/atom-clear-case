AtomClearCaseSelectView = require './atom-clear-case-select-view'
IRView = require './atom-clear-case-IR-view'

{CompositeDisposable} = require 'atom'
{spawn} = require 'child_process'

module.exports = AtomClearCase =
  atomClearCaseView: null
  modalPanel: null
  subscriptions: null
  mystate: null

  activate: (state) ->
    @mystate = state

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-clear-case:toggle': => @toggle()

  deactivate: ->
    #@modalPanel.destroy()
    @subscriptions.dispose()
    #@atomClearCaseView.destroy()

  serialize: ->
    #atomClearCaseViewState: @atomClearCaseView.serialize()

  findAct: (line) ->
    words = line.split " "
    return words[3]

  toggle: ->
    console.log 'AtomClearCase was toggled!'

    sl = spawn 'sleep', ['-h']
    sl.stdout.on 'data', (data) -> console.log data.toString().trim()
    sl.stderr.on 'data', (data) -> console.log data.toString().trim()

    ls = spawn 'cat', ['/Users/trond/Projects/atom-clear-case/lsact-cview-output.txt']
    # receive all output and process
    ls.stdout.on 'data', (data) ->
      console.log data.toString().trim()
      lines = data.toString().split "\n"
      acts = (new IRView(line) for line in lines)
      @atomClearCaseView = new AtomClearCaseSelectView(acts)

    # receive error messages and process
    ls.stderr.on 'data', (data) -> console.log data.toString().trim()
