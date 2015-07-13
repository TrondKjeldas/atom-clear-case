#AtomClearCaseView = require './atom-clear-case-view'
AtomClearCaseSelectView = require './atom-clear-case-select-view'
{CompositeDisposable} = require 'atom'
{spawn} = require 'child_process'

module.exports = AtomClearCase =
  atomClearCaseView: null
  modalPanel: null
  subscriptions: null
  mystate: null

  activate: (state) ->
    console.log("yo!")
    #@atomClearCaseView = new AtomClearCaseSelectView(state.atomClearCaseViewState)
    console.log("hei!")
    #@modalPanel = atom.workspace.addModalPanel(item: @atomClearCaseView.getElement(), visible: false)
    console.log("hallo!")
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
    #ls.stdout.on 'data', (data) -> @setItems([ "#{data}" ] ) #console.log data.toString().trim()
    ls.stdout.on 'data', (data) ->
      console.log data.toString().trim()
      lines = data.toString().split "\n"

      IRs = lines.map (l) -> l.split(" ").filter (x) -> x.slice(0, 2) == "IR"
      IRs = IRs.filter (x) -> x.length > 0

      Descriptions = lines.map (l) -> l.split(" ").filter (x) -> x.slice(0, 1) == "\""
      Descriptions = Descriptions.filter (x) -> x.length > 0
      console.log (Descriptions)

      acts = ("#{IRs[i]} - #{Descriptions[i]}" for i in [0..IRs.length-1])

      @atomClearCaseView = new AtomClearCaseSelectView(acts)
    # receive error messages and process
    ls.stderr.on 'data', (data) -> console.log data.toString().trim()

    #if @atomClearCaseView == null
    #@atomClearCaseView = new AtomClearCaseSelectView(@mystate.atomClearCaseViewState)
    #else
    #  if @atomClearCaseView .isVisible()
    #      @atomClearCaseView .hide()
    #  else
    #@atomClearCaseView .show()
