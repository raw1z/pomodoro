import React from 'react';
import { createTask } from '../ducks/tasks';
import TaskView from './task-view';

const TasksView = ({tasks}) => {
  let editingTasks = tasks.filter((task) => {
    return task.editing == true;
  });

  let nonEditingTasks = tasks.filter((task) => {
    return task.editing == false;
  });

  return (
    <ul className="tasks">
      { editingTasks.map((task) => {
          return <TaskView key={task.id} task={task} /> })}
      { nonEditingTasks.map((task) => {
          return <TaskView key={task.id} task={task} /> })}
    </ul>
  );
};

export default TasksView;
