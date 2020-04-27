function readBuffer (memory, ptr) {
  var len = memory.readUInt32LE(ptr)
  return memory.slice(4+ptr, 4+ptr+len)
}
var assert = require('assert')
var N = 100000
var x = require('acidlisp/require')(__dirname)('../')
function assertInt(r) {
  r = r | 0
  var p = x.encode(r)
  console.log(r, readBuffer(x.memory, p).toString())
  assert.equal(readBuffer(x.memory, p).toString(), r.toString())
  var length = x.memory.readUInt32LE(p)
  assert.equal(length, r.toString().length, 'length is correct')
  assert.equal(x.decode(p, 0, length), r)
}

for (var i = 0; i < 100; i++) assertInt(i)

for (var i = 0; i < 1000; i++) assertInt(~~(Math.random()*N*2) - N)
assertInt(0)
assertInt(0xffffffff)
