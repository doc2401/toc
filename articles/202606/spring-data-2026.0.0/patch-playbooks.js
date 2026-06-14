const fs = require('fs')
const path = require('path')

const sourcesDir = path.join(__dirname, 'sources')
const commonsDir = path.join(sourcesDir, 'spring-data-commons')
const selectedProjects = new Set(process.argv.slice(2))

console.log('--- Pointing Antora playbooks at the local Spring Data Commons checkout ---')

if (!fs.existsSync(commonsDir)) {
  console.error(`Error: Spring Data Commons checkout does not exist at ${commonsDir}`)
  process.exit(1)
}

function findPlaybooks(dir) {
  const results = []

  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const entryPath = path.join(dir, entry.name)

    if (entry.isDirectory()) {
      results.push(...findPlaybooks(entryPath))
    } else if (entry.name === 'antora-playbook.yml') {
      results.push(entryPath)
    }
  }

  return results
}

const projectDirs =
  selectedProjects.size > 0
    ? [...selectedProjects].map((projectName) => path.join(sourcesDir, projectName))
    : [sourcesDir]

for (const projectDir of projectDirs) {
  if (!fs.existsSync(projectDir)) {
    console.error(`Error: selected project does not exist at ${projectDir}`)
    process.exitCode = 1
    continue
  }

  for (const playbookPath of findPlaybooks(projectDir)) {
  const original = fs.readFileSync(playbookPath, 'utf8')
  const lineBreak = original.includes('\r\n') ? '\r\n' : '\n'
  const playbookDir = path.dirname(playbookPath)
  let relativeCommonsPath = path.relative(playbookDir, commonsDir).replaceAll('\\', '/')

  if (!relativeCommonsPath.startsWith('.')) {
    relativeCommonsPath = `./${relativeCommonsPath}`
  }

  const commonsSourcePattern =
    /    - url: https:\/\/github\.com\/spring-projects\/spring-data-commons\r?\n[\s\S]*?(?=\r?\n(?:    - url:|asciidoc:))/

  if (!commonsSourcePattern.test(original)) {
    console.log(`No remote Spring Data Commons source found: ${playbookPath}`)
    continue
  }

  const localCommonsSource = [
    `    - url: ${relativeCommonsPath}`,
    '      branches: HEAD',
    '      start_path: src/main/antora',
    '      worktrees: true',
  ].join(lineBreak)

  const patched = original.replace(commonsSourcePattern, localCommonsSource)
  fs.writeFileSync(playbookPath, patched, 'utf8')
  console.log(`Patched playbook: ${playbookPath}`)
  }
}
