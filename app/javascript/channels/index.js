// app/javascript/channels/index.js

// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

const channels = require.context('.', true, /\.js$/)
channels.keys().forEach(channels)