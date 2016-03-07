# Analytics Data Retrieval Plugin for [DocPad](http://docpad.org)

[![Build Status](https://img.shields.io/travis/SteveMcArthur/docpad-plugin-analytics/master.svg)](https://travis-ci.org/SteveMcArthur/docpad-plugin-analytics "Check this project's build status on TravisCI")
[![NPM version](https://img.shields.io/npm/v/docpad-plugin-analytics.svg)](https://www.npmjs.com/package/docpad-plugin-analytics "View this project on NPM")
[![NPM downloads](https://img.shields.io/npm/dm/docpad-plugin-analytics.svg)](https://www.npmjs.com/package/docpad-plugin-analytics "View this project on NPM")

Retrieves [Google Analytics](https://www.google.com/analytics/) data using serverside authentication via the [embed api](https://ga-dev-tools.appspot.com/embed-api/server-side-authorization/). Google returns analytic data in the form of a JSON object which can be used to produce tables, charts and reports. The plugin does not create these reports - just retrieves the data (which is really the hard part). Once you have the data it is simple enough to use something like [Chart.js](http://www.chartjs.org/) to create nice visual charts. The charts example shows how to do this. The data returned from google is in the following format:
````json
{
    "kind": "analytics#gaData",
    "id": "https://www.googleapis.com/analytics/v3/data/ga?ids=ga:...",
    "query": {
        "start-date": "30daysAgo",
        "end-date": "yesterday",
        "ids": "ga:12345678",
        "dimensions": "ga:pagePath",
        "metrics": [
            "ga:uniquePageviews"
        ],
        "sort": [
            "-ga:uniquePageviews"
        ],
        "start-index": 1,
        "max-results": 10
    },
    "itemsPerPage": 10,
    "totalResults": 20,
    "selfLink": "https://www.googleapis.com/analytics/v3/data/ga?ids=ga:...",
    "nextLink": "https://www.googleapis.com/analytics/v3/data/ga?ids=ga:...",
    "profileInfo": {
        "profileId": "87654321",
        "accountId": "12345678",
        "webPropertyId": "UA-12345678-1",
        "internalWebPropertyId": "991234567",
        "profileName": "All Web Site Data",
        "tableId": "ga:1010101010"
    },
    "containsSampledData": false,
    "columnHeaders": [
        {
            "name": "ga:pagePath",
            "columnType": "DIMENSION",
            "dataType": "STRING"
        },
        {
            "name": "ga:uniquePageviews",
            "columnType": "METRIC",
            "dataType": "INTEGER"
        }
    ],
    "totalsForAllResults": {
        "ga:uniquePageviews": "27845"
    },
    "rows": [
        [
            "/",
            "6500"
        ],
        [
            "/news",
            "21345"
        ]
    
    ]
}

````


The advantage of this approach that you don't need to give users access to your analytics account and the users don't need to log in to google to access the data. This makes a lot more sense for an admin style page that shows analytic data. Of course, you will probably want to protect this admin page with some sort of login for the website. So you will probably want to use this plugin in conjunction with an authentication plugin such as [docpad-plugin-authentication](https://www.npmjs.com/package/docpad-plugin-authentication).

The plugin relies on downloading from Google what they call a "JSON key". This is a json file containing all the necessary credentials for making calls to the embed API. All details can be found at: [https://ga-dev-tools.appspot.com/embed-api/server-side-authorization/](https://ga-dev-tools.appspot.com/embed-api/server-side-authorization/) 

Once you have the "JSON key" you need to place it in the root of your DocPad application. The plugin will load it from there. By default the plugin expects it to be named "credentials.json". 

In docpad.coffee file you will need to configure the queries you want to send to google and the URL endpoints for calling those queries from within your application.

````coffee
    plugins:
        analytics:
            queries:[{
                'endPoint': 'uniquePageviews',
                'query':{
                    'ids':['ga:12345678'],
                    'metrics': 'ga:uniquePageviews',
                    'dimensions': 'ga:pageTitle',
                    'start-date': '30daysAgo',
                    'end-date': 'yesterday',
                    'sort': '-ga:uniquePageviews',
                    'max-results': 10
                }
            }]
````

The `endPoint` parameter is appended to the base dataURL, by default, `/analytics/data`. So to retrieve the above query your application needs to make a call to `/analytics/data/uniquePageviews`.

```js
    $.getJSON('/analytics/data/uniquePageviews',function(data){
        $('#results pre').html(JSON.stringify(data,null,4));
    });
```

To build and test queries use google's [query explorer](https://ga-dev-tools.appspot.com/query-explorer/)