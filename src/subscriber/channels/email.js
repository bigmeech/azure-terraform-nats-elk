const sendgrid = require('@sendgrid/mail');

const config = require('../../config');
const nats = require('../../common/nats');

const emailConfig = config.channels.find( channel => channel.type === 'email');

sendgrid.setApiKey(emailConfig.sendgrid_api_key);

nats.subscribe(emailConfig.subscription_subject, (msg) => {
  const emailTarget = msg.targets.find( target => target.channel === 'email');
  const msgObject = {
    to: (msg.target) || (emailTarget && emailTarget.target),
    from: emailConfig.default_owner,
    subject: msg.title,
    text: msg.content
  };
  sendgrid.send(msgObject).then(response => {
    console.log('Message success', msgObject);
  }).catch(err => {
    console.error('Error happened', err);
  });
});