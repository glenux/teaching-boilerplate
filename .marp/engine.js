// engine.js
// You have to run `npm i @marp-team/marp-core` at first.
const { Marp } = require('@marp-team/marp-core')

module.exports = opts => {
  const marp = new Marp(opts)

  // Disable parsing fragmented list
  marp.markdown.core.ruler.disable('marpit_fragment')

  return marp
}
