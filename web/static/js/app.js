import React from 'react';
import { Provider } from 'react-redux';
import ReactDOM from 'react-dom';
import MainView from './app/components/main-view'
import socket from './socket';
import { createStore, combineReducers } from 'redux';

let reducer = combineReducers({ tasks });
let store = createStore(reducer, {
  tasks: [
    { description: "a task" }
  ]
});

ReactDOM.render(
  <Provider store={store}>
    <MainView />
  </Provider>,
  document.getElementById('app')
)

