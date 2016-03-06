# Export Plugin Tester
module.exports = (testers) ->
    # PRepare
    {expect} = require('chai')
    request = require('request')
    fs = require('fs')
    util = require('util')

    # Define My Tester
    class AnalyticsTester extends testers.ServerTester
        # Test Generate
        testGenerate: testers.RendererTester::testGenerate

        # Custom test for the server
        testServer: (next) ->
            # Prepare
            tester = @

            # Create the server
            super

            # Test
            @suite 'analytics', (suite,test) ->
                # Prepare
                baseUrl = "http://localhost:9778/analytics/data"
                
                outExpectedPath = tester.config.outExpectedPath
                plugin = tester.docpad.getPlugin('analytics')
                
                test 'plugin config should have queries property', (done) ->
                    config = plugin.getConfig()
                    expect(config).to.have.property('queries')
                    done()
                    
                test 'plugin config should have credentialsFile property', (done) ->
                    config = plugin.getConfig()
                    expect(config).to.have.property('credentialsFile')
                    done()
                    
                test 'plugin should have jwtClient property', (done) ->
                    expect(plugin).to.have.property('jwtClient')
                    done()
                    
                ###
                test 'server should return json object when calling uniquePageviews', (done) ->
                    fileUrl = "#{baseUrl}/uniquePageviews"
                    request fileUrl, (err,response,actual) ->
                        return done(err)  if err
                        obj = JSON.parse(response)
                        expect(obj).to.have.property('rows')
                        done()
                ###