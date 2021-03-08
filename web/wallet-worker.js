const handler = async () => {
  const port = chrome.runtime.connect();

  const callback = (data) => {
    const parsed = JSON.parse(data);
    port.postMessage(parsed);
  };

  const types = {
    "get": handlerGet,
    "store": handlerStore,
  };

  port.onMessage.addListener(({ type, origin, event }) => {
    const message = { event, origin };

    const json = JSON.stringify(message);

    if (!(type in types))
      throw new Error("Invalid event type!");

    types[type](json, callback);
  });

  port.onDisconnect.addListener(window.close);
};

window.addEventListener("wallet-ready", handler);
