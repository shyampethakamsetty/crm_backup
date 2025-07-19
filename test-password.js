const bcrypt = require('bcryptjs');

async function testPassword() {
  const password = 'demo123';
  const salt = await bcrypt.genSalt(12);
  const hash = await bcrypt.hash(password, salt);
  
  console.log('Password:', password);
  console.log('Salt:', salt);
  console.log('Hash:', hash);
  
  // Test the hash
  const isMatch = await bcrypt.compare(password, hash);
  console.log('Password match:', isMatch);
  
  // Test with the hash from database
  const dbHash = '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KqHhK.';
  const dbMatch = await bcrypt.compare(password, dbHash);
  console.log('Database hash match:', dbMatch);
}

testPassword().catch(console.error); 