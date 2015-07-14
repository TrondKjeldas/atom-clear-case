AtomClearCaseSelectView = require './atom-clear-case-select-view'

CCRunner = require './atom-clear-case-ccrunner'

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

    ccrunner = CCRunner.get()

    promise = ccrunner.getActivityList()
    promise.then(
      (activities) ->
        @atomClearCaseView = new AtomClearCaseSelectView(activities)
      (error) ->
        #atom.notifications.addInfo("Information!", detail: "Whatever!")
        #atom.notifications.addSuccess("Success!", detail: "Yohoo!")
        atom.notifications.addError("Atom ClearCase", detail: "Unable to fetch IR list: " + error)
        #console.log error
    )
