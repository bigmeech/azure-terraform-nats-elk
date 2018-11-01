const Twilio = require('twilio');
const config = require('../../config');
const nats = require('../../common/nats');

const phoneConfig = config.channels.find( channel => channel.type === 'phone');
const twilioClient = Twilio(phoneConfig.twilio_sid, phoneConfig.twilio_token);

nats.subscribe(phoneConfig.subscription_subject, (msg) => {
  const phoneTarget = msg.targets.find( target => target.channel === 'phone');
  const msgObject = {
    to: (msg.target) || (phoneTarget && phoneTarget.target),
    from: phoneConfig.default_owner,
    body: msg.content
  };
  twilioClient.messages
      .create(msgObject)
      .then(message => console.log('Text msg sent: ', message.sid))
      .catch( err => {
        console.error('Error Sending message', err);
      })
      .done();
});