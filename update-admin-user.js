db = db.getSiblingDB('rakshak-expense');
db.users.updateOne(
  { email: 'admin@rakshak.com' },
  { $set: { role: 'l3_approver', site: ObjectId('687b3b7c2b211a6e5232a03d') } }
); 