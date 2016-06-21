import React from 'react';
import { createTask } from '../ducks/tasks';
import TaskView from './task-view';

const TasksView = ({tasks}) => {
  return (
    <ul className="tasks">
      {
        tasks.map((task) => {
          return <TaskView key={task.id} task={task} />
        })
      }
    </ul>
  );
};

export default TasksView;
