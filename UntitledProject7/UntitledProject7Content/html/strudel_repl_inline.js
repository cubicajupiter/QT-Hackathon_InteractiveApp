// strudel_repl_inline.js
//
// OFFLINE STRUDEL HOST (PLACEHOLDER)
//
// This file provides a getStrudelHostHtml() function similar to the CDN-based
// version, but with an inline <script> area intended to contain the bundled
// Strudel runtime (e.g. output of a build of @strudel/repl or a consolidated
// subset providing note(), hush(), rev, jux, etc.).
//
// HOW TO USE (integration steps):
// 1. Replace your import in Screen01.ui.qml from:
//        import "html/strudelHost.js" as StrudelHost
//    to instead point to this file, or rename this file to strudelHost.js.
// 2. Remove the INTERNET permission from the Android Manifest if no other
//    network access is needed.
// 3. Paste the actual Strudel bundle contents between the markers
//    === BEGIN STRUDEL BUNDLE === and === END STRUDEL BUNDLE ===.
// 4. Ensure the bundle provides (or you polyfill) the globals/functions:
//        initStrudel(), note(<pattern>), hush(), rev, and that note(...).jux(...).play() works.
//    If the real implementation is absent, the included lightweight placeholders
//    will allow the UI to function silently with diagnostics overlays.
//
// DIAGNOSTICS POPUPS:
// A small in-page diagnostics overlay system is included. QML can call:
//    runJavaScript("window.__qtDiag('Some message')")
// to append new lines. Console errors are also mirrored there.
// The overlay can be toggled visible/hidden by calling:
//    runJavaScript("window.__toggleDiag()")
// or automatically appears on the first error.
//
// Qt 6.9.1 NOTE (based on typical usage pattern):
// - Ensure you have initialized QtWebEngineQuick in C++ before loading QML.
// - QML Import: import QtWebEngine (versioned import remains backwards compatible).
// - For offline WebEngine content loaded via data: URL, all resources (scripts)
//   must be inline. External URLs (including qrc:/) are blocked by standard
//   browser same-origin / data URL restrictions. Hence full inlining here.
//
// DISCLAIMER:
// This is a placeholder scaffold. Replace the placeholder Strudel section with
// a proper minified bundle to achieve sound generation offline.

