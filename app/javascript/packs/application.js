// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import * as ActiveStorage from '@rails/activestorage';
import Rails from '@rails/ujs';
import 'channels';
import 'material-design-lite/material.js';
import Turbolinks from 'turbolinks';
import WebpackerReact from 'webpacker-react';
import App from 'App';

Rails.start();
Turbolinks.start();
ActiveStorage.start();

WebpackerReact.setup({ App });
