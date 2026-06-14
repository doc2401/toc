const fs = require('fs')
const path = require('path')

const sourcesDir = path.join(__dirname, 'sources')
const commonsDir = path.join(sourcesDir, 'spring-data-commons')
const toolingDir = path.join(__dirname, 'antora-tooling')
const beforeDir = path.join(toolingDir, 'playbooks-before')
const afterDir = path.join(toolingDir, 'playbooks-after')
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
  const projectName = path.relative(sourcesDir, playbookPath).split(path.sep)[0]
  const actualProjectDir = path.join(sourcesDir, projectName)
  const beforeSnapshot = path.join(beforeDir, projectName, 'antora-playbook.yml')
  const afterSnapshot = path.join(afterDir, projectName, 'antora-playbook.yml')

  fs.mkdirSync(path.dirname(beforeSnapshot), { recursive: true })
  fs.mkdirSync(path.dirname(afterSnapshot), { recursive: true })
  fs.writeFileSync(beforeSnapshot, original, 'utf8')

  let relativeCommonsPath = path.relative(actualProjectDir, commonsDir).replaceAll('\\', '/')

  if (!relativeCommonsPath.startsWith('.')) {
    relativeCommonsPath = `./${relativeCommonsPath}`
  }

  const commonsSourcePattern =
    /    - url: (?:https:\/\/github\.com\/spring-projects\/spring-data-commons|[^\r\n]*spring-data-commons)\r?\n[\s\S]*?(?=\r?\n(?:    - url:|asciidoc:))/

  if (!commonsSourcePattern.test(original)) {
    fs.writeFileSync(afterSnapshot, original, 'utf8')
    console.log(`No Spring Data Commons content source found: ${playbookPath}`)
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
  fs.writeFileSync(afterSnapshot, patched, 'utf8')
  console.log(`Patched playbook: ${playbookPath}`)
  console.log(`  Before: ${beforeSnapshot}`)
  console.log(`  After:  ${afterSnapshot}`)
  }
}
