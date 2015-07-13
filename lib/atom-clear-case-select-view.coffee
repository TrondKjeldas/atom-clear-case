
{SelectListView} = require 'atom-space-pen-views'

module.exports =
class AtomClearCaseSelectView extends SelectListView
  initialize: (items) ->
    super
    @addClass('overlay from-top')

    @setItems items
    #@setItems(['Hello', 'World'])

    #@panel ?= atom.workspace.addModalPanel(item: this)
    #@panel.show()
    #@focusFilterEditor()
    @currentPane = atom.workspace.getActivePane()

    editor = atom.workspace.getActivePaneItem()
    file = editor?.buffer.file
    filePath = file?.path
    console.log ("file is: " + filePath)

    @result = new Promise (resolve, reject) =>
      @resolve = resolve
      @reject = reject
      @setup()

  setup: ->
    @show()

  show: ->
    #@filterEditorView.getModel().placeholderText = 'Initialize new repo where?'
    @panel ?= atom.workspace.addModalPanel(item: this)
    @panel.show()
    @focusFilterEditor()
    #@storeFocusedElement()

  viewForItem: (item) ->
    "<li>#{item}</li>"

  hide: -> @panel?.destroy()

  confirmed: (item) ->
    console.log("#{item} was selected")
    @cancel()

  cancelled: ->
    console.log("This view was cancelled")
    @hide()
    @currentPane.activate()
