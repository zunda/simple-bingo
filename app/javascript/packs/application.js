// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage"
// import "channels"
// We will import channels from Vue components
import initVueApp from "@/main.js"

initVueApp()
Rails.start()
ActiveStorage.start()
