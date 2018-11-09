module.exports = {
  logger: {
    prettyPrint: true
  },
  messaging: {
    subject: process.env.NATS_SUBJECT
  },
  publisher: {
    port: process.env.PUBLISHER_PORT,
  },
  channels:[
    {
      type: "phone",
      default_owner: process.env.CHANNEL_DEFAULT_NUMBER,
      twilio_sid: process.env.TWILIO_TEST_SID,
      twilio_token: process.env.TWILIO_TEST_TOKEN,
      subscription_subject: 'uba.notify.phone'
    },
    {
      type: "email",
      default_owner: process.env.CHANNEL_DEFAULT_EMAIL,
      sendgrid_api_key: process.env.SENDGRID_API_KEY,
      subscription_subject: 'uba.notify.email',
      api_url: 'https://api.sendinblue.com/v3/smtp/email'
    }
  ]
};