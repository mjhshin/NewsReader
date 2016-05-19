'use strict';
let https = require('https');
var AWS = require("aws-sdk");
var fs = require('fs');
var moment = require('moment');

let options = {
    hostname: 'api.nytimes.com',
    path: '/svc/topstories/v2/home.json?api-key=70c209505f4dbaa2c67103044e24c4ec:8:60698120',
    method: 'GET'
};

/**
* Pass the data to send as `event.data`, and the request options as
* `event.options`. For more information see the HTTPS module documentation
* at https://nodejs.org/api/https.html.
*
* Will succeed with the response body.
*/
exports.handler = (event, context, callback) => {
    const req = https.request(options, (res) => {
        //console.log('Status:', res.statusCode);
        //console.log('Headers:', JSON.stringify(res.headers));

        let body = '';

        res.setEncoding('utf8');
        res.on('data', (chunk) => body += chunk);
        res.on('end', () => {
            //console.log('Successfully processed HTTPS response');
            //console.log('NYT Response:', body);
            if (res.headers['content-type'] === 'application/json') {
                body = JSON.parse(body);

                if(body.status === 'OK') {
                    var dynamo = new AWS.DynamoDB();

                    // Debug - Check DB NewYorkTimesArticle
                    var paramsArticle = {
                        TableName: 'newsreader-mobilehub-429622615-NewYorkTimesArticle'
                    };
                    dynamo.describeTable(paramsArticle, function(err, data) {
                        if (err) console.log(err, err.stack); // an error occurred
                        else     console.log(data);           // successful response
                    });

                    // Write to DB NewYorkTimesArticle
                    var docClient = new AWS.DynamoDB.DocumentClient();
                    body.results.forEach(function(article) {
                        //console.log('ARTICLE:', article.title);
                        var params = {
                            TableName: "newsreader-mobilehub-429622615-NewYorkTimesArticle",
                            Item: {
                                "abstract": article.abstract === '' ? null : article.abstract,
                                "byline": article.byline === '' ? null : article.byline,
                                "publish_date": article.published_date,
                                "section": article.section === '' ? null : article.section,
                                "subsection": article.subsection === '' ? null : article.subsection,
                                "title": article.title,
                                "url": article.url
                            }
                        };

                        // TODO: Make this a batch write
                        docClient.put(params, function(err, data) {
                            if (err) {
                                console.error("Unable to add article", article.title, ". Error JSON:", JSON.stringify(err, null, 2));
                            } else {
                                console.log("PutItem succeeded:", article.title);
                            }
                        });
                    });

                    // Debug - Check DB NewYorkTimesArticleSet
                    var paramsArticleSet = {
                        TableName: 'newsreader-mobilehub-429622615-NewYorkTimesArticleSet'
                    };
                    dynamo.describeTable(paramsArticleSet, function(err, data) {
                        if (err) console.log(err, err.stack); // an error occurred
                        else     console.log(data);           // successful response
                    });

                    var minutes = 1000 * 60;
                    var hours = minutes * 60;
                    var days = hours * 24;
                    var timestamp = new Date().getTime();

                    var date = Math.round(timestamp / days);

                    // Write to DB NewYorkTimesArticleSet
                    var params = {
                        TableName: "newsreader-mobilehub-429622615-NewYorkTimesArticleSet",
                        Item: {
                            "date": date,
                            "timestamp": timestamp,
                            "articles": body.results.map(function(a) {return a.url;}),
                            "num_articles": body.num_results
                        }
                    };

                    docClient.put(params, function(err, data) {
                        if (err) {
                            console.error("Unable to add article set. Error JSON:", JSON.stringify(err, null, 2));
                        } else {
                            console.log("PutItem succeeded on article set");
                        }
                    });
                }
            }
            callback(null);
        });
    });
    req.on('error', callback);
    req.end();
};
