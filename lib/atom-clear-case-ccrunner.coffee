path = require 'path'
{spawn} = require 'child_process'
ActivityInfoView = require './atom-clear-case-activity-view'

module.exports =
class CCRunner

  instance = null

  # Get singleton instance
  @get: ->
    instance ?= new CCRunnerImplementation()

  # Implementation of singleton class
  class CCRunnerImplementation

    constructor: () ->
      # body...

    # Fetch applicable IRs/activities for the specified file.
    getActivityList: (filePath) ->

      promise = new Promise (resolve, reject) =>
        console.log "Spawning!"
        #ls = spawn '/Users/trond/Projects/atom-clear-case/sleeper.sh', ['20'], cwd:"/Users/trond/Projects/atom-clear-case/"
        ls = spawn 'cat', ['/Users/trond/Projects/atom-clear-case/lsact-cview-output.txt']

        # receive all output and process
        ls.stdout.on 'data', (data) =>
          console.log data.toString().trim()
          lines = data.toString().split "\n"
          acts = (new ActivityInfoView(line) for line in lines)

          # should also check exit code...
          promise2 = new Promise (resolve2, reject2) =>
            ls.on 'close', (code) =>
              console.log "code = " + code
              if code == 0
                resolve2 acts
              else
                reject2 "failed exit code"

          promise2.then(
            (acts) ->
              console.log "resolved2"
              resolve acts
            (error) ->
              console.log "rejected2"
              reject error
          )

        # receive error messages and process
        ls.stderr.on 'data', (data) =>
          console.log data.toString().trim()
          reject "failed stderr"

      return promise

    checkOut: (filePath) ->

      fileName = path.basename filePath

      promise = new Promise (resolve, reject) =>

        ls = spawn 'ls', ['fail2'], cwd:"/Users/trond/Projects/atom-clear-case/"

        ls.on 'close', (code) =>
          console.log "code = " + code
          if code == 0
            resolve "File #{fileName} successfully checked out!"
          else
            reject "Failed to check out #{fileName}!"

      return promise

    checkIn: (filePath) ->

      fileName = path.basename filePath

      promise = new Promise (resolve, reject) =>

        ls = spawn 'ls', ['fail2'], cwd:"/Users/trond/Projects/atom-clear-case/"

        ls.on 'close', (code) =>
          console.log "code = " + code
          if code == 0
            resolve "File #{fileName} successfully checked in!"
          else
            reject "Failed to check in #{fileName}!"

        return promise

    lsvtree: (filePath) ->

      fileName = path.basename filePath

      promise = new Promise (resolve, reject) =>

        try
          vt = spawn 'lsvtree', [filePath], cwd:"/Users/trond/Projects/atom-clear-case/"

          ls.on 'close', (code) =>
            console.log "code = " + code
            if code == 0
              resolve "Showing version tree for #{fileName}"
            else
              reject "Unable to show version tree for #{fileName}"
        catch error
          reject "Unable to show version tree for #{fileName}"

      return promise
