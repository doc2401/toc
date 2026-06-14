const fs = require('fs');
const path = require('path');

const sourcesDir = path.join(__dirname, 'sources');

console.log('--- Patching Playbooks to include spring-data-commons 4.1.0 Tag ---');

function walk(dir) {
  let results = [];
  const list = fs.readdirSync(dir);
  list.forEach((file) => {
    const filePath = path.join(dir, file);
    const stat = fs.statSync(filePath);
    if (stat && stat.isDirectory()) {
      results = results.concat(walk(filePath));
    } else {
      if (file === 'antora-playbook.yml') {
        results.push(filePath);
      }
    }
  });
  return results;
}

if (!fs.existsSync(sourcesDir)) {
  console.error(`Error: sources directory does not exist at ${sourcesDir}`);
  process.exit(1);
}

const playbooks = walk(sourcesDir);

playbooks.forEach((playbookPath) => {
  let content = fs.readFileSync(playbookPath, 'utf8');
  
  // We want to find the section for spring-data-commons:
  // - url: https://github.com/spring-projects/spring-data-commons
  //   branches: [...]
  // and insert "      tags: [ 4.1.0 ]"
  
  const commonsRegex = /(url:\s*https:\/\/github\.com\/spring-projects\/spring-data-commons\s*\r?\n\s*(?:#.*\r?\n\s*)*branches:\s*\[[^\]]*\])/g;
  
  if (commonsRegex.test(content)) {
    // Reset regex lastIndex
    commonsRegex.lastIndex = 0;
    
    // Check if tags [ 4.1.0 ] is already present
    if (!content.includes('4.1.0') || !content.includes('tags:')) {
      content = content.replace(commonsRegex, (match) => {
        // Find line ending of branches line and append the tags line
        const lines = match.split(/\r?\n/);
        // Determine line break style
        const lineBreak = match.includes('\r\n') ? '\r\n' : '\n';
        // Get the indent of the branches line
        const lastLine = lines[lines.length - 1];
        const indentMatch = lastLine.match(/^(\s*)/);
        const indent = indentMatch ? indentMatch[1] : '      ';
        
        return match + lineBreak + indent + 'tags: [ 4.1.0 ]';
      });
      
      fs.writeFileSync(playbookPath, content, 'utf8');
      console.log(`Patched playbook: ${playbookPath}`);
    } else {
      console.log(`Playbook already patched or contains 4.1.0 tag: ${playbookPath}`);
    }
  } else {
    console.log(`No spring-data-commons source found in playbook: ${playbookPath}`);
  }
});
