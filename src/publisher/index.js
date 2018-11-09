require('dotenv').config();

const fastify = require('fastify');
const helmet = require('fastify-helmet');
const responseTime = require('fastify-response-time');
const logger = require('../common/logger');
const appConfig = require('../config');
const routes = require('./routes');

// config
const config = {
  logger: logger
};

const app = fastify(config);
app.register(helmet);
app.register(responseTime);

app.post('/api/notify', routes);

app.listen(appConfig.publisher.port, (err, address) => {
  if (err) {
    app.log.error(err);
    process.exit(1)
  }
});