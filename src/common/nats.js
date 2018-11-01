const Nats = require('nats');

module.exports = Nats.connect({
  url: 'nats://gnatsd01.uksouth.cloudapp.azure.com:4222',
  json: true
});

