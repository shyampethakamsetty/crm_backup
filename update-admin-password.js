db = db.getSiblingDB('rakshak-expense');
db.users.updateOne(
  { email: 'admin@rakshak.com' },
  { $set: { password: '$2a$12$FF7Piw9IBL9a.3wcINwAJ.uWV5jP.nnoJRzUWFlRXQ3CiP8X4ggZW' } }
); 