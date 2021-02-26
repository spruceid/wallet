const handler = async () => {
  try {
    await credentialHandlerPolyfill.loadOnce(MEDIATOR);
  } catch (e) {
    console.error("Error in loadOnce:", e);
  }

  const registration = await WebCredentialHandler.installHandler({
    url: `${location.origin}/index.html`,
  });

  await registration.credentialManager.hints.set("test", {
    name: "User",
    enabledTypes: ["VerifiablePresentation", "VerifiableCredential"],
  });

  return WebCredentialHandler.activateHandler({
    mediatorOrigin: MEDIATOR,
    get: (_) => ({
        type: 'redirect',
        url: `${location.origin}/get.html`,
    }),
    store: (_) => ({
        type: 'redirect',
        url: `${location.origin}/store.html`,
    }),
  });
};

window.addEventListener("load", handler);
