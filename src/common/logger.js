const Logger = require('pino');
const config = require('../config');

module.exports = Logger(config.logger);