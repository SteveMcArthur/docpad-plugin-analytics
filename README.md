# Google Analytics Data Plugin for [DocPad](http://docpad.org)

[![Build Status](https://img.shields.io/travis/SteveMcArthur/docpad-plugin-analytics/master.svg)](https://travis-ci.org/SteveMcArthur/docpad-plugin-analytics "Check this project's build status on TravisCI")
[![NPM version](https://img.shields.io/npm/v/docpad-plugin-analytics.svg)](https://www.npmjs.com/package/docpad-plugin-analytics "View this project on NPM")
[![NPM downloads](https://img.shields.io/npm/dm/docpad-plugin-analytics.svg)](https://www.npmjs.com/package/docpad-plugin-analytics "View this project on NPM")

Retrieves [Google Analytics](https://www.google.com/analytics/) data using serverside authentication via the [embed api](https://ga-dev-tools.appspot.com/embed-api/server-side-authorization/). Google returns analytic data in the form of a JSON object which can be used to produce tables, charts and reports. The plugin does not create these reports - just retrieves the data (which is really the hard part). Once you have the data it is simple enough to use something like [Chart.js](http://www.chartjs.org/) to create nice visual charts. The charts example shows how to do this. The data returned from the plugin is an abbreviated version of that returned from google. 
````json
{

    "totalResults": 20,
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

In docpad.coffee file configure the google analytics id for your site.

````coffee
    plugins:
        analytics:
            qryId: 'ga:123456789'
````
Each analytics query is identified by an `endPoint`. The `endPoint` parameter is appended to the base dataURL, by default, `/analytics/data`. So to retrieve the `uniquePageviews` query your application needs to make a call to `/analytics/data/uniquePageviews`.

```js
    $.getJSON('/analytics/data/uniquePageviews',function(data){
        $('#results pre').html(JSON.stringify(data,null,4));
    });
```
The endpoints for the default, built in queries are:
* "30daysPageviews"
````coffee
    'metrics': 'ga:uniquePageviews'
    'dimensions': 'ga:pageTitle'
    'start-date': '30daysAgo'
    'end-date': 'yesterday'
````
* "uniquePageviews"   
        alias for "30daysPageviews"
* "7daysPageviews"
````coffee
    'metrics': 'ga:uniquePageviews'
    'dimensions': 'ga:pageTitle'
    'start-date': '7daysAgo'
    'end-date': 'yesterday'
````
* "yesterdayPageviews"
````coffee
    'metrics': 'ga:uniquePageviews'
    'dimensions': 'ga:pageTitle'
    'start-date': 'yesterday'
    'end-date': 'yesterday'
````
* "60daySessions"
````coffee
    'metrics': 'ga:sessions'
    'dimensions': 'ga:date'
    'start-date': '60daysAgo'
    'end-date': 'yesterday'
````
* "30dayCountry"
````coffee
    'metrics': 'ga:sessions'
    'dimensions': 'ga:country,ga:countryIsoCode'
    'start-date': '30daysAgo'
    'end-date': 'yesterday'
````
* "7daysCountry"
````coffee
    'metrics': 'ga:sessions'
    'dimensions': 'ga:country,ga:countryIsoCode'
    'start-date': '7daysAgo'
    'end-date': 'yesterday'
````
* "yesterdayCountry"
````coffee
    'metrics': 'ga:sessions'
    'dimensions': 'ga:country,ga:countryIsoCode'
    'start-date': 'yesterday'
    'end-date': 'yesterday'
````
* "browserAndOS"
````coffee
    'metrics': 'ga:sessions'
    'dimensions': 'ga:browser,ga:browserVersion,ga:operatingSystem,ga:operatingSystemVersion'
    'start-date': '30daysAgo'
    'end-date': 'yesterday'
````
* "timeOnSite"
````coffee
    'metrics': 'ga:sessions,ga:sessionDuration'
    'start-date': '30daysAgo'
    'end-date': 'yesterday'
````
* "trafficSources"
````coffee
    'metrics': 'ga:sessions,ga:pageviews,ga:sessionDuration,ga:exits'
    'dimensions': 'ga:source,ga:medium'
    'start-date': '30daysAgo'
    'end-date': 'yesterday'
````
* "keywords"
````coffee
    'metrics': 'ga:sessions'
    'dimensions': 'ga:keyword'
    'start-date': '30daysAgo'
    'end-date': 'yesterday'
````

To build and test queries use google's [query explorer](https://ga-dev-tools.appspot.com/query-explorer/)