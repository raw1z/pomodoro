// Actions
const LOAD   = 'pomodoro/tasks/load';
const CREATE = 'pomodoro/tasks/create';
const UPDATE = 'pomodoro/tasks/update';
const REMOVE = 'pomodoro/tasks/remove';

// Action creators
export function loadTasks(tasks) {
  return { type: LOAD, tasks };
}

export function createTask(attributes) {
  return { type: CREATE, attributes };
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
      return action.tasks;

    case CREATE:
      return [...state, action.attributes]

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
