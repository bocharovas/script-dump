module.exports = {
  types: [
    { value: 'test',     name: 'test:     Adding missing tests 💍' },
    { value: 'feat',     name: 'feat:     A new feature 🎸' },
    { value: 'fix',      name: 'fix:      A bug fix 🐛' },
    { value: 'chore',    name: 'chore:    Build process or auxiliary tool changes 🤖' },
    { value: 'docs',     name: 'docs:     Documentation only changes ✏️' },
    { value: 'refactor', name: 'refactor: Code change that neither fixes a bug nor adds a feature 💡' },
    { value: 'style',    name: 'style:    Code style change 💄' },
    { value: 'ci',       name: 'ci:       CI related changes 🎡' },
    { value: 'perf',     name: 'perf:     Performance improvements ⚡️' },
    { value: 'release',  name: 'release:  Create a release commit 🏹' }
  ],

  scopes: ['src', 'git-status', 'sys', 'autostart', 'root', 'pic', 'commitizen'],

  allowCustomScopes: true,

  messages: {
    type: 'Select the type of change that you\'re committing:',
    scope: 'Select the scope this component affects (optional):',
    customScope: 'Or enter a custom scope:',
    subject: 'Write a short, imperative description:\n',
    body: 'Provide a longer description (optional):\n',
    breaking: 'List any breaking changes:\n',
    footer: 'Issues this commit closes, e.g. #123:\n',
    confirmCommit: 'Confirm the commit above?'
  },

  allowBreakingChanges: ['feat', 'fix'],

  skipQuestions: [],

  subjectLimit: 64
};

