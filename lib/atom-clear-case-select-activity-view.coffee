CCRunner = require './atom-clear-case-ccrunner'
{SelectListView} = require 'atom-space-pen-views'

module.exports =
class AtomClearCaseSelectView extends SelectListView
  initialize: (items) ->
    super
    @addClass('overlay from-top')

    editor = atom.workspace.getActivePaneItem()
    file = editor?.buffer.file
    @filePath = file?.path
    console.log ("file is: " + @filePath)

    @setItems items

  show: ->
    @storeFocusedElement()
    @panel ?= atom.workspace.addModalPanel(item: this)
    @panel.show()
    @focusFilterEditor()

    @result = new Promise (resolve, reject) =>
         @resolve = resolve
         @reject = reject

    return @result

  viewForItem: (item) ->
    item.viewForItem()

  getFilterKey: ->
    "description"

  hide: ->
    @panel?.destroy()

  confirmed: (item) ->
    console.log("#{item.description} was selected")
    @resolve item
    @cancel()

  cancelled: ->
    console.log("This view was cancelled")
    @reject
    console.log "After reject"
    @hide()
