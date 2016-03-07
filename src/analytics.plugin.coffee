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

            #download your credentials file from
            #your google analytics account and place
            #it somewhere in your docpad project. The
            #default place is the root of the docpad application.
            credentialsFile: path.resolve(process.cwd(),'credentials.json')
            
            #possibility to add credentials directly to the config
            credentials: null
            
            #example of a google analytics api query. You will probably want
            #to use googles query explorer (https://ga-dev-tools.appspot.com/query-explorer/)
            #to build your own query.
            queries:[{
                #appended to the dataURL config option
                #to create the URL used to call the query
                'endPoint': 'uniquePageviews',
                #this is the actual query sent to google
                'query':{
                    'ids':'',
                    'metrics': 'ga:uniquePageviews',
                    'dimensions': 'ga:pageTitle',
                    'start-date': '30daysAgo',
                    'end-date': 'yesterday',
                    'sort': '-ga:uniquePageviews',
                    'max-results': 10
                }
            }]
        
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
                    else
                        callback(null,data)
        
        constructor: ->
            super
            
         
        init: ->
            creds =  @config.credentials
            if !creds
                creds = require(@config.credentialsFile)
            @jwtClient = new google.auth.JWT(creds.client_email, null, creds.private_key, ['https://www.googleapis.com/auth/analytics.readonly'], null)
            
        # Use to extend the server with routes that will be triggered before the DocPad routes.
        serverAfter: (opts) ->
            # Extract the server from the options
            {server} = opts
            config = @getConfig()
            plugin = @
            plugin.init()
            
            serverGet = (req,res,next) ->
                endPoint = req.path.split('/').pop()
                theQry = null

                for q in config.queries
                    if q.endPoint == endPoint
                        theQry = q.query
                        
                if theQry
                    try
                        plugin.retrieveData theQry, (err,data) ->
                            if err
                                obj =
                                    msg:'error retrieving data',
                                    err: err
                                str = JSON.stringify(obj)
                                res.send(500,str)
                            else
                                res.setHeader('Content-Type', 'application/json')
                                res.send(200, JSON.stringify(data))
                    catch err
                        res.send(500,err)
                else
                    res.send(500,"Unable to find matching query")
            
            qrys = config.queries
            qrys.forEach (qry) ->
                server.get config.dataURL+'/'+qry.endPoint, (req,res,next) ->
                    serverGet(req,res,next)

            @