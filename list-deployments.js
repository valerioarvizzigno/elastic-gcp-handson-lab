#!/usr/bin/env node

// usage:
// terraform output -json | ./list-deployments.js

var stdin = process.stdin,
  stdout = process.stdout,
  inputChunks = [];

stdin.resume();
stdin.setEncoding('utf8');

stdin.on('data', function (chunk) {
  inputChunks.push(chunk);
});

stdin.on('end', function () {
  var inputJSON = inputChunks.join();
  var data = JSON.parse(inputJSON);

  for (i = 0; i < data.deployment_names.value[0].length; i++) {
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
  }

  stdout.write('\n');
  stdout.write('\n');
});
