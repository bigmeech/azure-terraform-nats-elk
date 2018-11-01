const fastify = require('fastify');
const helmet = require('fastify-helmet');
const responseTime = require('fastify-response-time');
const { publisher: publisherConfig, messaging } = require('../config');
const routes = require('./routes');
const config = {
  logger: true
};

const app = fastify(config);
app.register(helmet);
app.register(responseTime);

app.post('/api/notify', routes);

app.listen(publisherConfig.port, (err, address) => {
  if (err) {
    app.log.error(err);
    process.exit(1)
  }
});