function getStrudelHostHtml() {
    return `
<!doctype html>
<html>
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Strudel Offline Host</title>
<style>
html,body {
  margin:0; padding:0; background:#101018; color:#EEE; font-family: system-ui, sans-serif;
  font-size:14px;
}
#diagOverlay {
  position:fixed; left:4px; top:4px; right:4px; max-height:45vh;
  background:rgba(0,0,0,0.75); border:1px solid #444; border-radius:8px;
  padding:6px 8px; font-family:monospace; font-size:11px;
  overflow:auto; z-index:999999; backdrop-filter: blur(4px);
  box-shadow:0 0 12px rgba(0,0,0,0.6);
  display:none;
}
#diagOverlay h1 {
  margin:0 0 4px 0; font-size:12px; font-weight:600; letter-spacing:0.5px;
  color:#9fd2ff;
}
.diag-line { margin:0 0 2px 0; white-space:pre-wrap; word-break:break-word; }
.diag-error { color:#ff7575; }
.diag-warn { color:#ffc775; }
#diagOverlay button {
  all:unset; cursor:pointer; padding:2px 6px; margin-left:6px;
  background:#2a2f3a; color:#9fd2ff; border-radius:4px; font-size:11px;
  border:1px solid #445;
}
#diagOverlay button:hover { background:#394252; }
</style>
</head>
<body>
<div id="diagOverlay">
  <h1>Diagnostics
    <button onclick="window.__clearDiag()">Clear</button>
    <button onclick="window.__hideDiag()">Hide</button>
  </h1>
  <div id="diagBody"></div>
</div>

<script>
// ===== Diagnostics overlay helpers =====
(function(){
  const overlay = document.getElementById('diagOverlay');
  const bodyEl = document.getElementById('diagBody');
  let autoShown = false;

  function ensureVisible(auto=false){
     if (!overlay) return;
     if (auto && autoShown) return;
     overlay.style.display = 'block';
     if (auto) autoShown = true;
  }

  function addLine(msg, cls){
     if (!bodyEl) return;
     const div = document.createElement('div');
     div.className = 'diag-line ' + (cls||'');
     const when = new Date().toISOString().split('T')[1].replace('Z','');
     div.textContent = '['+when+'] ' + msg;
     bodyEl.appendChild(div);
     // Keep to last ~500 lines
     if (bodyEl.children.length > 500) {
        bodyEl.removeChild(bodyEl.firstChild);
     }
  }

  window.__qtDiag = function(msg){
     addLine(msg,'');
     ensureVisible();
  };
  window.__qtDiagError = function(msg){
     addLine('ERROR: '+msg,'diag-error');
     ensureVisible(true);
  };
  window.__qtDiagWarn = function(msg){
     addLine('WARN: '+msg,'diag-warn');
     ensureVisible();
  };
  window.__hideDiag = function(){ if (overlay) overlay.style.display='none'; };
  window.__showDiag = function(){ if (overlay) overlay.style.display='block'; };
  window.__toggleDiag = function(){
     if (!overlay) return;
     overlay.style.display = (overlay.style.display==='none'||!overlay.style.display)?'block':'none';
  };
  window.__clearDiag = function(){
     if (bodyEl) bodyEl.innerHTML='';
  };

  // Wrap console to mirror logs
  const cErr = console.error.bind(console);
  const cWarn = console.warn.bind(console);
  const cLog = console.log.bind(console);
  console.error = function(...args){ window.__qtDiagError(args.join(' ')); cErr(...args); };
  console.warn  = function(...args){ window.__qtDiagWarn(args.join(' ')); cWarn(...args); };
  console.log   = function(...args){ window.__qtDiag(args.join(' ')); cLog(...args); };

  window.addEventListener('error', e=>{
     window.__qtDiagError('Unhandled error: ' + (e.message || e.error));
  });
  window.addEventListener('unhandledrejection', e=>{
     window.__qtDiagError('Unhandled promise rejection: ' + (e.reason || e));
  });

  window.__qtDiag('Diagnostics initialized (offline host).');
})();
</script>

<script>
// ===== Placeholder / Polyfill Section =====
// If you paste the real Strudel bundle below, you may remove these placeholders.
// They provide minimal stub behavior so that the UI does not crash when the
// actual engine is not yet bundled. They produce no sound.

(function(global){
  const placeholderMsg = 'Using placeholder Strudel stubs (no audio). Replace with real bundle.';
  global.__qtDiag && global.__qtDiag(placeholderMsg);

  if (typeof global.initStrudel !== 'function') {
     global.initStrudel = function(){
        if (!global.__strudelInitialized) {
           global.__strudelInitialized = true;
           global.__qtDiag && global.__qtDiag('initStrudel() placeholder invoked.');
        }
     };
  }

  function patternObject(str){
     return {
        _p: str,
        jux(fn){
           // placeholder for transformation
           return this;
        },
        play(){
           global.__qtDiag && global.__qtDiag('Playing pattern (placeholder): ' + this._p);
           return this;
        }
     };
  }

  if (typeof global.note !== 'function') {
     global.note = function(pat){
        return patternObject(pat);
     };
  }

  if (typeof global.hush !== 'function') {
     global.hush = function(){
        global.__qtDiag && global.__qtDiag('hush() called (placeholder).');
     };
  }

  if (typeof global.rev === 'undefined') {
     global.rev = function(x){ return x; };
  }

})(window);
</script>

<script>
// ===== REAL STRUDEL BUNDLE INLINED HERE =====
// Replace this entire block with the actual (minified) Strudel distribution.
// Typically you would produce a single JS file via your bundler and paste it.
//
// === BEGIN STRUDEL BUNDLE ===
/*
   PASTE THE MINIFIED STRUDEL BUNDLE CONTENTS HERE.
   Ensure it defines: initStrudel, note, hush, rev (or equivalents).
   After bundling, you can remove the placeholder stubs above if unneeded.
*/
// === END STRUDEL BUNDLE ===
</script>

<script>
// ===== Host glue API (stable interface used by QML) =====
(function(){
  function ensureStrudel(){
     try {
        if (typeof initStrudel === 'function') initStrudel();
     } catch(e){
        console.error('initStrudel invocation failed:', e);
     }
  }

  window.strudelPlayPattern = function(patternCode){
     ensureStrudel();
     try {
        eval(patternCode);
        __qtDiag && __qtDiag('Pattern eval success.');
     } catch(err){
        console.error('Pattern eval error:', err);
     }
  };

  window.strudelStop = function(){
     try {
        if (typeof hush === 'function') hush();
        __qtDiag && __qtDiag('Playback stopped (hush).');
     } catch(e){
        console.error('hush failed:', e);
     }
  };

  __qtDiag && __qtDiag('Offline Strudel host ready.');
})();
</script>

</body>
</html>
`;
}

// Export for QML import (import ".../strudel_repl_inline.js" as StrudelHost)
