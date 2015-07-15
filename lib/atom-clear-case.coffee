AtomClearCaseCommandView = require './atom-clear-case-select-command-view'

{CompositeDisposable} = require 'atom'
{spawn} = require 'child_process'

module.exports = AtomClearCase =
  atomClearCaseCommandView: null
  subscriptions: null
  mystate: null

  activate: (state) ->
    @mystate = state

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-clear-case:toggle': => @toggle()

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->

  findAct: (line) ->
    words = line.split " "
    return words[3]

  toggle: ->
    console.log 'AtomClearCase was toggled!'

    editor = atom.workspace.getActivePaneItem()
    file = editor?.buffer.file
    filePath = file?.path

    @atomClearCaseCommandView = new AtomClearCaseCommandView(filePath)
