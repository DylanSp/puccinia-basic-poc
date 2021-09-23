import init, { say_hello } from "./pucciniabasicpoc_nif.js";

init();
document.getElementById("client-hello").addEventListener("click", () => {
  alert(say_hello("Mr. Sprague"));
});
