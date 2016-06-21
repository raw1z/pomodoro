import React from 'react';
import { Provider } from 'react-redux';
import createLogger from 'redux-logger'
import ReactDOM from 'react-dom';
import MainView from './app/components/main-view'
import socket from './socket';
import { createStore, applyMiddleware, combineReducers } from 'redux';
import tasks from './app/ducks/tasks';

const loggerMiddleware = createLogger();
const createStoreWithMiddleware = applyMiddleware(loggerMiddleware)(createStore);

let reducer = combineReducers({ tasks });
let store = createStoreWithMiddleware(reducer, {
  tasks: [
    {
      id: (new Date()).getTime(),
      description: "a task"
    }
  ]
});

ReactDOM.render(
  <Provider store={store}>
    <MainView />
  </Provider>,
  document.getElementById('app')
)

