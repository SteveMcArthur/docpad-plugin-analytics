
# Test our plugin using DocPad's Testers
testerConfig =
    pluginPath: __dirname+'/..'
    autoExit: 'safe'
docpadConfig =
    templateData:
        site:
            url: 'http://127.0.0.1'

require('docpad').require('testers')
    .test(testerConfig,docpadConfig)