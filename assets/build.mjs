// borrowed from https://hexdocs.pm/phoenix/1.6.0-rc.1/asset_management.html
// and https://github.com/evanw/esbuild/issues/408#issuecomment-757555771

import { build } from "esbuild";
import path from "path";
import fs from "fs";
import { execSync } from "child_process";

const args = process.argv.slice(2);
const watch = args.includes("--watch");
const deploy = args.includes("--deploy");

const buildWasm = () => {
  const projectName = "pucciniabasicpoc";
  const nativeFolderName = `${projectName}_rs`;

  execSync("wasm-pack build --target web", {
    cwd: path.join("..", "native", nativeFolderName),
  });

  const files = [`${nativeFolderName}.js`, `${nativeFolderName}_bg.wasm`];

  fs.mkdirSync(path.join("js", "pkg"), {
    recursive: true,
  });
  for (const file of files) {
    const sourcePath = path.join("..", "native", nativeFolderName, "pkg", file);
    const targetPath = path.join("js", "pkg", file);
    fs.copyFileSync(sourcePath, targetPath);
  }
};

let wasmPlugin = {
  name: "wasm",
  setup(build) {
    // Resolve ".wasm" files to a path with a namespace
    build.onResolve({ filter: /\.wasm$/ }, (args) => {
      // Resolve relative paths to absolute paths here since this
      // resolve callback is given "resolveDir", the directory to
      // resolve imports against.
      if (args.resolveDir === "") {
        return; // Ignore unresolvable paths
      }
      return {
        path: path.isAbsolute(args.path)
          ? args.path
          : path.join(args.resolveDir, args.path),
        namespace: "wasm-binary",
      };
    });

    // Virtual modules in the "wasm-binary" namespace contain the
    // actual bytes of the WebAssembly file. This uses esbuild's
    // built-in "binary" loader instead of manually embedding the
    // binary data inside JavaScript code ourselves.
    build.onLoad({ filter: /.*/, namespace: "wasm-binary" }, async (args) => ({
      contents: await fs.promises.readFile(args.path),
      loader: "binary",
    }));
  },
};

const loader = {
  // Add loaders for images/fonts/etc, e.g. { '.svg': 'file' }
};

const plugins = [wasmPlugin];

let opts = {
  entryPoints: ["js/app.js"],
  bundle: true,
  target: "es2020",
  outdir: "../priv/static/assets",
  logLevel: "info",
  loader,
  plugins,
};

if (watch) {
  opts = {
    ...opts,
    watch,
    sourcemap: "inline",
  };
}

if (deploy) {
  opts = {
    ...opts,
    minify: true,
  };
}

buildWasm();
const promise = build(opts);

if (watch) {
  promise.then((_result) => {
    process.stdin.on("close", () => {
      process.exit(0);
    });

    process.stdin.resume();
  });
}
