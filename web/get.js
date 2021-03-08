const get = () => {
  credentialHandlerPolyfill.loadOnce(MEDIATOR).then(async () => {
    const event = await WebCredentialHandler.receiveCredentialEvent();

    const message = {
      credentialRequestOptions: event.credentialRequestOptions,
      credentialRequestOrigin: event.credentialRequestOrigin,
      hintKey: event.hintKey,
      type: event.type,
    };

    handlerGet(JSON.stringify(message), (data) => {
      const parsed = JSON.parse(data);
      console.log('[GET]', parsed);

      //if (!response.success) event.respondWith(
        //Promise.resolve({ dataType: "Response", data: "error" })
      //);

      event.respondWith(
        Promise.resolve({
          dataType: "VerifiablePresentation",
          data: parsed,
        })
      );
    });
  });
};

window.addEventListener("wallet-ready", get);
