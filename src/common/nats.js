const Nats = require('nats');

module.exports = Nats.connect({
  url: 'nats://gnats-0.westeurope.cloudapp.azure.com:4222',
  json: true
});

