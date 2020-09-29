// engine.js
// You have to run `npm i @marp-team/marp-core` at first.
const { Marp } = require('@marp-team/marp-core')

module.exports = opts => {

  opts.markdown = { ...opts.markdown }
  opts.markdown.breaks = false
  opts.markdown.html = true
  opts.html = true

  // console.log(opts)

  const marp = new Marp(opts)

  // Disable parsing fragmented list
  marp.markdown.core.ruler.disable('marpit_fragment')

  return marp
}
