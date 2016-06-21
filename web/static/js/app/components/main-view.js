import React from 'react';
import { connect } from 'react-redux';
import TasksView from './tasks-view';
import { createTask } from '../ducks/tasks';

const MainView = ({
  tasks,
  onAddBtnClicked
}) => {
  return (
    <div className="main-view">
      <a className="btn-add" onClick={onAddBtnClicked}>Add</a>
      <TasksView tasks={tasks}/>
    </div>
  );
};

const mapStateToProps = (state) => {
  return {
    tasks: state.tasks
  };
}

const mapDispatchToProps = (dispatch) => {
  return {
    onAddBtnClicked: () => dispatch(createTask({
      id: (new Date()).getTime(),
      description: 'a task'
    }))
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(MainView);

