// MongoDB initialization script
// This script runs when the MongoDB container starts for the first time

// Switch to the rakshak-expense database
db = db.getSiblingDB('rakshak-expense');

// Create collections with validation
db.createCollection('users', {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["email", "name", "role"],
      properties: {
        email: {
          bsonType: "string",
          pattern: "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
        },
        name: {
          bsonType: "string",
          minLength: 2
        },
        role: {
          enum: ["submitter", "l1_approver", "l2_approver", "l3_approver", "admin"]
        }
      }
    }
  }
});

db.createCollection('sites', {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["name", "location"],
      properties: {
        name: {
          bsonType: "string",
          minLength: 2
        },
        location: {
          bsonType: "string"
        },
        budget: {
          bsonType: "number",
          minimum: 0
        }
      }
    }
  }
});

db.createCollection('expenses', {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["amount", "description", "submitter", "site"],
      properties: {
        amount: {
          bsonType: "number",
          minimum: 0
        },
        description: {
          bsonType: "string",
          minLength: 5
        },
        status: {
          enum: ["pending", "approved", "rejected"]
        }
      }
    }
  }
});

// Create indexes for better performance
db.users.createIndex({ "email": 1 }, { unique: true });
db.users.createIndex({ "role": 1 });
db.sites.createIndex({ "name": 1 }, { unique: true });
db.expenses.createIndex({ "submitter": 1 });
db.expenses.createIndex({ "site": 1 });
db.expenses.createIndex({ "status": 1 });
db.expenses.createIndex({ "createdAt": -1 });

// Insert default admin user (password: admin123)
db.users.insertOne({
  name: "System Administrator",
  email: "admin@rakshak.com",
  password: "$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/HS.iK2e", // admin123
  role: "admin",
  isActive: true,
  createdAt: new Date(),
  updatedAt: new Date()
});

// Insert default site
db.sites.insertOne({
  name: "Head Office",
  location: "Mumbai, Maharashtra",
  budget: 1000000,
  isActive: true,
  createdAt: new Date(),
  updatedAt: new Date()
});

print("MongoDB initialization completed successfully!");
print("Default admin user created: admin@rakshak.com / admin123");
print("Default site created: Head Office"); 