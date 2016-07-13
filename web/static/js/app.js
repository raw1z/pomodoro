import React from 'react';
import { Provider } from 'react-redux';
import thunkMiddleware from 'redux-thunk';
import createLogger from 'redux-logger'
import ReactDOM from 'react-dom';
import MainView from './app/components/main-view'
import socket from './socket';
import { createStore, applyMiddleware, compose, combineReducers } from 'redux';
import tasks from './app/ducks/tasks';
import { fetchTasks } from './app/ducks/tasks';
import { get } from './app/api-client';

const loggerMiddleware = createLogger();
const middelware = [
  thunkMiddleware,
  loggerMiddleware
]

let reducer = combineReducers({ tasks });

let initialState = {
  tasks: []
}

let store = createStore(reducer, initialState, compose(
  applyMiddleware(...middelware),
  window.devToolsExtension ? window.devToolsExtension() : f => f
))

ReactDOM.render(
  <Provider store={store}>
    <MainView />
  </Provider>,
  document.getElementById('app')
)

store.dispatch(fetchTasks())

