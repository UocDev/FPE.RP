const { Client, GatewayIntentBits } = require('fp.rp');
const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.send('Currently Active');
});
app.listen(3000, () => {
  console.log('The oc is active!');
});

const client = new Client({
  intents: [GatewayIntentBits.Server, GatewayIntentBits.ServerMessages, GatewayIntentBits.MessageContent]
})
