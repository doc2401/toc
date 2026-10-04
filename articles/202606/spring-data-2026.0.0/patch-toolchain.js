const fs = require('fs');
const path = require('path');

const projectRoot = __dirname;
const antoraToolingDir = path.join(projectRoot, 'antora-tooling');

console.log('--- Spring Data Documentation Build Fix & Patch Script ---');

// 1. Patch fd-slicer.js inside yauzl
const fdSlicerPath = path.join(antoraToolingDir, 'node_modules/yauzl/fd-slicer.js');
if (fs.existsSync(fdSlicerPath)) {
  console.log(`Patching ${fdSlicerPath}...`);
  let content = fs.readFileSync(fdSlicerPath, 'utf8');
  
  const target = `  if (toRead <= 0) {
    self.destroyed = true;
    self.push(null);
    self.context.unref();
    return;
  }`;
  
  const replacement = `  if (toRead <= 0) {
    self.push(null);
    return;
  }`;

  const targetDestroy = `ReadStream.prototype.destroy = function(err) {
  if (this.destroyed) return;
  err = err || new Error("stream destroyed");
  this.destroyed = true;
  this.emit('error', err);
  this.context.unref();
};`;

  const replacementDestroy = `ReadStream.prototype.destroy = function(err) {
  if (this.destroyed) return;
  this.destroyed = true;
  this.context.unref();
  if (err) {
    this.emit('error', err);
  }
};`;
  
  let modified = false;

  if (content.includes(target)) {
    content = content.replace(target, replacement);
    modified = true;
    console.log('Successfully patched fd-slicer.js EOF check');
  }
  
  if (content.includes(targetDestroy)) {
    content = content.replace(targetDestroy, replacementDestroy);
    modified = true;
    console.log('Successfully patched fd-slicer.js ReadStream.destroy');
  }

  if (modified) {
    fs.writeFileSync(fdSlicerPath, content, 'utf8');
  } else if (content.includes(replacement) && content.includes(replacementDestroy)) {
    console.log('fd-slicer.js is already patched.');
  } else {
    console.warn('Warning: Could not find target content in fd-slicer.js');
  }
} else {
  console.warn(`Warning: ${fdSlicerPath} does not exist. Please run npm install/ci inside antora-tooling first.`);
}

// 2. Patch inject-collector-cache-config-extension.js inside @springio/antora-extensions
const extensionPath = path.join(
  antoraToolingDir,
  'node_modules/@springio/antora-extensions/lib/inject-collector-cache-config-extension.js'
);
if (fs.existsSync(extensionPath)) {
  console.log(`Patching ${extensionPath}...`);
  let content = fs.readFileSync(extensionPath, 'utf8');

  const target = `            const normalizedCollectorConfig = Array.isArray(collectorConfig) ? collectorConfig : [collectorConfig]
            origin.descriptor.ext.collector = normalizedCollectorConfig
            normalizedCollectorConfig.forEach((collector) => {
              const { scan: scanConfig = [] } = collector
              // cache the output of the build
              const scanDir = expandPath(scanConfig.dir, expandPathContext)
              logger.info(
                \`Configuring collector to cache '\${scanDir}' at '\${cacheDir}' and zip the results at '\${zipCacheFile}'\`
              )
              const cachedCollectorConfig = createCachedCollectorConfig(scanDir, cacheDir, zipCacheFile)
              normalizedCollectorConfig.push.apply(normalizedCollectorConfig, cachedCollectorConfig)
              // add the zip of cache to be published
            })`;

  const replacement = `            const normalizedCollectorConfig = Array.isArray(collectorConfig) ? collectorConfig : [collectorConfig]
            origin.descriptor.ext.collector = normalizedCollectorConfig
            normalizedCollectorConfig.forEach((collector) => {
              const { scan: scanConfig = [] } = collector
              const scans = Array.isArray(scanConfig) ? scanConfig : [scanConfig]
              scans.forEach((scan) => {
                if (scan && scan.dir) {
                  const scanDir = expandPath(scan.dir, expandPathContext)
                  logger.info(
                    \`Configuring collector to cache '\${scanDir}' at '\${cacheDir}' and zip the results at '\${zipCacheFile}'\`
                  )
                  const cachedCollectorConfig = createCachedCollectorConfig(scanDir, cacheDir, zipCacheFile)
                  normalizedCollectorConfig.push.apply(normalizedCollectorConfig, cachedCollectorConfig)
                }
              })
            })`;

  if (content.includes(target)) {
    content = content.replace(target, replacement);
    fs.writeFileSync(extensionPath, content, 'utf8');
    console.log('Successfully patched inject-collector-cache-config-extension.js');
  } else if (content.includes(replacement)) {
    console.log('inject-collector-cache-config-extension.js is already patched.');
  } else {
    console.warn('Warning: Could not find target content in inject-collector-cache-config-extension.js');
  }
} else {
  console.warn(`Warning: ${extensionPath} does not exist.`);
}

// 3. Patch cache-scandir.js inside @springio/antora-extensions
const cacheScanDirPath = path.join(
  antoraToolingDir,
  'node_modules/@springio/antora-extensions/lib/cache-scandir/cache-scandir.js'
);
if (fs.existsSync(cacheScanDirPath)) {
  console.log(`Patching ${cacheScanDirPath}...`);
  let content = fs.readFileSync(cacheScanDirPath, 'utf8');

  const target = `const copyRecursiveSync = function (src, dest) {
  const exists = fs.existsSync(src)
  const stats = exists && fs.statSync(src)
  const isDirectory = exists && stats.isDirectory()
  if (isDirectory) {
    fs.mkdirSync(dest)
    fs.readdirSync(src).forEach(function (childItemName) {
      copyRecursiveSync(path.join(src, childItemName), path.join(dest, childItemName))
    })
  } else {
    fs.copyFileSync(src, dest)
  }
}`;

  const replacement = `const copyRecursiveSync = function (src, dest) {
  const exists = fs.existsSync(src)
  const stats = exists && fs.statSync(src)
  const isDirectory = exists && stats.isDirectory()
  if (isDirectory) {
    if (!fs.existsSync(dest)) {
      fs.mkdirSync(dest)
    }
    fs.readdirSync(src).forEach(function (childItemName) {
      copyRecursiveSync(path.join(src, childItemName), path.join(dest, childItemName))
    })
  } else {
    fs.copyFileSync(src, dest)
  }
}`;

  if (content.includes(target)) {
    content = content.replace(target, replacement);
    fs.writeFileSync(cacheScanDirPath, content, 'utf8');
    console.log('Successfully patched cache-scandir.js');
  } else if (content.includes(replacement)) {
    console.log('cache-scandir.js is already patched.');
  } else {
    console.warn('Warning: Could not find target content in cache-scandir.js');
  }
} else {
  console.warn(`Warning: ${cacheScanDirPath} does not exist.`);
}
