CCRunner = require './atom-clear-case-ccrunner'
{SelectListView} = require 'atom-space-pen-views'

module.exports =
class AtomClearCaseSelectView extends SelectListView
  initialize: (items) ->
    super
    @addClass('overlay from-top')

    @currentPane = atom.workspace.getActivePane()

    editor = atom.workspace.getActivePaneItem()
    file = editor?.buffer.file
    filePath = file?.path
    console.log ("file is: " + filePath)

    @setItems items

    @storeFocusedElement()
    @panel ?= atom.workspace.addModalPanel(item: this)
    @panel.show()
    @focusFilterEditor()

  viewForItem: (item) ->
    item.viewForItem()

  getFilterKey: ->
    "description"

  hide: ->
    @panel?.destroy()

  confirmed: (item) ->
    console.log("#{item.description} was selected")
    CCRunner.get().checkOut(item).then(
      (success) ->
        atom.notifications.addSuccess("Atom ClearCase", detail: success)
      (error) ->
        atom.notifications.addError("Atom ClearCase", detail: error)
    )
    @cancel()

  cancelled: ->
    console.log("This view was cancelled")
    @hide()
    @currentPane.activate()
