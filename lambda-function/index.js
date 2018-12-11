'use strict';

// Configuring the AWS SDK
var AWS = require('aws-sdk');
AWS.config.update({region: 'eu-west-1'});
console.log('Loading hello world function');

exports.handler = function(event, context, callback) {
    let message = 'Hello World';
    let responseCode = 200;
    console.log("request: " + JSON.stringify(event));

    var responseBody = {
        message: message,
    };

    var response = {
        statusCode: responseCode,
// We do not need any additional headers
//         headers: {
//             "x-custom-header" : "my custom header value"
//         },
        body: JSON.stringify(responseBody)
    };


    console.log("response: " + JSON.stringify(response))
    callback(null, response);
};



