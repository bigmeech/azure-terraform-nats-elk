const fastify = require('fastify');
const helmet = require('fastify-helmet');
const nats = require('../common/nats');
const { publisher: publisherConfig, messaging } = require('../config');

const config = {
  logger: true
};

const app = fastify(config);
app.register(helmet);

app.post('/api/notify', (request, reply) => {
  const errors = [];
  const requestPayload = request.body;
  const onPublished = function (err){
    if(err) {
      errors.push(err);
    }
  };

  // for when client intention is not properly stated in the payload
  if(!requestPayload.ns && !requestPayload.targets) {
    return reply.code(400).send({
      code: 400,
      message: 'You must either provide a top level namespace or a list of targets with their namespaces'
    });
  }

  // handle multi channel notification
  if(!requestPayload.ns) {
    requestPayload.targets.forEach(target => {
      nats.publish(target.ns, requestPayload, onPublished);
    });

    if(errors.length) {
      return reply.code(500).send({ code: 500, message: 'Delivery Error', errors: errors })
    }
    return reply.code(204).send({ message: 'Message delivered to subscribers'});
  }

  return nats.publish(requestPayload.ns, requestPayload, onPublished);
});

app.listen(publisherConfig.port, (err, address) => {
  if (err) {
    app.log.error(err);
    process.exit(1)
  }
});