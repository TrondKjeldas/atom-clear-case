{SelectListView} = require 'atom-space-pen-views'
path = require 'path'

CCRunner = require './atom-clear-case-ccrunner'
AtomClearCaseSelectView = require './atom-clear-case-select-activity-view'

module.exports =
class AtomClearCaseSelectCommandView extends SelectListView

  initialize: (filePath) ->
    super
    @addClass('overlay from-top')

    @filePath = filePath
    @fileName = path.basename filePath

    commands = [
      {
        name: "Checkout"
        func: => @checkout()
      }
      {
        name: "Checkin"
        func: => @checkin()
      }
      {
        name: "Version Tree"
        func: => @lsvtree()
      }
      ]

    @setItems commands

    @storeFocusedElement()
    @panel ?= atom.workspace.addModalPanel(item: this)
    @panel.show()
    @focusFilterEditor()

  viewForItem: (item) ->
    "<li>#{item.name} file: #{@fileName}</li>"

  hide: ->
    @panel?.destroy()

  confirmed: (command) ->
    console.log("Command #{command.name} was selected")
    command.func()
    @cancel()

  cancelled: ->
    console.log("This view was cancelled")
    @hide()

  selectActivity: ->

    promise = CCRunner.get().getActivityList(@filePath)
    promise.then(
      (activities) =>
        atomClearCaseActivitiesView = new AtomClearCaseSelectView(activities)
        @handleActivitySelected(atomClearCaseActivitiesView.show())

      (error) ->
        #atom.notifications.addInfo("Information!", detail: "Whatever!")
        #atom.notifications.addSuccess("Success!", detail: "Yohoo!")
        atom.notifications.addError("Atom ClearCase", detail: "Unable to fetch IR list: " + error)
        #console.log error
    )

  handleActivitySelected: (promise) ->

    promise.then(

      (item) =>
        console.log "success: #{item.number}"
        @performCCOperation()

      () =>
        console.log "Selection aborted"
    )

  performCCOperation: ->

    if @operation == "co"
      promise = CCRunner.get().checkOut(@filePath)
    else if @operation == "ci"
      promise = CCRunner.get().checkIn(@filePath)
    else if @operation == "vt"
      promise = CCRunner.get().lsvtree(@filePath)
    else
      atom.notifications.addError("Atom ClearCase", detail: "unknown operation: #{@operation}")

    promise.then(
      (success) =>
        atom.notifications.addSuccess("Atom ClearCase", detail: success)
      (error) =>
        atom.notifications.addError("Atom ClearCase", detail: error)
    )

  checkout: ->
    console.log "checkout called for file #{@filePath}!"
    @operation = "co"
    @selectActivity()

  checkin: ->
    console.log "checkin called for file #{@filePath}!"
    @operation = "ci"
    @selectActivity()

  lsvtree: ->
    console.log "lsvtree called for file #{@filePath}!"
    @operation = "vt"
    @performCCOperation()
