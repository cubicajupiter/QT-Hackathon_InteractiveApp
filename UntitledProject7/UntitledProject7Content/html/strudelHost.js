// strudelHost.js
// Provides a function that returns the host HTML for Strudel as a string.
// The host exposes two global functions:
//   window.strudelPlayPattern(patternCode)
//   window.strudelStop()
//
// patternCode is expected to be a JS snippet string that will be eval'd in page context.
// NOTE: This uses the CDN @strudel/repl for convenience. For production (Android) bundle
// the Strudel scripts locally and replace the script src below.

function getStrudelHostHtml() {
    return `
<!doctype html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Strudel Host</title>
  <!-- Development: CDN. For production, bundle @strudel/repl locally and reference it -->
  <script src="https://unpkg.com/@strudel/repl@latest"></script>
</head>
<body>
  <script>
    function ensureStrudel() {
      try {
        if (typeof initStrudel === "function") initStrudel();
      } catch (e) {
        console.warn("initStrudel not available or failed:", e);
      }
    }

    window.strudelPlayPattern = function(patternCode) {
      ensureStrudel();
      try {
        eval(patternCode);
      } catch (err) {
        console.error("strudelPlayPattern eval error:", err, patternCode);
      }
    };

    window.strudelStop = function() {
      try { if (typeof hush === "function") hush(); } catch (e) { console.warn("strudelStop failed:", e); }
    };

    // tiny keepalive to indicate ready
    console.log("Strudel host loaded");
  </script>
</body>
</html>
`;
}

// expose function for import
// In QML you will use StrudelHost.getStrudelHostHtml()
