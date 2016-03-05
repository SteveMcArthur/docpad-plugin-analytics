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
                
                test 'plugin config should have credentials property', (done) ->
                    config = plugin.getConfig()
                    expect(config).to.have.property('credentials')
                    done()
                    
                test 'plugin config should have credentials.client_id property', (done) ->
                    credentials = plugin.getConfig().credentials
                    expect(credentials).to.have.property('client_id')
                    done()
                    
                test 'plugin should have jwtClient property', (done) ->
                    expect(plugin).to.have.property('jwtClient')
                    done()
                    

                test 'server should return json object when calling last30days', (done) ->
                    fileUrl = "#{baseUrl}/last30days"
                    request fileUrl, (err,response,actual) ->
                        return done(err)  if err
                        obj = JSON.parse(response)
                        expect(obj).to.have.property('rows')
                        done()
                        
                test 'server should return json object when calling last7days', (done) ->
                    fileUrl = "#{baseUrl}/last7days"
                    request fileUrl, (err,response,actual) ->
                        return done(err)  if err
                        obj = JSON.parse(response)
                        expect(obj).to.have.property('rows')
                        done()
                        
                test 'server should return json object when calling yesterdayh', (done) ->
                    fileUrl = "#{baseUrl}/yesterday"
                    request fileUrl, (err,response,actual) ->
                        return done(err)  if err
                        obj = JSON.parse(response)
                        expect(obj).to.have.property('rows')
                        done()