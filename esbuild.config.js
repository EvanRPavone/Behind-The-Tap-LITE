const esbuild = require('esbuild');
const sassPlugin = require('esbuild-plugin-sass');

const isWatchMode = process.argv.includes('--watch');

const buildOptions = {
  entryPoints: ['app/javascript/application.js'],
  bundle: true,
  sourcemap: true,
  outdir: 'app/assets/builds',
  loader: { '.scss': 'css', '.css': 'css', '.woff2': 'file', '.ttf': 'file' },
  plugins: [sassPlugin()],
  resolveExtensions: ['.js', '.scss', '.css'],
  define: {
    global: 'window',
  },
};

async function build() {
  if (isWatchMode) {
    const ctx = await esbuild.context(buildOptions);
    await ctx.watch();
    console.log('Watching for changes...');
  } else {
    await esbuild.build(buildOptions);
    console.log('Build complete.');
  }
}

build().catch(() => process.exit(1));
