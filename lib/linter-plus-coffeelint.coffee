coffeelint = require 'coffeelint'
findFile = require './find-file'

module.exports = LinterPlusCoffeelint =

  scopes: ['source.coffee', 'source.litcoffee', 'source.coffee.jsx']

  activate: ->
    unless atom.packages.getLoadedPackages 'linter-plus'
      @showError '[Linter+ Coffeelint] `linter-plus` package not found, please install it'

  showError: (message = '') ->
    atom.notifications.addError message

  provideLinter: ->
    {
      scopes: @scopes
      lint: @lint
      lintOnFly: true
    }

  lint: (TextEditor, TextBuffer, {Error}) ->
    filePath = TextEditor.getPath()
    origPath = if filePath then path.dirname filePath else ''

    configPath = findFile origPath, 'coffeelint.json'
    options = if configPath then require configPath else {}

    if filePath
      try
        results = coffeelint.lint TextEditor.getText(), options

        results.map ({message, lineNumber, context, column}) ->
          message = "#{message}. #{context}" if context
          column = 0 unless column

          new Error(message, filePath, [[lineNumber, column], [lineNumber, column]], [])
      catch error
        console.warn('[Liner+ Coffeelint] error while linting file')
        console.warn(error)

        return [new Error('error while linting file', filePath, [[1, 0], [1, 0]], [])]
