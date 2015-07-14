
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
    @cancel()

  cancelled: ->
    console.log("This view was cancelled")
    @hide()
    @currentPane.activate()
