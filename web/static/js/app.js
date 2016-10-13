import socket from './socket';

var app = Elm.Pomodoro.fullscreen();

let timerChannel = socket.channel("tasks:crud", {});
timerChannel.join()
  .receive("ok", resp => { console.log("Joined successfully 'tasks:crud': ", resp) })
  .receive("error", resp => { console.log("Unable to join 'tasks:crud': ", resp) });

timerChannel.on("start", payload => {
  app.ports.start.send(payload);
});

timerChannel.on("timesup", (payload) => {
  app.ports.timesup.send(payload);
});

app.ports.run.subscribe((payload) => {
  timerChannel.push("run", payload)
});
