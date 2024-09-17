// YAML TO JSON
// CHANGE VERSION
// THEN JSON TO YAML AND WRITE TO FILE

const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');

const newVersion = process.argv[2];
if (!newVersion) {
  console.error('Error: No version specified.');
  process.exit(1);
}

const chartFilePath = 'charts/kexa-chart/Chart.yaml';

if (!fs.existsSync(chartFilePath)) {
  console.error(`Error: ${chartFilePath} not found.`);
  process.exit(1);
}

let fileContent = fs.readFileSync(chartFilePath, 'utf8');
let chartData;

try {
  chartData = yaml.load(fileContent);
} catch (e) {
  console.error('Error parsing YAML:', e);
  process.exit(1);
}

if (chartData.version) {
  chartData.version = newVersion;
  console.log(`Updating version to ${newVersion}`);
} else {
  console.error('Version field not found in Chart.yaml.');
  process.exit(1);
}

const updatedYaml = yaml.dump(chartData);
fs.writeFileSync(chartFilePath, updatedYaml, 'utf8');
console.log(`Updated ${chartFilePath} to version ${newVersion}`);