#AtomClearCaseView = require './atom-clear-case-view'
AtomClearCaseView = require './atom-clear-case-select-view'
{CompositeDisposable} = require 'atom'

module.exports = AtomClearCase =
  atomClearCaseView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @atomClearCaseView = new AtomClearCaseView(state.atomClearCaseViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @atomClearCaseView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-clear-case:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @atomClearCaseView.destroy()

  serialize: ->
    atomClearCaseViewState: @atomClearCaseView.serialize()

  toggle: ->
    console.log 'AtomClearCase was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
