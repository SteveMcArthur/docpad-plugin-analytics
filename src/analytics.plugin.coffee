# Export Plugin
module.exports = (BasePlugin) ->
    # Define Plugin
    google = require('googleapis')
    path = require('path')
    class AnalyticsPlugin extends BasePlugin
        # Plugin name
        name: 'analytics'
        # Config
        config:
            dataURL: '/analytics/data'
            gaID: ''
            credentialsFile: path.resolve(process.cwd(),'credentials.json')

        assign: (target, source) ->
            for key, val of source
                if (!target[key])
                    target[key] = val
            return target

        pageViewsQuery:
            'auth': @jwtClient,
            'ids': '',
            'metrics': 'ga:uniquePageviews',
            'dimensions': 'ga:pagePath',
            'start-date': '30daysAgo',
            'end-date': 'yesterday',
            'sort': '-ga:uniquePageviews',
            'max-results': 10
            
        getQueries: (baseQuery, id, resultCount) ->
            maxResults = resultCount || 10

            result =
                last30days: @assign({
                    'ids': id,
                    'max-results': maxResults,
                    'start-date': '30daysAgo'
                }, baseQuery),
                last7days: @assign({
                    'ids': id,
                    'max-results': maxResults,
                    'start-date': '7daysAgo'
                }, baseQuery),
                yesterday: @assign({
                    'ids': id,
                    'max-results': maxResults,
                    'start-date': 'yesterday'
                }, baseQuery)

            return result
        
        retrieveData: (query,callback) ->
            authClient = @jwtClient
            authClient.authorize (err, tokens) ->
                if (err)
                    callback(err)

                analytics = google.analytics('v3')
                query.auth = authClient
                analytics.data.ga.get query, (err, data) ->
                    if (err)
                        callback(err)

                    callback(data)
        
        constructor: ->
            super
            #creds = @config.credentials
            #credentialFile = path.resolve(@docpad.getconfig().rootPath,'credentials.json')
            creds = require(@config.credentialsFile)
            @jwtClient = new google.auth.JWT(creds.client_email, null, creds.private_key, ['https://www.googleapis.com/auth/analytics.readonly'], null)
         
        # Use to extend the server with routes that will be triggered before the DocPad routes.
        serverExtend: (opts) ->
            # Extract the server from the options
            {server} = opts
            config = @getConfig()
            plugin = @
            analytics = google.analytics('v3')
            qrys = @getQueries(@pageViewsQuery, config.gaID)

            server.get config.dataURL+"/last30days", (req,res,next) ->
                try
                    plugin.retrieveData qrys.last30days, (data) ->
                        res.setHeader('Content-Type', 'application/json')
                        res.send(200, JSON.stringify(data))
                catch err
                    res.send(500,err)
            
            server.get config.dataURL+"/last7days", (req,res,next) ->
                plugin.queryData analytics, qrys.last7days, (data) ->
                    res.setHeader('Content-Type', 'application/json')
                    res.send(200, data)
                
            server.get config.dataURL+"/yesterday", (req,res,next) ->
                plugin.queryData analytics, qrys.yesterday, (data) ->
                    res.setHeader('Content-Type', 'application/json')
                    res.send(200, data)


            @
        

