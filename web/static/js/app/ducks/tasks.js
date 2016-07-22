import { get, post } from '../api-client';

// Actions
const LOAD    = 'pomodoro/tasks/load';
const NEW     = 'pomodoro/tasks/new';
const CREATE  = 'pomodoro/tasks/create';
const UPDATE  = 'pomodoro/tasks/update';
const REMOVE  = 'pomodoro/tasks/remove';

// Action creators
export function fetchTasks() {
  return dispatch => {
    get('/tasks').then((tasks) => {
      dispatch(loadTasks(tasks));
    });
  }
}

export function loadTasks(tasks) {
  return { type: LOAD, tasks };
}

export function newTask(attributes) {
  return { type: NEW }
}

export function createTask(task) {
  return dispatch => {
    post('/tasks', {task: task}).then((task) => {
      dispatch({ type: CREATE, task });
    });
  };
}

export function updateTask(id, attributes) {
  return { type: UPDATE, id, attributes };
}

export function removeTasks(id) {
  return { type: REMOVE, id };
}

// Reducer
export default function reducer(state={}, action={}) {
  switch(action.type) {
    case LOAD:
      return action.tasks.map((task) => {
        return Object.assign({}, task, {editing: false});
      });

    case NEW:
      let newTask = {
        id: (new Date()).getTime(),
        description: "",
        done: false,
        editing: true
      }
      return [...state, newTask];

    case CREATE:
      let task = Object.assign({}, action.task, {editing: false})
      return [...state, task];

    case UPDATE:
      return state.map((task) => {
        if (task.id === action.id) {
          return Object.assign({}, task, action.attributes);
        }
        else {
          return task;
        }
      })

    case REMOVE:
      return state;

    default: return state
  }
}
