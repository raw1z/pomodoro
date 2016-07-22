import React from 'react';

const EditingTaskView = ({task}) => {
  let input;

  return (
    <li className="task editing">
      <form>
        <div className="done">
          <input type="checkbox" disabled="disabled" />
        </div>

        <div className="description">
          <input type="text" value={task.description} ref={node => { input = node }} />
        </div>

        <div className="actions">
          <button type="submit">save</button>
        </div>
      </form>
    </li>
  );
}

const NonEditingTaskView = ({task}) => {
  return (
    <li className="task non-editing">
      <div className="done">
        <input type="checkbox" />
      </div>

      <div className="description">
        {task.description}
      </div>

      <div className="actions">
        <a>start</a>
        <a>edit</a>
        <a>delete</a>
      </div>
    </li>
  );
}

const TaskView = ({task}) => {
  if (task.editing) {
    return <EditingTaskView task={task} />;
  }
  else {
    return <NonEditingTaskView task={task} />;
  }
};

export default TaskView;

