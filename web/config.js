//const MEDIATOR =
//"https://authn.theosirian.com/mediator" +
//"?origin=" +
//encodeURIComponent(location.origin);

const MEDIATOR =
  "https://authn.io/mediator" +
  "?origin=" +
  encodeURIComponent(location.origin);

function getScript(source, callback) {
    var script = document.createElement('script');
    var prior = document.getElementsByTagName('script')[0];
    script.async = 1;

    script.onload = script.onreadystatechange = function( _, isAbort ) {
        if(isAbort || !script.readyState || /loaded|complete/.test(script.readyState) ) {
            script.onload = script.onreadystatechange = null;
            script = undefined;

            if(!isAbort) { if(callback) callback(); }
        }
    };

    script.src = source;
    prior.parentNode.insertBefore(script, prior);
}

setTimeout(() => {
  getScript("didkit/didkit-asm.min.js");
  getScript("main.dart.js");
}, 0);