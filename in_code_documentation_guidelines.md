# In-Code Documentation Guidelines

When contributing to the Pelias codebase, please support our effort to keep
uniform documentation across the board.
We recognize that it might not currently be the case in existing repos,
but it is a goal to have all existing and future code follow these guidelines.

### high level

Let's aim to write in-code documentation to help `"future you"` understand what
`"now you"` was thinking when you wrote the code.

### details

Use [JSDoc](http://usejsdoc.org/howto-commonjs-modules.html) syntax.
You can be as generous with your doc-blocks as you'd like.
We ask at a minimum that you decorate the public function of a module with a doc-block.

#### module.exports
```javascript
/**
 * Do something important
 *
 * @param {string} param1
 * @param {object} param2
 * @return {boolean}
 */
module.exports = function doIt(param1, param2) {
  return true;
}
```
 
#### classes and class functions
```javascript
/**
 * Important class that does important things
 *
 * @class
 */
function MyImportantClass(param1) {
}

/**
 * Do something important
 *
 * @param {string} param1
 * @param {object} param2
 * @return {number}
 */
MyImportantClass.prototype.doIt = function doIt(param1, param2) {
  return 123;
}
```

#### internal / private functions

These can be left without doc-blocks if you feel their functionality is 
self explanatory and/or easy enough for future-you to understand without scratching your head.

#### tests

Tests ARE documentation, so doc-blocks are not necessary there, unless you feel future-you will
have trouble following.
