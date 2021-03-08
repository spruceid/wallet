const store = () => {
  credentialHandlerPolyfill.loadOnce(MEDIATOR).then(async () => {
    const event = await WebCredentialHandler.receiveCredentialEvent();

    const message = {
      credential: event.credential,
      credentialRequestOrigin: event.credentialRequestOrigin,
      hintKey: event.hintKey,
      type: event.type,
    };

    handlerStore(JSON.stringify(message), (data) => {
      const parsed = JSON.parse(data);
      console.log('[STORE]', parsed);
      //if (!response.success) event.respondWith(Promise.resolve(null));
      event.respondWith(Promise.resolve({
        dataType: event.type,
        data: parsed,
      }));
    });
  });
};

window.addEventListener("wallet-ready", store);
