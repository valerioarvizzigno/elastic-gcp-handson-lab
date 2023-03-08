#!/usr/bin/env node

// usage:
// terraform output -json | ./list-deployments.js
 

var stdin = process.stdin,
  stdout = process.stdout,
  inputChunks = [],
  fs = require('fs');



stdin.resume();
stdin.setEncoding('utf8');

stdin.on('data', function (chunk) {
  inputChunks.push(chunk);
});

stdin.on('end', function () {
  var inputJSON = inputChunks.join();
  var data = JSON.parse(inputJSON);
  
  //next 2 lines are used to write console output also to a file, so it's easier to share endpoints
  var file_writer = fs.createWriteStream('./created_deployments_summary.txt', {flags: 'w'});

  //Next line completely ovverides console output with file output. Use only if you dont want to print to console but only to file
  //process.stdout.write = process.stderr.write = file_writer.write.bind(file_writer);

  for (i = 0; i < data.deployment_names.value[0].length; i++) {
    //write to console
    stdout.write('\n');
    stdout.write('\n');
    stdout.write(`Deployment: ${data.deployment_names.value[0][i]}\n`);
    stdout.write(
      `  kibanaEndpoint  = "${data.kibana_endpoints.value[0][i]}"\n`
    );
    stdout.write(
      `  adminUsername   = "${data.elasticsearch_usernames.value[0][i]}"\n`
    );
    stdout.write(
      `  adminPassword   = "${data.elasticsearch_passwords.value[0][i]}"\n`
    );
    stdout.write(
      `  elasticEndpoint = "${data.elasticsearch_endpoints.value[0][i]}"\n`
    );
    stdout.write(
      `  cloudId         = "${data.elasticsearch_cloud_ids.value[0][i]}"\n`
    );

    //write to file
    file_writer.write('\n');
    file_writer.write('\n');
    file_writer.write(`Deployment: ${data.deployment_names.value[0][i]}\n`);
    file_writer.write(
      `  kibanaEndpoint  = "${data.kibana_endpoints.value[0][i]}"\n`
    );
    file_writer.write(
      `  adminUsername   = "${data.elasticsearch_usernames.value[0][i]}"\n`
    );
    file_writer.write(
      `  adminPassword   = "${data.elasticsearch_passwords.value[0][i]}"\n`
    );
    file_writer.write(
      `  elasticEndpoint = "${data.elasticsearch_endpoints.value[0][i]}"\n`
    );
    file_writer.write(
      `  cloudId         = "${data.elasticsearch_cloud_ids.value[0][i]}"\n`
    );
  }

  file_writer.write('\n');
  file_writer.write('\n');
});
