import socket from './socket';

var app = Elm.Pomodoro.fullscreen();

let timerChannel = socket.channel("tasks:crud", {});
timerChannel.join()
  .receive("error", resp => { console.log("Unable to join 'tasks:crud': ", resp) })
  .receive("ok", resp => {
    console.log("Joined successfully 'tasks:crud': ", resp);
  });

timerChannel.on("start", payload => {
  app.ports.start.send(payload);
});

timerChannel.on("timesup", (payload) => {
  app.ports.timesup.send(payload);
});

timerChannel.on("status", (payload) => {
  app.ports.getStatus.send(payload);
});

app.ports.run.subscribe((payload) => {
  timerChannel.push("run", payload)
});

function restorePersistedState() {
  try {
    let persistedState = localStorage.getItem('pomodoro')
    let tasks = JSON.parse(persistedState);
    if (tasks != null) {
      app.ports.getPersistedState.send(tasks);
    }
  } catch(e) {
    console.log(`failed restoring persisted state: ${e.message}`);
  }
}

app.ports.requestStatus.subscribe(() => {
  restorePersistedState();
  timerChannel.push("status", {});
});

app.ports.saveTasks.subscribe((tasks) => {
  localStorage.setItem('pomodoro', JSON.stringify(tasks));
});

