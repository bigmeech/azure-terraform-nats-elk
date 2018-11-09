const request = require('got');

const config = require('../../config');
const nats = require('../../common/nats');
const emailConfig = config.channels.find( channel => channel.type === 'email');
const apiKey = emailConfig.email_api_key;

/**
 * get information about user(s) from another source
 * @param emailTarget
 * @param msg
 */
function buildTxList(emailTarget, msg) {
  let target;
  if(!msg.target){
    target = emailTarget && emailTarget.target
  } else {
    target = msg.target;
  }

  return [
    { name: 'Larry Eliemenye' },
    { email: target }
  ]
}

/**
 * nats subscriber handler
 * @param msg
 */
function onNatsSubscribe(msg) {
  const emailTarget = msg.targets.find( target => target.channel === 'email');
  const txList = buildTxList(msg, emailTarget);
  const msgObject = {
    to: txList,
    from: emailConfig.default_owner,
    subject: msg.title,
    text: msg.content
  };

  request.post(1, emailTo).then(response => {
    console.log('Message success', response);
  }).catch(err => {
    console.error('Error happened', err);
  });
}

nats.subscribe(emailConfig.subscription_subject, onNatsSubscribe);