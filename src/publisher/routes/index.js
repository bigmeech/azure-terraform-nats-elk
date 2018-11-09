const nats = require('../../common/nats');
const logger = require('../../common/logger');
module.exports = function (request, reply) {
  const errors = [];
  const requestPayload = request.body;
  const onPublished = function (err){
    if(err) {
      errors.push(err);
    }
  };

  if(requestPayload.ns) {
    nats.publish(requestPayload.ns, requestPayload, onPublished);
    reply.code(204).send({ message: 'Message delivered to subscribers'});
    return;
  }

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
};