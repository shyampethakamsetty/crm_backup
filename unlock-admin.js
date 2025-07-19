// Script to unlock admin account
const mongoose = require('mongoose');

// Connect to MongoDB
mongoose.connect('mongodb://admin:password123@localhost:27017/rakshak-expense?authSource=admin', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

// Import User model
const User = require('./backend/models/User');

async function unlockAdmin() {
  try {
    // Find and unlock admin user
    const result = await User.updateOne(
      { email: 'admin@rakshak.com' },
      { 
        $set: { 
          isLocked: false, 
          loginAttempts: 0, 
          lockUntil: null 
        } 
      }
    );

    if (result.modifiedCount > 0) {
      console.log('✅ Admin account unlocked successfully!');
      console.log('You can now login with: admin@rakshak.com / admin123');
    } else {
      console.log('❌ Admin account not found or already unlocked');
    }

    // Close connection
    await mongoose.connection.close();
    console.log('Database connection closed');
    
  } catch (error) {
    console.error('Error unlocking admin account:', error);
    process.exit(1);
  }
}

unlockAdmin(); 