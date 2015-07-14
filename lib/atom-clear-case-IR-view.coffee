module.exports =
class IRInfoView
  constructor: (line) ->
      @number = line.split(" ").filter (x) -> x.slice(0, 2) == "IR"
      @number = @number.filter (x) -> x.length > 0
      console.log (@number)

      @description = line.slice(line.indexOf("\"")+1, line.lastIndexOf("\""))
      console.log (@description)

  viewForItem: (item) ->
    "<li>#{@number}  -  #{@description}</li>"
